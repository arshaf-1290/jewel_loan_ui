import { Request, Response } from 'express';

import { asyncHandler } from '../../utils/asyncHandler.js';
import * as reportService from './customerReport.service.js';

export const listCustomers = asyncHandler(async (req: Request, res: Response) => {
  const customers = await reportService.listCustomers({
    search: typeof req.query.search === 'string' ? req.query.search : undefined,
    city: typeof req.query.city === 'string' ? req.query.city : undefined,
    group: typeof req.query.group === 'string' ? req.query.group : undefined,
  });
  res.json(customers);
});

