import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './expenses.controller.js';
import { createExpenseValidator, expenseIdParam } from './expenses.validators.js';

const router = Router();

router.get('/', controller.listExpenses);
router.get('/:id', expenseIdParam, validate, controller.getExpense);
router.post('/', createExpenseValidator, validate, controller.createExpense);
router.delete('/:id', expenseIdParam, validate, controller.deleteExpense);

export default router;

