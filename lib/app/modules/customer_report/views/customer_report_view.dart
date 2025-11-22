import 'package:flutter/material.dart';

import '../../../core/widgets/app_paginated_table.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/customer_report_controller.dart';
part 'customer_report_ui_builders.dart';

class CustomerReportView extends StatefulWidget {
  const CustomerReportView({super.key});

  @override
  State<CustomerReportView> createState() => _CustomerReportViewState();
}

class _CustomerReportViewState extends State<CustomerReportView> {
  late final CustomerReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomerReportController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Customer Intelligence',
      subtitle: 'Customer purchase summary, outstanding, visit history and contact details',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.mail_outline),
          label: const Text('Send Statement'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Export PDF'),
        ),
      ],
      filters: _CustomerFilters(controller: _controller),
      sidePanel: const _CustomerHighlights(),
      child: Column(
        children: [
          _CustomerTable(controller: _controller),
        ],
      ),
    );
  }
}

