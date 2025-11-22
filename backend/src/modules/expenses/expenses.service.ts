import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreateExpensePayload, ExpenseEntry } from './expenses.types.js';

const mapExpense = (row: RowDataPacket): ExpenseEntry => ({
  id: row.id,
  expenseDate: row.expense_date,
  expenseType: row.expense_type,
  amount: Number(row.amount),
  notes: row.notes,
  attachmentUrl: row.attachment_url,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

export const listExpenses = async (): Promise<ExpenseEntry[]> => {
  const [rows] = await query<RowDataPacket[]>(
    'SELECT * FROM expenses ORDER BY expense_date DESC, id DESC'
  );
  return rows.map(mapExpense);
};

export const getExpenseById = async (id: number): Promise<ExpenseEntry> => {
  const [rows] = await query<RowDataPacket[]>(
    'SELECT * FROM expenses WHERE id = :id',
    { id }
  );
  if (!rows.length) {
    throw new HttpException(404, 'Expense entry not found');
  }
  return mapExpense(rows[0]);
};

export const createExpense = async (payload: CreateExpensePayload): Promise<ExpenseEntry> => {
  const [result] = await query<ResultSetHeader>(
    `INSERT INTO expenses (expense_date, expense_type, amount, notes, attachment_url)
     VALUES (:expenseDate, :expenseType, :amount, :notes, :attachmentUrl)`,
    {
      expenseDate: payload.expenseDate,
      expenseType: payload.expenseType,
      amount: payload.amount,
      notes: payload.notes ?? null,
      attachmentUrl: payload.attachmentUrl ?? null,
    }
  );
  return getExpenseById(result.insertId);
};

export const deleteExpense = async (id: number) => {
  const [result] = await query<ResultSetHeader>('DELETE FROM expenses WHERE id = :id', { id });
  if (!result.affectedRows) {
    throw new HttpException(404, 'Expense entry not found');
  }
};

