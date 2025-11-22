import 'package:flutter/material.dart';

class LedgerController extends ChangeNotifier {
  LedgerController() {
    _ledgerEntries = _generateEntries();
  }

  DateTimeRange? _dateRange;
  final TextEditingController searchController = TextEditingController();
  final List<String> heads = ['Customers', 'Suppliers', 'Expenses', 'Loans', 'Sales'];
  String _selectedHead = 'Customers';
  late List<Map<String, dynamic>> _ledgerEntries;

  DateTimeRange? get dateRange => _dateRange;
  String get selectedHead => _selectedHead;
  List<Map<String, dynamic>> get ledgerEntries => _ledgerEntries;

  void updateDateRange(DateTimeRange range) {
    _dateRange = range;
    notifyListeners();
  }

  void changeHead(String? head) {
    if (head == null || head == _selectedHead) return;
    _selectedHead = head;
    notifyListeners();
  }

  List<Map<String, dynamic>> _generateEntries() {
    double runningBalance = 0;
    return List.generate(40, (index) {
      final debit = index.isEven ? (index * 1800 + 5500) : 0;
      final credit = index.isOdd ? (index * 1700 + 4800) : 0;
      runningBalance += debit - credit;
      return {
        'date': '2024-10-${(index % 30 + 1).toString().padLeft(2, '0')}',
        'particulars': index.isEven ? 'Sale Bill #S-${5400 + index}' : 'Receipt #R-${4300 + index}',
        'voucher': index.isEven ? 'Sales' : 'Receipt',
        'debit': debit == 0 ? '' : '₹ ${debit.toStringAsFixed(2)}',
        'credit': credit == 0 ? '' : '₹ ${credit.toStringAsFixed(2)}',
        'balance': '₹ ${runningBalance.toStringAsFixed(2)}',
      };
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

