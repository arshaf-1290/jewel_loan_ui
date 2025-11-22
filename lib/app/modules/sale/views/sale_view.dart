import 'package:flutter/material.dart';

import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/sale_controller.dart';

class SaleView extends StatefulWidget {
  const SaleView({super.key});

  @override
  State<SaleView> createState() => _SaleViewState();
}

class _SaleViewState extends State<SaleView> {
  late final SaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SaleController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Gold Sales',
      subtitle: 'Capture gold sales with manual gram and rate entry, and generate professional bills',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () => _controller.previewBill(context),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('Preview Bill PDF'),
        ),
        ElevatedButton.icon(
          onPressed: () => _controller.previewBill(context),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Generate Bill'),
        ),
      ],
      filters: const _SaleFilters(),
      sidePanel: const _SaleSummary(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _SaleHeaderForm(controller: _controller),
            const SizedBox(height: 24),
            _SaleLineItems(controller: _controller),
            const SizedBox(height: 24),
            _SaleHistoryTable(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _SaleFilters extends StatelessWidget {
  const _SaleFilters();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: AppTextField(label: 'Customer Name')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'Bill Number')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'From Date')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'To Date')),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 12,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Filters'),
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

class _SaleHeaderForm extends StatelessWidget {
  const _SaleHeaderForm({required this.controller});

  final SaleController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Customer & Sale Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.customerController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.contactController,
                  decoration: const InputDecoration(labelText: 'Phone / Email'),
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
                      decoration: const InputDecoration(labelText: 'Bill Date'),
                      child: Text(controller.saleDate.toString().split(' ').first),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.gramController,
                  decoration: const InputDecoration(labelText: 'Gold Weight (g)'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.rateController,
                  decoration: const InputDecoration(labelText: 'Rate per Gram'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.makingController,
                  decoration: const InputDecoration(labelText: 'Making Charges'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.wastageController,
                decoration: const InputDecoration(labelText: 'Wastage (%)'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.discountController,
                decoration: const InputDecoration(labelText: 'Discount / Scheme'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: controller.addLineItem,
              icon: const Icon(Icons.add),
              label: const Text('Add to Bill'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SaleLineItems extends StatelessWidget {
  const _SaleLineItems({required this.controller});

  final SaleController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final items = controller.saleItems;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Bill Breakdown', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            DataTable(
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Grams')),
                DataColumn(label: Text('Rate')),
                DataColumn(label: Text('Making')),
                DataColumn(label: Text('Net Amount')),
                DataColumn(label: Text('')),
              ],
              rows: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => DataRow(
                      cells: [
                        DataCell(Text(entry.value['description'].toString())),
                        DataCell(Text(entry.value['grams'].toString())),
                        DataCell(Text(entry.value['rate'].toString())),
                        DataCell(Text(entry.value['making'].toString())),
                        DataCell(Text(entry.value['net'].toString())),
                        DataCell(
                          IconButton(
                            onPressed: () => controller.removeLineItem(entry.key),
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
                child: Center(child: Text('Add line items to start building the bill.')),
              ),
          ],
        );
      },
    );
  }
}

class _SaleHistoryTable extends StatelessWidget {
  const _SaleHistoryTable({required this.controller});

  final SaleController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Recent Sales', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) => AppPaginatedTable(
            columns: const [
              AppTableColumn(label: 'Bill No', key: 'billNo'),
              AppTableColumn(label: 'Date', key: 'date'),
              AppTableColumn(label: 'Customer', key: 'customer'),
              AppTableColumn(label: 'Grams', key: 'grams', numeric: true),
              AppTableColumn(label: 'Rate', key: 'rate', numeric: true),
              AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
            ],
            rows: controller.saleRecords,
          ),
        ),
      ],
    );
  }
}

class _SaleSummary extends StatelessWidget {
  const _SaleSummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SummaryTile(title: 'Today’s Sale', value: '₹ 4,85,200'),
        _SummaryTile(title: 'Gold Sold (g)', value: '146.35 g'),
        _SummaryTile(title: 'Avg. Rate', value: '₹ 6,140'),
        SizedBox(height: 24),
        Text('Billing Options', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _Bullet(text: 'Add hallmarking and certification charges'),
        _Bullet(text: 'Configure discount / loyalty scheme'),
        _Bullet(text: 'Send invoice via WhatsApp / Email'),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.check_circle_outline, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

