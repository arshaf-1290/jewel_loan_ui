import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentType {
  emi,
  partPayment,
  fullSettlement,
  preclosure,
}

enum PaymentMode {
  cash,
  bankTransfer,
  upi,
  cheque,
}

enum CloseType {
  regularClosure,
  preclosure,
}

enum ReceiptStatus {
  received,
  pending,
  cancelled,
}

enum AccountClosureStatus {
  closed,
  preclosed,
  pending,
  active,
}

class LoanReceiptRecord {
  LoanReceiptRecord({
    required this.receiptId,
    required this.receiptDate,
    required this.loanId,
    required this.customerName,
    required this.mobileNumber,
    required this.handledBy,
    required this.paymentType,
    required this.paymentMode,
    required this.amountReceived,
    required this.interestComponent,
    required this.principalComponent,
    required this.lateFee,
    required this.totalReceiptValue,
    this.referenceTransactionId,
    required this.voucherNumber,
    this.nextDueDate,
    required this.status,
    this.remarks,
    this.closeType,
    this.closureDate,
    this.totalOutstandingBeforeClosure,
    this.interestRebate,
    this.penaltyForeclosureCharges,
    this.finalSettlementAmount,
    this.closurePaymentMode,
    this.closureReferenceId,
    this.closedBy,
    this.accountClosureStatus,
    this.closureRemarks,
    this.branch,
    this.createdBy,
    this.createdAt,
  });

  final String receiptId;
  final DateTime receiptDate;
  final String loanId;
  final String customerName;
  final String mobileNumber;
  final String handledBy;
  final PaymentType paymentType;
  final PaymentMode paymentMode;
  final double amountReceived;
  final double interestComponent;
  final double principalComponent;
  final double lateFee;
  final double totalReceiptValue;
  final String? referenceTransactionId;
  final String voucherNumber;
  final DateTime? nextDueDate;
  final ReceiptStatus status;
  final String? remarks;
  final CloseType? closeType;
  final DateTime? closureDate;
  final double? totalOutstandingBeforeClosure;
  final double? interestRebate;
  final double? penaltyForeclosureCharges;
  final double? finalSettlementAmount;
  final PaymentMode? closurePaymentMode;
  final String? closureReferenceId;
  final String? closedBy;
  final AccountClosureStatus? accountClosureStatus;
  final String? closureRemarks;
  final String? branch;
  final String? createdBy;
  final DateTime? createdAt;

  String get formattedDate => DateFormat('dd-MMM-yyyy').format(receiptDate);
  String get formattedNextDueDate =>
      nextDueDate == null ? '—' : DateFormat('dd-MMM-yyyy').format(nextDueDate!);
  String get formattedClosureDate =>
      closureDate == null ? '—' : DateFormat('dd-MMM-yyyy').format(closureDate!);

  String get paymentTypeLabel {
    switch (paymentType) {
      case PaymentType.emi:
        return 'EMI';
      case PaymentType.partPayment:
        return 'Part Payment';
      case PaymentType.fullSettlement:
        return 'Full Settlement';
      case PaymentType.preclosure:
        return 'Preclosure';
    }
  }

  String get paymentModeLabel {
    switch (paymentMode) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.cheque:
        return 'Cheque';
    }
  }

  String get statusLabel {
    switch (status) {
      case ReceiptStatus.received:
        return 'Received';
      case ReceiptStatus.pending:
        return 'Pending';
      case ReceiptStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get closeTypeLabel {
    if (closeType == null) return '—';
    switch (closeType!) {
      case CloseType.regularClosure:
        return 'Regular Closure';
      case CloseType.preclosure:
        return 'Preclosure';
    }
  }

  String get accountClosureStatusLabel {
    if (accountClosureStatus == null) return '—';
    switch (accountClosureStatus!) {
      case AccountClosureStatus.closed:
        return 'Closed';
      case AccountClosureStatus.preclosed:
        return 'Preclosed';
      case AccountClosureStatus.pending:
        return 'Pending';
      case AccountClosureStatus.active:
        return 'Active';
    }
  }

  LoanReceiptRecord copyWith({
    String? receiptId,
    DateTime? receiptDate,
    String? loanId,
    String? customerName,
    String? mobileNumber,
    String? handledBy,
    PaymentType? paymentType,
    PaymentMode? paymentMode,
    double? amountReceived,
    double? interestComponent,
    double? principalComponent,
    double? lateFee,
    double? totalReceiptValue,
    String? referenceTransactionId,
    String? voucherNumber,
    DateTime? nextDueDate,
    ReceiptStatus? status,
    String? remarks,
    CloseType? closeType,
    DateTime? closureDate,
    double? totalOutstandingBeforeClosure,
    double? interestRebate,
    double? penaltyForeclosureCharges,
    double? finalSettlementAmount,
    PaymentMode? closurePaymentMode,
    String? closureReferenceId,
    String? closedBy,
    AccountClosureStatus? accountClosureStatus,
    String? closureRemarks,
    String? branch,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return LoanReceiptRecord(
      receiptId: receiptId ?? this.receiptId,
      receiptDate: receiptDate ?? this.receiptDate,
      loanId: loanId ?? this.loanId,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      handledBy: handledBy ?? this.handledBy,
      paymentType: paymentType ?? this.paymentType,
      paymentMode: paymentMode ?? this.paymentMode,
      amountReceived: amountReceived ?? this.amountReceived,
      interestComponent: interestComponent ?? this.interestComponent,
      principalComponent: principalComponent ?? this.principalComponent,
      lateFee: lateFee ?? this.lateFee,
      totalReceiptValue: totalReceiptValue ?? this.totalReceiptValue,
      referenceTransactionId: referenceTransactionId ?? this.referenceTransactionId,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      closeType: closeType ?? this.closeType,
      closureDate: closureDate ?? this.closureDate,
      totalOutstandingBeforeClosure: totalOutstandingBeforeClosure ?? this.totalOutstandingBeforeClosure,
      interestRebate: interestRebate ?? this.interestRebate,
      penaltyForeclosureCharges: penaltyForeclosureCharges ?? this.penaltyForeclosureCharges,
      finalSettlementAmount: finalSettlementAmount ?? this.finalSettlementAmount,
      closurePaymentMode: closurePaymentMode ?? this.closurePaymentMode,
      closureReferenceId: closureReferenceId ?? this.closureReferenceId,
      closedBy: closedBy ?? this.closedBy,
      accountClosureStatus: accountClosureStatus ?? this.accountClosureStatus,
      closureRemarks: closureRemarks ?? this.closureRemarks,
      branch: branch ?? this.branch,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LoanReceiptController extends ChangeNotifier {
  LoanReceiptController() {
    // Sample data
    _receipts.add(
      LoanReceiptRecord(
        receiptId: 'LR-2025-0028',
        receiptDate: DateTime(2025, 11, 10),
        loanId: 'LN-2025-0028',
        customerName: 'R. Krishnan',
        mobileNumber: '9876543210',
        handledBy: 'Priya',
        paymentType: PaymentType.preclosure,
        paymentMode: PaymentMode.bankTransfer,
        amountReceived: 285000,
        interestComponent: 15000,
        principalComponent: 270000,
        lateFee: 0,
        totalReceiptValue: 285000,
        referenceTransactionId: 'TXN7821934',
        voucherNumber: 'LR-2025-0028',
        nextDueDate: null,
        status: ReceiptStatus.received,
        remarks: 'Customer opted for preclosure',
        closeType: CloseType.preclosure,
        closureDate: DateTime(2025, 11, 10),
        totalOutstandingBeforeClosure: 295000,
        interestRebate: 10000,
        penaltyForeclosureCharges: 0,
        finalSettlementAmount: 285000,
        closurePaymentMode: PaymentMode.bankTransfer,
        closureReferenceId: 'TXN7821934',
        closedBy: 'Priya',
        accountClosureStatus: AccountClosureStatus.preclosed,
        closureRemarks: 'Early loan closure after 8 months with ₹10,000 interest rebate',
        branch: 'Erode Main',
        createdBy: 'Priya',
        createdAt: DateTime(2025, 11, 10),
      ),
    );
  }

  final List<LoanReceiptRecord> _receipts = [];

  List<LoanReceiptRecord> get receipts => List.unmodifiable(_receipts);

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  String formatCurrency(double value) => _currencyFormat.format(value);

  String generateNextVoucherNumber(DateTime date) {
    final year = date.year;
    final sequence =
        _receipts.where((r) => r.receiptDate.year == year).length + 1;
    return 'LR-$year-${sequence.toString().padLeft(4, '0')}';
  }

  void addReceipt(LoanReceiptRecord record) {
    _receipts.insert(0, record);
    notifyListeners();
  }

  void updateReceipt(String receiptId, LoanReceiptRecord updated) {
    final index = _receipts.indexWhere((r) => r.receiptId == receiptId);
    if (index != -1) {
      _receipts[index] = updated;
      notifyListeners();
    }
  }

  void deleteReceipt(String receiptId) {
    _receipts.removeWhere((r) => r.receiptId == receiptId);
    notifyListeners();
  }

  LoanReceiptRecord? getReceiptById(String receiptId) {
    try {
      return _receipts.firstWhere((r) => r.receiptId == receiptId);
    } catch (e) {
      return null;
    }
  }
}

