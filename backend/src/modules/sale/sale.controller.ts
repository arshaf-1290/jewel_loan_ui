import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as saleService from './sale.service.js';

export const listSales = asyncHandler(async (_req: Request, res: Response) => {
  const sales = await saleService.listSales();
  res.json(sales);
});

export const getSale = asyncHandler(async (req: Request, res: Response) => {
  const sale = await saleService.getSaleById(Number(req.params.id));
  res.json(sale);
});

export const createSale = asyncHandler(async (req: Request, res: Response) => {
  const sale = await saleService.createSale(req.body);
  res.status(201).json(sale);
});

