// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get weeklyReportsTitle => 'Informes Semanales';

  @override
  String get noReportsYet => 'Aún no hay informes';

  @override
  String get createFirstReportPrompt =>
      'Haga clic en + para crear su primer informe semanal';

  @override
  String get generating => 'Generando...';

  @override
  String get createReport => 'Crear Informe';

  @override
  String costTokens(Object cost) {
    return 'Costo: $cost fichas';
  }

  @override
  String balanceParenthesis(Object balance) {
    return '(Saldo: $balance)';
  }

  @override
  String get watchAdForToken => 'Ver Anuncio (+1 Ficha)';

  @override
  String get selectReportType => 'Tipo de Informe:';

  @override
  String generatedAtDate(Object date) {
    return 'Generado: $date';
  }

  @override
  String get insufficientTokensWatchAd =>
      '¡Fichas insuficientes! Vea un anuncio para ganar fichas.';

  @override
  String get reportCreatedSuccess => '¡Informe creado! ✨';

  @override
  String get reportAlreadyExists => 'Ya existe un informe para esta semana.';

  @override
  String get tokenEarnedSuccess => '¡+1 ficha ganada! 🎉';

  @override
  String get about => 'Acerca de';

  @override
  String get account => 'Cuenta';

  @override
  String get achievements => 'Logros';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'Días activos';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => 'Añadir';

  @override
  String get addDate => 'Añadir fecha';

  @override
  String get addFirstTransaction => 'Añadir primera transacción';

  @override
  String get addHabit => 'Añadir Hábito';

  @override
  String get addImage => 'Añadir imagen';

  @override
  String get addNew => 'Agregar nuevo';

  @override
  String get addNewHabit => 'Añadir Nuevo Hábito';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Añadir opciones para empezar';

  @override
  String get addSpecialDays => 'Añadir días especiales';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'Añadir tarea';

  @override
  String get addText => 'Añadir texto';

  @override
  String get addToList => 'Añadir a la lista';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'Hábito Avanzado';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get aiAssistantOnline => 'En línea';

  @override
  String get aiAssistantTitle => 'Mira Asistan';

  @override
  String aiContextMessage(Object tip) {
    return '¡Hola! He notado que te interesa este consejo:\n\n\"$tip\"\n\n¿Quieres que te enseñe a aplicarlo en Mira?';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return '$count hábitos añadidos con IA';
  }

  @override
  String get aiInputHint => 'Describe el hábito que quieres crear...';

  @override
  String get aiPoweredRecommendations => 'AI powered recommendations';

  @override
  String get aiPreviewTitle => 'Sugerencias de IA';

  @override
  String get aiQuickFinance => 'Consejos de presupuesto';

  @override
  String get aiQuickGamification => '¿Qué es el sistema XP?';

  @override
  String get aiQuickHabit => 'Crear nuevo hábito';

  @override
  String get aiQuickMood => 'Analizar mi estado de ánimo';

  @override
  String get aiQuickMotivation => 'Dame motivación';

  @override
  String get aiQuickProfile => 'Mi personaje de IA';

  @override
  String get aiQuickTimer => '¿Cómo usar el temporizador?';

  @override
  String get aiQuickVision => 'Ayuda con el Tablero de Visión';

  @override
  String get aiRetry => 'Reintentar (Reglas más estrictas)';

  @override
  String get aiShowMeHow => 'Sí, enséñame cómo';

  @override
  String get aiTip0 =>
      '¿Sabías que? Puedes crear un Tablero de Visión para tus objetivos a largo plazo.';

  @override
  String get aiTip1 =>
      'Consejo: Usa el temporizador para sesiones de trabajo enfocadas.';

  @override
  String get aiTip2 =>
      'Registra tu estado de ánimo diariamente para ver cambios a lo largo del tiempo.';

  @override
  String get aiTip3 =>
      'Los hábitos se mantienen mejor si los haces a la misma hora todos los días.';

  @override
  String get aiTip4 =>
      'Divide las grandes visiones en tareas más pequeñas y manejables.';

  @override
  String get aiTip5 =>
      'Usa la pestaña de Finanzas para rastrear tus gastos diarios.';

  @override
  String get aiTip6 =>
      '¿Necesitas ayuda? ¡Toca aquí para preguntar al asistente de IA!';

  @override
  String get aiTip7 => '¡La consistencia es clave! No rompas la racha.';

  @override
  String get aiWelcomeMessage =>
      '¡Hola! Soy tu asistente Mira. ¿En qué puedo ayudarte hoy? Puedes preguntarme sobre visiones, hábitos, temporizadores u otras funciones.';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get allLabel => 'Todos';

  @override
  String get alsoDeleteLinkedHabits =>
      'Eliminar también los hábitos vinculados';

  @override
  String get amount => 'Cantidad';

  @override
  String get amountLabel => 'Cantidad';

  @override
  String get analysis => 'Análisis';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Apariencia';

  @override
  String get apply => 'Aplicar';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Esta visión dura unos $days días';
  }

  @override
  String get assetsReloadHint =>
      'Puede ser necesario reiniciar la aplicación por completo para cargar algunos activos.';

  @override
  String get atLeast => 'Al menos';

  @override
  String get atMost => 'Como máximo';

  @override
  String get autoBackupSubtitle =>
      'Haz una copia de seguridad de tus datos automáticamente en Google Drive cada 24 horas.';

  @override
  String get autoBackupTitle => 'Copia de seguridad automática';

  @override
  String get averageMood => 'Estado de ánimo promedio';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => 'Placa de fondo';

  @override
  String get backupError => 'Error de copia de seguridad';

  @override
  String get backupFailed => 'Error en la copia de seguridad';

  @override
  String get backupNow => 'Hacer copia ahora';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String backupSuccess(Object id) {
    return 'Respaldado: $id';
  }

  @override
  String get backupTitle => 'Copia de seguridad';

  @override
  String get backupToDrive => 'Copia en Drive';

  @override
  String get badgeActive100dDesc => 'Estar activo en 100 días diferentes';

  @override
  String get badgeActive100dTitle => '100 Días Activo';

  @override
  String get badgeActive30dDesc => 'Estar activo en 30 días diferentes';

  @override
  String get badgeActive30dTitle => '30 Días Activo';

  @override
  String get badgeActive7dDesc => 'Estar activo en 7 días diferentes';

  @override
  String get badgeActive7dTitle => '7 Días Activo';

  @override
  String get badgeCategoryActivity => 'Actividad';

  @override
  String get badgeCategoryFinance => 'Finanzas';

  @override
  String get badgeCategoryHabit => 'Hábito';

  @override
  String get badgeCategoryLevel => 'Nivel';

  @override
  String get badgeCategoryVision => 'Visión';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => 'Registrar 100 transacciones';

  @override
  String get badgeFin100Title => 'Financiero 100';

  @override
  String get badgeFin10Desc => 'Registrar 10 transacciones';

  @override
  String get badgeFin10Title => 'Financiero 10';

  @override
  String get badgeFin250Desc => 'Registrar 250 transacciones';

  @override
  String get badgeFin250Title => 'Financiero 250';

  @override
  String get badgeFin50Desc => 'Registrar 50 transacciones';

  @override
  String get badgeFin50Title => 'Financiero 50';

  @override
  String get badgeHabit100Desc => 'Completar 100 hábitos en total';

  @override
  String get badgeHabit100Title => 'Hábito 100';

  @override
  String get badgeHabit10Desc => 'Completar 10 hábitos en total';

  @override
  String get badgeHabit10Title => 'Hábito 10';

  @override
  String get badgeHabit200Desc => 'Completar 200 hábitos en total';

  @override
  String get badgeHabit200Title => 'Hábito 200';

  @override
  String get badgeHabit50Desc => 'Completar 50 hábitos en total';

  @override
  String get badgeHabit50Title => 'Hábito 50';

  @override
  String get badgeLevel10Desc => 'Alcanzar el nivel 10';

  @override
  String get badgeLevel10Title => 'Nivel 10';

  @override
  String get badgeLevel20Desc => 'Alcanzar el nivel 20';

  @override
  String get badgeLevel20Title => 'Nivel 20';

  @override
  String get badgeLevel5Desc => 'Alcanzar el nivel 5';

  @override
  String get badgeLevel5Title => 'Nivel 5';

  @override
  String get badgeVision10Desc => 'Crear 10 visiones';

  @override
  String get badgeVision10Title => 'Gran Maestro de la Visión';

  @override
  String get badgeVision1Desc => 'Crea tu primera visión';

  @override
  String get badgeVision1Title => 'Visionario';

  @override
  String get badgeVision5Desc => 'Crear 5 visiones';

  @override
  String get badgeVision5Title => 'Maestro de la Visión';

  @override
  String get badgeVisionHabits3Desc => 'Vincular 3+ hábitos a una visión';

  @override
  String get badgeVisionHabits3Title => 'Conector';

  @override
  String get badgeXp1000Desc => 'Ganar un total de 1000 XP';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => 'Ganar un total de 500 XP';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => 'Insignias';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => 'Entre 1 y 360';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => 'Biografía';

  @override
  String get bioHint => 'Una breve biografía sobre ti';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => 'Descanso';

  @override
  String get breakdownByCategory => 'Desglose por categoría';

  @override
  String get bringForward => 'Traer adelante';

  @override
  String bugReportFailedError(Object error) {
    return 'Failed to send bug report: $error';
  }

  @override
  String bugReportFailedStatus(Object statusCode) {
    return 'Failed to send bug report: $statusCode';
  }

  @override
  String get bugReportSentSuccess =>
      'Your bug report has been sent successfully. Thank you!';

  @override
  String get buyPremium => 'Buy Premium';

  @override
  String get canIGetRefund => 'Can I get a refund?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'Categoría';

  @override
  String get categoryName => 'Nombre de la categoría';

  @override
  String get characterDescBalancedMindful =>
      'You\'re calm, stable, and value inner peace. You excel at maintaining balance and approaching life with mindfulness and composure.';

  @override
  String get characterDescExplorer =>
      'You\'re curious, creative, and love variety. You thrive on learning new things and trying different approaches to life\'s challenges.';

  @override
  String get characterDescPlanner =>
      'You\'re organized, goal-oriented, and thrive on structure. You excel at turning dreams into actionable plans and following through with discipline.';

  @override
  String get characterDescSocialConnector =>
      'You\'re warm, empathetic, and energized by relationships. You find meaning in connecting with others and building strong communities.';

  @override
  String get characterTypeBalancedMindful => 'The Balanced Mindful';

  @override
  String get characterTypeExplorer => 'The Explorer';

  @override
  String get characterTypePlanner => 'The Planner';

  @override
  String get characterTypeSocialConnector => 'The Social Connector';

  @override
  String get checkboxType => 'Checkbox';

  @override
  String get checkboxTypeDesc => 'Simple check';

  @override
  String get checkingPurchases => 'Checking purchases...';

  @override
  String get chooseBestCategory => 'Elige la mejor categoría para tu hábito';

  @override
  String get chooseColor => 'Elegir color:';

  @override
  String get chooseEmoji => 'Elegir Emoji:';

  @override
  String get choosePhoto => 'Elegir foto';

  @override
  String get choosePhotoSubtitle => 'Elige una foto que te motive';

  @override
  String get choosePhotoDesc => 'Elige una foto que te inspire';

  @override
  String get clear => 'Limpiar';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get clearHistory => 'Limpiar historial';

  @override
  String get close => 'Cerrar';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'Decide entre dos opciones';

  @override
  String get coinFlipInstruction => '¡Escribe dos opciones y lanza la moneda!';

  @override
  String get coinFlipTitle => 'Lanzar moneda';

  @override
  String get colorLabel => 'Color';

  @override
  String get colorTheme => 'Tema de color';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'Completado (día seleccionado)';

  @override
  String get confirmDeleteAccount => 'Confirmar eliminación de cuenta';

  @override
  String get confirmHabits => 'Confirmar hábitos';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueText => 'Devam Et';

  @override
  String get cottonCandy => 'Algodón de azúcar';

  @override
  String get cottonCandyDesc => 'Algodón de azúcar - Rosa y Azul';

  @override
  String get countdownConfigureTitle => 'Configurar cuenta atrás';

  @override
  String get countdownLabel => 'COUNTDOWN';

  @override
  String get cozyJournal => 'Diario acogedor';

  @override
  String get cozyJournalDesc => 'Tonos marrones y línea de tiempo';

  @override
  String get crashReports => 'Crash reports';

  @override
  String get crashReportsSubtitle => 'Send anonymous reports on app crashes';

  @override
  String get create => 'Crear';

  @override
  String get createAdvancedHabit => 'Crear Hábito Avanzado';

  @override
  String get createDailyTask => 'Crear tarea diaria';

  @override
  String get createFirstHabit => 'Crear primer hábito';

  @override
  String get createFirstVision => 'Crear tu primera visión';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => 'Crear plantilla de hábito';

  @override
  String get createHabitTitle => 'Crear Hábito';

  @override
  String get createList => 'Crear lista';

  @override
  String get createNewCategory => 'Crear Nueva Categoría';

  @override
  String get createNewList => 'Crear nueva lista';

  @override
  String get createVision => 'Crear Visión';

  @override
  String get createVisionTemplateTitle => 'Crear plantilla de visión';

  @override
  String get createVisionWithAI => 'Crear visión con IA';

  @override
  String get createWithAi => 'Crear con IA';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get custom => 'Personalizado';

  @override
  String get customCategories => 'Categorías personalizadas';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => 'Ej: ✨';

  @override
  String get customEmojiOptional => 'Emoji personalizado (opcional)';

  @override
  String get customFrequency => 'Personalizado';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => 'Ej: porción, serie, km...';

  @override
  String get daily => 'Diario';

  @override
  String get dailyCheck => 'Comprobación diaria';

  @override
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => 'Límite diario';

  @override
  String get dailyTask => 'Tarea diaria';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Tarea diaria creada: $title';
  }

  @override
  String get dailyTasksSection => 'Tareas diarias';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get dashboard => 'Panel';

  @override
  String get date => 'Fecha';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Vie';

  @override
  String get dayMonShort => 'Lun';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Día $start–$end';
  }

  @override
  String get daySatShort => 'Sáb';

  @override
  String dayShort(Object day) {
    return 'Día $day';
  }

  @override
  String get daySunShort => 'Dom';

  @override
  String get dayThuShort => 'Jue';

  @override
  String get dayTueShort => 'Mar';

  @override
  String get dayWedShort => 'Mié';

  @override
  String get days => 'gün';

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String daysAverageShort(Object days) {
    return '${days}d prom.';
  }

  @override
  String daysCount(Object count) {
    return '$count días';
  }

  @override
  String get daysInterval => 'days';

  @override
  String get daysIntervalLabel => 'days';

  @override
  String daysLater(Object days) {
    return '$days days later';
  }

  @override
  String get daysLeft => 'days left';

  @override
  String get daysRemaining => 'Days Remaining';

  @override
  String get decisionEggDescription => 'Elige un huevo místico';

  @override
  String get decisionEggTitle => 'Huevo de la Decisión';

  @override
  String get defaultUnit => 'adet';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAccountFailed => 'Account deletion failed';

  @override
  String get deleteAccountRequestSuccess =>
      'Su solicitud de eliminación de cuenta se ha recibido con éxito';

  @override
  String get deleteAccountSubtitle =>
      'Solicitar la eliminación de su cuenta y datos';

  @override
  String get deleteAccountWarning =>
      'Esta acción no se puede deshacer. Por favor, confirme el correo electrónico asociado a su cuenta.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllDataConfirmContent =>
      'Are you sure you want to delete all your app data? This action cannot be undone.';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return '¿Eliminar la categoría \"$name\"?';
  }

  @override
  String get deleteCategoryTitle => 'Eliminar categoría';

  @override
  String get deleteCustomCategoryConfirm =>
      '¿Eliminar esta categoría personalizada?';

  @override
  String get deleteEntryConfirm => '¿Eliminar esta entrada?';

  @override
  String deleteHabitConfirm(Object title) {
    return '¿Eliminar el hábito \"$title\"?';
  }

  @override
  String get deleteListMessage =>
      'Esta lista se eliminará. Elige qué hacer con los elementos vinculados:';

  @override
  String get deleteListTitle => 'Eliminar lista';

  @override
  String get deleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage =>
      '¿Quieres eliminar esta tarea diaria? Esta acción se puede deshacer.';

  @override
  String get deleteTaskConfirmTitle => '¿Eliminar tarea?';

  @override
  String deleteTransactionConfirm(Object title) {
    return '¿Eliminar el registro \"$title\"?';
  }

  @override
  String get deleteVisionMessage => '¿Eliminar esta visión?';

  @override
  String get deleteVisionTitle => 'Eliminar visión';

  @override
  String get descHint => 'Detalles sobre tu hábito (opcional)';

  @override
  String get descriptionHintOptional => 'Açıklama ekle (isteğe bağlı)';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get detailedCharts => 'Detailed charts and statistics';

  @override
  String get diagnosticsData => 'Diagnostics data';

  @override
  String get diagnosticsDataSubtitle => 'Share anonymous usage statistics';

  @override
  String get difficulty => 'Nivel de Dificultad';

  @override
  String get drinkWater => 'Su İç';

  @override
  String get duration => 'Duración';

  @override
  String get durationAutoLabel => 'Duración (auto)';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => 'Selección de duración';

  @override
  String get durationType => 'Tipo de duración';

  @override
  String get earthTheme => 'Tierra';

  @override
  String get earthThemeDesc => 'Colores de la tierra';

  @override
  String get easy => 'Fácil';

  @override
  String get edit => 'Editar';

  @override
  String get editCategory => 'Editar Categoría';

  @override
  String get editHabit => 'Editar Hábito';

  @override
  String get editListTitle => 'Editar lista';

  @override
  String get education => 'Educación';

  @override
  String get eggRevealMessage => '¡El huevo místico ha hablado! ✨';

  @override
  String get eggSelectMessage => 'Piensa en una pregunta y toca un huevo 🥚';

  @override
  String get emojiAndColor => 'Emoji y Color';

  @override
  String get emojiCategoryAnimals => 'Animals';

  @override
  String get emojiCategoryCare => 'Care';

  @override
  String get emojiCategoryFood => 'Food';

  @override
  String get emojiCategoryHealth => 'Health';

  @override
  String get emojiCategoryLife => 'Life';

  @override
  String get emojiCategoryNature => 'Nature';

  @override
  String get emojiCategoryPopular => 'Popular';

  @override
  String get emojiCategoryProductivity => 'Productivity';

  @override
  String get emojiCategorySport => 'Sport';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get emptyHabitSubtitle =>
      'Crea tu primer hábito para rastrear tu progreso.';

  @override
  String get emptyHabitTitle => 'Comienza tu viaje';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get enableReminder => 'Activar Recordatorio';

  @override
  String get endDate => 'Fecha de finalización';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => 'Día de finalización (opcional)';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Introduce un plan mensual para calcular un límite diario.';

  @override
  String get enterNameAndDesc =>
      'Introduce el nombre y la descripción de tu hábito';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => 'Introducir valor';

  @override
  String get enterYourName => 'Introduce tu nombre';

  @override
  String get entries => 'Entradas';

  @override
  String get entrySaved => 'Entry saved successfully!';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get every => 'Every';

  @override
  String get everyDay => 'Every day';

  @override
  String get everyLabel => 'Every';

  @override
  String get everyNDaysQuestion => '¿Cada cuántos días?';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => 'Todos los días';

  @override
  String get exact => 'Exacto';

  @override
  String get exactAlarmPermission => 'Permiso de alarma exacta (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Ejemplo: $example';
  }

  @override
  String get expenseDelta => 'Gasto Δ';

  @override
  String get expenseDistributionPie => 'Distribución de gastos (tarta)';

  @override
  String get expenseEditTitle => 'Editar Gasto';

  @override
  String get expenseLabel => 'Gasto';

  @override
  String get expenseNewTitle => 'Nuevo Gasto';

  @override
  String failedToLoad(Object error) {
    return 'Error al cargar: $error';
  }

  @override
  String get featureAdvancedFinance => 'Gelişmiş Finans Özellikleri';

  @override
  String get featureAdvancedHabits => 'Gelişmiş Alışkanlık Oluşturma';

  @override
  String get featureAiBioClock => 'AI Destekli Biyolojik Saat';

  @override
  String get featureAiBioClockDesc =>
      'Biyolojik ritminize göre optimum zamanlama';

  @override
  String get featureAiWeeklyReport => 'AI Destekli Haftalık Rapor';

  @override
  String get featureAiWeeklyReportDesc => 'İlerlemenizin detaylı AI analizi';

  @override
  String get featureBackup => 'Yedekleme Özelliği';

  @override
  String get featurePremiumThemes => 'Premium Temalar';

  @override
  String get featureVisionCreation => 'Vizyon Oluşturma';

  @override
  String get feelingMoreSpecific => '¿Puedes ser más específico?';

  @override
  String get filterTitle => 'Filtro';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'Finanzas';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Análisis Financiero · $month';
  }

  @override
  String get financeLast7Days => 'Finanzas · Últimos 7 días';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'Finalizar';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Fijo';

  @override
  String get flexiblePlan => 'Flexible plan, cancel anytime';

  @override
  String get flipCoin => 'Lanzar moneda';

  @override
  String get focusLabel => 'FOCUS';

  @override
  String get focusedZen => 'Odaklanmış Zen';

  @override
  String get focusedZenDesc => 'Minimalist, tek odak noktası';

  @override
  String get font => 'Fuente';

  @override
  String get forestTheme => 'Bosque';

  @override
  String get forestThemeDesc => 'Tema verde natural';

  @override
  String get forever => 'Para siempre';

  @override
  String get fortuneDisclaimer => 'La adivinación es solo para entretenimiento';

  @override
  String fortuneEggSemantic(int index) {
    return 'Huevo de la fortuna $index';
  }

  @override
  String get fortuneEggsSubtitle => 'Elige un huevo para revelar tu fortuna';

  @override
  String get fortuneNoQuestion => 'Aún no has hecho una pregunta';

  @override
  String get fortunePlay => 'Jugar';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => '¿Qué te gustaría saber?';

  @override
  String get fortuneQuestionPrompt => 'Haz tu pregunta';

  @override
  String get fortuneResultTitle => 'Tu fortuna';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => 'Huevos de la fortuna';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get fullScreen => 'Pantalla completa';

  @override
  String get gallery => 'Galería';

  @override
  String get gamesDescription =>
      '¿Te cuesta decidir? ¡Toma tu decisión con juegos divertidos!';

  @override
  String get gamesTitle => 'Juegos';

  @override
  String get general => 'General';

  @override
  String get generalNotifications => 'Notificaciones generales';

  @override
  String get generate => 'Generar';

  @override
  String get glasses => 'Vasos';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'Dorado';

  @override
  String get goldenThemeDesc => 'Tema dorado cálido';

  @override
  String get goodMorning => '¡Buenos días! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Concedido';

  @override
  String get greatDayAhead => '¡Hoy es un gran día, puedes hacerlo!';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get guestAccount => 'Cuenta de invitado';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

  @override
  String get habit => 'Hábito';

  @override
  String habitAddError(Object error) {
    return 'Error adding habits: $error';
  }

  @override
  String habitAddSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits added',
      one: '1 habit added',
      zero: 'No habits added',
    );
    return '$_temp0';
  }

  @override
  String habitCreatedMessage(Object title) {
    return 'Hábito creado: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Hábito eliminado: $title';
  }

  @override
  String get habitDescription => 'Descripción';

  @override
  String get habitDescriptionHint => 'Añadir una breve descripción...';

  @override
  String get habitDetails => 'Detalles del Hábito';

  @override
  String get habitExplorerCreativeProject => 'Creative Project Time';

  @override
  String get habitExplorerCreativeProjectDesc =>
      'Work on a creative project that sparks your imagination.';

  @override
  String get habitExplorerExplorePlace => 'Explore a New Place';

  @override
  String get habitExplorerExplorePlaceDesc =>
      'Visit a new neighborhood, park, or location in your area.';

  @override
  String get habitExplorerLearnNewSkill => 'Learn Something New';

  @override
  String get habitExplorerLearnNewSkillDesc =>
      'Dedicate time each week to learning a new skill or subject.';

  @override
  String get habitExplorerReadDiverse => 'Read Diverse Content';

  @override
  String get habitExplorerReadDiverseDesc =>
      'Read books, articles, or content from different genres and perspectives.';

  @override
  String get habitExplorerTryNewActivity => 'Try a New Activity';

  @override
  String get habitExplorerTryNewActivityDesc =>
      'Step out of your comfort zone and experience something different.';

  @override
  String get habitMindfulBreathing => 'Deep Breathing Exercise';

  @override
  String get habitMindfulBreathingDesc =>
      'Practice deep breathing techniques to center yourself.';

  @override
  String get habitMindfulGratitude => 'Gratitude Practice';

  @override
  String get habitMindfulGratitudeDesc =>
      'Write down three things you\'re grateful for today.';

  @override
  String get habitMindfulJournaling => 'Reflective Journaling';

  @override
  String get habitMindfulJournalingDesc =>
      'Journal your thoughts and reflections for self-awareness.';

  @override
  String get habitMindfulMeditation => 'Meditation';

  @override
  String get habitMindfulMeditationDesc =>
      'Practice mindfulness meditation for 10-15 minutes.';

  @override
  String get habitMindfulNatureWalk => 'Nature Walk';

  @override
  String get habitMindfulNatureWalkDesc =>
      'Take a mindful walk in nature, paying attention to your surroundings.';

  @override
  String get habitName => 'Nombre del Hábito';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => 'Ej: Beber agua, Leer páginas...';

  @override
  String get habitNameHintTimer => 'Ej: Meditación, Ejercicio...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => 'Hábito no encontrado.';

  @override
  String get habitOfThisVision => 'Hábito de esta visión';

  @override
  String get habitPlannerGoalSetting => 'Monthly Goal Setting';

  @override
  String get habitPlannerGoalSettingDesc =>
      'Set specific, measurable goals for the month ahead.';

  @override
  String get habitPlannerMorningRoutine => 'Morning Routine';

  @override
  String get habitPlannerMorningRoutineDesc =>
      'Start each day with a structured morning routine to set the tone for productivity.';

  @override
  String get habitPlannerTaskPrioritization => 'Daily Task Prioritization';

  @override
  String get habitPlannerTaskPrioritizationDesc =>
      'Identify your top 3 priorities for the day each morning.';

  @override
  String get habitPlannerTimeBlocking => 'Time Blocking';

  @override
  String get habitPlannerTimeBlockingDesc =>
      'Schedule your day in focused time blocks for deep work.';

  @override
  String get habitPlannerWeeklyReview => 'Weekly Review';

  @override
  String get habitPlannerWeeklyReviewDesc =>
      'Review your week\'s progress and plan for the next week every Sunday.';

  @override
  String get habitReminderBody => 'Time to complete your habit!';

  @override
  String get habitReminders => 'Recordatorios de hábitos';

  @override
  String get habitRemindersSubtitle => 'Recordatorios diarios para tus hábitos';

  @override
  String get habitSocialCallFriend => 'Call a Friend';

  @override
  String get habitSocialCallFriendDesc =>
      'Reach out to a friend or family member for a meaningful conversation.';

  @override
  String get habitSocialCompliment => 'Give a Genuine Compliment';

  @override
  String get habitSocialComplimentDesc =>
      'Brighten someone\'s day with a sincere compliment.';

  @override
  String get habitSocialFamilyTime => 'Quality Family Time';

  @override
  String get habitSocialFamilyTimeDesc =>
      'Spend dedicated time with family members without distractions.';

  @override
  String get habitSocialGroupActivity => 'Join Group Activity';

  @override
  String get habitSocialGroupActivityDesc =>
      'Participate in a group activity or social event.';

  @override
  String get habitSocialVolunteer => 'Volunteer';

  @override
  String get habitSocialVolunteerDesc =>
      'Give back to your community through volunteer work.';

  @override
  String get habitTypeLabel => 'Habit Type';

  @override
  String get habitUpdatedMessage => 'Hábito actualizado.';

  @override
  String get habits => 'Hábitos';

  @override
  String get habitsSection => 'Hábitos';

  @override
  String get hard => 'Difícil';

  @override
  String get hardMode => 'Modo difícil';

  @override
  String get headerFocusLabel => 'Foco';

  @override
  String get headerFocusReady => 'Listo';

  @override
  String get headerHabitsLabel => 'Hábito';

  @override
  String get health => 'Salud';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'sa';

  @override
  String get hours => 'Horas';

  @override
  String get howAreYouFeeling => '¿Cómo te sientes?';

  @override
  String get howDoYouFeel => '¿Cómo te sientes hoy?';

  @override
  String get howOftenDoHabit =>
      'Decide con qué frecuencia realizarás tu hábito';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => 'Cómo ganar';

  @override
  String get howToTrackHabit => 'Elige cómo se seguirá tu hábito';

  @override
  String get ifCondition => 'Si';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'Importar desde enlace';

  @override
  String get importantNotice => 'Aviso importante';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => 'Δ de ingresos';

  @override
  String get incomeEditTitle => 'Editar Ingreso';

  @override
  String get incomeLabel => 'Ingreso';

  @override
  String get incomeNewTitle => 'Nuevo Ingreso';

  @override
  String get incompleteSelectedDay => 'Incompleto (día seleccionado)';

  @override
  String get input => 'Entrada';

  @override
  String get insights => 'Insights';

  @override
  String get invalidLink => 'Enlace no válido.';

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get issueDescription => 'Issue Description';

  @override
  String get issueDescriptionHint => 'Describe the issue in detail...';

  @override
  String get journalEntry => 'Journal Entry';

  @override
  String get journalEntryDesc =>
      'Is there anything you\'d like to write about today?';

  @override
  String get journalHint => 'Something you\'d like to write about today...';

  @override
  String get jsonDataExample => 'JSON Data (example):';

  @override
  String get keepItUp => '¡Genial! ¡Sigue así! 💪';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelection => 'Selección de Idioma';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Sueños de lavanda';

  @override
  String get lavenderDreamsDesc => 'Tonos elegantes de lavanda y lila';

  @override
  String get letsPlayGame => '¡Vamos a jugar! 🎮';

  @override
  String get letsStart => '¡Empecemos!';

  @override
  String levelLabel(Object level) {
    return 'Nivel $level';
  }

  @override
  String levelShort(Object level) {
    return 'N$level';
  }

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get likertAgree => 'De acuerdo';

  @override
  String get likertDisagree => 'En desacuerdo';

  @override
  String get likertNeutral => 'Neutral';

  @override
  String get likertStronglyAgree => 'Totalmente de acuerdo';

  @override
  String get likertStronglyDisagree => 'Totalmente en desacuerdo';

  @override
  String get linkHabits => 'Vincular hábitos';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'Lista creada: $title';
  }

  @override
  String get listLabel => 'Lista';

  @override
  String get listNameHint => 'Ej: Salud';

  @override
  String get listNameLabel => 'Nombre de la lista';

  @override
  String get loadingHabits => 'Cargando hábitos...';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get longestStreak => 'Racha más larga';

  @override
  String get manageLists => 'Gestionar listas';

  @override
  String get manageListsSubtitle =>
      'Añadir una nueva lista, renombrar o eliminar.';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => 'Gestionar Suscripción';

  @override
  String get manageSubscriptionDesc =>
      'Change plan, cancel or view billing info';

  @override
  String get manageSubscriptionSubtitle =>
      'Administra tu suscripción a Mira Plus a través de Google Play';

  @override
  String get manageVisionTasks => 'Manage Tasks';

  @override
  String get manualFallback => 'Crear manualmente';

  @override
  String get maxOptionsReached => 'Puedes añadir un máximo de 12 opciones';

  @override
  String get meditation => 'Meditación';

  @override
  String get medium => 'Medio';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Atención Plena';

  @override
  String get mintFresh => 'Menta fresca';

  @override
  String get mintFreshDesc => 'Tonos frescos de menta y turquesa';

  @override
  String get minutes => 'Minutos';

  @override
  String get minutesSuffixShort => 'min';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Pzt';

  @override
  String get monthCount => 'Número de meses';

  @override
  String get monthCountHint => 'Ej: 12';

  @override
  String get monthSuffixShort => 'mes';

  @override
  String get monthly => 'Mensual';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'Ayın belirli günlerinde';

  @override
  String get monthlyProgress => 'Progreso mensual';

  @override
  String get monthlyTrend => 'Tendencia mensual';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => 'Estado de ánimo';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => 'Malo';

  @override
  String get moodBadDesc => 'Pasando un mal momento';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => 'Excelente';

  @override
  String get moodExcellentDesc => 'Me siento increíble';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => 'Rastrea tu bienestar emocional';

  @override
  String get moodFlowTitle => '¿Cómo te sientes?';

  @override
  String get moodGood => 'Bueno';

  @override
  String get moodGoodDesc => 'Me siento positivo';

  @override
  String get moodGreat => 'Genial';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodNeutralDesc => 'Me siento bien';

  @override
  String get moodOk => 'Bien';

  @override
  String get moodSelection => 'Selección de estado de ánimo';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String get moodTerribleDesc => 'Me siento muy mal';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get moodTrend => 'Mood Trend (Last 30 Days)';

  @override
  String get mostCommonEmotion => 'Most Common Emotion';

  @override
  String get mostCommonMood => 'Most Common Mood';

  @override
  String get mostCommonReason => 'Most Common Reason';

  @override
  String get motivation => 'Motivación';

  @override
  String motivationBody(Object percent, Object period) {
    return '¡Buen trabajo! $period has alcanzado una tasa de éxito del $percent%.';
  }

  @override
  String motivationDayStart(Object title) {
    return '$title için harika bir gün! 🌟';
  }

  @override
  String get motivationJourneyStart => 'Her yolculuk tek bir adımla başlar!';

  @override
  String get motivationSmallSteps =>
      'Büyük hedeflere ulaşmak için küçük adımlarla başla 💪';

  @override
  String motivationWaiting(Object title) {
    return '$title seni bekliyor 🚀';
  }

  @override
  String get mtdAverageShort => 'Prom. MTD';

  @override
  String get multiple => 'Múltiple';

  @override
  String get multipleSubItems => 'Multiple sub-items';

  @override
  String get multipleSubItemsDesc => 'Çoklu alt öğeler';

  @override
  String get emotionOverwhelmed => 'Bunalmış';

  @override
  String get emotionLonely => 'Yalnız';

  @override
  String get emotionRegretful => 'Pişman';

  @override
  String get emotionInsecure => 'Güvensiz';

  @override
  String get emotionGuilty => 'Suçlu';

  @override
  String get emotionBored => 'Sıkılmış';

  @override
  String get emotionNumb => 'Hissiz';

  @override
  String get emotionConfused => 'Kafası Karışık';

  @override
  String get emotionDistracted => 'Dikkati Dağınık';

  @override
  String get emotionProud => 'Gururlu';

  @override
  String get emotionConfident => 'Kendinden Emin';

  @override
  String get emotionHopeful => 'Umutlu';

  @override
  String get emotionEuphoric => 'Coşkulu';

  @override
  String get emotionBlessed => 'Şanslı/Kutsanmış';

  @override
  String get emotionUnstoppable => 'Durdurulamaz';

  @override
  String get reasonTitle => 'Neden';

  @override
  String get mustBePremiumToUse =>
      'You must be a Premium subscriber to use this feature.';

  @override
  String get myBigGoal => 'Büyük Hedefim';

  @override
  String get myBoard => 'My Board';

  @override
  String get mysticTheme => 'Místico';

  @override
  String get mysticThemeDesc => 'Tema púrpura místico';

  @override
  String nDaysLabel(Object count) {
    return '$count días';
  }

  @override
  String get nameHint => 'Ej: Entrenamiento diario';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => 'Nuevos hábitos';

  @override
  String get newList => 'Nueva lista';

  @override
  String get next => 'Siguiente';

  @override
  String get nextLabel => 'Siguiente';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => 'Próximo año';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noDataLast7Days => 'No hay datos de los últimos 7 días';

  @override
  String get noDataThisMonth => 'No hay datos para este mes';

  @override
  String get noEndDate => 'Sin fecha de finalización';

  @override
  String get noEndDayDefaultsDaily =>
      'Cuando no se establece un día de finalización, este hábito aparecerá todos los días por defecto.';

  @override
  String get noEntriesYet => 'Aún no hay entradas';

  @override
  String get noExpenseInThisCategory => 'No hay gastos en esta categoría';

  @override
  String get noExpenses => 'No hay gastos';

  @override
  String get noExpensesThisMonth => 'No hay gastos para este mes';

  @override
  String get noHabitsAddedYet => 'Aún no se han añadido hábitos.';

  @override
  String get noHistory => 'Sin historial';

  @override
  String get noIncomeThisMonth => 'No hay ingresos para este mes';

  @override
  String get noItemsMatchFilters =>
      'Ningún elemento coincide con los filtros seleccionados';

  @override
  String get noLinkedHabitsInVision =>
      'No hay hábitos vinculados a esta visión.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => 'No se encontraron visiones listas.';

  @override
  String get noRecordsThisMonth => 'No hay registros para este mes';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'Aún no añadido.';

  @override
  String get notGranted => 'No concedido';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'No desbloqueado';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get notificationBehavior => 'Comportamiento de notificaciones';

  @override
  String get notificationPermission => 'Permiso de notificación';

  @override
  String get notificationSettings => 'Configuración de notificaciones';

  @override
  String get notificationSettingsSubtitle =>
      'Configure sus preferencias de notificación';

  @override
  String get notificationTroubleshooting =>
      'Para que las notificaciones funcionen correctamente:\n\n• DESACTIVE la optimización de batería\n• PERMITA la actividad en segundo plano\n• Asegúrese de que los permisos de notificación estén ACTIVADOS\n• Verifique el modo \'No molestar\'';

  @override
  String get notificationTypes => 'Tipos de notificaciones';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationsMasterSubtitle =>
      'Controlar todas las notificaciones de la aplicación';

  @override
  String get numberLabel => 'Número';

  @override
  String get numericExample => 'Beber 8 vasos de agua al día';

  @override
  String get numericSettings => 'Configuración de objetivo numérico';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => 'Seguimiento de objetivo numérico';

  @override
  String get numericalGoalShort => 'Objetivo numérico';

  @override
  String get numericalType => 'Valor Numérico';

  @override
  String get oceanTheme => 'Océano';

  @override
  String get oceanThemeDesc => 'Tema azul tranquilo';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get onDailyLimit => 'Estás en tu límite diario.';

  @override
  String get onPeriodic => 'En intervalos específicos';

  @override
  String get onSpecificMonthDays => 'En días específicos del mes';

  @override
  String get onSpecificWeekdays => 'En días específicos de la semana';

  @override
  String get onSpecificYearDays => 'En días específicos del año';

  @override
  String get onboardingQ1 =>
      'Disfruto probar nuevas experiencias y explorar cosas desconocidas.';

  @override
  String get onboardingQ10 =>
      'Planifico con anticipación eventos y tareas importantes.';

  @override
  String get onboardingQ11 =>
      'Me gusta probar enfoques diferentes en lugar de ceñirme a un solo método.';

  @override
  String get onboardingQ12 =>
      'Me mantengo tranquilo bajo presión y me recupero rápidamente de los contratiempos.';

  @override
  String get onboardingQ2 =>
      'Mantengo mi espacio organizado y prefiero tener una rutina diaria estructurada.';

  @override
  String get onboardingQ3 =>
      'Me siento con energía cuando estoy con otras personas y disfruto de las reuniones sociales.';

  @override
  String get onboardingQ4 =>
      'Prefiero trabajar con otros y considero que la cooperación es más efectiva que la competencia.';

  @override
  String get onboardingQ5 =>
      'Manejo las situaciones estresantes con calma y rara vez me siento ansioso.';

  @override
  String get onboardingQ6 =>
      'Disfruto de actividades creativas como el arte, la música o la escritura.';

  @override
  String get onboardingQ7 =>
      'Me fijo metas claras y trabajo con constancia para lograrlas.';

  @override
  String get onboardingQ8 =>
      'Prefiero las actividades en grupo a pasar tiempo a solas.';

  @override
  String get onboardingQ9 =>
      'A menudo considero los sentimientos de los demás antes de tomar decisiones.';

  @override
  String get onboardingQuizIntro =>
      'Responde algunas preguntas para ayudarnos a entender mejor tu personalidad. Se basa en investigaciones psicológicas científicamente validadas.';

  @override
  String get onboardingWelcomeDesc =>
      'Tu rastreador de hábitos personal que crece contigo. Descubramos tu personalidad única y sugiramos hábitos hechos a tu medida.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Mira';

  @override
  String get once => 'Una vez';

  @override
  String get open => 'Open';

  @override
  String get openBatteryOptimization => 'Open battery optimization';

  @override
  String get openNotificationSettings => 'Open notification settings';

  @override
  String get openSystemSettings => 'Open system settings';

  @override
  String get option1 => 'Seçenek 1';

  @override
  String get option2 => 'Seçenek 2';

  @override
  String get optional => 'optional';

  @override
  String get optionalLabel => 'optional';

  @override
  String get other => 'Otro';

  @override
  String get outline => 'Contorno';

  @override
  String get outlineColor => 'Color del contorno';

  @override
  String get overall => 'General';

  @override
  String get overallProgress => 'Progreso general';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'Páginas';

  @override
  String get pastelColors => 'Colores pastel';

  @override
  String get pause => 'Pausa';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => 'Periódico';

  @override
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => 'Selección periódica';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => 'Elige el estado de ánimo de hoy';

  @override
  String get plannedMonthlySpend => 'Gasto mensual planificado';

  @override
  String plansLoadError(Object error) {
    return 'Error al cargar los planes: $error';
  }

  @override
  String get plateColor => 'Color de la placa';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get pomodoroAndCustomTimers => 'Pomodoro and custom timers';

  @override
  String get premiumBenefits => 'Premium benefits:';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get premiumPlans => 'Premium Plans';

  @override
  String get previous => 'Anterior';

  @override
  String get previousYear => 'Año anterior';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'Privacidad y seguridad';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => 'Productividad';

  @override
  String get profile => 'Perfil';

  @override
  String get profileInfo => 'Información del perfil';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get promoCodeActiveMessage =>
      'Your Premium access is activated via promo code ✨';

  @override
  String get promoCodeAlreadyUsed =>
      'A promo code has already been used on this account.';

  @override
  String get promoCodeHint => 'Enter your promo code';

  @override
  String get promoCodeInvalid =>
      'Invalid promo code. Please check and try again.';

  @override
  String get promoCodeLabel => 'Promo Code';

  @override
  String get promoCodeSuccess =>
      '🎉 Promo code applied successfully! Premium access activated.';

  @override
  String get quickSuggestions => 'Hızlı Öneriler';

  @override
  String get readBook => 'Kitap Oku';

  @override
  String get readyVisionsLoadFailed =>
      'No se pudieron cargar las visiones listas.';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'Salud';

  @override
  String get reasonOther => 'Otro';

  @override
  String get reasonPersonalGrowth => 'Personal Growth';

  @override
  String get reasonRelationship => 'Relationship';

  @override
  String get reasonSelection => 'What\'s the reason for this state?';

  @override
  String get reasonSocial => 'Social';

  @override
  String get reasonWeather => 'Weather';

  @override
  String get reasonWork => 'Trabajo';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc =>
      'Añadir automáticamente cada mes en la fecha seleccionada';

  @override
  String get recurringMonthlyTitle => 'Recurrente (mensual)';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => 'Recargar';

  @override
  String get remainingToday => 'Restante hoy';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

  @override
  String get reminderFrequency => 'Frecuencia del recordatorio';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'Configuración de recordatorios';

  @override
  String get reminderTime => 'Hora de Recordatorio';

  @override
  String get removeFromList => 'Eliminar de la lista';

  @override
  String get repeatEveryDay => 'Se repite todos los días';

  @override
  String get repeatEveryNDays => 'Repetir cada N días';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reset => 'Reiniciar';

  @override
  String get resetAction => 'Reset';

  @override
  String get resetOnboarding => 'Reset Onboarding';

  @override
  String get resetOnboardingDescription =>
      'This will clear your current personality results and let you retake the quiz.';

  @override
  String get resetOnboardingTitle => 'Reset Onboarding?';

  @override
  String get restore => 'Restore';

  @override
  String get restoreError => 'Error de restauración';

  @override
  String get restoreFailed => 'Error en la restauración';

  @override
  String get restoreLatest => 'Restaurar última';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'Descargado: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => 'Reintentar';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Regla: Duración introducida ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Regla: Duración introducida ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Regla: Duración introducida = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Regla: Valor introducido ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Regla: Valor introducido ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Regla: Valor introducido = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => 'Guardado';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => 'Plan de Ahorro / Presupuesto';

  @override
  String get scheduleHabit => 'Establece el horario de tu hábito';

  @override
  String get scheduleLabel => 'Horario';

  @override
  String get schedulingOptions => 'Opciones de programación';

  @override
  String get seconds => 'Segundos';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => 'Seleccionar';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get selectCategory => 'Seleccionar Categoría';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectAtLeastOneDay => 'Lütfen en az bir gün seçin';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'Seleccionar fecha de finalización';

  @override
  String get selectFrequency => 'Seleccionar Frecuencia';

  @override
  String get selectHabitType => 'Seleccionar Tipo de Hábito';

  @override
  String get selectHabitsToAdd =>
      'Selecciona los hábitos que te gustaría añadir a tu rutina diaria:';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc =>
      'Selecciona qué está afectando tu estado de ánimo';

  @override
  String get selectSubEmotion => 'Seleccionar sub-emoción';

  @override
  String get selectSubEmotionDesc => 'Selecciona una emoción más específica';

  @override
  String get selectTime => 'Seleccionar hora';

  @override
  String get selectYourCurrentMood => 'Selecciona tu estado de ánimo actual';

  @override
  String get selectYourMood => 'Selecciona tu estado de ánimo';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => 'Enviar atrás';

  @override
  String get setVisionTimeline => 'Establece la línea de tiempo para tu visión';

  @override
  String get settings => 'Configuraciones';

  @override
  String get shareAsLink => 'Compartir como enlace';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied =>
      'Enlace para compartir copiado al portapapeles.';

  @override
  String get shareVision => 'Compartir visión';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'Mezclar';

  @override
  String get signInFailed => 'Inicio de sesión fallido. Inténtalo de nuevo.';

  @override
  String get signInToSaveData => 'Verileri kaydetmek için giriş yap';

  @override
  String get signInWithGoogle => 'Inicia sesión con Google';

  @override
  String get signInWithGoogleButton => 'Sign in with Google';

  @override
  String get signInWithGoogleDesc =>
      'Connect your Google account to continue. Your profile info will be filled automatically.';

  @override
  String get signInWithGoogleTitle => 'Sign in with Google';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutConfirmation => 'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get simpleHabitColorSubtitle =>
      'Deja que el color refleje la personalidad del hábito';

  @override
  String get simpleHabitColorTitle => 'Elige un color';

  @override
  String get simpleHabitEmojiSubtitle => '¡Haz tu hábito más divertido!';

  @override
  String get simpleHabitEmojiTitle => 'Elige un emoji que lo represente';

  @override
  String get simpleHabitFrequencySubtitle => 'Establece tus objetivos';

  @override
  String get simpleHabitFrequencyTitle =>
      '¿Con qué frecuencia quieres hacerlo?';

  @override
  String get simpleHabitMonthDaysSubtitle => 'Decide qué días estará activo';

  @override
  String get simpleHabitMonthDaysTitle => '¿Qué días del mes?';

  @override
  String get simpleHabitNameSubtitle => '¿Qué quieres convertir en hábito?';

  @override
  String get simpleHabitNameTitle => 'Ponle un nombre a tu hábito';

  @override
  String get simpleHabitPeriodicSubtitle =>
      'Establece el intervalo de repetición';

  @override
  String get simpleHabitPeriodicTitle => '¿Cada cuántos días?';

  @override
  String get simpleHabitPreviewSubtitle => '¿Todo se ve bien?';

  @override
  String get simpleHabitPreviewTitle => '¡Genial! Aquí está tu hábito';

  @override
  String get simpleHabitReminderSubtitle =>
      'No te pierdas tu hábito con un recordatorio diario';

  @override
  String get simpleHabitReminderTitle => '¿Te lo recuerdo?';

  @override
  String get simpleHabitStartDateSubtitle =>
      'Elige un punto de partida para tu viaje';

  @override
  String get simpleHabitStartDateTitle => '¿Cuándo empezarás?';

  @override
  String get simpleHabitTargetOne => 'Hábito simple (objetivo = 1)';

  @override
  String get simpleHabitWeekdaysSubtitle => 'Decide qué días estará activo';

  @override
  String get simpleHabitWeekdaysTitle => '¿Qué días?';

  @override
  String get simpleHabitWizardDesc =>
      'Te guiaré paso a paso. ¡Creemos un gran hábito juntos!';

  @override
  String get simpleHabitWizardTitle => '¿Listo para empezar un nuevo hábito?';

  @override
  String get simpleTypeShort => 'Simple';

  @override
  String get skip => 'Omitir';

  @override
  String get skipOnboarding => 'Omitir';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => 'Social';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get softCloud => 'Yumuşak Bulut';

  @override
  String get softCloudDesc => 'Bulut gibi, rüya gibi yumuşak';

  @override
  String get softPeach => '(Şeftali) Soft Peach';

  @override
  String get softPeachDesc => 'Sıcak şeftali ve krem tonları';

  @override
  String get sound => 'Sonido';

  @override
  String get soundAlerts => 'Alertas de sonido';

  @override
  String get soundSubtitle => 'Reproducir sonido con notificaciones';

  @override
  String get specificDaysOfMonth => 'Días específicos del mes';

  @override
  String get specificDaysOfWeek => 'Días específicos de la semana';

  @override
  String get specificDaysOfYear => 'Días específicos del año';

  @override
  String get spendingAdvisorNoBudget =>
      'Establece un presupuesto para recibir consejos.';

  @override
  String get spendingAdvisorOnTrack =>
      '¡Genial! Estás al día con tu presupuesto.';

  @override
  String get spendingAdvisorOverBudget =>
      'Estás por encima del presupuesto. Deja de gastar.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Puedes gastar $amount por día.';
  }

  @override
  String get spendingAdvisorTitle => 'Asesor de Gastos';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Reduce el gasto diario en $amount para mantenerte al día.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return '¡Genial! Estás gastando $amount menos que el promedio diario.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return '¡Atención! Estás gastando $amount más que el promedio diario.';
  }

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get start => 'Empezar';

  @override
  String get startDate => 'Fecha de inicio';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => 'Día de inicio (1-365)';

  @override
  String get startJourney => 'Comienza tu camino';

  @override
  String get startTest => 'Start Test';

  @override
  String get startTestDesc =>
      'If you complete the test, you will get personalized suggestions and habit recommendations. You can skip this step if you wish.';

  @override
  String get startTestTitle => 'Do you want to start the personality test?';

  @override
  String get startTrackingFinances =>
      'Finanslarınızı takip etmeye başlayın ve harcamalarınızı kontrol altına alın.';

  @override
  String get startTrackingMood => 'Start tracking your mood to see analytics';

  @override
  String get startsOn => 'Başlangıç';

  @override
  String get statsActiveDays => 'Aktif Gün';

  @override
  String get statusLabel => 'Estado';

  @override
  String get step => 'Paso';

  @override
  String stepOf(Object current, Object total) {
    return 'Paso $current de $total';
  }

  @override
  String get steps => 'Pasos';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return 'Racha de $count días';
  }

  @override
  String get streakIndicator => 'Indicador de racha';

  @override
  String get streakIndicatorDesc => 'Mostrar efectos de llama y hielo';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => 'Enojado';

  @override
  String get subEmotionAnxious => 'Ansioso';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => 'Tranquilo';

  @override
  String get subEmotionCheerful => 'Alegre';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => 'Desmoralizado';

  @override
  String get subEmotionDetermined => 'Determinado';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => 'Exhausto';

  @override
  String get subEmotionEmpty => 'Vacío';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'Entusiasta';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => 'Emocionado';

  @override
  String get subEmotionExhausted => 'Agotado';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => 'Feliz';

  @override
  String get subEmotionHelpless => 'Impotente';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => 'Desesperado';

  @override
  String get subEmotionHurt => 'Herido';

  @override
  String get subEmotionIndecisive => 'Indeciso';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'Motivado';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => 'Normal';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'Orgulloso';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => 'Triste';

  @override
  String get subEmotionSelection => 'Selección de sub-emoción';

  @override
  String get subEmotionStressed => 'Estresado';

  @override
  String get subEmotionTired => 'Cansado';

  @override
  String get subEmotionUnstoppable => 'Durdurulamaz';

  @override
  String get subscribeToEnjoyPremium => 'Subscribe to enjoy premium features';

  @override
  String get subscription => 'Abonelik';

  @override
  String get subscriptionDetails => 'Subscription Details';

  @override
  String subtaskIndex(Object index) {
    return 'Subtask $index';
  }

  @override
  String get subtasks => 'Subtasks';

  @override
  String get subtasksTitle => 'Subtasks';

  @override
  String get subtasksType => 'Subtasks';

  @override
  String get subtasksTypeDesc => 'Multi-task';

  @override
  String get success => 'Éxito';

  @override
  String get successfulDayLegend => 'Día exitoso';

  @override
  String successfulDaysCount(Object count) {
    return '$count Días Exitosos';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'Información del sistema';

  @override
  String get systemTheme => 'Tema del sistema';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

  @override
  String get target => 'Objetivo';

  @override
  String get targetDurationMinutes => 'Duración objetivo (minutos)';

  @override
  String targetShort(Object value) {
    return 'Objetivo: $value';
  }

  @override
  String get targetType => 'Tipo de objetivo';

  @override
  String get targetValue => 'Valor Objetivo';

  @override
  String get targetValueLabel => 'Valor Objetivo';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'Tarea eliminada: $title';
  }

  @override
  String get taskDescription => 'Descripción (Opcional)';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'Título de la tarea';

  @override
  String get taskTitleRequired => 'El título de la tarea es obligatorio';

  @override
  String get tellMeYourDream =>
      'Cuéntame tu sueño. Te ayudaré a crear un Tablero de Visión.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound =>
      'Detalles de la plantilla no encontrados';

  @override
  String get templatesTabManual => 'Manual';

  @override
  String get templatesTabReady => 'Listo';

  @override
  String get textLabel => 'Texto';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'Tema';

  @override
  String get themeAbyss => 'Derinlik';

  @override
  String get themeAbyssDesc => 'Karanlık ve sofistike';

  @override
  String get themeBlush => 'Allık';

  @override
  String get themeBlushDesc => 'Tatlı ve feminen';

  @override
  String get themeCotton => 'Cotton';

  @override
  String get themeCottonDesc => 'Warm & Neutral';

  @override
  String get themeCream => 'Krem';

  @override
  String get themeCreamDesc => 'Sıcak ve yumuşak';

  @override
  String get themeCrimson => 'Bordo';

  @override
  String get themeCrimsonDesc => 'Cesur ve tutkulu';

  @override
  String get themeDetails => 'Detalles del Tema';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeForestDesc => 'Rich & Organic';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeLavenderDesc => 'Calm & Dreamy';

  @override
  String get themeMatcha => 'Matcha';

  @override
  String get themeMatchaDesc => 'Fresh & Natural';

  @override
  String get themeMauve => 'Leylak';

  @override
  String get themeMauveDesc => 'Zarif ve romantik';

  @override
  String get themeMidnight => 'Gece Yarısı';

  @override
  String get themeMidnightDesc => 'Derin ve gizemli';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeOceanDesc => 'Deep & Serene';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeRoseDesc => 'Soft & Warm';

  @override
  String get themeSelection => 'Selección de Tema';

  @override
  String get themeSky => 'Sky';

  @override
  String get themeSkyDesc => 'Airy & Light';

  @override
  String get themeSlate => 'Slate';

  @override
  String get themeSlateDesc => 'Modern & Cool';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeSunsetDesc => 'Warm & Golden';

  @override
  String get themeVintageRed => 'Vintage Kırmızı';

  @override
  String get themeVintageRedDesc => 'Klasik ve zamansız kırmızı';

  @override
  String get thisFeatureIsPremium => 'This feature is Premium';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisYear => 'Este año';

  @override
  String get thursdayShort => 'Per';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst =>
      'Crea primero un hábito de temporizador';

  @override
  String get timerDescription => 'Seguimiento basado en tiempo';

  @override
  String get timerExample => 'Hacer un entrenamiento de 30 minutos';

  @override
  String get timerHabitLabel => 'Hábito de Temporizador';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Duración pendiente: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Pendiente: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Descanso';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Trabajo completado: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Ciclo de descanso largo (ej. 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Descanso largo (min)';

  @override
  String get timerPomodoroSettings => 'Configuración de Pomodoro';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Descanso corto (min)';

  @override
  String get timerPomodoroSkipPhase => 'Saltar fase';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Trabajo (min)';

  @override
  String get timerPomodoroWorkPhase => 'Trabajo';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => 'Guardar Duración';

  @override
  String get timerSaveSessionTitle => 'Guardar Sesión';

  @override
  String get timerSessionAlreadySaved => 'Esta sesión ya está guardada';

  @override
  String get timerSetDurationFirst => 'Establecer duración primero';

  @override
  String get timerSettings => 'Configuración del Temporizador';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'Cuenta atrás';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Cronómetro';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'Temporizador';

  @override
  String get times => 'Veces';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get titleHint => 'Ej: Comestibles, Freelance, etc.';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'Duración total';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => 'Progreso total';

  @override
  String get totalSuccessfulDays => 'Total de días exitosos';

  @override
  String get totalUnsuccessfulDays => 'Total de días no exitosos';

  @override
  String get trackEarnings => 'Gelirlerini takip et';

  @override
  String get trackSpending => 'Harcamalarını takip et';

  @override
  String get trends => 'Trends';

  @override
  String get trialCancelEffect =>
      'If you cancel during the free trial, you won\'t be charged immediately.';

  @override
  String get trialInfo => '14-day free trial, cancel anytime.';

  @override
  String get tuesdayShort => 'Sal';

  @override
  String get typeEmoji => 'Type an emoji from keyboard';

  @override
  String get typeEmojiHint => 'Type an emoji from keyboard';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get typeNotChangeable => 'El tipo no se puede cambiar';

  @override
  String get unassignLinkedDailyTasks => 'Desasignar tareas diarias vinculadas';

  @override
  String get unassignLinkedHabits => 'Desasignar hábitos vinculados';

  @override
  String get undo => 'Deshacer';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => 'Unidad';

  @override
  String get unitAdet => 'pza';

  @override
  String get unitAdim => 'paso';

  @override
  String get unitBardak => 'vaso';

  @override
  String get unitHint => 'Unidad (vaso, paso, página...)';

  @override
  String get unitKalori => 'cal';

  @override
  String get unitKez => 'veces';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'litro';

  @override
  String get unitSayfa => 'pág';

  @override
  String get unknownList => 'Unknown List';

  @override
  String get unlimitedDataStorage => 'Unlimited data storage';

  @override
  String get unlistedItems => 'Unlisted Items';

  @override
  String get unlockAllFeatures => 'Unlock all features and remove limits.';

  @override
  String get unnamedBackup => 'unnamed';

  @override
  String get update => 'Actualizar';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => 'Valor';

  @override
  String get vibration => 'Vibración';

  @override
  String get vibrationSubtitle => 'Vibrar con notificaciones';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'Visión';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Esta visión utilizará el último día de la plantilla: $day.';
  }

  @override
  String get visionBoard => 'Tablero de Visión';

  @override
  String get visionBoardDesc =>
      'Crea una visión para organizar tus objetivos y seguir tu viaje';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'Crear Visión';

  @override
  String get visionDurationDaysLabel => 'Duración (días)';

  @override
  String get visionDurationNote =>
      'Nota: Cuando comienza la visión, se establece una duración total; si el día de finalización excede esta duración, se acortará automáticamente.';

  @override
  String get visionEditTitle => 'Editar Visión';

  @override
  String get visionEmptyDescription =>
      'Visualiza tus objetivos y añade tu primera visión para convertir tus sueños en realidad.';

  @override
  String get visionEndDayInvalid =>
      'El día de finalización debe estar entre 1 y 365';

  @override
  String get visionEndDayLess =>
      'El día de finalización no puede ser anterior al día de inicio';

  @override
  String get visionEndDayQuestion =>
      '¿En qué día de la visión debería terminar?';

  @override
  String get visionEndDayRequired => 'Introduce el día de finalización';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo =>
      'No se especificó un día de finalización. La visión comenzará de forma abierta.';

  @override
  String get visionPlural => 'Visiones';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid =>
      'El día de inicio debe estar entre 1 y 365';

  @override
  String get visionStartDayQuestion =>
      '¿En qué día de la visión debería comenzar?';

  @override
  String get visionStartFailed => 'No se pudo iniciar la visión.';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Visión iniciada: $title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => 'Visual';

  @override
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => 'Vie';

  @override
  String get weekdaysShortMon => 'Lun';

  @override
  String get weekdaysShortSat => 'Sáb';

  @override
  String get weekdaysShortSun => 'Dom';

  @override
  String get weekdaysShortThu => 'Jue';

  @override
  String get weekdaysShortTue => 'Mar';

  @override
  String get weekdaysShortWed => 'Mié';

  @override
  String get weekly => 'Semanal';

  @override
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => 'Resumen semanal por correo';

  @override
  String get weeklyProgress => 'Progreso semanal';

  @override
  String get weeklySummaryEmail => 'Correo electrónico de resumen semanal';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => '¿Cuál es la causa?';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => '¿Qué días deben estar activos?';

  @override
  String get whichWeekdays => '¿Qué días de la semana?';

  @override
  String get worldTheme => 'Mundo';

  @override
  String get worldThemeDesc => 'Armonía de todos los colores';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP para el siguiente nivel';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get yearly => 'Anual';

  @override
  String get yearlyProgress => 'Progreso anual';

  @override
  String get yesNoDescription => 'Seguimiento simple de sí/no';

  @override
  String get yesNoExample => '¿Medité hoy?';

  @override
  String get yesNoType => 'Sí/No';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourCharacterType => 'Your Character Type';

  @override
  String get yourEmail => 'Tu correo electrónico';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get yourMoodToday => 'Your Mood Today';

  @override
  String get dailyHabitInfo => 'Este hábito se repetirá todos los días';

  @override
  String get whichDays => 'Hangi günler?';

  @override
  String get whichMonthDays => '¿Qué días del mes?';

  @override
  String get whichYearDays => 'Yılın hangi günleri?';

  @override
  String everyNDays(Object days) {
    return 'Kaç günde bir?';
  }

  @override
  String nDays(Object days) {
    return '$days gün';
  }

  @override
  String everyNDaysInfo(Object days) {
    return 'Her $days günde bir tekrarlanacak';
  }

  @override
  String get rhythmTeaserTitle =>
      'Maximiza Tus Hábitos Según Tu Reloj Biológico';

  @override
  String get rhythmTeaserSubtitle =>
      'Live Rhythm aprende tus momentos más productivos y coloca hábitos en el momento adecuado.';

  @override
  String get rhythmTeaserSkip => 'Omitir';

  @override
  String get rhythmTeaserCta => 'Ver Paquetes';

  @override
  String get rhythmWindowFocus => 'Tiempo de Enfoque';

  @override
  String get rhythmWindowFocusDesc => 'Claridad mental, aprendizaje, análisis';

  @override
  String get rhythmWindowEnergy => 'Tiempo de Energía';

  @override
  String get rhythmWindowEnergyDesc => 'Movimiento, acción, deportes';

  @override
  String get rhythmWindowLight => 'Tiempo Ligero';

  @override
  String get rhythmWindowLightDesc => 'Bajo esfuerzo, tareas pequeñas';

  @override
  String get rhythmWindowReflection => 'Tiempo de Reflexión';

  @override
  String get rhythmWindowReflectionDesc => 'Diario, contemplación, cierre';

  @override
  String get rhythmBenefit1 => 'Tarea correcta en el momento correcto';

  @override
  String get rhythmBenefit2 => 'Sin fatiga de decisión';

  @override
  String get rhythmBenefit3 => 'Personalización cada semana';

  @override
  String get rhythmAnalyzing => 'Live Rhythm está analizando...';

  @override
  String get rhythmDisclaimer =>
      'Estos no son resultados definitivos. Live Rhythm se ajustará mientras te conoce.';

  @override
  String get rhythmQ1 => '¿A qué hora sueles dormirte?';

  @override
  String get rhythmQ2 => '¿A qué hora sueles despertarte?';

  @override
  String get rhythmQ3 =>
      '¿Cuándo abordas las tareas difíciles más cómodamente?';

  @override
  String get rhythmQ4 => '¿Cuándo te sientes más lúcido para aprender?';

  @override
  String get rhythmQ5 => '¿En qué parte del día te sientes más enérgico?';

  @override
  String get rhythmA1_1 => '22:00 – 23:00';

  @override
  String get rhythmA1_2 => '23:00 – 00:00';

  @override
  String get rhythmA1_3 => '00:00 – 01:00';

  @override
  String get rhythmA1_4 => '01:00+';

  @override
  String get rhythmA1_5 => '11:00 – 12:00';

  @override
  String get rhythmA2_1 => '06:00 – 07:00';

  @override
  String get rhythmA2_2 => '07:00 – 08:00';

  @override
  String get rhythmA2_3 => '08:00 – 09:00';

  @override
  String get rhythmA2_4 => '09:00+';

  @override
  String get rhythmA3_1 => 'Temprano en la mañana';

  @override
  String get rhythmA3_2 => 'Media mañana';

  @override
  String get rhythmA3_3 => 'Tarde';

  @override
  String get rhythmA3_4 => 'Noche';

  @override
  String get rhythmA3_5 => 'Sin diferencia';

  @override
  String get rhythmA4_1 => 'Mañana';

  @override
  String get rhythmA4_2 => 'Mediodía';

  @override
  String get rhythmA4_3 => 'Tarde';

  @override
  String get rhythmA4_4 => 'Noche';

  @override
  String get rhythmA4_5 => 'Varía';

  @override
  String get rhythmA5_1 => 'Mañana';

  @override
  String get rhythmA5_2 => 'Mediodía';

  @override
  String get rhythmA5_3 => 'Tarde';

  @override
  String get rhythmA5_4 => 'Ninguno';

  @override
  String get rhythmResultTitle => 'Biyolojik Saat Profiliniz';

  @override
  String get rhythmResultSubtitle =>
      'Verilerinize dayanarak gününüzü sizin için bölümlere ayırdık.';

  @override
  String get rhythmChronoMorning => 'Sabah İnsanı (Erkenci Kuş)';

  @override
  String get rhythmChronoEvening => 'Akşam İnsanı (Gece Kuşu)';

  @override
  String get rhythmChronoIntermediate => 'Ara Tip (Dengeli)';

  @override
  String get rhythmHabitSuggestionTitle => 'Sizin İçin Önerilen Saatler:';

  @override
  String get rhythmResultGotIt => 'Harika, Başlayalım';

  @override
  String get rhythmFocusHint => 'Zihinsel çalışma, analiz, öğrenme';

  @override
  String get rhythmEnergyHint => 'Antrenman, fiziksel aktivite';

  @override
  String get rhythmLightHint => 'E-postalar, sosyal medya, ufak işler';

  @override
  String get rhythmReflectionHint => 'Günlük, kitap, uykuya hazırlık';

  @override
  String get testsSection => 'Tests';

  @override
  String get retakePersonalityTestDesc => 'Redescubre tu tipo de personalidad';

  @override
  String get retakeRhythmTest => 'Repetir Test de Ritmo';

  @override
  String get retakeRhythmTestDesc => 'Reconfigurar tu reloj biológico';

  @override
  String get rhythmWindowStepTitle => 'Mejor Ventana de Tiempo';

  @override
  String get rhythmWindowStepSubtitle =>
      '¿Cuándo te gustaría hacer este hábito?';

  @override
  String get rhythmWindowNoProfileHint =>
      'Completa el test de ritmo para obtener sugerencias personalizadas';

  @override
  String get weeklySchedule => 'Haftalık';

  @override
  String get addEvent => 'Etkinlik Ekle';

  @override
  String get eventTitle => 'Etkinlik Başlığı';

  @override
  String get eventDescription => 'Açıklama';

  @override
  String get startTime => 'Başlangıç Saati';

  @override
  String get endTime => 'Bitiş Saati';

  @override
  String get selectDay => 'Gün Seçin';

  @override
  String get eventDetails => 'Etkinlik Detayı';

  @override
  String get deleteEvent => 'Etkinliği Sil';

  @override
  String get editEvent => 'Etkinliği Düzenle';

  @override
  String get noEvents => 'Henüz etkinlik yok';

  @override
  String get habitBlock => 'Alışkanlık';

  @override
  String get customEvent => 'Özel Etkinlik';
}
