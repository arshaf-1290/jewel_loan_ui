import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './loanReceipt.controller.js';
import { createLoanReceiptValidator, loanReceiptIdParam } from './loanReceipt.validators.js';

const router = Router();

router.get('/', controller.listReceipts);
router.get('/:id', loanReceiptIdParam, validate, controller.getReceipt);
router.post('/', createLoanReceiptValidator, validate, controller.createReceipt);

export default router;

