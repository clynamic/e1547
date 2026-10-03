import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// The app name.
  ///
  /// In en, this message translates to:
  /// **'e1547'**
  String get appName;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// No description provided for @nothingToSeeHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing to see here'**
  String get nothingToSeeHere;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get actionCancel;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// No description provided for @actionDownload.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD'**
  String get actionDownload;

  /// No description provided for @actionImport.
  ///
  /// In en, this message translates to:
  /// **'IMPORT'**
  String get actionImport;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'EXPORT'**
  String get actionExport;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @actionRestartNow.
  ///
  /// In en, this message translates to:
  /// **'RESTART NOW'**
  String get actionRestartNow;

  /// No description provided for @failedToLoadSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load suggestions'**
  String get failedToLoadSuggestions;

  /// Number of selected items.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String selectionItemCount(num count);

  /// No description provided for @actionAbort.
  ///
  /// In en, this message translates to:
  /// **'Abort'**
  String get actionAbort;

  /// No description provided for @actionSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// Confirmation after saving a file.
  ///
  /// In en, this message translates to:
  /// **'File saved as {name}'**
  String fileSavedAs(String name);

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @saveFile.
  ///
  /// In en, this message translates to:
  /// **'Save file'**
  String get saveFile;

  /// No description provided for @filterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTooltip;

  /// No description provided for @rangeInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get rangeInvalidFormat;

  /// Progress of processing items.
  ///
  /// In en, this message translates to:
  /// **'Item {current}/{total}'**
  String itemProgress(num current, num total);

  /// No description provided for @taskCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled task'**
  String get taskCancelled;

  /// Item processing failure.
  ///
  /// In en, this message translates to:
  /// **'Failed at item {index}'**
  String taskFailedAt(num index);

  /// No description provided for @taskDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskDone;

  /// No description provided for @failedToInitialize.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize'**
  String get failedToInitialize;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get navHot;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get navSubscriptions;

  /// No description provided for @navBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get navBookmarks;

  /// No description provided for @navPools.
  ///
  /// In en, this message translates to:
  /// **'Pools'**
  String get navPools;

  /// No description provided for @navForum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get navForum;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @sectionUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get sectionUser;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @sectionInteractions.
  ///
  /// In en, this message translates to:
  /// **'Interactions'**
  String get sectionInteractions;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @sectionDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get sectionDevelopment;

  /// No description provided for @settingsBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get settingsBlacklist;

  /// No description provided for @tagsBlocked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tag blocked} other{{count} tags blocked}}'**
  String tagsBlocked(num count);

  /// No description provided for @settingsFollows.
  ///
  /// In en, this message translates to:
  /// **'Follows'**
  String get settingsFollows;

  /// No description provided for @searchesFollowed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 search followed} other{{count} searches followed}}'**
  String searchesFollowed(num count);

  /// No description provided for @settingsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get settingsHistory;

  /// No description provided for @pagesVisited.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page visited} other{{count} pages visited}}'**
  String pagesVisited(num count);

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get themeDark;

  /// No description provided for @themeAmoled.
  ///
  /// In en, this message translates to:
  /// **'amoled'**
  String get themeAmoled;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get themeLight;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get themeBlue;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get themeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @settingsTileSize.
  ///
  /// In en, this message translates to:
  /// **'Tile size'**
  String get settingsTileSize;

  /// No description provided for @settingsQuilt.
  ///
  /// In en, this message translates to:
  /// **'Quilt'**
  String get settingsQuilt;

  /// No description provided for @gridTitle.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get gridTitle;

  /// No description provided for @quiltSquare.
  ///
  /// In en, this message translates to:
  /// **'tiles are quadratic'**
  String get quiltSquare;

  /// No description provided for @quiltVertical.
  ///
  /// In en, this message translates to:
  /// **'tiles expand vertically'**
  String get quiltVertical;

  /// No description provided for @settingsPostInfo.
  ///
  /// In en, this message translates to:
  /// **'Post info'**
  String get settingsPostInfo;

  /// No description provided for @postInfoShown.
  ///
  /// In en, this message translates to:
  /// **'info on post tiles'**
  String get postInfoShown;

  /// No description provided for @postInfoHidden.
  ///
  /// In en, this message translates to:
  /// **'image tiles only'**
  String get postInfoHidden;

  /// No description provided for @settingsDownloadLocation.
  ///
  /// In en, this message translates to:
  /// **'Download location'**
  String get settingsDownloadLocation;

  /// No description provided for @settingsUpvoteFavorites.
  ///
  /// In en, this message translates to:
  /// **'Upvote favorites'**
  String get settingsUpvoteFavorites;

  /// No description provided for @upvoteFavoritesOn.
  ///
  /// In en, this message translates to:
  /// **'upvote and favorite'**
  String get upvoteFavoritesOn;

  /// No description provided for @upvoteFavoritesOff.
  ///
  /// In en, this message translates to:
  /// **'favorite only'**
  String get upvoteFavoritesOff;

  /// No description provided for @settingsVideoVolume.
  ///
  /// In en, this message translates to:
  /// **'Video volume'**
  String get settingsVideoVolume;

  /// No description provided for @videoMuted.
  ///
  /// In en, this message translates to:
  /// **'muted'**
  String get videoMuted;

  /// No description provided for @videoWithSound.
  ///
  /// In en, this message translates to:
  /// **'with sound'**
  String get videoWithSound;

  /// No description provided for @videoSeekSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String videoSeekSeconds(Object seconds);

  /// No description provided for @settingsVideoResolution.
  ///
  /// In en, this message translates to:
  /// **'Video resolution'**
  String get settingsVideoResolution;

  /// No description provided for @videoResStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (480p)'**
  String get videoResStandard;

  /// No description provided for @videoResHigh.
  ///
  /// In en, this message translates to:
  /// **'High (720p)'**
  String get videoResHigh;

  /// No description provided for @videoResFull.
  ///
  /// In en, this message translates to:
  /// **'Full (1080p)'**
  String get videoResFull;

  /// No description provided for @videoResUltra.
  ///
  /// In en, this message translates to:
  /// **'Ultra (4K)'**
  String get videoResUltra;

  /// No description provided for @videoResSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get videoResSource;

  /// No description provided for @settingsSecureDisplay.
  ///
  /// In en, this message translates to:
  /// **'Secure display'**
  String get settingsSecureDisplay;

  /// No description provided for @secureDisplayOn.
  ///
  /// In en, this message translates to:
  /// **'screen protected'**
  String get secureDisplayOn;

  /// No description provided for @secureDisplayOff.
  ///
  /// In en, this message translates to:
  /// **'screen visible'**
  String get secureDisplayOff;

  /// No description provided for @settingsIncognitoKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Incognito keyboard'**
  String get settingsIncognitoKeyboard;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabled;

  /// No description provided for @settingsPinLock.
  ///
  /// In en, this message translates to:
  /// **'PIN lock'**
  String get settingsPinLock;

  /// No description provided for @pinEnabled.
  ///
  /// In en, this message translates to:
  /// **'PIN enabled'**
  String get pinEnabled;

  /// No description provided for @pinDisabled.
  ///
  /// In en, this message translates to:
  /// **'PIN disabled'**
  String get pinDisabled;

  /// No description provided for @settingsBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get settingsBiometricLock;

  /// No description provided for @biometricsEnabled.
  ///
  /// In en, this message translates to:
  /// **'biometrics enabled'**
  String get biometricsEnabled;

  /// No description provided for @biometricsDisabled.
  ///
  /// In en, this message translates to:
  /// **'biometrics disabled'**
  String get biometricsDisabled;

  /// No description provided for @settingsDeveloperMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get settingsDeveloperMode;

  /// No description provided for @devOptionsShown.
  ///
  /// In en, this message translates to:
  /// **'options shown'**
  String get devOptionsShown;

  /// No description provided for @devOptionsHidden.
  ///
  /// In en, this message translates to:
  /// **'options hidden'**
  String get devOptionsHidden;

  /// No description provided for @errorsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 error logged} other{{count} errors logged}}'**
  String errorsLogged(num count);

  /// No description provided for @settingsDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get settingsDatabase;

  /// No description provided for @databaseExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting database...'**
  String get databaseExporting;

  /// No description provided for @databaseExported.
  ///
  /// In en, this message translates to:
  /// **'Database exported successfully'**
  String get databaseExported;

  /// No description provided for @databaseExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get databaseExportFailed;

  /// No description provided for @databaseExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get databaseExport;

  /// No description provided for @databaseImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing database...'**
  String get databaseImporting;

  /// No description provided for @databaseInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid database file: {error}'**
  String databaseInvalidFile(String error);

  /// No description provided for @databaseImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String databaseImportFailed(String error);

  /// No description provided for @databaseImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Database'**
  String get databaseImportTitle;

  /// No description provided for @databaseRestartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart Required'**
  String get databaseRestartTitle;

  /// No description provided for @databaseRestartBody.
  ///
  /// In en, this message translates to:
  /// **'The app needs to restart to apply changes.'**
  String get databaseRestartBody;

  /// No description provided for @databaseImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get databaseImport;

  /// No description provided for @lockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get lockEnterPin;

  /// No description provided for @lockEnterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get lockEnterNewPin;

  /// No description provided for @lockConfirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get lockConfirmNewPin;

  /// No description provided for @lockFailedAuth.
  ///
  /// In en, this message translates to:
  /// **'Failed to authenticate'**
  String get lockFailedAuth;

  /// No description provided for @lockPleaseAuth.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate'**
  String get lockPleaseAuth;

  /// No description provided for @lockRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get lockRetry;

  /// No description provided for @lockBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock.'**
  String get lockBiometricReason;

  /// No description provided for @lockBiometricFailure.
  ///
  /// In en, this message translates to:
  /// **'Severe failure in biometric authentication'**
  String get lockBiometricFailure;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @updaterFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching updates...'**
  String get updaterFetching;

  /// No description provided for @updaterCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to check for updates'**
  String get updaterCheckFailed;

  /// No description provided for @updaterNewest.
  ///
  /// In en, this message translates to:
  /// **'You have the newest version'**
  String get updaterNewest;

  /// No description provided for @updaterNewer.
  ///
  /// In en, this message translates to:
  /// **'A newer version is available: {version}'**
  String updaterNewer(String version);

  /// No description provided for @updaterNewerHeader.
  ///
  /// In en, this message translates to:
  /// **'A newer version is available: '**
  String get updaterNewerHeader;

  /// No description provided for @aboutExperimentalPlatform.
  ///
  /// In en, this message translates to:
  /// **'Experimental platform'**
  String get aboutExperimentalPlatform;

  /// No description provided for @aboutExperimentalBody.
  ///
  /// In en, this message translates to:
  /// **'This platform is not supported. Expect bugs and missing features.'**
  String get aboutExperimentalBody;

  /// No description provided for @aboutGitHub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get aboutGitHub;

  /// No description provided for @aboutUpstream.
  ///
  /// In en, this message translates to:
  /// **'Upstream'**
  String get aboutUpstream;

  /// No description provided for @aboutUpstreamBody.
  ///
  /// In en, this message translates to:
  /// **'This app is a fork of clragon/e1547'**
  String get aboutUpstreamBody;

  /// No description provided for @aboutDiscord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get aboutDiscord;

  /// No description provided for @aboutForum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get aboutForum;

  /// No description provided for @aboutForumTopic.
  ///
  /// In en, this message translates to:
  /// **'e621 thread #{id}'**
  String aboutForumTopic(num id);

  /// No description provided for @aboutWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutWebsite;

  /// No description provided for @aboutKofi.
  ///
  /// In en, this message translates to:
  /// **'Ko-fi'**
  String get aboutKofi;

  /// No description provided for @aboutEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutEmail;

  /// No description provided for @aboutPlaystore.
  ///
  /// In en, this message translates to:
  /// **'Playstore'**
  String get aboutPlaystore;

  /// No description provided for @aboutDonors.
  ///
  /// In en, this message translates to:
  /// **'Donors'**
  String get aboutDonors;

  /// No description provided for @aboutDonorsThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for helping me keep up development!'**
  String get aboutDonorsThanks;

  /// No description provided for @aboutNoDonors.
  ///
  /// In en, this message translates to:
  /// **'No donors yet'**
  String get aboutNoDonors;

  /// No description provided for @aboutDonorsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch donors'**
  String get aboutDonorsFailed;

  /// No description provided for @aboutDonorsNotListed.
  ///
  /// In en, this message translates to:
  /// **'Not on the list? Contact us!'**
  String get aboutDonorsNotListed;

  /// No description provided for @developerUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You are now a developer!'**
  String get developerUnlocked;

  /// No description provided for @databaseErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading database'**
  String get databaseErrorLoading;

  /// No description provided for @databaseUnknownSize.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get databaseUnknownSize;

  /// No description provided for @databaseExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Database'**
  String get databaseExportTitle;

  /// No description provided for @databaseExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save a backup copy of your database'**
  String get databaseExportSubtitle;

  /// No description provided for @databaseImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replace current database with imported one'**
  String get databaseImportSubtitle;

  /// No description provided for @databaseImportWarning.
  ///
  /// In en, this message translates to:
  /// **'This will replace your current database. \nAll data will be lost. This cannot be undone!'**
  String get databaseImportWarning;

  /// No description provided for @databaseExportSanitizedBody.
  ///
  /// In en, this message translates to:
  /// **'The exported file will not contain your logins or API keys.\nEverything else, including accounts, hosts, history, follows and tasks, is included.'**
  String get databaseExportSanitizedBody;

  /// No description provided for @databaseImportNewerFile.
  ///
  /// In en, this message translates to:
  /// **'This file was created by a newer app version and cannot be imported.'**
  String get databaseImportNewerFile;

  /// No description provided for @databaseImportSanitized.
  ///
  /// In en, this message translates to:
  /// **'For safety, saved logins were removed from the imported file.'**
  String get databaseImportSanitized;

  /// No description provided for @databaseImportHostsWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: the imported file contains accounts on other sites: {hosts}'**
  String databaseImportHostsWarning(String hosts);

  /// No description provided for @databaseImportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Import cancelled'**
  String get databaseImportCancelled;

  /// No description provided for @postsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsTitle;

  /// No description provided for @favoritesOf.
  ///
  /// In en, this message translates to:
  /// **'{user}\'s Favorites'**
  String favoritesOf(String user);

  /// No description provided for @favoritesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Favorites are unavailable for anonymous users'**
  String get favoritesUnavailable;

  /// No description provided for @favoriteOrder.
  ///
  /// In en, this message translates to:
  /// **'Favorite order'**
  String get favoriteOrder;

  /// No description provided for @orderAdded.
  ///
  /// In en, this message translates to:
  /// **'added order'**
  String get orderAdded;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'id order'**
  String get orderId;

  /// No description provided for @postStateDeleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get postStateDeleted;

  /// No description provided for @postStateUnsupported.
  ///
  /// In en, this message translates to:
  /// **'unsupported'**
  String get postStateUnsupported;

  /// No description provided for @postStateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get postStateUnavailable;

  /// No description provided for @menuShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get menuShare;

  /// No description provided for @menuDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get menuDownload;

  /// No description provided for @menuBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get menuBrowse;

  /// No description provided for @menuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuEdit;

  /// No description provided for @menuComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get menuComment;

  /// No description provided for @menuReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get menuReport;

  /// No description provided for @menuFlag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get menuFlag;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get actionFollow;

  /// No description provided for @actionUnfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get actionUnfollow;

  /// No description provided for @actionMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get actionMute;

  /// No description provided for @actionNotify.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get actionNotify;

  /// No description provided for @actionBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get actionBookmark;

  /// No description provided for @actionUnbookmark.
  ///
  /// In en, this message translates to:
  /// **'Unbookmark'**
  String get actionUnbookmark;

  /// No description provided for @actionBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get actionBlock;

  /// No description provided for @actionUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get actionUnblock;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionSubtract.
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get actionSubtract;

  /// No description provided for @selectionPost.
  ///
  /// In en, this message translates to:
  /// **'post #{id}'**
  String selectionPost(num id);

  /// No description provided for @selectionPostsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} posts}}'**
  String selectionPostsCount(num count);

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts'**
  String get noPosts;

  /// No description provided for @failedToLoadPosts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load posts'**
  String get failedToLoadPosts;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Showing cached data.'**
  String get offlineBanner;

  /// No description provided for @offlineNoData.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineNoData;

  /// No description provided for @postListPageSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {count, plural, one{{count} post} other{{count} posts}}'**
  String postListPageSummary(num count, Object page);

  /// No description provided for @postListPageLimit.
  ///
  /// In en, this message translates to:
  /// **'You have reached the server\'s page limit. Please narrow your search terms.'**
  String get postListPageLimit;

  /// No description provided for @postListJumpToPage.
  ///
  /// In en, this message translates to:
  /// **'Jump to page'**
  String get postListJumpToPage;

  /// No description provided for @postListJumpPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get postListJumpPageLabel;

  /// No description provided for @postListJumpPageRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a page number between 1 and {max}'**
  String postListJumpPageRange(Object max);

  /// No description provided for @postDeletedOverlay.
  ///
  /// In en, this message translates to:
  /// **'Post was deleted'**
  String get postDeletedOverlay;

  /// No description provided for @postUnavailableOverlay.
  ///
  /// In en, this message translates to:
  /// **'Post is unavailable'**
  String get postUnavailableOverlay;

  /// No description provided for @postBlacklistedOverlay.
  ///
  /// In en, this message translates to:
  /// **'Post is blacklisted'**
  String get postBlacklistedOverlay;

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'{ext} files are not supported'**
  String unsupportedFileType(String ext);

  /// No description provided for @loginRequiredEdit.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to edit posts!'**
  String get loginRequiredEdit;

  /// No description provided for @loginRequiredComment.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to comment!'**
  String get loginRequiredComment;

  /// No description provided for @loginRequiredReport.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to report posts!'**
  String get loginRequiredReport;

  /// No description provided for @loginRequiredFlag.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to flag posts!'**
  String get loginRequiredFlag;

  /// Number of posts currently blocked by the blacklist.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{blocked 1 post} other{blocked {count} posts}}'**
  String postsBlocked(num count);

  /// Error shown when saving the blacklist failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update blacklist!'**
  String get blacklistUpdateFailed;

  /// Title of the prompt that adds a tag to the blacklist.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get blacklistAddTag;

  /// Title of the prompt that edits a blacklist entry.
  ///
  /// In en, this message translates to:
  /// **'Edit tag'**
  String get blacklistEditTag;

  /// No description provided for @denylistEntryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Blacklist entry removed'**
  String get denylistEntryDeleted;

  /// Message shown when the blacklist contains no entries.
  ///
  /// In en, this message translates to:
  /// **'Your blacklist is empty'**
  String get blacklistEmpty;

  /// Menu item that deletes an item.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menuDelete;

  /// Name of the score filter.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get filterScore;

  /// Name of the favorite count filter.
  ///
  /// In en, this message translates to:
  /// **'Favorite count'**
  String get filterFavoriteCount;

  /// Name of the sort order filter.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get filterSortBy;

  /// Sort order option that sorts by newest posts.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get filterNew;

  /// Sort order option that sorts by rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get filterRank;

  /// Sort order option that sorts randomly.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get filterRandom;

  /// Choice that leaves a filter at its default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get filterDefault;

  /// Name of the rating filter.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filterRating;

  /// The safe rating.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get filterSafe;

  /// The questionable rating.
  ///
  /// In en, this message translates to:
  /// **'Questionable'**
  String get filterQuestionable;

  /// The explicit rating.
  ///
  /// In en, this message translates to:
  /// **'Explicit'**
  String get filterExplicit;

  /// Choice that does not restrict a filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Name of the pool filter.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get filterPool;

  /// Description of the pool filter.
  ///
  /// In en, this message translates to:
  /// **'Has pool'**
  String get filterHasPool;

  /// Name of the child post filter.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get filterChild;

  /// Description of the child post filter.
  ///
  /// In en, this message translates to:
  /// **'Is child post'**
  String get filterIsChildPost;

  /// Name of the parent post filter.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get filterParent;

  /// Description of the parent post filter.
  ///
  /// In en, this message translates to:
  /// **'Is parent post'**
  String get filterIsParentPost;

  /// Name of the upload date filter.
  ///
  /// In en, this message translates to:
  /// **'Upload date'**
  String get filterUploadDate;

  /// Upload date option for the last day.
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get filterLastDay;

  /// Upload date option for the last week.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get filterLastWeek;

  /// Upload date option for the last month.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get filterLastMonth;

  /// Upload date option for the last year.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get filterLastYear;

  /// Name of the post status filter.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// The active post status.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// The pending post status.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterPending;

  /// The deleted post status.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get filterDeleted;

  /// The flagged post status.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get filterFlagged;

  /// Post status option that allows any status.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterFileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get filterFileType;

  /// No description provided for @filterUploader.
  ///
  /// In en, this message translates to:
  /// **'Uploader'**
  String get filterUploader;

  /// No description provided for @filterWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get filterWidth;

  /// No description provided for @filterHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get filterHeight;

  /// No description provided for @filterTagCount.
  ///
  /// In en, this message translates to:
  /// **'Tag count'**
  String get filterTagCount;

  /// No description provided for @filterTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get filterTrue;

  /// No description provided for @filterFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get filterFalse;

  /// No description provided for @filterImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get filterImages;

  /// No description provided for @filterVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get filterVideos;

  /// Name of the topic title filter.
  ///
  /// In en, this message translates to:
  /// **'Title contains'**
  String get filterTitleContains;

  /// Name of the category filter.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// The general topic category.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get filterGeneral;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'Site Bug Reports & Feature Requests'**
  String get filterSiteBugReports;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'Tag/Wiki Projects and Questions'**
  String get filterTagWikiProjects;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'Tag Alias and Implication Suggestions'**
  String get filterTagAliasSuggestions;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'Art Talk'**
  String get filterArtTalk;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'Off Topic'**
  String get filterOffTopic;

  /// A topic category.
  ///
  /// In en, this message translates to:
  /// **'e621 Tools and Applications'**
  String get filterE621Tools;

  /// Sort order option that sorts by newest topics first.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get filterNewestFirst;

  /// Sort order option that sorts by oldest topics first.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get filterOldestFirst;

  /// Name of the sticky filter.
  ///
  /// In en, this message translates to:
  /// **'Sticky'**
  String get filterSticky;

  /// Description of the sticky filter.
  ///
  /// In en, this message translates to:
  /// **'Is sticky'**
  String get filterIsSticky;

  /// Name of the locked filter.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get filterLocked;

  /// Description of the locked filter.
  ///
  /// In en, this message translates to:
  /// **'Is locked'**
  String get filterIsLocked;

  /// Name of the pool description filter.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get filterDescription;

  /// Name of the pool creator filter.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get filterCreator;

  /// Description of the active pool filter.
  ///
  /// In en, this message translates to:
  /// **'Is active'**
  String get filterIsActive;

  /// The series pool category.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get filterSeries;

  /// The collection pool category.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get filterCollection;

  /// Sort order option that sorts pools by name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get filterName;

  /// Sort order option that sorts pools by creation date.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get filterCreated;

  /// Sort order option that sorts pools by update date.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get filterUpdated;

  /// Sort order option that sorts pools by post count.
  ///
  /// In en, this message translates to:
  /// **'Post count'**
  String get filterPostCount;

  /// Error shown when updating a post failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update post #{id}'**
  String postUpdateFailed(num id);

  /// Confirmation shown after updating a post.
  ///
  /// In en, this message translates to:
  /// **'Updated post #{id}'**
  String postUpdated(num id);

  /// Error shown when a single post failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load post'**
  String get failedToLoadPost;

  /// Message shown when a post does not exist.
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get postNotFound;

  /// Title of the comment list drawer.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// Title of a post's comment page.
  ///
  /// In en, this message translates to:
  /// **'#{postId} comments'**
  String commentsOfPost(num postId);

  /// Label of the comment sorting switch.
  ///
  /// In en, this message translates to:
  /// **'Comment order'**
  String get commentOrder;

  /// Message shown when there are no comments.
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get noComments;

  /// Error shown when comments failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments'**
  String get failedToLoadComments;

  /// Title of the comment loading page.
  ///
  /// In en, this message translates to:
  /// **'Comment #{id}'**
  String commentTitle(num id);

  /// Error shown when a comment failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comment'**
  String get failedToLoadComment;

  /// Message shown when a comment does not exist.
  ///
  /// In en, this message translates to:
  /// **'Comment not found'**
  String get commentNotFound;

  /// Title of the comment editor.
  ///
  /// In en, this message translates to:
  /// **'#{postId} comment'**
  String commentEditorTitle(num postId);

  /// Error shown when sending a comment failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send comment!'**
  String get commentSendFailed;

  /// Confirmation shown after sending a comment.
  ///
  /// In en, this message translates to:
  /// **'Comment sent!'**
  String get commentSent;

  /// Tooltip of the hidden comment indicator.
  ///
  /// In en, this message translates to:
  /// **'This comment is hidden'**
  String get commentHidden;

  /// Error shown when upvoting a comment failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upvote comment #{id}'**
  String commentUpvoteFailed(num id);

  /// Error shown when downvoting a comment failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to downvote comment #{id}'**
  String commentDownvoteFailed(num id);

  /// Error shown when editing a comment requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to edit comments!'**
  String get commentLoginRequiredEdit;

  /// Error shown when replying to a comment requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to reply to comments!'**
  String get commentLoginRequiredReply;

  /// Error shown when reporting a comment requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to report comments!'**
  String get commentLoginRequiredReport;

  /// Confirmation shown after copying a comment id.
  ///
  /// In en, this message translates to:
  /// **'Copied comment id #{id}'**
  String commentCopiedId(num id);

  /// Warning attached to a comment or reply whose author was warned.
  ///
  /// In en, this message translates to:
  /// **'User received a warning for this message'**
  String get warningUserWarned;

  /// Warning attached to a comment or reply whose author received a record.
  ///
  /// In en, this message translates to:
  /// **'User received a record for this message'**
  String get warningUserRecorded;

  /// Warning attached to a comment or reply whose author was banned.
  ///
  /// In en, this message translates to:
  /// **'User was banned for this message'**
  String get warningUserBanned;

  /// Title of the reply list drawer.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get repliesTitle;

  /// Label of the reply sorting switch.
  ///
  /// In en, this message translates to:
  /// **'Reply order'**
  String get replyOrder;

  /// Message shown when there are no replies.
  ///
  /// In en, this message translates to:
  /// **'No replies'**
  String get noReplies;

  /// Error shown when replies failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load replies'**
  String get failedToLoadReplies;

  /// Title of the reply loading page.
  ///
  /// In en, this message translates to:
  /// **'Reply #{id}'**
  String replyTitle(num id);

  /// Error shown when a reply failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reply'**
  String get failedToLoadReply;

  /// Message shown when a reply does not exist.
  ///
  /// In en, this message translates to:
  /// **'Reply not found'**
  String get replyNotFound;

  /// Title of the reply editor.
  ///
  /// In en, this message translates to:
  /// **'#{topicId} reply'**
  String replyEditorTitle(num topicId);

  /// Error shown when sending a reply failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply!'**
  String get replySendFailed;

  /// Confirmation shown after sending a reply.
  ///
  /// In en, this message translates to:
  /// **'Reply sent!'**
  String get replySent;

  /// Tooltip of the hidden reply indicator.
  ///
  /// In en, this message translates to:
  /// **'This reply is hidden'**
  String get replyHidden;

  /// Error shown when editing a reply requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to edit replies!'**
  String get replyLoginRequiredEdit;

  /// Error shown when replying requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to reply!'**
  String get replyLoginRequiredReply;

  /// Error shown when reporting a reply requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to report replies!'**
  String get replyLoginRequiredReport;

  /// Confirmation shown after copying a reply id.
  ///
  /// In en, this message translates to:
  /// **'Copied reply id #{id}'**
  String replyCopiedId(num id);

  /// Menu item that replies to an item.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get menuReply;

  /// Menu item that copies an id to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get menuCopyId;

  /// Menu item that refreshes a list.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get menuRefresh;

  /// Tooltip of copy buttons.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// Button that saves changes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Tooltip to reveal a hidden value.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get actionShow;

  /// Tooltip to hide a visible value.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// Warning that a destructive action is permanent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// Label of info buttons and sections.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Title of the wiki loading page. The placeholder is an id reference like '#123' or a wiki title.
  ///
  /// In en, this message translates to:
  /// **'Wiki {idOrTitle}'**
  String wikiTitle(String idOrTitle);

  /// Error shown when a wiki page failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wiki'**
  String get failedToLoadWiki;

  /// Message shown when a wiki page does not exist.
  ///
  /// In en, this message translates to:
  /// **'Wiki not found'**
  String get wikiNotFound;

  /// Confirmation shown after copying a wiki id.
  ///
  /// In en, this message translates to:
  /// **'Copied wiki id #{id}'**
  String wikiCopiedId(num id);

  /// Label of the wiki id info row.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get wikiInfoId;

  /// Label of the wiki alias info row.
  ///
  /// In en, this message translates to:
  /// **'alias'**
  String get wikiInfoAlias;

  /// Label of the wiki creation date info row.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get wikiInfoCreated;

  /// Label of the wiki update date info row.
  ///
  /// In en, this message translates to:
  /// **'updated'**
  String get wikiInfoUpdated;

  /// Label of the wiki lock info row.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get wikiInfoLocked;

  /// Positive value of info rows.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get wikiInfoYes;

  /// Negative value of info rows.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get wikiInfoNo;

  /// Title of the user loading page. The placeholder is an id reference like '#123' or a username.
  ///
  /// In en, this message translates to:
  /// **'User {idOrName}'**
  String userTitle(String idOrName);

  /// Error shown when a user failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user'**
  String get failedToLoadUser;

  /// Message shown when a user does not exist.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Label of the uploads tab on the user page.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get userUploads;

  /// Error shown when reporting a user requires a login.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to report users!'**
  String get userLoginRequiredReport;

  /// Header of the commission info section on the user page.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get userComission;

  /// Label of the user id info row.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get userId;

  /// Label of the join date info row.
  ///
  /// In en, this message translates to:
  /// **'joined'**
  String get userJoined;

  /// Label of the user rank info row.
  ///
  /// In en, this message translates to:
  /// **'rank'**
  String get userRank;

  /// Label of the user post count info row.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get userPosts;

  /// Label of the user post edit count info row.
  ///
  /// In en, this message translates to:
  /// **'edits'**
  String get userEdits;

  /// Label of the user favorite count info row.
  ///
  /// In en, this message translates to:
  /// **'favorites'**
  String get userFavorites;

  /// Label of the user comment count info row.
  ///
  /// In en, this message translates to:
  /// **'comments'**
  String get userComments;

  /// Label of the user forum post count info row.
  ///
  /// In en, this message translates to:
  /// **'forum'**
  String get userForum;

  /// Confirmation shown after copying a user id.
  ///
  /// In en, this message translates to:
  /// **'Copied user id #{id}'**
  String userCopiedId(num id);

  /// Title of the logs page.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logsTitle;

  /// Title of the logs page for a specific date.
  ///
  /// In en, this message translates to:
  /// **'Logs - {date}'**
  String logsTitleDate(String date);

  /// Number of selected log entries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} logs}}'**
  String selectionLogsCount(num count);

  /// Number of selected log files.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} log files}}'**
  String selectionLogsFilesCount(num count);

  /// Header of the log level filter section.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get logsLevels;

  /// Header of the log recording settings section.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get logsRecording;

  /// Switch that records verbose logs.
  ///
  /// In en, this message translates to:
  /// **'Verbose'**
  String get logsVerbose;

  /// Subtitle of the verbose switch when all levels are recorded.
  ///
  /// In en, this message translates to:
  /// **'all levels recorded'**
  String get logsVerboseAll;

  /// Subtitle of the verbose switch naming the minimum recorded level.
  ///
  /// In en, this message translates to:
  /// **'{level} and above'**
  String logsVerboseMinimum(String level);

  /// Title of the log file list page.
  ///
  /// In en, this message translates to:
  /// **'Log Files'**
  String get logFilesTitle;

  /// Error shown when log files failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load log files!'**
  String get failedToLoadLogFiles;

  /// Message shown when there are no log files.
  ///
  /// In en, this message translates to:
  /// **'No log files available!'**
  String get noLogFiles;

  /// Label of the live log source tile in the log file list.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get logsLive;

  /// Message shown when there are no log entries.
  ///
  /// In en, this message translates to:
  /// **'No logs'**
  String get noLogs;

  /// Error shown when a log file failed to read.
  ///
  /// In en, this message translates to:
  /// **'Failed to read the log'**
  String get failedToReadLog;

  /// Message shown when no errors have been logged.
  ///
  /// In en, this message translates to:
  /// **'No errors logged'**
  String get noErrorsLogged;

  /// Number of errors logged in the current session.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 error} other{{count} errors}}'**
  String logsErrorsCount(num count);

  /// Button that opens the full logs page.
  ///
  /// In en, this message translates to:
  /// **'All logs'**
  String get logsAll;

  /// Button that dismisses all logged errors.
  ///
  /// In en, this message translates to:
  /// **'Dismiss all'**
  String get logsDismissAll;

  /// Title of the log file deletion dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} log files?'**
  String logsDeleteTitle(num count);

  /// Header of the account list in the identity picker.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get identityAccounts;

  /// Title of the page that adds an account.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get identityAdd;

  /// Title of the page that edits an account.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get identityEdit;

  /// Title of the account removal dialog.
  ///
  /// In en, this message translates to:
  /// **'Remove account?'**
  String get identityRemoveTitle;

  /// Body of the account removal dialog.
  ///
  /// In en, this message translates to:
  /// **'All its data will be permanently removed, including history and follows.'**
  String get identityRemoveBody;

  /// Name shown for identities without a username.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get identityAnonymous;

  /// Error shown when adding a duplicate identity.
  ///
  /// In en, this message translates to:
  /// **'You already have an identity under this host and username.'**
  String get identityDuplicate;

  /// Error shown when logging in failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to log in. \n{reason}'**
  String identityLoginFailed(String reason);

  /// Fallback reason shown when logging in failed without details.
  ///
  /// In en, this message translates to:
  /// **'Check your network connection and login details'**
  String get identityLoginCheckDetails;

  /// Label of the account host input field.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get identitySite;

  /// Error shown when the host field is empty.
  ///
  /// In en, this message translates to:
  /// **'You must provide a host URL.'**
  String get identityHostRequired;

  /// Error shown when the host URL is invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid host URL'**
  String get identityHostInvalid;

  /// Tooltip of the read-only host field.
  ///
  /// In en, this message translates to:
  /// **'Site can\'t be changed. Add a new account to use a different one.'**
  String get identityHostReadOnly;

  /// Label of the account username input field.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get identityUsernameLabel;

  /// Error shown when the username field is empty.
  ///
  /// In en, this message translates to:
  /// **'You must provide a username.'**
  String get identityUsernameRequired;

  /// Label of the account api key input field.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get identityApikeyLabel;

  /// Link that opens the api key page of the current site.
  ///
  /// In en, this message translates to:
  /// **'Where do I find my API key?'**
  String get identityApikeyHelp;

  /// Error shown when the api key field is empty.
  ///
  /// In en, this message translates to:
  /// **'You must provide an API key.\ne.g. 1ca1d165e973d7f8d35b7deb7a2ae54c'**
  String get identityApikeyRequired;

  /// Error shown when the api key is malformed.
  ///
  /// In en, this message translates to:
  /// **'API key is a 24 or 32-character sequence of A-z and 0-9\ne.g. 1ca1d165e973d7f8d35b7deb7a2ae54c'**
  String get identityApikeyInvalid;

  /// Link that opens the registration page of the current site.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up here'**
  String get identitySignupPrompt;

  /// Hint below the account host input field.
  ///
  /// In en, this message translates to:
  /// **'The site that hosts your account and posts.'**
  String get identityHostHint;

  /// Segment that selects the sign-in mode of the account form.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get identitySignIn;

  /// Segment that selects the guest mode of the account form.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get identityGuest;

  /// Button that logs in with the entered credentials.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get identityLogin;

  /// Button that continues without an account.
  ///
  /// In en, this message translates to:
  /// **'Browse anonymously'**
  String get identityBrowseAnonymously;

  /// Message of the login loading dialog.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {host} as {username}…'**
  String identityConnecting(String host, String username);

  /// No description provided for @identityActivateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to activate identity: {error}'**
  String identityActivateFailed(Object error);

  /// No description provided for @traitsActivateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to activate traits: {error}'**
  String traitsActivateFailed(Object error);

  /// Error shown when identities failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load identities'**
  String get failedToLoadIdentities;

  /// Button that skips the onboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Button that returns to the previous onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Button that advances to the next onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Title of the welcome onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {app}'**
  String onboardingWelcomeTitle(String app);

  /// Body of the welcome onboarding step.
  ///
  /// In en, this message translates to:
  /// **'A sophisticated booru browser.'**
  String get onboardingWelcomeBody;

  /// Title of the theme onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Pick a look'**
  String get onboardingThemeTitle;

  /// Body of the theme onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Try one on. You can always change your mind later.'**
  String get onboardingThemeBody;

  /// Title of the login onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Connect an account'**
  String get onboardingLoginTitle;

  /// Title of the language onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get onboardingLanguageTitle;

  /// Prompt title for adding a tag to the subscriptions page.
  ///
  /// In en, this message translates to:
  /// **'Add to subscriptions'**
  String get followAddToSubscriptions;

  /// Empty state of the subscriptions page.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions'**
  String get followNoSubscriptions;

  /// Error state of the subscriptions page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subscriptions'**
  String get followFailedToLoadSubscriptions;

  /// Prompt title for adding a tag to the bookmarks page.
  ///
  /// In en, this message translates to:
  /// **'Add to bookmarks'**
  String get followAddToBookmarks;

  /// Empty state of the bookmarks page.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks'**
  String get followNoBookmarks;

  /// Error state of the bookmarks page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookmarks'**
  String get followFailedToLoadBookmarks;

  /// Title of the unseen posts tile in the subscriptions drawer.
  ///
  /// In en, this message translates to:
  /// **'unseen posts'**
  String get followUnseenPosts;

  /// Subtitle of the unseen posts tile, marking posts as seen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{mark 1 post as seen} other{mark {count} posts as seen}}'**
  String followMarkPostsSeen(num count);

  /// Subtitle of the unseen posts tile when nothing is unseen.
  ///
  /// In en, this message translates to:
  /// **'no unseen posts'**
  String get followNoUnseenPosts;

  /// Title of the unseen filter switch in the subscriptions drawer.
  ///
  /// In en, this message translates to:
  /// **'show unseen first'**
  String get followShowUnseenFirst;

  /// Subtitle of the unseen filter switch when filtering.
  ///
  /// In en, this message translates to:
  /// **'filtering for unseen'**
  String get followFilteringUnseen;

  /// Subtitle of the unseen filter switch when not filtering.
  ///
  /// In en, this message translates to:
  /// **'all posts shown'**
  String get followAllPostsShown;

  /// Title of the force sync tile in the subscriptions drawer.
  ///
  /// In en, this message translates to:
  /// **'Force sync'**
  String get followForceSync;

  /// Subtitle of the force sync tile when idle.
  ///
  /// In en, this message translates to:
  /// **'sync all follows'**
  String get followSyncAllFollows;

  /// Subtitle of the force sync tile while syncing, with a progress value.
  ///
  /// In en, this message translates to:
  /// **'syncing follows... {progress}'**
  String followSyncingFollows(String progress);

  /// Title of the follow editor page.
  ///
  /// In en, this message translates to:
  /// **'Edit follows'**
  String get followEditorTitle;

  /// Section title of the subscription list in the follow editor.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get followSubscribe;

  /// Prompt title for editing a follow's tags.
  ///
  /// In en, this message translates to:
  /// **'Edit follow'**
  String get followEditPrompt;

  /// Label of the text field renaming a follow.
  ///
  /// In en, this message translates to:
  /// **'Follow title'**
  String get followTitlePrompt;

  /// Menu action marking a follow as read.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get followMarkAsRead;

  /// Menu action disabling notifications of a follow.
  ///
  /// In en, this message translates to:
  /// **'Disable notifications'**
  String get followDisableNotifications;

  /// Menu action enabling notifications of a follow.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get followEnableNotifications;

  /// Menu action renaming a follow.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get followRename;

  /// Unseen counter label on a follow tile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new post} other{{label} new posts}}'**
  String followNewPosts(num count, String label);

  /// Title of the follow selection app bar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 follow} other{{count} follows}}'**
  String followSelectionCount(num count);

  /// Alias label on a follow tile.
  ///
  /// In en, this message translates to:
  /// **'alias {alias}'**
  String followAlias(String? alias);

  /// Title of the history selection app bar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry} other{{count} entries}}'**
  String historySelectionCount(num count);

  /// No description provided for @historyEntriesDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Deleted 1 history entry} other{Deleted {count} history entries}}'**
  String historyEntriesDeleted(int count);

  /// Title of the clear history tile in the history drawer.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClear;

  /// Subtitle of the clear history tile.
  ///
  /// In en, this message translates to:
  /// **'Delete all entries'**
  String get historyClearSubtitle;

  /// Title of the clear history confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get historyClearConfirm;

  /// Body of the clear history confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'All history entries will be permanently deleted. This action cannot be undone.'**
  String get historyClearConfirmBody;

  /// Confirmation button of the clear history dialog.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get historyClearAction;

  /// Title of the history limit dialog.
  ///
  /// In en, this message translates to:
  /// **'History limit'**
  String get historyLimit;

  /// Body of the history limit dialog explaining its effects.
  ///
  /// In en, this message translates to:
  /// **'Enabling history limit means all history entries beyond {amount} and all entries older than {months} months are automatically deleted.'**
  String historyLimitEnableBody(String amount, num months);

  /// Title of the history limit switch in the history drawer.
  ///
  /// In en, this message translates to:
  /// **'Limit history'**
  String get historyLimitTitle;

  /// Subtitle of the history limit switch when enabled.
  ///
  /// In en, this message translates to:
  /// **'Limited to newer than {months} months or less than {amount} entries.'**
  String historyLimitOn(String amount, num months);

  /// Subtitle of the history limit switch when disabled.
  ///
  /// In en, this message translates to:
  /// **'history is infinite'**
  String get historyLimitOff;

  /// Section header of the history category filters.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get historyEntries;

  /// Section header of the history type filters.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get historyType;

  /// Category filter showing visited items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get historyItems;

  /// Category filter showing visited searches.
  ///
  /// In en, this message translates to:
  /// **'Searches'**
  String get historySearches;

  /// Type filter showing wiki history entries.
  ///
  /// In en, this message translates to:
  /// **'Wikis'**
  String get historyWikis;

  /// Type filter showing user history entries.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get historyUsers;

  /// Empty state of the history page.
  ///
  /// In en, this message translates to:
  /// **'Your history is empty'**
  String get historyEmpty;

  /// Error state of the history page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyFailedToLoad;

  /// Placeholder shown when a history entry has no description.
  ///
  /// In en, this message translates to:
  /// **'no description'**
  String get historyNoDescription;

  /// Name of the hot posts search in the history.
  ///
  /// In en, this message translates to:
  /// **'Hot posts'**
  String get historyHotPosts;

  /// Name of a visited post in the history.
  ///
  /// In en, this message translates to:
  /// **'Post #{id}'**
  String historyLinkPost(num id);

  /// Name of a visited user in the history.
  ///
  /// In en, this message translates to:
  /// **'User #{id}'**
  String historyLinkUser(num id);

  /// Name of a visited wiki page in the history.
  ///
  /// In en, this message translates to:
  /// **'Wiki #{id}'**
  String historyLinkWiki(num id);

  /// Name of a visited user page in the history, looked up by name.
  ///
  /// In en, this message translates to:
  /// **'{id} - User'**
  String historyLinkUserByName(String id);

  /// Name of a visited wiki page in the history, looked up by title.
  ///
  /// In en, this message translates to:
  /// **'{id} - Wiki'**
  String historyLinkWikiByName(String id);

  /// Name of a visited search in the history, combining its type and query.
  ///
  /// In en, this message translates to:
  /// **'{type} - {query}'**
  String historySearchQuery(String type, String query);

  /// Menu action opening the wiki of a searched tag.
  ///
  /// In en, this message translates to:
  /// **'Wiki'**
  String get historyWiki;

  /// Empty state of the pools page.
  ///
  /// In en, this message translates to:
  /// **'No pools'**
  String get poolEmpty;

  /// Error state of the pools page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pools'**
  String get poolFailedToLoadPools;

  /// Label of the pool title search filter.
  ///
  /// In en, this message translates to:
  /// **'Pool title'**
  String get poolTitle;

  /// Info row label of the post count of a pool.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get poolInfoPosts;

  /// Info row label of the id of a pool.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get poolInfoId;

  /// Info row label of the activity state of a pool.
  ///
  /// In en, this message translates to:
  /// **'activity'**
  String get poolInfoActivity;

  /// Info row value of an active pool.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get poolInfoActive;

  /// Info row value of an inactive pool.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get poolInfoInactive;

  /// Info row label of the creation date of a pool.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get poolInfoCreated;

  /// Info row label of the last update of a pool.
  ///
  /// In en, this message translates to:
  /// **'updated'**
  String get poolInfoUpdated;

  /// Snackbar shown after copying the id of a pool.
  ///
  /// In en, this message translates to:
  /// **'Copied pool id #{id}'**
  String poolCopiedId(num id);

  /// Title of the pool loading page.
  ///
  /// In en, this message translates to:
  /// **'Pool #{id}'**
  String poolLink(num id);

  /// Error state of the pool loading page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pool'**
  String get poolFailedToLoadPool;

  /// Empty state of the pool loading page.
  ///
  /// In en, this message translates to:
  /// **'Pool not found'**
  String get poolNotFound;

  /// Title of the pool order switch in the pool drawer.
  ///
  /// In en, this message translates to:
  /// **'Pool order'**
  String get poolOrder;

  /// Subtitle of the pool order switch when sorting oldest first.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get poolOldestFirst;

  /// Subtitle of the pool order switch when sorting newest first.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get poolNewestFirst;

  /// Title of the pool reader mode switch in the pool drawer.
  ///
  /// In en, this message translates to:
  /// **'Pool reader mode'**
  String get poolReaderMode;

  /// Subtitle of the pool reader mode switch when enabled.
  ///
  /// In en, this message translates to:
  /// **'large images'**
  String get poolReaderLargeImages;

  /// Subtitle of the pool reader mode switch when disabled.
  ///
  /// In en, this message translates to:
  /// **'normal grid'**
  String get poolReaderNormalGrid;

  /// Title of the topics page.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicsTitle;

  /// Title of the tag edit switch in the topics drawer.
  ///
  /// In en, this message translates to:
  /// **'Hide tags edits'**
  String get topicHideTagEdits;

  /// Subtitle of the tag edit switch when hidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get topicTagEditsHidden;

  /// Subtitle of the tag edit switch when visible.
  ///
  /// In en, this message translates to:
  /// **'visible'**
  String get topicTagEditsVisible;

  /// Title of the topic loading page.
  ///
  /// In en, this message translates to:
  /// **'Topic #{id}'**
  String topicLink(num id);

  /// Error state of the topic loading page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load topic'**
  String get topicFailedToLoadTopic;

  /// Empty state of the topic loading page.
  ///
  /// In en, this message translates to:
  /// **'Topic not found'**
  String get topicNotFound;

  /// Empty state of the topics page.
  ///
  /// In en, this message translates to:
  /// **'No topics'**
  String get topicEmpty;

  /// Error state of the topics page.
  ///
  /// In en, this message translates to:
  /// **'Failed to load topics'**
  String get topicFailedToLoadTopics;

  /// Info row label of the reply count of a topic.
  ///
  /// In en, this message translates to:
  /// **'replies'**
  String get topicInfoReplies;

  /// Info row label of the id of a topic.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get topicInfoId;

  /// Snackbar shown after copying the id of a topic.
  ///
  /// In en, this message translates to:
  /// **'Copied topic id #{id}'**
  String topicCopiedId(num id);

  /// Info row label of the locked state of a topic.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get topicInfoLocked;

  /// Info row value confirming a topic state.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get topicInfoYes;

  /// Info row value denying a topic state.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get topicInfoNo;

  /// Info row label of the creation date of a topic.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get topicInfoCreated;

  /// Info row label of the last update of a topic.
  ///
  /// In en, this message translates to:
  /// **'updated'**
  String get topicInfoUpdated;

  /// Name of the tags filter used by the tag prompt.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get filterTags;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to perform this action.'**
  String get loginRequired;

  /// No description provided for @actionChooseIdentity.
  ///
  /// In en, this message translates to:
  /// **'Choose identity'**
  String get actionChooseIdentity;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// Button on the post detail page opening the comment section.
  ///
  /// In en, this message translates to:
  /// **'COMMENTS ({count})'**
  String detailCommentsButton(num count);

  /// Section header of the file info of a post.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get detailFile;

  /// Section header of the sources of a post.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get detailSources;

  /// Placeholder shown when a post has no sources.
  ///
  /// In en, this message translates to:
  /// **'no sources'**
  String get detailNoSources;

  /// Section header listing the child posts of a post.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get detailChildren;

  /// Section header of the deletion flag reason of a post.
  ///
  /// In en, this message translates to:
  /// **'Deletion'**
  String get detailDeletion;

  /// Section header listing the blacklist entries that blocked a post.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get detailBlacklisted;

  /// Placeholder shown when a post has no artist tags.
  ///
  /// In en, this message translates to:
  /// **'no artist'**
  String get detailNoArtist;

  /// Post count of a pool shown on a pool relation tile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 post} other{{count} posts}}'**
  String detailPoolPosts(num count);

  /// Snackbar shown after copying the id of a post.
  ///
  /// In en, this message translates to:
  /// **'Copied post id #{id}'**
  String postCopiedId(num id);

  /// Error shown when upvoting a post failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upvote post #{id}'**
  String postUpvoteFailed(num id);

  /// Error shown when downvoting a post failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to downvote post #{id}'**
  String postDownvoteFailed(num id);

  /// Error shown when adding a post to favorites failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add post #{id} to favorites'**
  String postAddFavoriteFailed(num id);

  /// Error shown when removing a post from favorites failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove post #{id} from favorites'**
  String postRemoveFavoriteFailed(num id);

  /// Tooltip of the DText editor button enclosing a section block.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get editorSection;

  /// Tooltip of the DText editor button enclosing a quote block.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get editorQuote;

  /// Tooltip of the DText editor button enclosing a code block.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get editorCode;

  /// Tooltip of the DText editor button enclosing a spoiler block.
  ///
  /// In en, this message translates to:
  /// **'Spoiler'**
  String get editorSpoiler;

  /// Tooltip of the DText editor button enclosing bold text.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get editorBold;

  /// Tooltip of the DText editor button enclosing italic text.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get editorItalic;

  /// Tooltip of the DText editor button enclosing underlined text.
  ///
  /// In en, this message translates to:
  /// **'Underlined'**
  String get editorUnderlined;

  /// Tooltip of the DText editor button enclosing struck-through text.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get editorStrikethrough;

  /// Placeholder shown in the preview pane of the DText editor.
  ///
  /// In en, this message translates to:
  /// **'your text here'**
  String get editorPreviewPlaceholder;

  /// Tab label of the editing pane of the text editor.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get editorWrite;

  /// Tab label of the preview pane of the text editor.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get editorPreview;

  /// Hint text of the text editor input field.
  ///
  /// In en, this message translates to:
  /// **'type here...'**
  String get editorTypeHere;

  /// Placeholder shown when the tag counter drawer found no tags.
  ///
  /// In en, this message translates to:
  /// **'no tags'**
  String get tagNoTags;

  /// Error state of the tag counter drawer.
  ///
  /// In en, this message translates to:
  /// **'failed to load tags'**
  String get tagFailedToLoadTags;

  /// Error shown when the wiki entry of a tag failed to load.
  ///
  /// In en, this message translates to:
  /// **'unable to retrieve wiki entry'**
  String get tagUnableToRetrieveWiki;

  /// Placeholder shown when a tag has no wiki entry.
  ///
  /// In en, this message translates to:
  /// **'no wiki entry'**
  String get tagNoWikiEntry;

  /// Name of the general tag category.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get tagCategoryGeneral;

  /// Name of the species tag category.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get tagCategorySpecies;

  /// Name of the character tag category.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get tagCategoryCharacter;

  /// Name of the copyright tag category.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get tagCategoryCopyright;

  /// Name of the meta tag category.
  ///
  /// In en, this message translates to:
  /// **'Meta'**
  String get tagCategoryMeta;

  /// Name of the lore tag category.
  ///
  /// In en, this message translates to:
  /// **'Lore'**
  String get tagCategoryLore;

  /// Name of the artist tag category.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get tagCategoryArtist;

  /// Name of the contributor tag category.
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get tagCategoryContributor;

  /// Name of the invalid tag category.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get tagCategoryInvalid;

  /// Title of the post description editor page.
  ///
  /// In en, this message translates to:
  /// **'#{postId} description'**
  String editDescriptionTitle(num postId);

  /// Hint text of the post description input field.
  ///
  /// In en, this message translates to:
  /// **'Enter post description...'**
  String get editDescriptionHint;

  /// Error text shown when the parent id input is not a number.
  ///
  /// In en, this message translates to:
  /// **'Invalid number format'**
  String get editInvalidNumber;

  /// Error text shown when a parent post does not exist.
  ///
  /// In en, this message translates to:
  /// **'Invalid parent post'**
  String get editInvalidParent;

  /// Label of the parent id input field of the post edit form.
  ///
  /// In en, this message translates to:
  /// **'Parent ID (optional)'**
  String get editParentIdLabel;

  /// Hint text of the parent id input field of the post edit form.
  ///
  /// In en, this message translates to:
  /// **'Parent post ID'**
  String get editParentIdHint;

  /// Label of the edit reason input field of the post edit form.
  ///
  /// In en, this message translates to:
  /// **'Edit reason (optional)'**
  String get editReasonLabel;

  /// Hint text of the edit reason input field of the post edit form.
  ///
  /// In en, this message translates to:
  /// **'Why are you editing this post?'**
  String get editReasonHint;

  /// Title of the post sources editor page.
  ///
  /// In en, this message translates to:
  /// **'#{postId} sources'**
  String editSourcesTitle(num postId);

  /// Hint text of the tags input field of the post edit form.
  ///
  /// In en, this message translates to:
  /// **'space separated tags'**
  String get editTagsHint;

  /// Error shown when the tag preview failed to load.
  ///
  /// In en, this message translates to:
  /// **'Error loading tag preview: {error}'**
  String editTagPreviewFailed(String error);

  /// Status label of a tag that does not exist yet.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get editTagStatusNew;

  /// Status label of a tag in the invalid category.
  ///
  /// In en, this message translates to:
  /// **'invalid'**
  String get editTagStatusInvalid;

  /// Status label of a tag without any posts.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get editTagStatusEmpty;

  /// Status label of a rarely used general tag.
  ///
  /// In en, this message translates to:
  /// **'underused'**
  String get editTagStatusUnderused;

  /// Success message after reporting a comment.
  ///
  /// In en, this message translates to:
  /// **'Reported comment #{id}'**
  String reportCommentSuccess(num id);

  /// Error message after failing to report a comment.
  ///
  /// In en, this message translates to:
  /// **'Failed to report comment #{id}'**
  String reportCommentFailed(num id);

  /// Success message after reporting a reply.
  ///
  /// In en, this message translates to:
  /// **'Reported reply #{id}'**
  String reportReplySuccess(num id);

  /// Error message after failing to report a reply.
  ///
  /// In en, this message translates to:
  /// **'Failed to report reply #{id}'**
  String reportReplyFailed(num id);

  /// Success message after reporting a user.
  ///
  /// In en, this message translates to:
  /// **'Reported user #{id}'**
  String reportUserSuccess(num id);

  /// Error message after failing to report a user.
  ///
  /// In en, this message translates to:
  /// **'Failed to report user #{id}'**
  String reportUserFailed(num id);

  /// Success message after reporting a post.
  ///
  /// In en, this message translates to:
  /// **'Reported post #{id}'**
  String reportPostSuccess(num id);

  /// Error message after failing to report a post.
  ///
  /// In en, this message translates to:
  /// **'Failed to report post #{id}'**
  String reportPostFailed(num id);

  /// Error text shown when no report type was selected.
  ///
  /// In en, this message translates to:
  /// **'Type cannot be empty'**
  String get reportTypeRequired;

  /// Label of the report reason input field.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reportReason;

  /// Error text shown when the report reason is empty.
  ///
  /// In en, this message translates to:
  /// **'Reason cannot be empty'**
  String get reportReasonRequired;

  /// Success message after submitting a report.
  ///
  /// In en, this message translates to:
  /// **'Submitted report'**
  String get reportSubmitted;

  /// Error message after failing to submit a report.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report'**
  String get reportSubmitFailed;

  /// Name of the rating abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'Rating Abuse'**
  String get reportTypeRating;

  /// Name of the malicious file post report type.
  ///
  /// In en, this message translates to:
  /// **'Malicious File'**
  String get reportTypeFile;

  /// Name of the malicious source post report type.
  ///
  /// In en, this message translates to:
  /// **'Malicious Source'**
  String get reportTypeSource;

  /// Name of the description abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'Description Abuse'**
  String get reportTypeDescription;

  /// Name of the note abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'Note Abuse'**
  String get reportTypeNote;

  /// Name of the tagging abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'Tagging Abuse'**
  String get reportTypeTagging;

  /// Description of the rating abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'The rating of the submission has been set to something incorrect.'**
  String get reportTypeRatingBody;

  /// Description of the malicious file post report type.
  ///
  /// In en, this message translates to:
  /// **'The file contains either malicious code or contains a hidden file archive. This is not for imagery depicted in the image itself.'**
  String get reportTypeFileBody;

  /// Description of the malicious source post report type.
  ///
  /// In en, this message translates to:
  /// **'One or more of the listed sources link to malicious pages or pay content.'**
  String get reportTypeSourceBody;

  /// Description of the description abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'The description contains malicious content, or has been edited to contain abusive material.'**
  String get reportTypeDescriptionBody;

  /// Description of the note abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'The notes on this post are wrong, harassive, or otherwise abusive.'**
  String get reportTypeNoteBody;

  /// Description of the tagging abuse post report type.
  ///
  /// In en, this message translates to:
  /// **'One or more tags on this post aren\'t valid or one or more valid tags have been removed from this post.'**
  String get reportTypeTaggingBody;

  /// Success message after flagging a post.
  ///
  /// In en, this message translates to:
  /// **'Flagged post #{id}'**
  String flagPostSuccess(num id);

  /// Error message after failing to flag a post.
  ///
  /// In en, this message translates to:
  /// **'Failed to flag post #{id}'**
  String flagPostFailed(num id);

  /// Label of the parent id input field of the post flag form.
  ///
  /// In en, this message translates to:
  /// **'Parent ID'**
  String get flagParentId;

  /// Error text shown when the parent id of a flag is empty.
  ///
  /// In en, this message translates to:
  /// **'Parent ID cannot be empty'**
  String get flagParentIdRequired;

  /// Error text shown when the parent id of a flag is not a number.
  ///
  /// In en, this message translates to:
  /// **'Parent ID must be a number'**
  String get flagParentIdInvalid;

  /// Name of the uploading guidelines post flag.
  ///
  /// In en, this message translates to:
  /// **'Does not meet the uploading guidelines'**
  String get flagTypeUploadingGuidelines;

  /// Name of the young human post flag.
  ///
  /// In en, this message translates to:
  /// **'Young human-like character in an explicit situation'**
  String get flagTypeYoungHuman;

  /// Name of the do not post artist post flag.
  ///
  /// In en, this message translates to:
  /// **'The artist of this post is on the avoid posting list'**
  String get flagTypeDnpArtist;

  /// Name of the pay content post flag.
  ///
  /// In en, this message translates to:
  /// **'Paysite, commercial, or subscription content'**
  String get flagTypePayContent;

  /// Name of the trace post flag.
  ///
  /// In en, this message translates to:
  /// **'Trace of another artist\'s work'**
  String get flagTypeTrace;

  /// Name of the previously deleted post flag.
  ///
  /// In en, this message translates to:
  /// **'Previously deleted'**
  String get flagTypePreviouslyDeleted;

  /// Name of the real porn post flag.
  ///
  /// In en, this message translates to:
  /// **'Real-life pornography'**
  String get flagTypeRealPorn;

  /// Name of the corrupt file post flag.
  ///
  /// In en, this message translates to:
  /// **'File is either corrupted, broken, or otherwise does not work'**
  String get flagTypeCorrupt;

  /// Name of the inferior post flag.
  ///
  /// In en, this message translates to:
  /// **'Duplicate or inferior version of another post'**
  String get flagTypeInferior;

  /// Description of the uploading guidelines post flag.
  ///
  /// In en, this message translates to:
  /// **'This post fails to meet the site\'s standards, be it for artistic worth, image quality, relevancy, or something else.\nKeep in mind that your personal preferences have no bearing on this. If you find the content of a post objectionable, simply [[e621:blacklist|blacklist]] it.'**
  String get flagTypeUploadingGuidelinesBody;

  /// Description of the young human post flag.
  ///
  /// In en, this message translates to:
  /// **'Posts featuring human and human-like characters depicted in a sexual or explicit nude way, are not acceptable on this site.'**
  String get flagTypeYoungHumanBody;

  /// Description of the do not post artist post flag.
  ///
  /// In en, this message translates to:
  /// **'Certain artists have requested that their work is not to be published on this site, and were granted [[avoid_posting|Do Not Post]] status.\nSometimes, that status comes with conditions; see [[conditional_dnp]] for more information'**
  String get flagTypeDnpArtistBody;

  /// Description of the pay content post flag.
  ///
  /// In en, this message translates to:
  /// **'We do not host paysite or commercial content of any kind. This includes Patreon leaks, reposts from piracy websites, and so on.'**
  String get flagTypePayContentBody;

  /// Description of the trace post flag.
  ///
  /// In en, this message translates to:
  /// **'Images traced from other artists\' artwork are not accepted on this site. Referencing from something is fine, but outright copying someone else\'s work is not.\nPlease, leave more information in the comments, or simply add the original artwork as the posts\'s parent if it\'s hosted on this site.'**
  String get flagTypeTraceBody;

  /// Description of the previously deleted post flag.
  ///
  /// In en, this message translates to:
  /// **'Posts usually get removed for a good reason, and reuploading of deleted content is not acceptable.\nPlease, leave more information in the comments, or simply add the original post as this post\'s parent.'**
  String get flagTypePreviouslyDeletedBody;

  /// Description of the real porn post flag.
  ///
  /// In en, this message translates to:
  /// **'Posts featuring real-life pornography are not acceptable on this site. No exceptions.\nNote that images featuring non-erotic photographs are acceptable.'**
  String get flagTypeRealPornBody;

  /// Description of the corrupt file post flag.
  ///
  /// In en, this message translates to:
  /// **'Something about this post does not work quite right. This may be a broken video, or a corrupted image.\nEither way, in order to avoid confusion, please explain the situation in the comments.'**
  String get flagTypeCorruptBody;

  /// Description of the inferior post flag.
  ///
  /// In en, this message translates to:
  /// **'A superior version of this post already exists on the site.\nThis may include images with better visual quality (larger, less compressed), but may also feature \"fixed\" versions, with visual mistakes accounted for by the artist.\nNote that edits and alternate versions do not fall under this category.'**
  String get flagTypeInferiorBody;

  /// Tooltip of the button which cancels all tasks.
  ///
  /// In en, this message translates to:
  /// **'Cancel all'**
  String get taskCancelAll;

  /// Tooltip of the button which clears all finished tasks.
  ///
  /// In en, this message translates to:
  /// **'Clear done'**
  String get taskClearDone;

  /// Tooltip of the button which clears the task selection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get taskClearSelection;

  /// Tooltip of the button which cancels a task.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get taskCancel;

  /// Tooltip of the button which dismisses a task.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get taskDismiss;

  /// Placeholder shown when there are no tasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get taskNoTasks;

  /// Error message shown when tasks failed to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tasks'**
  String get taskFailedToLoadTasks;

  /// Selection counter on the tasks page.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String taskSelectionCount(num count);

  /// Header of the active tasks group.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get taskGroupActive;

  /// Header of the failed tasks group.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get taskGroupFailed;

  /// Name of the download task action.
  ///
  /// In en, this message translates to:
  /// **'download'**
  String get taskActionDownload;

  /// Name of the favorite task action.
  ///
  /// In en, this message translates to:
  /// **'favorite'**
  String get taskActionFavorite;

  /// Name of the unfavorite task action.
  ///
  /// In en, this message translates to:
  /// **'unfavorite'**
  String get taskActionUnfavorite;

  /// Label of a running download task.
  ///
  /// In en, this message translates to:
  /// **'downloading'**
  String get taskDownloadRunning;

  /// Label of a running favorite task.
  ///
  /// In en, this message translates to:
  /// **'favoriting'**
  String get taskFavoriteRunning;

  /// Label of a running unfavorite task.
  ///
  /// In en, this message translates to:
  /// **'unfavoriting'**
  String get taskUnfavoriteRunning;

  /// Label of a completed download task.
  ///
  /// In en, this message translates to:
  /// **'downloaded'**
  String get taskDownloadCompleted;

  /// Label of a completed favorite task.
  ///
  /// In en, this message translates to:
  /// **'favorited'**
  String get taskFavoriteCompleted;

  /// Label of a completed unfavorite task.
  ///
  /// In en, this message translates to:
  /// **'unfavorited'**
  String get taskUnfavoriteCompleted;

  /// Label of a queued task.
  ///
  /// In en, this message translates to:
  /// **'queued to {action}'**
  String taskQueuedTo(String action);

  /// Label of a failed task.
  ///
  /// In en, this message translates to:
  /// **'failed to {action}'**
  String taskFailedTo(String action);

  /// Label of a canceled task.
  ///
  /// In en, this message translates to:
  /// **'canceled {action}'**
  String taskCanceledAction(String action);

  /// Title of a task tile.
  ///
  /// In en, this message translates to:
  /// **'{label} post #{id}'**
  String taskTileTitle(String label, num id);

  /// Body of a follow notification, shown under the follow's title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{has a new post!} other{has {count} new posts!}}'**
  String followNotificationBody(num count);

  /// Title of the summary notification for multiple follows.
  ///
  /// In en, this message translates to:
  /// **'New posts!'**
  String get followNotificationSummary;

  /// Name of the follow notification channel shown in the system settings.
  ///
  /// In en, this message translates to:
  /// **'Followed Tags'**
  String get followChannelName;

  /// Description of the follow notification channel shown in the system settings.
  ///
  /// In en, this message translates to:
  /// **'Notifications for tags you are following'**
  String get followChannelDescription;

  /// Title of the host unavailable page.
  ///
  /// In en, this message translates to:
  /// **'Host unavailable'**
  String get hostUnavailableTitle;

  /// Body of the host unavailable page.
  ///
  /// In en, this message translates to:
  /// **'It appears that {host} is not available!'**
  String hostUnavailableBody(String host);

  /// Hint about resolving the host unavailability in a browser.
  ///
  /// In en, this message translates to:
  /// **'Please resolve the issue in the following browser window.\n\nCloudflare captcha cookies will be saved.'**
  String get hostUnavailableResolveHint;

  /// Button opening the browser window resolving the host unavailability.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get hostUnavailableResolve;

  /// Body of the host unavailable page when the issue cannot be resolved by the user.
  ///
  /// In en, this message translates to:
  /// **'\nPlease wait for {host} to resolve the situation on their end.'**
  String hostUnavailableWaitBody(String host);

  /// Title of the folder picker dialog on desktop.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder'**
  String get downloadChooseFolder;

  /// Title of the posts search filter prompt.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilterTitle;

  /// Label of the query preview of the posts search filter prompt.
  ///
  /// In en, this message translates to:
  /// **'Current query:'**
  String get searchFilterQueryLabel;

  /// No description provided for @dtextParsingFailed.
  ///
  /// In en, this message translates to:
  /// **'DText parsing has failed'**
  String get dtextParsingFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'ja',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
