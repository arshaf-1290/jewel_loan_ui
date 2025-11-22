import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StaffRecord {
  StaffRecord({
    required this.staffId,
    required this.fullName,
    required this.dateOfBirth,
    required this.mobile,
    this.alternateNumber,
    this.address,
    required this.role,
    required this.dateOfJoining,
    required this.username,
    required this.password,
    required this.accessLevels,
    required this.accountStatus,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.isSoftDeleted = false,
    this.deactivationReason,
  });

  final String staffId;
  final String fullName;
  final DateTime dateOfBirth;
  final String mobile;
  final String? alternateNumber;
  final String? address;
  final String role;
  final DateTime dateOfJoining;
  final String username;
  final String password;
  final List<String> accessLevels;
  final String accountStatus;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
  final bool isSoftDeleted;
  final String? deactivationReason;

  StaffRecord copyWith({
    String? fullName,
    String? mobile,
    String? alternateNumber,
    String? address,
    String? role,
    List<String>? accessLevels,
    String? accountStatus,
    String? notes,
    bool? isSoftDeleted,
    String? deactivationReason,
  }) {
    return StaffRecord(
      staffId: staffId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth,
      mobile: mobile ?? this.mobile,
      alternateNumber: alternateNumber ?? this.alternateNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      dateOfJoining: dateOfJoining,
      username: username,
      password: password,
      accessLevels: accessLevels ?? this.accessLevels,
      accountStatus: accountStatus ?? this.accountStatus,
      notes: notes ?? this.notes,
      createdBy: createdBy,
      createdAt: createdAt,
      isSoftDeleted: isSoftDeleted ?? this.isSoftDeleted,
      deactivationReason: deactivationReason ?? this.deactivationReason,
    );
  }

  String get formattedDob => DateFormat('dd-MMM-yyyy').format(dateOfBirth);
  String get formattedDoj => DateFormat('dd-MMM-yyyy').format(dateOfJoining);
}

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

class StaffCreationController extends ChangeNotifier {
  StaffCreationController() {
    _staff.addAll([
      StaffRecord(
        staffId: 'STF-2025-0001',
        fullName: 'Karthik M',
        dateOfBirth: DateTime(1993, 5, 14),
        mobile: '9876543210',
        alternateNumber: '9443322110',
        address: '23, Mettur Road, Erode',
        role: 'Loan Officer',
        dateOfJoining: DateTime(2025, 3, 1),
        username: 'karthik.m',
        password: 'Auto-generated',
        accessLevels: const ['Loan Receipt', 'Loan Creation'],
        accountStatus: 'Active',
        notes: 'Handles bridal collection loans',
        createdBy: 'Admin',
        createdAt: DateTime(2025, 3, 1),
      ),
      StaffRecord(
        staffId: 'STF-2025-0002',
        fullName: 'Priya S',
        dateOfBirth: DateTime(1990, 11, 8),
        mobile: '9000012345',
        role: 'Accountant',
        dateOfJoining: DateTime(2025, 4, 12),
        username: 'priya.s',
        password: 'Auto-generated',
        accessLevels: const ['Accounts', 'Reports', 'Value Creation'],
        accountStatus: 'Active',
        notes: 'Monthly reconciliation',
        createdBy: 'Admin',
        createdAt: DateTime(2025, 4, 12),
      ),
    ]);

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

  final List<StaffRecord> _staff = [];
  final List<StaffSalaryRecord> _salaryRecords = [];

  List<StaffRecord> get staff => List.unmodifiable(_staff);
  List<StaffSalaryRecord> get salaryRecords =>
      List.unmodifiable(_salaryRecords);

  final NumberFormat _serialFormat = NumberFormat('0000');

  String generateNextStaffId(DateTime date) {
    final year = date.year;
    final countForYear =
        _staff.where((record) => record.dateOfJoining.year == year).length + 1;
    return 'STF-$year-${_serialFormat.format(countForYear)}';
  }

  String generateUsername(String fullName) {
    final processed = fullName.trim().toLowerCase();
    if (processed.isEmpty) return '';
    final base = processed.split(RegExp(r'\s+')).join('.');
    var username = base;
    var counter = 1;
    while (_staff.any((record) => record.username == username)) {
      counter += 1;
      username = '$base$counter';
    }
    return username;
  }

  void addStaff(StaffRecord record) {
    final index = _staff.indexWhere((item) => item.staffId == record.staffId);
    if (index >= 0) {
      _staff[index] = record;
    } else {
      _staff.insert(0, record);
    }
    notifyListeners();
  }

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

  void updateStaff(String staffId, StaffRecord updatedRecord) {
    final index = _staff.indexWhere((record) => record.staffId == staffId);
    if (index == -1) return;
    _staff[index] = updatedRecord;
    notifyListeners();
  }

  void softDelete(String staffId, String reason) {
    final index = _staff.indexWhere((record) => record.staffId == staffId);
    if (index == -1) return;
    final record = _staff[index];
    _staff[index] = record.copyWith(
      accountStatus: 'Inactive',
      isSoftDeleted: true,
      deactivationReason: reason,
    );
    notifyListeners();
  }

  void hardDelete(String staffId) {
    _staff.removeWhere((record) => record.staffId == staffId);
    notifyListeners();
  }

  List<StaffRecord> filter({
    String? query,
    String? role,
    String? status,
    DateTimeRange? joiningRange,
  }) {
    return _staff.where((record) {
      if (query != null && query.trim().isNotEmpty) {
        final lower = query.toLowerCase();
        final matchesName = record.fullName.toLowerCase().contains(lower);
        final matchesMobile = record.mobile.contains(lower);
        if (!matchesName && !matchesMobile) {
          return false;
        }
      }
      if (role != null && role.isNotEmpty && role != 'All') {
        if (record.role != role) return false;
      }
      if (status != null && status.isNotEmpty && status != 'All') {
        if (record.accountStatus != status) return false;
      }
      if (joiningRange != null) {
        final joinDate = record.dateOfJoining;
        if (joinDate.isBefore(joiningRange.start) ||
            joinDate.isAfter(joiningRange.end)) {
          return false;
        }
      }
      return true;
    }).toList();
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
        if (record.salaryMonth.year != year) return false;
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

  List<StaffSalaryRecord> salaryForStaff(String staffId) => _salaryRecords
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
}
