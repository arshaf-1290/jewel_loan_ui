import 'package:flutter/material.dart';

class SaleController extends ChangeNotifier {
  SaleController() {
    saleRecords = _generateMockSales();
  }

  final TextEditingController customerController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController gramController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController makingController = TextEditingController();
  final TextEditingController wastageController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  DateTime _saleDate = DateTime.now();
  late List<Map<String, dynamic>> saleRecords;
  final List<Map<String, dynamic>> saleItems = <Map<String, dynamic>>[];

  DateTime get saleDate => _saleDate;

  void pickDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _saleDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (selected != null) {
      _saleDate = selected;
      notifyListeners();
    }
  }

  void addLineItem() {
    saleItems.add({
      'description': 'Gold Chain',
      'grams': gramController.text.isEmpty ? '20.50' : gramController.text,
      'rate': rateController.text.isEmpty ? '6,150' : rateController.text,
      'making': makingController.text.isEmpty ? '3,200' : makingController.text,
      'net': '₹ 1,28,430',
    });
    notifyListeners();
  }

  void removeLineItem(int index) {
    saleItems.removeAt(index);
    notifyListeners();
  }

  Future<void> previewBill(BuildContext context) async {
    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sale Bill Preview', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                const Text('A professional PDF bill template will be generated here.'),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Export PDF'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockSales() {
    return List.generate(24, (index) {
      return {
        'billNo': 'S-${5400 + index}',
        'date': '12/${(index % 12) + 1}/2024',
        'customer': 'Customer ${(index % 8) + 1}',
        'grams': '${(index * 4.5 + 22).toStringAsFixed(2)}',
        'rate': '6,150',
        'making': '2,950',
        'amount': '₹ ${(index * 86000 + 145000).toStringAsFixed(0)}',
      };
    });
  }

  @override
  void dispose() {
    customerController.dispose();
    contactController.dispose();
    gramController.dispose();
    rateController.dispose();
    makingController.dispose();
    wastageController.dispose();
    discountController.dispose();
    super.dispose();
  }
}

