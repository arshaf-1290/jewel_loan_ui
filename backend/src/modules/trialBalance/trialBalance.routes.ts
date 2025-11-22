import { Router } from 'express';

import * as controller from './trialBalance.controller.js';

const router = Router();

router.get('/latest', controller.latestTrialBalance);

export default router;

