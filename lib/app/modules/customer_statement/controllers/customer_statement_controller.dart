import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerStatementLoan {
  CustomerStatementLoan({
    required this.loanNo,
    required this.loanDate,
    required this.loanAmount,
    required this.interestPercent,
    required this.paidAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.status,
  });

  final String loanNo;
  final DateTime loanDate;
  final double loanAmount;
  final double interestPercent;
  final double paidAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final String status;

  String get formattedLoanDate => DateFormat('dd-MMM-yyyy').format(loanDate);
  String get formattedDueDate => DateFormat('dd-MMM-yyyy').format(dueDate);
}

class CustomerStatement {
  CustomerStatement({
    required this.customerName,
    required this.mobileNumber,
    required this.address,
    required this.loans,
  });

  final String customerName;
  final String mobileNumber;
  final String address;
  final List<CustomerStatementLoan> loans;

  int get totalLoans => loans.length;
  double get totalLoanAmount => loans.fold(0, (sum, loan) => sum + loan.loanAmount);
  double get totalPaid => loans.fold(0, (sum, loan) => sum + loan.paidAmount);
  double get totalPending => loans.fold(0, (sum, loan) => sum + loan.pendingAmount);
  double get totalOverdue => loans
      .where((loan) => loan.status == 'Overdue')
      .fold(0, (sum, loan) => sum + loan.pendingAmount);
}

class CustomerStatementController extends ChangeNotifier {
  CustomerStatementController() {
    _statement = CustomerStatement(
      customerName: 'Lakshmi Devi',
      mobileNumber: '9876500011',
      address: '12, Anna Nagar, Coimbatore',
      loans: [
        CustomerStatementLoan(
          loanNo: 'LN-2025-0008',
          loanDate: DateTime(2025, 1, 12),
          loanAmount: 320000,
          interestPercent: 12.5,
          paidAmount: 200000,
          pendingAmount: 120000,
          dueDate: DateTime(2025, 12, 12),
          status: 'Active',
        ),
        CustomerStatementLoan(
          loanNo: 'LN-2025-0010',
          loanDate: DateTime(2025, 4, 5),
          loanAmount: 180000,
          interestPercent: 11.0,
          paidAmount: 60000,
          pendingAmount: 120000,
          dueDate: DateTime(2025, 11, 30),
          status: 'Overdue',
        ),
        CustomerStatementLoan(
          loanNo: 'LN-2025-0015',
          loanDate: DateTime(2025, 9, 15),
          loanAmount: 250000,
          interestPercent: 10.5,
          paidAmount: 100000,
          pendingAmount: 150000,
          dueDate: DateTime(2026, 6, 15),
          status: 'Active',
        ),
      ],
    );
  }

  late CustomerStatement _statement;

  CustomerStatement get statement => _statement;

  void updateLoan(String loanNo, CustomerStatementLoan updated) {
    final index = _statement.loans.indexWhere((loan) => loan.loanNo == loanNo);
    if (index == -1) return;
    final loans = List<CustomerStatementLoan>.from(_statement.loans);
    loans[index] = updated;
    _statement = CustomerStatement(
      customerName: _statement.customerName,
      mobileNumber: _statement.mobileNumber,
      address: _statement.address,
      loans: loans,
    );
    notifyListeners();
  }
}

