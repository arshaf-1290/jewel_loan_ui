import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import { createSaleValidator, saleIdParam } from './sale.validators.js';
import * as controller from './sale.controller.js';

const router = Router();

router.get('/', controller.listSales);
router.get('/:id', saleIdParam, validate, controller.getSale);
router.post('/', createSaleValidator, validate, controller.createSale);

export default router;

