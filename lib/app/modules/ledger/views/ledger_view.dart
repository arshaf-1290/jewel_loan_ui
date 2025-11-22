import 'package:flutter/material.dart';

import '../../../core/widgets/app_date_range_field.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/ledger_controller.dart';

class LedgerView extends StatefulWidget {
  const LedgerView({super.key});

  @override
  State<LedgerView> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<LedgerView> {
  late final LedgerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LedgerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Ledger',
      subtitle: 'Monitor all accounting heads with running balance and voucher details',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Export Ledger'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.summarize_outlined),
          label: const Text('View Ledger Summary'),
        ),
      ],
      filters: _LedgerFilters(controller: _controller),
      sidePanel: const _LedgerStats(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => AppPaginatedTable(
          columns: const [
            AppTableColumn(label: 'Date', key: 'date'),
            AppTableColumn(label: 'Particulars', key: 'particulars'),
            AppTableColumn(label: 'Voucher', key: 'voucher'),
            AppTableColumn(label: 'Debit', key: 'debit', numeric: true),
            AppTableColumn(label: 'Credit', key: 'credit', numeric: true),
            AppTableColumn(label: 'Balance', key: 'balance', numeric: true),
          ],
          rows: _controller.ledgerEntries,
        ),
      ),
    );
  }
}

class _LedgerFilters extends StatelessWidget {
  const _LedgerFilters({required this.controller});

  final LedgerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppSearchField(
                hintText: 'Search by voucher, customer or reference',
                onChanged: (_) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => AppDropdownField<String>(
                  label: 'Ledger Head',
                  value: controller.selectedHead,
                  items: controller.heads,
                  itemLabel: (item) => item,
                  onChanged: controller.changeHead,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => AppDateRangeField(
                  label: 'Date Range',
                  value: controller.dateRange,
                  onChanged: controller.updateDateRange,
                ),
              ),
            ),
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

class _LedgerStats extends StatelessWidget {
  const _LedgerStats();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Metrics', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        _StatItem(label: 'Opening Balance', value: '₹ 12,45,320'),
        _StatItem(label: 'Closing Balance', value: '₹ 18,62,540'),
        _StatItem(label: 'Total Debit', value: '₹ 42,18,000'),
        _StatItem(label: 'Total Credit', value: '₹ 36,01,200'),
        const SizedBox(height: 24),
        Text('Smart Suggestions', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        const _Bullet(text: 'Review negative balances for Supplier head'),
        const _Bullet(text: 'Lock ledger before finalising financials'),
        const _Bullet(text: 'Download ledger backup in Excel & PDF'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
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

