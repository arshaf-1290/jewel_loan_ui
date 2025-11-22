import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as reportService from './reports.service.js';

const extractRange = (req: Request) => ({
  from: typeof req.query.from === 'string' ? req.query.from : undefined,
  to: typeof req.query.to === 'string' ? req.query.to : undefined,
});

export const salesSummary = asyncHandler(async (req: Request, res: Response) => {
  const { from, to } = extractRange(req);
  const summary = await reportService.salesSummary(from, to);
  res.json(summary);
});

export const purchaseSummary = asyncHandler(async (req: Request, res: Response) => {
  const { from, to } = extractRange(req);
  const summary = await reportService.purchaseSummary(from, to);
  res.json(summary);
});

export const stockSnapshot = asyncHandler(async (_req: Request, res: Response) => {
  const snapshot = await reportService.stockSnapshot();
  res.json(snapshot);
});

export const customerAging = asyncHandler(async (_req: Request, res: Response) => {
  const rows = await reportService.customerAging();
  res.json(rows);
});

