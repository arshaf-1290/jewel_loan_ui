import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/loan_receipt_controller.dart';
import 'loan_receipt_ui_builders.dart';

class LoanReceiptView extends StatefulWidget {
  const LoanReceiptView({super.key});

  @override
  State<LoanReceiptView> createState() => _LoanReceiptViewState();
}

class _LoanReceiptViewState extends State<LoanReceiptView>
    with TickerProviderStateMixin {
  late final LoanReceiptController controller;
  late TabController tabController;

  // Entry form controllers
  final TextEditingController loanIdCtrl = TextEditingController();
  final TextEditingController customerNameCtrl = TextEditingController();
  final TextEditingController mobileNumberCtrl = TextEditingController();
  final TextEditingController handledByCtrl = TextEditingController();
  final TextEditingController amountReceivedCtrl = TextEditingController();
  final TextEditingController interestComponentCtrl = TextEditingController();
  final TextEditingController principalComponentCtrl = TextEditingController();
  final TextEditingController lateFeeCtrl = TextEditingController(text: '0');
  final TextEditingController totalReceiptValueCtrl = TextEditingController();
  final TextEditingController referenceTransactionIdCtrl = TextEditingController();
  final TextEditingController voucherNumberCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController totalOutstandingCtrl = TextEditingController();
  final TextEditingController interestRebateCtrl = TextEditingController(text: '0');
  final TextEditingController penaltyChargesCtrl = TextEditingController(text: '0');
  final TextEditingController finalSettlementAmountCtrl = TextEditingController();
  final TextEditingController closureReferenceIdCtrl = TextEditingController();
  final TextEditingController closedByCtrl = TextEditingController();
  final TextEditingController closureRemarksCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();

  // Edit form controllers
  final TextEditingController editAmountReceivedCtrl = TextEditingController();
  final TextEditingController editInterestComponentCtrl = TextEditingController();
  final TextEditingController editPrincipalComponentCtrl = TextEditingController();
  final TextEditingController editLateFeeCtrl = TextEditingController();
  final TextEditingController editTotalReceiptValueCtrl = TextEditingController();
  final TextEditingController editReferenceTransactionIdCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();
  final TextEditingController editInterestRebateCtrl = TextEditingController();
  final TextEditingController editPenaltyChargesCtrl = TextEditingController();
  final TextEditingController editFinalSettlementAmountCtrl = TextEditingController();
  final TextEditingController editClosureReferenceIdCtrl = TextEditingController();
  final TextEditingController editClosureRemarksCtrl = TextEditingController();

  DateTime _receiptDate = DateTime.now();
  PaymentType _paymentType = PaymentType.emi;
  PaymentMode _paymentMode = PaymentMode.cash;
  ReceiptStatus _status = ReceiptStatus.received;
  DateTime? _nextDueDate;
  CloseType? _closeType;
  DateTime? _closureDate;
  PaymentMode? _closurePaymentMode;
  AccountClosureStatus? _accountClosureStatus;

  // Edit state
  LoanReceiptRecord? _selectedReceipt;
  bool _showEditTab = false;
  PaymentType _editPaymentType = PaymentType.emi;
  PaymentMode _editPaymentMode = PaymentMode.cash;
  ReceiptStatus _editStatus = ReceiptStatus.received;
  CloseType? _editCloseType;
  AccountClosureStatus? _editAccountClosureStatus;
  PaymentMode? _editClosurePaymentMode;

  // View scroll controller
  final ScrollController _viewScrollController = ScrollController();

  void _initTabController({int initialIndex = 0}) {
    final length = _showEditTab ? 3 : 2;
    tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: initialIndex.clamp(0, length - 1),
    );
    tabController.addListener(_handleTabChange);
  }
  void _reinitializeTabController({int initialIndex = 0}) {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    _initTabController(initialIndex: initialIndex);
  }

  void _handleTabChange() {
    if (!_showEditTab) return;
    if (!tabController.indexIsChanging &&
        tabController.index != tabController.length - 1) {
      final target = tabController.length - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_showEditTab) return;
        tabController.animateTo(target);
        _showSnackBar('Please update, delete, or cancel before leaving edit.');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = LoanReceiptController();
    _initTabController(initialIndex: 0);
    voucherNumberCtrl.text = controller.generateNextVoucherNumber(_receiptDate);
    
    // Auto-calculate total receipt value
    amountReceivedCtrl.addListener(_calculateTotalReceipt);
    interestComponentCtrl.addListener(_calculateTotalReceipt);
    principalComponentCtrl.addListener(_calculateTotalReceipt);
    lateFeeCtrl.addListener(_calculateTotalReceipt);
  }

  void _calculateTotalReceipt() {
    final amount = double.tryParse(amountReceivedCtrl.text) ?? 0;
    final interest = double.tryParse(interestComponentCtrl.text) ?? 0;
    final principal = double.tryParse(principalComponentCtrl.text) ?? 0;
    final fee = double.tryParse(lateFeeCtrl.text) ?? 0;
    final total = principal + interest + fee;
    totalReceiptValueCtrl.text = total.toStringAsFixed(2);
    if (amount > 0 && totalReceiptValueCtrl.text != amount.toStringAsFixed(2)) {
      // Auto-update if amount received is set
      totalReceiptValueCtrl.text = amount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    controller.dispose();
    _viewScrollController.dispose();
    loanIdCtrl.dispose();
    customerNameCtrl.dispose();
    mobileNumberCtrl.dispose();
    handledByCtrl.dispose();
    amountReceivedCtrl.dispose();
    interestComponentCtrl.dispose();
    principalComponentCtrl.dispose();
    lateFeeCtrl.dispose();
    totalReceiptValueCtrl.dispose();
    referenceTransactionIdCtrl.dispose();
    voucherNumberCtrl.dispose();
    remarksCtrl.dispose();
    totalOutstandingCtrl.dispose();
    interestRebateCtrl.dispose();
    penaltyChargesCtrl.dispose();
    finalSettlementAmountCtrl.dispose();
    closureReferenceIdCtrl.dispose();
    closedByCtrl.dispose();
    closureRemarksCtrl.dispose();
    branchCtrl.dispose();
    editAmountReceivedCtrl.dispose();
    editInterestComponentCtrl.dispose();
    editPrincipalComponentCtrl.dispose();
    editLateFeeCtrl.dispose();
    editTotalReceiptValueCtrl.dispose();
    editReferenceTransactionIdCtrl.dispose();
    editRemarksCtrl.dispose();
    editInterestRebateCtrl.dispose();
    editPenaltyChargesCtrl.dispose();
    editFinalSettlementAmountCtrl.dispose();
    editClosureReferenceIdCtrl.dispose();
    editClosureRemarksCtrl.dispose();
    super.dispose();
  }

  void _resetEntryForm() {
    loanIdCtrl.clear();
    customerNameCtrl.clear();
    mobileNumberCtrl.clear();
    handledByCtrl.clear();
    amountReceivedCtrl.clear();
    interestComponentCtrl.clear();
    principalComponentCtrl.clear();
    lateFeeCtrl.text = '0';
    totalReceiptValueCtrl.clear();
    referenceTransactionIdCtrl.clear();
    voucherNumberCtrl.text = controller.generateNextVoucherNumber(DateTime.now());
    remarksCtrl.clear();
    totalOutstandingCtrl.clear();
    interestRebateCtrl.text = '0';
    penaltyChargesCtrl.text = '0';
    finalSettlementAmountCtrl.clear();
    closureReferenceIdCtrl.clear();
    closedByCtrl.clear();
    closureRemarksCtrl.clear();
    branchCtrl.clear();
    _receiptDate = DateTime.now();
    _paymentType = PaymentType.emi;
    _paymentMode = PaymentMode.cash;
    _status = ReceiptStatus.received;
    _nextDueDate = null;
    _closeType = null;
    _closureDate = null;
    _closurePaymentMode = null;
    _accountClosureStatus = null;
  }

  void _handleSubmit() {
    if (loanIdCtrl.text.isEmpty || customerNameCtrl.text.isEmpty) {
      _showSnackBar('Please fill required fields');
      return;
    }

    final amount = double.tryParse(amountReceivedCtrl.text) ?? 0;
    final interest = double.tryParse(interestComponentCtrl.text) ?? 0;
    final principal = double.tryParse(principalComponentCtrl.text) ?? 0;
    final fee = double.tryParse(lateFeeCtrl.text) ?? 0;
    final total = double.tryParse(totalReceiptValueCtrl.text) ?? 0;

    final record = LoanReceiptRecord(
      receiptId: voucherNumberCtrl.text,
      receiptDate: _receiptDate,
      loanId: loanIdCtrl.text,
      customerName: customerNameCtrl.text,
      mobileNumber: mobileNumberCtrl.text,
      handledBy: handledByCtrl.text,
      paymentType: _paymentType,
      paymentMode: _paymentMode,
      amountReceived: amount,
      interestComponent: interest,
      principalComponent: principal,
      lateFee: fee,
      totalReceiptValue: total,
      referenceTransactionId: referenceTransactionIdCtrl.text.isEmpty ? null : referenceTransactionIdCtrl.text,
      voucherNumber: voucherNumberCtrl.text,
      nextDueDate: _nextDueDate,
      status: _status,
      remarks: remarksCtrl.text.isEmpty ? null : remarksCtrl.text,
      closeType: _closeType,
      closureDate: _closureDate,
      totalOutstandingBeforeClosure: totalOutstandingCtrl.text.isEmpty ? null : double.tryParse(totalOutstandingCtrl.text),
      interestRebate: interestRebateCtrl.text.isEmpty ? null : double.tryParse(interestRebateCtrl.text),
      penaltyForeclosureCharges: penaltyChargesCtrl.text.isEmpty ? null : double.tryParse(penaltyChargesCtrl.text),
      finalSettlementAmount: finalSettlementAmountCtrl.text.isEmpty ? null : double.tryParse(finalSettlementAmountCtrl.text),
      closurePaymentMode: _closurePaymentMode,
      closureReferenceId: closureReferenceIdCtrl.text.isEmpty ? null : closureReferenceIdCtrl.text,
      closedBy: closedByCtrl.text.isEmpty ? null : closedByCtrl.text,
      accountClosureStatus: _accountClosureStatus,
      closureRemarks: closureRemarksCtrl.text.isEmpty ? null : closureRemarksCtrl.text,
      branch: branchCtrl.text.isEmpty ? null : branchCtrl.text,
      createdBy: handledByCtrl.text,
      createdAt: DateTime.now(),
    );

    controller.addReceipt(record);
    _resetEntryForm();
    _showSnackBar('Loan receipt created successfully');
    tabController.animateTo(1); // Switch to View tab
  }

  void _selectForEdit(LoanReceiptRecord receipt) {
    final shouldShowEditTab = !_showEditTab;
    if (shouldShowEditTab) {
      setState(() {
        _showEditTab = true;
        _selectedReceipt = receipt;
        _editPaymentType = receipt.paymentType;
        _editPaymentMode = receipt.paymentMode;
        _editStatus = receipt.status;
        _editCloseType = receipt.closeType;
        _editAccountClosureStatus = receipt.accountClosureStatus;
        _editClosurePaymentMode = receipt.closurePaymentMode;
        _populateEditControllers(receipt);
        _reinitializeTabController(initialIndex: 2);
      });
    } else {
      setState(() {
        _selectedReceipt = receipt;
        _editPaymentType = receipt.paymentType;
        _editPaymentMode = receipt.paymentMode;
        _editStatus = receipt.status;
        _editCloseType = receipt.closeType;
        _editAccountClosureStatus = receipt.accountClosureStatus;
        _editClosurePaymentMode = receipt.closurePaymentMode;
        _populateEditControllers(receipt);
      });
      tabController.animateTo(tabController.length - 1);
    }
  }

  void _populateEditControllers(LoanReceiptRecord receipt) {
    editAmountReceivedCtrl.text = receipt.amountReceived.toStringAsFixed(2);
    editInterestComponentCtrl.text = receipt.interestComponent.toStringAsFixed(2);
    editPrincipalComponentCtrl.text = receipt.principalComponent.toStringAsFixed(2);
    editLateFeeCtrl.text = receipt.lateFee.toStringAsFixed(2);
    editTotalReceiptValueCtrl.text = receipt.totalReceiptValue.toStringAsFixed(2);
    editReferenceTransactionIdCtrl.text = receipt.referenceTransactionId ?? '';
    editRemarksCtrl.text = receipt.remarks ?? '';
    editInterestRebateCtrl.text = receipt.interestRebate?.toStringAsFixed(2) ?? '0';
    editPenaltyChargesCtrl.text = receipt.penaltyForeclosureCharges?.toStringAsFixed(2) ?? '0';
    editFinalSettlementAmountCtrl.text =
        receipt.finalSettlementAmount?.toStringAsFixed(2) ?? '';
    editClosureReferenceIdCtrl.text = receipt.closureReferenceId ?? '';
    editClosureRemarksCtrl.text = receipt.closureRemarks ?? '';
  }

  void _exitEditMode({int targetIndex = 1}) {
    if (!_showEditTab) return;
    setState(() {
      _showEditTab = false;
      _selectedReceipt = null;
      _reinitializeTabController(initialIndex: targetIndex);
    });
  }

  void _handleUpdate() {
    if (_selectedReceipt == null) {
      _showSnackBar('Select a receipt to edit');
      return;
    }

    final updated = _selectedReceipt!.copyWith(
      paymentMode: _editPaymentMode,
      amountReceived: double.tryParse(editAmountReceivedCtrl.text) ?? _selectedReceipt!.amountReceived,
      interestComponent: double.tryParse(editInterestComponentCtrl.text) ?? _selectedReceipt!.interestComponent,
      principalComponent: double.tryParse(editPrincipalComponentCtrl.text) ?? _selectedReceipt!.principalComponent,
      lateFee: double.tryParse(editLateFeeCtrl.text) ?? _selectedReceipt!.lateFee,
      totalReceiptValue: double.tryParse(editTotalReceiptValueCtrl.text) ?? _selectedReceipt!.totalReceiptValue,
      referenceTransactionId: editReferenceTransactionIdCtrl.text.isEmpty ? null : editReferenceTransactionIdCtrl.text,
      status: _editStatus,
      remarks: editRemarksCtrl.text.isEmpty ? null : editRemarksCtrl.text,
      closeType: _editCloseType,
      interestRebate: editInterestRebateCtrl.text.isEmpty ? null : double.tryParse(editInterestRebateCtrl.text),
      penaltyForeclosureCharges: editPenaltyChargesCtrl.text.isEmpty ? null : double.tryParse(editPenaltyChargesCtrl.text),
      finalSettlementAmount: editFinalSettlementAmountCtrl.text.isEmpty ? null : double.tryParse(editFinalSettlementAmountCtrl.text),
      closurePaymentMode: _editClosurePaymentMode,
      closureReferenceId: editClosureReferenceIdCtrl.text.isEmpty ? null : editClosureReferenceIdCtrl.text,
      accountClosureStatus: _editAccountClosureStatus,
      closureRemarks: editClosureRemarksCtrl.text.isEmpty ? null : editClosureRemarksCtrl.text,
    );

    controller.updateReceipt(_selectedReceipt!.receiptId, updated);
    _exitEditMode(targetIndex: 1);
    _showSnackBar('Receipt updated successfully');
  }

  Future<void> _handleDeleteSelected() async {
    final receipt = _selectedReceipt;
    if (receipt == null) {
      _showSnackBar('Select a receipt to delete');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Loan Receipt'),
        content: const Text(
          'Are you sure you want to delete this loan receipt? This action cannot be undone.',
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
      controller.deleteReceipt(receipt.receiptId);
      _exitEditMode(targetIndex: 1);
      _showSnackBar('Loan receipt deleted.');
    }
  }

  void _handleCancelEdit() {
    if (!_showEditTab) return;
    _exitEditMode(targetIndex: 1);
    _showSnackBar('Edit cancelled.');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickDate(DateTime initial, Function(DateTime) onSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelected(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Tab>[
      const Tab(text: 'Loan Receipt Entry'),
      const Tab(text: 'Loan Receipt View'),
      if (_showEditTab) const Tab(text: 'Loan Receipt Edit'),
    ];

    final tabViews = <Widget>[
      EntryTab(
        controller: controller,
        locked: _showEditTab,
        receiptDate: _receiptDate,
        onPickDate: () => _pickDate(_receiptDate, (d) => _receiptDate = d),
        paymentType: _paymentType,
        onPaymentTypeChanged: (v) => setState(() => _paymentType = v),
        paymentMode: _paymentMode,
        onPaymentModeChanged: (v) => setState(() => _paymentMode = v),
        status: _status,
        onStatusChanged: (v) => setState(() => _status = v),
        nextDueDate: _nextDueDate,
        onPickNextDueDate: () => _pickDate(
          _nextDueDate ?? DateTime.now(),
          (d) => setState(() => _nextDueDate = d),
        ),
        closeType: _closeType,
        onCloseTypeChanged: (v) => setState(() => _closeType = v),
        closureDate: _closureDate,
        onPickClosureDate: () => _pickDate(
          _closureDate ?? DateTime.now(),
          (d) => setState(() => _closureDate = d),
        ),
        closurePaymentMode: _closurePaymentMode,
        onClosurePaymentModeChanged: (v) =>
            setState(() => _closurePaymentMode = v),
        accountClosureStatus: _accountClosureStatus,
        onAccountClosureStatusChanged: (v) =>
            setState(() => _accountClosureStatus = v),
        loanIdCtrl: loanIdCtrl,
        customerNameCtrl: customerNameCtrl,
        mobileNumberCtrl: mobileNumberCtrl,
        handledByCtrl: handledByCtrl,
        amountReceivedCtrl: amountReceivedCtrl,
        interestComponentCtrl: interestComponentCtrl,
        principalComponentCtrl: principalComponentCtrl,
        lateFeeCtrl: lateFeeCtrl,
        totalReceiptValueCtrl: totalReceiptValueCtrl,
        referenceTransactionIdCtrl: referenceTransactionIdCtrl,
        voucherNumberCtrl: voucherNumberCtrl,
        remarksCtrl: remarksCtrl,
        totalOutstandingCtrl: totalOutstandingCtrl,
        interestRebateCtrl: interestRebateCtrl,
        penaltyChargesCtrl: penaltyChargesCtrl,
        finalSettlementAmountCtrl: finalSettlementAmountCtrl,
        closureReferenceIdCtrl: closureReferenceIdCtrl,
        closedByCtrl: closedByCtrl,
        closureRemarksCtrl: closureRemarksCtrl,
        branchCtrl: branchCtrl,
        onSubmit: _handleSubmit,
        onReset: _resetEntryForm,
      ),
      ViewTab(
        controller: controller,
        scrollController: _viewScrollController,
        locked: _showEditTab,
        onSelect: _selectForEdit,
      ),
      if (_showEditTab)
        EditTab(
          controller: controller,
          selected: _selectedReceipt,
          paymentType: _editPaymentType,
          onPaymentTypeChanged: (v) => setState(() => _editPaymentType = v),
          paymentMode: _editPaymentMode,
          onPaymentModeChanged: (v) => setState(() => _editPaymentMode = v),
          status: _editStatus,
          onStatusChanged: (v) => setState(() => _editStatus = v),
          closeType: _editCloseType,
          onCloseTypeChanged: (v) => setState(() => _editCloseType = v),
          accountClosureStatus: _editAccountClosureStatus,
          onAccountClosureStatusChanged: (v) =>
              setState(() => _editAccountClosureStatus = v),
          closurePaymentMode: _editClosurePaymentMode,
          onClosurePaymentModeChanged: (v) =>
              setState(() => _editClosurePaymentMode = v),
          amountReceivedCtrl: editAmountReceivedCtrl,
          interestComponentCtrl: editInterestComponentCtrl,
          principalComponentCtrl: editPrincipalComponentCtrl,
          lateFeeCtrl: editLateFeeCtrl,
          totalReceiptValueCtrl: editTotalReceiptValueCtrl,
          referenceTransactionIdCtrl: editReferenceTransactionIdCtrl,
          remarksCtrl: editRemarksCtrl,
          interestRebateCtrl: editInterestRebateCtrl,
          penaltyChargesCtrl: editPenaltyChargesCtrl,
          finalSettlementAmountCtrl: editFinalSettlementAmountCtrl,
          closureReferenceIdCtrl: editClosureReferenceIdCtrl,
          closureRemarksCtrl: editClosureRemarksCtrl,
          onUpdate: _handleUpdate,
          onDelete: _handleDeleteSelected,
          onCancel: _handleCancelEdit,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: AnimatedBuilder(
                animation: controller,
        builder: (context, _) {
          return Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: TabBar(
                    controller: tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor:
                        AppColors.onSurface.withOpacity(0.6),
                    indicatorColor: AppColors.primary,
                    tabs: tabs,
                  ),
                ),
                const Divider(height: 1),
            Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: tabViews,
              ),
            ),
          ],
        ),
          );
        },
      ),
    );
  }
}



