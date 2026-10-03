// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'e1547';

  @override
  String get failedToLoad => 'No se pudo cargar';

  @override
  String get nothingToSeeHere => 'Nada que ver aquí';

  @override
  String get loading => 'Cargando…';

  @override
  String get actionCancel => 'CANCELAR';

  @override
  String get actionOk => 'OK';

  @override
  String get actionTryAgain => 'Reintentar';

  @override
  String get actionDownload => 'DESCARGAR';

  @override
  String get actionImport => 'IMPORTAR';

  @override
  String get actionExport => 'EXPORTAR';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionRestartNow => 'REINICIAR AHORA';

  @override
  String get failedToLoadSuggestions => 'No se pudieron cargar las sugerencias';

  @override
  String selectionItemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get actionAbort => 'Abortar';

  @override
  String get actionSelectAll => 'Seleccionar todo';

  @override
  String fileSavedAs(String name) {
    return 'Archivo guardado como $name';
  }

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get saveFile => 'Guardar archivo';

  @override
  String get filterTooltip => 'Filtro';

  @override
  String get rangeInvalidFormat => 'Formato no válido';

  @override
  String itemProgress(num current, num total) {
    return 'Elemento $current/$total';
  }

  @override
  String get taskCancelled => 'Tarea cancelada';

  @override
  String taskFailedAt(num index) {
    return 'Falló en el elemento $index';
  }

  @override
  String get taskDone => 'Listo';

  @override
  String get failedToInitialize => 'No se pudo inicializar';

  @override
  String get navHome => 'Inicio';

  @override
  String get navHot => 'Populares';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navTimeline => 'Cronología';

  @override
  String get navSubscriptions => 'Suscripciones';

  @override
  String get navBookmarks => 'Marcadores';

  @override
  String get navPools => 'Pools';

  @override
  String get navForum => 'Foro';

  @override
  String get navHistory => 'Historial';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navAbout => 'Acerca de';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionAccount => 'Cuenta';

  @override
  String get sectionUser => 'Usuario';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionInteractions => 'Interacciones';

  @override
  String get sectionSecurity => 'Seguridad';

  @override
  String get sectionDevelopment => 'Desarrollo';

  @override
  String get settingsBlacklist => 'Lista negra';

  @override
  String tagsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count etiquetas bloqueadas',
      one: '1 etiqueta bloqueada',
    );
    return '$_temp0';
  }

  @override
  String get settingsFollows => 'Suscripciones';

  @override
  String searchesFollowed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count búsquedas seguidas',
      one: '1 búsqueda seguida',
    );
    return '$_temp0';
  }

  @override
  String get settingsHistory => 'Historial';

  @override
  String pagesVisited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas visitadas',
      one: '1 página visitada',
    );
    return '$_temp0';
  }

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themeSystem => 'Del sistema';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsTileSize => 'Tamaño de mosaico';

  @override
  String get settingsQuilt => 'Formato de cuadrícula';

  @override
  String get gridTitle => 'Cuadrícula';

  @override
  String get quiltSquare => 'mosaicos cuadrados';

  @override
  String get quiltVertical => 'mosaicos verticales';

  @override
  String get settingsPostInfo => 'Información de posts';

  @override
  String get postInfoShown => 'información en los mosaicos';

  @override
  String get postInfoHidden => 'solo imágenes';

  @override
  String get settingsDownloadLocation => 'Carpeta de descargas';

  @override
  String get settingsUpvoteFavorites => 'Votar favoritos';

  @override
  String get upvoteFavoritesOn => 'voto positivo y favorito';

  @override
  String get upvoteFavoritesOff => 'solo favorito';

  @override
  String get settingsVideoVolume => 'Volumen de vídeo';

  @override
  String get videoMuted => 'silenciado';

  @override
  String get videoWithSound => 'con sonido';

  @override
  String videoSeekSeconds(Object seconds) {
    return '$seconds segundos';
  }

  @override
  String get settingsVideoResolution => 'Resolución de vídeo';

  @override
  String get videoResStandard => 'Estándar (480p)';

  @override
  String get videoResHigh => 'Alta (720p)';

  @override
  String get videoResFull => 'Completa (1080p)';

  @override
  String get videoResUltra => 'Ultra (4K)';

  @override
  String get videoResSource => 'Original';

  @override
  String get settingsSecureDisplay => 'Protección de pantalla';

  @override
  String get secureDisplayOn => 'pantalla protegida';

  @override
  String get secureDisplayOff => 'pantalla visible';

  @override
  String get settingsIncognitoKeyboard => 'Teclado de incógnito';

  @override
  String get enabled => 'activado';

  @override
  String get disabled => 'desactivado';

  @override
  String get settingsPinLock => 'Bloqueo con PIN';

  @override
  String get pinEnabled => 'PIN activado';

  @override
  String get pinDisabled => 'PIN desactivado';

  @override
  String get settingsBiometricLock => 'Bloqueo biométrico';

  @override
  String get biometricsEnabled => 'biometría activada';

  @override
  String get biometricsDisabled => 'biometría desactivada';

  @override
  String get settingsDeveloperMode => 'Modo desarrollador';

  @override
  String get devOptionsShown => 'opciones visibles';

  @override
  String get devOptionsHidden => 'opciones ocultas';

  @override
  String errorsLogged(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores registrados',
      one: '1 error registrado',
    );
    return '$_temp0';
  }

  @override
  String get settingsDatabase => 'Base de datos';

  @override
  String get databaseExporting => 'Exportando base de datos…';

  @override
  String get databaseExported => 'Base de datos exportada';

  @override
  String get databaseExportFailed => 'No se pudo exportar';

  @override
  String get databaseExport => 'Exportar';

  @override
  String get databaseImporting => 'Importando base de datos…';

  @override
  String databaseInvalidFile(String error) {
    return 'Archivo de base de datos no válido: $error';
  }

  @override
  String databaseImportFailed(String error) {
    return 'No se pudo importar: $error';
  }

  @override
  String get databaseImportTitle => 'Importar base de datos';

  @override
  String get databaseRestartTitle => 'Reinicio necesario';

  @override
  String get databaseRestartBody =>
      'Hay que reiniciar la aplicación para aplicar los cambios.';

  @override
  String get databaseImport => 'Importar';

  @override
  String get lockEnterPin => 'Introduce el PIN';

  @override
  String get lockEnterNewPin => 'Introduce el nuevo PIN';

  @override
  String get lockConfirmNewPin => 'Confirma el nuevo PIN';

  @override
  String get lockFailedAuth => 'Autenticación fallida';

  @override
  String get lockPleaseAuth => 'Autentícate';

  @override
  String get lockRetry => 'Reintentar';

  @override
  String get lockBiometricReason => 'Autentícate para desbloquear.';

  @override
  String get lockBiometricFailure =>
      'Error crítico de autenticación biométrica';

  @override
  String get aboutVersion => 'Versión';

  @override
  String get updaterFetching => 'Buscando actualizaciones…';

  @override
  String get updaterCheckFailed =>
      'No se pudo comprobar si hay actualizaciones';

  @override
  String get updaterNewest => 'Tienes la versión más reciente';

  @override
  String updaterNewer(String version) {
    return 'Hay una versión más reciente: $version';
  }

  @override
  String get updaterNewerHeader => 'Hay una versión más reciente: ';

  @override
  String get aboutExperimentalPlatform => 'Plataforma experimental';

  @override
  String get aboutExperimentalBody =>
      'Esta plataforma no está soportada. Es posible que haya errores o funciones ausentes.';

  @override
  String get aboutGitHub => 'GitHub';

  @override
  String get aboutUpstream => 'Proyecto original';

  @override
  String get aboutUpstreamBody => 'Esta es una bifurcación de clragon/e1547';

  @override
  String get aboutDiscord => 'Discord';

  @override
  String get aboutForum => 'Foro';

  @override
  String aboutForumTopic(num id) {
    return 'Tema de e621 #$id';
  }

  @override
  String get aboutWebsite => 'Sitio web';

  @override
  String get aboutKofi => 'Ko-fi';

  @override
  String get aboutEmail => 'Correo';

  @override
  String get aboutPlaystore => 'Play Store';

  @override
  String get aboutDonors => 'Donantes';

  @override
  String get aboutDonorsThanks =>
      '¡Gracias a todos los que hacen posible el desarrollo!';

  @override
  String get aboutNoDonors => 'Aún no hay donantes';

  @override
  String get aboutDonorsFailed => 'No se pudo cargar la lista de donantes';

  @override
  String get aboutDonorsNotListed => '¿No apareces en la lista? ¡Contáctanos!';

  @override
  String get developerUnlocked => '¡Ahora eres un desarrollador!';

  @override
  String get databaseErrorLoading => 'Error al cargar la base de datos';

  @override
  String get databaseUnknownSize => 'Desconocido';

  @override
  String get databaseExportTitle => 'Exportar base de datos';

  @override
  String get databaseExportSubtitle =>
      'Guardar una copia de seguridad de la base de datos';

  @override
  String get databaseImportSubtitle =>
      'Reemplaza la base de datos actual por la importada';

  @override
  String get databaseImportWarning =>
      'La base de datos actual será reemplazada.\n¡Todos los datos se perderán y no habrá forma de recuperarlos!';

  @override
  String get databaseExportSanitizedBody =>
      'El archivo exportado no contiene tus datos de sesión ni claves de API.\nSe incluyen todos los demás datos: cuentas, sitios, historial, suscripciones y tareas.';

  @override
  String get databaseImportNewerFile =>
      'Este archivo fue creado con una versión más reciente de la aplicación y no se puede importar.';

  @override
  String get databaseImportSanitized =>
      'Por seguridad, los datos de sesión guardados se eliminaron del archivo importado.';

  @override
  String databaseImportHostsWarning(String hosts) {
    return 'Atención: el archivo importado contiene cuentas de otros sitios: $hosts';
  }

  @override
  String get databaseImportCancelled => 'Importación cancelada';

  @override
  String get postsTitle => 'Posts';

  @override
  String favoritesOf(String user) {
    return 'Favoritos de $user';
  }

  @override
  String get favoritesUnavailable =>
      'Los favoritos no están disponibles sin iniciar sesión';

  @override
  String get favoriteOrder => 'Orden de favoritos';

  @override
  String get orderAdded => 'por fecha de añadido';

  @override
  String get orderId => 'por ID';

  @override
  String get postStateDeleted => 'eliminado';

  @override
  String get postStateUnsupported => 'no soportado';

  @override
  String get postStateUnavailable => 'no disponible';

  @override
  String get menuShare => 'Compartir';

  @override
  String get menuDownload => 'Descargar';

  @override
  String get menuBrowse => 'Abrir en el navegador';

  @override
  String get menuEdit => 'Editar';

  @override
  String get menuComment => 'Comentar';

  @override
  String get menuReport => 'Reportar';

  @override
  String get menuFlag => 'Marcar';

  @override
  String get actionOpen => 'Abrir';

  @override
  String get actionFollow => 'Seguir';

  @override
  String get actionUnfollow => 'Dejar de seguir';

  @override
  String get actionMute => 'Silenciar';

  @override
  String get actionNotify => 'Notificaciones';

  @override
  String get actionBookmark => 'A marcadores';

  @override
  String get actionUnbookmark => 'Quitar de marcadores';

  @override
  String get actionBlock => 'Bloquear';

  @override
  String get actionUnblock => 'Desbloquear';

  @override
  String get actionRemove => 'Eliminar';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionSubtract => 'Excluir';

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
      one: '1 post',
    );
    return '$_temp0';
  }

  @override
  String get noPosts => 'No hay posts';

  @override
  String get failedToLoadPosts => 'No se pudieron cargar los posts';

  @override
  String get offlineBanner =>
      'Sin conexión. Se muestran datos guardados en caché.';

  @override
  String get offlineNoData => 'Sin conexión';

  @override
  String postListPageSummary(num count, Object page) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '1 post',
    );
    return 'Página $page · $_temp0';
  }

  @override
  String get postListPageLimit =>
      'Se alcanzó el límite de páginas del servidor. Afina tu búsqueda.';

  @override
  String get postListJumpToPage => 'Ir a la página';

  @override
  String get postListJumpPageLabel => 'Número de página';

  @override
  String postListJumpPageRange(Object max) {
    return 'Introduce un número de página entre 1 y $max';
  }

  @override
  String get postDeletedOverlay => 'Post eliminado';

  @override
  String get postUnavailableOverlay => 'Post no disponible';

  @override
  String get postBlacklistedOverlay => 'El post está en la lista negra';

  @override
  String unsupportedFileType(String ext) {
    return 'Los archivos $ext no están soportados';
  }

  @override
  String get loginRequiredEdit =>
      '¡Necesitas iniciar sesión para editar posts!';

  @override
  String get loginRequiredComment => '¡Necesitas iniciar sesión para comentar!';

  @override
  String get loginRequiredReport =>
      '¡Necesitas iniciar sesión para reportar posts!';

  @override
  String get loginRequiredFlag =>
      '¡Necesitas iniciar sesión para marcar posts!';

  @override
  String postsBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts bloqueados',
      one: '1 post bloqueado',
    );
    return '$_temp0';
  }

  @override
  String get blacklistUpdateFailed => '¡No se pudo actualizar la lista negra!';

  @override
  String get blacklistAddTag => 'Añadir etiqueta';

  @override
  String get blacklistEditTag => 'Editar etiqueta';

  @override
  String get denylistEntryDeleted => 'Entrada de lista negra eliminada';

  @override
  String get blacklistEmpty => 'Tu lista negra está vacía';

  @override
  String get menuDelete => 'Eliminar';

  @override
  String get filterScore => 'Puntuación';

  @override
  String get filterFavoriteCount => 'Número de favoritos';

  @override
  String get filterSortBy => 'Orden';

  @override
  String get filterNew => 'Nuevos';

  @override
  String get filterRank => 'Rango';

  @override
  String get filterRandom => 'Aleatorio';

  @override
  String get filterDefault => 'Predeterminado';

  @override
  String get filterRating => 'Clasificación';

  @override
  String get filterSafe => 'Seguro';

  @override
  String get filterQuestionable => 'Cuestionable';

  @override
  String get filterExplicit => 'Explícito';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterPool => 'Pool';

  @override
  String get filterHasPool => 'Con pool';

  @override
  String get filterChild => 'Descendiente';

  @override
  String get filterIsChildPost => 'Post descendiente';

  @override
  String get filterParent => 'Ascendente';

  @override
  String get filterIsParentPost => 'Post ascendente';

  @override
  String get filterUploadDate => 'Fecha de subida';

  @override
  String get filterLastDay => 'Último día';

  @override
  String get filterLastWeek => 'Última semana';

  @override
  String get filterLastMonth => 'Último mes';

  @override
  String get filterLastYear => 'Último año';

  @override
  String get filterStatus => 'Estado';

  @override
  String get filterActive => 'Activo';

  @override
  String get filterPending => 'Pendiente';

  @override
  String get filterDeleted => 'Eliminado';

  @override
  String get filterFlagged => 'Marcado';

  @override
  String get filterAny => 'Cualquiera';

  @override
  String get filterFileType => 'Tipo de archivo';

  @override
  String get filterUploader => 'Quien lo subió';

  @override
  String get filterWidth => 'Ancho';

  @override
  String get filterHeight => 'Alto';

  @override
  String get filterTagCount => 'Número de etiquetas';

  @override
  String get filterTrue => 'Sí';

  @override
  String get filterFalse => 'No';

  @override
  String get filterImages => 'Imágenes';

  @override
  String get filterVideos => 'Vídeos';

  @override
  String get filterTitleContains => 'El título contiene';

  @override
  String get filterCategory => 'Categoría';

  @override
  String get filterGeneral => 'Generales';

  @override
  String get filterSiteBugReports =>
      'Informes de errores y peticiones del sitio';

  @override
  String get filterTagWikiProjects => 'Proyectos de etiquetas/wiki y preguntas';

  @override
  String get filterTagAliasSuggestions =>
      'Sugerencias de alias y relaciones de etiquetas';

  @override
  String get filterArtTalk => 'Charla de arte';

  @override
  String get filterOffTopic => 'Tema libre';

  @override
  String get filterE621Tools => 'Herramientas y apps de e621';

  @override
  String get filterNewestFirst => 'Más nuevos primero';

  @override
  String get filterOldestFirst => 'Más antiguos primero';

  @override
  String get filterSticky => 'Fijado';

  @override
  String get filterIsSticky => 'está fijado';

  @override
  String get filterLocked => 'Cerrado';

  @override
  String get filterIsLocked => 'está cerrado';

  @override
  String get filterDescription => 'Descripción';

  @override
  String get filterCreator => 'Creador';

  @override
  String get filterIsActive => 'está activo';

  @override
  String get filterSeries => 'Serie';

  @override
  String get filterCollection => 'Colección';

  @override
  String get filterName => 'Nombre';

  @override
  String get filterCreated => 'Creado';

  @override
  String get filterUpdated => 'Actualizado';

  @override
  String get filterPostCount => 'Número de posts';

  @override
  String postUpdateFailed(num id) {
    return 'No se pudo actualizar el post #$id';
  }

  @override
  String postUpdated(num id) {
    return 'Post #$id actualizado';
  }

  @override
  String get failedToLoadPost => 'No se pudo cargar el post';

  @override
  String get postNotFound => 'Post no encontrado';

  @override
  String get commentsTitle => 'Comentarios';

  @override
  String commentsOfPost(num postId) {
    return 'Comentarios del post #$postId';
  }

  @override
  String get commentOrder => 'Orden de comentarios';

  @override
  String get noComments => 'No hay comentarios';

  @override
  String get failedToLoadComments => 'No se pudieron cargar los comentarios';

  @override
  String commentTitle(num id) {
    return 'Comentario #$id';
  }

  @override
  String get failedToLoadComment => 'No se pudo cargar el comentario';

  @override
  String get commentNotFound => 'Comentario no encontrado';

  @override
  String commentEditorTitle(num postId) {
    return 'Comentario del post #$postId';
  }

  @override
  String get commentSendFailed => '¡No se pudo enviar el comentario!';

  @override
  String get commentSent => '¡Comentario enviado!';

  @override
  String get commentHidden => 'Este comentario está oculto';

  @override
  String commentUpvoteFailed(num id) {
    return 'No se pudo votar positivamente el comentario #$id';
  }

  @override
  String commentDownvoteFailed(num id) {
    return 'No se pudo votar negativamente el comentario #$id';
  }

  @override
  String get commentLoginRequiredEdit =>
      '¡Necesitas iniciar sesión para editar comentarios!';

  @override
  String get commentLoginRequiredReply =>
      '¡Necesitas iniciar sesión para responder comentarios!';

  @override
  String get commentLoginRequiredReport =>
      '¡Necesitas iniciar sesión para reportar comentarios!';

  @override
  String commentCopiedId(num id) {
    return 'ID del comentario #$id copiado';
  }

  @override
  String get warningUserWarned =>
      'El usuario recibió una advertencia por este mensaje';

  @override
  String get warningUserRecorded =>
      'Se dejó constancia en el registro del usuario por este mensaje';

  @override
  String get warningUserBanned => 'El usuario fue baneado por este mensaje';

  @override
  String get repliesTitle => 'Respuestas';

  @override
  String get replyOrder => 'Orden de respuestas';

  @override
  String get noReplies => 'No hay respuestas';

  @override
  String get failedToLoadReplies => 'No se pudieron cargar las respuestas';

  @override
  String replyTitle(num id) {
    return 'Respuesta #$id';
  }

  @override
  String get failedToLoadReply => 'No se pudo cargar la respuesta';

  @override
  String get replyNotFound => 'Respuesta no encontrada';

  @override
  String replyEditorTitle(num topicId) {
    return 'Respuesta en el tema #$topicId';
  }

  @override
  String get replySendFailed => '¡No se pudo enviar la respuesta!';

  @override
  String get replySent => '¡Respuesta enviada!';

  @override
  String get replyHidden => 'Esta respuesta está oculta';

  @override
  String get replyLoginRequiredEdit =>
      '¡Necesitas iniciar sesión para editar respuestas!';

  @override
  String get replyLoginRequiredReply =>
      '¡Necesitas iniciar sesión para responder!';

  @override
  String get replyLoginRequiredReport =>
      '¡Necesitas iniciar sesión para reportar respuestas!';

  @override
  String replyCopiedId(num id) {
    return 'ID de la respuesta #$id copiado';
  }

  @override
  String get menuReply => 'Responder';

  @override
  String get menuCopyId => 'Copiar ID';

  @override
  String get menuRefresh => 'Actualizar';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionShow => 'Mostrar';

  @override
  String get actionHide => 'Ocultar';

  @override
  String get actionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get info => 'Información';

  @override
  String wikiTitle(String idOrTitle) {
    return 'Wiki $idOrTitle';
  }

  @override
  String get failedToLoadWiki => 'No se pudo cargar el wiki';

  @override
  String get wikiNotFound => 'Wiki no encontrado';

  @override
  String wikiCopiedId(num id) {
    return 'ID del wiki #$id copiado';
  }

  @override
  String get wikiInfoId => 'ID';

  @override
  String get wikiInfoAlias => 'alias';

  @override
  String get wikiInfoCreated => 'creado';

  @override
  String get wikiInfoUpdated => 'actualizado';

  @override
  String get wikiInfoLocked => 'bloqueado';

  @override
  String get wikiInfoYes => 'sí';

  @override
  String get wikiInfoNo => 'no';

  @override
  String userTitle(String idOrName) {
    return 'Usuario $idOrName';
  }

  @override
  String get failedToLoadUser => 'No se pudo cargar el usuario';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get userUploads => 'Subidas';

  @override
  String get userLoginRequiredReport =>
      '¡Necesitas iniciar sesión para reportar usuarios!';

  @override
  String get userComission => 'Commission';

  @override
  String get userId => 'ID';

  @override
  String get userJoined => 'se unió';

  @override
  String get userRank => 'rango';

  @override
  String get userPosts => 'posts';

  @override
  String get userEdits => 'ediciones';

  @override
  String get userFavorites => 'favoritos';

  @override
  String get userComments => 'comentarios';

  @override
  String get userForum => 'foro';

  @override
  String userCopiedId(num id) {
    return 'ID del usuario #$id copiado';
  }

  @override
  String get logsTitle => 'Registros';

  @override
  String logsTitleDate(String date) {
    return 'Registros – $date';
  }

  @override
  String selectionLogsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return '$_temp0';
  }

  @override
  String selectionLogsFilesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos de registro',
      one: '1 archivo de registro',
    );
    return '$_temp0';
  }

  @override
  String get logsLevels => 'Niveles';

  @override
  String get logsRecording => 'Grabación';

  @override
  String get logsVerbose => 'Detalle';

  @override
  String get logsVerboseAll => 'registrar todos los niveles';

  @override
  String logsVerboseMinimum(String level) {
    return '$level y superiores';
  }

  @override
  String get logFilesTitle => 'Archivos de registro';

  @override
  String get failedToLoadLogFiles =>
      '¡No se pudieron cargar los archivos de registro!';

  @override
  String get noLogFiles => '¡No hay archivos de registro disponibles!';

  @override
  String get logsLive => 'En vivo';

  @override
  String get noLogs => 'No hay registros';

  @override
  String get failedToReadLog => 'No se pudo leer el registro';

  @override
  String get noErrorsLogged => 'No hay errores registrados';

  @override
  String logsErrorsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores',
      one: '1 error',
    );
    return '$_temp0';
  }

  @override
  String get logsAll => 'Todos los registros';

  @override
  String get logsDismissAll => 'Ocultar todos';

  @override
  String logsDeleteTitle(num count) {
    return '¿Eliminar $count archivos de registro?';
  }

  @override
  String get identityAccounts => 'Cuentas';

  @override
  String get identityAdd => 'Añadir cuenta';

  @override
  String get identityEdit => 'Editar cuenta';

  @override
  String get identityRemoveTitle => '¿Eliminar la cuenta?';

  @override
  String get identityRemoveBody =>
      'Todos los datos de esta cuenta se eliminarán para siempre, incluidos el historial y las suscripciones.';

  @override
  String get identityAnonymous => 'Anónimo';

  @override
  String get identityDuplicate =>
      'Ya tienes una cuenta con este sitio y este nombre de usuario.';

  @override
  String identityLoginFailed(String reason) {
    return 'No se pudo iniciar sesión.\n$reason';
  }

  @override
  String get identityLoginCheckDetails =>
      'Comprueba tu conexión de red y tus datos de acceso';

  @override
  String get identitySite => 'Sitio';

  @override
  String get identityHostRequired => 'Introduce la URL del sitio.';

  @override
  String get identityHostInvalid => 'URL del sitio no válida';

  @override
  String get identityHostReadOnly =>
      'El sitio no se puede cambiar. Añade una cuenta nueva para usar otro sitio.';

  @override
  String get identityUsernameLabel => 'Nombre de usuario';

  @override
  String get identityUsernameRequired => 'Introduce un nombre de usuario.';

  @override
  String get identityApikeyLabel => 'Clave de API';

  @override
  String get identityApikeyHelp => '¿Dónde encuentro mi clave de API?';

  @override
  String get identityApikeyRequired =>
      'Introduce la clave de API.\np. ej. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identityApikeyInvalid =>
      'Una clave de API es una secuencia de 24 o 32 caracteres de A-z y 0-9\np. ej. 1ca1d165e973d7f8d35b7deb7a2ae54c';

  @override
  String get identitySignupPrompt => '¿Sin cuenta? Regístrate aquí';

  @override
  String get identityHostHint => 'El sitio donde están tu cuenta y tus posts.';

  @override
  String get identitySignIn => 'Iniciar sesión';

  @override
  String get identityGuest => 'Invitado';

  @override
  String get identityLogin => 'Iniciar sesión';

  @override
  String get identityBrowseAnonymously => 'Navegar de forma anónima';

  @override
  String identityConnecting(String host, String username) {
    return 'Conectando a $host como $username…';
  }

  @override
  String identityActivateFailed(Object error) {
    return 'No se pudo activar la cuenta: $error';
  }

  @override
  String traitsActivateFailed(Object error) {
    return 'No se pudieron activar las preferencias: $error';
  }

  @override
  String get failedToLoadIdentities => 'No se pudieron cargar las cuentas';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String onboardingWelcomeTitle(String app) {
    return 'Bienvenido a $app';
  }

  @override
  String get onboardingWelcomeBody => 'Un navegador de boorus sofisticado.';

  @override
  String get onboardingThemeTitle => 'Elige el aspecto';

  @override
  String get onboardingThemeBody =>
      'Pruébalo sin compromiso. Podrás cambiarlo cuando quieras.';

  @override
  String get onboardingLoginTitle => 'Conecta tu cuenta';

  @override
  String get onboardingLanguageTitle => 'Elige el idioma';

  @override
  String get followAddToSubscriptions => 'Añadir a suscripciones';

  @override
  String get followNoSubscriptions => 'No hay suscripciones';

  @override
  String get followFailedToLoadSubscriptions =>
      'No se pudieron cargar las suscripciones';

  @override
  String get followAddToBookmarks => 'Añadir a marcadores';

  @override
  String get followNoBookmarks => 'No hay marcadores';

  @override
  String get followFailedToLoadBookmarks =>
      'No se pudieron cargar los marcadores';

  @override
  String get followUnseenPosts => 'posts no vistos';

  @override
  String followMarkPostsSeen(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'marcar $count posts como vistos',
      one: 'marcar 1 post como visto',
    );
    return '$_temp0';
  }

  @override
  String get followNoUnseenPosts => 'no hay posts sin ver';

  @override
  String get followShowUnseenFirst => 'no vistos primero';

  @override
  String get followFilteringUnseen => 'mostrando solo no vistos';

  @override
  String get followAllPostsShown => 'mostrando todos los posts';

  @override
  String get followForceSync => 'Forzar sincronización';

  @override
  String get followSyncAllFollows => 'sincronizar todas las suscripciones';

  @override
  String followSyncingFollows(String progress) {
    return 'sincronizando suscripciones… $progress';
  }

  @override
  String get followEditorTitle => 'Editar suscripción';

  @override
  String get followSubscribe => 'Suscribirse';

  @override
  String get followEditPrompt => 'Editar suscripción';

  @override
  String get followTitlePrompt => 'Nombre de la suscripción';

  @override
  String get followMarkAsRead => 'Marcar como visto';

  @override
  String get followDisableNotifications => 'Desactivar notificaciones';

  @override
  String get followEnableNotifications => 'Activar notificaciones';

  @override
  String get followRename => 'Renombrar';

  @override
  String followNewPosts(num count, String label) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$label: $count posts nuevos',
      one: '1 post nuevo',
    );
    return '$_temp0';
  }

  @override
  String followSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suscripciones',
      one: '1 suscripción',
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
      other: '$count entradas',
      one: '1 entrada',
    );
    return '$_temp0';
  }

  @override
  String historyEntriesDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas del historial eliminadas',
      one: 'Entrada del historial eliminada',
    );
    return '$_temp0';
  }

  @override
  String get historyClear => 'Borrar historial';

  @override
  String get historyClearSubtitle => 'Eliminar todas las entradas';

  @override
  String get historyClearConfirm => '¿Borrar el historial?';

  @override
  String get historyClearConfirmBody =>
      'Todas las entradas del historial se eliminarán para siempre. Esta acción no se puede deshacer.';

  @override
  String get historyClearAction => 'Borrar';

  @override
  String get historyLimit => 'Límite del historial';

  @override
  String historyLimitEnableBody(String amount, num months) {
    return 'Al activar el límite, se eliminan automáticamente las entradas que superen $amount y las anteriores a $months meses.';
  }

  @override
  String get historyLimitTitle => 'Limitar historial';

  @override
  String historyLimitOn(String amount, num months) {
    return 'Se guardan entradas de los últimos $months meses y como máximo $amount entradas.';
  }

  @override
  String get historyLimitOff => 'historial ilimitado';

  @override
  String get historyEntries => 'Entradas';

  @override
  String get historyType => 'Tipo';

  @override
  String get historyItems => 'Elementos';

  @override
  String get historySearches => 'Búsquedas';

  @override
  String get historyWikis => 'Wikis';

  @override
  String get historyUsers => 'Usuarios';

  @override
  String get historyEmpty => 'El historial está vacío';

  @override
  String get historyFailedToLoad => 'No se pudo cargar el historial';

  @override
  String get historyNoDescription => 'sin descripción';

  @override
  String get historyHotPosts => 'Posts populares';

  @override
  String historyLinkPost(num id) {
    return 'Post #$id';
  }

  @override
  String historyLinkUser(num id) {
    return 'Usuario #$id';
  }

  @override
  String historyLinkWiki(num id) {
    return 'Wiki #$id';
  }

  @override
  String historyLinkUserByName(String id) {
    return 'Usuario $id';
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
  String get poolEmpty => 'No hay pools';

  @override
  String get poolFailedToLoadPools => 'No se pudieron cargar los pools';

  @override
  String get poolTitle => 'Nombre del pool';

  @override
  String get poolInfoPosts => 'posts';

  @override
  String get poolInfoId => 'ID';

  @override
  String get poolInfoActivity => 'actividad';

  @override
  String get poolInfoActive => 'activo';

  @override
  String get poolInfoInactive => 'inactivo';

  @override
  String get poolInfoCreated => 'creado';

  @override
  String get poolInfoUpdated => 'actualizado';

  @override
  String poolCopiedId(num id) {
    return 'ID del pool #$id copiado';
  }

  @override
  String poolLink(num id) {
    return 'Pool #$id';
  }

  @override
  String get poolFailedToLoadPool => 'No se pudo cargar el pool';

  @override
  String get poolNotFound => 'Pool no encontrado';

  @override
  String get poolOrder => 'Orden del pool';

  @override
  String get poolOldestFirst => 'Más antiguos primero';

  @override
  String get poolNewestFirst => 'Más nuevos primero';

  @override
  String get poolReaderMode => 'Modo lectura del pool';

  @override
  String get poolReaderLargeImages => 'imágenes grandes';

  @override
  String get poolReaderNormalGrid => 'cuadrícula normal';

  @override
  String get topicsTitle => 'Temas';

  @override
  String get topicHideTagEdits => 'Ocultar ediciones de etiquetas';

  @override
  String get topicTagEditsHidden => 'ocultas';

  @override
  String get topicTagEditsVisible => 'visibles';

  @override
  String topicLink(num id) {
    return 'Tema #$id';
  }

  @override
  String get topicFailedToLoadTopic => 'No se pudo cargar el tema';

  @override
  String get topicNotFound => 'Tema no encontrado';

  @override
  String get topicEmpty => 'No hay temas';

  @override
  String get topicFailedToLoadTopics => 'No se pudieron cargar los temas';

  @override
  String get topicInfoReplies => 'respuestas';

  @override
  String get topicInfoId => 'ID';

  @override
  String topicCopiedId(num id) {
    return 'ID del tema #$id copiado';
  }

  @override
  String get topicInfoLocked => 'cerrado';

  @override
  String get topicInfoYes => 'sí';

  @override
  String get topicInfoNo => 'no';

  @override
  String get topicInfoCreated => 'creado';

  @override
  String get topicInfoUpdated => 'actualizado';

  @override
  String get filterTags => 'Etiquetas';

  @override
  String get loginRequired => 'Necesitas iniciar sesión para esta acción.';

  @override
  String get actionChooseIdentity => 'Elegir cuenta';

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateYesterday => 'Ayer';

  @override
  String detailCommentsButton(num count) {
    return 'Comentarios ($count)';
  }

  @override
  String get detailFile => 'Archivo';

  @override
  String get detailSources => 'Fuentes';

  @override
  String get detailNoSources => 'sin fuentes';

  @override
  String get detailChildren => 'Descendientes';

  @override
  String get detailDeletion => 'Motivo de eliminación';

  @override
  String get detailBlacklisted => 'En la lista negra';

  @override
  String get detailNoArtist => 'sin artista';

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
    return 'ID del post #$id copiado';
  }

  @override
  String postUpvoteFailed(num id) {
    return 'No se pudo votar positivamente el post #$id';
  }

  @override
  String postDownvoteFailed(num id) {
    return 'No se pudo votar negativamente el post #$id';
  }

  @override
  String postAddFavoriteFailed(num id) {
    return 'No se pudo añadir el post #$id a favoritos';
  }

  @override
  String postRemoveFavoriteFailed(num id) {
    return 'No se pudo quitar el post #$id de favoritos';
  }

  @override
  String get editorSection => 'Sección';

  @override
  String get editorQuote => 'Cita';

  @override
  String get editorCode => 'Código';

  @override
  String get editorSpoiler => 'Spoiler';

  @override
  String get editorBold => 'Negrita';

  @override
  String get editorItalic => 'Cursiva';

  @override
  String get editorUnderlined => 'Subrayado';

  @override
  String get editorStrikethrough => 'Tachado';

  @override
  String get editorPreviewPlaceholder => 'Aquí aparecerá tu texto';

  @override
  String get editorWrite => 'Escribir';

  @override
  String get editorPreview => 'Vista previa';

  @override
  String get editorTypeHere => 'Escribe aquí…';

  @override
  String get tagNoTags => 'sin etiquetas';

  @override
  String get tagFailedToLoadTags => 'No se pudieron cargar las etiquetas';

  @override
  String get tagUnableToRetrieveWiki => 'no se pudo obtener el wiki';

  @override
  String get tagNoWikiEntry => 'sin entrada de wiki';

  @override
  String get tagCategoryGeneral => 'Generales';

  @override
  String get tagCategorySpecies => 'Especies';

  @override
  String get tagCategoryCharacter => 'Personajes';

  @override
  String get tagCategoryCopyright => 'Copyright';

  @override
  String get tagCategoryMeta => 'Meta';

  @override
  String get tagCategoryLore => 'Lore';

  @override
  String get tagCategoryArtist => 'Artistas';

  @override
  String get tagCategoryContributor => 'Colaboradores';

  @override
  String get tagCategoryInvalid => 'No válidas';

  @override
  String editDescriptionTitle(num postId) {
    return 'Descripción del post #$postId';
  }

  @override
  String get editDescriptionHint => 'Introduce la descripción del post…';

  @override
  String get editInvalidNumber => 'Formato numérico no válido';

  @override
  String get editInvalidParent => 'Post ascendente no válido';

  @override
  String get editParentIdLabel => 'ID del post ascendente (opcional)';

  @override
  String get editParentIdHint => 'ID del post ascendente';

  @override
  String get editReasonLabel => 'Motivo de la edición (opcional)';

  @override
  String get editReasonHint => '¿Por qué editas este post?';

  @override
  String editSourcesTitle(num postId) {
    return 'Fuentes del post #$postId';
  }

  @override
  String get editTagsHint => 'etiquetas separadas por espacios';

  @override
  String editTagPreviewFailed(String error) {
    return 'Error al cargar la vista previa de la etiqueta: $error';
  }

  @override
  String get editTagStatusNew => 'nueva';

  @override
  String get editTagStatusInvalid => 'no válida';

  @override
  String get editTagStatusEmpty => 'vacía';

  @override
  String get editTagStatusUnderused => 'poco usada';

  @override
  String reportCommentSuccess(num id) {
    return 'Comentario #$id reportado';
  }

  @override
  String reportCommentFailed(num id) {
    return 'No se pudo reportar el comentario #$id';
  }

  @override
  String reportReplySuccess(num id) {
    return 'Respuesta #$id reportada';
  }

  @override
  String reportReplyFailed(num id) {
    return 'No se pudo reportar la respuesta #$id';
  }

  @override
  String reportUserSuccess(num id) {
    return 'Usuario #$id reportado';
  }

  @override
  String reportUserFailed(num id) {
    return 'No se pudo reportar al usuario #$id';
  }

  @override
  String reportPostSuccess(num id) {
    return 'Post #$id reportado';
  }

  @override
  String reportPostFailed(num id) {
    return 'No se pudo reportar el post #$id';
  }

  @override
  String get reportTypeRequired => 'El tipo es obligatorio';

  @override
  String get reportReason => 'Motivo';

  @override
  String get reportReasonRequired => 'El motivo es obligatorio';

  @override
  String get reportSubmitted => 'Reporte enviado';

  @override
  String get reportSubmitFailed => 'No se pudo enviar el reporte';

  @override
  String get reportTypeRating => 'Uso indebido de la clasificación';

  @override
  String get reportTypeFile => 'Archivo malicioso';

  @override
  String get reportTypeSource => 'Fuente maliciosa';

  @override
  String get reportTypeDescription => 'Uso indebido de la descripción';

  @override
  String get reportTypeNote => 'Uso indebido de las notas';

  @override
  String get reportTypeTagging => 'Uso indebido de etiquetas';

  @override
  String get reportTypeRatingBody =>
      'La clasificación de esta obra está mal indicada.';

  @override
  String get reportTypeFileBody =>
      'El archivo contiene código malicioso o un archivo comprimido oculto. No se refiere al contenido de la imagen en sí.';

  @override
  String get reportTypeSourceBody =>
      'Una o más de las fuentes indicadas llevan a páginas maliciosas o a contenido de pago.';

  @override
  String get reportTypeDescriptionBody =>
      'La descripción contiene contenido malicioso o fue alterada con material ofensivo.';

  @override
  String get reportTypeNoteBody =>
      'Las notas de este post son incorrectas, resultan ofensivas o son inadecuadas de algún otro modo.';

  @override
  String get reportTypeTaggingBody =>
      'Una o más etiquetas de este post no son válidas, o se eliminaron etiquetas válidas.';

  @override
  String flagPostSuccess(num id) {
    return 'Post #$id marcado';
  }

  @override
  String flagPostFailed(num id) {
    return 'No se pudo marcar el post #$id';
  }

  @override
  String get flagParentId => 'ID del post ascendente';

  @override
  String get flagParentIdRequired => 'El ID del post ascendente es obligatorio';

  @override
  String get flagParentIdInvalid =>
      'El ID del post ascendente debe ser un número';

  @override
  String get flagTypeUploadingGuidelines => 'No cumple las normas de subida';

  @override
  String get flagTypeYoungHuman =>
      'Personaje humanoide joven en situaciones explícitas';

  @override
  String get flagTypeDnpArtist =>
      'El artista de este post está en la lista de no publicar';

  @override
  String get flagTypePayContent =>
      'Contenido de sitios de pago, comercial o por suscripción';

  @override
  String get flagTypeTrace => 'Calco de la obra de otro artista';

  @override
  String get flagTypePreviouslyDeleted => 'Eliminado anteriormente';

  @override
  String get flagTypeRealPorn => 'Pornografía con personas reales';

  @override
  String get flagTypeCorrupt => 'El archivo está dañado, roto o no funciona';

  @override
  String get flagTypeInferior => 'Duplicado o versión inferior de otro post';

  @override
  String get flagTypeUploadingGuidelinesBody =>
      'Este post no cumple los estándares del sitio, ya sea en valor artístico, calidad de imagen o relevancia.\nLas preferencias personales no cuentan aquí. Si el contenido te desagrada, usa la [[e621:blacklist|lista negra]].';

  @override
  String get flagTypeYoungHumanBody =>
      'Los posts con personajes humanos o humanoides en situaciones sexuales o desnudos explícitos no se permiten en este sitio.';

  @override
  String get flagTypeDnpArtistBody =>
      'Algunos artistas han pedido que no se publiquen sus obras aquí y tienen el estado de [[avoid_posting|no publicar]].\nEste estado puede tener condiciones; consulta [[conditional_dnp]] para más información';

  @override
  String get flagTypePayContentBody =>
      'No alojamos contenido de sitios de pago ni contenido comercial de ningún tipo. Esto incluye filtraciones de Patreon y repeticiones de sitios piratas.';

  @override
  String get flagTypeTraceBody =>
      'Los calcos de obras de otros artistas no se admiten en este sitio. Inspirarse en algo está bien; copiar directamente el trabajo ajeno, no.\nDeja más información en los comentarios o marca el original como post ascendente si existe en este sitio.';

  @override
  String get flagTypePreviouslyDeletedBody =>
      'Los posts normalmente se eliminan por un motivo, y volver a subir contenido eliminado no está permitido.\nDeja más información en los comentarios o marca el post original como ascendente de este.';

  @override
  String get flagTypeRealPornBody =>
      'Los posts con pornografía de personas reales no se permiten en este sitio en absoluto. Sin excepciones.\nTen en cuenta que sí se permiten imágenes con fotografías reales no eróticas.';

  @override
  String get flagTypeCorruptBody =>
      'Algo de este post no funciona bien. Puede ser un vídeo roto o una imagen dañada.\nEn cualquier caso, describe la situación en los comentarios para evitar confusiones.';

  @override
  String get flagTypeInferiorBody =>
      'Ya existe en el sitio una versión mejor de este post.\nEsto incluye imágenes de mayor calidad (más grandes, menos comprimidas), pero también versiones «corregidas» donde el artista arregló errores visuales.\nTen en cuenta que las ediciones y versiones alternativas no entran en esta categoría.';

  @override
  String get taskCancelAll => 'Cancelar todo';

  @override
  String get taskClearDone => 'Quitar terminadas';

  @override
  String get taskClearSelection => 'Deseleccionar';

  @override
  String get taskCancel => 'Cancelar';

  @override
  String get taskDismiss => 'Descartar';

  @override
  String get taskNoTasks => 'No hay tareas';

  @override
  String get taskFailedToLoadTasks => 'No se pudieron cargar las tareas';

  @override
  String taskSelectionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '1 tarea',
    );
    return '$_temp0';
  }

  @override
  String get taskGroupActive => 'Activas';

  @override
  String get taskGroupFailed => 'Fallidas';

  @override
  String get taskActionDownload => 'descarga';

  @override
  String get taskActionFavorite => 'añadir a favoritos';

  @override
  String get taskActionUnfavorite => 'quitar de favoritos';

  @override
  String get taskDownloadRunning => 'descargando';

  @override
  String get taskFavoriteRunning => 'añadiendo a favoritos';

  @override
  String get taskUnfavoriteRunning => 'quitando de favoritos';

  @override
  String get taskDownloadCompleted => 'descargado';

  @override
  String get taskFavoriteCompleted => 'añadido a favoritos';

  @override
  String get taskUnfavoriteCompleted => 'quitado de favoritos';

  @override
  String taskQueuedTo(String action) {
    return 'en cola para $action';
  }

  @override
  String taskFailedTo(String action) {
    return '$action falló';
  }

  @override
  String taskCanceledAction(String action) {
    return '$action cancelada';
  }

  @override
  String taskTileTitle(String label, num id) {
    return 'Post #$id: $label';
  }

  @override
  String followNotificationBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¡$count posts nuevos!',
      one: '¡1 post nuevo!',
    );
    return '$_temp0';
  }

  @override
  String get followNotificationSummary => '¡Posts nuevos!';

  @override
  String get followChannelName => 'Suscripciones de etiquetas';

  @override
  String get followChannelDescription =>
      'Notificaciones de las etiquetas que sigues';

  @override
  String get hostUnavailableTitle => 'Sitio no disponible';

  @override
  String hostUnavailableBody(String host) {
    return '¡Parece que $host no está disponible!';
  }

  @override
  String get hostUnavailableResolveHint =>
      'Resuelve el problema en la ventana del navegador que se abrirá.\n\nSe guardará la cookie del CAPTCHA de Cloudflare.';

  @override
  String get hostUnavailableResolve => 'Resolver';

  @override
  String hostUnavailableWaitBody(String host) {
    return '\nEspera a que $host resuelva la situación por su parte.';
  }

  @override
  String get downloadChooseFolder => 'Elegir carpeta';

  @override
  String get searchFilterTitle => 'Filtros';

  @override
  String get searchFilterQueryLabel => 'Consulta actual:';

  @override
  String get dtextParsingFailed => 'No se pudo analizar el DText';
}
