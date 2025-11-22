import 'package:flutter/material.dart';

class StockController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  DateTimeRange? _dateRange;
  String _categoryFilter = 'All Categories';
  late List<Map<String, dynamic>> _stockItems;
  final List<String> categories = ['All Categories', 'Necklace', 'Ring', 'Bracelet', 'Earring'];

  StockController() {
    _stockItems = _generateMockData();
  }

  DateTimeRange? get dateRange => _dateRange;
  String get categoryFilter => _categoryFilter;
  List<Map<String, dynamic>> get stockItems => _stockItems;

  void updateDateRange(DateTimeRange range) {
    _dateRange = range;
    notifyListeners();
  }

  void applySearch(String query) {
    final data = _generateMockData();
    final filtered = data.where((item) {
      final matchQuery = item['item'].toString().toLowerCase().contains(query.toLowerCase());
      final matchCategory = _categoryFilter == 'All Categories' || item['category'] == _categoryFilter;
      return matchQuery && matchCategory;
    }).toList();
    _stockItems = filtered;
    notifyListeners();
  }

  void changeCategory(String? value) {
    if (value == null) return;
    _categoryFilter = value;
    applySearch(searchController.text);
  }

  Future<void> openAddStockDialog(BuildContext context) async {
    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Stock Item', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                const _StockDialogForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockData() {
    return List.generate(32, (index) {
      final categories = ['Necklace', 'Ring', 'Bracelet', 'Earring'];
      final metals = ['Gold 22K', 'Gold 18K', 'Silver', 'Platinum'];
      final category = categories[index % categories.length];
      return {
        'item': '${category} ${index + 1}',
        'category': category,
        'metal': metals[index % metals.length],
        'grossWeight': (index * 2.5 + 8.4).toStringAsFixed(2),
        'netWeight': (index * 2.2 + 7.9).toStringAsFixed(2),
        'making': (index * 150 + 460).toStringAsFixed(0),
        'stockValue': (index * 1200 + 54000).toStringAsFixed(2),
      };
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class _StockDialogForm extends StatelessWidget {
  const _StockDialogForm();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: _FormField(label: 'Item Name')),
              SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Category')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _FormField(label: 'Metal Type')),
              SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Purity (K)')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _FormField(label: 'Gross Weight (g)')),
              SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Net Weight (g)')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _FormField(label: 'Stone Weight (g)')),
              SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Making Charges')), 
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Item'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
    );
  }
}

