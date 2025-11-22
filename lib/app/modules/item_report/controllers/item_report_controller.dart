import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemRecord {
  ItemRecord({
    required this.itemCode,
    required this.itemName,
    required this.metalType,
    required this.dateOfEntry,
    this.hsnCode,
    required this.metalWeight,
    required this.stoneWeight,
    this.remarks,
  });

  final String itemCode;
  final String itemName;
  final String metalType;
  final DateTime dateOfEntry;
  final String? hsnCode;
  final double metalWeight;
  final double stoneWeight;
  final String? remarks;

  String get formattedDate => DateFormat('dd-MMM-yyyy').format(dateOfEntry);

  ItemRecord copyWith({
    String? itemName,
    String? metalType,
    String? hsnCode,
    double? metalWeight,
    double? stoneWeight,
    String? remarks,
  }) {
    return ItemRecord(
      itemCode: itemCode,
      itemName: itemName ?? this.itemName,
      metalType: metalType ?? this.metalType,
      dateOfEntry: dateOfEntry,
      hsnCode: hsnCode ?? this.hsnCode,
      metalWeight: metalWeight ?? this.metalWeight,
      stoneWeight: stoneWeight ?? this.stoneWeight,
      remarks: remarks ?? this.remarks,
    );
  }
}

class PendingLoanRecord {
  PendingLoanRecord({
    required this.serial,
    required this.loanDate,
    required this.loanNo,
    required this.customerName,
    required this.loanType,
    required this.loanAmount,
    required this.interestType,
    required this.interestPercent,
    required this.totalPayable,
    required this.paidAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.odPercent,
    required this.odAmount,
  });

  final int serial;
  final DateTime loanDate;
  final String loanNo;
  final String customerName;
  final String loanType;
  final double loanAmount;
  final String interestType;
  final double interestPercent;
  final double totalPayable;
  final double paidAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final double odPercent;
  final double odAmount;

  String get formattedLoanDate => DateFormat('dd-MMM-yyyy').format(loanDate);
  String get formattedDueDate => DateFormat('dd-MMM-yyyy').format(dueDate);
}

class ItemReportController extends ChangeNotifier {
  ItemReportController() {
    _items.addAll([
      ItemRecord(
        itemCode: 'ITM-2025-0001',
        itemName: 'Bridal Necklace',
        metalType: 'Gold',
        dateOfEntry: DateTime(2025, 11, 11),
        hsnCode: '7113',
        metalWeight: 56.45,
        stoneWeight: 4.2,
        remarks: 'Temple pattern',
      ),
      ItemRecord(
        itemCode: 'ITM-2025-0002',
        itemName: 'Silver Anklet',
        metalType: 'Silver',
        dateOfEntry: DateTime(2025, 11, 12),
        hsnCode: '7117',
        metalWeight: 22.1,
        stoneWeight: 0,
        remarks: 'Pair',
      ),
    ]);

    _pendingLoans.addAll([
      PendingLoanRecord(
        serial: 1,
        loanDate: DateTime(2025, 10, 5),
        loanNo: 'LN-2025-0005',
        customerName: 'Lakshmi Devi',
        loanType: 'Gold Loan',
        loanAmount: 320000,
        interestType: 'Flat',
        interestPercent: 12.5,
        totalPayable: 360000,
        paidAmount: 150000,
        pendingAmount: 210000,
        dueDate: DateTime(2025, 12, 5),
        odPercent: 0,
        odAmount: 0,
      ),
      PendingLoanRecord(
        serial: 2,
        loanDate: DateTime(2025, 9, 20),
        loanNo: 'LN-2025-0006',
        customerName: 'Raghavendra',
        loanType: 'Finance Loan',
        loanAmount: 500000,
        interestType: 'Reducing',
        interestPercent: 11,
        totalPayable: 575000,
        paidAmount: 300000,
        pendingAmount: 275000,
        dueDate: DateTime(2025, 11, 25),
        odPercent: 2,
        odAmount: 5500,
      ),
    ]);
  }

  final List<ItemRecord> _items = [];
  final List<PendingLoanRecord> _pendingLoans = [];

  List<ItemRecord> get items => List.unmodifiable(_items);
  List<PendingLoanRecord> get pendingLoans => List.unmodifiable(_pendingLoans);

  void updateItem(String itemCode, ItemRecord updated) {
    final index = _items.indexWhere((item) => item.itemCode == itemCode);
    if (index == -1) return;
    _items[index] = updated;
    notifyListeners();
  }

  void deleteItem(String itemCode) {
    _items.removeWhere((item) => item.itemCode == itemCode);
    notifyListeners();
  }

  String formatWeight(double weight) => '${weight.toStringAsFixed(2)} g';
}

