import 'package:flutter/material.dart';

class ExpensesController extends ChangeNotifier {
  // Expense heads (Expense To)
  final expenseTypes = ['Rent', 'Electricity', 'Salary', 'Maintenance', 'Marketing'];
  String _selectedType = 'Rent';

  // From account (like Cash A/c, Bank, etc.)
  final fromAccounts = ['Cash A/c', 'IOB', 'EB Bill', 'Vehicle', 'Loan Interest', 'Loan Deff', 'Raja'];
  String _selectedFromAccount = 'Cash A/c';

  // High-level category for the expense
  final expenseCategories = ['Others', 'Payment', 'Salary', 'Transaction', 'Expenses'];
  String _selectedCategory = 'Others';

  final TextEditingController voucherController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime _expenseDate = DateTime.now();
  final List<Map<String, dynamic>> _expenses = <Map<String, dynamic>>[];
  int? _editingIndex;

  ExpensesController() {
    _expenses.addAll(_generateExpenses());
  }

  String get selectedType => _selectedType;
  String get selectedFromAccount => _selectedFromAccount;
  String get selectedCategory => _selectedCategory;
  DateTime get expenseDate => _expenseDate;
  List<Map<String, dynamic>> get expenses => List.unmodifiable(_expenses);
  bool get isEditing => _editingIndex != null;

  void pickDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (selected != null) {
      _expenseDate = selected;
      notifyListeners();
    }
  }

  void changeType(String? value) {
    if (value == null) return;
    if (value == _selectedType) return;
    _selectedType = value;
    notifyListeners();
  }

  void changeFromAccount(String? value) {
    if (value == null || value == _selectedFromAccount) return;
    _selectedFromAccount = value;
    notifyListeners();
  }

  void changeCategory(String? value) {
    if (value == null || value == _selectedCategory) return;
    _selectedCategory = value;
    notifyListeners();
  }

  void addExpense() {
    final record = {
      'date': _expenseDate.toString().split(' ').first,
      'type': _selectedType,
      'amount': '₹ ${amountController.text}',
      'notes': notesController.text,
      'from': _selectedFromAccount,
      'category': _selectedCategory,
      'voucher': voucherController.text,
    };

    if (_editingIndex != null &&
        _editingIndex! >= 0 &&
        _editingIndex! < _expenses.length) {
      _expenses[_editingIndex!] = record;
    } else {
      _expenses.insert(0, record);
    }
    clearForm();
  }

  void deleteExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) return;
    _expenses.removeAt(index);
    notifyListeners();
  }

  void deleteCurrentEditing() {
    if (_editingIndex == null) return;
    final index = _editingIndex!;
    if (index < 0 || index >= _expenses.length) return;
    _expenses.removeAt(index);
    clearForm();
    notifyListeners();
  }

  void startEdit(int index) {
    if (index < 0 || index >= _expenses.length) return;
    final record = _expenses[index];
    _editingIndex = index;

    voucherController.text = '${record['voucher'] ?? ''}';
    notesController.text = '${record['notes'] ?? ''}';

    final rawAmount = (record['amount'] ?? '').toString();
    final cleanedAmount =
        rawAmount.replaceAll(RegExp(r'[^0-9.]'), ''); // strip currency
    amountController.text = cleanedAmount;

    _selectedType = '${record['type'] ?? _selectedType}';
    _selectedFromAccount = '${record['from'] ?? _selectedFromAccount}';
    _selectedCategory = '${record['category'] ?? _selectedCategory}';

    final dateStr = record['date']?.toString();
    if (dateStr != null) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) {
        _expenseDate = parsed;
      }
    }

    notifyListeners();
  }

  void cancelEdit() {
    _editingIndex = null;
    clearForm();
  }

  void clearForm() {
    amountController.clear();
    notesController.clear();
    voucherController.clear();
    _editingIndex = null;
    _selectedType = expenseTypes.first;
    _selectedFromAccount = fromAccounts.first;
    _selectedCategory = expenseCategories.first;
    _expenseDate = DateTime.now();
    notifyListeners();
  }

  List<Map<String, dynamic>> _generateExpenses() {
    final types = ['Rent', 'Electricity', 'Salary', 'Maintenance', 'Marketing'];
    return List.generate(20, (index) {
      return {
        'date': '2024-10-${(index % 30 + 1).toString().padLeft(2, '0')}',
        'type': types[index % types.length],
        'amount': '₹ ${(index * 4500 + 12500).toStringAsFixed(0)}',
        'notes': index.isEven ? 'Monthly payout' : 'One-time expense',
        'from': 'Cash A/c',
        'category': 'Others',
        'voucher': 'EXP-2025-${(index + 1).toString().padLeft(4, '0')}',
      };
    });
  }

  @override
  void dispose() {
    voucherController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

