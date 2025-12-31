import 'package:flutter/material.dart';

/// Brand color palette derived from provided mockup.
class BrandColors {
  BrandColors._();

  // Core palette
  static const Color navy900 = Color(0xFF08123A); // darkest header
  static const Color navy800 = Color(0xFF0F4476); // medium blue
  static const Color navy700 = Color(0xFF0C2E55); // dark body/accent
  static const Color sand200 = Color(0xFFE8D5B5); // light background accent
  static const Color amber400 = Color(0xFFF6C04D); // CTA highlight

  // Grays
  static const Color gray900 = Color(0xFF1A1C1E);
  static const Color gray700 = Color(0xFF5F6368);
  static const Color gray500 = Color(0xFF8A8F99);
  static const Color gray300 = Color(0xFFE3E8EF);
  static const Color gray100 = Color(0xFFF5F7FA);

  // Feedback
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);
}

/// Text styles (can be extended with GoogleFonts if desired).
class BrandTextStyles {
  BrandTextStyles._();

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: BrandColors.navy900,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: BrandColors.navy900,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BrandColors.gray900,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BrandColors.gray700,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: BrandColors.gray700,
  );
}

/// Spacing scale
class BrandSpacing {
  BrandSpacing._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Radius tokens
class BrandRadius {
  BrandRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
}

/// Shadows
class BrandShadows {
  BrandShadows._();
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}

/// Common button styles (usage: style: BrandButtons.primary())
class BrandButtons {
  BrandButtons._();

  static ButtonStyle primary() => ElevatedButton.styleFrom(
        backgroundColor: BrandColors.navy900,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BrandRadius.md)),
        elevation: 0,
      );

  static ButtonStyle accent() => ElevatedButton.styleFrom(
        backgroundColor: BrandColors.amber400,
        foregroundColor: BrandColors.navy900,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BrandRadius.md)),
        elevation: 0,
      );

  static ButtonStyle destructive() => ElevatedButton.styleFrom(
        backgroundColor: BrandColors.error,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BrandRadius.md)),
        elevation: 0,
      );
}
