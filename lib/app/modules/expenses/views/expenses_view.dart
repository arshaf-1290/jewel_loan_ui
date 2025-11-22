import 'package:flutter/material.dart';

import '../../../core/widgets/module_scaffold.dart';
import '../controllers/expenses_controller.dart';
import 'expenses_ui_builders.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView>
    with TickerProviderStateMixin {
  late final ExpensesController _controller;
  TabController? _tabController;

  bool get _isEditing => _controller.isEditing;
  bool _showEditTab = false;

  int get _tabCount => _showEditTab ? 3 : 2;
  int get _editTabIndex => _showEditTab ? 2 : -1;

  @override
  void initState() {
    super.initState();
    _controller = ExpensesController();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController!.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Expenses Entry',
      subtitle: 'Record operational expenses; automatically update ledger and P&L',
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelPadding: const EdgeInsets.symmetric(horizontal: 24),
            onTap: _handleTabTap,
             tabs: [
               const Tab(text: 'Entry'),
               const Tab(text: 'View'),
               if (_showEditTab) const Tab(text: 'Edit'),
             ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
               physics: _showEditTab && _isEditing
                  ? const NeverScrollableScrollPhysics()
                  : null,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ExpenseForm(controller: _controller),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ExpenseTable(
                    controller: _controller,
                    onRowTap: (index, row) {
                       _startEditFromView(index);
                    },
                  ),
                ),
                if (_showEditTab)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ExpenseEditTab(
                      controller: _controller,
                      onCancel: _handleCancelEdit,
                      onDelete: _handleDeleteEdit,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabTap(int index) {
    final controller = _tabController;
    if (controller == null) return;
    if (_isEditing && index != _editTabIndex && _editTabIndex != -1) {
      _showEditLockedMessage(context);
      return;
    }
    if (index >= controller.length) return;
    controller.animateTo(index);
  }

  void _handleTabChange() {
    final controller = _tabController;
    if (controller == null) return;
    if (!_isEditing || !_showEditTab) return;
    if (controller.index != _editTabIndex && _editTabIndex != -1) {
      // Force stay on Edit tab
      if (_editTabIndex >= 0 && _editTabIndex < controller.length) {
        controller.animateTo(_editTabIndex);
      }
      _showEditLockedMessage(context);
    }
  }

  void _startEditFromView(int index) {
    _controller.startEdit(index);
    final wasShowingEdit = _showEditTab;
    setState(() {
      _showEditTab = true;
      _resetTabController(targetIndex: _editTabIndex);
    });

    if (!wasShowingEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabController != null && _editTabIndex != -1) {
          _tabController!.animateTo(_editTabIndex);
        }
      });
    } else {
      if (_tabController != null && _editTabIndex != -1) {
        _tabController!.animateTo(_editTabIndex);
      }
    }
  }

  void _handleCancelEdit() {
    _controller.cancelEdit();
    setState(() {
      _showEditTab = false;
      _resetTabController(targetIndex: 1); // back to View
    });
  }

  void _handleDeleteEdit() {
    _controller.deleteCurrentEditing();
    setState(() {
      _showEditTab = false;
      _resetTabController(targetIndex: 1); // back to View
    });
  }

  void _resetTabController({int targetIndex = 0}) {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();

    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController!.addListener(_handleTabChange);

    if (targetIndex >= _tabCount) {
      targetIndex = _tabCount - 1;
    }
    _tabController!.index = targetIndex.clamp(0, _tabCount - 1);
  }
}

void _showEditLockedMessage(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Save or cancel the edit before switching tabs.'),
        duration: Duration(seconds: 2),
      ),
    );
}
