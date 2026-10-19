import 'package:flutter/material.dart';
import 'package:melody/colors.dart';
import 'package:melody/pages/chords.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melody',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.paper,
          surface: AppColors.base,
          onSurface: AppColors.contrast,
        ),
        scaffoldBackgroundColor: AppColors.base,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.base,
          foregroundColor: AppColors.contrast,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.paper,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.divider),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.paper,
            disabledBackgroundColor: AppColors.divider,
            disabledForegroundColor: AppColors.contrast.withValues(alpha: 0.4),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const ChordsPage(),
    );
  }
}
