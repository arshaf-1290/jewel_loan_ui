import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as service from './balanceSheet.service.js';

export const latestBalanceSheet = asyncHandler(async (_req: Request, res: Response) => {
  const snapshot = await service.latestBalanceSheet();
  res.json(snapshot);
});

