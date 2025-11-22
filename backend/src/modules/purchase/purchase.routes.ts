import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './purchase.controller.js';
import { createPurchaseValidator, purchaseIdParam } from './purchase.validators.js';

const router = Router();

router.get('/', controller.listPurchases);
router.get('/:id', purchaseIdParam, validate, controller.getPurchase);
router.post('/', createPurchaseValidator, validate, controller.createPurchase);

export default router;

