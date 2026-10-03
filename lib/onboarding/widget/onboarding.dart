import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/onboarding/onboarding.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Needs its own navigator for overlay widgets.
    return Navigator(
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (context) => const _OnboardingPager()),
    );
  }
}

class _OnboardingPager extends StatefulWidget {
  const _OnboardingPager();

  @override
  State<_OnboardingPager> createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<_OnboardingPager> {
  final PageController controller = PageController();
  int page = 0;
  static const int pages = 4;

  void complete() => context.read<Settings>().onboardingSeen.value = true;

  void next() => controller.nextPage(
    duration: defaultAnimationDuration,
    curve: Curves.ease,
  );

  void back() => controller.previousPage(
    duration: defaultAnimationDuration,
    curve: Curves.ease,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String host = context.watch<IdentityClient>().identity.host;
    bool isLast = page == pages - 1;
    return KeyboardDismisser(
      child: LimitedWidthLayout(
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: LimitedWidthChild(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: complete,
                          child: Text(l10n.onboardingSkip),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: (value) => setState(() => page = value),
                        children: [
                          const LanguageStep(),
                          const WelcomeStep(),
                          const ThemeStep(),
                          LoginStep(initialHost: host, onComplete: complete),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: LimitedWidthChild(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PageDots(count: pages, active: page),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (page > 0)
                          TextButton(
                            onPressed: back,
                            child: Text(l10n.onboardingBack),
                          ),
                        const Spacer(),
                        if (!isLast)
                          ElevatedButton(
                            onPressed: next,
                            child: Text(l10n.onboardingNext),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: defaultAnimationDuration,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}
