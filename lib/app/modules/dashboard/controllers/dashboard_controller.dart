import 'dart:math';

import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  DashboardController();

  String _selectedRange = _DashboardRange.today.name;

  final Map<_DashboardRange, _DashboardSnapshot> _snapshots = {
    _DashboardRange.today: const _DashboardSnapshot(
      totalSales: 342500,
      totalPurchase: 198750,
      activeLoans: 42,
      accountBalance: 1287450,
      monthlySeries: [
        MonthlySummary(month: 'Jan', sales: 12, purchase: 9),
        MonthlySummary(month: 'Feb', sales: 15, purchase: 11),
        MonthlySummary(month: 'Mar', sales: 18, purchase: 12),
        MonthlySummary(month: 'Apr', sales: 22, purchase: 15),
        MonthlySummary(month: 'May', sales: 24, purchase: 19),
        MonthlySummary(month: 'Jun', sales: 28, purchase: 21),
      ],
      pendingLoans: [
        PendingLoan(customer: 'A. Kumar', pledgeId: 'PL-1023', dueDays: 4, amount: 45000),
        PendingLoan(customer: 'S. Priya', pledgeId: 'PL-0976', dueDays: 7, amount: 28000),
        PendingLoan(customer: 'M. Rahman', pledgeId: 'PL-0882', dueDays: 9, amount: 62000),
        PendingLoan(customer: 'Divya Jewels', pledgeId: 'PL-0764', dueDays: 12, amount: 91000),
        PendingLoan(customer: 'V. Ramesh', pledgeId: 'PL-0755', dueDays: 14, amount: 32000),
      ],
    ),
    _DashboardRange.thisWeek: const _DashboardSnapshot(
      totalSales: 2123500,
      totalPurchase: 1748800,
      activeLoans: 186,
      accountBalance: 5274540,
      monthlySeries: [
        MonthlySummary(month: 'Jan', sales: 60, purchase: 42),
        MonthlySummary(month: 'Feb', sales: 68, purchase: 53),
        MonthlySummary(month: 'Mar', sales: 76, purchase: 61),
        MonthlySummary(month: 'Apr', sales: 82, purchase: 67),
        MonthlySummary(month: 'May', sales: 86, purchase: 71),
        MonthlySummary(month: 'Jun', sales: 94, purchase: 78),
      ],
      pendingLoans: [
        PendingLoan(customer: 'G. Suresh', pledgeId: 'PL-0729', dueDays: 3, amount: 52000),
        PendingLoan(customer: 'Lakshmi Bullion', pledgeId: 'PL-0718', dueDays: 6, amount: 145000),
        PendingLoan(customer: 'P. Naveen', pledgeId: 'PL-0685', dueDays: 8, amount: 38000),
        PendingLoan(customer: 'A. Sindhu', pledgeId: 'PL-0642', dueDays: 11, amount: 46000),
        PendingLoan(customer: 'R. Mohan', pledgeId: 'PL-0590', dueDays: 15, amount: 74000),
      ],
    ),
    _DashboardRange.thisMonth: const _DashboardSnapshot(
      totalSales: 8214350,
      totalPurchase: 6587230,
      activeLoans: 342,
      accountBalance: 8621540,
      monthlySeries: [
        MonthlySummary(month: 'Jan', sales: 130, purchase: 95),
        MonthlySummary(month: 'Feb', sales: 148, purchase: 112),
        MonthlySummary(month: 'Mar', sales: 162, purchase: 124),
        MonthlySummary(month: 'Apr', sales: 176, purchase: 139),
        MonthlySummary(month: 'May', sales: 188, purchase: 152),
        MonthlySummary(month: 'Jun', sales: 204, purchase: 168),
      ],
      pendingLoans: [
        PendingLoan(customer: 'P. Srinivasan', pledgeId: 'PL-0526', dueDays: 5, amount: 110000),
        PendingLoan(customer: 'Vel Jewellers', pledgeId: 'PL-0489', dueDays: 9, amount: 268000),
        PendingLoan(customer: 'S. Meenakshi', pledgeId: 'PL-0451', dueDays: 14, amount: 56000),
        PendingLoan(customer: 'J. Dhanush', pledgeId: 'PL-0418', dueDays: 17, amount: 39000),
        PendingLoan(customer: 'Classic Bullion', pledgeId: 'PL-0396', dueDays: 21, amount: 312000),
      ],
    ),
  };

  String get selectedRange => _selectedRange;

  _DashboardSnapshot get currentSnapshot =>
      _snapshots[_DashboardRange.values.firstWhere((range) => range.name == _selectedRange)]!;

  List<MetricTile> get metrics {
    final snapshot = currentSnapshot;
    return [
      MetricTile(
        label: 'Total Sales (Today)',
        value: _formatCurrency(snapshot.totalSales),
        icon: Icons.auto_graph_outlined,
        color: const Color(0xFF1ABC9C),
      ),
      MetricTile(
        label: 'Total Purchase (Today)',
        value: _formatCurrency(snapshot.totalPurchase),
        icon: Icons.shopping_bag_outlined,
        color: const Color(0xFF3498DB),
      ),
      MetricTile(
        label: 'Total Gold Loans (Active)',
        value: snapshot.activeLoans.toString(),
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFFF1C40F),
      ),
      MetricTile(
        label: 'Account Balance',
        value: _formatCurrency(snapshot.accountBalance),
        icon: Icons.savings_outlined,
        color: const Color(0xFF9B59B6),
      ),
    ];
  }

  List<MonthlySummary> get monthlySummary => currentSnapshot.monthlySeries;

  List<PendingLoan> get pendingLoans => currentSnapshot.pendingLoans;

  void changeRange(String value) {
    if (_selectedRange == value) return;
    if (_DashboardRange.values.any((range) => range.name == value)) {
      _selectedRange = value;
      notifyListeners();
    }
  }

  String _formatCurrency(num value) {
    final rounded = value.toInt();
    final buffer = StringBuffer();
    final digits = rounded.toString();
    int separatorPosition = digits.length;
    for (int i = digits.length - 1; i >= 0; i--) {
      buffer.write(digits[i]);
      final leftIndex = digits.length - i;
      if (i > 0) {
        if (leftIndex == 3 || (leftIndex > 3 && (leftIndex - 3) % 2 == 0)) {
          buffer.write(',');
        }
      }
    }
    final formatted = buffer.toString().split('').reversed.join();
    return '₹ $formatted';
  }
}

enum _DashboardRange { today, thisWeek, thisMonth }

class MetricTile {
  const MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class MonthlySummary {
  const MonthlySummary({
    required this.month,
    required this.sales,
    required this.purchase,
  });

  final String month;
  final int sales;
  final int purchase;

  double get maxValue => max(sales.toDouble(), purchase.toDouble());
}

class PendingLoan {
  const PendingLoan({
    required this.customer,
    required this.pledgeId,
    required this.dueDays,
    required this.amount,
  });

  final String customer;
  final String pledgeId;
  final int dueDays;
  final int amount;
}

class _DashboardSnapshot {
  const _DashboardSnapshot({
    required this.totalSales,
    required this.totalPurchase,
    required this.activeLoans,
    required this.accountBalance,
    required this.monthlySeries,
    required this.pendingLoans,
  });

  final int totalSales;
  final int totalPurchase;
  final int activeLoans;
  final int accountBalance;
  final List<MonthlySummary> monthlySeries;
  final List<PendingLoan> pendingLoans;
}


