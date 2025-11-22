import { body, param } from 'express-validator';

export const createSaleValidator = [
  body('saleDate').isISO8601().toDate(),
  body('customerId').optional().isInt({ gt: 0 }).toInt(),
  body('billNo').isString().trim().isLength({ min: 2, max: 60 }),
  body('ratePerGram').isFloat({ gt: 0 }).toFloat(),
  body('makingCharge').isFloat({ min: 0 }).toFloat(),
  body('discount').isFloat({ min: 0 }).toFloat(),
  body('notes').optional().isString().trim().isLength({ max: 255 }),
  body('items').isArray({ min: 1 }),
  body('items.*.description').isString().trim().isLength({ min: 2, max: 120 }),
  body('items.*.grams').isFloat({ gt: 0 }).toFloat(),
  body('items.*.ratePerGram').isFloat({ gt: 0 }).toFloat(),
  body('items.*.makingCharge').isFloat({ min: 0 }).toFloat(),
  body('items.*.amount').isFloat({ gt: 0 }).toFloat(),
];

export const saleIdParam = [param('id').isInt({ gt: 0 }).toInt()];

