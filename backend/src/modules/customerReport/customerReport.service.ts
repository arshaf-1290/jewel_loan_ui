import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';

export interface CustomerFilter {
  search?: string;
  city?: string;
  group?: string;
}

export const listCustomers = async (filters: CustomerFilter) => {
  const params: Record<string, unknown> = {};
  const where: string[] = [];

  if (filters.search) {
    where.push('(c.name LIKE :search OR c.phone LIKE :search OR c.code LIKE :search)');
    params.search = `%${filters.search}%`;
  }
  if (filters.city) {
    where.push('c.city = :city');
    params.city = filters.city;
  }
  if (filters.group) {
    where.push('c.customer_group = :group');
    params.group = filters.group;
  }

  const sql = `
    SELECT c.*, COALESCE(cb.balance_amount, 0) AS outstanding,
           (SELECT MAX(s.sale_date) FROM sales s WHERE s.customer_id = c.id) AS last_sale_date
    FROM customers c
    LEFT JOIN customer_balances cb ON cb.customer_id = c.id
    ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
    ORDER BY c.name
    LIMIT 200
  `;

  const [rows] = await query<RowDataPacket[]>(sql, params);
  return rows.map((row) => ({
    id: row.id,
    code: row.code,
    name: row.name,
    phone: row.phone,
    email: row.email,
    city: row.city,
    customerGroup: row.customer_group,
    totalPurchase: Number(row.total_purchase ?? 0),
    outstanding: Number(row.outstanding ?? 0),
    lastSaleDate: row.last_sale_date,
  }));
};

