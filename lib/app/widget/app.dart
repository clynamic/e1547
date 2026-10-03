import 'package:e1547/account/account.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/app/widget/initialize.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/onboarding/onboarding.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:relative_time/relative_time.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInit(
      child: MultiProvider(
        providers: [
          const WindowProvider(),
          AppInfoClientProvider(),
          ClientFactoryProvider(),
          SettingsProvider(),
          VideoServiceProvider(),
          AdaptiveScaffoldScope(),
          DefaultRouteObserver(),
          NavigationProvider(
            destinations: rootDestintations,
            drawerHeader: (context) => const UserDrawerHeader(),
          ),
        ],
        builder: (context, child) => LogLevelScope(
          child: _PlatformBrightnessBuilder(
            builder: (context, brightness) => ValueListenableBuilder<AppTheme>(
              valueListenable: context.watch<Settings>().theme,
              builder: (context, value, child) {
                final ThemeData themeData = value.resolve(brightness).data;
                return ExcludeSemantics(
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                    value:
                        themeData.appBarTheme.systemOverlayStyle ??
                        const SystemUiOverlayStyle(),
                    child: SubValue<GlobalKey<NavigatorState>>(
                      create: () => GlobalKey<NavigatorState>(),
                      builder: (context, navigatorKey) =>
                          ValueListenableBuilder<String?>(
                            valueListenable: context.watch<Settings>().language,
                            builder: (context, language, child) => MaterialApp(
                              title: AppInfo.instance.appName,
                              theme: themeData,
                              scrollBehavior: AndroidStretchScrollBehaviour(),
                              locale: parseLanguage(language),
                              supportedLocales:
                                  AppLocalizations.supportedLocales,
                              localizationsDelegates: const [
                                ...AppLocalizations.localizationsDelegates,
                                GlobalCupertinoLocalizations.delegate,
                                RelativeTimeLocalizations.delegate,
                              ],
                              localeListResolutionCallback:
                                  (locales, supported) =>
                                      resolveAppLocale(locales),
                              navigatorKey: navigatorKey,
                              navigatorObservers: [
                                context.watch<AnyRouteObserver>(),
                                RouteLoggerObserver(),
                                MaterialApp.createMaterialHeroController(),
                              ],
                              routes: context
                                  .watch<RouterDrawerController>()
                                  .routes,
                              builder: (context, child) => WindowFrame(
                                child: WindowShortcuts(
                                  navigatorKey: navigatorKey,
                                  child: SecureDisplay(
                                    child: LockScreen(
                                      child: LoadingShell(
                                        child: MultiProvider(
                                          providers: [
                                            IdentityClientProvider(),
                                            TraitsClientProvider(),
                                            ClientProvider(),
                                            FileCacheProvider(),
                                            TasksControllerProvider(),
                                          ],
                                          child: LoadingCore(
                                            child: OnboardingGate(
                                              child: AccountConnector(
                                                navigatorKey: navigatorKey,
                                                child: FollowConnector(
                                                  child: AppLinkHandler(
                                                    navigatorKey: navigatorKey,
                                                    child: NotificationHandler(
                                                      navigatorKey:
                                                          navigatorKey,
                                                      child: AppBubbleOverlay(
                                                        navigatorKey:
                                                            navigatorKey,
                                                        child: child!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Rebuilds its subtree when the platform brightness changes.
///
/// Used to resolve [AppTheme.system] against the system dark mode setting.
class _PlatformBrightnessBuilder extends StatefulWidget {
  const _PlatformBrightnessBuilder({required this.builder});

  final Widget Function(BuildContext context, Brightness brightness) builder;

  @override
  State<_PlatformBrightnessBuilder> createState() =>
      _PlatformBrightnessBuilderState();
}

class _PlatformBrightnessBuilderState extends State<_PlatformBrightnessBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    View.of(context).platformDispatcher.platformBrightness,
  );
}
