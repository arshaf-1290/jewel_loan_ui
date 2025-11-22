class ReportsController {
  ReportsController()
      : stockReport = _generateStockReport(),
        purchaseReport = _generatePurchaseReport(),
        salesReport = _generateSalesReport(),
        loanReport = _generateLoanReport();

  final tabs = const ['Stock', 'Purchase', 'Sales', 'Loans'];

  final List<Map<String, dynamic>> stockReport;
  final List<Map<String, dynamic>> purchaseReport;
  final List<Map<String, dynamic>> salesReport;
  final List<Map<String, dynamic>> loanReport;

  static List<Map<String, dynamic>> _generateStockReport() {
    return List.generate(15, (index) {
      return {
        'item': 'Necklace ${index + 1}',
        'category': 'Necklace',
        'stock': '${(index * 5.2 + 24).toStringAsFixed(2)} g',
        'value': '₹ ${(index * 45000 + 180000).toStringAsFixed(0)}',
      };
    });
  }

  static List<Map<String, dynamic>> _generatePurchaseReport() {
    return List.generate(12, (index) {
      return {
        'supplier': 'Supplier ${(index % 5) + 1}',
        'invoices': '${(index % 4) + 2}',
        'amount': '₹ ${(index * 220000 + 350000).toStringAsFixed(0)}',
        'avgRate': '₹ ${(5800 + index * 15).toStringAsFixed(0)}',
      };
    });
  }

  static List<Map<String, dynamic>> _generateSalesReport() {
    return List.generate(12, (index) {
      return {
        'customer': 'Customer ${(index % 7) + 1}',
        'bills': '${(index % 5) + 1}',
        'grams': '${(index * 7.2 + 32).toStringAsFixed(2)}',
        'amount': '₹ ${(index * 180000 + 240000).toStringAsFixed(0)}',
      };
    });
  }

  static List<Map<String, dynamic>> _generateLoanReport() {
    return List.generate(10, (index) {
      return {
        'loanNo': 'L-${3320 + index}',
        'customer': 'Borrower ${(index % 6) + 1}',
        'grams': '${(index * 4.5 + 28).toStringAsFixed(2)}',
        'outstanding': '₹ ${(index * 64000 + 185000).toStringAsFixed(0)}',
      };
    });
  }

}

