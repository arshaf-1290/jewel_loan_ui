import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query, withTransaction } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreateSalePayload, Sale, SaleItem } from './sale.types.js';

const mapSale = (row: RowDataPacket): Sale => ({
  id: row.id,
  saleDate: row.sale_date,
  customerId: row.customer_id,
  customerName: row.customer_name,
  billNo: row.bill_no,
  totalAmount: Number(row.total_amount),
  totalGrams: Number(row.total_grams),
  ratePerGram: Number(row.rate_per_gram),
  makingCharge: Number(row.making_charge),
  discount: Number(row.discount_amount ?? 0),
  notes: row.notes,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const mapItem = (row: RowDataPacket): SaleItem => ({
  id: row.id,
  saleId: row.sale_id,
  description: row.description,
  grams: Number(row.grams),
  ratePerGram: Number(row.rate_per_gram),
  makingCharge: Number(row.making_charge),
  amount: Number(row.amount),
});

export const listSales = async (): Promise<Sale[]> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT s.*, c.name AS customer_name
     FROM sales s
     LEFT JOIN customers c ON c.id = s.customer_id
     ORDER BY s.sale_date DESC`
  );
  return rows.map(mapSale);
};

export const getSaleById = async (id: number): Promise<Sale> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT s.*, c.name AS customer_name
     FROM sales s
     LEFT JOIN customers c ON c.id = s.customer_id
     WHERE s.id = :id`,
    { id }
  );

  if (!rows.length) {
    throw new HttpException(404, 'Sale not found');
  }

  const sale = mapSale(rows[0]);
  const [itemRows] = await query<RowDataPacket[]>(
    'SELECT * FROM sale_items WHERE sale_id = :id',
    { id }
  );
  sale.items = itemRows.map(mapItem);
  return sale;
};

export const createSale = async (payload: CreateSalePayload): Promise<Sale> => {
  return withTransaction(async (connection) => {
    const grams = payload.items.reduce((acc, item) => acc + item.grams, 0);
    const total = payload.items.reduce((acc, item) => acc + item.amount, 0) - payload.discount;

    const [result] = await connection.execute<ResultSetHeader>(
      `INSERT INTO sales
        (sale_date, customer_id, bill_no, total_amount, total_grams, rate_per_gram, making_charge, discount_amount, notes)
        VALUES (:saleDate, :customerId, :billNo, :totalAmount, :totalGrams, :ratePerGram, :makingCharge, :discount, :notes)`,
      {
        saleDate: payload.saleDate,
        customerId: payload.customerId ?? null,
        billNo: payload.billNo,
        totalAmount: total,
        totalGrams: grams,
        ratePerGram: payload.ratePerGram,
        makingCharge: payload.makingCharge,
        discount: payload.discount,
        notes: payload.notes ?? null,
      }
    );

    const saleId = result.insertId;
    const sql = `INSERT INTO sale_items
      (sale_id, description, grams, rate_per_gram, making_charge, amount)
      VALUES (:saleId, :description, :grams, :ratePerGram, :makingCharge, :amount)`;

    for (const item of payload.items) {
      await connection.execute(sql, {
        saleId,
        description: item.description,
        grams: item.grams,
        ratePerGram: item.ratePerGram,
        makingCharge: item.makingCharge,
        amount: item.amount,
      });
    }

    const [rows] = await connection.execute<RowDataPacket[]>(
      `SELECT s.*, c.name AS customer_name
       FROM sales s
       LEFT JOIN customers c ON c.id = s.customer_id
       WHERE s.id = :id`,
      { id: saleId }
    );

    const sale = mapSale(rows[0]);
    sale.items = payload.items.map((item, index) => ({
      id: index + 1,
      saleId,
      description: item.description,
      grams: item.grams,
      ratePerGram: item.ratePerGram,
      makingCharge: item.makingCharge,
      amount: item.amount,
    }));

    return sale;
  });
};

