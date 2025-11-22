import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../staff_creation/controllers/staff_creation_controller.dart' hide StaffSalaryRecord;
import '../controllers/salary_controller.dart';

class SalaryView extends StatefulWidget {
  const SalaryView({super.key});

  @override
  State<SalaryView> createState() => _SalaryViewState();
}

class _SalaryViewState extends State<SalaryView> with TickerProviderStateMixin {
  late final SalaryController controller;
  late final StaffCreationController staffController;
  late final TabController tabController;
  static const _salaryLockMessage =
      'Salary Entry, Salary View, and Salary Reports are locked while editing. Save or cancel to continue.';

  // Salary entry
  String? _salaryStaffId;
  DateTime _salaryMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  final TextEditingController salaryBasicCtrl = TextEditingController();
  final TextEditingController salaryAllowanceCtrl = TextEditingController();
  final TextEditingController salaryIncentiveCtrl = TextEditingController();
  final TextEditingController salaryDeductionCtrl = TextEditingController();
  final TextEditingController salaryRemarksCtrl = TextEditingController();
  String _salaryPaymentType = 'Cash';
  String _salaryLedger = 'Cash Account';
  DateTime? _salaryPaidDate = DateTime.now();
  String _salaryStatus = 'Paid';

  // Salary filters
  final TextEditingController salarySearchCtrl = TextEditingController();
  DateTime? _salaryFilterMonth;
  String _salaryFilterRole = 'All';
  String _salaryFilterStatus = 'All';
  String _salaryFilterYear = '';
  final TextEditingController salaryYearCtrl = TextEditingController();

  // Salary edit
  StaffSalaryRecord? _editingSalaryRecord;
  final TextEditingController editSalaryBasicCtrl = TextEditingController();
  final TextEditingController editSalaryAllowanceCtrl = TextEditingController();
  final TextEditingController editSalaryIncentiveCtrl = TextEditingController();
  final TextEditingController editSalaryDeductionCtrl = TextEditingController();
  final TextEditingController editSalaryRemarksCtrl = TextEditingController();
  String _editSalaryPaymentType = 'Cash';
  String _editSalaryLedger = 'Cash Account';
  DateTime? _editSalaryPaidDate;
  String _editSalaryStatus = 'Paid';
  bool _showSalaryEditTab = false;

  static const _paymentTypes = ['Cash', 'Bank', 'UPI'];
  static const _ledgerOptions = [
    'Cash Account',
    'Bank of India - Salary A/c',
    'Axis Bank - Current',
    'ICICI Bank - Payroll',
  ];

  int get _tabCount => 3 + (_showSalaryEditTab ? 1 : 0);
  int get _editTabIndex => _showSalaryEditTab ? 2 : -1;

  @override
  void initState() {
    super.initState();
    staffController = StaffCreationController();
    controller = SalaryController(staffController: staffController);
    _initTabController();
    salaryYearCtrl.text = _salaryFilterYear;
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    controller.dispose();
    staffController.dispose();
    salaryBasicCtrl.dispose();
    salaryAllowanceCtrl.dispose();
    salaryIncentiveCtrl.dispose();
    salaryDeductionCtrl.dispose();
    salaryRemarksCtrl.dispose();
    salarySearchCtrl.dispose();
    salaryYearCtrl.dispose();
    editSalaryBasicCtrl.dispose();
    editSalaryAllowanceCtrl.dispose();
    editSalaryIncentiveCtrl.dispose();
    editSalaryDeductionCtrl.dispose();
    editSalaryRemarksCtrl.dispose();
    super.dispose();
  }

  void _initTabController() {
    tabController = TabController(length: _tabCount, vsync: this);
    tabController.addListener(_handleTabChange);
  }

  void _resetTabController(int targetIndex) {
    tabController.removeListener(_handleTabChange);
    final oldController = tabController;
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: targetIndex.clamp(0, _tabCount - 1),
    );
    tabController.addListener(_handleTabChange);
    oldController.dispose();
  }

  void _handleTabChange() {
    if (!_showSalaryEditTab) return;
    final editIndex = _editTabIndex;
    if (editIndex == -1) return;
    final isLeavingEditTab =
        tabController.previousIndex == editIndex &&
        tabController.index != editIndex;
    if (isLeavingEditTab) {
      tabController.animateTo(editIndex);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_salaryLockMessage)),
      );
    }
  }

  void _handleTabTap(int index) {
    if (!_showSalaryEditTab) return;
    final editIndex = _editTabIndex;
    if (editIndex == -1 || index == editIndex) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(_salaryLockMessage)),
    );
    tabController.animateTo(editIndex);
  }

  void _cancelSalaryEdit() {
    if (!_showSalaryEditTab) return;
    setState(() {
      _editingSalaryRecord = null;
      _showSalaryEditTab = false;
    });
    _resetTabController(1);
  }

  Widget _buildSalaryLockedWrapper(Widget child) {
    if (!_showSalaryEditTab) return child;
    return AbsorbPointer(child: child);
  }

  double _parseAmount(TextEditingController ctrl) {
    final text = ctrl.text.trim();
    if (text.isEmpty) return 0;
    return double.tryParse(text) ?? 0;
  }

  double get _currentNetSalary {
    final basic = _parseAmount(salaryBasicCtrl);
    final allowance = _parseAmount(salaryAllowanceCtrl);
    final incentives = _parseAmount(salaryIncentiveCtrl);
    final deductions = _parseAmount(salaryDeductionCtrl);
    return basic + allowance + incentives - deductions;
  }

  double get _editNetSalary {
    final basic = _parseAmount(editSalaryBasicCtrl);
    final allowance = _parseAmount(editSalaryAllowanceCtrl);
    final incentives = _parseAmount(editSalaryIncentiveCtrl);
    final deductions = _parseAmount(editSalaryDeductionCtrl);
    return basic + allowance + incentives - deductions;
  }

  StaffRecord? _staffById(String? staffId) {
    if (staffId == null) return null;
    try {
      return controller.staff.firstWhere((record) => record.staffId == staffId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickSalaryMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _salaryMonth,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Select salary month',
    );
    if (picked != null) {
      setState(() {
        _salaryMonth = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  Future<void> _pickSalaryPaidDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _salaryPaidDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Select paid date',
    );
    if (picked != null) {
      setState(() {
        _salaryPaidDate = picked;
      });
    }
  }

  Future<void> _pickSalaryFilterMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _salaryFilterMonth ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Filter month',
    );
    if (picked != null) {
      setState(() {
        _salaryFilterMonth = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  void _resetSalaryEntryForm() {
    setState(() {
      _salaryStaffId = null;
      _salaryMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
      salaryBasicCtrl.clear();
      salaryAllowanceCtrl.clear();
      salaryIncentiveCtrl.clear();
      salaryDeductionCtrl.clear();
      salaryRemarksCtrl.clear();
      _salaryPaymentType = 'Cash';
      _salaryLedger = 'Cash Account';
      _salaryPaidDate = DateTime.now();
      _salaryStatus = 'Paid';
    });
  }

  void _openSalaryEditFromView(StaffSalaryRecord record) {
    final shouldShow = !_showSalaryEditTab;
    setState(() {
      _editingSalaryRecord = record;
      _showSalaryEditTab = true;
      editSalaryBasicCtrl.text = record.basicSalary.toStringAsFixed(2);
      editSalaryAllowanceCtrl.text = record.allowance.toStringAsFixed(2);
      editSalaryIncentiveCtrl.text = record.incentives.toStringAsFixed(2);
      editSalaryDeductionCtrl.text = record.deductions.toStringAsFixed(2);
      editSalaryRemarksCtrl.text = record.remarks ?? '';
      _editSalaryPaymentType = record.paymentType;
      _editSalaryLedger = record.ledger;
      _editSalaryPaidDate = record.paidDate;
      _editSalaryStatus = record.status;
    });

    if (shouldShow) {
      _resetTabController(_editTabIndex);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final editIndex = _editTabIndex;
      if (mounted && editIndex != -1) {
        tabController.animateTo(editIndex);
      }
    });
  }

  void _handleSalarySubmit() {
    if (_salaryStaffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a staff member for salary entry.'),
        ),
      );
      return;
    }

    final staff = _staffById(_salaryStaffId);
    if (staff == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected staff record not found.')),
      );
      return;
    }

    final salaryId = controller.generateSalaryId(_salaryMonth);
    final record = StaffSalaryRecord(
      salaryId: salaryId,
      staffId: staff.staffId,
      staffName: staff.fullName,
      role: staff.role,
      salaryMonth: _salaryMonth,
      basicSalary: _parseAmount(salaryBasicCtrl),
      allowance: _parseAmount(salaryAllowanceCtrl),
      incentives: _parseAmount(salaryIncentiveCtrl),
      deductions: _parseAmount(salaryDeductionCtrl),
      paymentType: _salaryStatus == 'Pending' ? 'Pending' : _salaryPaymentType,
      ledger: _salaryStatus == 'Pending' ? '—' : _salaryLedger,
      paidDate: _salaryStatus == 'Pending' ? null : _salaryPaidDate,
      remarks: salaryRemarksCtrl.text.trim().isEmpty
          ? null
          : salaryRemarksCtrl.text.trim(),
      status: _salaryStatus,
    );

    controller.addSalary(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salary record saved successfully.')),
    );

    _resetSalaryEntryForm();
  }

  void _handleSalaryEditSave() {
    final record = _editingSalaryRecord;
    if (record == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a salary record to edit.')),
      );
      return;
    }

    final updated = record.copyWith(
      basicSalary: _parseAmount(editSalaryBasicCtrl),
      allowance: _parseAmount(editSalaryAllowanceCtrl),
      incentives: _parseAmount(editSalaryIncentiveCtrl),
      deductions: _parseAmount(editSalaryDeductionCtrl),
      paymentType: _editSalaryStatus == 'Pending'
          ? 'Pending'
          : _editSalaryPaymentType,
      ledger: _editSalaryStatus == 'Pending' ? '—' : _editSalaryLedger,
      paidDate: _editSalaryStatus == 'Pending' ? null : _editSalaryPaidDate,
      remarks: editSalaryRemarksCtrl.text.trim().isEmpty
          ? null
          : editSalaryRemarksCtrl.text.trim(),
      status: _editSalaryStatus,
    );

    controller.updateSalary(record.salaryId, updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salary record updated.')),
    );
  }

  void _handleSalaryDelete(StaffSalaryRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Salary Delete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Staff Name: ${record.staffName}'),
            Text('Staff ID: ${record.staffId}'),
            Text('Month & Year: ${record.formattedMonth}'),
            Text('Net Salary: ₹${record.netSalary.toStringAsFixed(2)}'),
            Text('Paid Date: ${record.formattedPaidDate}'),
            const SizedBox(height: 12),
            const Text('Are you sure you want to delete this salary record?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      controller.deleteSalary(record.salaryId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salary record deleted.')),
      );
      if (_editingSalaryRecord?.salaryId == record.salaryId) {
        setState(() {
          _editingSalaryRecord = null;
          _showSalaryEditTab = false;
        });
        _resetTabController(1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final salaryList = controller.salaryRecords;
          final total = salaryList.length;
          final paid = salaryList.where((r) => r.status == 'Paid').length;
          final pending = total - paid;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.6),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 16,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Salary Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                _HeaderCount(label: 'Total', value: total.toString()),
                                const SizedBox(width: 24),
                                _HeaderCount(label: 'Paid', value: paid.toString()),
                                const SizedBox(width: 24),
                                _HeaderCount(label: 'Pending', value: pending.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        isScrollable: true,
                        controller: tabController,
                        onTap: _handleTabTap,
                        labelColor: AppColors.primary,
                        unselectedLabelColor:
                            AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 60),
                        tabs: [
                          const Tab(text: 'Salary Entry'),
                          const Tab(text: 'Salary View'),
                          if (_showSalaryEditTab)
                            const Tab(text: 'Salary Edit'),
                          const Tab(text: 'Salary Reports'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _buildSalaryLockedWrapper(
                              _SalaryEntryTab(
                                controller: controller,
                                staffId: _salaryStaffId,
                                onStaffChanged: (value) =>
                                    setState(() => _salaryStaffId = value),
                                salaryMonth: _salaryMonth,
                                onPickMonth: _pickSalaryMonth,
                                basicCtrl: salaryBasicCtrl,
                                allowanceCtrl: salaryAllowanceCtrl,
                                incentiveCtrl: salaryIncentiveCtrl,
                                deductionCtrl: salaryDeductionCtrl,
                                netSalary: _currentNetSalary,
                                paymentType: _salaryPaymentType,
                                onPaymentChanged: (value) =>
                                    setState(() => _salaryPaymentType = value),
                                ledger: _salaryLedger,
                                onLedgerChanged: (value) =>
                                    setState(() => _salaryLedger = value),
                                paidDate: _salaryPaidDate,
                                onPickPaidDate: _pickSalaryPaidDate,
                                status: _salaryStatus,
                                onStatusChanged: (value) => setState(() {
                                  _salaryStatus = value;
                                  if (value == 'Pending') {
                                    _salaryPaymentType = 'Pending';
                                    _salaryLedger = '—';
                                    _salaryPaidDate = null;
                                  } else {
                                    if (!_paymentTypes
                                        .contains(_salaryPaymentType)) {
                                      _salaryPaymentType = _paymentTypes.first;
                                    }
                                    if (!_ledgerOptions.contains(_salaryLedger)) {
                                      _salaryLedger = _ledgerOptions.first;
                                    }
                                    _salaryPaidDate ??= DateTime.now();
                                  }
                                }),
                                remarksCtrl: salaryRemarksCtrl,
                                paymentTypes: _paymentTypes,
                                ledgerOptions: _ledgerOptions,
                                staffLookup: _staffById,
                                onSubmit: _handleSalarySubmit,
                              ),
                            ),
                            _buildSalaryLockedWrapper(
                              _SalaryViewTab(
                                controller: controller,
                                searchCtrl: salarySearchCtrl,
                                filterRole: _salaryFilterRole,
                                onRoleChanged: (value) =>
                                    setState(() => _salaryFilterRole = value),
                                filterStatus: _salaryFilterStatus,
                                onStatusChanged: (value) =>
                                    setState(() => _salaryFilterStatus = value),
                                filterMonth: _salaryFilterMonth,
                                onPickMonth: _pickSalaryFilterMonth,
                                filterYear: _salaryFilterYear,
                                onYearChanged: (value) =>
                                    setState(() => _salaryFilterYear = value),
                                onSelectRecord: _openSalaryEditFromView,
                              ),
                            ),
                            if (_showSalaryEditTab)
                              _SalaryEditTab(
                                onSave: _handleSalaryEditSave,
                                onDelete: _handleSalaryDelete,
                                onCancel: _cancelSalaryEdit,
                                editingRecord: _editingSalaryRecord,
                                basicCtrl: editSalaryBasicCtrl,
                                allowanceCtrl: editSalaryAllowanceCtrl,
                                incentiveCtrl: editSalaryIncentiveCtrl,
                                deductionCtrl: editSalaryDeductionCtrl,
                                netSalary: _editNetSalary,
                                paymentType: _editSalaryPaymentType,
                                onPaymentChanged: (value) => setState(
                                  () => _editSalaryPaymentType = value,
                                ),
                                ledger: _editSalaryLedger,
                                onLedgerChanged: (value) =>
                                    setState(() => _editSalaryLedger = value),
                                paidDate: _editSalaryPaidDate,
                                onPickPaidDate: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _editSalaryPaidDate ?? DateTime.now(),
                                    firstDate: DateTime(2020, 1, 1),
                                    lastDate: DateTime(2100, 12, 31),
                                    helpText: 'Select paid date',
                                  );
                                  if (picked != null) {
                                    setState(() => _editSalaryPaidDate = picked);
                                  }
                                },
                                status: _editSalaryStatus,
                                onStatusChanged: (value) => setState(() {
                                  _editSalaryStatus = value;
                                  if (value == 'Pending') {
                                    _editSalaryPaymentType = 'Pending';
                                    _editSalaryLedger = '—';
                                    _editSalaryPaidDate = null;
                                  } else {
                                    if (!_paymentTypes
                                        .contains(_editSalaryPaymentType)) {
                                      _editSalaryPaymentType =
                                          _paymentTypes.first;
                                    }
                                    if (!_ledgerOptions
                                        .contains(_editSalaryLedger)) {
                                      _editSalaryLedger = _ledgerOptions.first;
                                    }
                                    _editSalaryPaidDate ??= DateTime.now();
                                  }
                                }),
                                remarksCtrl: editSalaryRemarksCtrl,
                                paymentTypes: _paymentTypes,
                                ledgerOptions: _ledgerOptions,
                              ),
                            _buildSalaryLockedWrapper(
                              _SalaryReportTab(controller: controller),
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
}

class _HeaderCount extends StatelessWidget {
  const _HeaderCount({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SalaryEntryTab extends StatelessWidget {
  const _SalaryEntryTab({
    required this.controller,
    required this.staffId,
    required this.onStaffChanged,
    required this.salaryMonth,
    required this.onPickMonth,
    required this.basicCtrl,
    required this.allowanceCtrl,
    required this.incentiveCtrl,
    required this.deductionCtrl,
    required this.netSalary,
    required this.paymentType,
    required this.onPaymentChanged,
    required this.ledger,
    required this.onLedgerChanged,
    required this.paidDate,
    required this.onPickPaidDate,
    required this.status,
    required this.onStatusChanged,
    required this.remarksCtrl,
    required this.paymentTypes,
    required this.ledgerOptions,
    required this.staffLookup,
    required this.onSubmit,
  });

  final SalaryController controller;
  final String? staffId;
  final ValueChanged<String?> onStaffChanged;
  final DateTime salaryMonth;
  final VoidCallback onPickMonth;
  final TextEditingController basicCtrl;
  final TextEditingController allowanceCtrl;
  final TextEditingController incentiveCtrl;
  final TextEditingController deductionCtrl;
  final double netSalary;
  final String paymentType;
  final ValueChanged<String> onPaymentChanged;
  final String ledger;
  final ValueChanged<String> onLedgerChanged;
  final DateTime? paidDate;
  final VoidCallback onPickPaidDate;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final TextEditingController remarksCtrl;
  final List<String> paymentTypes;
  final List<String> ledgerOptions;
  final StaffRecord? Function(String?) staffLookup;
  final VoidCallback onSubmit;

  static const _salaryStatuses = ['Paid', 'Pending'];

  @override
  Widget build(BuildContext context) {
    final selectedStaff = staffLookup(staffId);
    final paymentItems = status == 'Pending'
        ? (paymentTypes.contains('Pending')
              ? List<String>.from(paymentTypes)
              : [...paymentTypes, 'Pending'])
        : paymentTypes;
    final ledgerItems = status == 'Pending'
        ? (ledgerOptions.contains('—')
              ? List<String>.from(ledgerOptions)
              : [...ledgerOptions, '—'])
        : ledgerOptions;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 280,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: staffId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Staff Name',
                    hintText: 'Select staff',
                  ),
                  items: controller.staff
                      .map(
                        (staff) => DropdownMenuItem(
                          value: staff.staffId,
                          child: Text('${staff.fullName} (${staff.staffId})'),
                        ),
                      )
                      .toList(),
                  onChanged: onStaffChanged,
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: _MonthSelector(
                  label: 'Salary Month',
                  date: salaryMonth,
                  onTap: onPickMonth,
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _AmountField(controller: basicCtrl, label: 'Basic Salary'),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _AmountField(
                  controller: allowanceCtrl,
                  label: 'Allowance (optional)',
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _AmountField(
                  controller: incentiveCtrl,
                  label: 'Incentives (optional)',
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _AmountField(controller: deductionCtrl, label: 'Deductions'),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: _DateBox(
                  label: 'Paid Date',
                  dateText: paidDate == null
                      ? '—'
                      : DateFormat('dd-MMM-yyyy').format(paidDate!),
                  onTap: status == 'Pending' ? null : onPickPaidDate,
                ),
              ),
              SizedBox(
                width: 220,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Salary Status'),
                  items: _salaryStatuses
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item, style: TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onStatusChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: paymentType,
                  decoration: const InputDecoration(labelText: 'Payment Type'),
                  items: paymentItems
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: status == 'Pending'
                      ? null
                      : (value) {
                          if (value != null) onPaymentChanged(value);
                        },
                ),
              ),
              SizedBox(
                width: 240,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: ledger,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Select Ledger'),
                  items: ledgerItems
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: status == 'Pending'
                      ? null
                      : (value) {
                          if (value != null) onLedgerChanged(value);
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedStaff != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 24,
                children: [
                  Text('Staff ID: ${selectedStaff.staffId}'),
                  Text('Role: ${selectedStaff.role}'),
                  Text('Joining: ${selectedStaff.formattedDoj}'),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EBD9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Salary',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '₹${netSalary.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: remarksCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Remarks (optional)'),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Save Salary'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryViewTab extends StatefulWidget {
  _SalaryViewTab({
    required this.controller,
    required this.searchCtrl,
    required this.filterRole,
    required this.onRoleChanged,
    required this.filterStatus,
    required this.onStatusChanged,
    required this.filterMonth,
    required this.onPickMonth,
    required this.filterYear,
    required this.onYearChanged,
    required this.onSelectRecord,
  });

  final SalaryController controller;
  final TextEditingController searchCtrl;
  final String filterRole;
  final ValueChanged<String> onRoleChanged;
  final String filterStatus;
  final ValueChanged<String> onStatusChanged;
  final DateTime? filterMonth;
  final VoidCallback onPickMonth;
  final String filterYear;
  final ValueChanged<String> onYearChanged;
  final ValueChanged<StaffSalaryRecord> onSelectRecord;

  @override
  State<_SalaryViewTab> createState() => _SalaryViewTabState();
}

class _SalaryViewTabState extends State<_SalaryViewTab> {
  final ScrollController _horizontalScrollController = ScrollController();

  static const _roles = ['All', 'Admin', 'Manager', 'Accountant', 'Loan Officer', 'Staff', 'Agent'];
  static const _status = ['All', 'Paid', 'Pending'];

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.filterYear.trim();
    final year = int.tryParse(text.isEmpty ? '' : text);
    final filtered = widget.controller.filterSalary(
      query: widget.searchCtrl.text,
      role: widget.filterRole,
      status: widget.filterStatus,
      month: widget.filterMonth,
      year: year,
    );

    final totals = widget.controller.salaryTotals(filtered);
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.searchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Search staff / ID',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => (context as Element).markNeedsBuild(),
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: widget.filterRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: _roles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onRoleChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: widget.filterStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: _status
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onStatusChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: _DateBox(
                  label: 'Filter Month',
                  dateText: widget.filterMonth == null
                      ? 'All months'
                      : DateFormat('MMM yyyy').format(widget.filterMonth!),
                  onTap: widget.onPickMonth,
                ),
              ),
              SizedBox(
                width: 140,
                height: 48,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Filter Year'),
                  keyboardType: TextInputType.number,
                  onChanged: widget.onYearChanged,
                  controller: TextEditingController(text: widget.filterYear)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.filterYear.length),
                    ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 48,
                    ),
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text('S.No')),
                        DataColumn(label: Text('Staff Name')),
                        DataColumn(label: Text('Staff ID')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Month & Year')),
                        DataColumn(label: Text('Basic Salary')),
                        DataColumn(label: Text('Allowance')),
                        DataColumn(label: Text('Incentives')),
                        DataColumn(label: Text('Deductions')),
                        DataColumn(label: Text('Net Salary')),
                        DataColumn(label: Text('Payment Type')),
                        DataColumn(label: Text('Paid Date')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        ...filtered.asMap().entries.map((entry) {
                          final record = entry.value;
                          final index = entry.key + 1;
                          return DataRow(
                            onSelectChanged: (_) =>
                                widget.onSelectRecord(record),
                            cells: [
                              DataCell(
                                Text(index.toString()),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.staffName),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.staffId),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.role),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.formattedMonth),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(currency.format(record.basicSalary)),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(currency.format(record.allowance)),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(currency.format(record.incentives)),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(currency.format(record.deductions)),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(currency.format(record.netSalary)),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.paymentType),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.formattedPaidDate),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                              DataCell(
                                Text(record.status),
                                onTap: () => widget.onSelectRecord(record),
                              ),
                            ],
                          );
                        }),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            DataCell(Text(currency.format(totals['basic'] ?? 0))),
                            DataCell(Text(currency.format(totals['allowance'] ?? 0))),
                            DataCell(
                              Text(currency.format(totals['incentives'] ?? 0)),
                            ),
                            DataCell(
                              Text(currency.format(totals['deductions'] ?? 0)),
                            ),
                            DataCell(Text(currency.format(totals['net'] ?? 0))),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SalaryEditTab extends StatelessWidget {
  const _SalaryEditTab({
    required this.editingRecord,
    required this.onSave,
    required this.onDelete,
    required this.onCancel,
    required this.basicCtrl,
    required this.allowanceCtrl,
    required this.incentiveCtrl,
    required this.deductionCtrl,
    required this.netSalary,
    required this.paymentType,
    required this.onPaymentChanged,
    required this.ledger,
    required this.onLedgerChanged,
    required this.paidDate,
    required this.onPickPaidDate,
    required this.status,
    required this.onStatusChanged,
    required this.remarksCtrl,
    required this.paymentTypes,
    required this.ledgerOptions,
  });

  final StaffSalaryRecord? editingRecord;
  final VoidCallback onSave;
  final ValueChanged<StaffSalaryRecord> onDelete;
  final VoidCallback onCancel;
  final TextEditingController basicCtrl;
  final TextEditingController allowanceCtrl;
  final TextEditingController incentiveCtrl;
  final TextEditingController deductionCtrl;
  final double netSalary;
  final String paymentType;
  final ValueChanged<String> onPaymentChanged;
  final String ledger;
  final ValueChanged<String> onLedgerChanged;
  final DateTime? paidDate;
  final VoidCallback onPickPaidDate;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final TextEditingController remarksCtrl;
  final List<String> paymentTypes;
  final List<String> ledgerOptions;

  static const _salaryStatuses = ['Paid', 'Pending'];

  @override
  Widget build(BuildContext context) {
    if (editingRecord == null) {
      return const Center(
        child: Text('Select a salary record from Salary View to edit.'),
      );
    }

    final paymentItems = status == 'Pending'
        ? (paymentTypes.contains('Pending')
              ? List<String>.from(paymentTypes)
              : [...paymentTypes, 'Pending'])
        : paymentTypes;
    final ledgerItems = status == 'Pending'
        ? (ledgerOptions.contains('—')
              ? List<String>.from(ledgerOptions)
              : [...ledgerOptions, '—'])
        : ledgerOptions;
    final record = editingRecord!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${record.staffName} (${record.staffId})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text('Month: ${record.formattedMonth} • Role: ${record.role}'),
          const SizedBox(height: 24),
          Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: _AmountField(
                              controller: basicCtrl,
                              label: 'Basic Salary',
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: _AmountField(
                              controller: allowanceCtrl,
                              label: 'Allowance',
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: _AmountField(
                              controller: incentiveCtrl,
                              label: 'Incentives',
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: _AmountField(
                              controller: deductionCtrl,
                              label: 'Deductions',
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            height: 48,
                            child: DropdownButtonFormField<String>(
                              value: status,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                              ),
                              items: _salaryStatuses
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) onStatusChanged(value);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            height: 48,
                            child: DropdownButtonFormField<String>(
                              value: paymentType,
                              decoration: const InputDecoration(
                                labelText: 'Payment Type',
                              ),
                              items: paymentItems
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                              onChanged: status == 'Pending'
                                  ? null
                                  : (value) {
                                      if (value != null)
                                        onPaymentChanged(value);
                                    },
                            ),
                          ),
                          SizedBox(
                            width: 240,
                            height: 48,
                            child: DropdownButtonFormField<String>(
                              value: ledger,
                              decoration: const InputDecoration(
                                labelText: 'Ledger',
                              ),
                              items: ledgerItems
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              onChanged: status == 'Pending'
                                  ? null
                                  : (value) {
                                      if (value != null) onLedgerChanged(value);
                                    },
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            height: 48,
                            child: _DateBox(
                              label: 'Paid Date',
                              dateText: paidDate == null
                                  ? '—'
                                  : DateFormat('dd-MMM-yyyy').format(paidDate!),
                              onTap: status == 'Pending'
                                  ? null
                                  : onPickPaidDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F6FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Net Salary',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '₹${netSalary.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: remarksCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Remarks'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: onCancel,
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => onDelete(record),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.danger,
                            ),
                            label: const Text('Delete Salary'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: onSave,
                            icon: const Icon(Icons.save_alt_outlined),
                            label: const Text('Save Changes'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
        ],
      ),
    );
  }
}

class _SalaryReportTab extends StatefulWidget {
  const _SalaryReportTab({required this.controller});

  final SalaryController controller;

  @override
  State<_SalaryReportTab> createState() => _SalaryReportTabState();
}

class _SalaryReportTabState extends State<_SalaryReportTab>
    with SingleTickerProviderStateMixin {
  late final TabController _reportTabController;
  DateTime? _summaryMonth;
  String? _staffFilterId;
  DateTime? _pendingMonth;

  @override
  void initState() {
    super.initState();
    _reportTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _reportTabController.dispose();
    super.dispose();
  }

  Future<void> _pickSummaryMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _summaryMonth ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Select month',
    );
    if (picked != null) {
      setState(() => _summaryMonth = DateTime(picked.year, picked.month, 1));
    }
  }

  Future<void> _pickPendingMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _pendingMonth ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Pending month',
    );
    if (picked != null) {
      setState(() => _pendingMonth = DateTime(picked.year, picked.month, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final staff = controller.staff;
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    final summaryRecords = _summaryMonth == null
        ? controller.salaryRecords
        : controller.filterSalary(month: _summaryMonth);
    final summaryTotals = controller.salaryTotals(summaryRecords);

    final staffRecords = _staffFilterId == null
        ? <StaffSalaryRecord>[]
        : controller.salaryForStaff(_staffFilterId!);
    final staffTotals = controller.salaryTotals(staffRecords);

    final pendingRecords = _pendingMonth == null
        ? controller.filterSalary(status: 'Pending')
        : controller.pendingSalaryForMonth(_pendingMonth!);
    final pendingTotals = controller.salaryTotals(pendingRecords);

    return Column(
      children: [
        TabBar(
          controller: _reportTabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurface.withOpacity(0.6),
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Salary Summary'),
            Tab(text: 'Staff-wise Report'),
            Tab(text: 'Pending Salaries'),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: _reportTabController,
            children: [
              _SummaryReportView(
                records: summaryRecords,
                totals: summaryTotals,
                currency: currency,
                selectedMonth: _summaryMonth,
                onPickMonth: _pickSummaryMonth,
              ),
              _StaffWiseReportView(
                staff: staff,
                selectedStaffId: _staffFilterId,
                onStaffChanged: (value) =>
                    setState(() => _staffFilterId = value),
                records: staffRecords,
                totals: staffTotals,
                currency: currency,
              ),
              _PendingReportView(
                records: pendingRecords,
                totals: pendingTotals,
                currency: currency,
                selectedMonth: _pendingMonth,
                onPickMonth: _pickPendingMonth,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryReportView extends StatefulWidget {
  const _SummaryReportView({
    required this.records,
    required this.totals,
    required this.currency,
    required this.selectedMonth,
    required this.onPickMonth,
  });

  final List<StaffSalaryRecord> records;
  final Map<String, double> totals;
  final NumberFormat currency;
  final DateTime? selectedMonth;
  final VoidCallback onPickMonth;

  @override
  State<_SummaryReportView> createState() => _SummaryReportViewState();
}

class _SummaryReportViewState extends State<_SummaryReportView> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              _DateBox(
                label: 'Month Filter',
                dateText: widget.selectedMonth == null
                    ? 'All Months'
                    : DateFormat('MMM yyyy').format(widget.selectedMonth!),
                onTap: widget.onPickMonth,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 48,
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Staff Name')),
                        DataColumn(label: Text('Staff ID')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Month & Year')),
                        DataColumn(label: Text('Basic')),
                        DataColumn(label: Text('Allowance')),
                        DataColumn(label: Text('Incentives')),
                        DataColumn(label: Text('Deductions')),
                        DataColumn(label: Text('Net Salary')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        ...widget.records.map(
                          (record) => DataRow(
                            cells: [
                              DataCell(Text(record.staffName)),
                              DataCell(Text(record.staffId)),
                              DataCell(Text(record.role)),
                              DataCell(Text(record.formattedMonth)),
                              DataCell(Text(widget.currency.format(record.basicSalary))),
                              DataCell(Text(widget.currency.format(record.allowance))),
                              DataCell(Text(widget.currency.format(record.incentives))),
                              DataCell(Text(widget.currency.format(record.deductions))),
                              DataCell(Text(widget.currency.format(record.netSalary))),
                              DataCell(Text(record.status)),
                            ],
                          ),
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Grand Totals',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            DataCell(Text(widget.currency.format(widget.totals['basic'] ?? 0))),
                            DataCell(Text(widget.currency.format(widget.totals['allowance'] ?? 0))),
                            DataCell(
                              Text(widget.currency.format(widget.totals['incentives'] ?? 0)),
                            ),
                            DataCell(
                              Text(widget.currency.format(widget.totals['deductions'] ?? 0)),
                            ),
                            DataCell(Text(widget.currency.format(widget.totals['net'] ?? 0))),
                            const DataCell(Text('')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StaffWiseReportView extends StatefulWidget {
  const _StaffWiseReportView({
    required this.staff,
    required this.selectedStaffId,
    required this.onStaffChanged,
    required this.records,
    required this.totals,
    required this.currency,
  });

  final List<StaffRecord> staff;
  final String? selectedStaffId;
  final ValueChanged<String?> onStaffChanged;
  final List<StaffSalaryRecord> records;
  final Map<String, double> totals;
  final NumberFormat currency;

  @override
  State<_StaffWiseReportView> createState() => _StaffWiseReportViewState();
}

class _StaffWiseReportViewState extends State<_StaffWiseReportView> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StaffRecord? selectedStaff;
    if (widget.selectedStaffId != null) {
      try {
        selectedStaff = widget.staff.firstWhere(
          (record) => record.staffId == widget.selectedStaffId,
        );
      } catch (_) {
        selectedStaff = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: SizedBox(
            width: 320,
            child: DropdownButtonFormField<String>(
              value: widget.selectedStaffId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Select Staff',
                hintText: 'Choose staff member',
              ),
              items: widget.staff
                  .map(
                    (record) => DropdownMenuItem(
                      value: record.staffId,
                      child: Text('${record.fullName} (${record.staffId})'),
                    ),
                  )
                  .toList(),
              onChanged: widget.onStaffChanged,
            ),
          ),
        ),
        if (selectedStaff != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 24,
              children: [
                Text('Role: ${selectedStaff.role}'),
                Text('Joining Date: ${selectedStaff.formattedDoj}'),
              ],
            ),
          ),
        const SizedBox(height: 12),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 48,
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Salary Month')),
                        DataColumn(label: Text('Basic')),
                        DataColumn(label: Text('Allowance')),
                        DataColumn(label: Text('Incentives')),
                        DataColumn(label: Text('Deductions')),
                        DataColumn(label: Text('Net Salary')),
                        DataColumn(label: Text('Paid Date')),
                        DataColumn(label: Text('Payment Type')),
                      ],
                      rows: [
                        ...widget.records.map(
                          (record) => DataRow(
                            cells: [
                              DataCell(Text(record.formattedMonth)),
                              DataCell(Text(widget.currency.format(record.basicSalary))),
                              DataCell(Text(widget.currency.format(record.allowance))),
                              DataCell(Text(widget.currency.format(record.incentives))),
                              DataCell(Text(widget.currency.format(record.deductions))),
                              DataCell(Text(widget.currency.format(record.netSalary))),
                              DataCell(Text(record.formattedPaidDate)),
                              DataCell(Text(record.paymentType)),
                            ],
                          ),
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Totals',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataCell(Text(widget.currency.format(widget.totals['basic'] ?? 0))),
                            DataCell(Text(widget.currency.format(widget.totals['allowance'] ?? 0))),
                            DataCell(
                              Text(widget.currency.format(widget.totals['incentives'] ?? 0)),
                            ),
                            DataCell(
                              Text(widget.currency.format(widget.totals['deductions'] ?? 0)),
                            ),
                            DataCell(Text(widget.currency.format(widget.totals['net'] ?? 0))),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingReportView extends StatefulWidget {
  const _PendingReportView({
    required this.records,
    required this.totals,
    required this.currency,
    required this.selectedMonth,
    required this.onPickMonth,
  });

  final List<StaffSalaryRecord> records;
  final Map<String, double> totals;
  final NumberFormat currency;
  final DateTime? selectedMonth;
  final VoidCallback onPickMonth;

  @override
  State<_PendingReportView> createState() => _PendingReportViewState();
}

class _PendingReportViewState extends State<_PendingReportView> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              _DateBox(
                label: 'Pending Month',
                dateText: widget.selectedMonth == null
                    ? 'All Months'
                    : DateFormat('MMM yyyy').format(widget.selectedMonth!),
                onTap: widget.onPickMonth,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 48,
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Staff Name')),
                        DataColumn(label: Text('Staff ID')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Month & Year')),
                        DataColumn(label: Text('Basic Salary')),
                        DataColumn(label: Text('Allowance')),
                        DataColumn(label: Text('Net Salary')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        ...widget.records.map(
                          (record) => DataRow(
                            cells: [
                              DataCell(Text(record.staffName)),
                              DataCell(Text(record.staffId)),
                              DataCell(Text(record.role)),
                              DataCell(Text(record.formattedMonth)),
                              DataCell(Text(widget.currency.format(record.basicSalary))),
                              DataCell(Text(widget.currency.format(record.allowance))),
                              DataCell(Text(widget.currency.format(record.netSalary))),
                              const DataCell(Text('Pending')),
                            ],
                          ),
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                'Totals',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
                            DataCell(Text(widget.currency.format(widget.totals['basic'] ?? 0))),
                            DataCell(Text(widget.currency.format(widget.totals['allowance'] ?? 0))),
                            DataCell(Text(widget.currency.format(widget.totals['net'] ?? 0))),
                            const DataCell(Text('')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: textStyle,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return SizedBox(
      width: 200,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_view_month_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM yyyy').format(date),
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.dateText, this.onTap});

  final String label;
  final String dateText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return SizedBox(
      width: 200,
      height: 48,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.event_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dateText,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientScrollbar extends StatefulWidget {
  const _GradientScrollbar({
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<_GradientScrollbar> createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<_GradientScrollbar> {
  bool _isDragging = false;
  double _dragStartPosition = 0.0;
  double _dragStartScrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!widget.controller.hasClients) {
                return const SizedBox.shrink();
              }

              return AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final maxScrollExtent = widget.controller.position.maxScrollExtent;
                  final minScrollExtent = widget.controller.position.minScrollExtent;
                  final scrollExtent = maxScrollExtent - minScrollExtent;

                  if (scrollExtent <= 0) {
                    return const SizedBox.shrink();
                  }

                  final viewportDimension = widget.controller.position.viewportDimension;
                  final thumbExtent = (viewportDimension / (scrollExtent + viewportDimension)) * constraints.maxWidth;
                  final scrollOffset = widget.controller.position.pixels - minScrollExtent;
                  final thumbOffset = (scrollOffset / scrollExtent) * (constraints.maxWidth - thumbExtent);

                  return GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragStartPosition = details.localPosition.dx;
                        _dragStartScrollOffset = widget.controller.position.pixels;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final delta = details.localPosition.dx - _dragStartPosition;
                        final scrollDelta = (delta / (constraints.maxWidth - thumbExtent)) * scrollExtent;
                        final newScrollOffset = (_dragStartScrollOffset + scrollDelta).clamp(
                          minScrollExtent,
                          maxScrollExtent,
                        );
                        widget.controller.jumpTo(newScrollOffset);
                      }
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Stack(
                        children: [
                          Positioned(
                            left: thumbOffset.clamp(0.0, constraints.maxWidth - thumbExtent),
                            width: thumbExtent.clamp(20.0, constraints.maxWidth),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF8C6A2F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

