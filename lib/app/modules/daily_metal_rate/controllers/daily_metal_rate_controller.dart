import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyMetalRateRecord {
  DailyMetalRateRecord({
    required this.id,
    required this.date,
    required this.createdBy,
    required this.goldRate,
    required this.silverRate,
    required this.platinumRate,
    required this.diamondRate,
    this.remarks = '',
    this.isActive = true,
    this.lastEditedBy,
    this.lastEditedAt,
    this.deletedBy,
    this.deletedAt,
  });

  final String id;
  final DateTime date;
  final String createdBy;
  double goldRate;
  double silverRate;
  double platinumRate;
  double diamondRate;
  String remarks;
  bool isActive;
  String? lastEditedBy;
  DateTime? lastEditedAt;
  String? deletedBy;
  DateTime? deletedAt;

  DailyMetalRateRecord copyWith({
    double? goldRate,
    double? silverRate,
    double? platinumRate,
    double? diamondRate,
    String? remarks,
    bool? isActive,
    String? lastEditedBy,
    DateTime? lastEditedAt,
    String? deletedBy,
    DateTime? deletedAt,
  }) {
    return DailyMetalRateRecord(
      id: id,
      date: date,
      createdBy: createdBy,
      goldRate: goldRate ?? this.goldRate,
      silverRate: silverRate ?? this.silverRate,
      platinumRate: platinumRate ?? this.platinumRate,
      diamondRate: diamondRate ?? this.diamondRate,
      remarks: remarks ?? this.remarks,
      isActive: isActive ?? this.isActive,
      lastEditedBy: lastEditedBy ?? this.lastEditedBy,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  String get status => isActive ? 'Active' : 'Inactive';

  String get formattedDate => DateFormat('dd-MMM-yyyy').format(date);
}

class DailyMetalRateController extends ChangeNotifier {
  DailyMetalRateController() {
    _records.add(
      DailyMetalRateRecord(
        id: 'VAL-2025-1110-0001',
        date: DateTime(2025, 11, 10),
        createdBy: 'STF-2025-0008 (Karthik M)',
        goldRate: 6200,
        silverRate: 85,
        platinumRate: 3400,
        diamondRate: 58000,
        remarks: 'Updated as per 10-Nov-2025 morning market rate',
      ),
    );
  }

  final List<DailyMetalRateRecord> _records = [];

  List<DailyMetalRateRecord> get records => List.unmodifiable(_records);

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  String formatCurrency(double value) => _currencyFormat.format(value);

  String generateNextId(DateTime date) {
    final serial =
        _records
            .where(
              (record) =>
                  record.date.year == date.year &&
                  record.date.month == date.month &&
                  record.date.day == date.day,
            )
            .length +
        1;
    final dateSegment =
        '${date.year}-${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return 'VAL-$dateSegment-${serial.toString().padLeft(4, '0')}';
  }

  void addRecord({
    required DateTime date,
    required String createdBy,
    required double goldRate,
    required double silverRate,
    required double platinumRate,
    required double diamondRate,
    String remarks = '',
  }) {
    final record = DailyMetalRateRecord(
      id: generateNextId(date),
      date: date,
      createdBy: createdBy,
      goldRate: goldRate,
      silverRate: silverRate,
      platinumRate: platinumRate,
      diamondRate: diamondRate,
      remarks: remarks,
    );
    _records.insert(0, record);
    notifyListeners();
  }

  void updateRecord({
    required String id,
    required double goldRate,
    required double silverRate,
    required double platinumRate,
    required double diamondRate,
    required String remarks,
    required String editedBy,
  }) {
    final index = _records.indexWhere((record) => record.id == id);
    if (index == -1) return;
    final existing = _records[index];
    _records[index] = existing.copyWith(
      goldRate: goldRate,
      silverRate: silverRate,
      platinumRate: platinumRate,
      diamondRate: diamondRate,
      remarks: remarks,
      lastEditedBy: editedBy,
      lastEditedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void softDeleteRecord({
    required String id,
    required String deletedBy,
    String reason = '',
  }) {
    final index = _records.indexWhere((record) => record.id == id);
    if (index == -1) return;
    final existing = _records[index];
    if (!existing.isActive) return;
    _records[index] = existing.copyWith(
      isActive: false,
      remarks: reason.isEmpty ? existing.remarks : reason,
      deletedBy: deletedBy,
      deletedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void restoreRecord(String id) {
    final index = _records.indexWhere((record) => record.id == id);
    if (index == -1) return;
    final existing = _records[index];
    if (existing.isActive) return;
    _records[index] = existing.copyWith(
      isActive: true,
      deletedBy: null,
      deletedAt: null,
    );
    notifyListeners();
  }

  void hardDeleteRecord(String id) {
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }

  List<DailyMetalRateRecord> filterByRange(DateTimeRange? range) {
    if (range == null) return records;
    return records
        .where(
          (record) =>
              record.date.isAfter(
                range.start.subtract(const Duration(days: 1)),
              ) &&
              record.date.isBefore(range.end.add(const Duration(days: 1))),
        )
        .toList();
  }
}
