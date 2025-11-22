import { body, param } from 'express-validator';

export const createPurchaseValidator = [
  body('purchaseDate').isISO8601().toDate(),
  body('supplierId').isInt({ gt: 0 }).toInt(),
  body('invoiceNo').isString().trim().isLength({ min: 2, max: 60 }),
  body('status').isIn(['Booked', 'Delivered', 'Cancelled']),
  body('notes').optional().isString().trim().isLength({ max: 255 }),
  body('items').isArray({ min: 1 }),
  body('items.*.description').isString().trim().isLength({ min: 2, max: 120 }),
  body('items.*.grossWeight').isFloat({ gt: 0 }).toFloat(),
  body('items.*.netWeight').isFloat({ gt: 0 }).toFloat(),
  body('items.*.ratePerGram').isFloat({ gt: 0 }).toFloat(),
  body('items.*.makingCharge').isFloat({ min: 0 }).toFloat(),
  body('items.*.amount').isFloat({ gt: 0 }).toFloat(),
];

export const purchaseIdParam = [param('id').isInt({ gt: 0 }).toInt()];

