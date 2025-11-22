import compression from 'compression';
import cors from 'cors';
import express from 'express';
import morgan from 'morgan';

import { env } from './config/env.js';
import { errorHandler } from './middleware/errorHandler.js';
import { notFoundHandler } from './middleware/notFoundHandler.js';
import router from './routes/index.js';

export const createApp = () => {
  const app = express();

  app.use(cors());
  app.use(compression());
  app.use(express.json({ limit: '5mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(morgan(env.nodeEnv === 'development' ? 'dev' : 'combined'));

  app.get('/health', (_req, res) => {
    res.json({ status: 'ok', env: env.nodeEnv, timestamp: new Date().toISOString() });
  });

  app.use('/api', router);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
};

