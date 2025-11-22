import { query } from 'express-validator';

export const customerReportValidator = [
  query('search').optional().isString().trim().isLength({ max: 120 }),
  query('city').optional().isString().trim().isLength({ max: 120 }),
  query('group').optional().isString().trim().isLength({ max: 120 }),
];

