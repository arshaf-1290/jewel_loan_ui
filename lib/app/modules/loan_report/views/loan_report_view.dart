import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/loan_report_controller.dart';

part 'loan_report_ui_builders.dart';

class LoanReportView extends StatefulWidget {
  const LoanReportView({super.key});

  @override
  State<LoanReportView> createState() => _LoanReportViewState();
}

class _LoanReportViewState extends State<LoanReportView>
    with TickerProviderStateMixin {
  late final LoanReportController controller;
  late TabController tabController;
  bool _showEditTab = false;
  bool _showPrintTab = false;
  bool _isPrinting = false;
  bool _canLeavePrintPreview = false;

  void _handlePrint() async {
    setState(() => _isPrinting = true);
    // TODO: Implement actual print logic here
    await Future.delayed(const Duration(seconds: 1)); // Simulate print delay
    setState(() {
      _isPrinting = false;
      _canLeavePrintPreview = true;
    });
    _showSnackBar('Printing completed');
    _resetPrintPreview();
  }

  void _handleDownload() async {
    setState(() => _isPrinting = true);
    // TODO: Implement actual download logic here
    await Future.delayed(const Duration(seconds: 1)); // Simulate download delay
    setState(() {
      _isPrinting = false;
      _canLeavePrintPreview = true;
    });
    _showSnackBar('Download completed');
    _resetPrintPreview();
  }

  void _handleCancelPrint() {
    setState(() {
      _canLeavePrintPreview = true;
    });
    _resetPrintPreview();
  }

  void _resetPrintPreview() {
    if (!mounted) return;
    final targetIndex = _showEditTab ? 1 : 0;
    setState(() {
      _showPrintTab = false;
      _canLeavePrintPreview = false;
      _isPrinting = false;
    });
    _reinitializeTabController(initialIndex: targetIndex);
  }

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _filterLoanType = 'All';
  final TextEditingController recommenderCtrl = TextEditingController();
  final TextEditingController guarantorCtrl = TextEditingController();
  final TextEditingController customerCtrl = TextEditingController();
  final TextEditingController loanNoCtrl = TextEditingController();

  // Entry controllers
  DateTime _entryDate = DateTime.now();
  final TextEditingController entryLoanNoCtrl = TextEditingController();
  final TextEditingController entryCustomerCtrl = TextEditingController();
  final TextEditingController entryMobileCtrl = TextEditingController();
  String _entryLoanType = 'Gold Loan';
  final TextEditingController entryLoanAmountCtrl =
      TextEditingController(text: '0');
  String _entryInterestType = 'Monthly';
  final TextEditingController entryInterestPercentCtrl =
      TextEditingController(text: '12');
  final TextEditingController entryDueAmountCtrl =
      TextEditingController(text: '0');
  final TextEditingController entryOdPercentCtrl =
      TextEditingController(text: '0');
  final TextEditingController entryOdAmountCtrl =
      TextEditingController(text: '0');
  final TextEditingController entryAdvanceReceiptCtrl =
      TextEditingController(text: '0');
  final TextEditingController entryDocAmountCtrl =
      TextEditingController(text: '0');
  final TextEditingController entryRemarksCtrl = TextEditingController();
  final TextEditingController entryRecommenderCtrl = TextEditingController();
  final TextEditingController entryGuarantorCtrl = TextEditingController();
  int _entryExtraDays = 0;
  DateTime? _entryRevisedDue;
  final TextEditingController entryExtraInterestCtrl =
      TextEditingController(text: '0');
  bool _showAdvancedEntry = false;

  // Edit state
  LoanReportEntry? _selectedForEdit;
  String _editLoanType = 'Gold Loan';
  String _editInterestType = 'Monthly';
  final TextEditingController editLoanAmountCtrl = TextEditingController();
  final TextEditingController editInterestPercentCtrl =
      TextEditingController();
  final TextEditingController editDueAmountCtrl = TextEditingController();
  final TextEditingController editOdPercentCtrl = TextEditingController();
  final TextEditingController editOdAmountCtrl = TextEditingController();
  final TextEditingController editAdvanceCtrl = TextEditingController();
  final TextEditingController editDocCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();

  final TextEditingController deleteReasonCtrl = TextEditingController();

  int get _tabCount =>
      1 + (_showEditTab ? 1 : 0) + (_showPrintTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? 1 : -1;
  int get _printTabIndex => _showPrintTab ? _tabCount - 1 : -1;

  void _initTabController({int initialIndex = 0}) {
    final length = _tabCount;
    final clampedIndex = initialIndex.clamp(0, length - 1);
    tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: clampedIndex,
    );
    tabController.addListener(_handleTabChange);
  }

  void _reinitializeTabController({int initialIndex = 0}) {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    _initTabController(initialIndex: initialIndex);
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) return;

    if (_showEditTab && _editTabIndex != -1) {
      final tryingToLeaveEdit = tabController.index != _editTabIndex &&
          !(_showPrintTab && tabController.index == _printTabIndex);
      if (tryingToLeaveEdit) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_showEditTab) return;
          tabController.animateTo(_editTabIndex);
          _showSnackBar(
            'Please update, delete, or cancel before leaving edit.',
          );
        });
        return;
      }
    }

    if (!_showPrintTab || _printTabIndex == -1) return;
    if (tabController.index != _printTabIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_showPrintTab || _canLeavePrintPreview) return;
        tabController.animateTo(_printTabIndex);
        _showSnackBar(
          'Please complete the print action (Print or Download) or click Cancel before navigating away from Print Preview.',
        );
      });
    }
  }


  @override
  void initState() {
    super.initState();
    controller = LoanReportController();
    _initTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    controller.dispose();
    recommenderCtrl.dispose();
    guarantorCtrl.dispose();
    customerCtrl.dispose();
    loanNoCtrl.dispose();
    entryLoanNoCtrl.dispose();
    entryCustomerCtrl.dispose();
    entryMobileCtrl.dispose();
    entryLoanAmountCtrl.dispose();
    entryInterestPercentCtrl.dispose();
    entryDueAmountCtrl.dispose();
    entryOdPercentCtrl.dispose();
    entryOdAmountCtrl.dispose();
    entryAdvanceReceiptCtrl.dispose();
    entryDocAmountCtrl.dispose();
    entryRemarksCtrl.dispose();
    entryRecommenderCtrl.dispose();
    entryGuarantorCtrl.dispose();
    entryExtraInterestCtrl.dispose();
    editLoanAmountCtrl.dispose();
    editInterestPercentCtrl.dispose();
    editDueAmountCtrl.dispose();
    editOdPercentCtrl.dispose();
    editOdAmountCtrl.dispose();
    editAdvanceCtrl.dispose();
    editDocCtrl.dispose();
    editRemarksCtrl.dispose();
    deleteReasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) onSelected(picked);
  }

  void _toggleAdvancedEntry() {
    setState(() => _showAdvancedEntry = !_showAdvancedEntry);
  }

  void _openPrintTab() {
    if (_showPrintTab) {
      tabController.animateTo(_printTabIndex);
      _canLeavePrintPreview = false;
      return;
    }
    setState(() {
      _showPrintTab = true;
      _canLeavePrintPreview = false;
    });
    _reinitializeTabController(initialIndex: _printTabIndex);
  }

  void _handleCreateEntry() {
    if (entryLoanNoCtrl.text.trim().isEmpty ||
        entryCustomerCtrl.text.trim().isEmpty) {
      _showSnackBar('Loan No and Customer Name are required.');
      return;
    }
    final entry = LoanReportEntry(
      loanNo: entryLoanNoCtrl.text.trim(),
      loanDate: _entryDate,
      customerName: entryCustomerCtrl.text.trim(),
      mobileNumber: entryMobileCtrl.text.trim(),
      loanType: _entryLoanType,
      loanAmount: double.tryParse(entryLoanAmountCtrl.text) ?? 0,
      interestType: _entryInterestType,
      interestPercent: double.tryParse(entryInterestPercentCtrl.text) ?? 0,
      dueAmount: double.tryParse(entryDueAmountCtrl.text) ?? 0,
      odPercent: double.tryParse(entryOdPercentCtrl.text) ?? 0,
      odAmount: double.tryParse(entryOdAmountCtrl.text) ?? 0,
      advanceReceipt: double.tryParse(entryAdvanceReceiptCtrl.text) ?? 0,
      documentAmount: double.tryParse(entryDocAmountCtrl.text) ?? 0,
      remarks: entryRemarksCtrl.text.trim(),
      recommenderName: entryRecommenderCtrl.text.trim().isEmpty
          ? null
          : entryRecommenderCtrl.text.trim(),
      guarantorName: entryGuarantorCtrl.text.trim().isEmpty
          ? null
          : entryGuarantorCtrl.text.trim(),
      extraDaysAdded: _entryExtraDays,
      revisedDueDate: _entryRevisedDue,
      extraInterest: double.tryParse(entryExtraInterestCtrl.text) ?? 0,
    );
    controller.addEntry(entry);
    _showSnackBar('Loan entry recorded.');
    _resetEntryForm();
  }

  void _resetEntryForm() {
    entryLoanNoCtrl.clear();
    entryCustomerCtrl.clear();
    entryMobileCtrl.clear();
    entryLoanAmountCtrl.text = '0';
    entryInterestPercentCtrl.text = '12';
    entryDueAmountCtrl.text = '0';
    entryOdPercentCtrl.text = '0';
    entryOdAmountCtrl.text = '0';
    entryAdvanceReceiptCtrl.text = '0';
    entryDocAmountCtrl.text = '0';
    entryRemarksCtrl.clear();
    entryRecommenderCtrl.clear();
    entryGuarantorCtrl.clear();
    entryExtraInterestCtrl.text = '0';
    setState(() {
      _entryDate = DateTime.now();
      _entryLoanType = controller.loanTypes.first;
      _entryInterestType = 'Monthly';
      _entryExtraDays = 0;
      _entryRevisedDue = null;
      _showAdvancedEntry = false;
    });
  }

  void _selectForEdit(LoanReportEntry entry) {
    final shouldShowEditTab = !_showEditTab;
    setState(() {
      _showEditTab = true;
      _selectedForEdit = entry;
      _editLoanType = entry.loanType;
      _editInterestType = entry.interestType;
      editLoanAmountCtrl.text = entry.loanAmount.toStringAsFixed(2);
      editInterestPercentCtrl.text = entry.interestPercent.toStringAsFixed(2);
      editDueAmountCtrl.text = entry.dueAmount.toStringAsFixed(2);
      editOdPercentCtrl.text = entry.odPercent.toStringAsFixed(2);
      editOdAmountCtrl.text = entry.odAmount.toStringAsFixed(2);
      editAdvanceCtrl.text = entry.advanceReceipt.toStringAsFixed(2);
      editDocCtrl.text = entry.documentAmount.toStringAsFixed(2);
      editRemarksCtrl.text = entry.remarks;
    });
    if (shouldShowEditTab) {
      _reinitializeTabController(initialIndex: _editTabIndex);
    } else if (_editTabIndex != -1) {
      tabController.animateTo(_editTabIndex);
    }
  }

  void _exitEditMode({int targetIndex = 0}) {
    if (!_showEditTab) return;
    setState(() {
      _showEditTab = false;
      _selectedForEdit = null;
    });
    _reinitializeTabController(initialIndex: targetIndex);
  }

  Future<void> _handleDeleteSelected() async {
    final entry = _selectedForEdit;
    if (entry == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Loan Report'),
        content: Text(
          'Are you sure you want to delete ${entry.loanNo}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      controller.deleteEntry(entry.loanNo);
      _exitEditMode();
      _showSnackBar('Loan report deleted.');
    }
  }

  void _handleCancelEdit() {
    _exitEditMode();
  }

  void _handleUpdate() {
    final entry = _selectedForEdit;
    if (entry == null) {
      _showSnackBar('Select a record to edit.');
      return;
    }
    final updated = entry.copyWith(
      loanAmount: double.tryParse(editLoanAmountCtrl.text) ?? entry.loanAmount,
      interestType: _editInterestType,
      interestPercent:
          double.tryParse(editInterestPercentCtrl.text) ?? entry.interestPercent,
      dueAmount: double.tryParse(editDueAmountCtrl.text) ?? entry.dueAmount,
      odPercent: double.tryParse(editOdPercentCtrl.text) ?? entry.odPercent,
      odAmount: double.tryParse(editOdAmountCtrl.text) ?? entry.odAmount,
      advanceReceipt:
          double.tryParse(editAdvanceCtrl.text) ?? entry.advanceReceipt,
      documentAmount: double.tryParse(editDocCtrl.text) ?? entry.documentAmount,
      loanType: _editLoanType,
      remarks: editRemarksCtrl.text.trim(),
    );
    controller.updateEntry(entry.loanNo, updated);
    _showSnackBar('Loan report updated.');
    _exitEditMode(targetIndex: 0);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  List<LoanReportEntry> get _filteredEntries => controller.filterEntries(
        fromDate: _fromDate,
        toDate: _toDate,
        loanType: _filterLoanType,
        recommender: recommenderCtrl.text,
        guarantor: guarantorCtrl.text,
        customer: customerCtrl.text,
        loanNo: loanNoCtrl.text,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final entries = _filteredEntries;
          final totalAmount = controller.sumLoanAmount(entries);
          final totalDue = controller.sumDueAmount(entries);
          final totalOd = controller.sumOdAmount(entries);
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 5,
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor:
                            AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        tabs: [
                          const Tab(text: 'Loan Report'),
                          if (_showEditTab) const Tab(text: 'Edit Loan'),
                          if (_showPrintTab) const Tab(text: 'Print Preview'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: _showPrintTab && !_canLeavePrintPreview
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          children: [
                            _ReportTab(
                              controller: controller,
                              entries: entries,
                              fromDate: _fromDate,
                              toDate: _toDate,
                              onChangeFrom: (date) =>
                                  setState(() => _fromDate = date),
                              onChangeTo: (date) => setState(() => _toDate = date),
                              loanTypes: const ['All', ...[
                                'Gold Loan',
                                'Diamond Loan',
                                'Business Loan',
                                'Agriculture Loan',
                                'Personal Loan',
                              ]],
                              selectedLoanType: _filterLoanType,
                              onChangeLoanType: (value) =>
                                  setState(() => _filterLoanType = value),
                              recommenderCtrl: recommenderCtrl,
                              guarantorCtrl: guarantorCtrl,
                              customerCtrl: customerCtrl,
                              loanNoCtrl: loanNoCtrl,
                              onSearch: () => setState(() {}),
                              onPrint: _openPrintTab,
                              onSelect: _selectForEdit,
                              locked:
                                  _showEditTab || (_showPrintTab && !_canLeavePrintPreview),
                              lockMessage: _showPrintTab && !_canLeavePrintPreview
                                  ? 'Please complete the print action (Print or Download) or click Cancel before navigating away from Print Preview.'
                                  : _showEditTab
                                      ? 'Please update, delete, or cancel before leaving edit.'
                                      : null,
                            ),
                            if (_showEditTab)
                              _EditTab(
                                selected: _selectedForEdit,
                                loanTypes: controller.loanTypes,
                                loanType: _editLoanType,
                                onSelectLoanType: (value) =>
                                    setState(() => _editLoanType = value),
                                interestType: _editInterestType,
                                onSelectInterestType: (value) =>
                                    setState(() => _editInterestType = value),
                                loanAmountCtrl: editLoanAmountCtrl,
                                interestPercentCtrl: editInterestPercentCtrl,
                                dueAmountCtrl: editDueAmountCtrl,
                                odPercentCtrl: editOdPercentCtrl,
                                odAmountCtrl: editOdAmountCtrl,
                                advanceCtrl: editAdvanceCtrl,
                                docCtrl: editDocCtrl,
                                remarksCtrl: editRemarksCtrl,
                                onUpdate: _handleUpdate,
                                onCancel: _handleCancelEdit,
                                onDelete: _handleDeleteSelected,
                                onPrint: _openPrintTab,
                                locked: _showPrintTab && !_canLeavePrintPreview,
                              ),
                            if (_showPrintTab)
                              _PrintTab(
                                fromDate: _fromDate,
                                toDate: _toDate,
                                loanType: _filterLoanType,
                                recommender: recommenderCtrl.text,
                                guarantor: guarantorCtrl.text,
                                customer: customerCtrl.text,
                                loanNo: loanNoCtrl.text,
                                entries: entries,
                                controller: controller,
                                onPrint: _handlePrint,
                                onDownload: _handleDownload,
                                onCancel: _handleCancelPrint,
                                isPrinting: _isPrinting,
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


