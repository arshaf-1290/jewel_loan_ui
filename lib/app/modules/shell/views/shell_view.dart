import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/shell_controller.dart';

class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final ShellController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ShellController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Row(
          children: [
            _Sidebar(theme: theme, controller: _controller),
            Expanded(
              child: Column(
                children: [
                  _TopBar(controller: _controller),
                  const Divider(height: 1),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final currentIndex = _controller.selectedIndex;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _controller.modules[currentIndex].view,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.theme, required this.controller});

  final ThemeData theme;
  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.diamond, color: AppColors.accent, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Jewel MS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Desktop Suite',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final currentIndex = controller.selectedIndex;
                final modules = controller.modules;
                final groups = controller.moduleGroups;
                return ListView(
                  children: [
                    for (final group in groups) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 12, bottom: 6),
                        child: Text(
                          group.title.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white54,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      for (final module in group.modules)
                        Builder(
                          builder: (context) {
                            final moduleIndex = modules.indexOf(module);
                            final isActive = moduleIndex == currentIndex;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => controller.selectModule(moduleIndex),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: isActive ? AppColors.sidebarActive : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    child: Row(
                                      children: [
                                        Icon(
                                          module.icon,
                                          color: isActive ? AppColors.accent : Colors.white70,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                module.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                module.subtitle,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isActive)
                                          const Icon(Icons.chevron_right, color: Colors.white70),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
       
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final module = controller.modules[controller.selectedIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(module.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(module.subtitle, style: theme.textTheme.bodySmall),
                ],
              );
            },
          ),
          const Spacer(),
          SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Quick search (Ctrl + K)',
              ),
            ),
          ),
          const SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
            ),
           
          ),
          const SizedBox(width: 24),
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text('AK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

