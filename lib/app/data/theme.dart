import 'package:e1547/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MaterialColor primarySwatch = MaterialColor(0xFFFCB328, <int, Color>{
  50: Color(0xFFFFF6E5),
  100: Color(0xFFFEE8BF),
  200: Color(0xFFFED994),
  300: Color(0xFFFDCA69),
  400: Color(0xFFFCBE48),
  500: Color(0xFFFCB328),
  600: Color(0xFFFCAC24),
  700: Color(0xFFFBA31E),
  800: Color(0xFFFB9A18),
  900: Color(0xFFFA8B0F),
});

final Color accentColor = primarySwatch.shade400;

enum AppTheme {
  dark,
  amoled,
  light,
  blue,
  system;

  /// Resolves [AppTheme.system] against a platform brightness.
  ///
  /// All other themes resolve to themselves.
  AppTheme resolve(Brightness brightness) => switch (this) {
    AppTheme.system =>
      brightness == Brightness.dark ? AppTheme.dark : AppTheme.light,
    _ => this,
  };

  /// A preview decoration for theme pickers.
  ///
  /// [AppTheme.system] gets a split light and dark circle, since it has
  /// no colors of its own.
  BoxDecoration get swatch => switch (this) {
    AppTheme.system => BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        stops: const [0, 0.5, 0.5, 1],
        colors: [
          AppTheme.light.data.cardColor,
          AppTheme.light.data.cardColor,
          AppTheme.dark.data.cardColor,
          AppTheme.dark.data.cardColor,
        ],
      ),
    ),
    _ => BoxDecoration(shape: BoxShape.circle, color: data.cardColor),
  };

  ThemeData get data {
    switch (this) {
      case AppTheme.system:
        throw UnsupportedError(
          'AppTheme.system has no ThemeData of its own, resolve it against '
          'the platform brightness first',
        );
      case AppTheme.light:
        return M2ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: accentColor,
            cardColor: Colors.white,
            backgroundColor: Colors.grey[50],
          ),
        ).copyWith(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
          ),
        );
      case AppTheme.dark:
        return M2ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: accentColor,
            cardColor: Colors.grey[900],
            backgroundColor: const Color.fromARGB(255, 20, 20, 20),
            brightness: Brightness.dark,
          ),
        );
      case AppTheme.amoled:
        return M2ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: accentColor,
            cardColor: const Color.fromARGB(255, 20, 20, 20),
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
          ),
        );
      case AppTheme.blue:
        return M2ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: accentColor,
            cardColor: const Color.fromARGB(255, 31, 60, 103),
            backgroundColor: const Color.fromARGB(255, 15, 33, 60),
            brightness: Brightness.dark,
          ),
        );
    }
  }
}

extension M2ThemeData on ThemeData {
  static ThemeData from({required ColorScheme colorScheme}) {
    final bool isDark = colorScheme.brightness == Brightness.dark;

    final Color primarySurfaceColor = isDark
        ? colorScheme.surface
        : colorScheme.primary;
    final Color onPrimarySurfaceColor = isDark
        ? colorScheme.onSurface
        : colorScheme.onPrimary;

    return prepareTheme(
      ThemeData(
        colorScheme: colorScheme,
        brightness: colorScheme.brightness,
        primaryColor: primarySurfaceColor,
        // ignore: deprecated_member_use
        canvasColor: colorScheme.background,
        // ignore: deprecated_member_use
        scaffoldBackgroundColor: colorScheme.background,
        cardColor: colorScheme.surface,
        dividerColor: colorScheme.onSurface.withAlpha(31),
        // ignore: deprecated_member_use
        dialogBackgroundColor: colorScheme.background,
        tabBarTheme: TabBarThemeData(indicatorColor: onPrimarySurfaceColor),
        applyElevationOverlayColor: isDark,
        useMaterial3: false,
      ),
    );
  }

  static ThemeData prepareTheme(ThemeData theme) => theme.copyWith(
    applyElevationOverlayColor: false,
    appBarTheme: theme.appBarTheme.copyWith(
      surfaceTintColor:
          theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      backgroundColor: theme.canvasColor,
      foregroundColor: theme.iconTheme.color,
    ),
    dialogTheme: theme.dialogTheme.copyWith(
      backgroundColor: theme.canvasColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    cardTheme: theme.cardTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: theme.cardTheme.color,
    ),
    bannerTheme: theme.bannerTheme.copyWith(backgroundColor: theme.canvasColor),
    tooltipTheme: theme.tooltipTheme.copyWith(
      waitDuration: const Duration(milliseconds: 400),
    ),
    snackBarTheme: theme.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
      width: 600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

class AndroidStretchScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (getPlatform(context) == TargetPlatform.android) {
      return StretchingOverscrollIndicator(
        axisDirection: details.direction,
        child: child,
      );
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}

/// Localized display names for theme pickers.
String localizedThemeName(BuildContext context, AppTheme theme) =>
    switch (theme) {
      AppTheme.dark => AppLocalizations.of(context).themeDark,
      AppTheme.amoled => AppLocalizations.of(context).themeAmoled,
      AppTheme.light => AppLocalizations.of(context).themeLight,
      AppTheme.blue => AppLocalizations.of(context).themeBlue,
      AppTheme.system => AppLocalizations.of(context).themeSystem,
    };
