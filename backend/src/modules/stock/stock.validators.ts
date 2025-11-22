import { body, param, query } from 'express-validator';

export const listStockValidator = [
  query('search').optional().isString().trim().isLength({ max: 120 }),
  query('category').optional().isString().trim().isLength({ max: 60 }),
  query('metalType').optional().isString().trim().isLength({ max: 60 }),
];

export const stockIdParam = [param('id').isInt({ gt: 0 }).toInt()];

export const createStockValidator = [
  body('itemName').isString().trim().isLength({ min: 2, max: 120 }),
  body('category').isString().trim().isLength({ min: 2, max: 60 }),
  body('metalType').isString().trim().isLength({ min: 2, max: 60 }),
  body('purity').isString().trim().isLength({ min: 1, max: 30 }),
  body('grossWeight').isFloat({ gt: 0 }).toFloat(),
  body('netWeight').isFloat({ gt: 0 }).toFloat(),
  body('stoneWeight').optional().isFloat({ min: 0 }).toFloat(),
  body('makingCharge').isFloat({ min: 0 }).toFloat(),
  body('costPrice').isFloat({ min: 0 }).toFloat(),
  body('quantity').isInt({ gt: 0 }).toInt(),
  body('sku').optional().isString().trim().isLength({ max: 60 }),
];

export const updateStockValidator = [
  ...stockIdParam,
  body().custom((body) => {
    if (!Object.keys(body).length) {
      throw new Error('Body cannot be empty');
    }
    return true;
  }),
  body('itemName').optional().isString().trim().isLength({ min: 2, max: 120 }),
  body('category').optional().isString().trim().isLength({ min: 2, max: 60 }),
  body('metalType').optional().isString().trim().isLength({ min: 2, max: 60 }),
  body('purity').optional().isString().trim().isLength({ min: 1, max: 30 }),
  body('grossWeight').optional().isFloat({ gt: 0 }).toFloat(),
  body('netWeight').optional().isFloat({ gt: 0 }).toFloat(),
  body('stoneWeight').optional().isFloat({ min: 0 }).toFloat(),
  body('makingCharge').optional().isFloat({ min: 0 }).toFloat(),
  body('costPrice').optional().isFloat({ min: 0 }).toFloat(),
  body('quantity').optional().isInt({ gt: 0 }).toInt(),
  body('sku').optional().isString().trim().isLength({ max: 60 }),
];

