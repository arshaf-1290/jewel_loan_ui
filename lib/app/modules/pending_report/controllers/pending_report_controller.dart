import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingReportEntry {
  PendingReportEntry({
    required this.loanNo,
    required this.customerName,
    required this.mobile,
    required this.loanDate,
    required this.loanAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.loanType,
  });

  final String loanNo;
  final String customerName;
  final String mobile;
  final DateTime loanDate;
  final double loanAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final String loanType; // Monthly Flex / Yearly Flex

  String get formattedLoanDate =>
      DateFormat('dd-MMM-yyyy').format(loanDate);
  String get formattedDueDate =>
      DateFormat('dd-MMM-yyyy').format(dueDate);
}

class PendingReportController extends ChangeNotifier {
  final List<PendingReportEntry> _entries = [];

  PendingReportController() {
    _seedSampleData();
  }

  List<PendingReportEntry> get entries => List.unmodifiable(_entries);

  void _seedSampleData() {
    final now = DateTime.now();
    _entries.addAll([
      PendingReportEntry(
        loanNo: 'LN-2025-0001',
        customerName: 'Aravind R',
        mobile: '9008765432',
        loanDate: now.subtract(const Duration(days: 40)),
        loanAmount: 150000,
        pendingAmount: 32000,
        dueDate: now.add(const Duration(days: 5)),
        loanType: 'Monthly Flex',
      ),
      PendingReportEntry(
        loanNo: 'LN-2025-0002',
        customerName: 'Suresh Kumar',
        mobile: '9876543210',
        loanDate: now.subtract(const Duration(days: 65)),
        loanAmount: 250000,
        pendingAmount: 78000,
        dueDate: now.add(const Duration(days: 15)),
        loanType: 'Yearly Flex',
      ),
      PendingReportEntry(
        loanNo: 'LN-2025-0003',
        customerName: 'Meena D',
        mobile: '9012345678',
        loanDate: now.subtract(const Duration(days: 95)),
        loanAmount: 100000,
        pendingAmount: 45000,
        dueDate: now.add(const Duration(days: 2)),
        loanType: 'Monthly Flex',
      ),
    ]);
  }

  List<PendingReportEntry> filter({
    DateTime? from,
    DateTime? to,
    String? loanType,
  }) {
    return _entries.where((entry) {
      if (from != null &&
          DateTime(entry.loanDate.year, entry.loanDate.month, entry.loanDate.day)
              .isBefore(DateTime(from.year, from.month, from.day))) {
        return false;
      }
      if (to != null &&
          DateTime(entry.loanDate.year, entry.loanDate.month, entry.loanDate.day)
              .isAfter(DateTime(to.year, to.month, to.day))) {
        return false;
      }
      if (loanType != null &&
          loanType.isNotEmpty &&
          loanType != 'All' &&
          entry.loanType != loanType) {
        return false;
      }
      return true;
    }).toList();
  }

  double sumLoanAmount(Iterable<PendingReportEntry> list) =>
      list.fold(0, (sum, e) => sum + e.loanAmount);

  double sumPendingAmount(Iterable<PendingReportEntry> list) =>
      list.fold(0, (sum, e) => sum + e.pendingAmount);
}


