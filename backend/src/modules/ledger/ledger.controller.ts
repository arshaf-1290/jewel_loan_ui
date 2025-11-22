import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as ledgerService from './ledger.service.js';

const extractFilters = (req: Request) => ({
  head: typeof req.query.head === 'string' ? req.query.head : undefined,
  fromDate: typeof req.query.from === 'string' ? req.query.from : undefined,
  toDate: typeof req.query.to === 'string' ? req.query.to : undefined,
});

export const listEntries = asyncHandler(async (req: Request, res: Response) => {
  const entries = await ledgerService.listEntries(extractFilters(req));
  res.json(entries);
});

export const summary = asyncHandler(async (req: Request, res: Response) => {
  const summary = await ledgerService.ledgerSummary(extractFilters(req));
  res.json(summary);
});

