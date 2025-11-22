class ProfitLossController {
  const ProfitLossController()
      : summary = const {
          'grossProfit': '₹ 12,40,500',
          'netProfit': '₹ 8,95,200',
          'grossMargin': '24.8%',
          'netMargin': '17.3%',
        },
        income = const [
          {'head': 'Gold Sales', 'amount': '₹ 28,60,000'},
          {'head': 'Making Charges', 'amount': '₹ 4,20,000'},
          {'head': 'Interest Income', 'amount': '₹ 1,24,000'},
          {'head': 'Other Income', 'amount': '₹ 86,000'},
        ],
        expense = const [
          {'head': 'Purchases', 'amount': '₹ 19,30,000'},
          {'head': 'Making Charges Paid', 'amount': '₹ 2,40,000'},
          {'head': 'Salary & Wages', 'amount': '₹ 1,80,000'},
          {'head': 'Rent', 'amount': '₹ 75,000'},
          {'head': 'Electricity', 'amount': '₹ 48,000'},
          {'head': 'Miscellaneous', 'amount': '₹ 32,800'},
        ];

  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> income;
  final List<Map<String, dynamic>> expense;
}

