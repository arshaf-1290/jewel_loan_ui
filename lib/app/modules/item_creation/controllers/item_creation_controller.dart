import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemRecord {
  ItemRecord({
    required this.code,
    required this.name,
    required this.metalType,
    required this.entryDate,
    this.hsnCode,
    required this.metalWeight,
    required this.stoneWeight,
    this.baseValue,
    this.wastageValue,
    this.location,
    this.remarks,
  });

  final String code;
  final String name;
  final String metalType;
  final DateTime entryDate;
  final String? hsnCode;
  final double metalWeight;
  final double stoneWeight;
  final double? baseValue;
  final double? wastageValue;
  final String? location;
  final String? remarks;

  String get formattedDate => DateFormat('dd-MMM-yyyy').format(entryDate);
}

class ItemCreationController extends ChangeNotifier {
  ItemCreationController() {
    _items.add(
      ItemRecord(
        code: 'ITM-2025-0001',
        name: 'Gold Necklace 22K',
        metalType: 'Gold',
        entryDate: DateTime(2025, 11, 12),
        hsnCode: '7113',
        metalWeight: 45.320,
        stoneWeight: 2.150,
        baseValue: 279000,
        wastageValue: 8370,
        location: 'Bridal Collection Rack',
        remarks: 'Bridal Collection',
      ),
    );
  }

  final List<ItemRecord> _items = [];

  List<ItemRecord> get items => List.unmodifiable(_items);

  final NumberFormat _weightFormat = NumberFormat('#,##0.000', 'en_IN');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  String formatWeight(double value) => _weightFormat.format(value);
  String formatCurrency(double? value) =>
      value == null ? '—' : _currencyFormat.format(value);

  String generateNextCode(DateTime date) {
    final year = date.year;
    final sequence =
        _items.where((item) => item.entryDate.year == year).length + 1;
    return 'ITM-$year-${sequence.toString().padLeft(4, '0')}';
  }

  void addItem(ItemRecord record) {
    _items.insert(0, record);
    notifyListeners();
  }

  void deleteItem(String code) {
    _items.removeWhere((item) => item.code == code);
    notifyListeners();
  }
}
