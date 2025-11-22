import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as service from './trialBalance.service.js';

export const latestTrialBalance = asyncHandler(async (_req: Request, res: Response) => {
  const snapshot = await service.latestTrialBalance();
  res.json(snapshot);
});

