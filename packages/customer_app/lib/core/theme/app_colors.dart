import 'package:flutter/material.dart';

/// LY-Elite Tourism Group Official Color Palette & Brand Tokens
class AppColors {
  const AppColors._();

  // Primary Navy Shades
  static const Color primaryNavy = Color(0xFF0E2A47);
  static const Color primaryNavyDark = Color(0xFF081A2E);

  // Secondary Gold Shades (Accents & Primary Call to Action)
  static const Color accentGold = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFE8D18F);
  static const Color goldSoftBg = Color(0xFFF9F5EA);

  // Aliases for Compatibility (حل أخطاء الاستدعاء)
  static const Color primaryGold = accentGold;
  static const Color surfaceWhite = lightCard;

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF7F4EC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF16233A);
  static const Color lightTextSecondary = Color(0xFF5C6B83);
  static const Color lightDividers = Color(0xFFE4DDC9);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0B1626);
  static const Color darkCard = Color(0xFF101F36);
  static const Color darkTextPrimary = Color(0xFFEEF1F6);
  static const Color darkTextSecondary = Color(0xFF9FB0C8);
  static const Color darkDividers = Color(0xFF22344F);

  // Status & Utility Colors
  static const Color statusPending = Color(0xFFD97706); // Amber
  static const Color statusProcessing = Color(0xFF2563EB); // Blue
  static const Color statusConfirmed = Color(0xFF059669); // Emerald
  static const Color statusIssued = Color(0xFF10B981); // Green
  static const Color statusCancelled = Color(0xFFDC2626); // Red
  static const Color statusRejected = Color(0xFFE11D48); // Rose
  static const Color statusCompleted = Color(0xFF0D9488); // Teal
}
