import 'package:flutter/material.dart';

class CustomerReportController extends ChangeNotifier {
  CustomerReportController() {
    _customers = _generateCustomers();
  }

  final TextEditingController searchController = TextEditingController();
  late List<Map<String, dynamic>> _customers;

  List<Map<String, dynamic>> get customers => _customers;

  void applySearch(String query) {
    final data = _generateCustomers();
    if (query.isEmpty) {
      _customers = data;
    } else {
      _customers = data
          .where(
            (c) => c['name'].toString().toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _generateCustomers() {
    return List.generate(25, (index) {
      return {
        'code': 'CUST-${1000 + index}',
        'name': 'Customer ${(index % 12) + 1}',
        'contact': '+91 9845${index.toString().padLeft(5, '0')}',
        'totalPurchase': '₹ ${(index * 285000 + 345000).toStringAsFixed(0)}',
        'outstanding': index.isEven ? '₹ ${(index * 35000 + 45000).toStringAsFixed(0)}' : '₹ 0',
        'lastVisit': '2024-10-${(index % 28 + 1).toString().padLeft(2, '0')}',
      };
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

