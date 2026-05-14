import 'dart:ui';

class AppColors {
  final Color bg;
  final Color surface;
  final Color cardBg;
  final Color accent;
  final Color accentLight;
  final Color accentDark;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color border;
  final Color label;
  final Color btnUpdate;
  final Color btnDelete;
  final Color btnDegrade;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.cardBg,
    required this.accent,
    required this.accentLight,
    required this.accentDark,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.border,
    required this.label, 
    required this.btnUpdate,
    required this.btnDelete,
    required this.btnDegrade
  });

  static const dark = AppColors(
    bg: Color(0xFF0A0A0F),
    surface: Color(0xFF0E0E18),
    cardBg: Color(0xFF161624),
    accent: Color(0xFF8A5CF7),
    accentLight: Color(0xFFA88FFF),
    accentDark: Color(0xFF633CD2),
    text: Color(0xFFFFFFFF),
    textMuted: Color(0x88FFFFFF),
    textFaint: Color(0x44FFFFFF),
    border: Color(0x12FFFFFF),
    label:Color(0xFFF5F5FA),
    btnUpdate: Color(0xFF60A5FA),
    btnDelete:Color(0xFFF23861),
    btnDegrade: Color(0xFFCF343E)
  );

  static const light = AppColors(
    bg: Color(0xFFF5F5FA),
    surface: Color(0xFFFFFFFF),
    cardBg: Color(0xFFEAEAF4),
    accent: Color(0xFF1759EB),
    accentLight: Color(0xFF519AFC),
    accentDark: Color(0xFF21489E),
    text: Color(0xFF111111),
    textMuted: Color(0xFF666666),
    textFaint: Color(0xFFAAAAAA),
    border: Color(0x1A000000),
    label:Color(0xFF111111),
    btnUpdate: Color(0xFF2563EB),
    btnDelete:Color(0xFFF23861),
    btnDegrade:Color(0xFFCF343E),


  );
}
