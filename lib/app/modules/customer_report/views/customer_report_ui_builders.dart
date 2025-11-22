part of 'customer_report_view.dart';

class _CustomerFilters extends StatelessWidget {
  const _CustomerFilters({required this.controller});

  final CustomerReportController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _SearchField(controller: controller),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'City / Area'),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Customer Group'),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final CustomerReportController controller;

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      hintText: 'Search by name, phone or code',
      onChanged: controller.applySearch,
    );
  }
}

class _CustomerTable extends StatelessWidget {
  const _CustomerTable({required this.controller});

  final CustomerReportController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => AppPaginatedTable(
        columns: const [
          AppTableColumn(label: 'Customer Code', key: 'code'),
          AppTableColumn(label: 'Name', key: 'name'),
          AppTableColumn(label: 'Contact', key: 'contact'),
          AppTableColumn(
            label: 'Total Purchase',
            key: 'totalPurchase',
            numeric: true,
          ),
          AppTableColumn(
            label: 'Outstanding',
            key: 'outstanding',
            numeric: true,
          ),
          AppTableColumn(label: 'Last Visit', key: 'lastVisit'),
        ],
        rows: controller.customers,
        rowsPerPage: 8,
      ),
    );
  }
}

class _CustomerHighlights extends StatelessWidget {
  const _CustomerHighlights();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Highlights', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _Bullet(text: 'Top 10 customers contribute 62% revenue'),
        _Bullet(text: '5 customers have outstanding > 30 days'),
        _Bullet(text: 'Loyalty program enrolment: 68%'),
        SizedBox(height: 24),
        Text('Follow-up Queue', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _Bullet(text: 'Call Customer CUST-1010 for scheme renewal'),
        _Bullet(text: 'Invite premium customers for Dhanteras preview'),
        _Bullet(text: 'Send reminder for pending hallmark certificates'),
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
            child: Icon(Icons.person_outline, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}


