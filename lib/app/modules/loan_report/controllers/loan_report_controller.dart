import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanReportEntry {
  LoanReportEntry({
    required this.loanNo,
    required this.loanDate,
    required this.customerName,
    required this.mobileNumber,
    required this.loanType,
    required this.loanAmount,
    required this.interestType,
    required this.interestPercent,
    required this.dueAmount,
    required this.odPercent,
    required this.odAmount,
    required this.advanceReceipt,
    required this.documentAmount,
    required this.remarks,
    this.recommenderName,
    this.guarantorName,
    this.extraDaysAdded = 0,
    this.revisedDueDate,
    this.extraInterest = 0,
  });

  final String loanNo;
  final DateTime loanDate;
  final String customerName;
  final String mobileNumber;
  final String loanType;
  final double loanAmount;
  final String interestType;
  final double interestPercent;
  final double dueAmount;
  final double odPercent;
  final double odAmount;
  final double advanceReceipt;
  final double documentAmount;
  final String remarks;
  final String? recommenderName;
  final String? guarantorName;
  final int extraDaysAdded;
  final DateTime? revisedDueDate;
  final double extraInterest;

  String get formattedLoanDate => DateFormat('dd-MMM-yyyy').format(loanDate);
  String get formattedRevisedDate =>
      revisedDueDate == null ? '—' : DateFormat('dd-MMM-yyyy').format(revisedDueDate!);

  LoanReportEntry copyWith({
    double? loanAmount,
    String? interestType,
    double? interestPercent,
    double? dueAmount,
    double? odPercent,
    double? odAmount,
    double? advanceReceipt,
    double? documentAmount,
    String? loanType,
    String? remarks,
  }) {
    return LoanReportEntry(
      loanNo: loanNo,
      loanDate: loanDate,
      customerName: customerName,
      mobileNumber: mobileNumber,
      loanType: loanType ?? this.loanType,
      loanAmount: loanAmount ?? this.loanAmount,
      interestType: interestType ?? this.interestType,
      interestPercent: interestPercent ?? this.interestPercent,
      dueAmount: dueAmount ?? this.dueAmount,
      odPercent: odPercent ?? this.odPercent,
      odAmount: odAmount ?? this.odAmount,
      advanceReceipt: advanceReceipt ?? this.advanceReceipt,
      documentAmount: documentAmount ?? this.documentAmount,
      remarks: remarks ?? this.remarks,
      recommenderName: recommenderName,
      guarantorName: guarantorName,
      extraDaysAdded: extraDaysAdded,
      revisedDueDate: revisedDueDate,
      extraInterest: extraInterest,
    );
  }
}

class LoanReportController extends ChangeNotifier {
  LoanReportController() {
    _entries.addAll([
      LoanReportEntry(
        loanNo: 'LN-2025-0001',
        loanDate: DateTime(2025, 10, 5),
        customerName: 'Karthika Bala',
        mobileNumber: '9876543210',
        loanType: 'Gold Loan',
        loanAmount: 250000,
        interestType: 'Monthly',
        interestPercent: 12,
        dueAmount: 220000,
        odPercent: 2,
        odAmount: 4400,
        advanceReceipt: 20000,
        documentAmount: 1500,
        remarks: 'OD interest accruing',
        recommenderName: 'Arun Kumar',
        guarantorName: 'Lakshmi Devi',
        extraDaysAdded: 5,
        revisedDueDate: DateTime(2025, 10, 30),
        extraInterest: 1200,
      ),
      LoanReportEntry(
        loanNo: 'LN-2025-0002',
        loanDate: DateTime(2025, 11, 1),
        customerName: 'Srinath S',
        mobileNumber: '9123456780',
        loanType: 'Diamond Loan',
        loanAmount: 480000,
        interestType: 'Daily',
        interestPercent: 11.5,
        dueAmount: 420000,
        odPercent: 1.8,
        odAmount: 7560,
        advanceReceipt: 100000,
        documentAmount: 2000,
        remarks: 'Customer requested restructure',
        recommenderName: 'Meena Devi',
        guarantorName: 'Suresh K',
        extraDaysAdded: 0,
        revisedDueDate: null,
        extraInterest: 0,
      ),
      LoanReportEntry(
        loanNo: 'LN-2025-0003',
        loanDate: DateTime(2025, 9, 22),
        customerName: 'Raghavendra',
        mobileNumber: '9000011112',
        loanType: 'Business Loan',
        loanAmount: 600000,
        interestType: 'Monthly',
        interestPercent: 13,
        dueAmount: 560000,
        odPercent: 2.2,
        odAmount: 12320,
        advanceReceipt: 50000,
        documentAmount: 5000,
        remarks: 'High priority customer',
        recommenderName: 'Selvi',
        guarantorName: 'Prakash',
        extraDaysAdded: 8,
        revisedDueDate: DateTime(2025, 10, 28),
        extraInterest: 2200,
      ),
    ]);
  }

  final List<LoanReportEntry> _entries = [];
  final NumberFormat _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  List<LoanReportEntry> get entries => List.unmodifiable(_entries);

  List<String> get loanTypes => const [
        'Gold Loan',
        'Diamond Loan',
        'Business Loan',
        'Agriculture Loan',
        'Personal Loan',
      ];

  void addEntry(LoanReportEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void updateEntry(String loanNo, LoanReportEntry entry) {
    final index = _entries.indexWhere((item) => item.loanNo == loanNo);
    if (index == -1) return;
    _entries[index] = entry;
    notifyListeners();
  }

  void deleteEntry(String loanNo) {
    _entries.removeWhere((entry) => entry.loanNo == loanNo);
    notifyListeners();
  }

  List<LoanReportEntry> filterEntries({
    DateTime? fromDate,
    DateTime? toDate,
    String? loanType,
    String? recommender,
    String? guarantor,
    String? customer,
    String? loanNo,
  }) {
    return _entries.where((entry) {
      if (fromDate != null && entry.loanDate.isBefore(fromDate)) return false;
      if (toDate != null && entry.loanDate.isAfter(toDate)) return false;
      if (loanType != null && loanType.isNotEmpty && loanType != 'All') {
        if (entry.loanType != loanType) return false;
      }
      if (recommender != null && recommender.trim().isNotEmpty) {
        if (!(entry.recommenderName ?? '')
            .toLowerCase()
            .contains(recommender.toLowerCase())) return false;
      }
      if (guarantor != null && guarantor.trim().isNotEmpty) {
        if (!(entry.guarantorName ?? '')
            .toLowerCase()
            .contains(guarantor.toLowerCase())) return false;
      }
      if (customer != null && customer.trim().isNotEmpty) {
        if (!entry.customerName
            .toLowerCase()
            .contains(customer.toLowerCase())) return false;
      }
      if (loanNo != null && loanNo.trim().isNotEmpty) {
        if (!entry.loanNo.toLowerCase().contains(loanNo.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  String formatCurrency(double value) => _currency.format(value);

  double sumLoanAmount(Iterable<LoanReportEntry> items) =>
      items.fold(0, (total, entry) => total + entry.loanAmount);

  double sumDueAmount(Iterable<LoanReportEntry> items) =>
      items.fold(0, (total, entry) => total + entry.dueAmount);

  double sumOdAmount(Iterable<LoanReportEntry> items) =>
      items.fold(0, (total, entry) => total + entry.odAmount);
}

