import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './ledger.controller.js';
import { ledgerFilterValidator } from './ledger.validators.js';

const router = Router();

router.get('/', ledgerFilterValidator, validate, controller.listEntries);
router.get('/summary', ledgerFilterValidator, validate, controller.summary);

export default router;

