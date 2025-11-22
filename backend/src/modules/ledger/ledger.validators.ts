import { query } from 'express-validator';

export const ledgerFilterValidator = [
  query('head').optional().isString().trim().isLength({ max: 120 }),
  query('from').optional().isISO8601().toDate(),
  query('to').optional().isISO8601().toDate(),
];

