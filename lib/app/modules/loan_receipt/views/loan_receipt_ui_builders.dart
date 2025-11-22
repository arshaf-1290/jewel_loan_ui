import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/loan_receipt_controller.dart';

class EntryTab extends StatelessWidget {
  const EntryTab({
    super.key,
    required this.controller,
    this.locked = false,
    required this.receiptDate,
    required this.onPickDate,
    required this.paymentType,
    required this.onPaymentTypeChanged,
    required this.paymentMode,
    required this.onPaymentModeChanged,
    required this.status,
    required this.onStatusChanged,
    required this.nextDueDate,
    this.onPickNextDueDate,
    required this.closeType,
    required this.onCloseTypeChanged,
    required this.closureDate,
    this.onPickClosureDate,
    required this.closurePaymentMode,
    required this.onClosurePaymentModeChanged,
    required this.accountClosureStatus,
    required this.onAccountClosureStatusChanged,
    required this.loanIdCtrl,
    required this.customerNameCtrl,
    required this.mobileNumberCtrl,
    required this.handledByCtrl,
    required this.amountReceivedCtrl,
    required this.interestComponentCtrl,
    required this.principalComponentCtrl,
    required this.lateFeeCtrl,
    required this.totalReceiptValueCtrl,
    required this.referenceTransactionIdCtrl,
    required this.voucherNumberCtrl,
    required this.remarksCtrl,
    required this.totalOutstandingCtrl,
    required this.interestRebateCtrl,
    required this.penaltyChargesCtrl,
    required this.finalSettlementAmountCtrl,
    required this.closureReferenceIdCtrl,
    required this.closedByCtrl,
    required this.closureRemarksCtrl,
    required this.branchCtrl,
    required this.onSubmit,
    required this.onReset,
  });

  final LoanReceiptController controller;
  final bool locked;
  final DateTime receiptDate;
  final VoidCallback onPickDate;
  final PaymentType paymentType;
  final ValueChanged<PaymentType> onPaymentTypeChanged;
  final PaymentMode paymentMode;
  final ValueChanged<PaymentMode> onPaymentModeChanged;
  final ReceiptStatus status;
  final ValueChanged<ReceiptStatus> onStatusChanged;
  final DateTime? nextDueDate;
  final VoidCallback? onPickNextDueDate;
  final CloseType? closeType;
  final ValueChanged<CloseType?> onCloseTypeChanged;
  final DateTime? closureDate;
  final VoidCallback? onPickClosureDate;
  final PaymentMode? closurePaymentMode;
  final ValueChanged<PaymentMode?> onClosurePaymentModeChanged;
  final AccountClosureStatus? accountClosureStatus;
  final ValueChanged<AccountClosureStatus?> onAccountClosureStatusChanged;
  final TextEditingController loanIdCtrl;
  final TextEditingController customerNameCtrl;
  final TextEditingController mobileNumberCtrl;
  final TextEditingController handledByCtrl;
  final TextEditingController amountReceivedCtrl;
  final TextEditingController interestComponentCtrl;
  final TextEditingController principalComponentCtrl;
  final TextEditingController lateFeeCtrl;
  final TextEditingController totalReceiptValueCtrl;
  final TextEditingController referenceTransactionIdCtrl;
  final TextEditingController voucherNumberCtrl;
  final TextEditingController remarksCtrl;
  final TextEditingController totalOutstandingCtrl;
  final TextEditingController interestRebateCtrl;
  final TextEditingController penaltyChargesCtrl;
  final TextEditingController finalSettlementAmountCtrl;
  final TextEditingController closureReferenceIdCtrl;
  final TextEditingController closedByCtrl;
  final TextEditingController closureRemarksCtrl;
  final TextEditingController branchCtrl;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  static const TextStyle textStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 11,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formContent = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: loanIdCtrl,
                    label: 'Loan ID / Pledge Number',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: customerNameCtrl,
                    label: 'Customer Name',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: mobileNumberCtrl,
                    label: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: handledByCtrl,
                    label: 'Handled By (Staff / Agent Name)',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Receipt Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: voucherNumberCtrl,
                    label: 'Voucher / Receipt Number',
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: InputDecorator(
                    decoration: fieldDecoration('Receipt Date'),
                    child: InkWell(
                      onTap: onPickDate,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(receiptDate),
                            style: textStyle,
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<PaymentMode>(
                    value: paymentMode,
                    decoration: fieldDecoration('Payment Mode'),
                    style: textStyle,
                    items: PaymentMode.values.map((mode) {
                      String label;
                      switch (mode) {
                        case PaymentMode.cash:
                          label = 'Cash';
                          break;
                        case PaymentMode.bankTransfer:
                          label = 'Bank Transfer';
                          break;
                        case PaymentMode.upi:
                          label = 'UPI';
                          break;
                        case PaymentMode.cheque:
                          label = 'Cheque';
                          break;
                      }
                      return DropdownMenuItem(value: mode, child: Text(label));
                    }).toList(),
                    onChanged: (value) => onPaymentModeChanged(value!),
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: amountReceivedCtrl,
                    label: 'Amount Received (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: interestComponentCtrl,
                    label: 'Interest Component (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: principalComponentCtrl,
                    label: 'Principal Component (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: lateFeeCtrl,
                    label: 'Late Fee / Penalty (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: totalReceiptValueCtrl,
                    label: 'Total Receipt Value (₹)',
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: InputDecorator(
                    decoration: fieldDecoration('Next Due Date'),
                    child: InkWell(
                      onTap: onPickNextDueDate,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nextDueDate == null
                                ? '—'
                                : DateFormat('dd-MMM-yyyy').format(nextDueDate!),
                            style: textStyle,
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppTextField(
              controller: remarksCtrl,
              label: 'Remarks / Notes',
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Account Close / Preclose Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Used when a customer closes or prepays their loan ahead of tenure.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<CloseType?>(
                    value: closeType,
                    decoration: fieldDecoration('Close Type'),
                    style: textStyle,
                    items: [
                      const DropdownMenuItem<CloseType?>(
                        value: null,
                        child: Text('—'),
                      ),
                      ...CloseType.values.map((type) {
                        String label;
                        switch (type) {
                          case CloseType.regularClosure:
                            label = 'Regular Closure';
                            break;
                          case CloseType.preclosure:
                            label = 'Preclosure';
                            break;
                        }
                        return DropdownMenuItem(value: type, child: Text(label));
                      }),
                    ],
                    onChanged: onCloseTypeChanged,
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: InputDecorator(
                    decoration: fieldDecoration('Closure Date'),
                    child: InkWell(
                      onTap: onPickClosureDate,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            closureDate == null
                                ? '—'
                                : DateFormat('dd-MMM-yyyy').format(closureDate!),
                            style: textStyle,
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: totalOutstandingCtrl,
                    label: 'Total Outstanding Before Closure (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: finalSettlementAmountCtrl,
                    label: 'Final Settlement Amount (₹)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<PaymentMode?>(
                    value: closurePaymentMode,
                    decoration: fieldDecoration('Payment Mode (for closure)'),
                    style: textStyle,
                    items: [
                      const DropdownMenuItem<PaymentMode?>(
                        value: null,
                        child: Text('—'),
                      ),
                      ...PaymentMode.values.map((mode) {
                        String label;
                        switch (mode) {
                          case PaymentMode.cash:
                            label = 'Cash';
                            break;
                          case PaymentMode.bankTransfer:
                            label = 'Bank Transfer';
                            break;
                          case PaymentMode.upi:
                            label = 'UPI';
                            break;
                          case PaymentMode.cheque:
                            label = 'Cheque';
                            break;
                        }
                        return DropdownMenuItem(value: mode, child: Text(label));
                      }),
                    ],
                    onChanged: onClosurePaymentModeChanged,
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: closureReferenceIdCtrl,
                    label: 'Reference / Transaction ID (for closure)',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: closedByCtrl,
                    label: 'Closed By (Staff / Admin)',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<AccountClosureStatus?>(
                    value: accountClosureStatus,
                    decoration: fieldDecoration('Account Closure Status'),
                    style: textStyle,
                    items: [
                      const DropdownMenuItem<AccountClosureStatus?>(
                        value: null,
                        child: Text('—'),
                      ),
                      ...AccountClosureStatus.values.map((s) {
                        String label;
                        switch (s) {
                          case AccountClosureStatus.closed:
                            label = 'Closed';
                            break;
                          case AccountClosureStatus.preclosed:
                            label = 'Preclosed';
                            break;
                          case AccountClosureStatus.pending:
                            label = 'Pending';
                            break;
                          case AccountClosureStatus.active:
                            label = 'Active';
                            break;
                        }
                        return DropdownMenuItem(value: s, child: Text(label));
                      }),
                    ],
                    onChanged: onAccountClosureStatusChanged,
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppTextField(
              controller: closureRemarksCtrl,
              label:
                  'Remarks (Example: Preclosed after 8 months with rebate adjustment)',
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: locked ? null : onReset,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: locked ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );

    if (!locked) {
      return formContent;
    }

    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: formContent),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.65),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Finish editing the selected receipt or cancel to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ViewTab extends StatelessWidget {
  const ViewTab({
    super.key,
    required this.controller,
    required this.scrollController,
    this.locked = false,
    required this.onSelect,
  });

  final LoanReceiptController controller;
  final ScrollController scrollController;
  final bool locked;
  final ValueChanged<LoanReceiptRecord> onSelect;

  @override
  Widget build(BuildContext context) {
    final canInteract = !locked;

    final viewContent = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOAN RECEIPT VIEW',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Read / Track Receipt Records',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor:
                        MaterialStateProperty.all(Colors.transparent),
                    thickness: MaterialStateProperty.all(8),
                    radius: const Radius.circular(4),
                  ),
                ),
                child: GradientScrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth:
                            MediaQuery.of(context).size.width - 48,
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Receipt Date')),
                          DataColumn(
                            label: Text('Receipt / Voucher No.'),
                          ),
                          DataColumn(label: Text('Customer Name')),
                          DataColumn(label: Text('Mobile Number')),
                          DataColumn(label: Text('Loan ID / Pledge No.')),
                          DataColumn(label: Text('Branch / Agent')),
                          DataColumn(label: Text('Payment Type')),
                          DataColumn(label: Text('Amount Received (₹)')),
                          DataColumn(label: Text('Payment Mode')),
                          DataColumn(label: Text('Transaction ID')),
                          DataColumn(label: Text('Close Type')),
                          DataColumn(
                            label: Text('Account Closure Status'),
                          ),
                          DataColumn(label: Text('Next Due Date')),
                          DataColumn(label: Text('Remarks')),
                        ],
                        rows: controller.receipts
                            .map(
                              (receipt) => DataRow(
                                cells: [
                                  DataCell(
                                    InkWell(
                                      onTap: canInteract
                                          ? () => onSelect(receipt)
                                          : null,
                                      child: Text(
                                        receipt.formattedDate,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.voucherNumber,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.customerName,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.mobileNumber,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.loanId,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.branch ?? '—',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.paymentTypeLabel,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      controller.formatCurrency(
                                        receipt.amountReceived,
                                      ),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.paymentModeLabel,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.referenceTransactionId ?? '—',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.closeTypeLabel,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.accountClosureStatusLabel,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.formattedNextDueDate,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      receipt.remarks ?? '—',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!locked) {
      return viewContent;
    }

    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: viewContent),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.65),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Finish or cancel the edit to select another receipt.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditTab extends StatelessWidget {
  const EditTab({
    super.key,
    required this.controller,
    required this.selected,
    required this.paymentType,
    required this.onPaymentTypeChanged,
    required this.paymentMode,
    required this.onPaymentModeChanged,
    required this.status,
    required this.onStatusChanged,
    required this.closeType,
    required this.onCloseTypeChanged,
    required this.accountClosureStatus,
    required this.onAccountClosureStatusChanged,
    required this.closurePaymentMode,
    required this.onClosurePaymentModeChanged,
    required this.amountReceivedCtrl,
    required this.interestComponentCtrl,
    required this.principalComponentCtrl,
    required this.lateFeeCtrl,
    required this.totalReceiptValueCtrl,
    required this.referenceTransactionIdCtrl,
    required this.remarksCtrl,
    required this.interestRebateCtrl,
    required this.penaltyChargesCtrl,
    required this.finalSettlementAmountCtrl,
    required this.closureReferenceIdCtrl,
    required this.closureRemarksCtrl,
    required this.onUpdate,
    required this.onDelete,
    required this.onCancel,
  });

  final LoanReceiptController controller;
  final LoanReceiptRecord? selected;
  final PaymentType paymentType;
  final ValueChanged<PaymentType> onPaymentTypeChanged;
  final PaymentMode paymentMode;
  final ValueChanged<PaymentMode> onPaymentModeChanged;
  final ReceiptStatus status;
  final ValueChanged<ReceiptStatus> onStatusChanged;
  final CloseType? closeType;
  final ValueChanged<CloseType?> onCloseTypeChanged;
  final AccountClosureStatus? accountClosureStatus;
  final ValueChanged<AccountClosureStatus?> onAccountClosureStatusChanged;
  final PaymentMode? closurePaymentMode;
  final ValueChanged<PaymentMode?> onClosurePaymentModeChanged;
  final TextEditingController amountReceivedCtrl;
  final TextEditingController interestComponentCtrl;
  final TextEditingController principalComponentCtrl;
  final TextEditingController lateFeeCtrl;
  final TextEditingController totalReceiptValueCtrl;
  final TextEditingController referenceTransactionIdCtrl;
  final TextEditingController remarksCtrl;
  final TextEditingController interestRebateCtrl;
  final TextEditingController penaltyChargesCtrl;
  final TextEditingController finalSettlementAmountCtrl;
  final TextEditingController closureReferenceIdCtrl;
  final TextEditingController closureRemarksCtrl;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  static const TextStyle textStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 11,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Select a receipt from View tab to edit',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System-Controlled Fields',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              //  const SizedBox(height: 5),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    Text('Loan ID: ${selected!.loanId}'),
                    Text('Receipt Number: ${selected!.voucherNumber}'),
                    Text('Created By: ${selected!.createdBy ?? '—'}'),
                    Text(
                      'Entry Date: ${selected!.createdAt != null ? DateFormat('dd-MMM-yyyy').format(selected!.createdAt!) : '—'}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<PaymentMode>(
                    value: paymentMode,
                    decoration: fieldDecoration('Payment Mode'),
                    style: textStyle,
                    items: PaymentMode.values.map((mode) {
                      String label;
                      switch (mode) {
                        case PaymentMode.cash:
                          label = 'Cash';
                          break;
                        case PaymentMode.bankTransfer:
                          label = 'Bank Transfer';
                          break;
                        case PaymentMode.upi:
                          label = 'UPI';
                          break;
                        case PaymentMode.cheque:
                          label = 'Cheque';
                          break;
                      }
                      return DropdownMenuItem(value: mode, child: Text(label));
                    }).toList(),
                    onChanged: (value) => onPaymentModeChanged(value!),
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: referenceTransactionIdCtrl,
                    label: 'Transaction / Reference ID',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: amountReceivedCtrl,
                    label: 'Amount Received',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: interestComponentCtrl,
                    label: 'Interest Component',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: AppTextField(
                    controller: principalComponentCtrl,
                    label: 'Principal Component',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<CloseType?>(
                    value: closeType,
                    decoration: fieldDecoration('Close Type'),
                    style: textStyle,
                    items: [
                      const DropdownMenuItem<CloseType?>(
                        value: null,
                        child: Text('—'),
                      ),
                      ...CloseType.values.map((type) {
                        String label;
                        switch (type) {
                          case CloseType.regularClosure:
                            label = 'Regular Closure';
                            break;
                          case CloseType.preclosure:
                            label = 'Preclosure';
                            break;
                        }
                        return DropdownMenuItem(value: type, child: Text(label));
                      }),
                    ],
                    onChanged: onCloseTypeChanged,
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField<ReceiptStatus>(
                    value: status,
                    decoration: fieldDecoration('Status'),
                    style: textStyle,
                    items: ReceiptStatus.values.map((s) {
                      String label;
                      switch (s) {
                        case ReceiptStatus.received:
                          label = 'Received';
                          break;
                        case ReceiptStatus.pending:
                          label = 'Pending';
                          break;
                        case ReceiptStatus.cancelled:
                          label = 'Cancelled';
                          break;
                      }
                      return DropdownMenuItem(value: s, child: Text(label));
                    }).toList(),
                    onChanged: (value) => onStatusChanged(value!),
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: SizedBox(
                  height: 40,
                  child:
                      DropdownButtonFormField<AccountClosureStatus?>(
                    value: accountClosureStatus,
                    decoration:
                        fieldDecoration('Account Closure Status'),
                    style: textStyle,
                    items: [
                      const DropdownMenuItem<AccountClosureStatus?>(
                        value: null,
                        child: Text('—'),
                      ),
                      ...AccountClosureStatus.values.map((s) {
                        String label;
                        switch (s) {
                          case AccountClosureStatus.closed:
                            label = 'Closed';
                            break;
                          case AccountClosureStatus.preclosed:
                            label = 'Preclosed';
                            break;
                          case AccountClosureStatus.pending:
                            label = 'Pending';
                            break;
                          case AccountClosureStatus.active:
                            label = 'Active';
                            break;
                        }
                        return DropdownMenuItem(value: s, child: Text(label));
                      }),
                    ],
                    onChanged: onAccountClosureStatusChanged,
                    isExpanded: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppTextField(
              controller: remarksCtrl,
              label: 'Remarks (updated after manager approval)',
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GradientScrollbar extends StatefulWidget {
  const GradientScrollbar({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<GradientScrollbar> createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<GradientScrollbar> {
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
                  final maxScrollExtent =
                      widget.controller.position.maxScrollExtent;
                  final minScrollExtent =
                      widget.controller.position.minScrollExtent;
                  final scrollExtent = maxScrollExtent - minScrollExtent;

                  if (scrollExtent <= 0) {
                    return const SizedBox.shrink();
                  }

                  final viewportDimension =
                      widget.controller.position.viewportDimension;
                  final thumbExtent = (viewportDimension /
                          (scrollExtent + viewportDimension)) *
                      constraints.maxWidth;
                  final scrollOffset =
                      widget.controller.position.pixels - minScrollExtent;
                  final thumbOffset = (scrollOffset / scrollExtent) *
                      (constraints.maxWidth - thumbExtent);

                  return GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragStartPosition = details.localPosition.dx;
                        _dragStartScrollOffset =
                            widget.controller.position.pixels;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final delta =
                            details.localPosition.dx - _dragStartPosition;
                        final scrollDelta =
                            (delta / (constraints.maxWidth - thumbExtent)) *
                                scrollExtent;
                        final newScrollOffset =
                            (_dragStartScrollOffset + scrollDelta).clamp(
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
                            left: thumbOffset.clamp(
                                0.0, constraints.maxWidth - thumbExtent),
                            width: thumbExtent.clamp(
                                20.0, constraints.maxWidth),
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


