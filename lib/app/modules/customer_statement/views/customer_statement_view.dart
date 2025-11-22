import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/customer_statement_controller.dart';

part 'customer_statement_ui_builders.dart';

class CustomerStatementView extends StatefulWidget {
  const CustomerStatementView({super.key});

  @override
  State<CustomerStatementView> createState() => _CustomerStatementViewState();
}

class _CustomerStatementViewState extends State<CustomerStatementView>
    with TickerProviderStateMixin {
  late final CustomerStatementController controller;
  late TabController tabController;

  CustomerStatementLoan? _selectedLoan;
  bool _showEditTab = false;
  bool _showPrintTab = false;

  final TextEditingController paidCtrl = TextEditingController();
  final TextEditingController pendingCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController(text: 'Active');

  @override
  void initState() {
    super.initState();
    controller = CustomerStatementController();
    _initTabController();
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    paidCtrl.dispose();
    pendingCtrl.dispose();
    statusCtrl.dispose();
    super.dispose();
  }

  int get _tabCount => 1 + (_showEditTab ? 1 : 0) + (_showPrintTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? 1 : -1;
  int get _printTabIndex => !_showPrintTab
      ? -1
      : _showEditTab
          ? 2
          : 1;

  void _initTabController({int initialIndex = 0}) {
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  void _syncTabController(int targetIndex) {
    final newCount = _tabCount;
    final clampedIndex = newCount == 0
        ? 0
        : targetIndex.clamp(0, newCount - 1);
    if (tabController.length == newCount) {
      tabController.animateTo(clampedIndex);
      return;
    }
    tabController.dispose();
    tabController = TabController(
      length: newCount,
      vsync: this,
      initialIndex: clampedIndex,
    );
    setState(() {});
  }

  void _selectLoan(CustomerStatementLoan loan) {
    setState(() {
      _selectedLoan = loan;
      _showEditTab = true;
      _showPrintTab = false;
      paidCtrl.text = loan.paidAmount.toStringAsFixed(2);
      pendingCtrl.text = loan.pendingAmount.toStringAsFixed(2);
      statusCtrl.text = loan.status;
    });
    _syncTabController(_editTabIndex);
  }

  void _cancelEdit() {
    setState(() {
      _selectedLoan = null;
      paidCtrl.clear();
      pendingCtrl.clear();
      statusCtrl.text = 'Active';
      _showEditTab = false;
      _showPrintTab = false;
    });
    _syncTabController(0);
  }

  void _printSelectedLoan() {
    final loan = _selectedLoan;
    if (loan == null) {
      _showSnack('Select a loan to print.');
      return;
    }
    setState(() {
      _showPrintTab = true;
    });
    _syncTabController(_printTabIndex);
  }

  void _closePrintTab() {
    if (!_showPrintTab) return;
    setState(() {
      _showPrintTab = false;
    });
    final targetIndex = _showEditTab ? _editTabIndex : 0;
    _syncTabController(targetIndex);
  }

  bool get _isEditing => _showEditTab && _selectedLoan != null;
  String get _statementLockMessage =>
      'Please update, print, or cancel before returning to the statement.';

  void _handleTabTap(int index) {
    if (!_isEditing && !_showPrintTab) return;
    final allowedIndex = _showPrintTab ? _printTabIndex : _editTabIndex;
    if (allowedIndex == -1 || index == allowedIndex) return;
    _showSnack(_statementLockMessage);
    tabController.animateTo(allowedIndex);
  }

  void _updateLoan() {
    final loan = _selectedLoan;
    if (loan == null) {
      _showSnack('Select a loan to edit.');
      return;
    }
    final updated = CustomerStatementLoan(
      loanNo: loan.loanNo,
      loanDate: loan.loanDate,
      loanAmount: loan.loanAmount,
      interestPercent: loan.interestPercent,
      paidAmount: double.tryParse(paidCtrl.text) ?? loan.paidAmount,
      pendingAmount: double.tryParse(pendingCtrl.text) ?? loan.pendingAmount,
      dueDate: loan.dueDate,
      status: statusCtrl.text.trim().isEmpty ? loan.status : statusCtrl.text.trim(),
    );
    controller.updateLoan(loan.loanNo, updated);
    setState(() => _selectedLoan = updated);
    _showSnack('Loan updated.');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (tabController.index >= tabController.length) {
      tabController.index = tabController.length - 1;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final statement = controller.statement;
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border.withOpacity(0.6)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                          children: [
                            const Icon(Icons.people_alt_outlined,
                                color: AppColors.primary, size: 26),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Customer Statement Report',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(statement.customerName,
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                            const Spacer(),
                            _Stat(label: 'Loans', value: '${statement.totalLoans}'),
                            const SizedBox(width: 18),
                            _Stat(
                              label: 'Total Loan',
                              value: _formatCurrency(statement.totalLoanAmount),
                            ),
                            const SizedBox(width: 18),
                            _Stat(label: 'Paid', value: _formatCurrency(statement.totalPaid)),
                            const SizedBox(width: 18),
                            _Stat(
                              label: 'Pending',
                              value: _formatCurrency(statement.totalPending),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        onTap: _handleTabTap,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        tabs: [
                          const Tab(text: 'Statement'),
                          if (_showEditTab) const Tab(text: 'Edit Loan'),
                          if (_showPrintTab) const Tab(text: 'Print'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _StatementTab(
                              statement: statement,
                              onSelectLoan: _selectLoan,
                              locked: _isEditing || _showPrintTab,
                              lockMessage: _statementLockMessage,
                            ),
                            if (_showEditTab)
                              _EditTab(
                                selected: _selectedLoan,
                                paidCtrl: paidCtrl,
                                pendingCtrl: pendingCtrl,
                                statusCtrl: statusCtrl,
                                onSave: _updateLoan,
                                onCancel: _cancelEdit,
                                onPrint: _printSelectedLoan,
                              ),
                            if (_showPrintTab)
                              _PrintTab(
                                statement: statement,
                                onCancel: _closePrintTab,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatCurrency(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(value);
}