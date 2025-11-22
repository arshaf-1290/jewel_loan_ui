import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';
import type { LedgerEntry, LedgerFilter } from './ledger.types.js';

const mapEntry = (row: RowDataPacket): LedgerEntry => ({
  id: row.id,
  entryDate: row.entry_date,
  ledgerHead: row.ledger_head,
  referenceType: row.reference_type,
  referenceId: row.reference_id,
  particulars: row.particulars,
  debit: Number(row.debit),
  credit: Number(row.credit),
  balance: Number(row.running_balance ?? 0),
  createdAt: row.created_at,
});

export const listEntries = async (filters: LedgerFilter): Promise<LedgerEntry[]> => {
  const where: string[] = [];
  const params: Record<string, unknown> = {};

  if (filters.head) {
    where.push('ledger_head = :head');
    params.head = filters.head;
  }
  if (filters.fromDate) {
    where.push('entry_date >= :fromDate');
    params.fromDate = filters.fromDate;
  }
  if (filters.toDate) {
    where.push('entry_date <= :toDate');
    params.toDate = filters.toDate;
  }

  const sql = `
    SELECT le.*, SUM(le.debit - le.credit) OVER (PARTITION BY ledger_head ORDER BY entry_date, id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_balance
    FROM ledger_entries le
    ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
    ORDER BY le.entry_date ASC, le.id ASC
  `;

  const [rows] = await query<RowDataPacket[]>(sql, params);
  return rows.map(mapEntry);
};

export const ledgerSummary = async (filters: LedgerFilter) => {
  const where: string[] = [];
  const params: Record<string, unknown> = {};
  if (filters.head) {
    where.push('ledger_head = :head');
    params.head = filters.head;
  }
  if (filters.fromDate) {
    where.push('entry_date >= :fromDate');
    params.fromDate = filters.fromDate;
  }
  if (filters.toDate) {
    where.push('entry_date <= :toDate');
    params.toDate = filters.toDate;
  }

  const sql = `
    SELECT ledger_head,
           SUM(debit) AS total_debit,
           SUM(credit) AS total_credit,
           SUM(debit - credit) AS balance
    FROM ledger_entries
    ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
    GROUP BY ledger_head
    ORDER BY ledger_head
  `;

  const [rows] = await query<RowDataPacket[]>(sql, params);
  return rows.map((row) => ({
    ledgerHead: row.ledger_head,
    totalDebit: Number(row.total_debit ?? 0),
    totalCredit: Number(row.total_credit ?? 0),
    balance: Number(row.balance ?? 0),
  }));
};

