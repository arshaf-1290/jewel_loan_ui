import 'package:flutter/material.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/purchase_controller.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  late final PurchaseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PurchaseController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Purchase Register',
      subtitle: 'Capture bullion purchases and supplier invoices seamlessly',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Generate Purchase PDF'),
        ),
        ElevatedButton.icon(
          onPressed: _controller.addItem,
          icon: const Icon(Icons.add_box_outlined),
          label: const Text('Add Line Item'),
        ),
      ],
      filters: const _PurchaseFilters(),
      sidePanel: const _SupplierSummary(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PurchaseHeaderForm(controller: _controller),
            const SizedBox(height: 24),
            _LineItemTable(controller: _controller),
            const SizedBox(height: 24),
            _PurchaseHistoryTable(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _PurchaseFilters extends StatelessWidget {
  const _PurchaseFilters();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: AppTextField(label: 'Filter by Supplier')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'Invoice No.')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'Metal Type')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(child: AppTextField(label: 'From Date')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'To Date')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'Status')),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 12,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_delete_outlined),
                label: const Text('Clear Filters'),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt),
                label: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PurchaseHeaderForm extends StatelessWidget {
  const _PurchaseHeaderForm({required this.controller});

  final PurchaseController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Purchase Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => DropdownButtonFormField<String>(
                  value: controller.selectedSupplier,
                  decoration: const InputDecoration(labelText: 'Supplier'),
                  items: controller.suppliers
                      .map(
                        (supplier) => DropdownMenuItem(
                          value: supplier,
                          child: Text(supplier),
                        ),
                      )
                      .toList(),
                  onChanged: controller.selectSupplier,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.invoiceController,
                  decoration: const InputDecoration(labelText: 'Invoice Number'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => InkWell(
                    onTap: () => controller.pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Purchase Date'),
                      child: Text(controller.purchaseDate.toString().split(' ').first),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LineItemTable extends StatelessWidget {
  const _LineItemTable({required this.controller});

  final PurchaseController controller;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Line Items', style: TextStyle(fontWeight: FontWeight.w700)),
              TextButton.icon(
                onPressed: controller.addItem,
                icon: const Icon(Icons.playlist_add),
                label: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final items = controller.purchaseItems;
              return Column(
                children: [
                  DataTable(
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('Gross Wt')),
                      DataColumn(label: Text('Net Wt')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('Making')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('')),
                    ],
                    rows: items
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text(entry.value['item'].toString())),
                              DataCell(Text(entry.value['gross'].toString())),
                              DataCell(Text(entry.value['net'].toString())),
                              DataCell(Text(entry.value['rate'].toString())),
                              DataCell(Text(entry.value['making'].toString())),
                              DataCell(Text(entry.value['amount'].toString())),
                              DataCell(
                                IconButton(
                                  onPressed: () => controller.removeItem(entry.key),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('Add items to build the purchase register.'),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PurchaseHistoryTable extends StatelessWidget {
  const _PurchaseHistoryTable({required this.controller});

  final PurchaseController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Purchase History', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) => AppPaginatedTable(
            columns: const [
              AppTableColumn(label: 'Date', key: 'date'),
              AppTableColumn(label: 'Supplier', key: 'supplier'),
              AppTableColumn(label: 'Invoice', key: 'invoice'),
              AppTableColumn(label: 'Gross Wt', key: 'gross'),
              AppTableColumn(label: 'Net Wt', key: 'net'),
              AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
              AppTableColumn(label: 'Status', key: 'status'),
            ],
            rows: controller.purchaseHistory,
          ),
        ),
      ],
    );
  }
}

class _SupplierSummary extends StatelessWidget {
  const _SupplierSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Supplier Insights', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        _SummaryRow(label: 'Outstanding Payables', value: '₹ 18,24,000'),
        _SummaryRow(label: 'Avg. Purchase Rate', value: '₹ 6,115 / g'),
        _SummaryRow(label: 'This Month Purchases', value: '₹ 52,40,650'),
        const SizedBox(height: 24),
        Text('Tasks', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        const _TaskBullet('Reconcile supplier statement by 10 Nov'),
        const _TaskBullet('Upload assay certificate for latest lot'),
        const _TaskBullet('Review making charges variance report'),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _TaskBullet extends StatelessWidget {
  const _TaskBullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle_outline, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

