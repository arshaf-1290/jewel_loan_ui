import { query } from 'express-validator';

export const rangeValidator = [
  query('from').optional().isISO8601().toDate(),
  query('to').optional().isISO8601().toDate(),
];

