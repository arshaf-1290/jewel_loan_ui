import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as syncService from './sync.service.js';

export const fetchOutbox = asyncHandler(async (req: Request, res: Response) => {
  const since = typeof req.query.since === 'string' ? req.query.since : undefined;
  const rows = await syncService.fetchOutbox(since);
  res.json(rows);
});

export const pushInbox = asyncHandler(async (req: Request, res: Response) => {
  await syncService.queueChanges(req.body);
  res.status(202).json({ message: 'Changes queued for processing' });
});

