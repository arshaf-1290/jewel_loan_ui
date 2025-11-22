import { Router } from 'express';

import * as controller from './balanceSheet.controller.js';

const router = Router();

router.get('/latest', controller.latestBalanceSheet);

export default router;

