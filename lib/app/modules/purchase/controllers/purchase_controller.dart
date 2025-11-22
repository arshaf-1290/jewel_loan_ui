import 'package:flutter/material.dart';

class PurchaseController extends ChangeNotifier {
  PurchaseController() {
    purchaseHistory = _generateHistory();
  }

  final TextEditingController supplierController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  DateTime _purchaseDate = DateTime.now();
  final List<Map<String, dynamic>> purchaseItems = <Map<String, dynamic>>[];
  late List<Map<String, dynamic>> purchaseHistory;
  final List<String> suppliers = ['Select Supplier', 'Kani Bullion', 'Lotus Jewels', 'Maharaja Gold', 'Shree Silver'];
  String _selectedSupplier = 'Select Supplier';

  DateTime get purchaseDate => _purchaseDate;
  String get selectedSupplier => _selectedSupplier;

  void addItem() {
    purchaseItems.add({
      'item': 'Gold 22K Necklace',
      'gross': '120.50',
      'net': '118.80',
      'rate': '6150',
      'making': '9000',
      'amount': '7,33,620',
    });
    notifyListeners();
  }

  void removeItem(int index) {
    purchaseItems.removeAt(index);
    notifyListeners();
  }

  void selectSupplier(String? value) {
    if (value == null || value == _selectedSupplier) return;
    _selectedSupplier = value;
    notifyListeners();
  }

  void pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      _purchaseDate = date;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _generateHistory() {
    return List.generate(18, (index) {
      return {
        'date': '0${index % 9 + 1}/10/2024',
        'supplier': suppliers[(index % (suppliers.length - 1)) + 1],
        'invoice': 'PUR-${1200 + index}',
        'gross': '${(index * 45.5 + 95).toStringAsFixed(2)} g',
        'net': '${(index * 45 + 90).toStringAsFixed(2)} g',
        'amount': '₹ ${(index * 240000 + 356000).toStringAsFixed(0)}',
        'status': index.isEven ? 'Booked' : 'Delivered',
      };
    });
  }

  @override
  void dispose() {
    supplierController.dispose();
    invoiceController.dispose();
    super.dispose();
  }
}

