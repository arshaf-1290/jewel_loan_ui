import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as expenseService from './expenses.service.js';

export const listExpenses = asyncHandler(async (_req: Request, res: Response) => {
  const expenses = await expenseService.listExpenses();
  res.json(expenses);
});

export const getExpense = asyncHandler(async (req: Request, res: Response) => {
  const expense = await expenseService.getExpenseById(Number(req.params.id));
  res.json(expense);
});

export const createExpense = asyncHandler(async (req: Request, res: Response) => {
  const expense = await expenseService.createExpense(req.body);
  res.status(201).json(expense);
});

export const deleteExpense = asyncHandler(async (req: Request, res: Response) => {
  await expenseService.deleteExpense(Number(req.params.id));
  res.status(204).send();
});

