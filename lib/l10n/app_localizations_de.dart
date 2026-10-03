// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => 'Laden fehlgeschlagen';

  @override
  String get nothingToSeeHere => 'Hier gibt es nichts zu sehen';

  @override
  String get loading => 'Lädt…';

  @override
  String get actionCancel => 'ABBRECHEN';

  @override
  String get actionOk => 'OK';

  @override
  String get actionTryAgain => 'Erneut versuchen';

  @override
  String get actionDownload => 'HERUNTERLADEN';

  @override
  String get actionImport => 'IMPORTIEREN';

  @override
  String get actionExport => 'EXPORTIEREN';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get actionRestartNow => 'JETZT NEUSTARTEN';

  @override
  String get failedToLoadSuggestions =>
      'Vorschläge konnten nicht geladen werden';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '1 Element',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => 'Abbrechen';

  @override
  String get actionSelectAll => 'Alle auswählen';

  @override
  String fileSavedAs(String name) {
    return 'Datei gespeichert als $name';
  }

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get saveFile => 'Datei speichern';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get rangeInvalidFormat => 'Ungültiges Format';

  @override
  String itemProgress(num current, num total) {
    return 'Element $current/$total';
  }

  @override
  String get taskCancelled => 'Aufgabe abgebrochen';

  @override
  String taskFailedAt(num index) {
    return 'Fehler bei Element $index';
  }

  @override
  String get taskDone => 'Fertig';

  @override
  String get failedToInitialize => 'Initialisierung fehlgeschlagen';

  @override
  String get navHome => 'Start';

  @override
  String get navHot => 'Beliebt';

  @override
  String get navSearch => 'Suche';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get navTimeline => 'Chronik';

  @override
  String get navSubscriptions => 'Abos';

  @override
  String get navBookmarks => 'Lesezeichen';

  @override
  String get navPools => 'Pools';

  @override
  String get navForum => 'Forum';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navAbout => 'Über';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get sectionUser => 'Benutzer';

  @override
  String get sectionAppearance => 'Erscheinungsbild';

  @override
  String get sectionInteractions => 'Interaktionen';

  @override
  String get sectionSecurity => 'Sicherheit';

  @override
  String get sectionDevelopment => 'Entwicklung';

  @override
  String get settingsBlacklist => 'Blacklist';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tags blockiert',
      one: '1 Tag blockiert',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => 'Abos';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Suchen abonniert',
      one: '1 Suche abonniert',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => 'Verlauf';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten besucht',
      one: '1 Seite besucht',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeBlue => 'Blau';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemstandard';

  @override
  String get settingsTileSize => 'Kachelgröße';

  @override
  String get settingsQuilt => 'Rasterform';

  @override
  String get gridTitle => 'Raster';

  @override
  String get quiltSquare => 'quadratische Kacheln';

  @override
  String get quiltVertical => 'hochkantige Kacheln';

  @override
  String get settingsPostInfo => 'Beitragsinfos';

  @override
  String get postInfoShown => 'Infos auf Kacheln';

  @override
  String get postInfoHidden => 'nur Bilder';

  @override
  String get settingsDownloadLocation => 'Download-Ordner';

  @override
  String get settingsUpvoteFavorites => 'Favoriten bewerten';

  @override
  String get upvoteFavoritesOn => 'positiv bewerten und favorisieren';

  @override
  String get upvoteFavoritesOff => 'nur favorisieren';

  @override
  String get settingsVideoVolume => 'Video-Lautstärke';

  @override
  String get videoMuted => 'stumm';

  @override
  String get videoWithSound => 'mit Ton';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds Sekunden';
  }

  @override
  String get settingsVideoResolution => 'Video-Auflösung';

  @override
  String get videoResStandard => 'Standard (480p)';

  @override
  String get videoResHigh => 'Hoch (720p)';

  @override
  String get videoResFull => 'Full HD (1080p)';

  @override
  String get videoResUltra => 'Ultra (4K)';

  @override
  String get videoResSource => 'Original';

  @override
  String get settingsSecureDisplay => 'Displayschutz';

  @override
  String get secureDisplayOn => 'Bildschirm geschützt';

  @override
  String get secureDisplayOff => 'Bildschirm sichtbar';

  @override
  String get settingsIncognitoKeyboard => 'Inkognito-Tastatur';

  @override
  String get enabled => 'aktiviert';

  @override
  String get disabled => 'deaktiviert';

  @override
  String get settingsPinLock => 'PIN-Sperre';

  @override
  String get pinEnabled => 'PIN aktiv';

  @override
  String get pinDisabled => 'PIN inaktiv';

  @override
  String get settingsBiometricLock => 'Biometrische Sperre';

  @override
  String get biometricsEnabled => 'Biometrie aktiv';

  @override
  String get biometricsDisabled => 'Biometrie inaktiv';

  @override
  String get settingsDeveloperMode => 'Entwicklermodus';

  @override
  String get devOptionsShown => 'Optionen sichtbar';

  @override
  String get devOptionsHidden => 'Optionen verborgen';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fehler protokolliert',
      one: '1 Fehler protokolliert',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => 'Datenbank';

  @override
  String get databaseExporting => 'Datenbank wird exportiert…';

  @override
  String get databaseExported => 'Datenbank exportiert';

  @override
  String get databaseExportFailed => 'Export fehlgeschlagen';

  @override
  String get databaseExport => 'Exportieren';

  @override
  String get databaseImporting => 'Datenbank wird importiert…';

  @override
  String databaseInvalidFile(String error) {
    return 'Ungültige Datenbankdatei: $error';
  }

  @override
  String databaseImportFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get databaseImportTitle => 'Datenbank importieren';

  @override
  String get databaseRestartTitle => 'Neustart erforderlich';

  @override
  String get databaseRestartBody =>
      'Die App muss neu gestartet werden, um die Änderungen zu übernehmen.';

  @override
  String get databaseImport => 'Importieren';

  @override
  String get lockEnterPin => 'PIN eingeben';

  @override
  String get lockEnterNewPin => 'Neue PIN eingeben';

  @override
  String get lockConfirmNewPin => 'Neue PIN bestätigen';

  @override
  String get lockFailedAuth => 'Authentifizierung fehlgeschlagen';

  @override
  String get lockPleaseAuth => 'Bitte authentifizieren';

  @override
  String get lockRetry => 'Erneut versuchen';

  @override
  String get lockBiometricReason => 'Zum Entsperren authentifizieren.';

  @override
  String get lockBiometricFailure =>
      'Kritischer Fehler der biometrischen Authentifizierung';

  @override
  String get aboutVersion => 'Version';

  @override
  String get updaterFetching => 'Suche nach Updates…';

  @override
  String get updaterCheckFailed => 'Update-Prüfung fehlgeschlagen';

  @override
  String get updaterNewest => 'Du hast die neueste Version';

  @override
  String updaterNewer(String version) {
    return 'Eine neue Version ist verfügbar: $version';
  }

  @override
  String get updaterNewerHeader => 'Eine neue Version ist verfügbar: ';

  @override
  String get aboutExperimentalPlatform => 'Experimentelle Plattform';

  @override
  String get aboutExperimentalBody =>
      'Diese Plattform wird nicht unterstützt. Fehler und fehlende Funktionen sind möglich.';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => 'Upstream';

  @override
  String get aboutUpstreamBody => 'Dies ist ein Fork von clragon/e1547';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => 'Forum';

  @override
  String aboutForumTopic(num id) {
    return 'e621-Thema #$id';
  }

  @override
  String get aboutWebsite => 'Webseite';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => 'E-Mail';

  @override
  String get aboutPlaystore => 'Play Store';

  @override
  String get aboutDonors => 'Unterstützer';

  @override
  String get aboutDonorsThanks =>
      'Danke an alle, die die Entwicklung möglich machen!';

  @override
  String get aboutNoDonors => 'Noch keine Unterstützer';

  @override
  String get aboutDonorsFailed => 'Unterstützer konnten nicht geladen werden';

  @override
  String get aboutDonorsNotListed => 'Nicht auf der Liste? Melde dich!';

  @override
  String get developerUnlocked => 'Du bist jetzt ein Entwickler!';

  @override
  String get databaseErrorLoading => 'Fehler beim Laden der Datenbank';

  @override
  String get databaseUnknownSize => 'Unbekannt';

  @override
  String get databaseExportTitle => 'Datenbank exportieren';

  @override
  String get databaseExportSubtitle => 'Ein Backup der Datenbank speichern';

  @override
  String get databaseImportSubtitle =>
      'Ersetzt die aktuelle Datenbank durch den Import';

  @override
  String get databaseImportWarning =>
      'Die aktuelle Datenbank wird ersetzt.\nAlle Daten gehen verloren und können nicht wiederhergestellt werden!';

  @override
  String get databaseExportSanitizedBody =>
      'Die exportierte Datei enthält keine Zugangsdaten und API-Schlüssel.\nAlle übrigen Daten wie Konten, Seiten, Verlauf, Abos und Aufgaben sind enthalten.';

  @override
  String get databaseImportNewerFile =>
      'Diese Datei wurde mit einer neueren Version der App erstellt und kann nicht importiert werden.';

  @override
  String get databaseImportSanitized =>
      'Aus Sicherheitsgründen wurden gespeicherte Zugangsdaten aus der importierten Datei entfernt.';

  @override
  String databaseImportHostsWarning(String hosts) {
    return 'Warnung: Die importierte Datei enthält Konten anderer Seiten: $hosts';
  }

  @override
  String get databaseImportCancelled => 'Import abgebrochen';

  @override
  String get postsTitle => 'Beiträge';

  @override
  String favoritesOf(String user) {
    return 'Favoriten von $user';
  }

  @override
  String get favoritesUnavailable =>
      'Favoriten sind nur mit Anmeldung verfügbar';

  @override
  String get favoriteOrder => 'Favoriten-Sortierung';

  @override
  String get orderAdded => 'nach Hinzufügung';

  @override
  String get orderId => 'nach ID';

  @override
  String get postStateDeleted => 'gelöscht';

  @override
  String get postStateUnsupported => 'nicht unterstützt';

  @override
  String get postStateUnavailable => 'nicht verfügbar';

  @override
  String get menuShare => 'Teilen';

  @override
  String get menuDownload => 'Herunterladen';

  @override
  String get menuBrowse => 'Im Browser öffnen';

  @override
  String get menuEdit => 'Bearbeiten';

  @override
  String get menuComment => 'Kommentieren';

  @override
  String get menuReport => 'Melden';

  @override
  String get menuFlag => 'Markieren';

  @override
  String get actionOpen => 'Öffnen';

  @override
  String get actionFollow => 'Folgen';

  @override
  String get actionUnfollow => 'Entfolgen';

  @override
  String get actionMute => 'Stummschalten';

  @override
  String get actionNotify => 'Benachrichtigen';

  @override
  String get actionBookmark => 'Zu Lesezeichen';

  @override
  String get actionUnbookmark => 'Aus Lesezeichen';

  @override
  String get actionBlock => 'Blockieren';

  @override
  String get actionUnblock => 'Entblocken';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get actionAdd => 'Hinzufügen';

  @override
  String get actionSubtract => 'Ausschließen';

  @override
  String selectionPost(num id) {
    return 'Beitrag #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge',
      one: '1 Beitrag',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => 'Keine Beiträge';

  @override
  String get failedToLoadPosts => 'Beiträge konnten nicht geladen werden';

  @override
  String get offlineBanner =>
      'Keine Verbindung. Zwischengespeicherte Daten werden angezeigt.';

  @override
  String get offlineNoData => 'Offline';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge',
      one: '1 Beitrag',
    );
    return 'Seite $page · $_temp0';
  }

  @override
  String get postListPageLimit =>
      'Das Seitenlimit des Servers ist erreicht. Passe die Suche an.';

  @override
  String get postListJumpToPage => 'Zu Seite springen';

  @override
  String get postListJumpPageLabel => 'Seitennummer';

  @override
  String postListJumpPageRange(Object max) {
    return 'Seitennummer zwischen 1 und $max eingeben';
  }

  @override
  String get postDeletedOverlay => 'Beitrag wurde gelöscht';

  @override
  String get postUnavailableOverlay => 'Beitrag nicht verfügbar';

  @override
  String get postBlacklistedOverlay => 'Beitrag ist auf der Blacklist';

  @override
  String unsupportedFileType(String ext) {
    return '$ext-Dateien werden nicht unterstützt';
  }

  @override
  String get loginRequiredEdit =>
      'Zum Bearbeiten von Beiträgen musst du angemeldet sein!';

  @override
  String get loginRequiredComment =>
      'Zum Kommentieren musst du angemeldet sein!';

  @override
  String get loginRequiredReport =>
      'Zum Melden von Beiträgen musst du angemeldet sein!';

  @override
  String get loginRequiredFlag =>
      'Zum Markieren von Beiträgen musst du angemeldet sein!';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge blockiert',
      one: '1 Beitrag blockiert',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed =>
      'Blacklist konnte nicht aktualisiert werden!';

  @override
  String get blacklistAddTag => 'Tag hinzufügen';

  @override
  String get blacklistEditTag => 'Tag bearbeiten';

  @override
  String get denylistEntryDeleted => 'Blacklist-Eintrag gelöscht';

  @override
  String get blacklistEmpty => 'Deine Blacklist ist leer';

  @override
  String get menuDelete => 'Löschen';

  @override
  String get filterScore => 'Bewertung';

  @override
  String get filterFavoriteCount => 'Favoritenanzahl';

  @override
  String get filterSortBy => 'Sortierung';

  @override
  String get filterNew => 'Neu';

  @override
  String get filterRank => 'Rang';

  @override
  String get filterRandom => 'Zufällig';

  @override
  String get filterDefault => 'Standard';

  @override
  String get filterRating => 'Einstufung';

  @override
  String get filterSafe => 'Sicher';

  @override
  String get filterQuestionable => 'Fragwürdig';

  @override
  String get filterExplicit => 'Explizit';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterPool => 'Pool';

  @override
  String get filterHasPool => 'Hat Pool';

  @override
  String get filterChild => 'Untergeordnet';

  @override
  String get filterIsChildPost => 'Untergeordneter Beitrag';

  @override
  String get filterParent => 'Übergeordnet';

  @override
  String get filterIsParentPost => 'Übergeordneter Beitrag';

  @override
  String get filterUploadDate => 'Upload-Datum';

  @override
  String get filterLastDay => 'Letzter Tag';

  @override
  String get filterLastWeek => 'Letzte Woche';

  @override
  String get filterLastMonth => 'Letzter Monat';

  @override
  String get filterLastYear => 'Letztes Jahr';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterActive => 'Aktiv';

  @override
  String get filterPending => 'Ausstehend';

  @override
  String get filterDeleted => 'Gelöscht';

  @override
  String get filterFlagged => 'Markiert';

  @override
  String get filterAny => 'Beliebig';

  @override
  String get filterFileType => 'Dateityp';

  @override
  String get filterUploader => 'Uploader';

  @override
  String get filterWidth => 'Breite';

  @override
  String get filterHeight => 'Höhe';

  @override
  String get filterTagCount => 'Tag-Anzahl';

  @override
  String get filterTrue => 'Ja';

  @override
  String get filterFalse => 'Nein';

  @override
  String get filterImages => 'Bilder';

  @override
  String get filterVideos => 'Videos';

  @override
  String get filterTitleContains => 'Titel enthält';

  @override
  String get filterCategory => 'Kategorie';

  @override
  String get filterGeneral => 'Allgemein';

  @override
  String get filterSiteBugReports => 'Seiten-Bugberichte und Funktionswünsche';

  @override
  String get filterTagWikiProjects => 'Tag-/Wiki-Projekte und Fragen';

  @override
  String get filterTagAliasSuggestions => 'Tag-Alias- und Beziehungsvorschläge';

  @override
  String get filterArtTalk => 'Kunst-Diskussionen';

  @override
  String get filterOffTopic => 'Off-Topic';

  @override
  String get filterE621Tools => 'e621-Werkzeuge und Apps';

  @override
  String get filterNewestFirst => 'Neueste zuerst';

  @override
  String get filterOldestFirst => 'Älteste zuerst';

  @override
  String get filterSticky => 'Angepinnt';

  @override
  String get filterIsSticky => 'ist angepinnt';

  @override
  String get filterLocked => 'Gesperrt';

  @override
  String get filterIsLocked => 'ist gesperrt';

  @override
  String get filterDescription => 'Beschreibung';

  @override
  String get filterCreator => 'Ersteller';

  @override
  String get filterIsActive => 'ist aktiv';

  @override
  String get filterSeries => 'Serie';

  @override
  String get filterCollection => 'Sammlung';

  @override
  String get filterName => 'Name';

  @override
  String get filterCreated => 'Erstellt';

  @override
  String get filterUpdated => 'Aktualisiert';

  @override
  String get filterPostCount => 'Beitragsanzahl';

  @override
  String postUpdateFailed(num id) {
    return 'Beitrag #$id konnte nicht aktualisiert werden';
  }

  @override
  String postUpdated(num id) {
    return 'Beitrag #$id aktualisiert';
  }

  @override
  String get failedToLoadPost => 'Beitrag konnte nicht geladen werden';

  @override
  String get postNotFound => 'Beitrag nicht gefunden';

  @override
  String get commentsTitle => 'Kommentare';

  @override
  String commentsOfPost(num postId) {
    return 'Kommentare zu Beitrag #$postId';
  }

  @override
  String get commentOrder => 'Kommentar-Sortierung';

  @override
  String get noComments => 'Keine Kommentare';

  @override
  String get failedToLoadComments => 'Kommentare konnten nicht geladen werden';

  @override
  String commentTitle(num id) {
    return 'Kommentar #$id';
  }

  @override
  String get failedToLoadComment => 'Kommentar konnte nicht geladen werden';

  @override
  String get commentNotFound => 'Kommentar nicht gefunden';

  @override
  String commentEditorTitle(num postId) {
    return 'Kommentar zu Beitrag #$postId';
  }

  @override
  String get commentSendFailed => 'Kommentar konnte nicht gesendet werden!';

  @override
  String get commentSent => 'Kommentar gesendet!';

  @override
  String get commentHidden => 'Dieser Kommentar ist verborgen';

  @override
  String commentUpvoteFailed(num id) {
    return 'Kommentar #$id konnte nicht positiv bewertet werden';
  }

  @override
  String commentDownvoteFailed(num id) {
    return 'Kommentar #$id konnte nicht negativ bewertet werden';
  }

  @override
  String get commentLoginRequiredEdit =>
      'Zum Bearbeiten von Kommentaren musst du angemeldet sein!';

  @override
  String get commentLoginRequiredReply =>
      'Zum Antworten auf Kommentare musst du angemeldet sein!';

  @override
  String get commentLoginRequiredReport =>
      'Zum Melden von Kommentaren musst du angemeldet sein!';

  @override
  String commentCopiedId(num id) {
    return 'Kommentar-ID #$id kopiert';
  }

  @override
  String get warningUserWarned =>
      'Der Benutzer wurde für diese Nachricht verwarnt';

  @override
  String get warningUserRecorded =>
      'Für diese Nachricht wurde ein Vermerk beim Benutzer hinzugefügt';

  @override
  String get warningUserBanned =>
      'Der Benutzer wurde für diese Nachricht gesperrt';

  @override
  String get repliesTitle => 'Antworten';

  @override
  String get replyOrder => 'Antwort-Sortierung';

  @override
  String get noReplies => 'Keine Antworten';

  @override
  String get failedToLoadReplies => 'Antworten konnten nicht geladen werden';

  @override
  String replyTitle(num id) {
    return 'Antwort #$id';
  }

  @override
  String get failedToLoadReply => 'Antwort konnte nicht geladen werden';

  @override
  String get replyNotFound => 'Antwort nicht gefunden';

  @override
  String replyEditorTitle(num topicId) {
    return 'Antwort in Thema #$topicId';
  }

  @override
  String get replySendFailed => 'Antwort konnte nicht gesendet werden!';

  @override
  String get replySent => 'Antwort gesendet!';

  @override
  String get replyHidden => 'Diese Antwort ist verborgen';

  @override
  String get replyLoginRequiredEdit =>
      'Zum Bearbeiten von Antworten musst du angemeldet sein!';

  @override
  String get replyLoginRequiredReply =>
      'Zum Antworten musst du angemeldet sein!';

  @override
  String get replyLoginRequiredReport =>
      'Zum Melden von Antworten musst du angemeldet sein!';

  @override
  String replyCopiedId(num id) {
    return 'Antwort-ID #$id kopiert';
  }

  @override
  String get menuReply => 'Antworten';

  @override
  String get menuCopyId => 'ID kopieren';

  @override
  String get menuRefresh => 'Aktualisieren';

  @override
  String get actionCopy => 'Kopieren';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionShow => 'Anzeigen';

  @override
  String get actionHide => 'Verbergen';

  @override
  String get actionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get info => 'Info';

  @override
  String wikiTitle(String idOrTitle) {
    return 'Wiki $idOrTitle';
  }

  @override
  String get failedToLoadWiki => 'Wiki konnte nicht geladen werden';

  @override
  String get wikiNotFound => 'Wiki nicht gefunden';

  @override
  String wikiCopiedId(num id) {
    return 'Wiki-ID #$id kopiert';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => 'Alias';

  @override
  String get wikiInfoCreated => 'erstellt';

  @override
  String get wikiInfoUpdated => 'aktualisiert';

  @override
  String get wikiInfoLocked => 'gesperrt';

  @override
  String get wikiInfoYes => 'ja';

  @override
  String get wikiInfoNo => 'nein';

  @override
  String userTitle(String idOrName) {
    return 'Benutzer $idOrName';
  }

  @override
  String get failedToLoadUser => 'Benutzer konnte nicht geladen werden';

  @override
  String get userNotFound => 'Benutzer nicht gefunden';

  @override
  String get userUploads => 'Uploads';

  @override
  String get userLoginRequiredReport =>
      'Zum Melden von Benutzern musst du angemeldet sein!';

  @override
  String get userComission => 'Commission';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => 'Beigetreten';

  @override
  String get userRank => 'Rang';

  @override
  String get userPosts => 'Beiträge';

  @override
  String get userEdits => 'Bearbeitungen';

  @override
  String get userFavorites => 'Favoriten';

  @override
  String get userComments => 'Kommentare';

  @override
  String get userForum => 'Forum';

  @override
  String userCopiedId(num id) {
    return 'Benutzer-ID #$id kopiert';
  }

  @override
  String get logsTitle => 'Protokolle';

  @override
  String logsTitleDate(String date) {
    return 'Protokolle – $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Protokolleinträge',
      one: '1 Protokolleintrag',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Protokolldateien',
      one: '1 Protokolldatei',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => 'Stufen';

  @override
  String get logsRecording => 'Aufzeichnung';

  @override
  String get logsVerbose => 'Detailgrad';

  @override
  String get logsVerboseAll => 'alle Stufen aufzeichnen';

  @override
  String logsVerboseMinimum(String level) {
    return '$level und höher';
  }

  @override
  String get logFilesTitle => 'Protokolldateien';

  @override
  String get failedToLoadLogFiles =>
      'Protokolldateien konnten nicht geladen werden!';

  @override
  String get noLogFiles => 'Keine Protokolldateien verfügbar!';

  @override
  String get logsLive => 'Live';

  @override
  String get noLogs => 'Keine Protokolle';

  @override
  String get failedToReadLog => 'Protokoll konnte nicht gelesen werden';

  @override
  String get noErrorsLogged => 'Keine Fehler protokolliert';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fehler',
      one: '1 Fehler',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => 'Alle Protokolle';

  @override
  String get logsDismissAll => 'Alle verbergen';

  @override
  String logsDeleteTitle(num count) {
    return '$count Protokolldateien löschen?';
  }

  @override
  String get identityAccounts => 'Konten';

  @override
  String get identityAdd => 'Konto hinzufügen';

  @override
  String get identityEdit => 'Konto bearbeiten';

  @override
  String get identityRemoveTitle => 'Konto entfernen?';

  @override
  String get identityRemoveBody =>
      'Alle Daten dieses Kontos werden dauerhaft gelöscht, einschließlich Verlauf und Abos.';

  @override
  String get identityAnonymous => 'Anonym';

  @override
  String get identityDuplicate =>
      'Du hast bereits ein Konto mit dieser Seite und diesem Benutzernamen.';

  @override
  String identityLoginFailed(String reason) {
    return 'Anmeldung fehlgeschlagen.\n$reason';
  }

  @override
  String get identityLoginCheckDetails =>
      'Prüfe deine Netzwerkverbindung und Zugangsdaten';

  @override
  String get identitySite => 'Seite';

  @override
  String get identityHostRequired => 'Gib die URL der Seite ein.';

  @override
  String get identityHostInvalid => 'Ungültige Seiten-URL';

  @override
  String get identityHostReadOnly =>
      'Die Seite kann nicht geändert werden. Füge für eine andere Seite ein neues Konto hinzu.';

  @override
  String get identityUsernameLabel => 'Benutzername';

  @override
  String get identityUsernameRequired => 'Gib einen Benutzernamen ein.';

  @override
  String get identityApikeyLabel => 'API-Schlüssel';

  @override
  String get identityApikeyHelp => 'Wo finde ich meinen API-Schlüssel?';

  @override
  String get identityApikeyRequired =>
      'Gib den API-Schlüssel ein.\nz. B. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'Ein API-Schlüssel ist eine Folge aus 24 oder 32 Zeichen aus A-z und 0-9\nz. B. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => 'Noch kein Konto? Hier registrieren';

  @override
  String get identityHostHint =>
      'Die Seite, auf der sich dein Konto und deine Beiträge befinden.';

  @override
  String get identitySignIn => 'Anmelden';

  @override
  String get identityGuest => 'Gast';

  @override
  String get identityLogin => 'Anmelden';

  @override
  String get identityBrowseAnonymously => 'Anonym browsen';

  @override
  String identityConnecting(String host, String username) {
    return 'Verbinde mit $host als $username…';
  }

  @override
  String identityActivateFailed(Object error) {
    return 'Konto konnte nicht aktiviert werden: $error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return 'Einstellungen konnten nicht aktiviert werden: $error';
  }

  @override
  String get failedToLoadIdentities => 'Konten konnten nicht geladen werden';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String onboardingWelcomeTitle(String app) {
    return 'Willkommen bei $app';
  }

  @override
  String get onboardingWelcomeBody => 'Ein ausgereifter Booru-Browser.';

  @override
  String get onboardingThemeTitle => 'Wähle dein Design';

  @override
  String get onboardingThemeBody =>
      'Probiere es einfach aus. Du kannst es später jederzeit ändern.';

  @override
  String get onboardingLoginTitle => 'Konto verbinden';

  @override
  String get onboardingLanguageTitle => 'Sprache wählen';

  @override
  String get followAddToSubscriptions => 'Zu Abos hinzufügen';

  @override
  String get followNoSubscriptions => 'Keine Abos';

  @override
  String get followFailedToLoadSubscriptions =>
      'Abos konnten nicht geladen werden';

  @override
  String get followAddToBookmarks => 'Zu Lesezeichen hinzufügen';

  @override
  String get followNoBookmarks => 'Keine Lesezeichen';

  @override
  String get followFailedToLoadBookmarks =>
      'Lesezeichen konnten nicht geladen werden';

  @override
  String get followUnseenPosts => 'ungelesene Beiträge';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge als gelesen markieren',
      one: '1 Beitrag als gelesen markieren',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => 'keine ungelesenen Beiträge';

  @override
  String get followShowUnseenFirst => 'ungelesene zuerst';

  @override
  String get followFilteringUnseen => 'zeige nur ungelesene';

  @override
  String get followAllPostsShown => 'alle Beiträge werden angezeigt';

  @override
  String get followForceSync => 'Synchronisierung erzwingen';

  @override
  String get followSyncAllFollows => 'alle Abos synchronisieren';

  @override
  String followSyncingFollows(String progress) {
    return 'Abos werden synchronisiert… $progress';
  }

  @override
  String get followEditorTitle => 'Abo bearbeiten';

  @override
  String get followSubscribe => 'Abonnieren';

  @override
  String get followEditPrompt => 'Abo bearbeiten';

  @override
  String get followTitlePrompt => 'Abo-Name';

  @override
  String get followMarkAsRead => 'Als gelesen markieren';

  @override
  String get followDisableNotifications => 'Benachrichtigungen deaktivieren';

  @override
  String get followEnableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get followRename => 'Umbenennen';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label: $count neue Beiträge',
      one: '1 neuer Beitrag',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abos',
      one: '1 Abo',
    );
    return '$_temp0';
  }

  @override
  String followAlias(String? alias) {
    return 'Alias $alias';
  }

  @override
  String historySelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Verlaufseinträge gelöscht',
      one: 'Verlaufseintrag gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => 'Verlauf löschen';

  @override
  String get historyClearSubtitle => 'Alle Einträge entfernen';

  @override
  String get historyClearConfirm => 'Verlauf löschen?';

  @override
  String get historyClearConfirmBody =>
      'Alle Verlaufseinträge werden dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get historyClearAction => 'Löschen';

  @override
  String get historyLimit => 'Verlaufsbegrenzung';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return 'Bei aktivierter Begrenzung werden automatisch Einträge über $amount und älter als $months Monate gelöscht.';
  }

  @override
  String get historyLimitTitle => 'Verlauf begrenzen';

  @override
  String historyLimitOn(String amount, num months) {
    return 'Es werden Einträge der letzten $months Monate und maximal $amount Einträge gespeichert.';
  }

  @override
  String get historyLimitOff => 'Verlauf unbegrenzt';

  @override
  String get historyEntries => 'Einträge';

  @override
  String get historyType => 'Typ';

  @override
  String get historyItems => 'Objekte';

  @override
  String get historySearches => 'Suchen';

  @override
  String get historyWikis => 'Wikis';

  @override
  String get historyUsers => 'Benutzer';

  @override
  String get historyEmpty => 'Verlauf ist leer';

  @override
  String get historyFailedToLoad => 'Verlauf konnte nicht geladen werden';

  @override
  String get historyNoDescription => 'keine Beschreibung';

  @override
  String get historyHotPosts => 'Beliebte Beiträge';

  @override
  String historyLinkPost(num id) {
    return 'Beitrag #$id';
  }

  @override
  String historyLinkUser(num id) {
    return 'Benutzer #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return 'Wiki #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return 'Benutzer $id';
  }

  @override
  String historyLinkWikiByName(String id) {
    return 'Wiki $id';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type – $query';
  }

  @override
  String get historyWiki => 'Wiki';

  @override
  String get poolEmpty => 'Keine Pools';

  @override
  String get poolFailedToLoadPools => 'Pools konnten nicht geladen werden';

  @override
  String get poolTitle => 'Pool-Name';

  @override
  String get poolInfoPosts => 'Beiträge';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => 'Aktivität';

  @override
  String get poolInfoActive => 'aktiv';

  @override
  String get poolInfoInactive => 'inaktiv';

  @override
  String get poolInfoCreated => 'erstellt';

  @override
  String get poolInfoUpdated => 'aktualisiert';

  @override
  String poolCopiedId(num id) {
    return 'Pool-ID #$id kopiert';
  }

  @override
  String poolLink(num id) {
    return 'Pool #$id';
  }

  @override
  String get poolFailedToLoadPool => 'Pool konnte nicht geladen werden';

  @override
  String get poolNotFound => 'Pool nicht gefunden';

  @override
  String get poolOrder => 'Pool-Sortierung';

  @override
  String get poolOldestFirst => 'Älteste zuerst';

  @override
  String get poolNewestFirst => 'Neueste zuerst';

  @override
  String get poolReaderMode => 'Pool-Lesemodus';

  @override
  String get poolReaderLargeImages => 'große Bilder';

  @override
  String get poolReaderNormalGrid => 'normales Raster';

  @override
  String get topicsTitle => 'Themen';

  @override
  String get topicHideTagEdits => 'Tag-Bearbeitungen verbergen';

  @override
  String get topicTagEditsHidden => 'verborgen';

  @override
  String get topicTagEditsVisible => 'sichtbar';

  @override
  String topicLink(num id) {
    return 'Thema #$id';
  }

  @override
  String get topicFailedToLoadTopic => 'Thema konnte nicht geladen werden';

  @override
  String get topicNotFound => 'Thema nicht gefunden';

  @override
  String get topicEmpty => 'Keine Themen';

  @override
  String get topicFailedToLoadTopics => 'Themen konnten nicht geladen werden';

  @override
  String get topicInfoReplies => 'Antworten';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return 'Thema-ID #$id kopiert';
  }

  @override
  String get topicInfoLocked => 'gesperrt';

  @override
  String get topicInfoYes => 'ja';

  @override
  String get topicInfoNo => 'nein';

  @override
  String get topicInfoCreated => 'erstellt';

  @override
  String get topicInfoUpdated => 'aktualisiert';

  @override
  String get filterTags => 'Tags';

  @override
  String get loginRequired => 'Für diese Aktion musst du angemeldet sein.';

  @override
  String get actionChooseIdentity => 'Konto wählen';

  @override
  String get dateToday => 'Heute';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String detailCommentsButton(num count) {
    return 'Kommentare ($count)';
  }

  @override
  String get detailFile => 'Datei';

  @override
  String get detailSources => 'Quellen';

  @override
  String get detailNoSources => 'keine Quellen';

  @override
  String get detailChildren => 'Untergeordnete';

  @override
  String get detailDeletion => 'Löschgrund';

  @override
  String get detailBlacklisted => 'Auf der Blacklist';

  @override
  String get detailNoArtist => 'ohne Künstler';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Beiträge',
      one: '1 Beitrag',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return 'Beitrags-ID #$id kopiert';
  }

  @override
  String postUpvoteFailed(num id) {
    return 'Beitrag #$id konnte nicht positiv bewertet werden';
  }

  @override
  String postDownvoteFailed(num id) {
    return 'Beitrag #$id konnte nicht negativ bewertet werden';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return 'Beitrag #$id konnte nicht zu Favoriten hinzugefügt werden';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return 'Beitrag #$id konnte nicht aus Favoriten entfernt werden';
  }

  @override
  String get editorSection => 'Abschnitt';

  @override
  String get editorQuote => 'Zitat';

  @override
  String get editorCode => 'Code';

  @override
  String get editorSpoiler => 'Spoiler';

  @override
  String get editorBold => 'Fett';

  @override
  String get editorItalic => 'Kursiv';

  @override
  String get editorUnderlined => 'Unterstrichen';

  @override
  String get editorStrikethrough => 'Durchgestrichen';

  @override
  String get editorPreviewPlaceholder => 'Hier erscheint dein Text';

  @override
  String get editorWrite => 'Schreiben';

  @override
  String get editorPreview => 'Vorschau';

  @override
  String get editorTypeHere => 'Hier tippen…';

  @override
  String get tagNoTags => 'keine Tags';

  @override
  String get tagFailedToLoadTags => 'Tags konnten nicht geladen werden';

  @override
  String get tagUnableToRetrieveWiki => 'Wiki konnte nicht abgerufen werden';

  @override
  String get tagNoWikiEntry => 'kein Wiki-Eintrag';

  @override
  String get tagCategoryGeneral => 'Allgemein';

  @override
  String get tagCategorySpecies => 'Spezies';

  @override
  String get tagCategoryCharacter => 'Charakter';

  @override
  String get tagCategoryCopyright => 'Copyright';

  @override
  String get tagCategoryMeta => 'Meta';

  @override
  String get tagCategoryLore => 'Lore';

  @override
  String get tagCategoryArtist => 'Künstler';

  @override
  String get tagCategoryContributor => 'Beitragende';

  @override
  String get tagCategoryInvalid => 'Ungültig';

  @override
  String editDescriptionTitle(num postId) {
    return 'Beschreibung zu Beitrag #$postId';
  }

  @override
  String get editDescriptionHint => 'Beschreibung des Beitrags eingeben…';

  @override
  String get editInvalidNumber => 'Ungültiges Zahlenformat';

  @override
  String get editInvalidParent => 'Ungültiger übergeordneter Beitrag';

  @override
  String get editParentIdLabel => 'ID des übergeordneten Beitrags (optional)';

  @override
  String get editParentIdHint => 'ID des übergeordneten Beitrags';

  @override
  String get editReasonLabel => 'Grund der Bearbeitung (optional)';

  @override
  String get editReasonHint => 'Warum bearbeitest du diesen Beitrag?';

  @override
  String editSourcesTitle(num postId) {
    return 'Quellen zu Beitrag #$postId';
  }

  @override
  String get editTagsHint => 'Tags durch Leerzeichen getrennt';

  @override
  String editTagPreviewFailed(String error) {
    return 'Fehler beim Laden der Tag-Vorschau: $error';
  }

  @override
  String get editTagStatusNew => 'neu';

  @override
  String get editTagStatusInvalid => 'ungültig';

  @override
  String get editTagStatusEmpty => 'leer';

  @override
  String get editTagStatusUnderused => 'selten verwendet';

  @override
  String reportCommentSuccess(num id) {
    return 'Kommentar #$id gemeldet';
  }

  @override
  String reportCommentFailed(num id) {
    return 'Kommentar #$id konnte nicht gemeldet werden';
  }

  @override
  String reportReplySuccess(num id) {
    return 'Antwort #$id gemeldet';
  }

  @override
  String reportReplyFailed(num id) {
    return 'Antwort #$id konnte nicht gemeldet werden';
  }

  @override
  String reportUserSuccess(num id) {
    return 'Benutzer #$id gemeldet';
  }

  @override
  String reportUserFailed(num id) {
    return 'Benutzer #$id konnte nicht gemeldet werden';
  }

  @override
  String reportPostSuccess(num id) {
    return 'Beitrag #$id gemeldet';
  }

  @override
  String reportPostFailed(num id) {
    return 'Beitrag #$id konnte nicht gemeldet werden';
  }

  @override
  String get reportTypeRequired => 'Typ ist erforderlich';

  @override
  String get reportReason => 'Grund';

  @override
  String get reportReasonRequired => 'Grund ist erforderlich';

  @override
  String get reportSubmitted => 'Meldung gesendet';

  @override
  String get reportSubmitFailed => 'Meldung konnte nicht gesendet werden';

  @override
  String get reportTypeRating => 'Bewertungsmissbrauch';

  @override
  String get reportTypeFile => 'Bösartige Datei';

  @override
  String get reportTypeSource => 'Bösartige Quelle';

  @override
  String get reportTypeDescription => 'Beschreibungsmissbrauch';

  @override
  String get reportTypeNote => 'Anmerkungsmissbrauch';

  @override
  String get reportTypeTagging => 'Tag-Missbrauch';

  @override
  String get reportTypeRatingBody =>
      'Die Einstufung dieses Werks ist falsch angegeben.';

  @override
  String get reportTypeFileBody =>
      'Die Datei enthält bösartigen Code oder ein verstecktes Archiv. Es geht nicht um den Inhalt des Bildes selbst.';

  @override
  String get reportTypeSourceBody =>
      'Eine oder mehrere der angegebenen Quellen führen zu bösartigen Seiten oder kostenpflichtigen Inhalten.';

  @override
  String get reportTypeDescriptionBody =>
      'Die Beschreibung enthält bösartige Inhalte oder wurde mit beleidigenden Inhalten verändert.';

  @override
  String get reportTypeNoteBody =>
      'Die Anmerkungen zu diesem Beitrag sind falsch, beleidigend oder auf andere Weise unzulässig.';

  @override
  String get reportTypeTaggingBody =>
      'Ein oder mehrere Tags dieses Beitrags sind ungültig, oder gültige Tags wurden entfernt.';

  @override
  String flagPostSuccess(num id) {
    return 'Beitrag #$id markiert';
  }

  @override
  String flagPostFailed(num id) {
    return 'Beitrag #$id konnte nicht markiert werden';
  }

  @override
  String get flagParentId => 'ID des übergeordneten Beitrags';

  @override
  String get flagParentIdRequired =>
      'ID des übergeordneten Beitrags ist erforderlich';

  @override
  String get flagParentIdInvalid =>
      'Die ID des übergeordneten Beitrags muss eine Zahl sein';

  @override
  String get flagTypeUploadingGuidelines =>
      'Entspricht nicht den Upload-Richtlinien';

  @override
  String get flagTypeYoungHuman =>
      'Junge menschenähnliche Charaktere in expliziten Situationen';

  @override
  String get flagTypeDnpArtist =>
      'Der Künstler dieses Beitrags steht auf der Do-Not-Post-Liste';

  @override
  String get flagTypePayContent =>
      'Inhalte von Bezahlsites, kommerzielle oder Abo-Inhalte';

  @override
  String get flagTypeTrace =>
      'Nachzeichnung der Arbeit eines anderen Künstlers';

  @override
  String get flagTypePreviouslyDeleted => 'Zuvor gelöscht';

  @override
  String get flagTypeRealPorn => 'Pornografie mit echten Menschen';

  @override
  String get flagTypeCorrupt =>
      'Datei ist beschädigt, defekt oder funktioniert nicht';

  @override
  String get flagTypeInferior =>
      'Duplikat oder schlechtere Version eines anderen Beitrags';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      'Dieser Beitrag erfüllt die Standards der Seite nicht, sei es künstlerischer Wert, Bildqualität, Relevanz oder anderes.\nPersönliche Vorlieben spielen hier keine Rolle. Wenn dir der Inhalt nicht gefällt, nutze die [[e621:blacklist|Blacklist]].';

  @override
  String get flagTypeYoungHumanBody =>
      'Beiträge mit menschlichen oder menschenähnlichen Charakteren in sexueller oder explizit nackter Darstellung sind auf dieser Seite nicht zulässig.';

  @override
  String get flagTypeDnpArtistBody =>
      'Manche Künstler haben untersagt, ihre Arbeiten hier zu veröffentlichen, und den Status [[avoid_posting|Do Not Post]] erhalten.\nDieser Status kann mit Bedingungen verbunden sein; mehr dazu unter [[conditional_dnp]]';

  @override
  String get flagTypePayContentBody =>
      'Wir hosten keinerlei Inhalte von Bezahlsites oder kommerzielle Inhalte. Das schließt Patreon-Leaks und Reposts von Piratenseiten ein.';

  @override
  String get flagTypeTraceBody =>
      'Nachzeichnungen der Arbeiten anderer Künstler sind hier nicht zulässig. Sich von etwas inspirieren zu lassen ist in Ordnung, das direkte Kopieren einer fremden Arbeit jedoch nicht.\nHinterlasse bitte weitere Informationen in den Kommentaren oder setze das Original als übergeordneten Beitrag, falls es auf dieser Seite existiert.';

  @override
  String get flagTypePreviouslyDeletedBody =>
      'Beiträge werden normalerweise aus gutem Grund gelöscht, und das erneute Hochladen gelöschter Inhalte ist unzulässig.\nHinterlasse bitte weitere Informationen in den Kommentaren oder setze den Originalbeitrag als übergeordneten für diesen.';

  @override
  String get flagTypeRealPornBody =>
      'Beiträge mit Pornografie echter Menschen sind auf dieser Seite grundsätzlich nicht zulässig. Keine Ausnahmen.\nBeachte, dass Bilder mit nicht-erotischen echten Fotografien zulässig sind.';

  @override
  String get flagTypeCorruptBody =>
      'Mit diesem Beitrag stimmt etwas nicht. Es kann ein kaputtes Video oder ein beschädigtes Bild sein.\nBeschreibe die Situation bitte in den Kommentaren, um Verwirrung zu vermeiden.';

  @override
  String get flagTypeInferiorBody =>
      'Eine bessere Version dieses Beitrags existiert bereits auf der Seite.\nDas umfasst Bilder höherer Qualität (größer, weniger Kompression), aber auch „korrigierte“ Versionen, in denen der Künstler visuelle Fehler behoben hat.\nBeachte, dass Bearbeitungen und alternative Versionen nicht in diese Kategorie fallen.';

  @override
  String get taskCancelAll => 'Alle abbrechen';

  @override
  String get taskClearDone => 'Fertige entfernen';

  @override
  String get taskClearSelection => 'Auswahl aufheben';

  @override
  String get taskCancel => 'Abbrechen';

  @override
  String get taskDismiss => 'Ausblenden';

  @override
  String get taskNoTasks => 'Keine Aufgaben';

  @override
  String get taskFailedToLoadTasks => 'Aufgaben konnten nicht geladen werden';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => 'Aktiv';

  @override
  String get taskGroupFailed => 'Fehlgeschlagen';

  @override
  String get taskActionDownload => 'Herunterladen';

  @override
  String get taskActionFavorite => 'Favorisieren';

  @override
  String get taskActionUnfavorite => 'Entfavorisieren';

  @override
  String get taskDownloadRunning => 'wird heruntergeladen';

  @override
  String get taskFavoriteRunning => 'wird favorisiert';

  @override
  String get taskUnfavoriteRunning => 'wird aus Favoriten entfernt';

  @override
  String get taskDownloadCompleted => 'heruntergeladen';

  @override
  String get taskFavoriteCompleted => 'favorisiert';

  @override
  String get taskUnfavoriteCompleted => 'aus Favoriten entfernt';

  @override
  String taskQueuedTo(String action) {
    return 'wartet auf $action';
  }

  @override
  String taskFailedTo(String action) {
    return '$action fehlgeschlagen';
  }

  @override
  String taskCanceledAction(String action) {
    return '$action abgebrochen';
  }

  @override
  String taskTileTitle(String label, num id) {
    return 'Beitrag #$id: $label';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Beiträge!',
      one: '1 neuer Beitrag!',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => 'Neue Beiträge!';

  @override
  String get followChannelName => 'Tag-Abos';

  @override
  String get followChannelDescription =>
      'Benachrichtigungen über abonnierte Tags';

  @override
  String get hostUnavailableTitle => 'Seite nicht erreichbar';

  @override
  String hostUnavailableBody(String host) {
    return '$host scheint nicht erreichbar zu sein!';
  }

  @override
  String get hostUnavailableResolveHint =>
      'Löse das Problem im sich öffnenden Browserfenster.\n\nDas CAPTCHA-Cookie von Cloudflare wird gespeichert.';

  @override
  String get hostUnavailableResolve => 'Lösen';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\nBitte warte, bis $host das Problem auf seiner Seite löst.';
  }

  @override
  String get downloadChooseFolder => 'Ordner wählen';

  @override
  String get searchFilterTitle => 'Filter';

  @override
  String get searchFilterQueryLabel => 'Aktuelle Suche:';

  @override
  String get dtextParsingFailed => 'DText konnte nicht geparst werden';
}
