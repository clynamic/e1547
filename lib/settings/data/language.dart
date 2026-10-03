import 'dart:ui';

import 'package:e1547/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:notified_preferences/notified_preferences.dart';

/// Languages selectable in the settings.
///
/// Labels are the languages' native names and are never translated.
const List<({String value, String label})> appLanguages = [
  (value: 'en', label: 'English'),
  (value: 'zh', label: '简体中文'),
  (value: 'zh_Hant', label: '繁體中文'),
  (value: 'ja', label: '日本語'),
  (value: 'ru', label: 'Русский'),
  (value: 'de', label: 'Deutsch'),
  (value: 'es', label: 'Español'),
];

/// Parses a stored language value into a locale.
///
/// Returns null for a null value, meaning the system language.
Locale? parseLanguage(String? value) {
  if (value == null) return null;
  List<String> parts = value.split('_');
  return Locale.fromSubtags(
    languageCode: parts.first,
    scriptCode: parts.length > 1 ? parts[1] : null,
  );
}

/// Resolves the given preferred locales to a supported app locale.
///
/// Wraps [basicLocaleListResolution], additionally upgrading a generic zh
/// result to the traditional script for regions that use it, since the
/// default resolution only matches the language code. Only a generic zh
/// result is upgraded, another language is never overridden.
///
/// Used by the app's MaterialApp and by [loadPreferenceLocalizations],
/// so both resolve languages the same way.
Locale resolveAppLocale(List<Locale>? preferredLocales) {
  Locale resolved = basicLocaleListResolution(
    preferredLocales ?? const <Locale>[],
    AppLocalizations.supportedLocales,
  );
  // basicLocaleListResolution falls back to the first supported locale,
  // which is alphabetically ordered and need not be english; an unsupported
  // preferred language must still fall back to english
  final bool matchesPreference = (preferredLocales ?? const <Locale>[]).any(
    (locale) => locale.languageCode == resolved.languageCode,
  );
  if (!matchesPreference) {
    return const Locale('en');
  }
  if (resolved.languageCode != 'zh' || resolved.scriptCode != null) {
    return resolved;
  }
  for (final locale in preferredLocales ?? const <Locale>[]) {
    if (locale.languageCode != 'zh') continue;
    if (!['TW', 'HK', 'MO'].contains(locale.countryCode)) {
      continue;
    }
    const Locale traditional = Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
    );
    if (AppLocalizations.supportedLocales.contains(traditional)) {
      return traditional;
    }
  }
  return resolved;
}

/// Loads localizations for places without a [BuildContext],
/// like background isolates.
///
/// Mirrors how the app's MaterialApp resolves its locale: the stored
/// language preference comes first, followed by the platform locales for
/// the system language.
Future<AppLocalizations> loadPreferenceLocalizations() async {
  List<Locale> preferredLocales = [
    if (parseLanguage(await _readStoredLanguage()) case final Locale locale)
      locale,
    ...PlatformDispatcher.instance.locales,
  ];
  return AppLocalizations.delegate.load(resolveAppLocale(preferredLocales));
}

Future<String?> _readStoredLanguage() async {
  try {
    return (await SharedPreferences.getInstance()).getString('language');
  } on Exception {
    // Plugin access may be unavailable, e.g. in tests.
    return null;
  }
}
