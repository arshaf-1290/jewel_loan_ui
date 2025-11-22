import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/item_creation_controller.dart';

class ItemCreationView extends StatefulWidget {
  const ItemCreationView({super.key});

  @override
  State<ItemCreationView> createState() => _ItemCreationViewState();
}

class _ItemCreationViewState extends State<ItemCreationView>
    with TickerProviderStateMixin {
  late final ItemCreationController controller;
  late final TabController tabController;

  final TextEditingController itemCodeCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  String _metalType = 'Gold';
  DateTime _entryDate = DateTime.now();
  final TextEditingController hsnCtrl = TextEditingController();
  final TextEditingController metalWeightCtrl = TextEditingController();
  final TextEditingController stoneWeightCtrl = TextEditingController();
  final TextEditingController baseValueCtrl = TextEditingController();
  final TextEditingController wastageValueCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  final TextEditingController deleteReasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ItemCreationController();
    tabController = TabController(length: 3, vsync: this);
    itemCodeCtrl.text = controller.generateNextCode(_entryDate);
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    itemCodeCtrl.dispose();
    nameCtrl.dispose();
    hsnCtrl.dispose();
    metalWeightCtrl.dispose();
    stoneWeightCtrl.dispose();
    baseValueCtrl.dispose();
    wastageValueCtrl.dispose();
    locationCtrl.dispose();
    remarksCtrl.dispose();
    deleteReasonCtrl.dispose();
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
      setState(() {
        _entryDate = picked;
        if (itemCodeCtrl.text.startsWith('ITM-')) {
          itemCodeCtrl.text = controller.generateNextCode(_entryDate);
        }
      });
    }
  }

  void _resetForm() {
    itemCodeCtrl.text = controller.generateNextCode(DateTime.now());
    nameCtrl.clear();
    _metalType = 'Gold';
    _entryDate = DateTime.now();
    hsnCtrl.clear();
    metalWeightCtrl.clear();
    stoneWeightCtrl.clear();
    baseValueCtrl.clear();
    wastageValueCtrl.clear();
    locationCtrl.clear();
    remarksCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final nextCode = controller.generateNextCode(_entryDate);
          if (itemCodeCtrl.text.isEmpty) {
            itemCodeCtrl.text = nextCode;
          }
          final items = controller.items;
          final totalItems = items.length;
          final latest = items.isNotEmpty ? items.first : null;
          final latestCode = latest?.code ?? 'N/A';
          final lastEntry = latest == null
              ? '--'
              : DateFormat('dd-MMM-yyyy').format(latest.entryDate);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
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
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.onSurface.withOpacity(
                          0.6,
                        ),
                        indicatorColor: AppColors.primary,
                        tabs: const [
                          Tab(text: 'Item Entry'),
                          Tab(text: 'Item View'),
                          Tab(text: 'Item Delete'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _EntryTab(
                              itemCodeCtrl: itemCodeCtrl,
                              nameCtrl: nameCtrl,
                              metalType: _metalType,
                              onMetalTypeChanged: (value) {
                                setState(() => _metalType = value);
                              },
                              entryDate: _entryDate,
                              onChangeDate: _pickEntryDate,
                              hsnCtrl: hsnCtrl,
                              metalWeightCtrl: metalWeightCtrl,
                              stoneWeightCtrl: stoneWeightCtrl,
                              baseValueCtrl: baseValueCtrl,
                              wastageValueCtrl: wastageValueCtrl,
                              locationCtrl: locationCtrl,
                              remarksCtrl: remarksCtrl,
                              onSubmit: () {
                                if (itemCodeCtrl.text.trim().isEmpty ||
                                    nameCtrl.text.trim().isEmpty ||
                                    metalWeightCtrl.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill required fields (Item Code, Name, Metal Weight).',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                controller.addItem(
                                  ItemRecord(
                                    code: itemCodeCtrl.text.trim(),
                                    name: nameCtrl.text.trim(),
                                    metalType: _metalType,
                                    entryDate: _entryDate,
                                    hsnCode: hsnCtrl.text.trim().isEmpty
                                        ? null
                                        : hsnCtrl.text.trim(),
                                    metalWeight:
                                        double.tryParse(metalWeightCtrl.text) ??
                                        0,
                                    stoneWeight:
                                        double.tryParse(stoneWeightCtrl.text) ??
                                        0,
                                    baseValue: double.tryParse(
                                      baseValueCtrl.text.trim(),
                                    ),
                                    wastageValue: double.tryParse(
                                      wastageValueCtrl.text.trim(),
                                    ),
                                    location: locationCtrl.text.trim().isEmpty
                                        ? null
                                        : locationCtrl.text.trim(),
                                    remarks: remarksCtrl.text.trim().isEmpty
                                        ? null
                                        : remarksCtrl.text.trim(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item created successfully.'),
                                  ),
                                );
                                _resetForm();
                                setState(() {
                                  itemCodeCtrl.text = controller
                                      .generateNextCode(DateTime.now());
                                });
                              },
                            ),
                            _ViewTab(controller: controller),
                            _DeleteTab(
                              controller: controller,
                              reasonCtrl: deleteReasonCtrl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _EntryTab extends StatelessWidget {
  const _EntryTab({
    required this.itemCodeCtrl,
    required this.nameCtrl,
    required this.metalType,
    required this.onMetalTypeChanged,
    required this.entryDate,
    required this.onChangeDate,
    required this.hsnCtrl,
    required this.metalWeightCtrl,
    required this.stoneWeightCtrl,
    required this.baseValueCtrl,
    required this.wastageValueCtrl,
    required this.locationCtrl,
    required this.remarksCtrl,
    required this.onSubmit,
  });

  final TextEditingController itemCodeCtrl;
  final TextEditingController nameCtrl;
  final String metalType;
  final ValueChanged<String> onMetalTypeChanged;
  final DateTime entryDate;
  final VoidCallback onChangeDate;
  final TextEditingController hsnCtrl;
  final TextEditingController metalWeightCtrl;
  final TextEditingController stoneWeightCtrl;
  final TextEditingController baseValueCtrl;
  final TextEditingController wastageValueCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController remarksCtrl;
  final VoidCallback onSubmit;

  static const _metalTypes = ['Gold', 'Silver', 'Platinum', 'Diamond', 'Other'];

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
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
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: 200,
                height: 48,
                child: _DateSelector(
                  label: 'Date of Entry',
                  date: entryDate,
                  onTap: onChangeDate,
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: itemCodeCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Item Code',
                    labelStyle: labelStyle,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    //helperText: 'Auto generated, editable if needed',
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                height: 48,
                child: TextField(
                  controller: nameCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: labelStyle,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: metalType,
                  decoration: InputDecoration(
                    labelText: 'Metal Type',
                    labelStyle: labelStyle,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                  style: textStyle,
                  items: _metalTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onMetalTypeChanged(value);
                    }
                  },
                ),
              ),
              
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: hsnCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'HSN Code (Optional)',
                    labelStyle: labelStyle,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _NumericField(
                  controller: metalWeightCtrl,
                  label: 'Metal Weight (grams)',
                ),
              ),
              SizedBox(
                width: 160,
                height: 48,
                child: _NumericField(
                  controller: stoneWeightCtrl,
                  label: 'Stone Weight (grams / carats)',
                ),
              ),
            
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: remarksCtrl,
            style: textStyle,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes / Remarks',
              labelStyle: labelStyle,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Item'),
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
  const _ViewTab({required this.controller});

  final ItemCreationController controller;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
            DataColumn(label: Text('Item Code')),
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Metal Type')),
            DataColumn(label: Text('Date of Entry')),
            DataColumn(label: Text('HSN Code')),
            DataColumn(label: Text('Metal Weight (g)')),
            DataColumn(label: Text('Stone Weight (g / ct)')),
            DataColumn(label: Text('Location')),
            DataColumn(label: Text('Remarks')),
          ],
          rows: widget.controller.items
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item.code)),
                    DataCell(Text(item.name)),
                    DataCell(Text(item.metalType)),
                    DataCell(Text(item.formattedDate)),
                    DataCell(Text(item.hsnCode ?? '—')),
                    DataCell(Text(widget.controller.formatWeight(item.metalWeight))),
                    DataCell(Text(widget.controller.formatWeight(item.stoneWeight))),
                    DataCell(Text(item.location ?? '—')),
                    DataCell(Text(item.remarks ?? '—')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
          ),
        ),
      ),
    );
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

class _DeleteTab extends StatelessWidget {
  const _DeleteTab({required this.controller, required this.reasonCtrl});

  final ItemCreationController controller;
  final TextEditingController reasonCtrl;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: controller.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.code,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(item.name),
                    const SizedBox(height: 4),
                    Text('${item.metalType} • ${item.formattedDate}'),
                    if (item.location != null && item.location!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Location: ${item.location}'),
                      ),
                    if (item.remarks != null && item.remarks!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Notes: ${item.remarks}'),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  reasonCtrl.clear();
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        _DeleteDialog(record: item, reasonCtrl: reasonCtrl),
                  );
                  if (confirmed == true) {
                    controller.deleteItem(item.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item deleted successfully.'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({required this.record, required this.reasonCtrl});

  final ItemRecord record;
  final TextEditingController reasonCtrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete this item?'),
          const SizedBox(height: 12),
          Text('Item Code: ${record.code}'),
          Text('Item Name: ${record.name}'),
          const SizedBox(height: 12),
          TextField(
            controller: reasonCtrl,
            decoration: const InputDecoration(labelText: 'Reason (optional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('Confirm Delete'),
        ),
      ],
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd-MMM-yyyy').format(date),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

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
    return TextField(
      controller: controller,
      style: textStyle,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
