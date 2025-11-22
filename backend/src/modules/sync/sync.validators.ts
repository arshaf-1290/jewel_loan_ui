import { body, query } from 'express-validator';

export const syncOutboxValidator = [
  query('since').optional().isISO8601().toDate(),
];

export const syncInboxValidator = [
  body('changes').isArray({ min: 1 }),
  body('changes.*.entity').isString().trim().isLength({ min: 2, max: 120 }),
  body('changes.*.action').isIn(['CREATE', 'UPDATE', 'DELETE']),
];

