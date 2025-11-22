import 'package:intl/intl.dart';

class TrialBalanceController {
  TrialBalanceController();

  final DateTime selectedDate = DateTime(2025, 11, 12);

  final List<TrialBalanceSection> sections = const [
    TrialBalanceSection(
      title: 'Cash in hand',
      entries: [TrialBalanceEntry(label: 'Cash A/c', credit: 52600)],
    ),
    TrialBalanceSection(
      title: 'Expenses',
      entries: [TrialBalanceEntry(label: 'EB bill', credit: 40000)],
    ),
    TrialBalanceSection(
      title: 'Bank',
      entries: [TrialBalanceEntry(label: 'Current Account', debit: 90000)],
    ),
    TrialBalanceSection(
      title: 'Loans & Advances',
      entries: [TrialBalanceEntry(label: 'Staff Advance', debit: 78000)],
    ),
    TrialBalanceSection(
      title: 'Fixed Assets',
      entries: [TrialBalanceEntry(label: 'Office Equipment', debit: 112000)],
    ),
    TrialBalanceSection(
      title: 'Inventory',
      entries: [TrialBalanceEntry(label: 'Gold Stock', debit: 65000)],
    ),
    TrialBalanceSection(
      title: 'Receivables',
      entries: [
        TrialBalanceEntry(label: 'Personal Loan Receivables', debit: 74000),
      ],
    ),
    TrialBalanceSection(
      title: 'Other Assets',
      entries: [TrialBalanceEntry(label: 'Prepaid Insurance', debit: 41000)],
    ),
  ];

  NumberFormat get _amountFormatter => NumberFormat('#,##,##0.00', 'en_IN');

  String get formattedSelectedDate =>
      DateFormat('dd-MM-yyyy').format(selectedDate);

  int get recordCount => recordCountFor(sections);

  double get totalDebit => totalDebitFor(sections);

  double get totalCredit => totalCreditFor(sections);

  double get creditDifference => (totalDebit - totalCredit).abs();

  double get grandTotal => totalDebit >= totalCredit ? totalDebit : totalCredit;

  TrialBalanceSummary get summary => summaryFor(sections);

  List<TrialBalanceSection> filterSections(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return sections;
    }
    return sections
        .map((section) {
          final matchesSection = section.title.toLowerCase().contains(trimmed);
          if (matchesSection) {
            return section;
          }
          final filteredEntries = section.entries
              .where((entry) => entry.label.toLowerCase().contains(trimmed))
              .toList();
          if (filteredEntries.isEmpty) {
            return null;
          }
          return TrialBalanceSection(
            title: section.title,
            entries: filteredEntries,
          );
        })
        .whereType<TrialBalanceSection>()
        .toList();
  }

  int recordCountFor(List<TrialBalanceSection> source) =>
      source.fold(0, (count, section) => count + section.entries.length);

  double totalDebitFor(List<TrialBalanceSection> source) =>
      source.fold(0, (sum, section) => sum + section.totalDebit);

  double totalCreditFor(List<TrialBalanceSection> source) =>
      source.fold(0, (sum, section) => sum + section.totalCredit);

  double creditDifferenceFor(List<TrialBalanceSection> source) {
    final debit = totalDebitFor(source);
    final credit = totalCreditFor(source);
    return (debit - credit).abs();
  }

  double grandTotalFor(List<TrialBalanceSection> source) {
    final debit = totalDebitFor(source);
    final credit = totalCreditFor(source);
    return debit >= credit ? debit : credit;
  }

  TrialBalanceSummary summaryFor(List<TrialBalanceSection> source) =>
      TrialBalanceSummary(
        totalDebit: totalDebitFor(source),
        totalCredit: totalCreditFor(source),
        creditDifference: creditDifferenceFor(source),
        overallTotal: grandTotalFor(source),
      );

  String formatAmount(double amount, {bool hideZero = false}) {
    if (hideZero && amount == 0) {
      return '';
    }
    return _amountFormatter.format(amount);
  }

  String formatOptional(double? amount) {
    if (amount == null) {
      return '';
    }
    return formatAmount(amount, hideZero: true);
  }
}

class TrialBalanceSection {
  const TrialBalanceSection({required this.title, required this.entries});

  final String title;
  final List<TrialBalanceEntry> entries;

  double get totalDebit =>
      entries.fold(0, (sum, entry) => sum + (entry.debit ?? 0));

  double get totalCredit =>
      entries.fold(0, (sum, entry) => sum + (entry.credit ?? 0));
}

class TrialBalanceEntry {
  const TrialBalanceEntry({required this.label, this.debit, this.credit});

  final String label;
  final double? debit;
  final double? credit;
}

class TrialBalanceSummary {
  const TrialBalanceSummary({
    required this.totalDebit,
    required this.totalCredit,
    required this.creditDifference,
    required this.overallTotal,
  });

  final double totalDebit;
  final double totalCredit;
  final double creditDifference;
  final double overallTotal;
}
