import 'package:flutter/material.dart';

class DayBookEntry {
  DayBookEntry({
    required this.date,
    required this.particulars,
    required this.voucherType,
    required this.credit,
    required this.debit,
  });

  final DateTime date;
  final String particulars;
  final String voucherType;
  final double credit;
  final double debit;
}

class DayBookController extends ChangeNotifier {
  DayBookController() {
    _generateSampleData();
  }

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedVoucherType;

  final List<String> voucherTypes = const [
    'All',
    'Loan',
    'Loan Interest',
    'Receipt',
    'Payment',
  ];

  final List<DayBookEntry> _allEntries = [];

  List<DayBookEntry> get filteredEntries {
    return _allEntries.where((e) {
      final inRange =
          !e.date.isBefore(fromDate) && !e.date.isAfter(toDate);
      final voucherOk = selectedVoucherType == null ||
          selectedVoucherType == 'All' ||
          e.voucherType == selectedVoucherType;
      return inRange && voucherOk;
    }).toList();
  }

  int get recordCount => filteredEntries.length;

  double get totalCredit =>
      filteredEntries.fold(0, (sum, e) => sum + e.credit);
  double get totalDebit =>
      filteredEntries.fold(0, (sum, e) => sum + e.debit);

  Future<void> pickFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      fromDate = picked;
      if (toDate.isBefore(fromDate)) {
        toDate = fromDate;
      }
      notifyListeners();
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      toDate = picked;
      if (fromDate.isAfter(toDate)) {
        fromDate = toDate;
      }
      notifyListeners();
    }
  }

  void changeVoucherType(String? value) {
    selectedVoucherType = value;
    notifyListeners();
  }

  void resetFilters() {
    fromDate = DateTime.now();
    toDate = DateTime.now();
    selectedVoucherType = 'All';
    notifyListeners();
  }

  void _generateSampleData() {
    final today = DateTime.now();
    _allEntries.addAll([
      DayBookEntry(
        date: today,
        particulars: '1780-K.MAHESH-Loan',
        voucherType: 'Loan',
        credit: 500000,
        debit: 0,
      ),
      DayBookEntry(
        date: today,
        particulars: '1780-K.MAHESH-Loan',
        voucherType: 'Loan Interest',
        credit: 0,
        debit: 7500,
      ),
      DayBookEntry(
        date: today,
        particulars: '1725-K. SELVARAJ-Loan',
        voucherType: 'Loan Interest',
        credit: 0,
        debit: 1500,
      ),
    ]);
  }
}


