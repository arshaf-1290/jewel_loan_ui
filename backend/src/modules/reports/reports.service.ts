import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';

export const salesSummary = async (from?: string, to?: string) => {
  const params: Record<string, unknown> = {};
  const where: string[] = [];
  if (from) {
    where.push('sale_date >= :from');
    params.from = from;
  }
  if (to) {
    where.push('sale_date <= :to');
    params.to = to;
  }

  const [rows] = await query<RowDataPacket[]>(
    `SELECT COUNT(*) AS bills, COALESCE(SUM(total_amount), 0) AS amount, COALESCE(SUM(total_grams), 0) AS grams
     FROM sales ${where.length ? `WHERE ${where.join(' AND ')}` : ''}`,
    params
  );
  return {
    bills: Number(rows[0]?.bills ?? 0),
    amount: Number(rows[0]?.amount ?? 0),
    grams: Number(rows[0]?.grams ?? 0),
  };
};

export const purchaseSummary = async (from?: string, to?: string) => {
  const params: Record<string, unknown> = {};
  const where: string[] = [];
  if (from) {
    where.push('purchase_date >= :from');
    params.from = from;
  }
  if (to) {
    where.push('purchase_date <= :to');
    params.to = to;
  }

  const [rows] = await query<RowDataPacket[]>(
    `SELECT COUNT(*) AS invoices, COALESCE(SUM(total_amount), 0) AS amount, COALESCE(SUM(gross_weight), 0) AS grossWeight
     FROM purchases ${where.length ? `WHERE ${where.join(' AND ')}` : ''}`,
    params
  );
  return {
    invoices: Number(rows[0]?.invoices ?? 0),
    amount: Number(rows[0]?.amount ?? 0),
    grossWeight: Number(rows[0]?.grossWeight ?? 0),
  };
};

export const stockSnapshot = async () => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT COALESCE(SUM(quantity), 0) AS items,
            COALESCE(SUM(cost_price * quantity), 0) AS inventoryValue,
            COALESCE(SUM(net_weight * quantity), 0) AS netWeight
     FROM stock_items`
  );
  return {
    items: Number(rows[0]?.items ?? 0),
    inventoryValue: Number(rows[0]?.inventoryValue ?? 0),
    netWeight: Number(rows[0]?.netWeight ?? 0),
  };
};

export const customerAging = async () => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT customer_id, c.name AS customer_name, COALESCE(SUM(balance_amount), 0) AS balance
     FROM customer_balances cb
     LEFT JOIN customers c ON c.id = cb.customer_id
     GROUP BY customer_id, customer_name
     ORDER BY balance DESC
     LIMIT 10`
  );
  return rows.map((row) => ({
    customerId: row.customer_id,
    customerName: row.customer_name,
    balance: Number(row.balance ?? 0),
  }));
};

