class BalanceSheetController {
  BalanceSheetController()
      : assets = const [
          {'head': 'Fixed Assets', 'amount': '₹ 12,80,000'},
          {'head': 'Inventory', 'amount': '₹ 24,80,000'},
          {'head': 'Receivables', 'amount': '₹ 6,40,000'},
          {'head': 'Cash & Bank', 'amount': '₹ 2,35,000'},
          {'head': 'Gold Loans Outstanding', 'amount': '₹ 3,45,000'},
        ],
        liabilities = const [
          {'head': 'Capital Account', 'amount': '₹ 35,00,000'},
          {'head': 'Accounts Payable', 'amount': '₹ 5,75,000'},
          {'head': 'Deposit Schemes', 'amount': '₹ 3,20,000'},
          {'head': 'Short Term Loans', 'amount': '₹ 2,40,000'},
          {'head': 'Current Liabilities', 'amount': '₹ 3,45,000'},
        ];

  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> liabilities;
}

