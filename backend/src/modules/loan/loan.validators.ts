import { body, param } from 'express-validator';

export const createLoanValidator = [
  body('loanDate').isISO8601().toDate(),
  body('customerId').isInt({ gt: 0 }).toInt(),
  body('loanNo').isString().trim().isLength({ min: 2, max: 60 }),
  body('principalAmount').isFloat({ gt: 0 }).toFloat(),
  body('ornamentDescription').isString().trim().isLength({ min: 2, max: 255 }),
  body('grossWeight').isFloat({ gt: 0 }).toFloat(),
  body('netWeight').isFloat({ gt: 0 }).toFloat(),
  body('interestRate').isFloat({ min: 0 }).toFloat(),
  body('tenureMonths').isInt({ gt: 0 }).toInt(),
  body('status').isIn(['Active', 'Closed', 'Overdue']),
  body('notes').optional().isString().trim().isLength({ max: 255 }),
  body('items').isArray({ min: 1 }),
  body('items.*.description').isString().trim().isLength({ min: 2, max: 120 }),
  body('items.*.grossWeight').isFloat({ gt: 0 }).toFloat(),
  body('items.*.netWeight').isFloat({ gt: 0 }).toFloat(),
  body('items.*.purity').isString().trim().isLength({ min: 1, max: 30 }),
  body('items.*.valuation').isFloat({ gt: 0 }).toFloat(),
];

export const loanIdParam = [param('id').isInt({ gt: 0 }).toInt()];

