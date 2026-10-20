import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(radius: 64),
          const SizedBox(height: 32),
          Text(
            tf('Welcome to {app}', params: {'app': AppInfo.instance.appName}),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              t('A sophisticated booru browser.'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t('Pick a look'),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            t('Try one on. You can always change your mind later.'),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.data.cardColor,
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
            Text(theme.name),
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
              t('Connect an account'),
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
