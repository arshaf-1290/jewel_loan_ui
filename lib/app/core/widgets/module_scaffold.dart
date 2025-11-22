import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_card.dart';
import 'app_page_header.dart';

class ModuleScaffold extends StatelessWidget {
  const ModuleScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.headerActions = const <Widget>[],
    this.filters,
    this.sidePanel,
    this.showHeader = true,
    this.wrapFiltersInCard = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> headerActions;
  final Widget? filters;
  final Widget? sidePanel;
  final bool showHeader;
  final bool wrapFiltersInCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSidePanel =
              sidePanel != null && constraints.maxWidth > 1280;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      AppPageHeader(
                        title: title,
                        subtitle: subtitle,
                        actions: headerActions,
                      ),
                    if (filters != null)
                      wrapFiltersInCard
                          ? AppCard(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(20),
                              child: filters!,
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: filters!,
                            ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: AppCard(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showSidePanel) ...[
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: AppCard(
                    padding: const EdgeInsets.all(24),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppColors.border.withOpacity(0.6),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: sidePanel!,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
