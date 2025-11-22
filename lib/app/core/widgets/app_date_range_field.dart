import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateRangeField extends StatelessWidget {
  AppDateRangeField({
    super.key,
    required this.label,
    required this.onChanged,
    DateTimeRange? value,
  }) : _value = value;

  final String label;
  final ValueChanged<DateTimeRange> onChanged;
  final DateTimeRange? _value;

  final DateFormat _format = DateFormat('dd MMM yyyy');

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _value ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: _value == null
          ? ''
          : '${_format.format(_value!.start)}  →  ${_format.format(_value!.end)}',
    );

    return GestureDetector(
      onTap: () => _pickRange(context),
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}

