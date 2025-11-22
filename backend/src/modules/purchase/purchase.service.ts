import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query, withTransaction } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreatePurchasePayload, Purchase, PurchaseItem } from './purchase.types.js';

const mapPurchase = (row: RowDataPacket): Purchase => ({
  id: row.id,
  purchaseDate: row.purchase_date,
  supplierId: row.supplier_id,
  supplierName: row.supplier_name ?? row.supplier_name_fallback,
  invoiceNo: row.invoice_no,
  grossWeight: Number(row.gross_weight ?? 0),
  netWeight: Number(row.net_weight ?? 0),
  totalAmount: Number(row.total_amount ?? 0),
  status: row.status,
  notes: row.notes,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const mapItem = (row: RowDataPacket): PurchaseItem => ({
  id: row.id,
  purchaseId: row.purchase_id,
  description: row.description,
  grossWeight: Number(row.gross_weight),
  netWeight: Number(row.net_weight),
  ratePerGram: Number(row.rate_per_gram),
  makingCharge: Number(row.making_charge),
  amount: Number(row.amount),
});

export const listPurchases = async (): Promise<Purchase[]> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT p.*, s.name AS supplier_name
     FROM purchases p
     LEFT JOIN suppliers s ON s.id = p.supplier_id
     ORDER BY p.purchase_date DESC`
  );
  return rows.map(mapPurchase);
};

export const getPurchaseById = async (id: number): Promise<Purchase> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT p.*, s.name AS supplier_name
     FROM purchases p
     LEFT JOIN suppliers s ON s.id = p.supplier_id
     WHERE p.id = :id`,
    { id }
  );

  if (!rows.length) {
    throw new HttpException(404, 'Purchase not found');
  }

  const purchase = mapPurchase(rows[0]);
  const [itemRows] = await query<RowDataPacket[]>(
    'SELECT * FROM purchase_items WHERE purchase_id = :id',
    { id }
  );
  purchase.items = itemRows.map(mapItem);
  return purchase;
};

export const createPurchase = async (payload: CreatePurchasePayload): Promise<Purchase> => {
  return withTransaction(async (connection) => {
    const gross = payload.items.reduce((acc, item) => acc + item.grossWeight, 0);
    const net = payload.items.reduce((acc, item) => acc + item.netWeight, 0);
    const total = payload.items.reduce((acc, item) => acc + item.amount, 0);

    const [result] = await connection.execute<ResultSetHeader>(
      `INSERT INTO purchases
        (purchase_date, supplier_id, invoice_no, status, gross_weight, net_weight, total_amount, notes)
        VALUES (:purchaseDate, :supplierId, :invoiceNo, :status, :grossWeight, :netWeight, :totalAmount, :notes)`,
      {
        purchaseDate: payload.purchaseDate,
        supplierId: payload.supplierId,
        invoiceNo: payload.invoiceNo,
        status: payload.status,
        grossWeight: gross,
        netWeight: net,
        totalAmount: total,
        notes: payload.notes ?? null,
      }
    );

    const purchaseId = result.insertId;
    const itemSql = `INSERT INTO purchase_items
      (purchase_id, description, gross_weight, net_weight, rate_per_gram, making_charge, amount)
      VALUES (:purchaseId, :description, :grossWeight, :netWeight, :ratePerGram, :makingCharge, :amount)`;

    for (const item of payload.items) {
      await connection.execute(itemSql, {
        purchaseId,
        description: item.description,
        grossWeight: item.grossWeight,
        netWeight: item.netWeight,
        ratePerGram: item.ratePerGram,
        makingCharge: item.makingCharge,
        amount: item.amount,
      });
    }

    const [rows] = await connection.execute<RowDataPacket[]>(
      `SELECT p.*, s.name AS supplier_name
       FROM purchases p
       LEFT JOIN suppliers s ON s.id = p.supplier_id
       WHERE p.id = :id`,
      { id: purchaseId }
    );

    const purchase = mapPurchase(rows[0]);
    purchase.items = payload.items.map((item, index) => ({
      id: index + 1,
      purchaseId,
      description: item.description,
      grossWeight: item.grossWeight,
      netWeight: item.netWeight,
      ratePerGram: item.ratePerGram,
      makingCharge: item.makingCharge,
      amount: item.amount,
    }));

    return purchase;
  });
};

