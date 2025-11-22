import 'package:flutter/material.dart';

import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> with SingleTickerProviderStateMixin {
  late final ReportsController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = ReportsController();
    _tabController = TabController(length: _controller.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Comprehensive Reports',
      subtitle: 'Generate insights across stock, purchase, sales, and loans with export capability',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.insert_drive_file_outlined),
          label: const Text('Export Excel'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Export PDF'),
        ),
      ],
      filters: const _ReportFilters(),
      sidePanel: const _ReportShortcuts(),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _controller.tabs.map((name) => Tab(text: name)).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 520,
            child: TabBarView(
              controller: _tabController,
              children: [
                _ReportTable(
                  columns: const [
                    AppTableColumn(label: 'Item', key: 'item'),
                    AppTableColumn(label: 'Category', key: 'category'),
                    AppTableColumn(label: 'Stock', key: 'stock'),
                    AppTableColumn(label: 'Value', key: 'value', numeric: true),
                  ],
                  rows: _controller.stockReport,
                ),
                _ReportTable(
                  columns: const [
                    AppTableColumn(label: 'Supplier', key: 'supplier'),
                    AppTableColumn(label: 'Invoices', key: 'invoices', numeric: true),
                    AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
                    AppTableColumn(label: 'Avg Rate', key: 'avgRate', numeric: true),
                  ],
                  rows: _controller.purchaseReport,
                ),
                _ReportTable(
                  columns: const [
                    AppTableColumn(label: 'Customer', key: 'customer'),
                    AppTableColumn(label: 'Bills', key: 'bills', numeric: true),
                    AppTableColumn(label: 'Grams', key: 'grams', numeric: true),
                    AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
                  ],
                  rows: _controller.salesReport,
                ),
                _ReportTable(
                  columns: const [
                    AppTableColumn(label: 'Loan No', key: 'loanNo'),
                    AppTableColumn(label: 'Customer', key: 'customer'),
                    AppTableColumn(label: 'Grams', key: 'grams', numeric: true),
                    AppTableColumn(label: 'Outstanding', key: 'outstanding', numeric: true),
                  ],
                  rows: _controller.loanReport,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportFilters extends StatelessWidget {
  const _ReportFilters();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: AppTextField(label: 'From Date')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'To Date')),
            SizedBox(width: 16),
            Expanded(child: AppTextField(label: 'Customer / Supplier')),
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
                label: const Text('Reset'),
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

class _ReportTable extends StatelessWidget {
  const _ReportTable({
    required this.columns,
    required this.rows,
    this.rowsPerPage = 6,
  });

  final List<AppTableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final int rowsPerPage;

  @override
  Widget build(BuildContext context) {
    return AppPaginatedTable(
      columns: columns,
      rows: rows,
      rowsPerPage: rowsPerPage,
    );
  }
}

class _ReportShortcuts extends StatelessWidget {
  const _ReportShortcuts();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Quick Links', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _Bullet(text: 'Daily sales summary'),
        _Bullet(text: 'Inventory ageing report'),
        _Bullet(text: 'Loan interest accrual report'),
        SizedBox(height: 24),
        Text('Automations', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _Bullet(text: 'Schedule email reports'),
        _Bullet(text: 'Sync with Tally / ERP'),
        _Bullet(text: 'Auto backup to cloud'),
      ],
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
            child: Icon(Icons.double_arrow, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

