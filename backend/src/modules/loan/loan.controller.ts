import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as loanService from './loan.service.js';

export const listLoans = asyncHandler(async (_req: Request, res: Response) => {
  const loans = await loanService.listLoans();
  res.json(loans);
});

export const getLoan = asyncHandler(async (req: Request, res: Response) => {
  const loan = await loanService.getLoanById(Number(req.params.id));
  res.json(loan);
});

export const createLoan = asyncHandler(async (req: Request, res: Response) => {
  const loan = await loanService.createLoan(req.body);
  res.status(201).json(loan);
});

