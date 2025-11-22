import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_date_range_field.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/info_tile.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/stock_controller.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  late final StockController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StockController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Stock Register',
      subtitle: 'Track metal purity, weights, valuation, and inventory movement',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download),
          label: const Text('Export Stock'),
        ),
        ElevatedButton.icon(
          onPressed: () => _controller.openAddStockDialog(context),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Add Stock Item'),
        ),
      ],
      filters: _StockFilters(controller: _controller),
      sidePanel: _StockHighlights(controller: _controller),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => AppPaginatedTable(
          columns: const [
            AppTableColumn(label: 'Item', key: 'item'),
            AppTableColumn(label: 'Category', key: 'category'),
            AppTableColumn(label: 'Metal', key: 'metal'),
            AppTableColumn(label: 'Gross Wt (g)', key: 'grossWeight', numeric: true),
            AppTableColumn(label: 'Net Wt (g)', key: 'netWeight', numeric: true),
            AppTableColumn(label: 'Making', key: 'making', numeric: true),
            AppTableColumn(label: 'Stock Value', key: 'stockValue', numeric: true),
          ],
          rows: _controller.stockItems,
        ),
      ),
    );
  }
}

class _StockFilters extends StatelessWidget {
  const _StockFilters({required this.controller});

  final StockController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppSearchField(
                hintText: 'Search by item, metal or barcode',
                onChanged: controller.applySearch,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => AppDropdownField<String>(
                  label: 'Category',
                  value: controller.categoryFilter,
                  items: controller.categories,
                  itemLabel: (item) => item,
                  onChanged: controller.changeCategory,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => AppDateRangeField(
                  label: 'Stocked Between',
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

class _StockHighlights extends StatelessWidget {
  const _StockHighlights({required this.controller});

  final StockController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        InfoTile(
          title: 'Total Gross Weight',
          value: '1,245.55 g',
          icon: Icons.scale,
          color: AppColors.primary,
        ),
        InfoTile(
          title: 'Total Net Gold Weight',
          value: '1,042.18 g',
          icon: Icons.workspace_premium_outlined,
          color: AppColors.accent,
        ),
        InfoTile(
          title: 'Inventory Value',
          value: '₹ 8,54,23,900',
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.secondary,
        ),
        SizedBox(height: 24),
        Text(
          'Quick Actions',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        SizedBox(height: 16),
        _QuickAction(
          icon: Icons.qr_code_scanner,
          label: 'Scan Barcode',
        ),
        _QuickAction(
          icon: Icons.compare_arrows,
          label: 'Stock Transfer',
        ),
        _QuickAction(
          icon: Icons.inventory_2_outlined,
          label: 'Stock Audit Checklist',
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: theme.dividerColor),
        ],
      ),
    );
  }
}

