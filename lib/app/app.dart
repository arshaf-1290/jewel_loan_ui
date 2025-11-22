import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

class JewelApp extends StatelessWidget {
  const JewelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jewel MS',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      onGenerateRoute: AppPages.onGenerateRoute,
      builder: (context, child) {
        final theme = Theme.of(context);
        return ResponsiveBreakpoints.builder(
          child: DefaultTextStyle(
            style: GoogleFonts.inter(
              textStyle: theme.textTheme.bodyMedium,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: PHONE),
            Breakpoint(start: 600, end: 1023, name: TABLET),
            Breakpoint(start: 1024, end: 1439, name: DESKTOP),
            Breakpoint(start: 1440, end: double.infinity, name: "4K"),
          ],
        );
      },
    );
  }
}

