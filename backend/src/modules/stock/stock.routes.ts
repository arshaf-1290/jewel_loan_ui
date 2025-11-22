import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './stock.controller.js';
import {
  createStockValidator,
  listStockValidator,
  stockIdParam,
  updateStockValidator,
} from './stock.validators.js';

const router = Router();

router.get('/', listStockValidator, validate, controller.listStock);
router.get('/:id', stockIdParam, validate, controller.getStock);
router.post('/', createStockValidator, validate, controller.createStock);
router.put('/:id', updateStockValidator, validate, controller.updateStock);
router.delete('/:id', stockIdParam, validate, controller.removeStock);

export default router;

