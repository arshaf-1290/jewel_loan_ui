import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as receiptService from './loanReceipt.service.js';

export const listReceipts = asyncHandler(async (_req: Request, res: Response) => {
  const receipts = await receiptService.listReceipts();
  res.json(receipts);
});

export const getReceipt = asyncHandler(async (req: Request, res: Response) => {
  const receipt = await receiptService.getReceiptById(Number(req.params.id));
  res.json(receipt);
});

export const createReceipt = asyncHandler(async (req: Request, res: Response) => {
  const receipt = await receiptService.createReceipt(req.body);
  res.status(201).json(receipt);
});

