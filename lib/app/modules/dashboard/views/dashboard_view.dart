import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/dashboard_controller.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Dashboard Overview',
      subtitle: 'Monitor sales, purchases, loans and cash flow at a glance',
      filters: _RangeFilters(controller: _controller),
      child: _DashboardBody(controller: _controller),
    );
  }
}

class _RangeFilters extends StatelessWidget {
  const _RangeFilters({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    const filterOptions = [
      {'label': 'Today', 'value': 'today'},
      {'label': 'This Week', 'value': 'thisWeek'},
      {'label': 'This Month', 'value': 'thisMonth'},
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final option in filterOptions)
            ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(option['label']!),
              ),
              selected: controller.selectedRange == option['value'],
              onSelected: (_) => controller.changeRange(option['value']!),
              selectedColor: AppColors.primary.withOpacity(0.12),
              labelStyle: TextStyle(
                color: controller.selectedRange == option['value']
                    ? AppColors.primary
                    : AppColors.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: controller.selectedRange == option['value']
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.border,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetricsGrid(metrics: controller.metrics),
            const SizedBox(height: 24),
            _SalesPurchaseCard(data: controller.monthlySummary),
            const SizedBox(height: 24),
            _PendingLoansCard(loans: controller.pendingLoans),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<MetricTile> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const minTileWidth = 240.0;
        final crossAxisCount = (constraints.maxWidth / minTileWidth).floor().clamp(1, 4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _MetricTile(metric: metric);
          },
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final MetricTile metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(metric.icon, color: metric.color, size: 28),
          Text(
            metric.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            metric.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}

class _SalesPurchaseCard extends StatelessWidget {
  const _SalesPurchaseCard({required this.data});

  final List<MonthlySummary> data;

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((item) => item.maxValue).fold<double>(0, (prev, value) => value > prev ? value : prev);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sales vs Purchase',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text('Monthly summary of sales and purchases'),
                ],
              ),
              Row(
                children: const [
                  _Legend(color: Color(0xFF8C6A2F), label: 'Sales'),
                  SizedBox(width: 16),
                  _Legend(color: Color(0xFFD4AF37), label: 'Purchase'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 260,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final item in data)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _MonthlyBar(item: item, maxValue: maxValue),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _MonthlyBar extends StatelessWidget {
  const _MonthlyBar({required this.item, required this.maxValue});

  final MonthlySummary item;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final salesHeight = maxValue == 0 ? 0.0 : item.sales / maxValue;
    final purchaseHeight = maxValue == 0 ? 0.0 : item.purchase / maxValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: salesHeight.clamp(0.0, 1.0),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8C6A2F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: purchaseHeight.clamp(0.0, 1.0),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(item.month, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _PendingLoansCard extends StatelessWidget {
  const _PendingLoansCard({required this.loans});

  final List<PendingLoan> loans;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Loans',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          AppPaginatedTable(
            columns: const [
              AppTableColumn(label: 'Customer', key: 'customer'),
              AppTableColumn(label: 'Pledge ID', key: 'pledgeId'),
              AppTableColumn(label: 'Due In (Days)', key: 'dueDays'),
              AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
            ],
            rows: loans
                .map(
                  (loan) => {
                    'customer': loan.customer,
                    'pledgeId': loan.pledgeId,
                    'dueDays': '${loan.dueDays} days',
                    'amount': '₹ ${loan.amount}',
                  },
                )
                .toList(),
            rowsPerPage: 5,
          ),
        ],
      ),
    );
  }
}


