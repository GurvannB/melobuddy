import 'package:flutter/material.dart';
import 'package:melody/pages/chords.page.dart';

const _primary = Color(0xFF9B423E);
const _base = Color(0xFFEFE9DC);
const _paper = Color(0xFFFAF8F4);
const _contrast = Color(0xFF241A16);
const _divider = Color(0xFFEBE4D4);

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
        colorScheme: ColorScheme.fromSeed(seedColor: _primary).copyWith(
          primary: _primary,
          onPrimary: _paper,
          surface: _base,
          onSurface: _contrast,
        ),
        scaffoldBackgroundColor: _base,
        appBarTheme: const AppBarTheme(
          backgroundColor: _base,
          foregroundColor: _contrast,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: _paper,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: _divider),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: _paper,
            disabledBackgroundColor: _divider,
            disabledForegroundColor: _contrast.withValues(alpha: 0.4),
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
