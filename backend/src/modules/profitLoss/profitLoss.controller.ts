import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as service from './profitLoss.service.js';

export const latestProfitLoss = asyncHandler(async (_req: Request, res: Response) => {
  const snapshot = await service.latestProfitLoss();
  res.json(snapshot);
});

