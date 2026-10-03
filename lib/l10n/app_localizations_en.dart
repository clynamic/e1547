// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get nothingToSeeHere => 'Nothing to see here';

  @override
  String get loading => 'Loading...';

  @override
  String get actionCancel => 'CANCEL';

  @override
  String get actionOk => 'OK';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get actionDownload => 'DOWNLOAD';

  @override
  String get actionImport => 'IMPORT';

  @override
  String get actionExport => 'EXPORT';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionRestartNow => 'RESTART NOW';

  @override
  String get failedToLoadSuggestions => 'Failed to load suggestions';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => 'Abort';

  @override
  String get actionSelectAll => 'Select all';

  @override
  String fileSavedAs(String name) {
    return 'File saved as $name';
  }

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get saveFile => 'Save file';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get rangeInvalidFormat => 'Invalid format';

  @override
  String itemProgress(num current, num total) {
    return 'Item $current/$total';
  }

  @override
  String get taskCancelled => 'Cancelled task';

  @override
  String taskFailedAt(num index) {
    return 'Failed at item $index';
  }

  @override
  String get taskDone => 'Done';

  @override
  String get failedToInitialize => 'Failed to initialize';

  @override
  String get navHome => 'Home';

  @override
  String get navHot => 'Hot';

  @override
  String get navSearch => 'Search';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navSubscriptions => 'Subscriptions';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navPools => 'Pools';

  @override
  String get navForum => 'Forum';

  @override
  String get navHistory => 'History';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionAccount => 'Account';

  @override
  String get sectionUser => 'User';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionInteractions => 'Interactions';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get sectionDevelopment => 'Development';

  @override
  String get settingsBlacklist => 'Blacklist';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tags blocked',
      one: '1 tag blocked',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => 'Follows';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count searches followed',
      one: '1 search followed',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => 'History';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages visited',
      one: '1 page visited',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeDark => 'dark';

  @override
  String get themeAmoled => 'amoled';

  @override
  String get themeLight => 'light';

  @override
  String get themeBlue => 'blue';

  @override
  String get themeSystem => 'system';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get settingsTileSize => 'Tile size';

  @override
  String get settingsQuilt => 'Quilt';

  @override
  String get gridTitle => 'Grid';

  @override
  String get quiltSquare => 'tiles are quadratic';

  @override
  String get quiltVertical => 'tiles expand vertically';

  @override
  String get settingsPostInfo => 'Post info';

  @override
  String get postInfoShown => 'info on post tiles';

  @override
  String get postInfoHidden => 'image tiles only';

  @override
  String get settingsDownloadLocation => 'Download location';

  @override
  String get settingsUpvoteFavorites => 'Upvote favorites';

  @override
  String get upvoteFavoritesOn => 'upvote and favorite';

  @override
  String get upvoteFavoritesOff => 'favorite only';

  @override
  String get settingsVideoVolume => 'Video volume';

  @override
  String get videoMuted => 'muted';

  @override
  String get videoWithSound => 'with sound';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds seconds';
  }

  @override
  String get settingsVideoResolution => 'Video resolution';

  @override
  String get videoResStandard => 'Standard (480p)';

  @override
  String get videoResHigh => 'High (720p)';

  @override
  String get videoResFull => 'Full (1080p)';

  @override
  String get videoResUltra => 'Ultra (4K)';

  @override
  String get videoResSource => 'Source';

  @override
  String get settingsSecureDisplay => 'Secure display';

  @override
  String get secureDisplayOn => 'screen protected';

  @override
  String get secureDisplayOff => 'screen visible';

  @override
  String get settingsIncognitoKeyboard => 'Incognito keyboard';

  @override
  String get enabled => 'enabled';

  @override
  String get disabled => 'disabled';

  @override
  String get settingsPinLock => 'PIN lock';

  @override
  String get pinEnabled => 'PIN enabled';

  @override
  String get pinDisabled => 'PIN disabled';

  @override
  String get settingsBiometricLock => 'Biometric lock';

  @override
  String get biometricsEnabled => 'biometrics enabled';

  @override
  String get biometricsDisabled => 'biometrics disabled';

  @override
  String get settingsDeveloperMode => 'Developer mode';

  @override
  String get devOptionsShown => 'options shown';

  @override
  String get devOptionsHidden => 'options hidden';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors logged',
      one: '1 error logged',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => 'Database';

  @override
  String get databaseExporting => 'Exporting database...';

  @override
  String get databaseExported => 'Database exported successfully';

  @override
  String get databaseExportFailed => 'Export failed';

  @override
  String get databaseExport => 'Export';

  @override
  String get databaseImporting => 'Importing database...';

  @override
  String databaseInvalidFile(String error) {
    return 'Invalid database file: $error';
  }

  @override
  String databaseImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get databaseImportTitle => 'Import Database';

  @override
  String get databaseRestartTitle => 'Restart Required';

  @override
  String get databaseRestartBody =>
      'The app needs to restart to apply changes.';

  @override
  String get databaseImport => 'Import';

  @override
  String get lockEnterPin => 'Enter PIN';

  @override
  String get lockEnterNewPin => 'Enter new PIN';

  @override
  String get lockConfirmNewPin => 'Confirm new PIN';

  @override
  String get lockFailedAuth => 'Failed to authenticate';

  @override
  String get lockPleaseAuth => 'Please authenticate';

  @override
  String get lockRetry => 'Retry';

  @override
  String get lockBiometricReason => 'Authenticate to unlock.';

  @override
  String get lockBiometricFailure =>
      'Severe failure in biometric authentication';

  @override
  String get aboutVersion => 'Version';

  @override
  String get updaterFetching => 'Fetching updates...';

  @override
  String get updaterCheckFailed => 'Failed to check for updates';

  @override
  String get updaterNewest => 'You have the newest version';

  @override
  String updaterNewer(String version) {
    return 'A newer version is available: $version';
  }

  @override
  String get updaterNewerHeader => 'A newer version is available: ';

  @override
  String get aboutExperimentalPlatform => 'Experimental platform';

  @override
  String get aboutExperimentalBody =>
      'This platform is not supported. Expect bugs and missing features.';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => 'Upstream';

  @override
  String get aboutUpstreamBody => 'This app is a fork of clragon/e1547';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => 'Forum';

  @override
  String aboutForumTopic(num id) {
    return 'e621 thread #$id';
  }

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => 'Email';

  @override
  String get aboutPlaystore => 'Playstore';

  @override
  String get aboutDonors => 'Donors';

  @override
  String get aboutDonorsThanks => 'Thanks for helping me keep up development!';

  @override
  String get aboutNoDonors => 'No donors yet';

  @override
  String get aboutDonorsFailed => 'Failed to fetch donors';

  @override
  String get aboutDonorsNotListed => 'Not on the list? Contact us!';

  @override
  String get developerUnlocked => 'You are now a developer!';

  @override
  String get databaseErrorLoading => 'Error loading database';

  @override
  String get databaseUnknownSize => 'Unknown';

  @override
  String get databaseExportTitle => 'Export Database';

  @override
  String get databaseExportSubtitle => 'Save a backup copy of your database';

  @override
  String get databaseImportSubtitle =>
      'Replace current database with imported one';

  @override
  String get databaseImportWarning =>
      'This will replace your current database. \nAll data will be lost. This cannot be undone!';

  @override
  String get databaseExportSanitizedBody =>
      'The exported file will not contain your logins or API keys.\nEverything else, including accounts, hosts, history, follows and tasks, is included.';

  @override
  String get databaseImportNewerFile =>
      'This file was created by a newer app version and cannot be imported.';

  @override
  String get databaseImportSanitized =>
      'For safety, saved logins were removed from the imported file.';

  @override
  String databaseImportHostsWarning(String hosts) {
    return 'Warning: the imported file contains accounts on other sites: $hosts';
  }

  @override
  String get databaseImportCancelled => 'Import cancelled';

  @override
  String get postsTitle => 'Posts';

  @override
  String favoritesOf(String user) {
    return '$user\'s Favorites';
  }

  @override
  String get favoritesUnavailable =>
      'Favorites are unavailable for anonymous users';

  @override
  String get favoriteOrder => 'Favorite order';

  @override
  String get orderAdded => 'added order';

  @override
  String get orderId => 'id order';

  @override
  String get postStateDeleted => 'deleted';

  @override
  String get postStateUnsupported => 'unsupported';

  @override
  String get postStateUnavailable => 'unavailable';

  @override
  String get menuShare => 'Share';

  @override
  String get menuDownload => 'Download';

  @override
  String get menuBrowse => 'Browse';

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuComment => 'Comment';

  @override
  String get menuReport => 'Report';

  @override
  String get menuFlag => 'Flag';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionFollow => 'Follow';

  @override
  String get actionUnfollow => 'Unfollow';

  @override
  String get actionMute => 'Mute';

  @override
  String get actionNotify => 'Notify';

  @override
  String get actionBookmark => 'Bookmark';

  @override
  String get actionUnbookmark => 'Unbookmark';

  @override
  String get actionBlock => 'Block';

  @override
  String get actionUnblock => 'Unblock';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionSubtract => 'Subtract';

  @override
  String selectionPost(num id) {
    return 'post #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => 'No posts';

  @override
  String get failedToLoadPosts => 'Failed to load posts';

  @override
  String get offlineBanner => 'You are offline. Showing cached data.';

  @override
  String get offlineNoData => 'You are offline';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '$count post',
    );
    return 'Page $page · $_temp0';
  }

  @override
  String get postListPageLimit =>
      'You have reached the server\'s page limit. Please narrow your search terms.';

  @override
  String get postListJumpToPage => 'Jump to page';

  @override
  String get postListJumpPageLabel => 'Page number';

  @override
  String postListJumpPageRange(Object max) {
    return 'Enter a page number between 1 and $max';
  }

  @override
  String get postDeletedOverlay => 'Post was deleted';

  @override
  String get postUnavailableOverlay => 'Post is unavailable';

  @override
  String get postBlacklistedOverlay => 'Post is blacklisted';

  @override
  String unsupportedFileType(String ext) {
    return '$ext files are not supported';
  }

  @override
  String get loginRequiredEdit => 'You must be logged in to edit posts!';

  @override
  String get loginRequiredComment => 'You must be logged in to comment!';

  @override
  String get loginRequiredReport => 'You must be logged in to report posts!';

  @override
  String get loginRequiredFlag => 'You must be logged in to flag posts!';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'blocked $count posts',
      one: 'blocked 1 post',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => 'Failed to update blacklist!';

  @override
  String get blacklistAddTag => 'Add tag';

  @override
  String get blacklistEditTag => 'Edit tag';

  @override
  String get denylistEntryDeleted => 'Blacklist entry removed';

  @override
  String get blacklistEmpty => 'Your blacklist is empty';

  @override
  String get menuDelete => 'Delete';

  @override
  String get filterScore => 'Score';

  @override
  String get filterFavoriteCount => 'Favorite count';

  @override
  String get filterSortBy => 'Sort by';

  @override
  String get filterNew => 'New';

  @override
  String get filterRank => 'Rank';

  @override
  String get filterRandom => 'Random';

  @override
  String get filterDefault => 'Default';

  @override
  String get filterRating => 'Rating';

  @override
  String get filterSafe => 'Safe';

  @override
  String get filterQuestionable => 'Questionable';

  @override
  String get filterExplicit => 'Explicit';

  @override
  String get filterAll => 'All';

  @override
  String get filterPool => 'Pool';

  @override
  String get filterHasPool => 'Has pool';

  @override
  String get filterChild => 'Child';

  @override
  String get filterIsChildPost => 'Is child post';

  @override
  String get filterParent => 'Parent';

  @override
  String get filterIsParentPost => 'Is parent post';

  @override
  String get filterUploadDate => 'Upload date';

  @override
  String get filterLastDay => 'Last day';

  @override
  String get filterLastWeek => 'Last week';

  @override
  String get filterLastMonth => 'Last Month';

  @override
  String get filterLastYear => 'Last Year';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterActive => 'Active';

  @override
  String get filterPending => 'Pending';

  @override
  String get filterDeleted => 'Deleted';

  @override
  String get filterFlagged => 'Flagged';

  @override
  String get filterAny => 'Any';

  @override
  String get filterFileType => 'File type';

  @override
  String get filterUploader => 'Uploader';

  @override
  String get filterWidth => 'Width';

  @override
  String get filterHeight => 'Height';

  @override
  String get filterTagCount => 'Tag count';

  @override
  String get filterTrue => 'True';

  @override
  String get filterFalse => 'False';

  @override
  String get filterImages => 'Images';

  @override
  String get filterVideos => 'Videos';

  @override
  String get filterTitleContains => 'Title contains';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterGeneral => 'General';

  @override
  String get filterSiteBugReports => 'Site Bug Reports & Feature Requests';

  @override
  String get filterTagWikiProjects => 'Tag/Wiki Projects and Questions';

  @override
  String get filterTagAliasSuggestions =>
      'Tag Alias and Implication Suggestions';

  @override
  String get filterArtTalk => 'Art Talk';

  @override
  String get filterOffTopic => 'Off Topic';

  @override
  String get filterE621Tools => 'e621 Tools and Applications';

  @override
  String get filterNewestFirst => 'Newest first';

  @override
  String get filterOldestFirst => 'Oldest first';

  @override
  String get filterSticky => 'Sticky';

  @override
  String get filterIsSticky => 'Is sticky';

  @override
  String get filterLocked => 'Locked';

  @override
  String get filterIsLocked => 'Is locked';

  @override
  String get filterDescription => 'Description';

  @override
  String get filterCreator => 'Creator';

  @override
  String get filterIsActive => 'Is active';

  @override
  String get filterSeries => 'Series';

  @override
  String get filterCollection => 'Collection';

  @override
  String get filterName => 'Name';

  @override
  String get filterCreated => 'Created';

  @override
  String get filterUpdated => 'Updated';

  @override
  String get filterPostCount => 'Post count';

  @override
  String postUpdateFailed(num id) {
    return 'Failed to update post #$id';
  }

  @override
  String postUpdated(num id) {
    return 'Updated post #$id';
  }

  @override
  String get failedToLoadPost => 'Failed to load post';

  @override
  String get postNotFound => 'Post not found';

  @override
  String get commentsTitle => 'Comments';

  @override
  String commentsOfPost(num postId) {
    return '#$postId comments';
  }

  @override
  String get commentOrder => 'Comment order';

  @override
  String get noComments => 'No comments';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String commentTitle(num id) {
    return 'Comment #$id';
  }

  @override
  String get failedToLoadComment => 'Failed to load comment';

  @override
  String get commentNotFound => 'Comment not found';

  @override
  String commentEditorTitle(num postId) {
    return '#$postId comment';
  }

  @override
  String get commentSendFailed => 'Failed to send comment!';

  @override
  String get commentSent => 'Comment sent!';

  @override
  String get commentHidden => 'This comment is hidden';

  @override
  String commentUpvoteFailed(num id) {
    return 'Failed to upvote comment #$id';
  }

  @override
  String commentDownvoteFailed(num id) {
    return 'Failed to downvote comment #$id';
  }

  @override
  String get commentLoginRequiredEdit =>
      'You must be logged in to edit comments!';

  @override
  String get commentLoginRequiredReply =>
      'You must be logged in to reply to comments!';

  @override
  String get commentLoginRequiredReport =>
      'You must be logged in to report comments!';

  @override
  String commentCopiedId(num id) {
    return 'Copied comment id #$id';
  }

  @override
  String get warningUserWarned => 'User received a warning for this message';

  @override
  String get warningUserRecorded => 'User received a record for this message';

  @override
  String get warningUserBanned => 'User was banned for this message';

  @override
  String get repliesTitle => 'Replies';

  @override
  String get replyOrder => 'Reply order';

  @override
  String get noReplies => 'No replies';

  @override
  String get failedToLoadReplies => 'Failed to load replies';

  @override
  String replyTitle(num id) {
    return 'Reply #$id';
  }

  @override
  String get failedToLoadReply => 'Failed to load reply';

  @override
  String get replyNotFound => 'Reply not found';

  @override
  String replyEditorTitle(num topicId) {
    return '#$topicId reply';
  }

  @override
  String get replySendFailed => 'Failed to send reply!';

  @override
  String get replySent => 'Reply sent!';

  @override
  String get replyHidden => 'This reply is hidden';

  @override
  String get replyLoginRequiredEdit => 'You must be logged in to edit replies!';

  @override
  String get replyLoginRequiredReply => 'You must be logged in to reply!';

  @override
  String get replyLoginRequiredReport =>
      'You must be logged in to report replies!';

  @override
  String replyCopiedId(num id) {
    return 'Copied reply id #$id';
  }

  @override
  String get menuReply => 'Reply';

  @override
  String get menuCopyId => 'Copy ID';

  @override
  String get menuRefresh => 'Refresh';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionSave => 'Save';

  @override
  String get actionShow => 'Show';

  @override
  String get actionHide => 'Hide';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get info => 'Info';

  @override
  String wikiTitle(String idOrTitle) {
    return 'Wiki $idOrTitle';
  }

  @override
  String get failedToLoadWiki => 'Failed to load wiki';

  @override
  String get wikiNotFound => 'Wiki not found';

  @override
  String wikiCopiedId(num id) {
    return 'Copied wiki id #$id';
  }

  @override
  String get wikiInfoId => 'id';

  @override
  String get wikiInfoAlias => 'alias';

  @override
  String get wikiInfoCreated => 'created';

  @override
  String get wikiInfoUpdated => 'updated';

  @override
  String get wikiInfoLocked => 'locked';

  @override
  String get wikiInfoYes => 'yes';

  @override
  String get wikiInfoNo => 'no';

  @override
  String userTitle(String idOrName) {
    return 'User $idOrName';
  }

  @override
  String get failedToLoadUser => 'Failed to load user';

  @override
  String get userNotFound => 'User not found';

  @override
  String get userUploads => 'Uploads';

  @override
  String get userLoginRequiredReport =>
      'You must be logged in to report users!';

  @override
  String get userComission => 'Commission';

  @override
  String get userId => 'id';

  @override
  String get userJoined => 'joined';

  @override
  String get userRank => 'rank';

  @override
  String get userPosts => 'posts';

  @override
  String get userEdits => 'edits';

  @override
  String get userFavorites => 'favorites';

  @override
  String get userComments => 'comments';

  @override
  String get userForum => 'forum';

  @override
  String userCopiedId(num id) {
    return 'Copied user id #$id';
  }

  @override
  String get logsTitle => 'Logs';

  @override
  String logsTitleDate(String date) {
    return 'Logs - $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count logs',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count log files',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => 'Levels';

  @override
  String get logsRecording => 'Recording';

  @override
  String get logsVerbose => 'Verbose';

  @override
  String get logsVerboseAll => 'all levels recorded';

  @override
  String logsVerboseMinimum(String level) {
    return '$level and above';
  }

  @override
  String get logFilesTitle => 'Log Files';

  @override
  String get failedToLoadLogFiles => 'Failed to load log files!';

  @override
  String get noLogFiles => 'No log files available!';

  @override
  String get logsLive => 'Live';

  @override
  String get noLogs => 'No logs';

  @override
  String get failedToReadLog => 'Failed to read the log';

  @override
  String get noErrorsLogged => 'No errors logged';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors',
      one: '1 error',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => 'All logs';

  @override
  String get logsDismissAll => 'Dismiss all';

  @override
  String logsDeleteTitle(num count) {
    return 'Delete $count log files?';
  }

  @override
  String get identityAccounts => 'Accounts';

  @override
  String get identityAdd => 'Add account';

  @override
  String get identityEdit => 'Edit account';

  @override
  String get identityRemoveTitle => 'Remove account?';

  @override
  String get identityRemoveBody =>
      'All its data will be permanently removed, including history and follows.';

  @override
  String get identityAnonymous => 'Anonymous';

  @override
  String get identityDuplicate =>
      'You already have an identity under this host and username.';

  @override
  String identityLoginFailed(String reason) {
    return 'Failed to log in. \n$reason';
  }

  @override
  String get identityLoginCheckDetails =>
      'Check your network connection and login details';

  @override
  String get identitySite => 'Site';

  @override
  String get identityHostRequired => 'You must provide a host URL.';

  @override
  String get identityHostInvalid => 'Invalid host URL';

  @override
  String get identityHostReadOnly =>
      'Site can\'t be changed. Add a new account to use a different one.';

  @override
  String get identityUsernameLabel => 'Username';

  @override
  String get identityUsernameRequired => 'You must provide a username.';

  @override
  String get identityApikeyLabel => 'API key';

  @override
  String get identityApikeyHelp => 'Where do I find my API key?';

  @override
  String get identityApikeyRequired =>
      'You must provide an API key.\ne.g. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'API key is a 24 or 32-character sequence of A-z and 0-9\ne.g. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => 'Don\'t have an account? Sign up here';

  @override
  String get identityHostHint => 'The site that hosts your account and posts.';

  @override
  String get identitySignIn => 'Sign in';

  @override
  String get identityGuest => 'Guest';

  @override
  String get identityLogin => 'Log in';

  @override
  String get identityBrowseAnonymously => 'Browse anonymously';

  @override
  String identityConnecting(String host, String username) {
    return 'Connecting to $host as $username…';
  }

  @override
  String identityActivateFailed(Object error) {
    return 'Failed to activate identity: $error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return 'Failed to activate traits: $error';
  }

  @override
  String get failedToLoadIdentities => 'Failed to load identities';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String onboardingWelcomeTitle(String app) {
    return 'Welcome to $app';
  }

  @override
  String get onboardingWelcomeBody => 'A sophisticated booru browser.';

  @override
  String get onboardingThemeTitle => 'Pick a look';

  @override
  String get onboardingThemeBody =>
      'Try one on. You can always change your mind later.';

  @override
  String get onboardingLoginTitle => 'Connect an account';

  @override
  String get onboardingLanguageTitle => 'Choose a language';

  @override
  String get followAddToSubscriptions => 'Add to subscriptions';

  @override
  String get followNoSubscriptions => 'No subscriptions';

  @override
  String get followFailedToLoadSubscriptions => 'Failed to load subscriptions';

  @override
  String get followAddToBookmarks => 'Add to bookmarks';

  @override
  String get followNoBookmarks => 'No bookmarks';

  @override
  String get followFailedToLoadBookmarks => 'Failed to load bookmarks';

  @override
  String get followUnseenPosts => 'unseen posts';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mark $count posts as seen',
      one: 'mark 1 post as seen',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => 'no unseen posts';

  @override
  String get followShowUnseenFirst => 'show unseen first';

  @override
  String get followFilteringUnseen => 'filtering for unseen';

  @override
  String get followAllPostsShown => 'all posts shown';

  @override
  String get followForceSync => 'Force sync';

  @override
  String get followSyncAllFollows => 'sync all follows';

  @override
  String followSyncingFollows(String progress) {
    return 'syncing follows... $progress';
  }

  @override
  String get followEditorTitle => 'Edit follows';

  @override
  String get followSubscribe => 'Subscribe';

  @override
  String get followEditPrompt => 'Edit follow';

  @override
  String get followTitlePrompt => 'Follow title';

  @override
  String get followMarkAsRead => 'Mark as read';

  @override
  String get followDisableNotifications => 'Disable notifications';

  @override
  String get followEnableNotifications => 'Enable notifications';

  @override
  String get followRename => 'Rename';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label new posts',
      one: '1 new post',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count follows',
      one: '1 follow',
    );
    return '$_temp0';
  }

  @override
  String followAlias(String? alias) {
    return 'alias $alias';
  }

  @override
  String historySelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted $count history entries',
      one: 'Deleted 1 history entry',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => 'Clear history';

  @override
  String get historyClearSubtitle => 'Delete all entries';

  @override
  String get historyClearConfirm => 'Clear history?';

  @override
  String get historyClearConfirmBody =>
      'All history entries will be permanently deleted. This action cannot be undone.';

  @override
  String get historyClearAction => 'Clear';

  @override
  String get historyLimit => 'History limit';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return 'Enabling history limit means all history entries beyond $amount and all entries older than $months months are automatically deleted.';
  }

  @override
  String get historyLimitTitle => 'Limit history';

  @override
  String historyLimitOn(String amount, num months) {
    return 'Limited to newer than $months months or less than $amount entries.';
  }

  @override
  String get historyLimitOff => 'history is infinite';

  @override
  String get historyEntries => 'Entries';

  @override
  String get historyType => 'Type';

  @override
  String get historyItems => 'Items';

  @override
  String get historySearches => 'Searches';

  @override
  String get historyWikis => 'Wikis';

  @override
  String get historyUsers => 'Users';

  @override
  String get historyEmpty => 'Your history is empty';

  @override
  String get historyFailedToLoad => 'Failed to load history';

  @override
  String get historyNoDescription => 'no description';

  @override
  String get historyHotPosts => 'Hot posts';

  @override
  String historyLinkPost(num id) {
    return 'Post #$id';
  }

  @override
  String historyLinkUser(num id) {
    return 'User #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return 'Wiki #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return '$id - User';
  }

  @override
  String historyLinkWikiByName(String id) {
    return '$id - Wiki';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type - $query';
  }

  @override
  String get historyWiki => 'Wiki';

  @override
  String get poolEmpty => 'No pools';

  @override
  String get poolFailedToLoadPools => 'Failed to load pools';

  @override
  String get poolTitle => 'Pool title';

  @override
  String get poolInfoPosts => 'posts';

  @override
  String get poolInfoId => 'id';

  @override
  String get poolInfoActivity => 'activity';

  @override
  String get poolInfoActive => 'active';

  @override
  String get poolInfoInactive => 'inactive';

  @override
  String get poolInfoCreated => 'created';

  @override
  String get poolInfoUpdated => 'updated';

  @override
  String poolCopiedId(num id) {
    return 'Copied pool id #$id';
  }

  @override
  String poolLink(num id) {
    return 'Pool #$id';
  }

  @override
  String get poolFailedToLoadPool => 'Failed to load pool';

  @override
  String get poolNotFound => 'Pool not found';

  @override
  String get poolOrder => 'Pool order';

  @override
  String get poolOldestFirst => 'Oldest first';

  @override
  String get poolNewestFirst => 'Newest first';

  @override
  String get poolReaderMode => 'Pool reader mode';

  @override
  String get poolReaderLargeImages => 'large images';

  @override
  String get poolReaderNormalGrid => 'normal grid';

  @override
  String get topicsTitle => 'Topics';

  @override
  String get topicHideTagEdits => 'Hide tags edits';

  @override
  String get topicTagEditsHidden => 'hidden';

  @override
  String get topicTagEditsVisible => 'visible';

  @override
  String topicLink(num id) {
    return 'Topic #$id';
  }

  @override
  String get topicFailedToLoadTopic => 'Failed to load topic';

  @override
  String get topicNotFound => 'Topic not found';

  @override
  String get topicEmpty => 'No topics';

  @override
  String get topicFailedToLoadTopics => 'Failed to load topics';

  @override
  String get topicInfoReplies => 'replies';

  @override
  String get topicInfoId => 'id';

  @override
  String topicCopiedId(num id) {
    return 'Copied topic id #$id';
  }

  @override
  String get topicInfoLocked => 'locked';

  @override
  String get topicInfoYes => 'yes';

  @override
  String get topicInfoNo => 'no';

  @override
  String get topicInfoCreated => 'created';

  @override
  String get topicInfoUpdated => 'updated';

  @override
  String get filterTags => 'Tags';

  @override
  String get loginRequired => 'You must be logged in to perform this action.';

  @override
  String get actionChooseIdentity => 'Choose identity';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String detailCommentsButton(num count) {
    return 'COMMENTS ($count)';
  }

  @override
  String get detailFile => 'File';

  @override
  String get detailSources => 'Sources';

  @override
  String get detailNoSources => 'no sources';

  @override
  String get detailChildren => 'Children';

  @override
  String get detailDeletion => 'Deletion';

  @override
  String get detailBlacklisted => 'Blacklisted';

  @override
  String get detailNoArtist => 'no artist';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '1 post',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return 'Copied post id #$id';
  }

  @override
  String postUpvoteFailed(num id) {
    return 'Failed to upvote post #$id';
  }

  @override
  String postDownvoteFailed(num id) {
    return 'Failed to downvote post #$id';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return 'Failed to add post #$id to favorites';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return 'Failed to remove post #$id from favorites';
  }

  @override
  String get editorSection => 'Section';

  @override
  String get editorQuote => 'Quote';

  @override
  String get editorCode => 'Code';

  @override
  String get editorSpoiler => 'Spoiler';

  @override
  String get editorBold => 'Bold';

  @override
  String get editorItalic => 'Italic';

  @override
  String get editorUnderlined => 'Underlined';

  @override
  String get editorStrikethrough => 'Strikethrough';

  @override
  String get editorPreviewPlaceholder => 'your text here';

  @override
  String get editorWrite => 'Write';

  @override
  String get editorPreview => 'Preview';

  @override
  String get editorTypeHere => 'type here...';

  @override
  String get tagNoTags => 'no tags';

  @override
  String get tagFailedToLoadTags => 'failed to load tags';

  @override
  String get tagUnableToRetrieveWiki => 'unable to retrieve wiki entry';

  @override
  String get tagNoWikiEntry => 'no wiki entry';

  @override
  String get tagCategoryGeneral => 'General';

  @override
  String get tagCategorySpecies => 'Species';

  @override
  String get tagCategoryCharacter => 'Character';

  @override
  String get tagCategoryCopyright => 'Copyright';

  @override
  String get tagCategoryMeta => 'Meta';

  @override
  String get tagCategoryLore => 'Lore';

  @override
  String get tagCategoryArtist => 'Artist';

  @override
  String get tagCategoryContributor => 'Contributor';

  @override
  String get tagCategoryInvalid => 'Invalid';

  @override
  String editDescriptionTitle(num postId) {
    return '#$postId description';
  }

  @override
  String get editDescriptionHint => 'Enter post description...';

  @override
  String get editInvalidNumber => 'Invalid number format';

  @override
  String get editInvalidParent => 'Invalid parent post';

  @override
  String get editParentIdLabel => 'Parent ID (optional)';

  @override
  String get editParentIdHint => 'Parent post ID';

  @override
  String get editReasonLabel => 'Edit reason (optional)';

  @override
  String get editReasonHint => 'Why are you editing this post?';

  @override
  String editSourcesTitle(num postId) {
    return '#$postId sources';
  }

  @override
  String get editTagsHint => 'space separated tags';

  @override
  String editTagPreviewFailed(String error) {
    return 'Error loading tag preview: $error';
  }

  @override
  String get editTagStatusNew => 'new';

  @override
  String get editTagStatusInvalid => 'invalid';

  @override
  String get editTagStatusEmpty => 'empty';

  @override
  String get editTagStatusUnderused => 'underused';

  @override
  String reportCommentSuccess(num id) {
    return 'Reported comment #$id';
  }

  @override
  String reportCommentFailed(num id) {
    return 'Failed to report comment #$id';
  }

  @override
  String reportReplySuccess(num id) {
    return 'Reported reply #$id';
  }

  @override
  String reportReplyFailed(num id) {
    return 'Failed to report reply #$id';
  }

  @override
  String reportUserSuccess(num id) {
    return 'Reported user #$id';
  }

  @override
  String reportUserFailed(num id) {
    return 'Failed to report user #$id';
  }

  @override
  String reportPostSuccess(num id) {
    return 'Reported post #$id';
  }

  @override
  String reportPostFailed(num id) {
    return 'Failed to report post #$id';
  }

  @override
  String get reportTypeRequired => 'Type cannot be empty';

  @override
  String get reportReason => 'Reason';

  @override
  String get reportReasonRequired => 'Reason cannot be empty';

  @override
  String get reportSubmitted => 'Submitted report';

  @override
  String get reportSubmitFailed => 'Failed to submit report';

  @override
  String get reportTypeRating => 'Rating Abuse';

  @override
  String get reportTypeFile => 'Malicious File';

  @override
  String get reportTypeSource => 'Malicious Source';

  @override
  String get reportTypeDescription => 'Description Abuse';

  @override
  String get reportTypeNote => 'Note Abuse';

  @override
  String get reportTypeTagging => 'Tagging Abuse';

  @override
  String get reportTypeRatingBody =>
      'The rating of the submission has been set to something incorrect.';

  @override
  String get reportTypeFileBody =>
      'The file contains either malicious code or contains a hidden file archive. This is not for imagery depicted in the image itself.';

  @override
  String get reportTypeSourceBody =>
      'One or more of the listed sources link to malicious pages or pay content.';

  @override
  String get reportTypeDescriptionBody =>
      'The description contains malicious content, or has been edited to contain abusive material.';

  @override
  String get reportTypeNoteBody =>
      'The notes on this post are wrong, harassive, or otherwise abusive.';

  @override
  String get reportTypeTaggingBody =>
      'One or more tags on this post aren\'t valid or one or more valid tags have been removed from this post.';

  @override
  String flagPostSuccess(num id) {
    return 'Flagged post #$id';
  }

  @override
  String flagPostFailed(num id) {
    return 'Failed to flag post #$id';
  }

  @override
  String get flagParentId => 'Parent ID';

  @override
  String get flagParentIdRequired => 'Parent ID cannot be empty';

  @override
  String get flagParentIdInvalid => 'Parent ID must be a number';

  @override
  String get flagTypeUploadingGuidelines =>
      'Does not meet the uploading guidelines';

  @override
  String get flagTypeYoungHuman =>
      'Young human-like character in an explicit situation';

  @override
  String get flagTypeDnpArtist =>
      'The artist of this post is on the avoid posting list';

  @override
  String get flagTypePayContent =>
      'Paysite, commercial, or subscription content';

  @override
  String get flagTypeTrace => 'Trace of another artist\'s work';

  @override
  String get flagTypePreviouslyDeleted => 'Previously deleted';

  @override
  String get flagTypeRealPorn => 'Real-life pornography';

  @override
  String get flagTypeCorrupt =>
      'File is either corrupted, broken, or otherwise does not work';

  @override
  String get flagTypeInferior =>
      'Duplicate or inferior version of another post';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      'This post fails to meet the site\'s standards, be it for artistic worth, image quality, relevancy, or something else.\nKeep in mind that your personal preferences have no bearing on this. If you find the content of a post objectionable, simply [[e621:blacklist|blacklist]] it.';

  @override
  String get flagTypeYoungHumanBody =>
      'Posts featuring human and human-like characters depicted in a sexual or explicit nude way, are not acceptable on this site.';

  @override
  String get flagTypeDnpArtistBody =>
      'Certain artists have requested that their work is not to be published on this site, and were granted [[avoid_posting|Do Not Post]] status.\nSometimes, that status comes with conditions; see [[conditional_dnp]] for more information';

  @override
  String get flagTypePayContentBody =>
      'We do not host paysite or commercial content of any kind. This includes Patreon leaks, reposts from piracy websites, and so on.';

  @override
  String get flagTypeTraceBody =>
      'Images traced from other artists\' artwork are not accepted on this site. Referencing from something is fine, but outright copying someone else\'s work is not.\nPlease, leave more information in the comments, or simply add the original artwork as the posts\'s parent if it\'s hosted on this site.';

  @override
  String get flagTypePreviouslyDeletedBody =>
      'Posts usually get removed for a good reason, and reuploading of deleted content is not acceptable.\nPlease, leave more information in the comments, or simply add the original post as this post\'s parent.';

  @override
  String get flagTypeRealPornBody =>
      'Posts featuring real-life pornography are not acceptable on this site. No exceptions.\nNote that images featuring non-erotic photographs are acceptable.';

  @override
  String get flagTypeCorruptBody =>
      'Something about this post does not work quite right. This may be a broken video, or a corrupted image.\nEither way, in order to avoid confusion, please explain the situation in the comments.';

  @override
  String get flagTypeInferiorBody =>
      'A superior version of this post already exists on the site.\nThis may include images with better visual quality (larger, less compressed), but may also feature \"fixed\" versions, with visual mistakes accounted for by the artist.\nNote that edits and alternate versions do not fall under this category.';

  @override
  String get taskCancelAll => 'Cancel all';

  @override
  String get taskClearDone => 'Clear done';

  @override
  String get taskClearSelection => 'Clear selection';

  @override
  String get taskCancel => 'Cancel';

  @override
  String get taskDismiss => 'Dismiss';

  @override
  String get taskNoTasks => 'No tasks';

  @override
  String get taskFailedToLoadTasks => 'Failed to load tasks';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => 'Active';

  @override
  String get taskGroupFailed => 'Failed';

  @override
  String get taskActionDownload => 'download';

  @override
  String get taskActionFavorite => 'favorite';

  @override
  String get taskActionUnfavorite => 'unfavorite';

  @override
  String get taskDownloadRunning => 'downloading';

  @override
  String get taskFavoriteRunning => 'favoriting';

  @override
  String get taskUnfavoriteRunning => 'unfavoriting';

  @override
  String get taskDownloadCompleted => 'downloaded';

  @override
  String get taskFavoriteCompleted => 'favorited';

  @override
  String get taskUnfavoriteCompleted => 'unfavorited';

  @override
  String taskQueuedTo(String action) {
    return 'queued to $action';
  }

  @override
  String taskFailedTo(String action) {
    return 'failed to $action';
  }

  @override
  String taskCanceledAction(String action) {
    return 'canceled $action';
  }

  @override
  String taskTileTitle(String label, num id) {
    return '$label post #$id';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'has $count new posts!',
      one: 'has a new post!',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => 'New posts!';

  @override
  String get followChannelName => 'Followed Tags';

  @override
  String get followChannelDescription =>
      'Notifications for tags you are following';

  @override
  String get hostUnavailableTitle => 'Host unavailable';

  @override
  String hostUnavailableBody(String host) {
    return 'It appears that $host is not available!';
  }

  @override
  String get hostUnavailableResolveHint =>
      'Please resolve the issue in the following browser window.\n\nCloudflare captcha cookies will be saved.';

  @override
  String get hostUnavailableResolve => 'Resolve';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\nPlease wait for $host to resolve the situation on their end.';
  }

  @override
  String get downloadChooseFolder => 'Choose a folder';

  @override
  String get searchFilterTitle => 'Filters';

  @override
  String get searchFilterQueryLabel => 'Current query:';

  @override
  String get dtextParsingFailed => 'DText parsing has failed';
}
