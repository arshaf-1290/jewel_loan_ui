import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreateStockPayload, StockItem, UpdateStockPayload } from './stock.types.js';

interface ListFilters {
  search?: string;
  category?: string;
  metalType?: string;
}

const mapRow = (row: RowDataPacket): StockItem => ({
  id: row.id,
  sku: row.sku,
  itemName: row.item_name,
  category: row.category,
  metalType: row.metal_type,
  purity: row.purity,
  grossWeight: Number(row.gross_weight),
  netWeight: Number(row.net_weight),
  stoneWeight: row.stone_weight ? Number(row.stone_weight) : null,
  makingCharge: Number(row.making_charge),
  costPrice: Number(row.cost_price),
  quantity: Number(row.quantity),
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

export const listStock = async (filters: ListFilters): Promise<StockItem[]> => {
  const where: string[] = [];
  const params: Record<string, unknown> = {};

  if (filters.search) {
    where.push('(si.item_name LIKE :search OR si.sku LIKE :search)');
    params.search = `%${filters.search}%`;
  }
  if (filters.category) {
    where.push('si.category = :category');
    params.category = filters.category;
  }
  if (filters.metalType) {
    where.push('si.metal_type = :metalType');
    params.metalType = filters.metalType;
  }

  const sql = `
    SELECT si.*
    FROM stock_items si
    ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
    ORDER BY si.updated_at DESC
  `;

  const [rows] = await query<RowDataPacket[]>(sql, params);
  return rows.map(mapRow);
};

export const getStockById = async (id: number): Promise<StockItem> => {
  const [rows] = await query<RowDataPacket[]>(
    'SELECT * FROM stock_items WHERE id = :id LIMIT 1',
    { id }
  );
  if (!rows.length) {
    throw new HttpException(404, 'Stock item not found');
  }
  return mapRow(rows[0]);
};

export const createStock = async (payload: CreateStockPayload): Promise<StockItem> => {
  const [result] = await query<ResultSetHeader>(
    `INSERT INTO stock_items
    (sku, item_name, category, metal_type, purity, gross_weight, net_weight, stone_weight, making_charge, cost_price, quantity)
    VALUES (:sku, :itemName, :category, :metalType, :purity, :grossWeight, :netWeight, :stoneWeight, :makingCharge, :costPrice, :quantity)`,
    {
      sku: payload.sku ?? null,
      itemName: payload.itemName,
      category: payload.category,
      metalType: payload.metalType,
      purity: payload.purity,
      grossWeight: payload.grossWeight,
      netWeight: payload.netWeight,
      stoneWeight: payload.stoneWeight ?? null,
      makingCharge: payload.makingCharge,
      costPrice: payload.costPrice,
      quantity: payload.quantity,
    }
  );

  return getStockById(result.insertId);
};

export const updateStock = async (payload: UpdateStockPayload): Promise<StockItem> => {
  const fields: string[] = [];
  const params: Record<string, unknown> = { id: payload.id };

  const editable: Array<keyof CreateStockPayload> = [
    'sku',
    'itemName',
    'category',
    'metalType',
    'purity',
    'grossWeight',
    'netWeight',
    'stoneWeight',
    'makingCharge',
    'costPrice',
    'quantity',
  ];

  editable.forEach((key) => {
    if (payload[key] !== undefined) {
      const column = key
        .replace(/([A-Z])/g, '_$1')
        .toLowerCase();
      fields.push(`${column} = :${key}`);
      params[key] = payload[key] ?? null;
    }
  });

  if (!fields.length) {
    throw new HttpException(400, 'No fields provided for update');
  }

  await query('UPDATE stock_items SET ' + fields.join(', ') + ' WHERE id = :id', params);

  return getStockById(payload.id);
};

export const deleteStock = async (id: number) => {
  const [result] = await query<ResultSetHeader>('DELETE FROM stock_items WHERE id = :id', { id });
  if (!result.affectedRows) {
    throw new HttpException(404, 'Stock item not found');
  }
};

