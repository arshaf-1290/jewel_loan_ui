import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreateLoanReceiptPayload, LoanReceipt } from './loanReceipt.types.js';

const mapReceipt = (row: RowDataPacket): LoanReceipt => ({
  id: row.id,
  loanId: row.loan_id,
  loanNo: row.loan_no,
  receiptNo: row.receipt_no,
  receiptDate: row.receipt_date,
  amountReceived: Number(row.amount_received),
  paymentMode: row.payment_mode,
  referenceNo: row.reference_no,
  notes: row.notes,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

export const listReceipts = async (): Promise<LoanReceipt[]> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT lr.*, l.loan_no
     FROM loan_receipts lr
     LEFT JOIN loans l ON l.id = lr.loan_id
     ORDER BY lr.receipt_date DESC`
  );
  return rows.map(mapReceipt);
};

export const getReceiptById = async (id: number): Promise<LoanReceipt> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT lr.*, l.loan_no
     FROM loan_receipts lr
     LEFT JOIN loans l ON l.id = lr.loan_id
     WHERE lr.id = :id`,
    { id }
  );
  if (!rows.length) {
    throw new HttpException(404, 'Loan receipt not found');
  }
  return mapReceipt(rows[0]);
};

export const createReceipt = async (payload: CreateLoanReceiptPayload): Promise<LoanReceipt> => {
  const [result] = await query<ResultSetHeader>(
    `INSERT INTO loan_receipts
      (loan_id, receipt_no, receipt_date, amount_received, payment_mode, reference_no, notes)
      VALUES (:loanId, :receiptNo, :receiptDate, :amountReceived, :paymentMode, :referenceNo, :notes)`,
    {
      loanId: payload.loanId,
      receiptNo: payload.receiptNo,
      receiptDate: payload.receiptDate,
      amountReceived: payload.amountReceived,
      paymentMode: payload.paymentMode,
      referenceNo: payload.referenceNo ?? null,
      notes: payload.notes ?? null,
    }
  );
  return getReceiptById(result.insertId);
};

