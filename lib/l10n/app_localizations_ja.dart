// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => '読み込めませんでした';

  @override
  String get nothingToSeeHere => '何もありません';

  @override
  String get loading => '読み込み中…';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionOk => 'OK';

  @override
  String get actionTryAgain => '再試行';

  @override
  String get actionDownload => 'ダウンロード';

  @override
  String get actionImport => 'インポート';

  @override
  String get actionExport => 'エクスポート';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionRestartNow => '今すぐ再起動';

  @override
  String get failedToLoadSuggestions => '候補の読み込みに失敗しました';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => '中止';

  @override
  String get actionSelectAll => 'すべて選択';

  @override
  String fileSavedAs(String name) {
    return 'ファイルを $name として保存しました';
  }

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get saveFile => 'ファイルを保存';

  @override
  String get filterTooltip => 'フィルター';

  @override
  String get rangeInvalidFormat => '形式が無効です';

  @override
  String itemProgress(num current, num total) {
    return 'アイテム $current/$total';
  }

  @override
  String get taskCancelled => 'タスクをキャンセルしました';

  @override
  String taskFailedAt(num index) {
    return 'アイテム $index で失敗しました';
  }

  @override
  String get taskDone => '完了';

  @override
  String get failedToInitialize => '初期化に失敗しました';

  @override
  String get navHome => 'ホーム';

  @override
  String get navHot => '人気';

  @override
  String get navSearch => '検索';

  @override
  String get navFavorites => 'お気に入り';

  @override
  String get navTimeline => 'タイムライン';

  @override
  String get navSubscriptions => 'フォロー';

  @override
  String get navBookmarks => 'ブックマーク';

  @override
  String get navPools => 'プール';

  @override
  String get navForum => 'フォーラム';

  @override
  String get navHistory => '履歴';

  @override
  String get navTasks => 'タスク';

  @override
  String get navSettings => '設定';

  @override
  String get navAbout => 'アプリ情報';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionAccount => 'アカウント';

  @override
  String get sectionUser => 'ユーザー';

  @override
  String get sectionAppearance => '外観';

  @override
  String get sectionInteractions => '操作';

  @override
  String get sectionSecurity => 'セキュリティ';

  @override
  String get sectionDevelopment => '開発';

  @override
  String get settingsBlacklist => 'ブラックリスト';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のタグをブロック中',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => 'フォロー';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の検索をフォロー中',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => '履歴';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ページを閲覧済み',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeBlue => 'ブルー';

  @override
  String get themeSystem => 'システムに従う';

  @override
  String get settingsLanguage => '言語';

  @override
  String get languageSystemDefault => 'システムに従う';

  @override
  String get settingsTileSize => 'タイルのサイズ';

  @override
  String get settingsQuilt => 'グリッド形式';

  @override
  String get gridTitle => 'グリッド';

  @override
  String get quiltSquare => '正方形のタイル';

  @override
  String get quiltVertical => '縦に伸びるタイル';

  @override
  String get settingsPostInfo => '投稿の情報';

  @override
  String get postInfoShown => 'タイルに情報を表示';

  @override
  String get postInfoHidden => '画像のみ表示';

  @override
  String get settingsDownloadLocation => 'ダウンロード先';

  @override
  String get settingsUpvoteFavorites => 'お気に入りに高評価';

  @override
  String get upvoteFavoritesOn => '高評価してお気に入りに追加';

  @override
  String get upvoteFavoritesOff => 'お気に入りのみ';

  @override
  String get settingsVideoVolume => '動画の音量';

  @override
  String get videoMuted => 'ミュート';

  @override
  String get videoWithSound => '音声あり';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get settingsVideoResolution => '動画の解像度';

  @override
  String get videoResStandard => '標準 (480p)';

  @override
  String get videoResHigh => '高画質 (720p)';

  @override
  String get videoResFull => 'フルHD (1080p)';

  @override
  String get videoResUltra => 'ウルトラ (4K)';

  @override
  String get videoResSource => 'オリジナル';

  @override
  String get settingsSecureDisplay => '画面の保護';

  @override
  String get secureDisplayOn => '画面を保護';

  @override
  String get secureDisplayOff => '画面を保護しない';

  @override
  String get settingsIncognitoKeyboard => 'シークレットキーボード';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get settingsPinLock => 'PIN ロック';

  @override
  String get pinEnabled => 'PIN 有効';

  @override
  String get pinDisabled => 'PIN 無効';

  @override
  String get settingsBiometricLock => '生体認証ロック';

  @override
  String get biometricsEnabled => '生体認証 有効';

  @override
  String get biometricsDisabled => '生体認証 無効';

  @override
  String get settingsDeveloperMode => '開発者モード';

  @override
  String get devOptionsShown => 'オプションを表示';

  @override
  String get devOptionsHidden => 'オプションを非表示';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のエラーを記録',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => 'データベース';

  @override
  String get databaseExporting => 'データベースをエクスポートしています…';

  @override
  String get databaseExported => 'データベースをエクスポートしました';

  @override
  String get databaseExportFailed => 'エクスポートに失敗しました';

  @override
  String get databaseExport => 'エクスポート';

  @override
  String get databaseImporting => 'データベースをインポートしています…';

  @override
  String databaseInvalidFile(String error) {
    return '無効なデータベースファイルです：$error';
  }

  @override
  String databaseImportFailed(String error) {
    return 'インポートに失敗しました：$error';
  }

  @override
  String get databaseImportTitle => 'データベースのインポート';

  @override
  String get databaseRestartTitle => '再起動が必要です';

  @override
  String get databaseRestartBody => '変更を適用するにはアプリを再起動する必要があります。';

  @override
  String get databaseImport => 'インポート';

  @override
  String get lockEnterPin => 'PIN を入力';

  @override
  String get lockEnterNewPin => '新しい PIN を入力';

  @override
  String get lockConfirmNewPin => '新しい PIN を確認';

  @override
  String get lockFailedAuth => '認証に失敗しました';

  @override
  String get lockPleaseAuth => '認証してください';

  @override
  String get lockRetry => '再試行';

  @override
  String get lockBiometricReason => 'ロックを解除するには認証してください。';

  @override
  String get lockBiometricFailure => '生体認証で重大なエラーが発生しました';

  @override
  String get aboutVersion => 'バージョン';

  @override
  String get updaterFetching => '更新を確認しています…';

  @override
  String get updaterCheckFailed => '更新の確認に失敗しました';

  @override
  String get updaterNewest => '最新バージョンです';

  @override
  String updaterNewer(String version) {
    return '新しいバージョンがあります：$version';
  }

  @override
  String get updaterNewerHeader => '新しいバージョンがあります：';

  @override
  String get aboutExperimentalPlatform => '実験的なプラットフォーム';

  @override
  String get aboutExperimentalBody =>
      'このプラットフォームはサポートされていません。不具合や機能の不足が発生する可能性があります。';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => 'アップストリーム';

  @override
  String get aboutUpstreamBody => '本アプリは clragon/e1547 のフォークです';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => 'フォーラム';

  @override
  String aboutForumTopic(num id) {
    return 'e621 トピック #$id';
  }

  @override
  String get aboutWebsite => 'ウェブサイト';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => 'メール';

  @override
  String get aboutPlaystore => 'Play ストア';

  @override
  String get aboutDonors => '支援者';

  @override
  String get aboutDonorsThanks => '開発を続けられるのは皆さんのおかげです。ありがとうございます！';

  @override
  String get aboutNoDonors => 'まだ支援者がいません';

  @override
  String get aboutDonorsFailed => '支援者の取得に失敗しました';

  @override
  String get aboutDonorsNotListed => 'リストに載っていませんか？ご連絡ください！';

  @override
  String get developerUnlocked => 'あなたは開発者になりました！';

  @override
  String get databaseErrorLoading => 'データベースの読み込みエラー';

  @override
  String get databaseUnknownSize => '不明';

  @override
  String get databaseExportTitle => 'データベースのエクスポート';

  @override
  String get databaseExportSubtitle => 'データベースのバックアップを保存';

  @override
  String get databaseImportSubtitle => 'インポートした内容で現在のデータベースを置き換えます';

  @override
  String get databaseImportWarning =>
      '現在のデータベースが置き換えられます。\nすべてのデータが失われ、元に戻せません！';

  @override
  String get databaseExportSanitizedBody =>
      'エクスポートされたファイルにログイン情報と API キーは含まれません。\nアカウント、サイト、履歴、フォロー、タスクなどのその他のデータは含まれます。';

  @override
  String get databaseImportNewerFile =>
      'このファイルは新しいバージョンのアプリで作成されたため、インポートできません。';

  @override
  String get databaseImportSanitized =>
      '安全のため、インポートされたファイルから保存されたログイン情報を削除しました。';

  @override
  String databaseImportHostsWarning(String hosts) {
    return '警告：インポートされたファイルには他のサイトのアカウントが含まれています：$hosts';
  }

  @override
  String get databaseImportCancelled => 'インポートをキャンセルしました';

  @override
  String get postsTitle => '投稿';

  @override
  String favoritesOf(String user) {
    return '$user のお気に入り';
  }

  @override
  String get favoritesUnavailable => '未ログインではお気に入りを利用できません';

  @override
  String get favoriteOrder => 'お気に入りの並び順';

  @override
  String get orderAdded => '追加順';

  @override
  String get orderId => 'ID 順';

  @override
  String get postStateDeleted => '削除済み';

  @override
  String get postStateUnsupported => '未対応';

  @override
  String get postStateUnavailable => '利用不可';

  @override
  String get menuShare => '共有';

  @override
  String get menuDownload => 'ダウンロード';

  @override
  String get menuBrowse => 'ブラウザで開く';

  @override
  String get menuEdit => '編集';

  @override
  String get menuComment => 'コメント';

  @override
  String get menuReport => '通報';

  @override
  String get menuFlag => 'フラグ';

  @override
  String get actionOpen => '開く';

  @override
  String get actionFollow => 'フォロー';

  @override
  String get actionUnfollow => 'フォロー解除';

  @override
  String get actionMute => 'ミュート';

  @override
  String get actionNotify => '通知';

  @override
  String get actionBookmark => 'ブックマークに追加';

  @override
  String get actionUnbookmark => 'ブックマーク解除';

  @override
  String get actionBlock => 'ブロック';

  @override
  String get actionUnblock => 'ブロック解除';

  @override
  String get actionRemove => '削除';

  @override
  String get actionAdd => '追加';

  @override
  String get actionSubtract => '除外';

  @override
  String selectionPost(num id) {
    return '投稿 #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の投稿',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => '投稿がありません';

  @override
  String get failedToLoadPosts => '投稿を読み込めませんでした';

  @override
  String get offlineBanner => 'オフラインのため、キャッシュされたデータを表示しています。';

  @override
  String get offlineNoData => 'オフラインです';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の投稿',
    );
    return '$page ページ目・$_temp0';
  }

  @override
  String get postListPageLimit => 'サーバーのページ数上限に達しました。検索条件を絞ってください。';

  @override
  String get postListJumpToPage => 'ページに移動';

  @override
  String get postListJumpPageLabel => 'ページ番号';

  @override
  String postListJumpPageRange(Object max) {
    return '1～$max のページ番号を入力してください';
  }

  @override
  String get postDeletedOverlay => '削除された投稿です';

  @override
  String get postUnavailableOverlay => '利用できない投稿です';

  @override
  String get postBlacklistedOverlay => 'ブラックリストに登録された投稿です';

  @override
  String unsupportedFileType(String ext) {
    return '$ext ファイルは未対応です';
  }

  @override
  String get loginRequiredEdit => '投稿を編集するにはログインが必要です！';

  @override
  String get loginRequiredComment => 'コメントするにはログインが必要です！';

  @override
  String get loginRequiredReport => '投稿を通報するにはログインが必要です！';

  @override
  String get loginRequiredFlag => '投稿にフラグを付けるにはログインが必要です！';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の投稿をブロック中',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => 'ブラックリストの更新に失敗しました！';

  @override
  String get blacklistAddTag => 'タグを追加';

  @override
  String get blacklistEditTag => 'タグを編集';

  @override
  String get denylistEntryDeleted => 'ブラックリストの項目を削除しました';

  @override
  String get blacklistEmpty => 'ブラックリストは空です';

  @override
  String get menuDelete => '削除';

  @override
  String get filterScore => 'スコア';

  @override
  String get filterFavoriteCount => 'お気に入り数';

  @override
  String get filterSortBy => '並び順';

  @override
  String get filterNew => '新着';

  @override
  String get filterRank => '順位';

  @override
  String get filterRandom => 'ランダム';

  @override
  String get filterDefault => 'デフォルト';

  @override
  String get filterRating => 'レーティング';

  @override
  String get filterSafe => 'セーフ';

  @override
  String get filterQuestionable => 'クエスチョナブル';

  @override
  String get filterExplicit => 'エクスプリシット';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterPool => 'プール';

  @override
  String get filterHasPool => 'プールあり';

  @override
  String get filterChild => '子投稿';

  @override
  String get filterIsChildPost => '子投稿';

  @override
  String get filterParent => '親投稿';

  @override
  String get filterIsParentPost => '親投稿';

  @override
  String get filterUploadDate => 'アップロード日';

  @override
  String get filterLastDay => '過去24時間';

  @override
  String get filterLastWeek => '過去1週間';

  @override
  String get filterLastMonth => '過去1か月';

  @override
  String get filterLastYear => '過去1年';

  @override
  String get filterStatus => '状態';

  @override
  String get filterActive => 'アクティブ';

  @override
  String get filterPending => '承認待ち';

  @override
  String get filterDeleted => '削除済み';

  @override
  String get filterFlagged => 'フラグ済み';

  @override
  String get filterAny => '指定なし';

  @override
  String get filterFileType => 'ファイル形式';

  @override
  String get filterUploader => '投稿者';

  @override
  String get filterWidth => '幅';

  @override
  String get filterHeight => '高さ';

  @override
  String get filterTagCount => 'タグ数';

  @override
  String get filterTrue => 'はい';

  @override
  String get filterFalse => 'いいえ';

  @override
  String get filterImages => '画像';

  @override
  String get filterVideos => '動画';

  @override
  String get filterTitleContains => 'タイトルに含む';

  @override
  String get filterCategory => 'カテゴリ';

  @override
  String get filterGeneral => '全般';

  @override
  String get filterSiteBugReports => 'サイトのバグ報告と機能リクエスト';

  @override
  String get filterTagWikiProjects => 'タグ/Wiki プロジェクトと質問';

  @override
  String get filterTagAliasSuggestions => 'タグの別名と関連の提案';

  @override
  String get filterArtTalk => 'アート談義';

  @override
  String get filterOffTopic => '雑談';

  @override
  String get filterE621Tools => 'e621 ツールとアプリ';

  @override
  String get filterNewestFirst => '新しい順';

  @override
  String get filterOldestFirst => '古い順';

  @override
  String get filterSticky => '固定';

  @override
  String get filterIsSticky => '固定済み';

  @override
  String get filterLocked => 'ロック';

  @override
  String get filterIsLocked => 'ロック済み';

  @override
  String get filterDescription => '説明';

  @override
  String get filterCreator => '作成者';

  @override
  String get filterIsActive => 'アクティブ';

  @override
  String get filterSeries => 'シリーズ';

  @override
  String get filterCollection => 'コレクション';

  @override
  String get filterName => '名前';

  @override
  String get filterCreated => '作成日';

  @override
  String get filterUpdated => '更新日';

  @override
  String get filterPostCount => '投稿数';

  @override
  String postUpdateFailed(num id) {
    return '投稿 #$id の更新に失敗しました';
  }

  @override
  String postUpdated(num id) {
    return '投稿 #$id を更新しました';
  }

  @override
  String get failedToLoadPost => '投稿を読み込めませんでした';

  @override
  String get postNotFound => '投稿が見つかりません';

  @override
  String get commentsTitle => 'コメント';

  @override
  String commentsOfPost(num postId) {
    return '投稿 #$postId のコメント';
  }

  @override
  String get commentOrder => 'コメントの並び順';

  @override
  String get noComments => 'コメントがありません';

  @override
  String get failedToLoadComments => 'コメントを読み込めませんでした';

  @override
  String commentTitle(num id) {
    return 'コメント #$id';
  }

  @override
  String get failedToLoadComment => 'コメントを読み込めませんでした';

  @override
  String get commentNotFound => 'コメントが見つかりません';

  @override
  String commentEditorTitle(num postId) {
    return '投稿 #$postId のコメント';
  }

  @override
  String get commentSendFailed => 'コメントの送信に失敗しました！';

  @override
  String get commentSent => 'コメントを送信しました！';

  @override
  String get commentHidden => 'このコメントは非表示です';

  @override
  String commentUpvoteFailed(num id) {
    return 'コメント #$id を高評価できませんでした';
  }

  @override
  String commentDownvoteFailed(num id) {
    return 'コメント #$id を低評価できませんでした';
  }

  @override
  String get commentLoginRequiredEdit => 'コメントを編集するにはログインが必要です！';

  @override
  String get commentLoginRequiredReply => 'コメントに返信するにはログインが必要です！';

  @override
  String get commentLoginRequiredReport => 'コメントを通報するにはログインが必要です！';

  @override
  String commentCopiedId(num id) {
    return 'コメント ID #$id をコピーしました';
  }

  @override
  String get warningUserWarned => 'このメッセージにより、ユーザーは警告を受けました';

  @override
  String get warningUserRecorded => 'このメッセージにより、ユーザーに記録が残りました';

  @override
  String get warningUserBanned => 'このメッセージにより、ユーザーは BAN されました';

  @override
  String get repliesTitle => '返信';

  @override
  String get replyOrder => '返信の並び順';

  @override
  String get noReplies => '返信がありません';

  @override
  String get failedToLoadReplies => '返信を読み込めませんでした';

  @override
  String replyTitle(num id) {
    return '返信 #$id';
  }

  @override
  String get failedToLoadReply => '返信を読み込めませんでした';

  @override
  String get replyNotFound => '返信が見つかりません';

  @override
  String replyEditorTitle(num topicId) {
    return 'トピック #$topicId の返信';
  }

  @override
  String get replySendFailed => '返信の送信に失敗しました！';

  @override
  String get replySent => '返信を送信しました！';

  @override
  String get replyHidden => 'この返信は非表示です';

  @override
  String get replyLoginRequiredEdit => '返信を編集するにはログインが必要です！';

  @override
  String get replyLoginRequiredReply => '返信するにはログインが必要です！';

  @override
  String get replyLoginRequiredReport => '返信を通報するにはログインが必要です！';

  @override
  String replyCopiedId(num id) {
    return '返信 ID #$id をコピーしました';
  }

  @override
  String get menuReply => '返信';

  @override
  String get menuCopyId => 'ID をコピー';

  @override
  String get menuRefresh => '更新';

  @override
  String get actionCopy => 'コピー';

  @override
  String get actionSave => '保存';

  @override
  String get actionShow => '表示';

  @override
  String get actionHide => '非表示';

  @override
  String get actionCannotBeUndone => 'この操作は元に戻せません。';

  @override
  String get info => '情報';

  @override
  String wikiTitle(String idOrTitle) {
    return 'Wiki $idOrTitle';
  }

  @override
  String get failedToLoadWiki => 'Wiki を読み込めませんでした';

  @override
  String get wikiNotFound => 'Wiki が見つかりません';

  @override
  String wikiCopiedId(num id) {
    return 'Wiki ID #$id をコピーしました';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => '別名';

  @override
  String get wikiInfoCreated => '作成日時';

  @override
  String get wikiInfoUpdated => '更新日時';

  @override
  String get wikiInfoLocked => 'ロック';

  @override
  String get wikiInfoYes => 'はい';

  @override
  String get wikiInfoNo => 'いいえ';

  @override
  String userTitle(String idOrName) {
    return 'ユーザー $idOrName';
  }

  @override
  String get failedToLoadUser => 'ユーザーを読み込めませんでした';

  @override
  String get userNotFound => 'ユーザーが見つかりません';

  @override
  String get userUploads => 'アップロード';

  @override
  String get userLoginRequiredReport => 'ユーザーを通報するにはログインが必要です！';

  @override
  String get userComission => 'コミッション';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => '登録日';

  @override
  String get userRank => 'ランク';

  @override
  String get userPosts => '投稿';

  @override
  String get userEdits => '編集';

  @override
  String get userFavorites => 'お気に入り';

  @override
  String get userComments => 'コメント';

  @override
  String get userForum => 'フォーラム';

  @override
  String userCopiedId(num id) {
    return 'ユーザー ID #$id をコピーしました';
  }

  @override
  String get logsTitle => 'ログ';

  @override
  String logsTitleDate(String date) {
    return 'ログ - $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のログ',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個のログファイル',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => 'レベル';

  @override
  String get logsRecording => '記録';

  @override
  String get logsVerbose => '記録レベル';

  @override
  String get logsVerboseAll => 'すべてのレベルを記録';

  @override
  String logsVerboseMinimum(String level) {
    return '$level 以上';
  }

  @override
  String get logFilesTitle => 'ログファイル';

  @override
  String get failedToLoadLogFiles => 'ログファイルを読み込めませんでした！';

  @override
  String get noLogFiles => '利用可能なログファイルがありません！';

  @override
  String get logsLive => 'リアルタイム';

  @override
  String get noLogs => 'ログがありません';

  @override
  String get failedToReadLog => 'ログの読み取りに失敗しました';

  @override
  String get noErrorsLogged => '記録されたエラーはありません';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のエラー',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => 'すべてのログ';

  @override
  String get logsDismissAll => 'すべて閉じる';

  @override
  String logsDeleteTitle(num count) {
    return '$count 個のログファイルを削除しますか？';
  }

  @override
  String get identityAccounts => 'アカウント';

  @override
  String get identityAdd => 'アカウントを追加';

  @override
  String get identityEdit => 'アカウントを編集';

  @override
  String get identityRemoveTitle => 'アカウントを削除しますか？';

  @override
  String get identityRemoveBody => 'このアカウントのすべてのデータ（履歴やフォローを含む）が完全に削除されます。';

  @override
  String get identityAnonymous => '匿名';

  @override
  String get identityDuplicate => 'このサイトとユーザー名のアカウントはすでに存在します。';

  @override
  String identityLoginFailed(String reason) {
    return 'ログインに失敗しました。\n$reason';
  }

  @override
  String get identityLoginCheckDetails => 'ネットワーク接続とログイン情報を確認してください';

  @override
  String get identitySite => 'サイト';

  @override
  String get identityHostRequired => 'サイトの URL を入力してください。';

  @override
  String get identityHostInvalid => '無効なサイト URL です';

  @override
  String get identityHostReadOnly =>
      'サイトは変更できません。別のサイトを使うには、新しいアカウントを追加してください。';

  @override
  String get identityUsernameLabel => 'ユーザー名';

  @override
  String get identityUsernameRequired => 'ユーザー名を入力してください。';

  @override
  String get identityApikeyLabel => 'API キー';

  @override
  String get identityApikeyHelp => 'API キーはどこで確認できますか？';

  @override
  String get identityApikeyRequired =>
      'API キーを入力してください。\n例：1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'API キーは A-z と 0-9 の文字で構成される 24 文字または 32 文字の列です\n例：1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => 'アカウントをお持ちでないですか？こちらから登録できます';

  @override
  String get identityHostHint => 'あなたのアカウントと投稿があるサイトです。';

  @override
  String get identitySignIn => 'ログイン';

  @override
  String get identityGuest => 'ゲスト';

  @override
  String get identityLogin => 'ログイン';

  @override
  String get identityBrowseAnonymously => '匿名で閲覧';

  @override
  String identityConnecting(String host, String username) {
    return '$username として $host に接続しています…';
  }

  @override
  String identityActivateFailed(Object error) {
    return 'アカウントの有効化に失敗しました：$error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return '特性の有効化に失敗しました：$error';
  }

  @override
  String get failedToLoadIdentities => 'アカウントを読み込めませんでした';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingNext => '次へ';

  @override
  String onboardingWelcomeTitle(String app) {
    return '$app へようこそ';
  }

  @override
  String get onboardingWelcomeBody => '洗練された booru ブラウザー。';

  @override
  String get onboardingThemeTitle => '見た目を選びましょう';

  @override
  String get onboardingThemeBody => 'まずは試してみてください。あとでいつでも変更できます。';

  @override
  String get onboardingLoginTitle => 'アカウントを接続';

  @override
  String get onboardingLanguageTitle => '言語を選択';

  @override
  String get followAddToSubscriptions => 'フォローに追加';

  @override
  String get followNoSubscriptions => 'フォローはありません';

  @override
  String get followFailedToLoadSubscriptions => 'フォローを読み込めませんでした';

  @override
  String get followAddToBookmarks => 'ブックマークに追加';

  @override
  String get followNoBookmarks => 'ブックマークはありません';

  @override
  String get followFailedToLoadBookmarks => 'ブックマークを読み込めませんでした';

  @override
  String get followUnseenPosts => '未読の投稿';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の投稿を既読にする',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => '未読なし';

  @override
  String get followShowUnseenFirst => '未読を優先表示';

  @override
  String get followFilteringUnseen => '未読のみ表示中';

  @override
  String get followAllPostsShown => 'すべての投稿を表示中';

  @override
  String get followForceSync => '強制同期';

  @override
  String get followSyncAllFollows => 'すべてのフォローを同期';

  @override
  String followSyncingFollows(String progress) {
    return 'フォローを同期しています… $progress';
  }

  @override
  String get followEditorTitle => 'フォローを編集';

  @override
  String get followSubscribe => 'フォローする';

  @override
  String get followEditPrompt => 'フォローを編集';

  @override
  String get followTitlePrompt => 'フォロー名';

  @override
  String get followMarkAsRead => '既読にする';

  @override
  String get followDisableNotifications => '通知をオフにする';

  @override
  String get followEnableNotifications => '通知をオンにする';

  @override
  String get followRename => '名前を変更';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label 件の新着投稿',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のフォロー',
    );
    return '$_temp0';
  }

  @override
  String followAlias(String? alias) {
    return '別名 $alias';
  }

  @override
  String historySelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の項目',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '履歴 $count 件を削除しました',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => '履歴を消去';

  @override
  String get historyClearSubtitle => 'すべてのエントリを削除';

  @override
  String get historyClearConfirm => '履歴を消去しますか？';

  @override
  String get historyClearConfirmBody => 'すべての履歴が完全に削除されます。この操作は元に戻せません。';

  @override
  String get historyClearAction => '消去';

  @override
  String get historyLimit => '履歴の上限';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return '履歴の上限を有効にすると、$amount 件を超える項目と $months か月より古い項目は自動的に削除されます。';
  }

  @override
  String get historyLimitTitle => '履歴を制限';

  @override
  String historyLimitOn(String amount, num months) {
    return '$months か月以内かつ $amount 件までの項目に制限されています。';
  }

  @override
  String get historyLimitOff => '履歴は無制限';

  @override
  String get historyEntries => '項目';

  @override
  String get historyType => '種類';

  @override
  String get historyItems => '閲覧';

  @override
  String get historySearches => '検索';

  @override
  String get historyWikis => 'Wiki';

  @override
  String get historyUsers => 'ユーザー';

  @override
  String get historyEmpty => '履歴は空です';

  @override
  String get historyFailedToLoad => '履歴を読み込めませんでした';

  @override
  String get historyNoDescription => '説明なし';

  @override
  String get historyHotPosts => '人気投稿';

  @override
  String historyLinkPost(num id) {
    return '投稿 #$id';
  }

  @override
  String historyLinkUser(num id) {
    return 'ユーザー #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return 'Wiki #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return 'ユーザー $id';
  }

  @override
  String historyLinkWikiByName(String id) {
    return 'Wiki $id';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type - $query';
  }

  @override
  String get historyWiki => 'Wiki';

  @override
  String get poolEmpty => 'プールがありません';

  @override
  String get poolFailedToLoadPools => 'プールを読み込めませんでした';

  @override
  String get poolTitle => 'プール名';

  @override
  String get poolInfoPosts => '投稿';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => '状態';

  @override
  String get poolInfoActive => 'アクティブ';

  @override
  String get poolInfoInactive => '非アクティブ';

  @override
  String get poolInfoCreated => '作成日時';

  @override
  String get poolInfoUpdated => '更新日時';

  @override
  String poolCopiedId(num id) {
    return 'プール ID #$id をコピーしました';
  }

  @override
  String poolLink(num id) {
    return 'プール #$id';
  }

  @override
  String get poolFailedToLoadPool => 'プールを読み込めませんでした';

  @override
  String get poolNotFound => 'プールが見つかりません';

  @override
  String get poolOrder => 'プールの並び順';

  @override
  String get poolOldestFirst => '古い順';

  @override
  String get poolNewestFirst => '新しい順';

  @override
  String get poolReaderMode => 'プールのリーダーモード';

  @override
  String get poolReaderLargeImages => '大きな画像';

  @override
  String get poolReaderNormalGrid => '通常のグリッド';

  @override
  String get topicsTitle => 'トピック';

  @override
  String get topicHideTagEdits => 'タグ編集を非表示';

  @override
  String get topicTagEditsHidden => '非表示';

  @override
  String get topicTagEditsVisible => '表示';

  @override
  String topicLink(num id) {
    return 'トピック #$id';
  }

  @override
  String get topicFailedToLoadTopic => 'トピックを読み込めませんでした';

  @override
  String get topicNotFound => 'トピックが見つかりません';

  @override
  String get topicEmpty => 'トピックがありません';

  @override
  String get topicFailedToLoadTopics => 'トピックを読み込めませんでした';

  @override
  String get topicInfoReplies => '返信';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return 'トピック ID #$id をコピーしました';
  }

  @override
  String get topicInfoLocked => 'ロック';

  @override
  String get topicInfoYes => 'はい';

  @override
  String get topicInfoNo => 'いいえ';

  @override
  String get topicInfoCreated => '作成日時';

  @override
  String get topicInfoUpdated => '更新日時';

  @override
  String get filterTags => 'タグ';

  @override
  String get loginRequired => 'この操作を行うにはログインが必要です。';

  @override
  String get actionChooseIdentity => 'アカウントを選択';

  @override
  String get dateToday => '今日';

  @override
  String get dateYesterday => '昨日';

  @override
  String detailCommentsButton(num count) {
    return 'コメント（$count）';
  }

  @override
  String get detailFile => 'ファイル';

  @override
  String get detailSources => 'ソース';

  @override
  String get detailNoSources => 'ソースなし';

  @override
  String get detailChildren => '子投稿';

  @override
  String get detailDeletion => '削除理由';

  @override
  String get detailBlacklisted => 'ブラックリスト済み';

  @override
  String get detailNoArtist => '絵師なし';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の投稿',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return '投稿 ID #$id をコピーしました';
  }

  @override
  String postUpvoteFailed(num id) {
    return '投稿 #$id を高評価できませんでした';
  }

  @override
  String postDownvoteFailed(num id) {
    return '投稿 #$id を低評価できませんでした';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return '投稿 #$id をお気に入りに追加できませんでした';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return '投稿 #$id をお気に入りから削除できませんでした';
  }

  @override
  String get editorSection => 'セクション';

  @override
  String get editorQuote => '引用';

  @override
  String get editorCode => 'コード';

  @override
  String get editorSpoiler => 'ネタバレ';

  @override
  String get editorBold => '太字';

  @override
  String get editorItalic => '斜体';

  @override
  String get editorUnderlined => '下線';

  @override
  String get editorStrikethrough => '打ち消し線';

  @override
  String get editorPreviewPlaceholder => 'ここにテキストが表示されます';

  @override
  String get editorWrite => '入力';

  @override
  String get editorPreview => 'プレビュー';

  @override
  String get editorTypeHere => 'ここに入力…';

  @override
  String get tagNoTags => 'タグなし';

  @override
  String get tagFailedToLoadTags => 'タグを読み込めませんでした';

  @override
  String get tagUnableToRetrieveWiki => 'Wiki を取得できません';

  @override
  String get tagNoWikiEntry => 'Wiki エントリなし';

  @override
  String get tagCategoryGeneral => '一般';

  @override
  String get tagCategorySpecies => '種族';

  @override
  String get tagCategoryCharacter => 'キャラクター';

  @override
  String get tagCategoryCopyright => 'コピーライト';

  @override
  String get tagCategoryMeta => 'メタ';

  @override
  String get tagCategoryLore => '背景設定';

  @override
  String get tagCategoryArtist => '絵師';

  @override
  String get tagCategoryContributor => '貢献者';

  @override
  String get tagCategoryInvalid => '無効';

  @override
  String editDescriptionTitle(num postId) {
    return '投稿 #$postId の説明';
  }

  @override
  String get editDescriptionHint => '投稿の説明を入力…';

  @override
  String get editInvalidNumber => '数値の形式が無効です';

  @override
  String get editInvalidParent => '無効な親投稿です';

  @override
  String get editParentIdLabel => '親投稿 ID（任意）';

  @override
  String get editParentIdHint => '親投稿の ID';

  @override
  String get editReasonLabel => '編集理由（任意）';

  @override
  String get editReasonHint => 'この投稿を編集する理由は何ですか？';

  @override
  String editSourcesTitle(num postId) {
    return '投稿 #$postId のソース';
  }

  @override
  String get editTagsHint => 'スペース区切りのタグ';

  @override
  String editTagPreviewFailed(String error) {
    return 'タグプレビューの読み込みエラー：$error';
  }

  @override
  String get editTagStatusNew => '新規';

  @override
  String get editTagStatusInvalid => '無効';

  @override
  String get editTagStatusEmpty => '空';

  @override
  String get editTagStatusUnderused => '使用頻度が低い';

  @override
  String reportCommentSuccess(num id) {
    return 'コメント #$id を通報しました';
  }

  @override
  String reportCommentFailed(num id) {
    return 'コメント #$id の通報に失敗しました';
  }

  @override
  String reportReplySuccess(num id) {
    return '返信 #$id を通報しました';
  }

  @override
  String reportReplyFailed(num id) {
    return '返信 #$id の通報に失敗しました';
  }

  @override
  String reportUserSuccess(num id) {
    return 'ユーザー #$id を通報しました';
  }

  @override
  String reportUserFailed(num id) {
    return 'ユーザー #$id の通報に失敗しました';
  }

  @override
  String reportPostSuccess(num id) {
    return '投稿 #$id を通報しました';
  }

  @override
  String reportPostFailed(num id) {
    return '投稿 #$id の通報に失敗しました';
  }

  @override
  String get reportTypeRequired => '種類は必須です';

  @override
  String get reportReason => '理由';

  @override
  String get reportReasonRequired => '理由は必須です';

  @override
  String get reportSubmitted => '通報を送信しました';

  @override
  String get reportSubmitFailed => '通報の送信に失敗しました';

  @override
  String get reportTypeRating => 'レーティングの悪用';

  @override
  String get reportTypeFile => '悪意のあるファイル';

  @override
  String get reportTypeSource => '悪意のあるソース';

  @override
  String get reportTypeDescription => '説明の悪用';

  @override
  String get reportTypeNote => '注釈の悪用';

  @override
  String get reportTypeTagging => 'タグ付けの悪用';

  @override
  String get reportTypeRatingBody => 'この作品のレーティングが誤って設定されています。';

  @override
  String get reportTypeFileBody =>
      'ファイルに悪意のあるコードや隠されたアーカイブが含まれています。画像自体の内容は関係ありません。';

  @override
  String get reportTypeSourceBody =>
      '掲載されているソースの一部または全部が、悪意のあるページや有料コンテンツへのリンクです。';

  @override
  String get reportTypeDescriptionBody =>
      '説明に悪意のあるコンテンツが含まれているか、暴言的な内容へと書き換えられています。';

  @override
  String get reportTypeNoteBody => 'この投稿の注釈が誤っていたり、嫌がらせやその他の悪質な内容を含んでいたりします。';

  @override
  String get reportTypeTaggingBody => 'この投稿には無効なタグが含まれているか、有効なタグが削除されています。';

  @override
  String flagPostSuccess(num id) {
    return '投稿 #$id にフラグを付けました';
  }

  @override
  String flagPostFailed(num id) {
    return '投稿 #$id のフラグ付けに失敗しました';
  }

  @override
  String get flagParentId => '親投稿 ID';

  @override
  String get flagParentIdRequired => '親投稿 ID は必須です';

  @override
  String get flagParentIdInvalid => '親投稿 ID は数値で入力してください';

  @override
  String get flagTypeUploadingGuidelines => 'アップロードガイドラインを満たしていません';

  @override
  String get flagTypeYoungHuman => 'エクスプリシットな場面に登場する若い人間型キャラクター';

  @override
  String get flagTypeDnpArtist => 'この投稿の絵師はアップロード禁止リストに登録されています';

  @override
  String get flagTypePayContent => '有料サイト・商業・サブスクリプションのコンテンツ';

  @override
  String get flagTypeTrace => '他の絵師の作品のトレス';

  @override
  String get flagTypePreviouslyDeleted => '過去に削除されたもの';

  @override
  String get flagTypeRealPorn => '実写のポルノ';

  @override
  String get flagTypeCorrupt => 'ファイルが破損しているか、壊れているか、正常に動作しません';

  @override
  String get flagTypeInferior => '他の投稿の重複または劣るバージョン';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      'この投稿は、芸術的価値・画像の品質・関連性などの面でサイトの基準を満たしていません。\n個人的な好みはここでは関係ありません。投稿の内容が不快に感じられる場合は、[[e621:blacklist|ブラックリスト]]に登録してください。';

  @override
  String get flagTypeYoungHumanBody =>
      '人間や人間型のキャラクターを性的・エクスプリシットなヌードとして描いた投稿は、このサイトでは許可されません。';

  @override
  String get flagTypeDnpArtistBody =>
      '一部の絵師は自身の作品の掲載を拒否し、[[avoid_posting|アップロード禁止]]のステータスを得ています。\nこのステータスには条件が付いている場合もあります。詳しくは[[conditional_dnp]]をご覧ください';

  @override
  String get flagTypePayContentBody =>
      '当サイトでは、有料サイトや商業目的のコンテンツは一切ホストしていません。これには Patreon のリークや海賊サイトからの転載などが含まれます。';

  @override
  String get flagTypeTraceBody =>
      '他の絵師の作品をトレスした画像は、このサイトでは許可されません。参考にすることは問題ありませんが、他人の作品をそのままコピーすることは許可されません。\n詳しい情報はコメントに残すか、元の作品がこのサイトにある場合はその投稿を親投稿として設定してください。';

  @override
  String get flagTypePreviouslyDeletedBody =>
      '投稿が削除されるのには通常正当な理由があり、削除されたコンテンツの再アップロードは許可されません。\n詳しい情報はコメントに残すか、元の投稿をこの投稿の親投稿として設定してください。';

  @override
  String get flagTypeRealPornBody =>
      '実写のポルノを含む投稿は、このサイトでは一切許可されません。例外はありません。\nエロを目的としない実写写真を含む画像は許可されることに注意してください。';

  @override
  String get flagTypeCorruptBody =>
      'この投稿には何かが正しく動作しない問題があります。動画の破損や画像の破損の可能性があります。\nいずれの場合も、混乱を避けるために状況をコメントで説明してください。';

  @override
  String get flagTypeInferiorBody =>
      'この投稿のより優れたバージョンがすでにサイトに存在します。\nこれには、見た目の品質がより高い画像（サイズが大きい、圧縮が少ない）が含まれるほか、絵師によって視覚的なミスが修正された「修正版」も含まれます。\n編集や別バージョンはこのカテゴリには当てはまらないことに注意してください。';

  @override
  String get taskCancelAll => 'すべてキャンセル';

  @override
  String get taskClearDone => '完了を消去';

  @override
  String get taskClearSelection => '選択を解除';

  @override
  String get taskCancel => 'キャンセル';

  @override
  String get taskDismiss => '非表示';

  @override
  String get taskNoTasks => 'タスクはありません';

  @override
  String get taskFailedToLoadTasks => 'タスクを読み込めませんでした';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のタスク',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => '実行中';

  @override
  String get taskGroupFailed => '失敗';

  @override
  String get taskActionDownload => 'ダウンロード';

  @override
  String get taskActionFavorite => 'お気に入り追加';

  @override
  String get taskActionUnfavorite => 'お気に入り解除';

  @override
  String get taskDownloadRunning => 'ダウンロード中';

  @override
  String get taskFavoriteRunning => 'お気に入り追加中';

  @override
  String get taskUnfavoriteRunning => 'お気に入り解除中';

  @override
  String get taskDownloadCompleted => 'ダウンロード済み';

  @override
  String get taskFavoriteCompleted => 'お気に入り追加済み';

  @override
  String get taskUnfavoriteCompleted => 'お気に入り解除済み';

  @override
  String taskQueuedTo(String action) {
    return '$actionを待機中';
  }

  @override
  String taskFailedTo(String action) {
    return '$actionに失敗しました';
  }

  @override
  String taskCanceledAction(String action) {
    return '$actionをキャンセルしました';
  }

  @override
  String taskTileTitle(String label, num id) {
    return '$label：投稿 #$id';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新しい投稿が $count 件あります！',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => '新しい投稿！';

  @override
  String get followChannelName => 'フォロー中のタグ';

  @override
  String get followChannelDescription => 'フォローしているタグの通知';

  @override
  String get hostUnavailableTitle => 'サイトに接続できません';

  @override
  String hostUnavailableBody(String host) {
    return '$host にアクセスできないようです！';
  }

  @override
  String get hostUnavailableResolveHint =>
      '次のブラウザウィンドウで問題を解決してください。\n\nCloudflare の CAPTCHA Cookie が保存されます。';

  @override
  String get hostUnavailableResolve => '解決';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\n$host 側が状況を解決するまでお待ちください。';
  }

  @override
  String get downloadChooseFolder => 'フォルダを選択';

  @override
  String get searchFilterTitle => 'フィルター';

  @override
  String get searchFilterQueryLabel => '現在のクエリ：';

  @override
  String get dtextParsingFailed => 'DText の解析に失敗しました';
}
