import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as purchaseService from './purchase.service.js';

export const listPurchases = asyncHandler(async (_req: Request, res: Response) => {
  const purchases = await purchaseService.listPurchases();
  res.json(purchases);
});

export const getPurchase = asyncHandler(async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const purchase = await purchaseService.getPurchaseById(id);
  res.json(purchase);
});

export const createPurchase = asyncHandler(async (req: Request, res: Response) => {
  const purchase = await purchaseService.createPurchase(req.body);
  res.status(201).json(purchase);
});

