import 'package:flutter/material.dart';

import '../../balance_sheet/views/balance_sheet_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../daily_metal_rate/views/daily_metal_rate_view.dart';
import '../../company_creation/views/company_creation_view.dart';
import '../../customer_creation/views/customer_creation_view.dart';
import '../../pending_report/views/pending_report_view.dart';
import '../../item_creation/views/item_creation_view.dart';
import '../../staff_creation/views/staff_creation_view.dart';
import '../../salary/views/salary_view.dart';
import '../../expenses/views/expenses_view.dart';
import '../../ledger/views/ledger_view.dart';
import '../../day_book/views/day_book_view.dart';
//import '../../loan/views/loan_view.dart';
import '../../loan_receipt/views/loan_receipt_view.dart';
import '../../loan_receipt_report/views/loan_receipt_report_view.dart';
import '../../profit_loss/views/profit_loss_view.dart';
import '../../sale/views/sale_view.dart';
import '../../item_report/views/item_report_view.dart';
import '../../customer_statement/views/customer_statement_view.dart';
import '../../trial_balance/views/trial_balance_view.dart';
import '../../loan_report/views/loan_report_view.dart';

class ModuleEntry {
  const ModuleEntry({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.view,
  });

  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget view;
}

class ModuleGroup {
  const ModuleGroup({required this.title, required this.modules});

  final String title;
  final List<ModuleEntry> modules;
}

class ShellController extends ChangeNotifier {
  ShellController();

  int _selectedIndex = 0;

  static const ModuleEntry _dashboardModule = ModuleEntry(
    key: 'dashboard',
    title: 'Dashboard',
    subtitle: 'Business pulse across sales, purchases, loans, and cash flow',
    icon: Icons.space_dashboard_outlined,
    view: DashboardView(),
  );

  static const ModuleEntry _dailyMetalRateModule = ModuleEntry(
    key: 'daily_metal_rate',
    title: 'Daily Metal Rate',
    subtitle: 'Manage gold, silver, platinum & diamond benchmark rates',
    icon: Icons.precision_manufacturing_outlined,
    view: DailyMetalRateView(),
  );

  static const ModuleEntry _companyCreationModule = ModuleEntry(
    key: 'company_creation',
    title: 'Company Creation',
    subtitle: 'Register companies, admins and banking defaults',
    icon: Icons.apartment_outlined,
    view: CompanyCreationView(),
  );

  static const ModuleEntry _customerCreationModule = ModuleEntry(
    key: 'customer_creation',
    title: 'Customer Creation',
    subtitle: 'Register and manage customers and referrals',
    icon: Icons.person_outline,
    view: CustomerCreationView(),
  );

  static const ModuleEntry _pendingReportModule = ModuleEntry(
    key: 'pending_report',
    title: 'Pending Report',
    subtitle: 'Track loans with pending amounts by date and type',
    icon: Icons.pending_actions_outlined,
    view: PendingReportView(),
  );

  static const ModuleEntry _itemCreationModule = ModuleEntry(
    key: 'item_creation',
    title: 'Item Creation',
    subtitle: 'Create and review inventory master items',
    icon: Icons.inventory_outlined,
    view: ItemCreationView(),
  );

  static const ModuleEntry _staffCreationModule = ModuleEntry(
    key: 'staff_creation',
    title: 'Staff Creation',
    subtitle: 'Manage branch staff, agents and admins',
    icon: Icons.person_add_alt_1_outlined,
    view: StaffCreationView(),
  );

  static const ModuleEntry _salaryModule = ModuleEntry(
    key: 'salary',
    title: 'Salary',
    subtitle: 'Manage staff salary entries, edits and reports',
    icon: Icons.account_balance_wallet_outlined,
    view: SalaryView(),
  );

  static const ModuleEntry _itemReportModule = ModuleEntry(
    key: 'item_report',
    title: 'Item Report',
    subtitle: 'View, edit, print item master & pending loans',
    icon: Icons.list_alt_outlined,
    view: ItemReportView(),
  );

  static const ModuleEntry _customerStatementModule = ModuleEntry(
    key: 'customer_statement_report',
    title: 'Customer Statement',
    subtitle: 'All loans & dues for a single customer',
    icon: Icons.people_alt_outlined,
    view: CustomerStatementView(),
  );

  static const ModuleEntry _saleModule = ModuleEntry(
    key: 'sale',
    title: 'Sale',
    subtitle: 'Gold sale billing & PDF invoices',
    icon: Icons.receipt_long_outlined,
    view: SaleView(),
  );

  // static const ModuleEntry _loanModule = ModuleEntry(
  //   key: 'loan',
  //   title: 'Loan',
  //   subtitle: 'Pledged ornaments & loan valuation',
  //   icon: Icons.account_balance_outlined,
  //   //view: LoanView(),
  // );

  static const ModuleEntry _loanReceiptModule = ModuleEntry(
    key: 'loan_receipt',
    title: 'Loan Receipt',
    subtitle: 'Repayment receipts & outstanding summary',
    icon: Icons.receipt_outlined,
    view: LoanReceiptView(),
  );

  static const ModuleEntry _loanReceiptReportModule = ModuleEntry(
    key: 'loan_receipt_report',
    title: 'Loan Receipt Report',
    subtitle: 'Track receipt breakups, edits, and printouts',
    icon: Icons.receipt_long_outlined,
    view: LoanReceiptReportView(),
  );

  static const ModuleEntry _loanReportModule = ModuleEntry(
    key: 'loan_report',
    title: 'Loan Report',
    subtitle: 'Analyze loan dues, OD and collections',
    icon: Icons.assignment_outlined,
    view: LoanReportView(),
  );

  static const ModuleEntry _ledgerModule = ModuleEntry(
    key: 'ledger',
    title: 'Ledger',
    subtitle: 'Debit / credit postings across heads',
    icon: Icons.menu_book_outlined,
    view: LedgerView(),
  );

  static const ModuleEntry _dayBookModule = ModuleEntry(
    key: 'day_book',
    title: 'Day Book',
    subtitle: 'Daily voucher-wise summary',
    icon: Icons.menu_book_rounded,
    view: DayBookView(),
  );

  static const ModuleEntry _trialBalanceModule = ModuleEntry(
    key: 'trial_balance',
    title: 'Trial Balance',
    subtitle: 'Balance verification before closing',
    icon: Icons.balance_outlined,
    view: TrialBalanceView(),
  );

  static const ModuleEntry _profitLossModule = ModuleEntry(
    key: 'profit_loss',
    title: 'Profit & Loss',
    subtitle: 'Income vs expenses overview',
    icon: Icons.show_chart_outlined,
    view: ProfitLossView(),
  );

  static const ModuleEntry _balanceSheetModule = ModuleEntry(
    key: 'balance_sheet',
    title: 'Balance Sheet',
    subtitle: 'Assets, liabilities & net worth',
    icon: Icons.account_balance_wallet_outlined,
    view: BalanceSheetView(),
  );

  static const ModuleEntry _expensesModule = ModuleEntry(
    key: 'expenses',
    title: 'Expenses',
    subtitle: 'Operational spends posting',
    icon: Icons.credit_card_outlined,
    view: ExpensesView(),
  );

  List<ModuleGroup> get moduleGroups => const [
    ModuleGroup(title: 'Overview', modules: [_dashboardModule]),
    ModuleGroup(
      title: 'Master',
      modules: [
        _companyCreationModule,
        _dailyMetalRateModule,
        _customerCreationModule,
        _pendingReportModule,
        _staffCreationModule,
        _salaryModule,
      ],
    ),
    ModuleGroup(
      title: 'Loan',
      modules: [
        _loanReceiptModule,
        _loanReportModule,
        _loanReceiptReportModule,
        _customerStatementModule,
      ],
    ),
    ModuleGroup(
      title: 'Item',
      modules: [
        _itemCreationModule,
        _itemReportModule,
      ],
    ),
    ModuleGroup(
      title: 'Operations',
      modules: [
        _saleModule,
        //_loanModule,
        //_loanReceiptModule,
      ],
    ),
    ModuleGroup(
      title: 'Accounting',
      modules: [
        _ledgerModule,
        _dayBookModule,
        _trialBalanceModule,
        _profitLossModule,
        _balanceSheetModule,
        _expensesModule,
      ],
    ),
  ];

  List<ModuleEntry> get modules =>
      moduleGroups.expand((group) => group.modules).toList(growable: false);

  int get selectedIndex => _selectedIndex;

  void selectModule(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
