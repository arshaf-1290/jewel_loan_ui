import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './reports.controller.js';
import { rangeValidator } from './reports.validators.js';

const router = Router();

router.get('/sales', rangeValidator, validate, controller.salesSummary);
router.get('/purchases', rangeValidator, validate, controller.purchaseSummary);
router.get('/stock', controller.stockSnapshot);
router.get('/customer-aging', controller.customerAging);

export default router;

