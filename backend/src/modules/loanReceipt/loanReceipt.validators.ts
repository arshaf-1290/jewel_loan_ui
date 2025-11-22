import { body, param } from 'express-validator';

export const createLoanReceiptValidator = [
  body('loanId').isInt({ gt: 0 }).toInt(),
  body('receiptNo').isString().trim().isLength({ min: 2, max: 60 }),
  body('receiptDate').isISO8601().toDate(),
  body('amountReceived').isFloat({ gt: 0 }).toFloat(),
  body('paymentMode').isString().trim().isLength({ min: 2, max: 60 }),
  body('referenceNo').optional().isString().trim().isLength({ max: 120 }),
  body('notes').optional().isString().trim().isLength({ max: 255 }),
];

export const loanReceiptIdParam = [param('id').isInt({ gt: 0 }).toInt()];

