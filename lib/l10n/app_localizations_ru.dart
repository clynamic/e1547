// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => 'Не удалось загрузить';

  @override
  String get nothingToSeeHere => 'Здесь ничего нет';

  @override
  String get loading => 'Загрузка…';

  @override
  String get actionCancel => 'ОТМЕНА';

  @override
  String get actionOk => 'ОК';

  @override
  String get actionTryAgain => 'Повторить';

  @override
  String get actionDownload => 'СКАЧАТЬ';

  @override
  String get actionImport => 'ИМПОРТ';

  @override
  String get actionExport => 'ЭКСПОРТ';

  @override
  String get actionUndo => 'Вернуть';

  @override
  String get actionRestartNow => 'ПЕРЕЗАПУСТИТЬ СЕЙЧАС';

  @override
  String get failedToLoadSuggestions => 'Не удалось загрузить предложения';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элемента',
      many: '$count элементов',
      few: '$count элемента',
      one: '$count элемент',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => 'Прервать';

  @override
  String get actionSelectAll => 'Выбрать всё';

  @override
  String fileSavedAs(String name) {
    return 'Файл сохранён как $name';
  }

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get saveFile => 'Сохранить файл';

  @override
  String get filterTooltip => 'Фильтр';

  @override
  String get rangeInvalidFormat => 'Неверный формат';

  @override
  String itemProgress(num current, num total) {
    return 'Элемент $current/$total';
  }

  @override
  String get taskCancelled => 'Задача отменена';

  @override
  String taskFailedAt(num index) {
    return 'Сбой на элементе $index';
  }

  @override
  String get taskDone => 'Готово';

  @override
  String get failedToInitialize => 'Не удалось инициализировать';

  @override
  String get navHome => 'Главная';

  @override
  String get navHot => 'Популярное';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get navTimeline => 'Лента';

  @override
  String get navSubscriptions => 'Подписки';

  @override
  String get navBookmarks => 'Закладки';

  @override
  String get navPools => 'Пулы';

  @override
  String get navForum => 'Форум';

  @override
  String get navHistory => 'История';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navAbout => 'О приложении';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionAccount => 'Аккаунт';

  @override
  String get sectionUser => 'Пользователь';

  @override
  String get sectionAppearance => 'Оформление';

  @override
  String get sectionInteractions => 'Взаимодействие';

  @override
  String get sectionSecurity => 'Безопасность';

  @override
  String get sectionDevelopment => 'Разработка';

  @override
  String get settingsBlacklist => 'Чёрный список';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'заблокировано $count тега',
      many: 'заблокировано $count тегов',
      few: 'заблокировано $count тега',
      one: 'заблокирован $count тег',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => 'Подписки';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подписки на поиск',
      many: '$count подписок на поиск',
      few: '$count подписки на поиск',
      one: '$count подписка на поиск',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => 'История';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'посещено $count страницы',
      many: 'посещено $count страниц',
      few: 'посещено $count страницы',
      one: 'посещена $count страница',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeBlue => 'Синяя';

  @override
  String get themeSystem => 'Системная';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get languageSystemDefault => 'Как в системе';

  @override
  String get settingsTileSize => 'Размер плиток';

  @override
  String get settingsQuilt => 'Вид сетки';

  @override
  String get gridTitle => 'Сетка';

  @override
  String get quiltSquare => 'квадратные плитки';

  @override
  String get quiltVertical => 'вертикально растянутые плитки';

  @override
  String get settingsPostInfo => 'Информация о постах';

  @override
  String get postInfoShown => 'информация на плитках';

  @override
  String get postInfoHidden => 'только изображения';

  @override
  String get settingsDownloadLocation => 'Папка для загрузок';

  @override
  String get settingsUpvoteFavorites => 'Оценивать избранное';

  @override
  String get upvoteFavoritesOn => 'плюс и в избранное';

  @override
  String get upvoteFavoritesOff => 'только в избранное';

  @override
  String get settingsVideoVolume => 'Громкость видео';

  @override
  String get videoMuted => 'без звука';

  @override
  String get videoWithSound => 'со звуком';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds с';
  }

  @override
  String get settingsVideoResolution => 'Разрешение видео';

  @override
  String get videoResStandard => 'Стандартное (480p)';

  @override
  String get videoResHigh => 'Высокое (720p)';

  @override
  String get videoResFull => 'Полное (1080p)';

  @override
  String get videoResUltra => 'Ультра (4K)';

  @override
  String get videoResSource => 'Оригинал';

  @override
  String get settingsSecureDisplay => 'Защита экрана';

  @override
  String get secureDisplayOn => 'экран защищён';

  @override
  String get secureDisplayOff => 'экран виден';

  @override
  String get settingsIncognitoKeyboard => 'Клавиатура инкогнито';

  @override
  String get enabled => 'включено';

  @override
  String get disabled => 'отключено';

  @override
  String get settingsPinLock => 'Блокировка PIN-кодом';

  @override
  String get pinEnabled => 'PIN включён';

  @override
  String get pinDisabled => 'PIN отключён';

  @override
  String get settingsBiometricLock => 'Биометрическая блокировка';

  @override
  String get biometricsEnabled => 'биометрия включена';

  @override
  String get biometricsDisabled => 'биометрия отключена';

  @override
  String get settingsDeveloperMode => 'Режим разработчика';

  @override
  String get devOptionsShown => 'опции показаны';

  @override
  String get devOptionsHidden => 'опции скрыты';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'записано $count ошибки',
      many: 'записано $count ошибок',
      few: 'записано $count ошибки',
      one: 'записана $count ошибка',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => 'База данных';

  @override
  String get databaseExporting => 'Экспорт базы данных…';

  @override
  String get databaseExported => 'База данных успешно экспортирована';

  @override
  String get databaseExportFailed => 'Не удалось экспортировать';

  @override
  String get databaseExport => 'Экспорт';

  @override
  String get databaseImporting => 'Импорт базы данных…';

  @override
  String databaseInvalidFile(String error) {
    return 'Недопустимый файл базы данных: $error';
  }

  @override
  String databaseImportFailed(String error) {
    return 'Не удалось импортировать: $error';
  }

  @override
  String get databaseImportTitle => 'Импорт базы данных';

  @override
  String get databaseRestartTitle => 'Требуется перезапуск';

  @override
  String get databaseRestartBody =>
      'Чтобы применить изменения, необходимо перезапустить приложение.';

  @override
  String get databaseImport => 'Импорт';

  @override
  String get lockEnterPin => 'Введите PIN';

  @override
  String get lockEnterNewPin => 'Введите новый PIN';

  @override
  String get lockConfirmNewPin => 'Подтвердите новый PIN';

  @override
  String get lockFailedAuth => 'Не удалось пройти аутентификацию';

  @override
  String get lockPleaseAuth => 'Пройдите аутентификацию';

  @override
  String get lockRetry => 'Повторить';

  @override
  String get lockBiometricReason => 'Разблокируйте с помощью аутентификации.';

  @override
  String get lockBiometricFailure =>
      'Критический сбой биометрической аутентификации';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get updaterFetching => 'Проверка обновлений…';

  @override
  String get updaterCheckFailed => 'Не удалось проверить обновления';

  @override
  String get updaterNewest => 'У вас последняя версия';

  @override
  String updaterNewer(String version) {
    return 'Доступна новая версия: $version';
  }

  @override
  String get updaterNewerHeader => 'Доступна новая версия: ';

  @override
  String get aboutExperimentalPlatform => 'Экспериментальная платформа';

  @override
  String get aboutExperimentalBody =>
      'Эта платформа не поддерживается. Возможны ошибки и отсутствие некоторых функций.';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => 'Исходный проект';

  @override
  String get aboutUpstreamBody => 'Это форк приложения clragon/e1547';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => 'Форум';

  @override
  String aboutForumTopic(num id) {
    return 'Тема на e621 #$id';
  }

  @override
  String get aboutWebsite => 'Веб-сайт';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => 'Эл. почта';

  @override
  String get aboutPlaystore => 'Play Маркет';

  @override
  String get aboutDonors => 'Донатеры';

  @override
  String get aboutDonorsThanks =>
      'Спасибо, что помогаете мне продолжать разработку!';

  @override
  String get aboutNoDonors => 'Донатеров пока нет';

  @override
  String get aboutDonorsFailed => 'Не удалось загрузить список донатеров';

  @override
  String get aboutDonorsNotListed => 'Нет в списке? Свяжитесь с нами!';

  @override
  String get developerUnlocked => 'Теперь вы разработчик!';

  @override
  String get databaseErrorLoading => 'Ошибка загрузки базы данных';

  @override
  String get databaseUnknownSize => 'Неизвестно';

  @override
  String get databaseExportTitle => 'Экспорт базы данных';

  @override
  String get databaseExportSubtitle => 'Сохранить резервную копию базы данных';

  @override
  String get databaseImportSubtitle =>
      'Заменить текущую базу данных импортированной';

  @override
  String get databaseImportWarning =>
      'Текущая база данных будет заменена.\nВсе данные будут потеряны. Это действие нельзя отменить!';

  @override
  String get databaseExportSanitizedBody =>
      'В экспортируемом файле не будет ваших логинов и API-ключей.\nВсе остальные данные, включая аккаунты, сайты, историю, подписки и задачи, будут сохранены.';

  @override
  String get databaseImportNewerFile =>
      'Этот файл создан более новой версией приложения и не может быть импортирован.';

  @override
  String get databaseImportSanitized =>
      'В целях безопасности сохранённые логины были удалены из импортированного файла.';

  @override
  String databaseImportHostsWarning(String hosts) {
    return 'Внимание: в импортированном файле есть аккаунты других сайтов: $hosts';
  }

  @override
  String get databaseImportCancelled => 'Импорт отменён';

  @override
  String get postsTitle => 'Посты';

  @override
  String favoritesOf(String user) {
    return 'Избранное пользователя $user';
  }

  @override
  String get favoritesUnavailable =>
      'Избранное недоступно для анонимных пользователей';

  @override
  String get favoriteOrder => 'Порядок избранного';

  @override
  String get orderAdded => 'по порядку добавления';

  @override
  String get orderId => 'по порядку ID';

  @override
  String get postStateDeleted => 'удалён';

  @override
  String get postStateUnsupported => 'не поддерживается';

  @override
  String get postStateUnavailable => 'недоступен';

  @override
  String get menuShare => 'Поделиться';

  @override
  String get menuDownload => 'Скачать';

  @override
  String get menuBrowse => 'Открыть в браузере';

  @override
  String get menuEdit => 'Редактировать';

  @override
  String get menuComment => 'Комментировать';

  @override
  String get menuReport => 'Пожаловаться';

  @override
  String get menuFlag => 'Отметить';

  @override
  String get actionOpen => 'Открыть';

  @override
  String get actionFollow => 'Подписаться';

  @override
  String get actionUnfollow => 'Отписаться';

  @override
  String get actionMute => 'Отключить уведомления';

  @override
  String get actionNotify => 'Уведомления';

  @override
  String get actionBookmark => 'В закладки';

  @override
  String get actionUnbookmark => 'Убрать из закладок';

  @override
  String get actionBlock => 'Заблокировать';

  @override
  String get actionUnblock => 'Разблокировать';

  @override
  String get actionRemove => 'Удалить';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get actionSubtract => 'Исключить';

  @override
  String selectionPost(num id) {
    return 'пост #$id';
  }

  @override
  String selectionPostsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поста',
      many: '$count постов',
      few: '$count поста',
      one: '$count пост',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => 'Нет постов';

  @override
  String get failedToLoadPosts => 'Не удалось загрузить посты';

  @override
  String get offlineBanner => 'Нет подключения. Показаны сохранённые данные.';

  @override
  String get offlineNoData => 'Нет подключения';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поста',
      many: '$count постов',
      few: '$count поста',
      one: '$count пост',
    );
    return 'Страница $page · $_temp0';
  }

  @override
  String get postListPageLimit =>
      'Достигнут лимит страниц сервера. Сузьте условия поиска.';

  @override
  String get postListJumpToPage => 'Перейти на страницу';

  @override
  String get postListJumpPageLabel => 'Номер страницы';

  @override
  String postListJumpPageRange(Object max) {
    return 'Введите номер страницы от 1 до $max';
  }

  @override
  String get postDeletedOverlay => 'Пост удалён';

  @override
  String get postUnavailableOverlay => 'Пост недоступен';

  @override
  String get postBlacklistedOverlay => 'Пост в чёрном списке';

  @override
  String unsupportedFileType(String ext) {
    return 'Файлы $ext не поддерживаются';
  }

  @override
  String get loginRequiredEdit =>
      'Чтобы редактировать посты, необходимо войти!';

  @override
  String get loginRequiredComment =>
      'Чтобы оставлять комментарии, необходимо войти!';

  @override
  String get loginRequiredReport =>
      'Чтобы жаловаться на посты, необходимо войти!';

  @override
  String get loginRequiredFlag => 'Чтобы помечать посты, необходимо войти!';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'заблокировано $count поста',
      many: 'заблокировано $count постов',
      few: 'заблокировано $count поста',
      one: 'заблокирован $count пост',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => 'Не удалось обновить чёрный список!';

  @override
  String get blacklistAddTag => 'Добавить тег';

  @override
  String get blacklistEditTag => 'Изменить тег';

  @override
  String get denylistEntryDeleted => 'Запись чёрного списка удалена';

  @override
  String get blacklistEmpty => 'Ваш чёрный список пуст';

  @override
  String get menuDelete => 'Удалить';

  @override
  String get filterScore => 'Оценка';

  @override
  String get filterFavoriteCount => 'Число избранных';

  @override
  String get filterSortBy => 'Сортировка';

  @override
  String get filterNew => 'Новые';

  @override
  String get filterRank => 'Ранг';

  @override
  String get filterRandom => 'Случайно';

  @override
  String get filterDefault => 'По умолчанию';

  @override
  String get filterRating => 'Рейтинг';

  @override
  String get filterSafe => 'Безопасный';

  @override
  String get filterQuestionable => 'Спорный';

  @override
  String get filterExplicit => 'Откровенный';

  @override
  String get filterAll => 'Все';

  @override
  String get filterPool => 'Пул';

  @override
  String get filterHasPool => 'Есть пул';

  @override
  String get filterChild => 'Дочерний';

  @override
  String get filterIsChildPost => 'Дочерний пост';

  @override
  String get filterParent => 'Родительский';

  @override
  String get filterIsParentPost => 'Родительский пост';

  @override
  String get filterUploadDate => 'Дата загрузки';

  @override
  String get filterLastDay => 'За сутки';

  @override
  String get filterLastWeek => 'За неделю';

  @override
  String get filterLastMonth => 'За месяц';

  @override
  String get filterLastYear => 'За год';

  @override
  String get filterStatus => 'Статус';

  @override
  String get filterActive => 'Активные';

  @override
  String get filterPending => 'На проверке';

  @override
  String get filterDeleted => 'Удалённые';

  @override
  String get filterFlagged => 'Помеченные';

  @override
  String get filterAny => 'Любой';

  @override
  String get filterFileType => 'Тип файла';

  @override
  String get filterUploader => 'Автор загрузки';

  @override
  String get filterWidth => 'Ширина';

  @override
  String get filterHeight => 'Высота';

  @override
  String get filterTagCount => 'Количество тегов';

  @override
  String get filterTrue => 'Да';

  @override
  String get filterFalse => 'Нет';

  @override
  String get filterImages => 'Изображения';

  @override
  String get filterVideos => 'Видео';

  @override
  String get filterTitleContains => 'Заголовок содержит';

  @override
  String get filterCategory => 'Категория';

  @override
  String get filterGeneral => 'Общие';

  @override
  String get filterSiteBugReports => 'Баг-репорты и запросы функций';

  @override
  String get filterTagWikiProjects => 'Проекты и вопросы по тегам/вики';

  @override
  String get filterTagAliasSuggestions =>
      'Предложения по алиасам и связям тегов';

  @override
  String get filterArtTalk => 'Обсуждение артов';

  @override
  String get filterOffTopic => 'Оффтоп';

  @override
  String get filterE621Tools => 'Инструменты и приложения e621';

  @override
  String get filterNewestFirst => 'Сначала новые';

  @override
  String get filterOldestFirst => 'Сначала старые';

  @override
  String get filterSticky => 'Закреплено';

  @override
  String get filterIsSticky => 'Закреплено';

  @override
  String get filterLocked => 'Закрыто';

  @override
  String get filterIsLocked => 'Закрыто';

  @override
  String get filterDescription => 'Описание';

  @override
  String get filterCreator => 'Создатель';

  @override
  String get filterIsActive => 'Активные';

  @override
  String get filterSeries => 'Серия';

  @override
  String get filterCollection => 'Коллекция';

  @override
  String get filterName => 'Название';

  @override
  String get filterCreated => 'Дата создания';

  @override
  String get filterUpdated => 'Дата обновления';

  @override
  String get filterPostCount => 'Количество постов';

  @override
  String postUpdateFailed(num id) {
    return 'Не удалось обновить пост #$id';
  }

  @override
  String postUpdated(num id) {
    return 'Пост #$id обновлён';
  }

  @override
  String get failedToLoadPost => 'Не удалось загрузить пост';

  @override
  String get postNotFound => 'Пост не найден';

  @override
  String get commentsTitle => 'Комментарии';

  @override
  String commentsOfPost(num postId) {
    return 'Комментарии к посту #$postId';
  }

  @override
  String get commentOrder => 'Порядок комментариев';

  @override
  String get noComments => 'Нет комментариев';

  @override
  String get failedToLoadComments => 'Не удалось загрузить комментарии';

  @override
  String commentTitle(num id) {
    return 'Комментарий #$id';
  }

  @override
  String get failedToLoadComment => 'Не удалось загрузить комментарий';

  @override
  String get commentNotFound => 'Комментарий не найден';

  @override
  String commentEditorTitle(num postId) {
    return 'Комментарий к посту #$postId';
  }

  @override
  String get commentSendFailed => 'Не удалось отправить комментарий!';

  @override
  String get commentSent => 'Комментарий отправлен!';

  @override
  String get commentHidden => 'Этот комментарий скрыт';

  @override
  String commentUpvoteFailed(num id) {
    return 'Не удалось повысить оценку комментария #$id';
  }

  @override
  String commentDownvoteFailed(num id) {
    return 'Не удалось понизить оценку комментария #$id';
  }

  @override
  String get commentLoginRequiredEdit =>
      'Чтобы редактировать комментарии, необходимо войти!';

  @override
  String get commentLoginRequiredReply =>
      'Чтобы отвечать на комментарии, необходимо войти!';

  @override
  String get commentLoginRequiredReport =>
      'Чтобы жаловаться на комментарии, необходимо войти!';

  @override
  String commentCopiedId(num id) {
    return 'Скопирован ID комментария #$id';
  }

  @override
  String get warningUserWarned =>
      'Пользователь получил предупреждение за это сообщение';

  @override
  String get warningUserRecorded =>
      'Пользователь получил запись за это сообщение';

  @override
  String get warningUserBanned => 'Пользователь забанен за это сообщение';

  @override
  String get repliesTitle => 'Ответы';

  @override
  String get replyOrder => 'Порядок ответов';

  @override
  String get noReplies => 'Нет ответов';

  @override
  String get failedToLoadReplies => 'Не удалось загрузить ответы';

  @override
  String replyTitle(num id) {
    return 'Ответ #$id';
  }

  @override
  String get failedToLoadReply => 'Не удалось загрузить ответ';

  @override
  String get replyNotFound => 'Ответ не найден';

  @override
  String replyEditorTitle(num topicId) {
    return 'Ответ в теме #$topicId';
  }

  @override
  String get replySendFailed => 'Не удалось отправить ответ!';

  @override
  String get replySent => 'Ответ отправлен!';

  @override
  String get replyHidden => 'Этот ответ скрыт';

  @override
  String get replyLoginRequiredEdit =>
      'Чтобы редактировать ответы, необходимо войти!';

  @override
  String get replyLoginRequiredReply => 'Чтобы отвечать, необходимо войти!';

  @override
  String get replyLoginRequiredReport =>
      'Чтобы жаловаться на ответы, необходимо войти!';

  @override
  String replyCopiedId(num id) {
    return 'Скопирован ID ответа #$id';
  }

  @override
  String get menuReply => 'Ответить';

  @override
  String get menuCopyId => 'Копировать ID';

  @override
  String get menuRefresh => 'Обновить';

  @override
  String get actionCopy => 'Копировать';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionShow => 'Показать';

  @override
  String get actionHide => 'Скрыть';

  @override
  String get actionCannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get info => 'Информация';

  @override
  String wikiTitle(String idOrTitle) {
    return 'Вики $idOrTitle';
  }

  @override
  String get failedToLoadWiki => 'Не удалось загрузить вики';

  @override
  String get wikiNotFound => 'Вики не найдено';

  @override
  String wikiCopiedId(num id) {
    return 'Скопирован ID вики #$id';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => 'алиас';

  @override
  String get wikiInfoCreated => 'создано';

  @override
  String get wikiInfoUpdated => 'обновлено';

  @override
  String get wikiInfoLocked => 'заблокировано';

  @override
  String get wikiInfoYes => 'да';

  @override
  String get wikiInfoNo => 'нет';

  @override
  String userTitle(String idOrName) {
    return 'Пользователь $idOrName';
  }

  @override
  String get failedToLoadUser => 'Не удалось загрузить пользователя';

  @override
  String get userNotFound => 'Пользователь не найден';

  @override
  String get userUploads => 'Загрузки';

  @override
  String get userLoginRequiredReport =>
      'Чтобы жаловаться на пользователей, необходимо войти!';

  @override
  String get userComission => 'Коммишены';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => 'дата регистрации';

  @override
  String get userRank => 'ранг';

  @override
  String get userPosts => 'посты';

  @override
  String get userEdits => 'правки';

  @override
  String get userFavorites => 'избранное';

  @override
  String get userComments => 'комментарии';

  @override
  String get userForum => 'форум';

  @override
  String userCopiedId(num id) {
    return 'Скопирован ID пользователя #$id';
  }

  @override
  String get logsTitle => 'Логи';

  @override
  String logsTitleDate(String date) {
    return 'Логи — $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count лога',
      many: '$count логов',
      few: '$count лога',
      one: '$count лог',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файла логов',
      many: '$count файлов логов',
      few: '$count файла логов',
      one: '$count файл логов',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => 'Уровни';

  @override
  String get logsRecording => 'Запись';

  @override
  String get logsVerbose => 'Детализация';

  @override
  String get logsVerboseAll => 'записываются все уровни';

  @override
  String logsVerboseMinimum(String level) {
    return '$level и выше';
  }

  @override
  String get logFilesTitle => 'Файлы логов';

  @override
  String get failedToLoadLogFiles => 'Не удалось загрузить файлы логов!';

  @override
  String get noLogFiles => 'Нет доступных файлов логов!';

  @override
  String get logsLive => 'В реальном времени';

  @override
  String get noLogs => 'Нет логов';

  @override
  String get failedToReadLog => 'Не удалось прочитать лог';

  @override
  String get noErrorsLogged => 'Ошибок не записано';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ошибки',
      many: '$count ошибок',
      few: '$count ошибки',
      one: '$count ошибка',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => 'Все логи';

  @override
  String get logsDismissAll => 'Скрыть все';

  @override
  String logsDeleteTitle(num count) {
    return 'Удалить файлы логов ($count)?';
  }

  @override
  String get identityAccounts => 'Аккаунты';

  @override
  String get identityAdd => 'Добавить аккаунт';

  @override
  String get identityEdit => 'Изменить аккаунт';

  @override
  String get identityRemoveTitle => 'Удалить аккаунт?';

  @override
  String get identityRemoveBody =>
      'Все его данные будут удалены безвозвратно, включая историю и подписки.';

  @override
  String get identityAnonymous => 'Аноним';

  @override
  String get identityDuplicate =>
      'У вас уже есть аккаунт с этим сайтом и именем пользователя.';

  @override
  String identityLoginFailed(String reason) {
    return 'Не удалось войти.\n$reason';
  }

  @override
  String get identityLoginCheckDetails =>
      'Проверьте сетевое подключение и данные для входа';

  @override
  String get identitySite => 'Сайт';

  @override
  String get identityHostRequired => 'Укажите URL сайта.';

  @override
  String get identityHostInvalid => 'Недопустимый URL сайта';

  @override
  String get identityHostReadOnly =>
      'Сайт нельзя изменить. Чтобы использовать другой, добавьте новый аккаунт.';

  @override
  String get identityUsernameLabel => 'Имя пользователя';

  @override
  String get identityUsernameRequired => 'Укажите имя пользователя.';

  @override
  String get identityApikeyLabel => 'API-ключ';

  @override
  String get identityApikeyHelp => 'Где найти мой API-ключ?';

  @override
  String get identityApikeyRequired =>
      'Необходимо указать API-ключ.\nнапример 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'API-ключ — это последовательность из 24 или 32 символов A-z и 0-9\nнапример 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => 'Нет аккаунта? Зарегистрируйтесь здесь';

  @override
  String get identityHostHint =>
      'Сайт, на котором находятся ваш аккаунт и посты.';

  @override
  String get identitySignIn => 'Войти';

  @override
  String get identityGuest => 'Гость';

  @override
  String get identityLogin => 'Войти';

  @override
  String get identityBrowseAnonymously => 'Анонимный просмотр';

  @override
  String identityConnecting(String host, String username) {
    return 'Подключение к $host как $username…';
  }

  @override
  String identityActivateFailed(Object error) {
    return 'Не удалось активировать аккаунт: $error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return 'Не удалось активировать настройки: $error';
  }

  @override
  String get failedToLoadIdentities => 'Не удалось загрузить аккаунты';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingNext => 'Далее';

  @override
  String onboardingWelcomeTitle(String app) {
    return 'Добро пожаловать в $app';
  }

  @override
  String get onboardingWelcomeBody => 'Продвинутый booru-браузер.';

  @override
  String get onboardingThemeTitle => 'Выберите внешний вид';

  @override
  String get onboardingThemeBody =>
      'Попробуйте разные варианты. Позже их всегда можно изменить.';

  @override
  String get onboardingLoginTitle => 'Подключите аккаунт';

  @override
  String get onboardingLanguageTitle => 'Выберите язык';

  @override
  String get followAddToSubscriptions => 'Добавить в подписки';

  @override
  String get followNoSubscriptions => 'Нет подписок';

  @override
  String get followFailedToLoadSubscriptions => 'Не удалось загрузить подписки';

  @override
  String get followAddToBookmarks => 'Добавить в закладки';

  @override
  String get followNoBookmarks => 'Нет закладок';

  @override
  String get followFailedToLoadBookmarks => 'Не удалось загрузить закладки';

  @override
  String get followUnseenPosts => 'непрочитанные посты';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'отметить $count поста как прочитанные',
      many: 'отметить $count постов как прочитанные',
      few: 'отметить $count поста как прочитанные',
      one: 'отметить $count пост как прочитанный',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => 'нет непрочитанных постов';

  @override
  String get followShowUnseenFirst => 'сначала непрочитанные';

  @override
  String get followFilteringUnseen => 'показаны только непрочитанные';

  @override
  String get followAllPostsShown => 'показаны все посты';

  @override
  String get followForceSync => 'Принудительная синхронизация';

  @override
  String get followSyncAllFollows => 'синхронизировать все подписки';

  @override
  String followSyncingFollows(String progress) {
    return 'синхронизация подписок… $progress';
  }

  @override
  String get followEditorTitle => 'Редактировать подписки';

  @override
  String get followSubscribe => 'Подписаться';

  @override
  String get followEditPrompt => 'Редактировать подписку';

  @override
  String get followTitlePrompt => 'Название подписки';

  @override
  String get followMarkAsRead => 'Отметить как прочитанное';

  @override
  String get followDisableNotifications => 'Отключить уведомления';

  @override
  String get followEnableNotifications => 'Включить уведомления';

  @override
  String get followRename => 'Переименовать';

  @override
  String followNewPosts(num count, String label) {
    return 'Новых постов: $label';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подписки',
      many: '$count подписок',
      few: '$count подписки',
      one: '$count подписка',
    );
    return '$_temp0';
  }

  @override
  String followAlias(String? alias) {
    return 'алиас $alias';
  }

  @override
  String historySelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи истории удалены',
      many: '$count записей истории удалены',
      few: '$count записи истории удалены',
      one: 'Запись истории удалена',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => 'Очистить историю';

  @override
  String get historyClearSubtitle => 'Удалить все записи';

  @override
  String get historyClearConfirm => 'Очистить историю?';

  @override
  String get historyClearConfirmBody =>
      'Все записи истории будут удалены безвозвратно. Это действие нельзя отменить.';

  @override
  String get historyClearAction => 'Очистить';

  @override
  String get historyLimit => 'Ограничение истории';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return 'При включении ограничения истории все записи сверх $amount и все записи старше $months месяцев удаляются автоматически.';
  }

  @override
  String get historyLimitTitle => 'Ограничить историю';

  @override
  String historyLimitOn(String amount, num months) {
    return 'Сохраняются записи не старше $months месяцев и не более $amount записей.';
  }

  @override
  String get historyLimitOff => 'история не ограничена';

  @override
  String get historyEntries => 'Записи';

  @override
  String get historyType => 'Тип';

  @override
  String get historyItems => 'Просмотры';

  @override
  String get historySearches => 'Поиски';

  @override
  String get historyWikis => 'Вики';

  @override
  String get historyUsers => 'Пользователи';

  @override
  String get historyEmpty => 'История пуста';

  @override
  String get historyFailedToLoad => 'Не удалось загрузить историю';

  @override
  String get historyNoDescription => 'нет описания';

  @override
  String get historyHotPosts => 'Популярные посты';

  @override
  String historyLinkPost(num id) {
    return 'Пост #$id';
  }

  @override
  String historyLinkUser(num id) {
    return 'Пользователь #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return 'Вики #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return 'Пользователь $id';
  }

  @override
  String historyLinkWikiByName(String id) {
    return 'Вики $id';
  }

  @override
  String historySearchQuery(String type, String query) {
    return '$type - $query';
  }

  @override
  String get historyWiki => 'Вики';

  @override
  String get poolEmpty => 'Нет пулов';

  @override
  String get poolFailedToLoadPools => 'Не удалось загрузить пулы';

  @override
  String get poolTitle => 'Название пула';

  @override
  String get poolInfoPosts => 'посты';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => 'активность';

  @override
  String get poolInfoActive => 'активен';

  @override
  String get poolInfoInactive => 'неактивен';

  @override
  String get poolInfoCreated => 'создан';

  @override
  String get poolInfoUpdated => 'обновлён';

  @override
  String poolCopiedId(num id) {
    return 'Скопирован ID пула #$id';
  }

  @override
  String poolLink(num id) {
    return 'Пул #$id';
  }

  @override
  String get poolFailedToLoadPool => 'Не удалось загрузить пул';

  @override
  String get poolNotFound => 'Пул не найден';

  @override
  String get poolOrder => 'Порядок пула';

  @override
  String get poolOldestFirst => 'Сначала старые';

  @override
  String get poolNewestFirst => 'Сначала новые';

  @override
  String get poolReaderMode => 'Режим чтения пула';

  @override
  String get poolReaderLargeImages => 'большие изображения';

  @override
  String get poolReaderNormalGrid => 'обычная сетка';

  @override
  String get topicsTitle => 'Темы';

  @override
  String get topicHideTagEdits => 'Скрыть правки тегов';

  @override
  String get topicTagEditsHidden => 'скрыты';

  @override
  String get topicTagEditsVisible => 'видны';

  @override
  String topicLink(num id) {
    return 'Тема #$id';
  }

  @override
  String get topicFailedToLoadTopic => 'Не удалось загрузить тему';

  @override
  String get topicNotFound => 'Тема не найдена';

  @override
  String get topicEmpty => 'Нет тем';

  @override
  String get topicFailedToLoadTopics => 'Не удалось загрузить темы';

  @override
  String get topicInfoReplies => 'ответы';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return 'Скопирован ID темы #$id';
  }

  @override
  String get topicInfoLocked => 'закрыта';

  @override
  String get topicInfoYes => 'да';

  @override
  String get topicInfoNo => 'нет';

  @override
  String get topicInfoCreated => 'создана';

  @override
  String get topicInfoUpdated => 'обновлена';

  @override
  String get filterTags => 'Теги';

  @override
  String get loginRequired => 'Для этого действия необходимо войти.';

  @override
  String get actionChooseIdentity => 'Выбрать аккаунт';

  @override
  String get dateToday => 'Сегодня';

  @override
  String get dateYesterday => 'Вчера';

  @override
  String detailCommentsButton(num count) {
    return 'Комментарии ($count)';
  }

  @override
  String get detailFile => 'Файл';

  @override
  String get detailSources => 'Источники';

  @override
  String get detailNoSources => 'нет источников';

  @override
  String get detailChildren => 'Дочерние';

  @override
  String get detailDeletion => 'Причина удаления';

  @override
  String get detailBlacklisted => 'В чёрном списке';

  @override
  String get detailNoArtist => 'без художника';

  @override
  String detailPoolPosts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поста',
      many: '$count постов',
      few: '$count поста',
      one: '$count пост',
    );
    return '$_temp0';
  }

  @override
  String postCopiedId(num id) {
    return 'Скопирован ID поста #$id';
  }

  @override
  String postUpvoteFailed(num id) {
    return 'Не удалось повысить оценку поста #$id';
  }

  @override
  String postDownvoteFailed(num id) {
    return 'Не удалось понизить оценку поста #$id';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return 'Не удалось добавить пост #$id в избранное';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return 'Не удалось убрать пост #$id из избранного';
  }

  @override
  String get editorSection => 'Раздел';

  @override
  String get editorQuote => 'Цитата';

  @override
  String get editorCode => 'Код';

  @override
  String get editorSpoiler => 'Спойлер';

  @override
  String get editorBold => 'Жирный';

  @override
  String get editorItalic => 'Курсив';

  @override
  String get editorUnderlined => 'Подчёркнутый';

  @override
  String get editorStrikethrough => 'Зачёркнутый';

  @override
  String get editorPreviewPlaceholder => 'Здесь будет ваш текст';

  @override
  String get editorWrite => 'Написать';

  @override
  String get editorPreview => 'Предпросмотр';

  @override
  String get editorTypeHere => 'Введите здесь…';

  @override
  String get tagNoTags => 'нет тегов';

  @override
  String get tagFailedToLoadTags => 'Не удалось загрузить теги';

  @override
  String get tagUnableToRetrieveWiki => 'не удалось получить вики-запись';

  @override
  String get tagNoWikiEntry => 'нет вики-записи';

  @override
  String get tagCategoryGeneral => 'Общие';

  @override
  String get tagCategorySpecies => 'Виды';

  @override
  String get tagCategoryCharacter => 'Персонажи';

  @override
  String get tagCategoryCopyright => 'Копирайт';

  @override
  String get tagCategoryMeta => 'Мета';

  @override
  String get tagCategoryLore => 'Лор';

  @override
  String get tagCategoryArtist => 'Художники';

  @override
  String get tagCategoryContributor => 'Контрибьюторы';

  @override
  String get tagCategoryInvalid => 'Неверные';

  @override
  String editDescriptionTitle(num postId) {
    return 'Описание поста #$postId';
  }

  @override
  String get editDescriptionHint => 'Введите описание поста…';

  @override
  String get editInvalidNumber => 'Неверный формат числа';

  @override
  String get editInvalidParent => 'Неверный родительский пост';

  @override
  String get editParentIdLabel => 'ID родителя (необязательно)';

  @override
  String get editParentIdHint => 'ID родительского поста';

  @override
  String get editReasonLabel => 'Причина правки (необязательно)';

  @override
  String get editReasonHint => 'Зачем вы редактируете этот пост?';

  @override
  String editSourcesTitle(num postId) {
    return 'Источники поста #$postId';
  }

  @override
  String get editTagsHint => 'теги через пробел';

  @override
  String editTagPreviewFailed(String error) {
    return 'Ошибка загрузки предпросмотра тега: $error';
  }

  @override
  String get editTagStatusNew => 'новый';

  @override
  String get editTagStatusInvalid => 'неверный';

  @override
  String get editTagStatusEmpty => 'пустой';

  @override
  String get editTagStatusUnderused => 'редко используемый';

  @override
  String reportCommentSuccess(num id) {
    return 'Отправлена жалоба на комментарий #$id';
  }

  @override
  String reportCommentFailed(num id) {
    return 'Не удалось отправить жалобу на комментарий #$id';
  }

  @override
  String reportReplySuccess(num id) {
    return 'Отправлена жалоба на ответ #$id';
  }

  @override
  String reportReplyFailed(num id) {
    return 'Не удалось отправить жалобу на ответ #$id';
  }

  @override
  String reportUserSuccess(num id) {
    return 'Отправлена жалоба на пользователя #$id';
  }

  @override
  String reportUserFailed(num id) {
    return 'Не удалось отправить жалобу на пользователя #$id';
  }

  @override
  String reportPostSuccess(num id) {
    return 'Отправлена жалоба на пост #$id';
  }

  @override
  String reportPostFailed(num id) {
    return 'Не удалось отправить жалобу на пост #$id';
  }

  @override
  String get reportTypeRequired => 'Тип не может быть пустым';

  @override
  String get reportReason => 'Причина';

  @override
  String get reportReasonRequired => 'Причина не может быть пустой';

  @override
  String get reportSubmitted => 'Жалоба отправлена';

  @override
  String get reportSubmitFailed => 'Не удалось отправить жалобу';

  @override
  String get reportTypeRating => 'Злоупотребление рейтингом';

  @override
  String get reportTypeFile => 'Вредоносный файл';

  @override
  String get reportTypeSource => 'Вредоносный источник';

  @override
  String get reportTypeDescription => 'Злоупотребление описанием';

  @override
  String get reportTypeNote => 'Злоупотребление заметками';

  @override
  String get reportTypeTagging => 'Злоупотребление тегами';

  @override
  String get reportTypeRatingBody => 'Рейтинг этой работы указан неверно.';

  @override
  String get reportTypeFileBody =>
      'Файл содержит вредоносный код или скрытый архив с файлами. Это не о содержании самого изображения.';

  @override
  String get reportTypeSourceBody =>
      'Один или несколько указанных источников ведут на вредоносные страницы или платный контент.';

  @override
  String get reportTypeDescriptionBody =>
      'Описание содержит вредоносный контент или было изменено с добавлением оскорбительных материалов.';

  @override
  String get reportTypeNoteBody =>
      'Заметки на этом посте неверны, носят оскорбительный характер или иным образом недопустимы.';

  @override
  String get reportTypeTaggingBody =>
      'Один или несколько тегов на этом посту недействительны, либо один или несколько действительных тегов были удалены.';

  @override
  String flagPostSuccess(num id) {
    return 'Пост #$id отмечен';
  }

  @override
  String flagPostFailed(num id) {
    return 'Не удалось отметить пост #$id';
  }

  @override
  String get flagParentId => 'ID родителя';

  @override
  String get flagParentIdRequired => 'ID родителя не может быть пустым';

  @override
  String get flagParentIdInvalid => 'ID родителя должен быть числом';

  @override
  String get flagTypeUploadingGuidelines =>
      'Не соответствует правилам загрузки';

  @override
  String get flagTypeYoungHuman =>
      'Молодой человекоподобный персонаж в откровенной ситуации';

  @override
  String get flagTypeDnpArtist =>
      'Художник этого поста внесён в список запрещённых к публикации';

  @override
  String get flagTypePayContent =>
      'Контент с платных сайтов, коммерческий или подписной контент';

  @override
  String get flagTypeTrace => 'Калька работы другого художника';

  @override
  String get flagTypePreviouslyDeleted => 'Ранее удалён';

  @override
  String get flagTypeRealPorn => 'Порнография с реальными людьми';

  @override
  String get flagTypeCorrupt => 'Файл повреждён или не воспроизводится';

  @override
  String get flagTypeInferior => 'Дубликат или худшая версия другого поста';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      'Этот пост не соответствует стандартам сайта — будь то художественная ценность, качество изображения, релевантность или что-то ещё.\nИмейте в виду: личные предпочтения здесь роли не играют. Если вам не нравится содержание поста, просто [[e621:blacklist|занесите его в чёрный список]].';

  @override
  String get flagTypeYoungHumanBody =>
      'Посты с человеческими и человекоподобными персонажами в сексуальном или откровенно обнажённом виде на этом сайте недопустимы.';

  @override
  String get flagTypeDnpArtistBody =>
      'Некоторые художники попросили не публиковать их работы на этом сайте и получили статус [[avoid_posting|Не публиковать]].\nИногда этот статус выдаётся с условиями; подробнее см. [[conditional_dnp]]';

  @override
  String get flagTypePayContentBody =>
      'Мы не размещаем контент платных сайтов или коммерческий контент любого рода. Сюда входят утечки с Patreon, репосты с пиратских сайтов и т.п.';

  @override
  String get flagTypeTraceBody =>
      'Кальки работ других художников на этом сайте не принимаются. Ссылаться на что-то — нормально, но прямое копирование чужой работы — нет.\nПожалуйста, оставьте больше информации в комментариях или просто укажите оригинал родительским постом, если он есть на этом сайте.';

  @override
  String get flagTypePreviouslyDeletedBody =>
      'Посты обычно удаляют не просто так, и повторная загрузка удалённого контента недопустима.\nПожалуйста, оставьте больше информации в комментариях или укажите оригинальный пост родительским для этого.';

  @override
  String get flagTypeRealPornBody =>
      'Посты с порнографией с реальными людьми на этом сайте недопустимы. Без исключений.\nОбратите внимание: изображения с неэротическими фотографиями допустимы.';

  @override
  String get flagTypeCorruptBody =>
      'Что-то в этом посте работает не так. Возможно, это сломанное видео или повреждённое изображение.\nВ любом случае, чтобы избежать путаницы, опишите ситуацию в комментариях.';

  @override
  String get flagTypeInferiorBody =>
      'Более качественная версия этого поста уже есть на сайте.\nЭто может быть изображение лучшего качества (больше, меньше сжатия), но также и «исправленные» версии, где художник учёл визуальные ошибки.\nОбратите внимание: правки и альтернативные версии не относятся к этой категории.';

  @override
  String get taskCancelAll => 'Отменить все';

  @override
  String get taskClearDone => 'Очистить завершённые';

  @override
  String get taskClearSelection => 'Снять выделение';

  @override
  String get taskCancel => 'Отменить';

  @override
  String get taskDismiss => 'Убрать';

  @override
  String get taskNoTasks => 'Нет задач';

  @override
  String get taskFailedToLoadTasks => 'Не удалось загрузить задачи';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => 'Активные';

  @override
  String get taskGroupFailed => 'Неудачные';

  @override
  String get taskActionDownload => 'скачивание';

  @override
  String get taskActionFavorite => 'добавление в избранное';

  @override
  String get taskActionUnfavorite => 'удаление из избранного';

  @override
  String get taskDownloadRunning => 'скачивание';

  @override
  String get taskFavoriteRunning => 'добавление в избранное';

  @override
  String get taskUnfavoriteRunning => 'удаление из избранного';

  @override
  String get taskDownloadCompleted => 'скачано';

  @override
  String get taskFavoriteCompleted => 'добавлено в избранное';

  @override
  String get taskUnfavoriteCompleted => 'убрано из избранного';

  @override
  String taskQueuedTo(String action) {
    return '$action в очереди';
  }

  @override
  String taskFailedTo(String action) {
    return '$action не удалось';
  }

  @override
  String taskCanceledAction(String action) {
    return '$action отменено';
  }

  @override
  String taskTileTitle(String label, num id) {
    return 'Пост #$id: $label';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых поста!',
      many: '$count новых постов!',
      few: '$count новых поста!',
      one: '$count новый пост!',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => 'Новые посты!';

  @override
  String get followChannelName => 'Подписки на теги';

  @override
  String get followChannelDescription =>
      'Уведомления о тегах, на которые вы подписаны';

  @override
  String get hostUnavailableTitle => 'Сайт недоступен';

  @override
  String hostUnavailableBody(String host) {
    return 'Похоже, $host недоступен!';
  }

  @override
  String get hostUnavailableResolveHint =>
      'Решите проблему в открывшемся окне браузера.\n\nCookie от CAPTCHA Cloudflare будут сохранены.';

  @override
  String get hostUnavailableResolve => 'Решить';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\nПодождите, пока $host решит проблему со своей стороны.';
  }

  @override
  String get downloadChooseFolder => 'Выберите папку';

  @override
  String get searchFilterTitle => 'Фильтры';

  @override
  String get searchFilterQueryLabel => 'Текущий запрос:';

  @override
  String get dtextParsingFailed => 'Не удалось разобрать DText';
}
