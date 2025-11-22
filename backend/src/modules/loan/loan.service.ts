import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query, withTransaction } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';
import type { CreateLoanPayload, Loan, LoanItem } from './loan.types.js';

const mapLoan = (row: RowDataPacket): Loan => ({
  id: row.id,
  loanDate: row.loan_date,
  customerId: row.customer_id,
  customerName: row.customer_name,
  loanNo: row.loan_no,
  principalAmount: Number(row.principal_amount),
  ornamentDescription: row.ornament_description,
  grossWeight: Number(row.gross_weight),
  netWeight: Number(row.net_weight),
  interestRate: Number(row.interest_rate),
  tenureMonths: Number(row.tenure_months),
  status: row.status,
  notes: row.notes,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const mapItem = (row: RowDataPacket): LoanItem => ({
  id: row.id,
  loanId: row.loan_id,
  description: row.description,
  grossWeight: Number(row.gross_weight),
  netWeight: Number(row.net_weight),
  purity: row.purity,
  valuation: Number(row.valuation),
});

export const listLoans = async (): Promise<Loan[]> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT l.*, c.name AS customer_name
     FROM loans l
     LEFT JOIN customers c ON c.id = l.customer_id
     ORDER BY l.loan_date DESC`
  );
  return rows.map(mapLoan);
};

export const getLoanById = async (id: number): Promise<Loan> => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT l.*, c.name AS customer_name
     FROM loans l
     LEFT JOIN customers c ON c.id = l.customer_id
     WHERE l.id = :id`,
    { id }
  );

  if (!rows.length) {
    throw new HttpException(404, 'Loan not found');
  }

  const loan = mapLoan(rows[0]);
  const [itemRows] = await query<RowDataPacket[]>(
    'SELECT * FROM loan_items WHERE loan_id = :id',
    { id }
  );
  loan.items = itemRows.map(mapItem);
  return loan;
};

export const createLoan = async (payload: CreateLoanPayload): Promise<Loan> => {
  return withTransaction(async (connection) => {
    const [result] = await connection.execute<ResultSetHeader>(
      `INSERT INTO loans
        (loan_date, customer_id, loan_no, principal_amount, ornament_description, gross_weight, net_weight, interest_rate, tenure_months, status, notes)
        VALUES (:loanDate, :customerId, :loanNo, :principalAmount, :ornamentDescription, :grossWeight, :netWeight, :interestRate, :tenureMonths, :status, :notes)`,
      {
        loanDate: payload.loanDate,
        customerId: payload.customerId,
        loanNo: payload.loanNo,
        principalAmount: payload.principalAmount,
        ornamentDescription: payload.ornamentDescription,
        grossWeight: payload.grossWeight,
        netWeight: payload.netWeight,
        interestRate: payload.interestRate,
        tenureMonths: payload.tenureMonths,
        status: payload.status,
        notes: payload.notes ?? null,
      }
    );

    const loanId = result.insertId;
    const sql = `INSERT INTO loan_items
      (loan_id, description, gross_weight, net_weight, purity, valuation)
      VALUES (:loanId, :description, :grossWeight, :netWeight, :purity, :valuation)`;

    for (const item of payload.items) {
      await connection.execute(sql, {
        loanId,
        description: item.description,
        grossWeight: item.grossWeight,
        netWeight: item.netWeight,
        purity: item.purity,
        valuation: item.valuation,
      });
    }

    const [rows] = await connection.execute<RowDataPacket[]>(
      `SELECT l.*, c.name AS customer_name
       FROM loans l
       LEFT JOIN customers c ON c.id = l.customer_id
       WHERE l.id = :id`,
      { id: loanId }
    );

    const loan = mapLoan(rows[0]);
    loan.items = payload.items.map((item, index) => ({
      id: index + 1,
      loanId,
      description: item.description,
      grossWeight: item.grossWeight,
      netWeight: item.netWeight,
      purity: item.purity,
      valuation: item.valuation,
    }));

    return loan;
  });
};

