import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/loan_receipt_report_controller.dart';

part 'loan_receipt_report_ui_builders.dart';

class LoanReceiptReportView extends StatefulWidget {
  const LoanReceiptReportView({super.key});

  @override
  State<LoanReceiptReportView> createState() => _LoanReceiptReportViewState();
}

class _LoanReceiptReportViewState extends State<LoanReceiptReportView>
    with TickerProviderStateMixin {
  late final LoanReceiptReportController controller;
  late TabController tabController;

  LoanReceiptRecord? _selected;
  bool _showEditTab = false;
  bool _showPrintTab = false;

  final TextEditingController editPaymentModeCtrl = TextEditingController();
  final TextEditingController editPrincipalCtrl = TextEditingController();
  final TextEditingController editInterestCtrl = TextEditingController();
  final TextEditingController editOdCtrl = TextEditingController();
  final TextEditingController editReceiptCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = LoanReceiptReportController();
    _initTabController();
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    controller.dispose();
    editPaymentModeCtrl.dispose();
    editPrincipalCtrl.dispose();
    editInterestCtrl.dispose();
    editOdCtrl.dispose();
    editReceiptCtrl.dispose();
    editRemarksCtrl.dispose();
    super.dispose();
  }

  void _initTabController({int initialIndex = 0}) {
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: initialIndex.clamp(0, _tabCount - 1),
    );
    tabController.addListener(_handleTabChange);
  }

  void _reinitializeTabController({int initialIndex = 0}) {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    _initTabController(initialIndex: initialIndex);
  }

  int get _tabCount => 1 + (_showEditTab ? 1 : 0) + (_showPrintTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? 1 : -1;
  int get _printTabIndex {
    if (!_showPrintTab) return -1;
    return _showEditTab ? 2 : 1;
  }
  bool get _isEditing => _showEditTab && _selected != null;
  String get _editLockMessage =>
      'Please update, delete, or cancel before leaving edit.';

  void _selectRecord(LoanReceiptRecord record) {
    final shouldAddEditTab = !_showEditTab;
    setState(() {
      _showEditTab = true;
      _showPrintTab = false;
      _selected = record;
      editPaymentModeCtrl.text = record.paymentMode;
      editPrincipalCtrl.text = record.principalAmount.toStringAsFixed(2);
      editInterestCtrl.text = record.interestAmount.toStringAsFixed(2);
      editOdCtrl.text = record.odAmount.toStringAsFixed(2);
      editReceiptCtrl.text = record.receiptAmount.toStringAsFixed(2);
      editRemarksCtrl.text = record.remarks;
    });
    if (shouldAddEditTab) {
      _reinitializeTabController(initialIndex: _editTabIndex);
    } else {
      tabController.animateTo(_editTabIndex);
    }
  }

  void _updateRecord() {
    final record = _selected;
    if (record == null) {
      _showSnack('Select a receipt to edit.');
      return;
    }
    if (!controller.canModify(record.receiptId)) {
      _showSnack('Only the latest receipt can be edited.');
      return;
    }
    final updated = record.copyWith(
      paymentMode: editPaymentModeCtrl.text.trim(),
      principalAmount: double.tryParse(editPrincipalCtrl.text) ?? record.principalAmount,
      interestAmount: double.tryParse(editInterestCtrl.text) ?? record.interestAmount,
      odAmount: double.tryParse(editOdCtrl.text) ?? record.odAmount,
      receiptAmount: double.tryParse(editReceiptCtrl.text) ?? record.receiptAmount,
      remarks: editRemarksCtrl.text.trim(),
    );
    controller.updateRecord(record.receiptId, updated);
    setState(() => _selected = updated);
    _showSnack('Receipt updated successfully.');
  }

  void _deleteRecord(LoanReceiptRecord record) async {
    if (!controller.canModify(record.receiptId)) {
      _showSnack('Only the latest receipt can be deleted.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Receipt'),
        content: const Text(
          'Are you sure you want to delete this loan receipt entry? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      controller.deleteRecord(record.receiptId);
      if (_selected?.receiptId == record.receiptId) {
        _hideEditTab();
      }
      _showSnack('Receipt deleted.');
    }
  }

  void _handleCancelEdit() {
    _hideEditTab();
  }

  void _handleDeleteSelected() {
    final record = _selected;
    if (record == null) {
      _showSnack('Select a receipt to delete.');
      return;
    }
    _deleteRecord(record);
  }

  void _hideEditTab() {
    if (!_showEditTab) {
      setState(() => _selected = null);
      return;
    }
    setState(() {
      _selected = null;
      _showEditTab = false;
    });
    _showPrintTab = false;
    _reinitializeTabController();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleTabChange() {
    if (!_isEditing || tabController.indexIsChanging) {
      return;
    }
    final index = tabController.index;
    if (_isAllowedTabIndex(index)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final previousIndex =
          tabController.previousIndex.clamp(0, tabController.length - 1);
      tabController.animateTo(previousIndex);
      _showSnack(_currentLockMessage);
    });
  }

  void _handleTabTap(int index) {
    if (!_isEditing) return;
    if (_isAllowedTabIndex(index)) return;
    _showSnack(_currentLockMessage);
    tabController.animateTo(tabController.index);
  }

  bool _isAllowedTabIndex(int index) {
    if (_isEditing && _showPrintTab) {
      return index == _editTabIndex || index == _printTabIndex;
    }
    if (_isEditing) return index == _editTabIndex;
    return true;
  }

  String get _currentLockMessage => _editLockMessage;

  void _openPrintPreview() {
    final shouldAddPrintTab = !_showPrintTab;
    setState(() {
      _showPrintTab = true;
    });
    if (shouldAddPrintTab) {
      _reinitializeTabController(initialIndex: _printTabIndex);
    } else {
      tabController.animateTo(_printTabIndex);
    }
  }

  void _closePrintPreview() {
    if (!_showPrintTab) return;
    setState(() => _showPrintTab = false);
    final targetIndex = _showEditTab ? _editTabIndex : 0;
    _reinitializeTabController(
      initialIndex: targetIndex.clamp(0, _tabCount - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = controller.records;
    final totalReceipt = records.fold<double>(
      0,
      (sum, record) => sum + record.receiptAmount,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final latest = controller.latestRecord?.receiptId ?? '—';
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
                            const Icon(Icons.receipt_long_outlined,
                                color: AppColors.primary, size: 26),
                            const SizedBox(width: 12),
                            const Text(
                              'Loan Receipt Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 24),
                            _Stat(label: 'Receipts', value: '${records.length}'),
                            const SizedBox(width: 16),
                            _Stat(label: 'Total Collected', value: controller.formatCurrency(totalReceipt)),
                            const SizedBox(width: 16),
                            _Stat(label: 'Last Receipt', value: latest),
                          ],
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        onTap: _handleTabTap,
                        labelColor: AppColors.primary,
                        unselectedLabelColor:
                            AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        tabs: [
                          const Tab(text: 'Receipts'),
                          if (_showEditTab) const Tab(text: 'Edit'),
                          if (_showPrintTab) const Tab(text: 'Print Preview'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: _isEditing
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          children: [
                            _ReceiptsTab(
                              controller: controller,
                              onSelect: _selectRecord,
                              locked: _isEditing,
                              lockMessage: _editLockMessage,
                            ),
                            if (_showEditTab)
                              _EditTab(
                                controller: controller,
                                selected: _selected,
                                canModify: (id) => controller.canModify(id),
                                paymentModeCtrl: editPaymentModeCtrl,
                                principalCtrl: editPrincipalCtrl,
                                interestCtrl: editInterestCtrl,
                                odCtrl: editOdCtrl,
                                receiptCtrl: editReceiptCtrl,
                                remarksCtrl: editRemarksCtrl,
                                onSave: _updateRecord,
                                onCancel: _handleCancelEdit,
                                onDelete: _handleDeleteSelected,
                                onPrint: _openPrintPreview,
                              ),
                            if (_showPrintTab)
                              _PrintTab(
                                controller: controller,
                                records: controller.records,
                                locked: false,
                                lockMessage: null,
                                onCancel: _closePrintPreview,
                                onPrintComplete: _closePrintPreview,
                                onDownloadComplete: _closePrintPreview,
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

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}


