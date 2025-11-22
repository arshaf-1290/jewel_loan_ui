import { NextFunction, Request, Response } from 'express';

import { HttpException } from '../utils/httpException.js';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export const errorHandler = (err: unknown, _req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof HttpException) {
    return res.status(err.status).json({ message: err.message });
  }

  console.error(err); // eslint-disable-line no-console
  return res.status(500).json({ message: 'Unexpected server error' });
};

