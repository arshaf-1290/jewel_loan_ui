import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/daily_metal_rate_controller.dart';

class DailyMetalRateView extends StatefulWidget {
  const DailyMetalRateView({super.key});

  @override
  State<DailyMetalRateView> createState() => _DailyMetalRateViewState();
}

class _DailyMetalRateViewState extends State<DailyMetalRateView>
    with TickerProviderStateMixin {
  late final DailyMetalRateController controller;
  late TabController tabController;

  DateTime _entryDate = DateTime.now();
  final TextEditingController _createdByCtrl = TextEditingController(
    text: 'STF-2025-0001',
  );
  final TextEditingController _goldRateCtrl = TextEditingController();
  final TextEditingController _silverRateCtrl = TextEditingController();
  final TextEditingController _platinumRateCtrl = TextEditingController();
  final TextEditingController _diamondRateCtrl = TextEditingController();
  final TextEditingController _remarksCtrl = TextEditingController();

  DateTimeRange? _viewRange;

  String? _selectedRecordId;
  bool _showEditTab = false;
  final TextEditingController _editGoldCtrl = TextEditingController();
  final TextEditingController _editSilverCtrl = TextEditingController();
  final TextEditingController _editPlatinumCtrl = TextEditingController();
  final TextEditingController _editDiamondCtrl = TextEditingController();
  final TextEditingController _editRemarksCtrl = TextEditingController();
  final TextEditingController _editStaffCtrl = TextEditingController(
    text: 'STF-2025-0005',
  );

  final TextEditingController _deleteReasonCtrl = TextEditingController();
  final TextEditingController _deleteStaffCtrl = TextEditingController(
    text: 'Admin',
  );

  @override
  void initState() {
    super.initState();
    controller = DailyMetalRateController();
    _initTabController();
  }

  int get _tabCount => 2 + (_showEditTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? 2 : -1;

  void _initTabController({int initialIndex = 0}) {
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: initialIndex.clamp(0, _tabCount - 1),
    );
    tabController.addListener(_handleTabChange);
  }

  void _syncTabController(int targetIndex) {
    final newCount = _tabCount;
    final clampedIndex = newCount == 0 ? 0 : targetIndex.clamp(0, newCount - 1);
    if (tabController.length == newCount) {
      tabController.animateTo(clampedIndex);
      return;
    }
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    _initTabController(initialIndex: clampedIndex);
    setState(() {});
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    _createdByCtrl.dispose();
    _goldRateCtrl.dispose();
    _silverRateCtrl.dispose();
    _platinumRateCtrl.dispose();
    _diamondRateCtrl.dispose();
    _remarksCtrl.dispose();
    _editGoldCtrl.dispose();
    _editSilverCtrl.dispose();
    _editPlatinumCtrl.dispose();
    _editDiamondCtrl.dispose();
    _editRemarksCtrl.dispose();
    _editStaffCtrl.dispose();
    _deleteReasonCtrl.dispose();
    _deleteStaffCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickEntryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
    }
  }

  Future<void> _pickViewRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _viewRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _viewRange = picked);
    }
  }

  void _resetEntryForm() {
    _goldRateCtrl.clear();
    _silverRateCtrl.clear();
    _platinumRateCtrl.clear();
    _diamondRateCtrl.clear();
    _remarksCtrl.clear();
  }

  void _populateEditForm(String id) {
    final record = controller.records.firstWhere((element) => element.id == id);
    _editGoldCtrl.text = record.goldRate.toStringAsFixed(2);
    _editSilverCtrl.text = record.silverRate.toStringAsFixed(2);
    _editPlatinumCtrl.text = record.platinumRate.toStringAsFixed(2);
    _editDiamondCtrl.text = record.diamondRate.toStringAsFixed(2);
    _editRemarksCtrl.text = record.remarks;
  }

  void _selectRecord(String id) {
    setState(() {
      _selectedRecordId = id;
      _showEditTab = true;
      _populateEditForm(id);
    });
    _syncTabController(_editTabIndex);
  }

  void _cancelEdit() {
    setState(() {
      _selectedRecordId = null;
      _showEditTab = false;
      _editGoldCtrl.clear();
      _editSilverCtrl.clear();
      _editPlatinumCtrl.clear();
      _editDiamondCtrl.clear();
      _editRemarksCtrl.clear();
    });
    _syncTabController(0);
  }

  void _handleTabTap(int index) {
    // Allow free navigation between tabs
  }

  void _handleTabChange() {
    // Allow free navigation between tabs
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final latestId = controller.generateNextId(_entryDate);
                final filteredRecords = controller.filterByRange(_viewRange);
                final activeRecords = controller.records
                    .where((r) => r.isActive)
                    .toList();
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 16,
                          offset: Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.6),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                         
                        ),
                        TabBar(
                          controller: tabController,
                          onTap: _handleTabTap,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.onSurface.withOpacity(
                            0.6,
                          ),
                          indicatorColor: AppColors.primary,
                          tabs: [
                            const Tab(text: 'Value Entry'),
                            const Tab(text: 'Value View'),
                            if (_showEditTab) const Tab(text: 'Value Edit'),
                          ],
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              _EntryTab(
                                valueId: latestId,
                                date: _entryDate,
                                onChangeDate: _pickEntryDate,
                                createdByCtrl: _createdByCtrl,
                                goldCtrl: _goldRateCtrl,
                                silverCtrl: _silverRateCtrl,
                                platinumCtrl: _platinumRateCtrl,
                                diamondCtrl: _diamondRateCtrl,
                                remarksCtrl: _remarksCtrl,
                                onSubmit: () {
                                  if (_goldRateCtrl.text.isEmpty ||
                                      _silverRateCtrl.text.isEmpty ||
                                      _platinumRateCtrl.text.isEmpty ||
                                      _diamondRateCtrl.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all rate fields.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  controller.addRecord(
                                    date: _entryDate,
                                    createdBy: _createdByCtrl.text.trim(),
                                    goldRate: double.parse(_goldRateCtrl.text),
                                    silverRate: double.parse(
                                      _silverRateCtrl.text,
                                    ),
                                    platinumRate: double.parse(
                                      _platinumRateCtrl.text,
                                    ),
                                    diamondRate: double.parse(
                                      _diamondRateCtrl.text,
                                    ),
                                    remarks: _remarksCtrl.text.trim(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Daily rate record saved successfully.',
                                      ),
                                    ),
                                  );
                                  _resetEntryForm();
                                },
                              ),
                              _ViewTab(
                                records: filteredRecords,
                                controller: controller,
                                filterRange: _viewRange,
                                onPickRange: _pickViewRange,
                                onSelectRecord: _selectRecord,
                              ),
                              if (_showEditTab)
                                _EditTab(
                                  records: activeRecords,
                                  controller: controller,
                                  selectedId: _selectedRecordId,
                                  onSelectRecord: (id) {
                                    setState(() => _selectedRecordId = id);
                                    if (id != null) {
                                      _populateEditForm(id);
                                    }
                                  },
                                  goldCtrl: _editGoldCtrl,
                                  silverCtrl: _editSilverCtrl,
                                  platinumCtrl: _editPlatinumCtrl,
                                  diamondCtrl: _editDiamondCtrl,
                                  remarksCtrl: _editRemarksCtrl,
                                  staffCtrl: _editStaffCtrl,
                                  onCancel: _cancelEdit,
                                ),
                            ],
                          ),
                        ),
                      ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTab extends StatelessWidget {
  const _EntryTab({
    required this.valueId,
    required this.date,
    required this.onChangeDate,
    required this.createdByCtrl,
    required this.goldCtrl,
    required this.silverCtrl,
    required this.platinumCtrl,
    required this.diamondCtrl,
    required this.remarksCtrl,
    required this.onSubmit,
  });

  final String valueId;
  final DateTime date;
  final VoidCallback onChangeDate;
  final TextEditingController createdByCtrl;
  final TextEditingController goldCtrl;
  final TextEditingController silverCtrl;
  final TextEditingController platinumCtrl;
  final TextEditingController diamondCtrl;
  final TextEditingController remarksCtrl;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ReadOnlyField(label: 'Value ID', value: valueId, labelStyle: labelStyle, textStyle: textStyle),
              _DateSelector(
                label: 'Rate Date',
                date: date,
                onTap: onChangeDate,
                labelStyle: labelStyle,
                textStyle: textStyle,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: createdByCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Created By (Staff ID)',
                    labelStyle: labelStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Metal Rates',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _NumericField(controller: goldCtrl, label: 'Gold Rate (₹/gram)', labelStyle: labelStyle, textStyle: textStyle),
              _NumericField(
                controller: silverCtrl,
                label: 'Silver Rate (₹/gram)',
                labelStyle: labelStyle,
                textStyle: textStyle,
              ),
              _NumericField(
                controller: platinumCtrl,
                label: 'Platinum Rate (₹/gram)',
                labelStyle: labelStyle,
                textStyle: textStyle,
              ),
              _NumericField(
                controller: diamondCtrl,
                label: 'Diamond Rate (₹/carat)',
                labelStyle: labelStyle,
                textStyle: textStyle,
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: remarksCtrl,
            maxLines: 3,
            style: textStyle,
            decoration: InputDecoration(
              labelText: 'Remarks (Optional)',
              labelStyle: labelStyle,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Daily Rate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewTab extends StatefulWidget {
  const _ViewTab({
    required this.records,
    required this.controller,
    required this.filterRange,
    required this.onPickRange,
    required this.onSelectRecord,
  });

  final List<DailyMetalRateRecord> records;
  final DailyMetalRateController controller;
  final DateTimeRange? filterRange;
  final VoidCallback onPickRange;
  final ValueChanged<String> onSelectRecord;

  @override
  State<_ViewTab> createState() => _ViewTabState();
}

class _ViewTabState extends State<_ViewTab> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: widget.onPickRange,
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: Text(
                  widget.filterRange == null
                      ? 'Filter by Date Range'
                      : '${DateFormat('dd MMM yyyy').format(widget.filterRange!.start)} - ${DateFormat('dd MMM yyyy').format(widget.filterRange!.end)}',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (widget.filterRange != null)
                TextButton(
                  onPressed: widget.onPickRange,
                  child: const Text('Clear Filter'),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
            child: SingleChildScrollView(
                controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 48,
                  ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Value ID')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Gold (₹/g)')),
                  DataColumn(label: Text('Silver (₹/g)')),
                  DataColumn(label: Text('Platinum (₹/g)')),
                  DataColumn(label: Text('Diamond (₹/ct)')),
                  DataColumn(label: Text('Created By')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Remarks')),
                ],
                  rows: widget.records
                    .map(
                      (record) => DataRow(
                        cells: [
                          DataCell(
                            Text(record.id),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(record.formattedDate),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(widget.controller.formatCurrency(record.goldRate)),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(widget.controller.formatCurrency(record.silverRate)),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(
                              widget.controller.formatCurrency(record.platinumRate),
                            ),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(widget.controller.formatCurrency(record.diamondRate)),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(record.createdBy),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: record.isActive
                                    ? Colors.green.withOpacity(0.12)
                                    : Colors.orange.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                record.status,
                                style: TextStyle(
                                  color: record.isActive
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                          DataCell(
                            Text(record.remarks.isEmpty ? '-' : record.remarks),
                            onTap: () => widget.onSelectRecord(record.id),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ],
    );
    return content;
  }
}

class _GradientScrollbar extends StatefulWidget {
  const _GradientScrollbar({
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<_GradientScrollbar> createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<_GradientScrollbar> {
  bool _isDragging = false;
  double _dragStartPosition = 0.0;
  double _dragStartScrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!widget.controller.hasClients) {
                return const SizedBox.shrink();
              }
              
              return AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final maxScrollExtent = widget.controller.position.maxScrollExtent;
                  final minScrollExtent = widget.controller.position.minScrollExtent;
                  final scrollExtent = maxScrollExtent - minScrollExtent;
                  
                  if (scrollExtent <= 0) {
                    return const SizedBox.shrink();
                  }
                  
                  final viewportDimension = widget.controller.position.viewportDimension;
                  final thumbExtent = (viewportDimension / (scrollExtent + viewportDimension)) * constraints.maxWidth;
                  final scrollOffset = widget.controller.position.pixels - minScrollExtent;
                  final thumbOffset = (scrollOffset / scrollExtent) * (constraints.maxWidth - thumbExtent);
                  
                  return GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragStartPosition = details.localPosition.dx;
                        _dragStartScrollOffset = widget.controller.position.pixels;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final delta = details.localPosition.dx - _dragStartPosition;
                        final scrollDelta = (delta / (constraints.maxWidth - thumbExtent)) * scrollExtent;
                        final newScrollOffset = (_dragStartScrollOffset + scrollDelta).clamp(
                          minScrollExtent,
                          maxScrollExtent,
                        );
                        widget.controller.jumpTo(newScrollOffset);
                      }
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Stack(
                        children: [
                          Positioned(
                            left: thumbOffset.clamp(0.0, constraints.maxWidth - thumbExtent),
                            width: thumbExtent.clamp(20.0, constraints.maxWidth),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF8C6A2F), // Brown color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.records,
    required this.controller,
    required this.selectedId,
    required this.onSelectRecord,
    required this.goldCtrl,
    required this.silverCtrl,
    required this.platinumCtrl,
    required this.diamondCtrl,
    required this.remarksCtrl,
    required this.staffCtrl,
    required this.onCancel,
  });

  final List<DailyMetalRateRecord> records;
  final DailyMetalRateController controller;
  final String? selectedId;
  final ValueChanged<String?> onSelectRecord;
  final TextEditingController goldCtrl;
  final TextEditingController silverCtrl;
  final TextEditingController platinumCtrl;
  final TextEditingController diamondCtrl;
  final TextEditingController remarksCtrl;
  final TextEditingController staffCtrl;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            child: DropdownButtonFormField<String>(
            value: selectedId,
            items: records
                .map(
                  (record) => DropdownMenuItem(
                    value: record.id,
                    child: Text(
                      '${record.id} — ${DateFormat('dd MMM yyyy').format(record.date)}',
                    ),
                  ),
                )
                .toList(),
              style: textStyle,
              decoration: InputDecoration(
                labelText: 'Select Value Entry',
                labelStyle: labelStyle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            onChanged: onSelectRecord,
            ),
          ),
          const SizedBox(height: 20),
          if (selectedId != null) ...[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _NumericField(
                  controller: goldCtrl,
                  label: 'Gold Rate (₹/gram)',
                  labelStyle: labelStyle,
                  textStyle: textStyle,
                ),
                _NumericField(
                  controller: silverCtrl,
                  label: 'Silver Rate (₹/gram)',
                  labelStyle: labelStyle,
                  textStyle: textStyle,
                ),
                _NumericField(
                  controller: platinumCtrl,
                  label: 'Platinum Rate (₹/gram)',
                  labelStyle: labelStyle,
                  textStyle: textStyle,
                ),
                _NumericField(
                  controller: diamondCtrl,
                  label: 'Diamond Rate (₹/carat)',
                  labelStyle: labelStyle,
                  textStyle: textStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarksCtrl,
              maxLines: 3,
              style: textStyle,
              decoration: InputDecoration(
                labelText: 'Remarks',
                labelStyle: labelStyle,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: TextField(
              controller: staffCtrl,
                style: textStyle,
                decoration: InputDecoration(
                labelText: 'Edited By (Staff ID)',
                  labelStyle: labelStyle,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (selectedId == null) return;
                      controller.updateRecord(
                        id: selectedId!,
                        goldRate: double.tryParse(goldCtrl.text) ?? 0,
                        silverRate: double.tryParse(silverCtrl.text) ?? 0,
                        platinumRate: double.tryParse(platinumCtrl.text) ?? 0,
                        diamondRate: double.tryParse(diamondCtrl.text) ?? 0,
                        remarks: remarksCtrl.text,
                        editedBy: staffCtrl.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Daily rate updated successfully.'),
                        ),
                      );
                      onCancel(); // Clear selection after update
                    },
                    icon: const Icon(Icons.save_alt_outlined),
                    label: const Text('Update Record'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4B1F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.textStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 48,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: Text(
              value,
          style: textStyle.copyWith(fontWeight: FontWeight.w600),
            ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
    required this.labelStyle,
    required this.textStyle,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 48,
      child: InkWell(
            onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          ),
          child: Text(
            DateFormat('dd-MMM-yyyy').format(date),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({
    required this.controller,
    required this.label,
    required this.labelStyle,
    required this.textStyle,
  });

  final TextEditingController controller;
  final String label;
  final TextStyle labelStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: textStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
