import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.isDense = true,
  });

  final List<T> items;
  final T? value;
  final String Function(T value) itemLabel;
  final String? label;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isDense: isDense,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

