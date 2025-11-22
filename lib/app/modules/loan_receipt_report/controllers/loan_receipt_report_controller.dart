import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanReceiptRecord {
  LoanReceiptRecord({
    required this.receiptId,
    required this.receiptDate,
    required this.loanNo,
    required this.customerName,
    required this.mobileNumber,
    required this.loanAmount,
    required this.duePeriod,
    required this.dueAmount,
    required this.paymentMode,
    required this.principalAmount,
    required this.interestAmount,
    required this.odAmount,
    required this.extraAmount,
    required this.extraAmountBehaviour,
    required this.totalAmount,
    required this.receiptAmount,
    required this.remarks,
    this.revisedDueDate,
    this.extraDayInterest = 0,
  });

  final String receiptId;
  final DateTime receiptDate;
  final String loanNo;
  final String customerName;
  final String mobileNumber;
  final double loanAmount;
  final String duePeriod;
  final double dueAmount;
  final String paymentMode;
  final double principalAmount;
  final double interestAmount;
  final double odAmount;
  final double extraAmount;
  final ExtraAmountBehaviour extraAmountBehaviour;
  final double totalAmount;
  final double receiptAmount;
  final String remarks;
  final DateTime? revisedDueDate;
  final double extraDayInterest;

  String get formattedDate => DateFormat('dd-MMM-yyyy').format(receiptDate);
  String get formattedRevisedDate =>
      revisedDueDate == null ? '—' : DateFormat('dd-MMM-yyyy').format(revisedDueDate!);

  LoanReceiptRecord copyWith({
    String? paymentMode,
    double? principalAmount,
    double? interestAmount,
    double? odAmount,
    double? receiptAmount,
    String? remarks,
  }) {
    return LoanReceiptRecord(
      receiptId: receiptId,
      receiptDate: receiptDate,
      loanNo: loanNo,
      customerName: customerName,
      mobileNumber: mobileNumber,
      loanAmount: loanAmount,
      duePeriod: duePeriod,
      dueAmount: dueAmount,
      paymentMode: paymentMode ?? this.paymentMode,
      principalAmount: principalAmount ?? this.principalAmount,
      interestAmount: interestAmount ?? this.interestAmount,
      odAmount: odAmount ?? this.odAmount,
      extraAmount: extraAmount,
      extraAmountBehaviour: extraAmountBehaviour,
      totalAmount: totalAmount,
      receiptAmount: receiptAmount ?? this.receiptAmount,
      remarks: remarks ?? this.remarks,
      revisedDueDate: revisedDueDate,
      extraDayInterest: extraDayInterest,
    );
  }
}

enum ExtraAmountBehaviour { add, less }

class LoanReceiptReportController extends ChangeNotifier {
  LoanReceiptReportController() {
    _records.addAll([
      LoanReceiptRecord(
        receiptId: 'LRCPT-2025-0012',
        receiptDate: DateTime(2025, 11, 12),
        loanNo: 'LN-2025-0002',
        customerName: 'Srinath S',
        mobileNumber: '9123456780',
        loanAmount: 480000,
        duePeriod: 'Aug 2025',
        dueAmount: 420000,
        paymentMode: 'UPI',
        principalAmount: 35000,
        interestAmount: 5200,
        odAmount: 750,
        extraAmount: 500,
        extraAmountBehaviour: ExtraAmountBehaviour.add,
        totalAmount: 40950,
        receiptAmount: 40950,
        remarks: 'UPI ref: 8844',
        revisedDueDate: DateTime(2025, 11, 15),
        extraDayInterest: 210,
      ),
      LoanReceiptRecord(
        receiptId: 'LRCPT-2025-0013',
        receiptDate: DateTime(2025, 11, 14),
        loanNo: 'LN-2025-0001',
        customerName: 'Karthika Bala',
        mobileNumber: '9876543210',
        loanAmount: 250000,
        duePeriod: 'Nov 2025',
        dueAmount: 220000,
        paymentMode: 'Cash',
        principalAmount: 18000,
        interestAmount: 3200,
        odAmount: 0,
        extraAmount: 300,
        extraAmountBehaviour: ExtraAmountBehaviour.less,
        totalAmount: 20900,
        receiptAmount: 20900,
        remarks: 'Cash counter',
        revisedDueDate: null,
        extraDayInterest: 0,
      ),
    ]);
  }

  final List<LoanReceiptRecord> _records = [];
  final NumberFormat _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  List<LoanReceiptRecord> get records => List.unmodifiable(_records);

  LoanReceiptRecord? get latestRecord =>
      _records.isEmpty ? null : _records.reduce((value, element) {
        final compare = value.receiptDate.compareTo(element.receiptDate);
        if (compare > 0) {
          return value;
        } else if (compare < 0) {
          return element;
        } else {
          return value.receiptId.compareTo(element.receiptId) >= 0 ? value : element;
        }
      });

  void addRecord(LoanReceiptRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }

  void updateRecord(String receiptId, LoanReceiptRecord updated) {
    final index = _records.indexWhere((record) => record.receiptId == receiptId);
    if (index == -1) return;
    _records[index] = updated;
    notifyListeners();
  }

  bool canModify(String receiptId) => latestRecord?.receiptId == receiptId;

  void deleteRecord(String receiptId) {
    _records.removeWhere((record) => record.receiptId == receiptId);
    notifyListeners();
  }

  String formatCurrency(double value) => _currency.format(value);
}

