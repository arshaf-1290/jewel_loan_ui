import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './loan.controller.js';
import { createLoanValidator, loanIdParam } from './loan.validators.js';

const router = Router();

router.get('/', controller.listLoans);
router.get('/:id', loanIdParam, validate, controller.getLoan);
router.post('/', createLoanValidator, validate, controller.createLoan);

export default router;

