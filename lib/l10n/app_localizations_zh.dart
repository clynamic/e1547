// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => '加载失败';

  @override
  String get nothingToSeeHere => '这里什么都没有';

  @override
  String get loading => '加载中…';

  @override
  String get actionCancel => '取消';

  @override
  String get actionOk => '确定';

  @override
  String get actionTryAgain => '重试';

  @override
  String get actionDownload => '下载';

  @override
  String get actionImport => '导入';

  @override
  String get actionExport => '导出';

  @override
  String get actionUndo => '撤销';

  @override
  String get actionRestartNow => '立即重启';

  @override
  String get failedToLoadSuggestions => '建议加载失败';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => '中止';

  @override
  String get actionSelectAll => '全选';

  @override
  String fileSavedAs(String name) {
    return '文件已保存为 $name';
  }

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get saveFile => '保存文件';

  @override
  String get filterTooltip => '筛选';

  @override
  String get rangeInvalidFormat => '格式无效';

  @override
  String itemProgress(num current, num total) {
    return '第 $current/$total 项';
  }

  @override
  String get taskCancelled => '已取消任务';

  @override
  String taskFailedAt(num index) {
    return '第 $index 项失败';
  }

  @override
  String get taskDone => '完成';

  @override
  String get failedToInitialize => '初始化失败';

  @override
  String get navHome => '首页';

  @override
  String get navHot => '热门';

  @override
  String get navSearch => '搜索';

  @override
  String get navFavorites => '收藏';

  @override
  String get navTimeline => '时间线';

  @override
  String get navSubscriptions => '订阅';

  @override
  String get navBookmarks => '书签';

  @override
  String get navPools => '图集';

  @override
  String get navForum => '论坛';

  @override
  String get navHistory => '历史';

  @override
  String get navTasks => '任务';

  @override
  String get navSettings => '设置';

  @override
  String get navAbout => '关于';

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionAccount => '账户';

  @override
  String get sectionUser => '用户';

  @override
  String get sectionAppearance => '外观';

  @override
  String get sectionInteractions => '交互';

  @override
  String get sectionSecurity => '安全';

  @override
  String get sectionDevelopment => '开发';

  @override
  String get settingsBlacklist => '黑名单';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已屏蔽 $count 个标签',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => '关注';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已关注 $count 个搜索',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => '历史';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已浏览 $count 个页面',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => '主题';

  @override
  String get themeDark => '深色';

  @override
  String get themeAmoled => '纯黑';

  @override
  String get themeLight => '浅色';

  @override
  String get themeBlue => '蓝色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageSystemDefault => '跟随系统';

  @override
  String get settingsTileSize => '格子大小';

  @override
  String get settingsQuilt => '布局';

  @override
  String get gridTitle => '网格';

  @override
  String get quiltSquare => '方形格子';

  @override
  String get quiltVertical => '纵向扩展的格子';

  @override
  String get settingsPostInfo => '帖子信息';

  @override
  String get postInfoShown => '在格子上显示信息';

  @override
  String get postInfoHidden => '仅显示图片';

  @override
  String get settingsDownloadLocation => '下载位置';

  @override
  String get settingsUpvoteFavorites => '收藏时点赞';

  @override
  String get upvoteFavoritesOn => '点赞并收藏';

  @override
  String get upvoteFavoritesOff => '仅收藏';

  @override
  String get settingsVideoVolume => '视频音量';

  @override
  String get videoMuted => '静音';

  @override
  String get videoWithSound => '有声音';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get settingsVideoResolution => '视频分辨率';

  @override
  String get videoResStandard => '标准 (480p)';

  @override
  String get videoResHigh => '高 (720p)';

  @override
  String get videoResFull => '全高清 (1080p)';

  @override
  String get videoResUltra => '超高清 (4K)';

  @override
  String get videoResSource => '原始画质';

  @override
  String get settingsSecureDisplay => '屏幕内容保护';

  @override
  String get secureDisplayOn => '隐藏屏幕内容';

  @override
  String get secureDisplayOff => '不隐藏屏幕内容';

  @override
  String get settingsIncognitoKeyboard => '无痕键盘';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get settingsPinLock => 'PIN 锁';

  @override
  String get pinEnabled => 'PIN 已启用';

  @override
  String get pinDisabled => 'PIN 已禁用';

  @override
  String get settingsBiometricLock => '生物识别锁';

  @override
  String get biometricsEnabled => '生物识别已启用';

  @override
  String get biometricsDisabled => '生物识别已禁用';

  @override
  String get settingsDeveloperMode => '开发者模式';

  @override
  String get devOptionsShown => '显示开发者选项';

  @override
  String get devOptionsHidden => '隐藏开发者选项';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已记录 $count 个错误',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => '数据库';

  @override
  String get databaseExporting => '正在导出数据库…';

  @override
  String get databaseExported => '数据库导出成功';

  @override
  String get databaseExportFailed => '导出失败';

  @override
  String get databaseExport => '导出';

  @override
  String get databaseImporting => '正在导入数据库…';

  @override
  String databaseInvalidFile(String error) {
    return '无效的数据库文件：$error';
  }

  @override
  String databaseImportFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get databaseImportTitle => '导入数据库';

  @override
  String get databaseRestartTitle => '需要重启';

  @override
  String get databaseRestartBody => '需要重启应用以使更改生效。';

  @override
  String get databaseImport => '导入';

  @override
  String get lockEnterPin => '输入 PIN';

  @override
  String get lockEnterNewPin => '输入新 PIN';

  @override
  String get lockConfirmNewPin => '确认新 PIN';

  @override
  String get lockFailedAuth => '验证失败';

  @override
  String get lockPleaseAuth => '请验证身份';

  @override
  String get lockRetry => '重试';

  @override
  String get lockBiometricReason => '验证以解锁。';

  @override
  String get lockBiometricFailure => '生物识别验证出现严重错误';

  @override
  String get aboutVersion => '版本';

  @override
  String get updaterFetching => '正在检查更新…';

  @override
  String get updaterCheckFailed => '检查更新失败';

  @override
  String get updaterNewest => '已是最新版本';

  @override
  String updaterNewer(String version) {
    return '有新版本可用：$version';
  }

  @override
  String get updaterNewerHeader => '有新版本可用：';

  @override
  String get aboutExperimentalPlatform => '实验性平台';

  @override
  String get aboutExperimentalBody => '此平台不受支持，可能存在缺陷和功能缺失。';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => '上游项目';

  @override
  String get aboutUpstreamBody => '本应用是 clragon/e1547 的分支';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => '论坛';

  @override
  String aboutForumTopic(num id) {
    return 'e621 讨论帖 #$id';
  }

  @override
  String get aboutWebsite => '网站';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => '电子邮件';

  @override
  String get aboutPlaystore => 'Play 商店';

  @override
  String get aboutDonors => '捐赠者';

  @override
  String get aboutDonorsThanks => '感谢你们支持本项目的开发！';

  @override
  String get aboutNoDonors => '暂无捐赠者';

  @override
  String get aboutDonorsFailed => '获取捐赠者失败';

  @override
  String get aboutDonorsNotListed => '不在名单上？请联系我们！';

  @override
  String get developerUnlocked => '你已成为开发者！';

  @override
  String get databaseErrorLoading => '数据库加载出错';

  @override
  String get databaseUnknownSize => '未知';

  @override
  String get databaseExportTitle => '导出数据库';

  @override
  String get databaseExportSubtitle => '保存数据库备份副本';

  @override
  String get databaseImportSubtitle => '用导入的数据库替换当前数据库';

  @override
  String get databaseImportWarning => '这将替换你当前的数据库。\n所有数据都会丢失，且无法撤销！';

  @override
  String get databaseExportSanitizedBody =>
      '导出的文件不会包含你的登录信息和 API 密钥。\n其余内容（账号、站点、历史、关注和任务）都会包含。';

  @override
  String get databaseImportNewerFile => '此文件由更新版本的应用创建，无法导入。';

  @override
  String get databaseImportSanitized => '为安全起见，已从导入的文件中移除保存的登录信息。';

  @override
  String databaseImportHostsWarning(String hosts) {
    return '警告：导入的文件包含其他站点的账号：$hosts';
  }

  @override
  String get databaseImportCancelled => '已取消导入';

  @override
  String get postsTitle => '帖子';

  @override
  String favoritesOf(String user) {
    return '$user 的收藏';
  }

  @override
  String get favoritesUnavailable => '未登录用户无法使用收藏';

  @override
  String get favoriteOrder => '收藏排序';

  @override
  String get orderAdded => '添加顺序';

  @override
  String get orderId => 'ID 顺序';

  @override
  String get postStateDeleted => '已删除';

  @override
  String get postStateUnsupported => '不支持的类型';

  @override
  String get postStateUnavailable => '不可用';

  @override
  String get menuShare => '分享';

  @override
  String get menuDownload => '下载';

  @override
  String get menuBrowse => '在浏览器中打开';

  @override
  String get menuEdit => '编辑';

  @override
  String get menuComment => '评论';

  @override
  String get menuReport => '举报';

  @override
  String get menuFlag => '标记';

  @override
  String get actionOpen => '打开';

  @override
  String get actionFollow => '关注';

  @override
  String get actionUnfollow => '取消关注';

  @override
  String get actionMute => '静音';

  @override
  String get actionNotify => '通知';

  @override
  String get actionBookmark => '加书签';

  @override
  String get actionUnbookmark => '移除书签';

  @override
  String get actionBlock => '屏蔽';

  @override
  String get actionUnblock => '取消屏蔽';

  @override
  String get actionRemove => '移除';

  @override
  String get actionAdd => '添加';

  @override
  String get actionSubtract => '排除';

  @override
  String selectionPost(num id) {
    return '帖子 #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个帖子',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => '没有帖子';

  @override
  String get failedToLoadPosts => '帖子加载失败';

  @override
  String get offlineBanner => '当前离线，正在显示缓存数据。';

  @override
  String get offlineNoData => '当前离线';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个帖子',
    );
    return '第 $page 页 · $_temp0';
  }

  @override
  String get postListPageLimit => '已达服务器页数上限，请缩小搜索范围';

  @override
  String get postListJumpToPage => '跳转页面';

  @override
  String get postListJumpPageLabel => '页码';

  @override
  String postListJumpPageRange(Object max) {
    return '请输入 1 到 $max 之间的页码';
  }

  @override
  String get postDeletedOverlay => '帖子已被删除';

  @override
  String get postUnavailableOverlay => '帖子不可用';

  @override
  String get postBlacklistedOverlay => '帖子已被屏蔽';

  @override
  String unsupportedFileType(String ext) {
    return '不支持 $ext 文件';
  }

  @override
  String get loginRequiredEdit => '必须登录才能编辑帖子！';

  @override
  String get loginRequiredComment => '必须登录才能评论！';

  @override
  String get loginRequiredReport => '必须登录才能举报帖子！';

  @override
  String get loginRequiredFlag => '必须登录才能标记帖子！';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已屏蔽 $count 个帖子',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => '黑名单更新失败！';

  @override
  String get blacklistAddTag => '添加标签';

  @override
  String get blacklistEditTag => '编辑标签';

  @override
  String get denylistEntryDeleted => '已移除黑名单条目';

  @override
  String get blacklistEmpty => '你的黑名单为空';

  @override
  String get menuDelete => '删除';

  @override
  String get filterScore => '评分';

  @override
  String get filterFavoriteCount => '收藏数';

  @override
  String get filterSortBy => '排序方式';

  @override
  String get filterNew => '最新';

  @override
  String get filterRank => '排名';

  @override
  String get filterRandom => '随机';

  @override
  String get filterDefault => '默认';

  @override
  String get filterRating => '分级';

  @override
  String get filterSafe => '安全';

  @override
  String get filterQuestionable => '存疑';

  @override
  String get filterExplicit => '露骨';

  @override
  String get filterAll => '全部';

  @override
  String get filterPool => '图集';

  @override
  String get filterHasPool => '含图集';

  @override
  String get filterChild => '子帖';

  @override
  String get filterIsChildPost => '是子帖';

  @override
  String get filterParent => '父帖';

  @override
  String get filterIsParentPost => '是父帖';

  @override
  String get filterUploadDate => '上传日期';

  @override
  String get filterLastDay => '最近一天';

  @override
  String get filterLastWeek => '最近一周';

  @override
  String get filterLastMonth => '最近一个月';

  @override
  String get filterLastYear => '最近一年';

  @override
  String get filterStatus => '状态';

  @override
  String get filterActive => '活跃';

  @override
  String get filterPending => '待处理';

  @override
  String get filterDeleted => '已删除';

  @override
  String get filterFlagged => '已标记';

  @override
  String get filterAny => '任意';

  @override
  String get filterFileType => '文件类型';

  @override
  String get filterUploader => '上传者';

  @override
  String get filterWidth => '宽度';

  @override
  String get filterHeight => '高度';

  @override
  String get filterTagCount => '标签数';

  @override
  String get filterTrue => '是';

  @override
  String get filterFalse => '否';

  @override
  String get filterImages => '图片';

  @override
  String get filterVideos => '视频';

  @override
  String get filterTitleContains => '标题包含';

  @override
  String get filterCategory => '分类';

  @override
  String get filterGeneral => '综合';

  @override
  String get filterSiteBugReports => '站点问题反馈与功能请求';

  @override
  String get filterTagWikiProjects => '标签/维基项目与提问';

  @override
  String get filterTagAliasSuggestions => '标签别名与关联建议';

  @override
  String get filterArtTalk => '艺术交流';

  @override
  String get filterOffTopic => '跑题';

  @override
  String get filterE621Tools => 'e621 工具与应用';

  @override
  String get filterNewestFirst => '最新优先';

  @override
  String get filterOldestFirst => '最旧优先';

  @override
  String get filterSticky => '置顶';

  @override
  String get filterIsSticky => '已置顶';

  @override
  String get filterLocked => '已锁定';

  @override
  String get filterIsLocked => '已锁定';

  @override
  String get filterDescription => '描述';

  @override
  String get filterCreator => '创建者';

  @override
  String get filterIsActive => '活跃中';

  @override
  String get filterSeries => '系列';

  @override
  String get filterCollection => '合集';

  @override
  String get filterName => '名称';

  @override
  String get filterCreated => '创建时间';

  @override
  String get filterUpdated => '更新时间';

  @override
  String get filterPostCount => '帖子数';

  @override
  String postUpdateFailed(num id) {
    return '更新帖子 #$id 失败';
  }

  @override
  String postUpdated(num id) {
    return '已更新帖子 #$id';
  }

  @override
  String get failedToLoadPost => '帖子加载失败';

  @override
  String get postNotFound => '找不到帖子';

  @override
  String get commentsTitle => '评论';

  @override
  String commentsOfPost(num postId) {
    return '帖子 #$postId 的评论';
  }

  @override
  String get commentOrder => '评论排序';

  @override
  String get noComments => '没有评论';

  @override
  String get failedToLoadComments => '评论加载失败';

  @override
  String commentTitle(num id) {
    return '评论 #$id';
  }

  @override
  String get failedToLoadComment => '评论加载失败';

  @override
  String get commentNotFound => '找不到评论';

  @override
  String commentEditorTitle(num postId) {
    return '帖子 #$postId 的评论';
  }

  @override
  String get commentSendFailed => '评论发送失败！';

  @override
  String get commentSent => '评论已发送！';

  @override
  String get commentHidden => '此评论已隐藏';

  @override
  String commentUpvoteFailed(num id) {
    return '评论 #$id 点赞失败';
  }

  @override
  String commentDownvoteFailed(num id) {
    return '评论 #$id 点踩失败';
  }

  @override
  String get commentLoginRequiredEdit => '必须登录才能编辑评论！';

  @override
  String get commentLoginRequiredReply => '必须登录才能回复评论！';

  @override
  String get commentLoginRequiredReport => '必须登录才能举报评论！';

  @override
  String commentCopiedId(num id) {
    return '已复制评论 ID #$id';
  }

  @override
  String get warningUserWarned => '用户因这条消息收到警告';

  @override
  String get warningUserRecorded => '用户因这条消息被记过';

  @override
  String get warningUserBanned => '用户因这条消息被封禁';

  @override
  String get repliesTitle => '回复';

  @override
  String get replyOrder => '回复排序';

  @override
  String get noReplies => '没有回复';

  @override
  String get failedToLoadReplies => '回复加载失败';

  @override
  String replyTitle(num id) {
    return '回复 #$id';
  }

  @override
  String get failedToLoadReply => '回复加载失败';

  @override
  String get replyNotFound => '找不到回复';

  @override
  String replyEditorTitle(num topicId) {
    return '讨论帖 #$topicId 的回复';
  }

  @override
  String get replySendFailed => '回复发送失败！';

  @override
  String get replySent => '回复已发送！';

  @override
  String get replyHidden => '此回复已隐藏';

  @override
  String get replyLoginRequiredEdit => '必须登录才能编辑回复！';

  @override
  String get replyLoginRequiredReply => '必须登录才能回复！';

  @override
  String get replyLoginRequiredReport => '必须登录才能举报回复！';

  @override
  String replyCopiedId(num id) {
    return '已复制回复 ID #$id';
  }

  @override
  String get menuReply => '回复';

  @override
  String get menuCopyId => '复制 ID';

  @override
  String get menuRefresh => '刷新';

  @override
  String get actionCopy => '复制';

  @override
  String get actionSave => '保存';

  @override
  String get actionShow => '显示';

  @override
  String get actionHide => '隐藏';

  @override
  String get actionCannotBeUndone => '此操作无法撤销。';

  @override
  String get info => '信息';

  @override
  String wikiTitle(String idOrTitle) {
    return '维基 $idOrTitle';
  }

  @override
  String get failedToLoadWiki => '维基加载失败';

  @override
  String get wikiNotFound => '找不到维基';

  @override
  String wikiCopiedId(num id) {
    return '已复制维基 ID #$id';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => '别名';

  @override
  String get wikiInfoCreated => '创建时间';

  @override
  String get wikiInfoUpdated => '更新时间';

  @override
  String get wikiInfoLocked => '锁定';

  @override
  String get wikiInfoYes => '是';

  @override
  String get wikiInfoNo => '否';

  @override
  String userTitle(String idOrName) {
    return '用户 $idOrName';
  }

  @override
  String get failedToLoadUser => '用户加载失败';

  @override
  String get userNotFound => '找不到用户';

  @override
  String get userUploads => '上传';

  @override
  String get userLoginRequiredReport => '必须登录才能举报用户！';

  @override
  String get userComission => '约稿';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => '加入时间';

  @override
  String get userRank => '等级';

  @override
  String get userPosts => '帖子';

  @override
  String get userEdits => '编辑';

  @override
  String get userFavorites => '收藏';

  @override
  String get userComments => '评论';

  @override
  String get userForum => '论坛';

  @override
  String userCopiedId(num id) {
    return '已复制用户 ID #$id';
  }

  @override
  String get logsTitle => '日志';

  @override
  String logsTitleDate(String date) {
    return '日志 - $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条日志',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个日志文件',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => '级别';

  @override
  String get logsRecording => '记录';

  @override
  String get logsVerbose => '详细日志';

  @override
  String get logsVerboseAll => '记录所有级别';

  @override
  String logsVerboseMinimum(String level) {
    return '$level 及以上';
  }

  @override
  String get logFilesTitle => '日志文件';

  @override
  String get failedToLoadLogFiles => '日志文件加载失败！';

  @override
  String get noLogFiles => '没有可用的日志文件！';

  @override
  String get logsLive => '实时';

  @override
  String get noLogs => '没有日志';

  @override
  String get failedToReadLog => '日志读取失败';

  @override
  String get noErrorsLogged => '没有已记录的错误';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个错误',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => '所有日志';

  @override
  String get logsDismissAll => '全部清除';

  @override
  String logsDeleteTitle(num count) {
    return '删除 $count 个日志文件？';
  }

  @override
  String get identityAccounts => '账户';

  @override
  String get identityAdd => '添加账户';

  @override
  String get identityEdit => '编辑账户';

  @override
  String get identityRemoveTitle => '移除账户？';

  @override
  String get identityRemoveBody => '其所有数据将被永久移除，包括历史和关注。';

  @override
  String get identityAnonymous => '匿名';

  @override
  String get identityDuplicate => '此站点和用户名下已存在账户。';

  @override
  String identityLoginFailed(String reason) {
    return '登录失败。\n$reason';
  }

  @override
  String get identityLoginCheckDetails => '请检查网络连接和登录信息';

  @override
  String get identitySite => '站点';

  @override
  String get identityHostRequired => '请输入站点地址。';

  @override
  String get identityHostInvalid => '站点地址无效';

  @override
  String get identityHostReadOnly => '无法更改站点。如需使用其他站点，请添加新账户。';

  @override
  String get identityUsernameLabel => '用户名';

  @override
  String get identityUsernameRequired => '请输入用户名。';

  @override
  String get identityApikeyLabel => 'API 密钥';

  @override
  String get identityApikeyHelp => '在哪里能找到我的 API 密钥？';

  @override
  String get identityApikeyRequired =>
      '必须提供 API 密钥。\n例如 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'API 密钥是由 A-z 和 0-9 中的 24 或 32 个字符组成的序列\n例如 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => '还没有账户？在这里注册';

  @override
  String get identityHostHint => '你的账户和帖子所在的站点。';

  @override
  String get identitySignIn => '登录';

  @override
  String get identityGuest => '访客';

  @override
  String get identityLogin => '登录';

  @override
  String get identityBrowseAnonymously => '匿名浏览';

  @override
  String identityConnecting(String host, String username) {
    return '正在以 $username 身份连接 $host…';
  }

  @override
  String identityActivateFailed(Object error) {
    return '激活身份失败：$error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return '激活特性失败：$error';
  }

  @override
  String get failedToLoadIdentities => '账户加载失败';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingBack => '上一步';

  @override
  String get onboardingNext => '下一步';

  @override
  String onboardingWelcomeTitle(String app) {
    return '欢迎使用 $app';
  }

  @override
  String get onboardingWelcomeBody => '一款精致的 booru 浏览器。';

  @override
  String get onboardingThemeTitle => '选个外观';

  @override
  String get onboardingThemeBody => '先试试看。以后随时可以更换。';

  @override
  String get onboardingLoginTitle => '连接账户';

  @override
  String get onboardingLanguageTitle => '选择语言';

  @override
  String get followAddToSubscriptions => '添加到订阅';

  @override
  String get followNoSubscriptions => '没有订阅';

  @override
  String get followFailedToLoadSubscriptions => '订阅加载失败';

  @override
  String get followAddToBookmarks => '添加到书签';

  @override
  String get followNoBookmarks => '没有书签';

  @override
  String get followFailedToLoadBookmarks => '书签加载失败';

  @override
  String get followUnseenPosts => '未读帖子';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '将 $count 个帖子标记为已读',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => '没有未读帖子';

  @override
  String get followShowUnseenFirst => '优先显示未读';

  @override
  String get followFilteringUnseen => '正在筛选未读';

  @override
  String get followAllPostsShown => '显示全部帖子';

  @override
  String get followForceSync => '强制同步';

  @override
  String get followSyncAllFollows => '同步全部关注';

  @override
  String followSyncingFollows(String progress) {
    return '正在同步关注… $progress';
  }

  @override
  String get followEditorTitle => '编辑关注';

  @override
  String get followSubscribe => '订阅';

  @override
  String get followEditPrompt => '编辑关注';

  @override
  String get followTitlePrompt => '关注标题';

  @override
  String get followMarkAsRead => '标记为已读';

  @override
  String get followDisableNotifications => '关闭通知';

  @override
  String get followEnableNotifications => '开启通知';

  @override
  String get followRename => '重命名';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label 个新帖子',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个关注',
    );
    return '$_temp0';
  }

  @override
  String followAlias(String? alias) {
    return '别名 $alias';
  }

  @override
  String historySelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个条目',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已删除 $count 条历史记录',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => '清空历史';

  @override
  String get historyClearSubtitle => '删除所有条目';

  @override
  String get historyClearConfirm => '清空历史？';

  @override
  String get historyClearConfirmBody => '所有历史条目将被永久删除，此操作无法撤销。';

  @override
  String get historyClearAction => '清空';

  @override
  String get historyLimit => '历史上限';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return '启用历史上限后，超过 $amount 条或早于 $months 个月的条目将被自动删除。';
  }

  @override
  String get historyLimitTitle => '限制历史';

  @override
  String historyLimitOn(String amount, num months) {
    return '仅保留最近 $months 个月内且不超过 $amount 条的记录。';
  }

  @override
  String get historyLimitOff => '历史无上限';

  @override
  String get historyEntries => '条目';

  @override
  String get historyType => '类型';

  @override
  String get historyItems => '浏览';

  @override
  String get historySearches => '搜索';

  @override
  String get historyWikis => '维基';

  @override
  String get historyUsers => '用户';

  @override
  String get historyEmpty => '历史记录为空';

  @override
  String get historyFailedToLoad => '历史加载失败';

  @override
  String get historyNoDescription => '暂无描述';

  @override
  String get historyHotPosts => '热门帖子';

  @override
  String historyLinkPost(num id) {
    return '帖子 #$id';
  }

  @override
  String historyLinkUser(num id) {
    return '用户 #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return '维基 #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return '用户 $id';
  }

  @override
  String historyLinkWikiByName(String id) {
    return '维基 $id';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type - $query';
  }

  @override
  String get historyWiki => '维基';

  @override
  String get poolEmpty => '没有图集';

  @override
  String get poolFailedToLoadPools => '图集加载失败';

  @override
  String get poolTitle => '图集标题';

  @override
  String get poolInfoPosts => '帖子';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => '活跃状态';

  @override
  String get poolInfoActive => '活跃';

  @override
  String get poolInfoInactive => '不活跃';

  @override
  String get poolInfoCreated => '创建时间';

  @override
  String get poolInfoUpdated => '更新时间';

  @override
  String poolCopiedId(num id) {
    return '已复制图集 ID #$id';
  }

  @override
  String poolLink(num id) {
    return '图集 #$id';
  }

  @override
  String get poolFailedToLoadPool => '图集加载失败';

  @override
  String get poolNotFound => '找不到图集';

  @override
  String get poolOrder => '图集排序';

  @override
  String get poolOldestFirst => '最旧优先';

  @override
  String get poolNewestFirst => '最新优先';

  @override
  String get poolReaderMode => '图集阅读模式';

  @override
  String get poolReaderLargeImages => '大图';

  @override
  String get poolReaderNormalGrid => '普通网格';

  @override
  String get topicsTitle => '讨论';

  @override
  String get topicHideTagEdits => '隐藏标签编辑帖';

  @override
  String get topicTagEditsHidden => '已隐藏';

  @override
  String get topicTagEditsVisible => '已显示';

  @override
  String topicLink(num id) {
    return '讨论帖 #$id';
  }

  @override
  String get topicFailedToLoadTopic => '讨论帖加载失败';

  @override
  String get topicNotFound => '找不到讨论帖';

  @override
  String get topicEmpty => '没有讨论帖';

  @override
  String get topicFailedToLoadTopics => '讨论帖加载失败';

  @override
  String get topicInfoReplies => '回复';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return '已复制讨论帖 ID #$id';
  }

  @override
  String get topicInfoLocked => '已锁定';

  @override
  String get topicInfoYes => '是';

  @override
  String get topicInfoNo => '否';

  @override
  String get topicInfoCreated => '创建时间';

  @override
  String get topicInfoUpdated => '更新时间';

  @override
  String get filterTags => '标签';

  @override
  String get loginRequired => '必须登录才能执行此操作！';

  @override
  String get actionChooseIdentity => '选择账户';

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String detailCommentsButton(num count) {
    return '评论（$count）';
  }

  @override
  String get detailFile => '文件';

  @override
  String get detailSources => '来源';

  @override
  String get detailNoSources => '无来源';

  @override
  String get detailChildren => '子帖';

  @override
  String get detailDeletion => '删除原因';

  @override
  String get detailBlacklisted => '已屏蔽';

  @override
  String get detailNoArtist => '无画师';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个帖子',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return '已复制帖子 ID #$id';
  }

  @override
  String postUpvoteFailed(num id) {
    return '帖子 #$id 点赞失败';
  }

  @override
  String postDownvoteFailed(num id) {
    return '帖子 #$id 点踩失败';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return '帖子 #$id 收藏失败';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return '帖子 #$id 取消收藏失败';
  }

  @override
  String get editorSection => '章节';

  @override
  String get editorQuote => '引用';

  @override
  String get editorCode => '代码';

  @override
  String get editorSpoiler => '剧透';

  @override
  String get editorBold => '加粗';

  @override
  String get editorItalic => '斜体';

  @override
  String get editorUnderlined => '下划线';

  @override
  String get editorStrikethrough => '删除线';

  @override
  String get editorPreviewPlaceholder => '你的文本会显示在这里';

  @override
  String get editorWrite => '编写';

  @override
  String get editorPreview => '预览';

  @override
  String get editorTypeHere => '在此输入…';

  @override
  String get tagNoTags => '没有标签';

  @override
  String get tagFailedToLoadTags => '标签加载失败';

  @override
  String get tagUnableToRetrieveWiki => '无法获取维基条目';

  @override
  String get tagNoWikiEntry => '没有维基条目';

  @override
  String get tagCategoryGeneral => '通用';

  @override
  String get tagCategorySpecies => '物种';

  @override
  String get tagCategoryCharacter => '角色';

  @override
  String get tagCategoryCopyright => '版权';

  @override
  String get tagCategoryMeta => '元信息';

  @override
  String get tagCategoryLore => '背景设定';

  @override
  String get tagCategoryArtist => '画师';

  @override
  String get tagCategoryContributor => '贡献者';

  @override
  String get tagCategoryInvalid => '无效';

  @override
  String editDescriptionTitle(num postId) {
    return '帖子 #$postId 的描述';
  }

  @override
  String get editDescriptionHint => '输入帖子描述…';

  @override
  String get editInvalidNumber => '数字格式无效';

  @override
  String get editInvalidParent => '父帖无效';

  @override
  String get editParentIdLabel => '父帖 ID（可选）';

  @override
  String get editParentIdHint => '父帖 ID';

  @override
  String get editReasonLabel => '编辑原因（可选）';

  @override
  String get editReasonHint => '你为什么要编辑这个帖子？';

  @override
  String editSourcesTitle(num postId) {
    return '帖子 #$postId 的来源';
  }

  @override
  String get editTagsHint => '以空格分隔的标签';

  @override
  String editTagPreviewFailed(String error) {
    return '标签预览加载失败：$error';
  }

  @override
  String get editTagStatusNew => '新建';

  @override
  String get editTagStatusInvalid => '无效';

  @override
  String get editTagStatusEmpty => '空';

  @override
  String get editTagStatusUnderused => '冷门';

  @override
  String reportCommentSuccess(num id) {
    return '已举报评论 #$id';
  }

  @override
  String reportCommentFailed(num id) {
    return '举报评论 #$id 失败';
  }

  @override
  String reportReplySuccess(num id) {
    return '已举报回复 #$id';
  }

  @override
  String reportReplyFailed(num id) {
    return '举报回复 #$id 失败';
  }

  @override
  String reportUserSuccess(num id) {
    return '已举报用户 #$id';
  }

  @override
  String reportUserFailed(num id) {
    return '举报用户 #$id 失败';
  }

  @override
  String reportPostSuccess(num id) {
    return '已举报帖子 #$id';
  }

  @override
  String reportPostFailed(num id) {
    return '举报帖子 #$id 失败';
  }

  @override
  String get reportTypeRequired => '类型不能为空';

  @override
  String get reportReason => '理由';

  @override
  String get reportReasonRequired => '理由不能为空';

  @override
  String get reportSubmitted => '已提交举报';

  @override
  String get reportSubmitFailed => '提交举报失败';

  @override
  String get reportTypeRating => '分级滥用';

  @override
  String get reportTypeFile => '恶意文件';

  @override
  String get reportTypeSource => '恶意来源';

  @override
  String get reportTypeDescription => '描述滥用';

  @override
  String get reportTypeNote => '注释滥用';

  @override
  String get reportTypeTagging => '标签滥用';

  @override
  String get reportTypeRatingBody => '该作品的分级被设置成了错误的值。';

  @override
  String get reportTypeFileBody => '文件中包含恶意代码或隐藏的文件压缩包。这与图像本身描绘的内容无关。';

  @override
  String get reportTypeSourceBody => '所列来源中有一个或多个指向恶意页面或付费内容。';

  @override
  String get reportTypeDescriptionBody => '描述中包含恶意内容，或被编辑加入了辱骂性内容。';

  @override
  String get reportTypeNoteBody => '该帖子的注释有误、带有骚扰性或存在其他滥用情况。';

  @override
  String get reportTypeTaggingBody => '该帖子存在一个或多个无效标签，或有一个或多个有效标签被移除。';

  @override
  String flagPostSuccess(num id) {
    return '已标记帖子 #$id';
  }

  @override
  String flagPostFailed(num id) {
    return '标记帖子 #$id 失败';
  }

  @override
  String get flagParentId => '父帖 ID';

  @override
  String get flagParentIdRequired => '父帖 ID 不能为空';

  @override
  String get flagParentIdInvalid => '父帖 ID 必须是数字';

  @override
  String get flagTypeUploadingGuidelines => '不符合上传准则';

  @override
  String get flagTypeYoungHuman => '露骨场景中的年轻类人角色';

  @override
  String get flagTypeDnpArtist => '该帖子的画师在禁止上传列表中';

  @override
  String get flagTypePayContent => '付费站、商业或订阅内容';

  @override
  String get flagTypeTrace => '对其他画师作品的描图';

  @override
  String get flagTypePreviouslyDeleted => '曾被删除';

  @override
  String get flagTypeRealPorn => '真人色情内容';

  @override
  String get flagTypeCorrupt => '文件已损坏、损毁或因其他原因无法正常使用';

  @override
  String get flagTypeInferior => '其他帖子的重复或较差版本';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      '该帖子未能达到站点标准，无论是艺术价值、图像质量、相关性还是其他方面。\n请注意，你的个人偏好与此无关。如果你觉得帖子内容令人不适，直接[[e621:blacklist|屏蔽]]即可。';

  @override
  String get flagTypeYoungHumanBody => '以色情或露骨裸露方式描绘人类及类人角色的帖子，在本站不被接受。';

  @override
  String get flagTypeDnpArtistBody =>
      '部分画师已要求不在本站发布其作品，并获得了[[avoid_posting|禁止上传]]状态。\n该状态有时附带条件；详情参见[[conditional_dnp]]';

  @override
  String get flagTypePayContentBody =>
      '本站不托管任何付费站或商业内容，包括 Patreon 泄露内容、盗版网站的转载等。';

  @override
  String get flagTypeTraceBody =>
      '描图自其他画师作品的图片在本站不被接受。参考其他作品没有问题，但直接照搬他人作品不行。\n请在评论中留下更多信息；如果原作品也托管在本站，也可以直接将其设为该帖子的父帖。';

  @override
  String get flagTypePreviouslyDeletedBody =>
      '帖子被移除通常都有充分的理由，重新上传已删除的内容是不被接受的。\n请在评论中留下更多信息，或者直接将原帖设为该帖子的父帖。';

  @override
  String get flagTypeRealPornBody =>
      '包含真人色情内容的帖子在本站不被接受，没有例外。\n请注意，非色情性质的真人照片是可以接受的。';

  @override
  String get flagTypeCorruptBody =>
      '该帖子存在无法正常工作的问题，可能是视频损坏，也可能是图像损坏。\n无论是哪种情况，为避免混淆，请在评论中说明具体情况。';

  @override
  String get flagTypeInferiorBody =>
      '站点上已存在该帖子的更优版本。\n这包括画质更好的图片（尺寸更大、压缩更少），也可能是修正了视觉错误后的“修正版”。\n请注意，编辑版和其他变体版本不属于此类。';

  @override
  String get taskCancelAll => '全部取消';

  @override
  String get taskClearDone => '清除已完成';

  @override
  String get taskClearSelection => '清除所选';

  @override
  String get taskCancel => '取消';

  @override
  String get taskDismiss => '忽略';

  @override
  String get taskNoTasks => '没有任务';

  @override
  String get taskFailedToLoadTasks => '任务加载失败';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个任务',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => '进行中';

  @override
  String get taskGroupFailed => '已失败';

  @override
  String get taskActionDownload => '下载';

  @override
  String get taskActionFavorite => '收藏';

  @override
  String get taskActionUnfavorite => '取消收藏';

  @override
  String get taskDownloadRunning => '正在下载';

  @override
  String get taskFavoriteRunning => '正在收藏';

  @override
  String get taskUnfavoriteRunning => '正在取消收藏';

  @override
  String get taskDownloadCompleted => '已下载';

  @override
  String get taskFavoriteCompleted => '已收藏';

  @override
  String get taskUnfavoriteCompleted => '已取消收藏';

  @override
  String taskQueuedTo(String action) {
    return '等待$action';
  }

  @override
  String taskFailedTo(String action) {
    return '$action失败';
  }

  @override
  String taskCanceledAction(String action) {
    return '已取消$action';
  }

  @override
  String taskTileTitle(String label, num id) {
    return '$label帖子 #$id';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个新帖子！',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => '新帖子！';

  @override
  String get followChannelName => '已关注标签';

  @override
  String get followChannelDescription => '你关注的标签的通知';

  @override
  String get hostUnavailableTitle => '站点不可用';

  @override
  String hostUnavailableBody(String host) {
    return '看起来 $host 不可用！';
  }

  @override
  String get hostUnavailableResolveHint =>
      '请在接下来的浏览器窗口中解决该问题。\n\nCloudflare 验证码 Cookie 将会被保存。';

  @override
  String get hostUnavailableResolve => '解决';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\n请等待 $host 方面解决该问题。';
  }

  @override
  String get downloadChooseFolder => '选择文件夹';

  @override
  String get searchFilterTitle => '筛选';

  @override
  String get searchFilterQueryLabel => '当前查询：';

  @override
  String get dtextParsingFailed => 'DText 解析失败';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => '載入失敗';

  @override
  String get nothingToSeeHere => '這裡什麼都沒有';

  @override
  String get loading => '載入中…';

  @override
  String get actionCancel => '取消';

  @override
  String get actionOk => '確定';

  @override
  String get actionTryAgain => '重試';

  @override
  String get actionDownload => '下載';

  @override
  String get actionImport => '匯入';

  @override
  String get actionExport => '匯出';

  @override
  String get actionUndo => '撤銷';

  @override
  String get actionRestartNow => '立即重新啟動';

  @override
  String get failedToLoadSuggestions => '建議載入失敗';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => '中止';

  @override
  String get actionSelectAll => '全選';

  @override
  String fileSavedAs(String name) {
    return '檔案已儲存為 $name';
  }

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get saveFile => '儲存檔案';

  @override
  String get filterTooltip => '篩選';

  @override
  String get rangeInvalidFormat => '格式無效';

  @override
  String itemProgress(num current, num total) {
    return '第 $current/$total 項';
  }

  @override
  String get taskCancelled => '已取消任務';

  @override
  String taskFailedAt(num index) {
    return '第 $index 項失敗';
  }

  @override
  String get taskDone => '完成';

  @override
  String get failedToInitialize => '初始化失敗';

  @override
  String get navHome => '首頁';

  @override
  String get navHot => '熱門';

  @override
  String get navSearch => '搜尋';

  @override
  String get navFavorites => '收藏';

  @override
  String get navTimeline => '時間軸';

  @override
  String get navSubscriptions => '訂閱';

  @override
  String get navBookmarks => '書籤';

  @override
  String get navPools => '圖集';

  @override
  String get navForum => '論壇';

  @override
  String get navHistory => '歷史';

  @override
  String get navTasks => '任務';

  @override
  String get navSettings => '設定';

  @override
  String get navAbout => '關於';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionAccount => '帳戶';

  @override
  String get sectionUser => '使用者';

  @override
  String get sectionAppearance => '外觀';

  @override
  String get sectionInteractions => '互動';

  @override
  String get sectionSecurity => '安全性';

  @override
  String get sectionDevelopment => '開發';

  @override
  String get settingsBlacklist => '黑名單';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已封鎖 $count 個標籤',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => '追蹤';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已追蹤 $count 個搜尋',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => '歷史';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已瀏覽 $count 個頁面',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => '主題';

  @override
  String get themeDark => '深色';

  @override
  String get themeAmoled => '純黑';

  @override
  String get themeLight => '淺色';

  @override
  String get themeBlue => '藍色';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get settingsLanguage => '語言';

  @override
  String get languageSystemDefault => '跟隨系統';

  @override
  String get settingsTileSize => '格子大小';

  @override
  String get settingsQuilt => '版面';

  @override
  String get gridTitle => '網格';

  @override
  String get quiltSquare => '方形格子';

  @override
  String get quiltVertical => '縱向延伸的格子';

  @override
  String get settingsPostInfo => '貼文資訊';

  @override
  String get postInfoShown => '在格子上顯示資訊';

  @override
  String get postInfoHidden => '僅顯示圖片';

  @override
  String get settingsDownloadLocation => '下載位置';

  @override
  String get settingsUpvoteFavorites => '收藏時按讚';

  @override
  String get upvoteFavoritesOn => '按讚並收藏';

  @override
  String get upvoteFavoritesOff => '僅收藏';

  @override
  String get settingsVideoVolume => '影片音量';

  @override
  String get videoMuted => '靜音';

  @override
  String get videoWithSound => '有聲音';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get settingsVideoResolution => '影片解析度';

  @override
  String get videoResStandard => '標準 (480p)';

  @override
  String get videoResHigh => '高 (720p)';

  @override
  String get videoResFull => '全高畫質 (1080p)';

  @override
  String get videoResUltra => '超高畫質 (4K)';

  @override
  String get videoResSource => '原始畫質';

  @override
  String get settingsSecureDisplay => '螢幕內容保護';

  @override
  String get secureDisplayOn => '隱藏螢幕內容';

  @override
  String get secureDisplayOff => '不隱藏螢幕內容';

  @override
  String get settingsIncognitoKeyboard => '無痕鍵盤';

  @override
  String get enabled => '已啟用';

  @override
  String get disabled => '已停用';

  @override
  String get settingsPinLock => 'PIN 鎖';

  @override
  String get pinEnabled => 'PIN 已啟用';

  @override
  String get pinDisabled => 'PIN 已停用';

  @override
  String get settingsBiometricLock => '生物辨識鎖';

  @override
  String get biometricsEnabled => '生物辨識已啟用';

  @override
  String get biometricsDisabled => '生物辨識已停用';

  @override
  String get settingsDeveloperMode => '開發者模式';

  @override
  String get devOptionsShown => '顯示開發者選項';

  @override
  String get devOptionsHidden => '隱藏開發者選項';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已記錄 $count 個錯誤',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => '資料庫';

  @override
  String get databaseExporting => '正在匯出資料庫…';

  @override
  String get databaseExported => '資料庫匯出成功';

  @override
  String get databaseExportFailed => '匯出失敗';

  @override
  String get databaseExport => '匯出';

  @override
  String get databaseImporting => '正在匯入資料庫…';

  @override
  String databaseInvalidFile(String error) {
    return '無效的資料庫檔案：$error';
  }

  @override
  String databaseImportFailed(String error) {
    return '匯入失敗：$error';
  }

  @override
  String get databaseImportTitle => '匯入資料庫';

  @override
  String get databaseRestartTitle => '需要重新啟動';

  @override
  String get databaseRestartBody => '應用程式需要重新啟動以套用變更。';

  @override
  String get databaseImport => '匯入';

  @override
  String get lockEnterPin => '輸入 PIN';

  @override
  String get lockEnterNewPin => '輸入新 PIN';

  @override
  String get lockConfirmNewPin => '確認新 PIN';

  @override
  String get lockFailedAuth => '驗證失敗';

  @override
  String get lockPleaseAuth => '請驗證身分';

  @override
  String get lockRetry => '重試';

  @override
  String get lockBiometricReason => '驗證以解鎖。';

  @override
  String get lockBiometricFailure => '生物辨識驗證發生嚴重錯誤';

  @override
  String get aboutVersion => '版本';

  @override
  String get updaterFetching => '正在檢查更新…';

  @override
  String get updaterCheckFailed => '檢查更新失敗';

  @override
  String get updaterNewest => '已是最新版本';

  @override
  String updaterNewer(String version) {
    return '有新版本可用：$version';
  }

  @override
  String get updaterNewerHeader => '有新版本可用：';

  @override
  String get aboutExperimentalPlatform => '實驗性平台';

  @override
  String get aboutExperimentalBody => '此平台不受支援，可能存在缺陷和功能缺失。';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => '上游專案';

  @override
  String get aboutUpstreamBody => '本應用程式是 clragon/e1547 的分支';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => '論壇';

  @override
  String aboutForumTopic(num id) {
    return 'e621 討論串 #$id';
  }

  @override
  String get aboutWebsite => '網站';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => '電子郵件';

  @override
  String get aboutPlaystore => 'Play 商店';

  @override
  String get aboutDonors => '捐贈者';

  @override
  String get aboutDonorsThanks => '感謝你們支持本專案的開發！';

  @override
  String get aboutNoDonors => '目前沒有捐贈者';

  @override
  String get aboutDonorsFailed => '取得捐贈者失敗';

  @override
  String get aboutDonorsNotListed => '不在名單上？請聯絡我們！';

  @override
  String get developerUnlocked => '你已成為開發者！';

  @override
  String get databaseErrorLoading => '資料庫載入錯誤';

  @override
  String get databaseUnknownSize => '未知';

  @override
  String get databaseExportTitle => '匯出資料庫';

  @override
  String get databaseExportSubtitle => '儲存資料庫備份副本';

  @override
  String get databaseImportSubtitle => '以匯入的資料庫取代目前資料庫';

  @override
  String get databaseImportWarning => '這將取代你目前的資料庫。\n所有資料都會遺失，且無法復原！';

  @override
  String get databaseExportSanitizedBody =>
      '匯出的檔案不會包含你的登入資訊和 API 金鑰。\n其餘內容（帳號、網站、歷史、關注和任務）都會包含。';

  @override
  String get databaseImportNewerFile => '此檔案由較新版本的應用程式建立，無法匯入。';

  @override
  String get databaseImportSanitized => '為安全起見，已從匯入的檔案中移除儲存的登入資訊。';

  @override
  String databaseImportHostsWarning(String hosts) {
    return '警告：匯入的檔案包含其他網站的帳號：$hosts';
  }

  @override
  String get databaseImportCancelled => '已取消匯入';

  @override
  String get postsTitle => '貼文';

  @override
  String favoritesOf(String user) {
    return '$user 的收藏';
  }

  @override
  String get favoritesUnavailable => '未登入使用者無法使用收藏';

  @override
  String get favoriteOrder => '收藏排序';

  @override
  String get orderAdded => '新增順序';

  @override
  String get orderId => 'ID 順序';

  @override
  String get postStateDeleted => '已刪除';

  @override
  String get postStateUnsupported => '不支援的類型';

  @override
  String get postStateUnavailable => '無法使用';

  @override
  String get menuShare => '分享';

  @override
  String get menuDownload => '下載';

  @override
  String get menuBrowse => '在瀏覽器中開啟';

  @override
  String get menuEdit => '編輯';

  @override
  String get menuComment => '評論';

  @override
  String get menuReport => '檢舉';

  @override
  String get menuFlag => '標記';

  @override
  String get actionOpen => '開啟';

  @override
  String get actionFollow => '追蹤';

  @override
  String get actionUnfollow => '取消追蹤';

  @override
  String get actionMute => '靜音';

  @override
  String get actionNotify => '通知';

  @override
  String get actionBookmark => '加入書籤';

  @override
  String get actionUnbookmark => '移除書籤';

  @override
  String get actionBlock => '封鎖';

  @override
  String get actionUnblock => '取消封鎖';

  @override
  String get actionRemove => '移除';

  @override
  String get actionAdd => '新增';

  @override
  String get actionSubtract => '排除';

  @override
  String selectionPost(num id) {
    return '貼文 #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則貼文',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => '沒有貼文';

  @override
  String get failedToLoadPosts => '貼文載入失敗';

  @override
  String get offlineBanner => '目前離線，正在顯示快取資料。';

  @override
  String get offlineNoData => '目前離線';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則貼文',
    );
    return '第 $page 頁 · $_temp0';
  }

  @override
  String get postListPageLimit => '已達伺服器頁數上限，請縮小搜尋範圍';

  @override
  String get postListJumpToPage => '跳轉頁面';

  @override
  String get postListJumpPageLabel => '頁碼';

  @override
  String postListJumpPageRange(Object max) {
    return '請輸入 1 到 $max 之間的頁碼';
  }

  @override
  String get postDeletedOverlay => '貼文已被刪除';

  @override
  String get postUnavailableOverlay => '貼文無法使用';

  @override
  String get postBlacklistedOverlay => '貼文已被封鎖';

  @override
  String unsupportedFileType(String ext) {
    return '不支援 $ext 檔案';
  }

  @override
  String get loginRequiredEdit => '必須登入才能編輯貼文！';

  @override
  String get loginRequiredComment => '必須登入才能評論！';

  @override
  String get loginRequiredReport => '必須登入才能檢舉貼文！';

  @override
  String get loginRequiredFlag => '必須登入才能標記貼文！';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已封鎖 $count 則貼文',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => '黑名單更新失敗！';

  @override
  String get blacklistAddTag => '新增標籤';

  @override
  String get blacklistEditTag => '編輯標籤';

  @override
  String get denylistEntryDeleted => '已移除黑名單條目';

  @override
  String get blacklistEmpty => '你的黑名單是空的';

  @override
  String get menuDelete => '刪除';

  @override
  String get filterScore => '評分';

  @override
  String get filterFavoriteCount => '收藏數';

  @override
  String get filterSortBy => '排序方式';

  @override
  String get filterNew => '最新';

  @override
  String get filterRank => '排名';

  @override
  String get filterRandom => '隨機';

  @override
  String get filterDefault => '預設';

  @override
  String get filterRating => '分級';

  @override
  String get filterSafe => '安全';

  @override
  String get filterQuestionable => '存疑';

  @override
  String get filterExplicit => '露骨';

  @override
  String get filterAll => '全部';

  @override
  String get filterPool => '圖集';

  @override
  String get filterHasPool => '含圖集';

  @override
  String get filterChild => '子貼文';

  @override
  String get filterIsChildPost => '是子貼文';

  @override
  String get filterParent => '父貼文';

  @override
  String get filterIsParentPost => '是父貼文';

  @override
  String get filterUploadDate => '上傳日期';

  @override
  String get filterLastDay => '最近一天';

  @override
  String get filterLastWeek => '最近一週';

  @override
  String get filterLastMonth => '最近一個月';

  @override
  String get filterLastYear => '最近一年';

  @override
  String get filterStatus => '狀態';

  @override
  String get filterActive => '活躍';

  @override
  String get filterPending => '待處理';

  @override
  String get filterDeleted => '已刪除';

  @override
  String get filterFlagged => '已標記';

  @override
  String get filterAny => '任意';

  @override
  String get filterFileType => '檔案類型';

  @override
  String get filterUploader => '上傳者';

  @override
  String get filterWidth => '寬度';

  @override
  String get filterHeight => '高度';

  @override
  String get filterTagCount => '標籤數';

  @override
  String get filterTrue => '是';

  @override
  String get filterFalse => '否';

  @override
  String get filterImages => '圖片';

  @override
  String get filterVideos => '影片';

  @override
  String get filterTitleContains => '標題包含';

  @override
  String get filterCategory => '分類';

  @override
  String get filterGeneral => '一般';

  @override
  String get filterSiteBugReports => '網站問題與功能請求';

  @override
  String get filterTagWikiProjects => '標籤/維基專案與提問';

  @override
  String get filterTagAliasSuggestions => '標籤別名與關聯建議';

  @override
  String get filterArtTalk => '藝術交流';

  @override
  String get filterOffTopic => '離題';

  @override
  String get filterE621Tools => 'e621 工具與應用程式';

  @override
  String get filterNewestFirst => '最新優先';

  @override
  String get filterOldestFirst => '最舊優先';

  @override
  String get filterSticky => '置頂';

  @override
  String get filterIsSticky => '已置頂';

  @override
  String get filterLocked => '已鎖定';

  @override
  String get filterIsLocked => '已鎖定';

  @override
  String get filterDescription => '描述';

  @override
  String get filterCreator => '建立者';

  @override
  String get filterIsActive => '活躍中';

  @override
  String get filterSeries => '系列';

  @override
  String get filterCollection => '合輯';

  @override
  String get filterName => '名稱';

  @override
  String get filterCreated => '建立時間';

  @override
  String get filterUpdated => '更新時間';

  @override
  String get filterPostCount => '貼文數';

  @override
  String postUpdateFailed(num id) {
    return '更新貼文 #$id 失敗';
  }

  @override
  String postUpdated(num id) {
    return '已更新貼文 #$id';
  }

  @override
  String get failedToLoadPost => '貼文載入失敗';

  @override
  String get postNotFound => '找不到貼文';

  @override
  String get commentsTitle => '評論';

  @override
  String commentsOfPost(num postId) {
    return '貼文 #$postId 的評論';
  }

  @override
  String get commentOrder => '評論排序';

  @override
  String get noComments => '沒有評論';

  @override
  String get failedToLoadComments => '評論載入失敗';

  @override
  String commentTitle(num id) {
    return '評論 #$id';
  }

  @override
  String get failedToLoadComment => '評論載入失敗';

  @override
  String get commentNotFound => '找不到評論';

  @override
  String commentEditorTitle(num postId) {
    return '貼文 #$postId 的評論';
  }

  @override
  String get commentSendFailed => '評論傳送失敗！';

  @override
  String get commentSent => '評論已傳送！';

  @override
  String get commentHidden => '此評論已隱藏';

  @override
  String commentUpvoteFailed(num id) {
    return '評論 #$id 按讚失敗';
  }

  @override
  String commentDownvoteFailed(num id) {
    return '評論 #$id 倒讚失敗';
  }

  @override
  String get commentLoginRequiredEdit => '必須登入才能編輯評論！';

  @override
  String get commentLoginRequiredReply => '必須登入才能回覆評論！';

  @override
  String get commentLoginRequiredReport => '必須登入才能檢舉評論！';

  @override
  String commentCopiedId(num id) {
    return '已複製評論 ID #$id';
  }

  @override
  String get warningUserWarned => '使用者因這則訊息收到警告';

  @override
  String get warningUserRecorded => '使用者因這則訊息被記過';

  @override
  String get warningUserBanned => '使用者因這則訊息被停權';

  @override
  String get repliesTitle => '回覆';

  @override
  String get replyOrder => '回覆排序';

  @override
  String get noReplies => '沒有回覆';

  @override
  String get failedToLoadReplies => '回覆載入失敗';

  @override
  String replyTitle(num id) {
    return '回覆 #$id';
  }

  @override
  String get failedToLoadReply => '回覆載入失敗';

  @override
  String get replyNotFound => '找不到回覆';

  @override
  String replyEditorTitle(num topicId) {
    return '討論串 #$topicId 的回覆';
  }

  @override
  String get replySendFailed => '回覆傳送失敗！';

  @override
  String get replySent => '回覆已傳送！';

  @override
  String get replyHidden => '此回覆已隱藏';

  @override
  String get replyLoginRequiredEdit => '必須登入才能編輯回覆！';

  @override
  String get replyLoginRequiredReply => '必須登入才能回覆！';

  @override
  String get replyLoginRequiredReport => '必須登入才能檢舉回覆！';

  @override
  String replyCopiedId(num id) {
    return '已複製回覆 ID #$id';
  }

  @override
  String get menuReply => '回覆';

  @override
  String get menuCopyId => '複製 ID';

  @override
  String get menuRefresh => '重新整理';

  @override
  String get actionCopy => '複製';

  @override
  String get actionSave => '儲存';

  @override
  String get actionShow => '顯示';

  @override
  String get actionHide => '隱藏';

  @override
  String get actionCannotBeUndone => '此操作無法復原。';

  @override
  String get info => '資訊';

  @override
  String wikiTitle(String idOrTitle) {
    return '維基 $idOrTitle';
  }

  @override
  String get failedToLoadWiki => '維基載入失敗';

  @override
  String get wikiNotFound => '找不到維基';

  @override
  String wikiCopiedId(num id) {
    return '已複製維基 ID #$id';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => '別名';

  @override
  String get wikiInfoCreated => '建立時間';

  @override
  String get wikiInfoUpdated => '更新時間';

  @override
  String get wikiInfoLocked => '鎖定';

  @override
  String get wikiInfoYes => '是';

  @override
  String get wikiInfoNo => '否';

  @override
  String userTitle(String idOrName) {
    return '使用者 $idOrName';
  }

  @override
  String get failedToLoadUser => '使用者載入失敗';

  @override
  String get userNotFound => '找不到使用者';

  @override
  String get userUploads => '上傳';

  @override
  String get userLoginRequiredReport => '必須登入才能檢舉使用者！';

  @override
  String get userComission => '委託';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => '加入時間';

  @override
  String get userRank => '等級';

  @override
  String get userPosts => '貼文';

  @override
  String get userEdits => '編輯';

  @override
  String get userFavorites => '收藏';

  @override
  String get userComments => '評論';

  @override
  String get userForum => '論壇';

  @override
  String userCopiedId(num id) {
    return '已複製使用者 ID #$id';
  }

  @override
  String get logsTitle => '記錄檔';

  @override
  String logsTitleDate(String date) {
    return '記錄檔 - $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 筆記錄',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個記錄檔案',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => '層級';

  @override
  String get logsRecording => '記錄';

  @override
  String get logsVerbose => '詳細記錄';

  @override
  String get logsVerboseAll => '記錄所有層級';

  @override
  String logsVerboseMinimum(String level) {
    return '$level 及以上';
  }

  @override
  String get logFilesTitle => '記錄檔案';

  @override
  String get failedToLoadLogFiles => '記錄檔案載入失敗！';

  @override
  String get noLogFiles => '沒有可用的記錄檔案！';

  @override
  String get logsLive => '即時';

  @override
  String get noLogs => '沒有記錄';

  @override
  String get failedToReadLog => '記錄檔讀取失敗';

  @override
  String get noErrorsLogged => '沒有已記錄的錯誤';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個錯誤',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => '所有記錄檔';

  @override
  String get logsDismissAll => '全部清除';

  @override
  String logsDeleteTitle(num count) {
    return '刪除 $count 個記錄檔案？';
  }

  @override
  String get identityAccounts => '帳戶';

  @override
  String get identityAdd => '新增帳戶';

  @override
  String get identityEdit => '編輯帳戶';

  @override
  String get identityRemoveTitle => '移除帳戶？';

  @override
  String get identityRemoveBody => '其所有資料將被永久移除，包括歷史和追蹤。';

  @override
  String get identityAnonymous => '匿名';

  @override
  String get identityDuplicate => '此網站和使用者名稱下已存在帳戶。';

  @override
  String identityLoginFailed(String reason) {
    return '登入失敗。\n$reason';
  }

  @override
  String get identityLoginCheckDetails => '請檢查網路連線和登入資訊';

  @override
  String get identitySite => '網站';

  @override
  String get identityHostRequired => '請輸入網站地址。';

  @override
  String get identityHostInvalid => '網站地址無效';

  @override
  String get identityHostReadOnly => '無法變更網站。如需使用其他網站，請新增帳戶。';

  @override
  String get identityUsernameLabel => '使用者名稱';

  @override
  String get identityUsernameRequired => '請輸入使用者名稱。';

  @override
  String get identityApikeyLabel => 'API 金鑰';

  @override
  String get identityApikeyHelp => '在哪裡能找到我的 API 金鑰？';

  @override
  String get identityApikeyRequired =>
      '必須提供 API 金鑰。\n例如 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'API 金鑰是由 A-z 和 0-9 中的 24 或 32 個字元組成的序列\n例如 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => '還沒有帳戶？在這裡註冊';

  @override
  String get identityHostHint => '你的帳戶和貼文所在的網站。';

  @override
  String get identitySignIn => '登入';

  @override
  String get identityGuest => '訪客';

  @override
  String get identityLogin => '登入';

  @override
  String get identityBrowseAnonymously => '匿名瀏覽';

  @override
  String identityConnecting(String host, String username) {
    return '正在以 $username 身分連線 $host…';
  }

  @override
  String identityActivateFailed(Object error) {
    return '啟用身分失敗：$error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return '啟用特性失敗：$error';
  }

  @override
  String get failedToLoadIdentities => '帳戶載入失敗';

  @override
  String get onboardingSkip => '略過';

  @override
  String get onboardingBack => '上一步';

  @override
  String get onboardingNext => '下一步';

  @override
  String onboardingWelcomeTitle(String app) {
    return '歡迎使用 $app';
  }

  @override
  String get onboardingWelcomeBody => '一款精緻的 booru 瀏覽器。';

  @override
  String get onboardingThemeTitle => '挑個外觀';

  @override
  String get onboardingThemeBody => '先試試看。之後隨時可以更換。';

  @override
  String get onboardingLoginTitle => '連結帳戶';

  @override
  String get onboardingLanguageTitle => '選擇語言';

  @override
  String get followAddToSubscriptions => '加入訂閱';

  @override
  String get followNoSubscriptions => '沒有訂閱';

  @override
  String get followFailedToLoadSubscriptions => '訂閱載入失敗';

  @override
  String get followAddToBookmarks => '加入書籤';

  @override
  String get followNoBookmarks => '沒有書籤';

  @override
  String get followFailedToLoadBookmarks => '書籤載入失敗';

  @override
  String get followUnseenPosts => '未讀貼文';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '將 $count 則貼文標記為已讀',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => '沒有未讀貼文';

  @override
  String get followShowUnseenFirst => '優先顯示未讀';

  @override
  String get followFilteringUnseen => '正在篩選未讀';

  @override
  String get followAllPostsShown => '顯示全部貼文';

  @override
  String get followForceSync => '強制同步';

  @override
  String get followSyncAllFollows => '同步全部追蹤';

  @override
  String followSyncingFollows(String progress) {
    return '正在同步追蹤… $progress';
  }

  @override
  String get followEditorTitle => '編輯追蹤';

  @override
  String get followSubscribe => '訂閱';

  @override
  String get followEditPrompt => '編輯追蹤';

  @override
  String get followTitlePrompt => '追蹤標題';

  @override
  String get followMarkAsRead => '標記為已讀';

  @override
  String get followDisableNotifications => '關閉通知';

  @override
  String get followEnableNotifications => '開啟通知';

  @override
  String get followRename => '重新命名';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label 則新貼文',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個追蹤',
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
      other: '$count 個條目',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已刪除 $count 條歷史記錄',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => '清空歷史';

  @override
  String get historyClearSubtitle => '刪除所有條目';

  @override
  String get historyClearConfirm => '清空歷史？';

  @override
  String get historyClearConfirmBody => '所有歷史條目將被永久刪除，此操作無法復原。';

  @override
  String get historyClearAction => '清空';

  @override
  String get historyLimit => '歷史上限';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return '啟用歷史上限後，超過 $amount 條或早於 $months 個月的條目將被自動刪除。';
  }

  @override
  String get historyLimitTitle => '限制歷史';

  @override
  String historyLimitOn(String amount, num months) {
    return '僅保留最近 $months 個月內且不超過 $amount 條的記錄。';
  }

  @override
  String get historyLimitOff => '歷史無上限';

  @override
  String get historyEntries => '條目';

  @override
  String get historyType => '類型';

  @override
  String get historyItems => '瀏覽';

  @override
  String get historySearches => '搜尋';

  @override
  String get historyWikis => '維基';

  @override
  String get historyUsers => '使用者';

  @override
  String get historyEmpty => '歷史記錄為空';

  @override
  String get historyFailedToLoad => '歷史載入失敗';

  @override
  String get historyNoDescription => '暫無描述';

  @override
  String get historyHotPosts => '熱門貼文';

  @override
  String historyLinkPost(num id) {
    return '貼文 #$id';
  }

  @override
  String historyLinkUser(num id) {
    return '使用者 #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return '維基 #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return '使用者 $id';
  }

  @override
  String historyLinkWikiByName(String id) {
    return '維基 $id';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type - $query';
  }

  @override
  String get historyWiki => '維基';

  @override
  String get poolEmpty => '沒有圖集';

  @override
  String get poolFailedToLoadPools => '圖集載入失敗';

  @override
  String get poolTitle => '圖集標題';

  @override
  String get poolInfoPosts => '貼文';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => '活躍狀態';

  @override
  String get poolInfoActive => '活躍';

  @override
  String get poolInfoInactive => '不活躍';

  @override
  String get poolInfoCreated => '建立時間';

  @override
  String get poolInfoUpdated => '更新時間';

  @override
  String poolCopiedId(num id) {
    return '已複製圖集 ID #$id';
  }

  @override
  String poolLink(num id) {
    return '圖集 #$id';
  }

  @override
  String get poolFailedToLoadPool => '圖集載入失敗';

  @override
  String get poolNotFound => '找不到圖集';

  @override
  String get poolOrder => '圖集排序';

  @override
  String get poolOldestFirst => '最舊優先';

  @override
  String get poolNewestFirst => '最新優先';

  @override
  String get poolReaderMode => '圖集閱讀模式';

  @override
  String get poolReaderLargeImages => '大圖';

  @override
  String get poolReaderNormalGrid => '普通網格';

  @override
  String get topicsTitle => '討論';

  @override
  String get topicHideTagEdits => '隱藏標籤編輯討論串';

  @override
  String get topicTagEditsHidden => '已隱藏';

  @override
  String get topicTagEditsVisible => '已顯示';

  @override
  String topicLink(num id) {
    return '討論串 #$id';
  }

  @override
  String get topicFailedToLoadTopic => '討論串載入失敗';

  @override
  String get topicNotFound => '找不到討論串';

  @override
  String get topicEmpty => '沒有討論串';

  @override
  String get topicFailedToLoadTopics => '討論串載入失敗';

  @override
  String get topicInfoReplies => '回覆';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return '已複製討論串 ID #$id';
  }

  @override
  String get topicInfoLocked => '已鎖定';

  @override
  String get topicInfoYes => '是';

  @override
  String get topicInfoNo => '否';

  @override
  String get topicInfoCreated => '建立時間';

  @override
  String get topicInfoUpdated => '更新時間';

  @override
  String get filterTags => '標籤';

  @override
  String get loginRequired => '必須登入才能執行此操作！';

  @override
  String get actionChooseIdentity => '選擇帳戶';

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String detailCommentsButton(num count) {
    return '評論（$count）';
  }

  @override
  String get detailFile => '檔案';

  @override
  String get detailSources => '來源';

  @override
  String get detailNoSources => '無來源';

  @override
  String get detailChildren => '子貼文';

  @override
  String get detailDeletion => '刪除原因';

  @override
  String get detailBlacklisted => '已封鎖';

  @override
  String get detailNoArtist => '無繪師';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則貼文',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return '已複製貼文 ID #$id';
  }

  @override
  String postUpvoteFailed(num id) {
    return '貼文 #$id 按讚失敗';
  }

  @override
  String postDownvoteFailed(num id) {
    return '貼文 #$id 倒讚失敗';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return '貼文 #$id 收藏失敗';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return '貼文 #$id 取消收藏失敗';
  }

  @override
  String get editorSection => '章節';

  @override
  String get editorQuote => '引用';

  @override
  String get editorCode => '程式碼';

  @override
  String get editorSpoiler => '劇透';

  @override
  String get editorBold => '粗體';

  @override
  String get editorItalic => '斜體';

  @override
  String get editorUnderlined => '底線';

  @override
  String get editorStrikethrough => '刪除線';

  @override
  String get editorPreviewPlaceholder => '你的文字會顯示在這裡';

  @override
  String get editorWrite => '撰寫';

  @override
  String get editorPreview => '預覽';

  @override
  String get editorTypeHere => '在此輸入…';

  @override
  String get tagNoTags => '沒有標籤';

  @override
  String get tagFailedToLoadTags => '標籤載入失敗';

  @override
  String get tagUnableToRetrieveWiki => '無法取得維基條目';

  @override
  String get tagNoWikiEntry => '沒有維基條目';

  @override
  String get tagCategoryGeneral => '一般';

  @override
  String get tagCategorySpecies => '物種';

  @override
  String get tagCategoryCharacter => '角色';

  @override
  String get tagCategoryCopyright => '版權';

  @override
  String get tagCategoryMeta => '中繼資訊';

  @override
  String get tagCategoryLore => '背景設定';

  @override
  String get tagCategoryArtist => '繪師';

  @override
  String get tagCategoryContributor => '貢獻者';

  @override
  String get tagCategoryInvalid => '無效';

  @override
  String editDescriptionTitle(num postId) {
    return '貼文 #$postId 的描述';
  }

  @override
  String get editDescriptionHint => '輸入貼文描述…';

  @override
  String get editInvalidNumber => '數字格式無效';

  @override
  String get editInvalidParent => '父貼文無效';

  @override
  String get editParentIdLabel => '父貼文 ID（可選）';

  @override
  String get editParentIdHint => '父貼文 ID';

  @override
  String get editReasonLabel => '編輯原因（可選）';

  @override
  String get editReasonHint => '你為什麼要編輯這個貼文？';

  @override
  String editSourcesTitle(num postId) {
    return '貼文 #$postId 的來源';
  }

  @override
  String get editTagsHint => '以空格分隔的標籤';

  @override
  String editTagPreviewFailed(String error) {
    return '標籤預覽載入失敗：$error';
  }

  @override
  String get editTagStatusNew => '新增';

  @override
  String get editTagStatusInvalid => '無效';

  @override
  String get editTagStatusEmpty => '空';

  @override
  String get editTagStatusUnderused => '冷門';

  @override
  String reportCommentSuccess(num id) {
    return '已檢舉評論 #$id';
  }

  @override
  String reportCommentFailed(num id) {
    return '檢舉評論 #$id 失敗';
  }

  @override
  String reportReplySuccess(num id) {
    return '已檢舉回覆 #$id';
  }

  @override
  String reportReplyFailed(num id) {
    return '檢舉回覆 #$id 失敗';
  }

  @override
  String reportUserSuccess(num id) {
    return '已檢舉使用者 #$id';
  }

  @override
  String reportUserFailed(num id) {
    return '檢舉使用者 #$id 失敗';
  }

  @override
  String reportPostSuccess(num id) {
    return '已檢舉貼文 #$id';
  }

  @override
  String reportPostFailed(num id) {
    return '檢舉貼文 #$id 失敗';
  }

  @override
  String get reportTypeRequired => '類型不能為空';

  @override
  String get reportReason => '理由';

  @override
  String get reportReasonRequired => '理由不能為空';

  @override
  String get reportSubmitted => '已送出檢舉';

  @override
  String get reportSubmitFailed => '送出檢舉失敗';

  @override
  String get reportTypeRating => '分級濫用';

  @override
  String get reportTypeFile => '惡意檔案';

  @override
  String get reportTypeSource => '惡意來源';

  @override
  String get reportTypeDescription => '描述濫用';

  @override
  String get reportTypeNote => '註釋濫用';

  @override
  String get reportTypeTagging => '標籤濫用';

  @override
  String get reportTypeRatingBody => '該作品的分級被設定成了錯誤的值。';

  @override
  String get reportTypeFileBody => '檔案中包含惡意程式碼或隱藏的檔案壓縮包。這與圖像本身描繪的內容無關。';

  @override
  String get reportTypeSourceBody => '所列來源中有一個或多個指向惡意頁面或付費內容。';

  @override
  String get reportTypeDescriptionBody => '描述中包含惡意內容，或被編輯加入了辱罵性內容。';

  @override
  String get reportTypeNoteBody => '該貼文的註釋有誤、帶有騷擾性或存在其他濫用情況。';

  @override
  String get reportTypeTaggingBody => '該貼文存在一個或多個無效標籤，或有一個或多個有效標籤被移除。';

  @override
  String flagPostSuccess(num id) {
    return '已標記貼文 #$id';
  }

  @override
  String flagPostFailed(num id) {
    return '標記貼文 #$id 失敗';
  }

  @override
  String get flagParentId => '父貼文 ID';

  @override
  String get flagParentIdRequired => '父貼文 ID 不能為空';

  @override
  String get flagParentIdInvalid => '父貼文 ID 必須是數字';

  @override
  String get flagTypeUploadingGuidelines => '不符合上傳準則';

  @override
  String get flagTypeYoungHuman => '露骨場景中的年輕類人角色';

  @override
  String get flagTypeDnpArtist => '該貼文的繪師在禁止上傳清單中';

  @override
  String get flagTypePayContent => '付費站、商業或訂閱內容';

  @override
  String get flagTypeTrace => '對其他繪師作品的描圖';

  @override
  String get flagTypePreviouslyDeleted => '曾被刪除';

  @override
  String get flagTypeRealPorn => '真人色情內容';

  @override
  String get flagTypeCorrupt => '檔案已損壞、損毀或因其他原因無法正常使用';

  @override
  String get flagTypeInferior => '其他貼文的重複或較差版本';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      '該貼文未能達到網站標準，無論是藝術價值、圖像品質、相關性還是其他方面。\n請注意，你的個人偏好與此無關。如果你覺得貼文內容令人不適，直接[[e621:blacklist|封鎖]]即可。';

  @override
  String get flagTypeYoungHumanBody => '以色情或露骨裸露方式描繪人類及類人角色的貼文，在本站不被接受。';

  @override
  String get flagTypeDnpArtistBody =>
      '部分繪師已要求不在本站發佈其作品，並取得了[[avoid_posting|禁止上傳]]狀態。\n該狀態有時附帶條件；詳情參見[[conditional_dnp]]';

  @override
  String get flagTypePayContentBody =>
      '本站不託管任何付費站或商業內容，包括 Patreon 外流內容、盜版網站的轉載等。';

  @override
  String get flagTypeTraceBody =>
      '描圖自其他繪師作品的圖片在本站不被接受。參考其他作品沒有問題，但直接照搬他人作品不行。\n請在評論中留下更多資訊；如果原作品也託管在本站，也可以直接將其設為該貼文的父貼文。';

  @override
  String get flagTypePreviouslyDeletedBody =>
      '貼文被移除通常都有充分的理由，重新上傳已刪除的內容是不被接受的。\n請在評論中留下更多資訊，或者直接將原貼文設為該貼文的父貼文。';

  @override
  String get flagTypeRealPornBody =>
      '包含真人色情內容的貼文在本站不被接受，沒有例外。\n請注意，非色情性質的真人照片是可以接受的。';

  @override
  String get flagTypeCorruptBody =>
      '該貼文存在無法正常運作的問題，可能是影片損壞，也可能是圖像損壞。\n無論是哪種情況，為避免混淆，請在評論中說明具體情況。';

  @override
  String get flagTypeInferiorBody =>
      '網站上已存在該貼文的更優版本。\n這包括畫質更好的圖片（尺寸更大、壓縮更少），也可能是修正了視覺錯誤後的「修正版」。\n請注意，編輯版和其他變體版本不屬於此類。';

  @override
  String get taskCancelAll => '全部取消';

  @override
  String get taskClearDone => '清除已完成';

  @override
  String get taskClearSelection => '清除所選';

  @override
  String get taskCancel => '取消';

  @override
  String get taskDismiss => '忽略';

  @override
  String get taskNoTasks => '沒有任務';

  @override
  String get taskFailedToLoadTasks => '任務載入失敗';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個任務',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => '進行中';

  @override
  String get taskGroupFailed => '已失敗';

  @override
  String get taskActionDownload => '下載';

  @override
  String get taskActionFavorite => '收藏';

  @override
  String get taskActionUnfavorite => '取消收藏';

  @override
  String get taskDownloadRunning => '正在下載';

  @override
  String get taskFavoriteRunning => '正在收藏';

  @override
  String get taskUnfavoriteRunning => '正在取消收藏';

  @override
  String get taskDownloadCompleted => '已下載';

  @override
  String get taskFavoriteCompleted => '已收藏';

  @override
  String get taskUnfavoriteCompleted => '已取消收藏';

  @override
  String taskQueuedTo(String action) {
    return '等待$action';
  }

  @override
  String taskFailedTo(String action) {
    return '$action失敗';
  }

  @override
  String taskCanceledAction(String action) {
    return '已取消$action';
  }

  @override
  String taskTileTitle(String label, num id) {
    return '$label貼文 #$id';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 則新貼文！',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => '新貼文！';

  @override
  String get followChannelName => '已追蹤標籤';

  @override
  String get followChannelDescription => '你追蹤的標籤的通知';

  @override
  String get hostUnavailableTitle => '網站無法使用';

  @override
  String hostUnavailableBody(String host) {
    return '看來 $host 無法使用！';
  }

  @override
  String get hostUnavailableResolveHint =>
      '請在接下來的瀏覽器視窗中解決該問題。\n\nCloudflare 驗證碼 Cookie 將會被儲存。';

  @override
  String get hostUnavailableResolve => '解決';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\n請等待 $host 方面解決該問題。';
  }

  @override
  String get downloadChooseFolder => '選擇資料夾';

  @override
  String get searchFilterTitle => '篩選';

  @override
  String get searchFilterQueryLabel => '當前查詢：';

  @override
  String get dtextParsingFailed => 'DText 解析失敗';
}
