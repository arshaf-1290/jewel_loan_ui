import { Router } from 'express';

import stockRoutes from '../modules/stock/stock.routes.js';
import purchaseRoutes from '../modules/purchase/purchase.routes.js';
import saleRoutes from '../modules/sale/sale.routes.js';
import loanRoutes from '../modules/loan/loan.routes.js';
import loanReceiptRoutes from '../modules/loanReceipt/loanReceipt.routes.js';
import ledgerRoutes from '../modules/ledger/ledger.routes.js';
import expenseRoutes from '../modules/expenses/expenses.routes.js';
import reportRoutes from '../modules/reports/reports.routes.js';
import trialBalanceRoutes from '../modules/trialBalance/trialBalance.routes.js';
import profitLossRoutes from '../modules/profitLoss/profitLoss.routes.js';
import balanceSheetRoutes from '../modules/balanceSheet/balanceSheet.routes.js';
import customerReportRoutes from '../modules/customerReport/customerReport.routes.js';
import syncRoutes from '../modules/sync/sync.routes.js';

const router = Router();

router.use('/stock', stockRoutes);
router.use('/purchases', purchaseRoutes);
router.use('/sales', saleRoutes);
router.use('/loans', loanRoutes);
router.use('/loan-receipts', loanReceiptRoutes);
router.use('/ledger', ledgerRoutes);
router.use('/expenses', expenseRoutes);
router.use('/reports', reportRoutes);
router.use('/trial-balance', trialBalanceRoutes);
router.use('/profit-loss', profitLossRoutes);
router.use('/balance-sheet', balanceSheetRoutes);
router.use('/customer-report', customerReportRoutes);
router.use('/sync', syncRoutes);

export default router;

