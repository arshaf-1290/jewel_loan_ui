import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as stockService from './stock.service.js';

export const listStock = asyncHandler(async (req: Request, res: Response) => {
  const items = await stockService.listStock({
    search: typeof req.query.search === 'string' ? req.query.search : undefined,
    category: typeof req.query.category === 'string' ? req.query.category : undefined,
    metalType: typeof req.query.metalType === 'string' ? req.query.metalType : undefined,
  });
  res.json(items);
});

export const getStock = asyncHandler(async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const item = await stockService.getStockById(id);
  res.json(item);
});

export const createStock = asyncHandler(async (req: Request, res: Response) => {
  const item = await stockService.createStock(req.body);
  res.status(201).json(item);
});

export const updateStock = asyncHandler(async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const item = await stockService.updateStock({ id, ...req.body });
  res.json(item);
});

export const removeStock = asyncHandler(async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  await stockService.deleteStock(id);
  res.status(204).send();
});

