import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../staff_creation/controllers/staff_creation_controller.dart';

class StaffSalaryRecord {
  StaffSalaryRecord({
    required this.salaryId,
    required this.staffId,
    required this.staffName,
    required this.role,
    required this.salaryMonth,
    required this.basicSalary,
    this.allowance = 0,
    this.incentives = 0,
    this.deductions = 0,
    required this.paymentType,
    required this.ledger,
    this.paidDate,
    this.remarks,
    this.status = 'Paid',
  });

  final String salaryId;
  final String staffId;
  final String staffName;
  final String role;
  final DateTime salaryMonth;
  final double basicSalary;
  final double allowance;
  final double incentives;
  final double deductions;
  final String paymentType;
  final String ledger;
  final DateTime? paidDate;
  final String? remarks;
  final String status;

  double get netSalary => basicSalary + allowance + incentives - deductions;
  String get formattedMonth => DateFormat('MMM yyyy').format(salaryMonth);
  String get formattedPaidDate =>
      paidDate == null ? '—' : DateFormat('dd-MMM-yyyy').format(paidDate!);

  StaffSalaryRecord copyWith({
    double? basicSalary,
    double? allowance,
    double? incentives,
    double? deductions,
    String? paymentType,
    String? ledger,
    DateTime? paidDate,
    String? remarks,
    String? status,
  }) {
    return StaffSalaryRecord(
      salaryId: salaryId,
      staffId: staffId,
      staffName: staffName,
      role: role,
      salaryMonth: salaryMonth,
      basicSalary: basicSalary ?? this.basicSalary,
      allowance: allowance ?? this.allowance,
      incentives: incentives ?? this.incentives,
      deductions: deductions ?? this.deductions,
      paymentType: paymentType ?? this.paymentType,
      ledger: ledger ?? this.ledger,
      paidDate: paidDate ?? this.paidDate,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
    );
  }
}

class SalaryController extends ChangeNotifier {
  SalaryController({StaffCreationController? staffController}) {
    _staffController = staffController;
    _salaryRecords.addAll([
      StaffSalaryRecord(
        salaryId: 'SAL-202501-0001',
        staffId: 'STF-2025-0001',
        staffName: 'Karthik M',
        role: 'Loan Officer',
        salaryMonth: DateTime(2025, 1, 1),
        basicSalary: 45000,
        allowance: 5000,
        incentives: 3500,
        deductions: 1200,
        paymentType: 'Bank',
        ledger: 'Bank of India - Salary A/c',
        paidDate: DateTime(2025, 1, 28),
        remarks: 'Quarter end bonus applied',
        status: 'Paid',
      ),
      StaffSalaryRecord(
        salaryId: 'SAL-202501-0002',
        staffId: 'STF-2025-0002',
        staffName: 'Priya S',
        role: 'Accountant',
        salaryMonth: DateTime(2025, 1, 1),
        basicSalary: 38000,
        allowance: 3000,
        incentives: 0,
        deductions: 500,
        paymentType: 'Cash',
        ledger: 'Cash Account',
        paidDate: DateTime(2025, 1, 30),
        remarks: 'Year-end adjustment',
        status: 'Paid',
      ),
      StaffSalaryRecord(
        salaryId: 'SAL-202502-0001',
        staffId: 'STF-2025-0003',
        staffName: 'Meena D',
        role: 'Agent',
        salaryMonth: DateTime(2025, 2, 1),
        basicSalary: 18000,
        allowance: 1500,
        incentives: 3200,
        deductions: 0,
        paymentType: 'Pending',
        ledger: 'Cash Account',
        remarks: 'Pending approval',
        status: 'Pending',
      ),
    ]);
  }

  StaffCreationController? _staffController;
  final List<StaffSalaryRecord> _salaryRecords = [];

  List<StaffSalaryRecord> get salaryRecords =>
      List.unmodifiable(_salaryRecords);

  List<StaffRecord> get staff {
    if (_staffController == null) {
      final tempController = StaffCreationController();
      return tempController.staff;
    }
    return _staffController!.staff;
  }

  final NumberFormat _serialFormat = NumberFormat('0000');

  String generateSalaryId(DateTime month) {
    final prefix = DateFormat('yyyyMM').format(month);
    final countForMonth =
        _salaryRecords
                .where(
                  (salary) =>
                      DateFormat('yyyyMM').format(salary.salaryMonth) == prefix,
                )
                .length +
            1;
    return 'SAL-$prefix-${_serialFormat.format(countForMonth)}';
  }

  void addSalary(StaffSalaryRecord record) {
    final index = _salaryRecords.indexWhere(
      (item) => item.salaryId == record.salaryId,
    );
    if (index >= 0) {
      _salaryRecords[index] = record;
    } else {
      _salaryRecords.insert(0, record);
    }
    notifyListeners();
  }

  void updateSalary(String salaryId, StaffSalaryRecord updatedRecord) {
    final index = _salaryRecords.indexWhere(
      (record) => record.salaryId == salaryId,
    );
    if (index == -1) return;
    _salaryRecords[index] = updatedRecord;
    notifyListeners();
  }

  void deleteSalary(String salaryId) {
    _salaryRecords.removeWhere((record) => record.salaryId == salaryId);
    notifyListeners();
  }

  List<StaffSalaryRecord> filterSalary({
    String? query,
    String? role,
    String? status,
    DateTime? month,
    int? year,
  }) {
    return _salaryRecords.where((record) {
      if (query != null && query.trim().isNotEmpty) {
        final lower = query.toLowerCase();
        if (!record.staffName.toLowerCase().contains(lower) &&
            !record.staffId.toLowerCase().contains(lower)) {
          return false;
        }
      }
      if (role != null && role.isNotEmpty && role != 'All') {
        if (record.role != role) return false;
      }
      if (status != null && status.isNotEmpty && status != 'All') {
        if (record.status != status) return false;
      }
      if (month != null) {
        if (record.salaryMonth.year != month.year ||
            record.salaryMonth.month != month.month) {
          return false;
        }
      }
      if (year != null) {
        if (record.salaryMonth.year != year) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Map<String, double> salaryTotals(Iterable<StaffSalaryRecord> records) {
    double basic = 0;
    double allowance = 0;
    double incentives = 0;
    double deductions = 0;
    double net = 0;

    for (final record in records) {
      basic += record.basicSalary;
      allowance += record.allowance;
      incentives += record.incentives;
      deductions += record.deductions;
      net += record.netSalary;
    }

    return {
      'basic': basic,
      'allowance': allowance,
      'incentives': incentives,
      'deductions': deductions,
      'net': net,
    };
  }

  List<StaffSalaryRecord> salaryForStaff(String staffId) =>
      _salaryRecords
          .where((record) => record.staffId == staffId)
          .toList(growable: false);

  List<StaffSalaryRecord> pendingSalaryForMonth(DateTime month) {
    final key = DateFormat('yyyyMM').format(month);
    return _salaryRecords
        .where(
          (record) =>
              DateFormat('yyyyMM').format(record.salaryMonth) == key &&
              record.status == 'Pending',
        )
        .toList(growable: false);
  }

  void setStaffController(StaffCreationController? controller) {
    _staffController = controller;
    notifyListeners();
  }
}

