import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class LanguageStep extends StatelessWidget {
  const LanguageStep({super.key});

  @override
  Widget build(BuildContext context) {
    Settings settings = context.watch<Settings>();
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.onboardingLanguageTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<String?>(
              valueListenable: settings.language,
              builder: (context, value, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(l10n.languageSystemDefault),
                    trailing: value == null ? const Icon(Icons.check) : null,
                    onTap: () => settings.language.value = null,
                  ),
                  ...appLanguages.map(
                    (language) => ListTile(
                      title: Text(language.label),
                      trailing: value == language.value
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => settings.language.value = language.value,
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

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(radius: 64),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingWelcomeTitle(AppInfo.instance.appName),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.onboardingWelcomeBody,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeStep extends StatelessWidget {
  const ThemeStep({super.key});

  @override
  Widget build(BuildContext context) {
    Settings settings = context.watch<Settings>();
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.onboardingThemeTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingThemeBody,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ValueListenableBuilder(
            valueListenable: settings.theme,
            builder: (context, current, child) => Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: AppTheme.values
                  .map(
                    (theme) => _ThemeSwatch(
                      theme: theme,
                      selected: theme == current,
                      onTap: () => settings.theme.value = theme,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final AppTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: theme.swatch.copyWith(
                border: Border.all(color: border, width: selected ? 3 : 1),
              ),
              child: selected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(localizedThemeName(context, theme)),
          ],
        ),
      ),
    );
  }
}

class LoginStep extends StatelessWidget {
  const LoginStep({
    super.key,
    required this.initialHost,
    required this.onComplete,
  });

  final String initialHost;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).onboardingLoginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AccountForm(initialHost: initialHost, onSubmitted: onComplete),
          ],
        ),
      ),
    );
  }
}
