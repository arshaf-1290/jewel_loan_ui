import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './customerReport.controller.js';
import { customerReportValidator } from './customerReport.validators.js';

const router = Router();

router.get('/', customerReportValidator, validate, controller.listCustomers);

export default router;

