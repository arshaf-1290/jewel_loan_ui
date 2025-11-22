import { Router } from 'express';

import * as controller from './profitLoss.controller.js';

const router = Router();

router.get('/latest', controller.latestProfitLoss);

export default router;

