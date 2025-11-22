import 'package:flutter/material.dart';

class AppTableColumn {
  const AppTableColumn({
    required this.label,
    required this.key,
    this.numeric = false,
    this.flex = 1,
  });

  final String label;
  final String key;
  final bool numeric;
  final int flex;
}

class AppPaginatedTable extends StatefulWidget {
  const AppPaginatedTable({
    super.key,
    required this.columns,
    required this.rows,
    this.rowsPerPage = 10,
    this.onRowTap,
  });

  final List<AppTableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final int rowsPerPage;
  final void Function(int index, Map<String, dynamic> row)? onRowTap;

  @override
  State<AppPaginatedTable> createState() => _AppPaginatedTableState();
}

class _AppPaginatedTableState extends State<AppPaginatedTable> {
  late _TableDataSource _dataSource;
  late int _rowsPerPage;

  @override
  void initState() {
    super.initState();
    _dataSource = _TableDataSource(
      widget.columns,
      widget.rows,
      onRowTap: widget.onRowTap,
    );
    _rowsPerPage = widget.rowsPerPage;
  }

  @override
  void didUpdateWidget(covariant AppPaginatedTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns != widget.columns ||
        oldWidget.rows != widget.rows ||
        oldWidget.onRowTap != widget.onRowTap) {
      setState(() {
        _dataSource = _TableDataSource(
          widget.columns,
          widget.rows,
          onRowTap: widget.onRowTap,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PaginatedDataTable(
        columns: widget.columns
            .map(
              (column) => DataColumn(
                label: Text(column.label),
                numeric: column.numeric,
              ),
            )
            .toList(),
        source: _dataSource,
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: const [5, 10, 20, 50],
        onRowsPerPageChanged: (value) {
          if (value != null) {
            setState(() => _rowsPerPage = value);
          }
        },
        showCheckboxColumn: false,
        columnSpacing: 32,
        headingRowHeight: 48,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
      ),
    );
  }
}

class _TableDataSource extends DataTableSource {
  _TableDataSource(this.columns, this.rows, {this.onRowTap});

  final List<AppTableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final void Function(int index, Map<String, dynamic> row)? onRowTap;

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    final row = rows[index];
    return DataRow.byIndex(
      index: index,
      onSelectChanged:
          onRowTap != null ? (_) => onRowTap!.call(index, row) : null,
      cells: columns
          .map(
            (column) => DataCell(
              Text(
                '${row[column.key] ?? ''}',
                textAlign: column.numeric ? TextAlign.right : TextAlign.left,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  int get rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

