import { body, param } from 'express-validator';

export const createExpenseValidator = [
  body('expenseDate').isISO8601().toDate(),
  body('expenseType').isString().trim().isLength({ min: 2, max: 120 }),
  body('amount').isFloat({ gt: 0 }).toFloat(),
  body('notes').optional().isString().trim().isLength({ max: 255 }),
  body('attachmentUrl').optional().isURL(),
];

export const expenseIdParam = [param('id').isInt({ gt: 0 }).toInt()];

