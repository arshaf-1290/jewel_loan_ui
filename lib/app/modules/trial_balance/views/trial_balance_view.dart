import 'package:flutter/material.dart';
import 'dart:ui';

import '../../../core/theme/app_colors.dart';
import '../controllers/trial_balance_controller.dart';

class TrialBalanceView extends StatefulWidget {
  const TrialBalanceView({super.key});

  @override
  State<TrialBalanceView> createState() => _TrialBalanceViewState();
}

class _TrialBalanceViewState extends State<TrialBalanceView> {
  final TrialBalanceController controller = TrialBalanceController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearch)
      ..dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() => _searchQuery = _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final sections = controller.filterSections(_searchQuery);
    final summary = controller.summaryFor(sections);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _TrialBalanceCard(
              controller: controller,
              sections: sections,
              searchController: _searchController,
              onSearchCleared: () => setState(() => _searchQuery = ''),
            ),
          ),
          const SizedBox(height: 24),
          _SummaryFooter(controller: controller, summary: summary),
        ],
      ),
    );
  }
}

class _TrialBalanceCard extends StatelessWidget {
  const _TrialBalanceCard({
    required this.controller,
    required this.sections,
    required this.searchController,
    required this.onSearchCleared,
  });

  final TrialBalanceController controller;
  final List<TrialBalanceSection> sections;
  final TextEditingController searchController;
  final VoidCallback onSearchCleared;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A8C6A2F),
            blurRadius: 28,
            offset: Offset(0, 20),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FiltersRow(
              formattedDate: controller.formattedSelectedDate,
              searchController: searchController,
              onSearchCleared: onSearchCleared,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _TrialBalanceTable(
                controller: controller,
                sections: sections,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.formattedDate,
    required this.searchController,
    required this.onSearchCleared,
  });

  final String formattedDate;
  final TextEditingController searchController;
  final VoidCallback onSearchCleared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Select Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 16),
        _DateDisplay(value: formattedDate),
        const Spacer(),
        SizedBox(
          width: 220,
          child: _LedgerSearchField(
            controller: searchController,
            onCleared: onSearchCleared,
          ),
        ),
        const SizedBox(width: 16),
        _PrimaryActionButton(
          label: 'Refresh',
          icon: Icons.refresh,
          backgroundColor: const Color(0xFF7C3AED),
          onPressed: () {},
        ),
        const SizedBox(width: 12),
        _PrimaryActionButton(
          label: 'Print',
          icon: Icons.print_outlined,
          backgroundColor: const Color(0xFFE53935),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _DateDisplay extends StatelessWidget {
  const _DateDisplay({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x148C6A2F),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          fontSize: 14,
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _LedgerSearchField extends StatelessWidget {
  const _LedgerSearchField({required this.controller, required this.onCleared});

  final TextEditingController controller;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Filter by ledger name',
        hintStyle: const TextStyle(color: Color(0xFF55609A), fontSize: 13),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: Color(0xFF142776),
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear filter',
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF142776),
                ),
                onPressed: () {
                  controller.clear();
                  onCleared();
                },
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFC8D1EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFC8D1EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF142776), width: 1.4),
        ),
        fillColor: const Color(0xFFF4F6FF),
        filled: true,
        isDense: true,
      ),
    );
  }
}

class _TrialBalanceTable extends StatelessWidget {
  const _TrialBalanceTable({required this.controller, required this.sections});

  final TrialBalanceController controller;
  final List<TrialBalanceSection> sections;

  @override
  Widget build(BuildContext context) {
    const divider = Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F4));

    final rows = <Widget>[
      Container(
        color: AppColors.primary.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: const [
            Expanded(
              flex: 3,
              child: Text(
                'Ledger',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Debit',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Credit',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      rows
        ..add(divider)
        ..add(
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: _TableValueRow(
              label: section.title.toUpperCase(),
              debit: controller.formatOptional(
                section.totalDebit > 0 ? section.totalDebit : null,
              ),
              credit: controller.formatOptional(
                section.totalCredit > 0 ? section.totalCredit : null,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
        );

      for (var j = 0; j < section.entries.length; j++) {
        final entry = section.entries[j];
        rows.add(
          Container(
            color: j.isEven ? Colors.white : AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: _TableValueRow(
              label: entry.label,
              debit: controller.formatOptional(entry.debit),
              credit: controller.formatOptional(entry.credit),
              style: const TextStyle(fontSize: 13, color: Color(0xFF4A3F2A)),
            ),
          ),
        );

        if (j < section.entries.length - 1) {
          rows.add(divider);
        }
      }

      if (i == sections.length - 1) {
        rows.add(divider);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border.withOpacity(0.8)),
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) => rows[index],
        ),
      ),
    );
  }
}

class _TableValueRow extends StatelessWidget {
  const _TableValueRow({
    required this.label,
    required this.debit,
    required this.credit,
    this.style,
  });

  final String label;
  final String debit;
  final String credit;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        style ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF1F2538),
          fontSize: 13,
        );
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label, style: effectiveStyle)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(debit, style: effectiveStyle),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(credit, style: effectiveStyle),
          ),
        ),
      ],
    );
  }
}

class _SummaryFooter extends StatelessWidget {
  const _SummaryFooter({required this.controller, required this.summary});

  final TrialBalanceController controller;
  final TrialBalanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A8C6A2F),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              label: 'Total Debit',
              value: controller.formatAmount(summary.totalDebit),
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Total Credit',
              value: controller.formatAmount(summary.totalCredit),
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Credit Diff',
              value: controller.formatAmount(summary.creditDifference),
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Total',
              value: controller.formatAmount(summary.overallTotal),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white24,
    );
  }
}
