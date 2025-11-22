import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/item_report_controller.dart';

class ItemReportView extends StatefulWidget {
  const ItemReportView({super.key});

  @override
  State<ItemReportView> createState() => _ItemReportViewState();
}

class _ItemReportViewState extends State<ItemReportView>
    with TickerProviderStateMixin {
  late final ItemReportController controller;
  late final TabController tabController;

  ItemRecord? _selectedItem;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController hsnCtrl = TextEditingController();
  final TextEditingController metalWeightCtrl = TextEditingController();
  final TextEditingController stoneWeightCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ItemReportController();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    nameCtrl.dispose();
    hsnCtrl.dispose();
    metalWeightCtrl.dispose();
    stoneWeightCtrl.dispose();
    remarksCtrl.dispose();
    super.dispose();
  }

  void _selectItem(ItemRecord record) {
    setState(() {
      _selectedItem = record;
      nameCtrl.text = record.itemName;
      hsnCtrl.text = record.hsnCode ?? '';
      metalWeightCtrl.text = record.metalWeight.toStringAsFixed(2);
      stoneWeightCtrl.text = record.stoneWeight.toStringAsFixed(2);
      remarksCtrl.text = record.remarks ?? '';
    });
  }

  void _deleteItem(ItemRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text(
          'Are you sure you want to delete this item record? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      controller.deleteItem(record.itemCode);
      if (_selectedItem?.itemCode == record.itemCode) {
        setState(() => _selectedItem = null);
      }
      _showSnack('Item deleted.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final totalWeight = controller.items.fold<double>(
            0,
            (sum, item) => sum + item.metalWeight,
          );
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border.withOpacity(0.6)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                          children: [
                            const Icon(Icons.inventory_outlined,
                                color: AppColors.primary, size: 26),
                            const SizedBox(width: 12),
                            const Text(
                              'Item Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 24),
                            _Stat(label: 'Items', value: '${controller.items.length}'),
                            const SizedBox(width: 16),
                            _Stat(label: 'Total Metal (g)', value: totalWeight.toStringAsFixed(2)),
                          ],
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor:
                            AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        tabs: const [
                          Tab(text: 'Items'),
                          Tab(text: 'Print / Pending'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _ItemsTab(
                              controller: controller,
                              onSelect: _selectItem,
                              onDelete: _deleteItem,
                            ),
                            _PrintPendingTab(controller: controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface.withOpacity(0.7),
              ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab({
    required this.controller,
    required this.onSelect,
    required this.onDelete,
  });

  final ItemReportController controller;
  final ValueChanged<ItemRecord> onSelect;
  final ValueChanged<ItemRecord> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Item Code')),
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Metal Type')),
              DataColumn(label: Text('Date of Entry')),
              DataColumn(label: Text('HSN Code')),
              DataColumn(label: Text('Metal Weight')),
              DataColumn(label: Text('Stone Weight')),
              DataColumn(label: Text('Remarks')),
              DataColumn(label: Text('Actions')),
            ],
            rows: controller.items
                .map(
                  (item) => DataRow(
                    cells: [
                      DataCell(Text(item.itemCode)),
                      DataCell(Text(item.itemName)),
                      DataCell(Text(item.metalType)),
                      DataCell(Text(item.formattedDate)),
                      DataCell(Text(item.hsnCode ?? '—')),
                      DataCell(Text(controller.formatWeight(item.metalWeight))),
                      DataCell(Text(controller.formatWeight(item.stoneWeight))),
                      DataCell(Text(item.remarks ?? '—')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'View',
                              onPressed: () => _showDetails(context, item, controller),
                              icon: const Icon(Icons.remove_red_eye_outlined),
                            ),
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () => onSelect(item),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () => onDelete(item),
                              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                            ),
                            IconButton(
                              tooltip: 'Print',
                              onPressed: () =>
                                  _showPrintPreview(context, [item], controller),
                              icon: const Icon(Icons.print_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  static void _showDetails(
    BuildContext context,
    ItemRecord item,
    ItemReportController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.itemName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item Code: ${item.itemCode}'),
            Text('Metal Type: ${item.metalType}'),
            Text('Metal Weight: ${controller.formatWeight(item.metalWeight)}'),
            Text('Stone Weight: ${controller.formatWeight(item.stoneWeight)}'),
            Text('HSN: ${item.hsnCode ?? '—'}'),
            Text('Date: ${item.formattedDate}'),
            Text('Notes: ${item.remarks ?? '—'}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  static void _showPrintPreview(
    BuildContext context,
    List<ItemRecord> items,
    ItemReportController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Item Report'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Company: Jewel MS Inventory HQ'),
              const SizedBox(height: 8),
              for (final item in items) ...[
                Text('${item.itemCode} • ${item.itemName}'),
                Text('Metal: ${item.metalType} | Weight: ${controller.formatWeight(item.metalWeight)}'),
                const Divider(),
              ],
              const SizedBox(height: 8),
              const Text('Summary: Includes filters and totals when printed.'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }
}

class _PrintPendingTab extends StatelessWidget {
  const _PrintPendingTab({required this.controller});

  final ItemReportController controller;

  @override
  Widget build(BuildContext context) {
    final pending = controller.pendingLoans;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    _ItemsTab._showPrintPreview(context, controller.items, controller),
                icon: const Icon(Icons.print),
                label: const Text('Print Item Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download as PDF'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Pending Loan Report',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('S.No')),
                    DataColumn(label: Text('Loan Date')),
                    DataColumn(label: Text('Loan No')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Loan Type')),
                    DataColumn(label: Text('Loan Amount')),
                    DataColumn(label: Text('Interest Type')),
                    DataColumn(label: Text('Interest %')),
                    DataColumn(label: Text('Total Payable')),
                    DataColumn(label: Text('Paid Amount')),
                    DataColumn(label: Text('Pending Amount')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('OD %')),
                    DataColumn(label: Text('OD Amount')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: pending
                      .map(
                        (record) => DataRow(
                          cells: [
                            DataCell(Text('${record.serial}')),
                            DataCell(Text(record.formattedLoanDate)),
                            DataCell(Text(record.loanNo)),
                            DataCell(Text(record.customerName)),
                            DataCell(Text(record.loanType)),
                            DataCell(Text(record.loanAmount.toStringAsFixed(2))),
                            DataCell(Text(record.interestType)),
                            DataCell(Text('${record.interestPercent.toStringAsFixed(2)}%')),
                            DataCell(Text(record.totalPayable.toStringAsFixed(2))),
                            DataCell(Text(record.paidAmount.toStringAsFixed(2))),
                            DataCell(Text(record.pendingAmount.toStringAsFixed(2))),
                            DataCell(Text(record.formattedDueDate)),
                            DataCell(Text('${record.odPercent.toStringAsFixed(2)}%')),
                            DataCell(Text(record.odAmount.toStringAsFixed(2))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Print',
                                    onPressed: () {},
                                    icon: const Icon(Icons.print_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

