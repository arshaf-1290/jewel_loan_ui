import { Router } from 'express';

import { validate } from '../../middleware/validate.js';
import * as controller from './sync.controller.js';
import { syncInboxValidator, syncOutboxValidator } from './sync.validators.js';

const router = Router();

router.get('/outbox', syncOutboxValidator, validate, controller.fetchOutbox);
router.post('/inbox', syncInboxValidator, validate, controller.pushInbox);

export default router;

