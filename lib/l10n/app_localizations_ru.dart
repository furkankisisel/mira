// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О приложении';

  @override
  String get account => 'Аккаунт';

  @override
  String get achievements => 'Достижения';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'Активные дни';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => 'Добавить';

  @override
  String get addDate => 'Добавить дату';

  @override
  String get addEvent => 'Добавить событие';

  @override
  String get addFabTooltip => 'Добавить';

  @override
  String get addFirstTransaction => 'Add first transaction';

  @override
  String get addHabit => 'Добавить привычку';

  @override
  String get addHabitToRoomPrompt =>
      'Добавьте привычку в комнату с помощью кнопки \"+\"!';

  @override
  String get addImage => 'Добавить изображение';

  @override
  String get addNew => 'Добавить новое';

  @override
  String get addNewHabit => 'Добавить новую привычку';

  @override
  String get addOptionHint => 'Add option...';

  @override
  String get addOptionsToStart => 'Add options to start';

  @override
  String get addRoomButton => 'Add Room';

  @override
  String get addSpecialDays => 'Добавить особые дни';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'Добавить задачу';

  @override
  String get addText => 'Добавить текст';

  @override
  String get addToList => 'Добавить в список';

  @override
  String addedToRoomSnackbar(Object title) {
    return '$title добавлено в комнату! 🎯';
  }

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'Продвинутая Привычка';

  @override
  String get advancedHabitSubtitle =>
      'Премиум • Создать привычку с детальными настройками';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get advancedHabitTypeDescription =>
      'Numeric goals, timers, and detailed tracking.';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get aiAssistantOnline => 'Online';

  @override
  String get aiAssistantTitle => 'Помощник Mira';

  @override
  String aiContextMessage(Object tip) {
    return 'Hello! I noticed you are interested in this tip:\n\n\"$tip\"\n\nWould you like me to show you how to apply this in Mira?';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return '$count habits added via AI';
  }

  @override
  String get aiInputHint => 'Describe the habit you want to build...';

  @override
  String get aiPoweredRecommendations => 'AI powered recommendations';

  @override
  String get aiPreviewTitle => 'AI Suggestions';

  @override
  String get aiQuickFinance => 'Budgeting tips';

  @override
  String get aiQuickGamification => 'Что такое система XP?';

  @override
  String get aiQuickHabit => 'Create a new habit';

  @override
  String get aiQuickMood => 'Анализировать мое настроение';

  @override
  String get aiQuickMotivation => 'Дай мне мотивацию';

  @override
  String get aiQuickProfile => 'Мой ИИ-персонаж';

  @override
  String get aiQuickTimer => 'How to use Timer?';

  @override
  String get aiQuickVision => 'Help with Vision Board';

  @override
  String get aiRetry => 'Retry with Stricter Rules';

  @override
  String get aiShowMeHow => 'Yes, show me how';

  @override
  String get aiTip0 =>
      'Did you know? You can create a Vision Board for your long-term goals.';

  @override
  String get aiTip1 => 'Tip: Use the Timer for focused work sessions.';

  @override
  String get aiTip2 => 'Track your mood daily to see patterns over time.';

  @override
  String get aiTip3 =>
      'Habits stick better when you do them at the same time every day.';

  @override
  String get aiTip4 => 'Break down big Visions into smaller, manageable Tasks.';

  @override
  String get aiTip5 =>
      'Use the Finance tab to keep track of your daily expenses.';

  @override
  String get aiTip6 => 'Need help? Tap here to ask the AI assistant!';

  @override
  String get aiTip7 => 'Consistency is key! Don\'t break the chain';

  @override
  String get aiWelcomeMessage =>
      'Hello! I\'m your Mira assistant. How can I help you today? You can ask me how to use visions, habits, timers, or any other feature.';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get allHabitsLabel => 'Все привычки';

  @override
  String get allLabel => 'Все';

  @override
  String get alsoDeleteLinkedHabits => 'Также удалить связанные привычки';

  @override
  String get amount => 'Количество';

  @override
  String get amountLabel => 'Сумма';

  @override
  String get analysis => 'Анализ';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get apply => 'Применить';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Это видение длится около $days дней';
  }

  @override
  String get assetsReloadHint =>
      'Для загрузки некоторых активов может потребоваться полный перезапуск приложения.';

  @override
  String get atLeast => 'Минимум';

  @override
  String get atMost => 'Максимум';

  @override
  String get autoBackupSubtitle =>
      'Автоматически сохраняйте данные на Google Drive каждые 24 часа.';

  @override
  String get autoBackupTitle => 'Автоматическое резервное копирование';

  @override
  String get averageMood => 'Среднее настроение';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => 'Фоновая пластина';

  @override
  String get backupError => 'Backup Error';

  @override
  String get backupFailed => 'Ошибка резервного копирования';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String backupSuccess(Object id) {
    return 'Сохранено: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get badgeActive100dDesc => 'Быть активным 100 разных дней';

  @override
  String get badgeActive100dTitle => '100 дней активности';

  @override
  String get badgeActive30dDesc => 'Быть активным 30 разных дней';

  @override
  String get badgeActive30dTitle => '30 дней активности';

  @override
  String get badgeActive7dDesc => 'Быть активным 7 разных дней';

  @override
  String get badgeActive7dTitle => '7 дней активности';

  @override
  String get badgeCategoryActivity => 'Активность';

  @override
  String get badgeCategoryFinance => 'Финансы';

  @override
  String get badgeCategoryHabit => 'Привычка';

  @override
  String get badgeCategoryLevel => 'Уровень';

  @override
  String get badgeCategoryVision => 'Видение';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => 'Зарегистрировать 100 транзакций';

  @override
  String get badgeFin100Title => 'Финансист 100';

  @override
  String get badgeFin10Desc => 'Зарегистрировать 10 транзакций';

  @override
  String get badgeFin10Title => 'Финансист 10';

  @override
  String get badgeFin250Desc => 'Зарегистрировать 250 транзакций';

  @override
  String get badgeFin250Title => 'Финансист 250';

  @override
  String get badgeFin50Desc => 'Зарегистрировать 50 транзакций';

  @override
  String get badgeFin50Title => 'Финансист 50';

  @override
  String get badgeHabit100Desc => 'Выполнить 100 привычек в общей сложности';

  @override
  String get badgeHabit100Title => 'Привычка 100';

  @override
  String get badgeHabit10Desc => 'Выполнить 10 привычек в общей сложности';

  @override
  String get badgeHabit10Title => 'Привычка 10';

  @override
  String get badgeHabit200Desc => 'Выполнить 200 привычек в общей сложности';

  @override
  String get badgeHabit200Title => 'Привычка 200';

  @override
  String get badgeHabit50Desc => 'Выполнить 50 привычек в общей сложности';

  @override
  String get badgeHabit50Title => 'Привычка 50';

  @override
  String get badgeLevel10Desc => 'Достичь 10-го уровня';

  @override
  String get badgeLevel10Title => 'Уровень 10';

  @override
  String get badgeLevel20Desc => 'Достичь 20-го уровня';

  @override
  String get badgeLevel20Title => 'Уровень 20';

  @override
  String get badgeLevel5Desc => 'Достичь 5-го уровня';

  @override
  String get badgeLevel5Title => 'Уровень 5';

  @override
  String get badgeVision10Desc => 'Создать 10 видений';

  @override
  String get badgeVision10Title => 'Гроссмейстер Видений';

  @override
  String get badgeVision1Desc => 'Создайте свое первое видение';

  @override
  String get badgeVision1Title => 'Визионер';

  @override
  String get badgeVision5Desc => 'Создать 5 видений';

  @override
  String get badgeVision5Title => 'Мастер Видений';

  @override
  String get badgeVisionHabits3Desc => 'Связать 3+ привычки с видением';

  @override
  String get badgeVisionHabits3Title => 'Соединитель';

  @override
  String get badgeXp1000Desc => 'Заработать в общей сложности 1000 XP';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => 'Заработать в общей сложности 500 XP';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => 'Значки';

  @override
  String balanceParenthesis(Object balance) {
    return '(Баланс: $balance)';
  }

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => 'От 1 до 360';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => 'Биография';

  @override
  String get bioHint => 'Краткая биография о себе';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => 'Перерыв';

  @override
  String get breakdownByCategory => 'Разбивка по категориям';

  @override
  String get bringForward => 'Вынести вперед';

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
  String get cancel => 'Отмена';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'Категория';

  @override
  String get categoryName => 'Название категории';

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
  String get chooseBestCategory =>
      'Выберите лучшую категорию для вашей привычки';

  @override
  String get chooseColor => 'Выберите цвет:';

  @override
  String get chooseEmoji => 'Выберите эмодзи:';

  @override
  String get choosePhoto => 'Choose Photo';

  @override
  String get choosePhotoDesc => 'Select a photo that inspires you';

  @override
  String get choosePhotoSubtitle => 'Choose a photo to motivate you';

  @override
  String get clear => 'Очистить';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get close => 'Закрыть';

  @override
  String get closeButton => 'Закрыть';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'Decide between two options';

  @override
  String get coinFlipInstruction => 'Enter two options and flip the coin!';

  @override
  String get coinFlipTitle => 'Coin Flip';

  @override
  String get colorLabel => 'Цвет';

  @override
  String get colorTheme => 'Цветовая тема';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'Завершено (выбранный день)';

  @override
  String get completedTableHeader => 'ГОТОВО';

  @override
  String get completionPercentLabel => '% выполнения';

  @override
  String completionsCount(Object count) {
    return '$count выполнений';
  }

  @override
  String get confirmDeleteAccount => 'Confirm Account Deletion';

  @override
  String get confirmHabits => 'Confirm Habits';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueText => 'Продолжить';

  @override
  String get copyButton => 'Копировать';

  @override
  String get copyCodeTitle => 'Копировать код';

  @override
  String costTokens(Object cost) {
    return 'Цена: $cost жетонов';
  }

  @override
  String get cottonCandy => 'Cotton Candy';

  @override
  String get cottonCandyDesc => 'Cotton candy - pink & blue';

  @override
  String get countdownConfigureTitle => 'Настроить обратный отсчет';

  @override
  String get countdownLabel => 'COUNTDOWN';

  @override
  String get cozyJournal => 'Cozy Journal';

  @override
  String get cozyJournalDesc => 'Brown tones & timeline';

  @override
  String get crashReports => 'Crash reports';

  @override
  String get crashReportsSubtitle => 'Send anonymous reports on app crashes';

  @override
  String get create => 'Создать';

  @override
  String get createAdvancedHabit => 'Создать Продвинутую Привычку';

  @override
  String get createButton => 'Создать';

  @override
  String get createDailyTask => 'Создать ежедневную задачу';

  @override
  String get createFirstHabit => 'Create Habit';

  @override
  String get createFirstReportPrompt => 'Нажмите +, чтобы создать первый отчет';

  @override
  String get createFirstVision => 'Create Your First Vision';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => 'Создать шаблон привычки';

  @override
  String get createHabitTitle => 'Создать привычку';

  @override
  String get createList => 'Создать список';

  @override
  String get createNewCategory => 'Создать новую категорию';

  @override
  String get createNewList => 'Создать новый список';

  @override
  String get createReport => 'Создать отчет';

  @override
  String get createRoomSubtitle => 'Создайте новую комнату и пригласите друзей';

  @override
  String get createRoomSuccessSnackbar => 'Комната создана! 🎉';

  @override
  String get createRoomTitle => 'Создать комнату';

  @override
  String get createVision => 'Создать видение';

  @override
  String get createVisionTemplateTitle => 'Создать шаблон видения';

  @override
  String get createVisionWithAI => 'Create Vision with AI';

  @override
  String get createWithAi => 'Create with AI';

  @override
  String get creatingBackup => 'Creating Backup';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get custom => 'Свой';

  @override
  String get customCategories => 'Пользовательские категории';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => 'Пример: ✨';

  @override
  String get customEmojiOptional => 'Пользовательский эмодзи (необязательно)';

  @override
  String get customEvent => 'Свое событие';

  @override
  String get customFrequency => 'Индивидуально';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => 'Напр: порция, подход, км...';

  @override
  String get daily => 'Ежедневно';

  @override
  String get dailyCheck => 'Ежедневная проверка';

  @override
  String get dailyDesc => 'Every day';

  @override
  String get dailyHabitInfo => 'Daily habit info';

  @override
  String get dailyLimit => 'Дневной лимит';

  @override
  String get dailyTask => 'Ежедневная задача';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Ежедневная задача создана: $title';
  }

  @override
  String get dailyTaskSubtitle => 'Добавить задачу на сегодня';

  @override
  String get dailyTaskTitle => 'Ежедневная задача';

  @override
  String get dailyTasksSection => 'Ежедневные задачи';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get dashboard => 'Панель';

  @override
  String get date => 'Дата';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Пт';

  @override
  String get dayMonShort => 'Пн';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'День $start–$end';
  }

  @override
  String get daySatShort => 'Сб';

  @override
  String dayShort(Object day) {
    return 'День $day';
  }

  @override
  String get daySunShort => 'Вс';

  @override
  String get dayThuShort => 'Чт';

  @override
  String get dayTueShort => 'Вт';

  @override
  String get dayWedShort => 'Wed';

  @override
  String get days => 'days';

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String daysAverageShort(Object days) {
    return '$daysдн. в среднем';
  }

  @override
  String daysCount(Object count) {
    return '$count дней';
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
  String get daysSuffixShort => 'д';

  @override
  String get decisionEggDescription => 'Pick a mystical egg for answers';

  @override
  String get decisionEggTitle => 'Decision Egg';

  @override
  String get defaultUnit => 'шт.';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteAccountFailed => 'Account deletion failed';

  @override
  String get deleteAccountRequestSuccess =>
      'Your account deletion request has been successfully received';

  @override
  String get deleteAccountSubtitle =>
      'Request deletion of your account and data';

  @override
  String get deleteAccountWarning =>
      'This action cannot be undone. Please confirm the email associated with your account.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllDataConfirmContent =>
      'Are you sure you want to delete all your app data? This action cannot be undone.';

  @override
  String get deleteButton => 'Удалить';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return 'Удалить категорию \"$name\"?';
  }

  @override
  String get deleteCategoryTitle => 'Удалить категорию';

  @override
  String get deleteCustomCategoryConfirm =>
      'Удалить эту пользовательскую категорию?';

  @override
  String get deleteEntryConfirm => 'Удалить эту запись?';

  @override
  String get deleteEvent => 'Удалить событие';

  @override
  String deleteHabitConfirm(Object title) {
    return 'Удалить привычку \"$title\"?';
  }

  @override
  String get deleteHabitTitle => 'Удалить привычку';

  @override
  String get deleteListMessage =>
      'Этот список будет удален. Выберите, что делать со связанными элементами:';

  @override
  String get deleteListTitle => 'Удалить список';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deleteRoomTitle => 'Удалить комнату';

  @override
  String get deleteRoomWarning =>
      'Эта комната и все ее содержимое будут удалены навсегда. Продолжить?';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage =>
      'Вы хотите удалить эту ежедневную задачу? Это действие можно отменить.';

  @override
  String get deleteTaskConfirmTitle => 'Удалить задачу?';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'Удалить запись \"$title\"?';
  }

  @override
  String get deleteVisionMessage => 'Удалить это видение?';

  @override
  String get deleteVisionTitle => 'Удалить видение';

  @override
  String get descHint => 'Подробности о вашей привычке (необязательно)';

  @override
  String get descriptionHintOptional => 'Add description (optional)';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get detailedCharts => 'Detailed charts and statistics';

  @override
  String get diagnosticsData => 'Diagnostics data';

  @override
  String get diagnosticsDataSubtitle => 'Share anonymous usage statistics';

  @override
  String get difficulty => 'Уровень Сложности';

  @override
  String get drinkWater => 'Drink Water';

  @override
  String get duration => 'Продолжительность';

  @override
  String get durationAutoLabel => 'Продолжительность (авто)';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => 'Выбор продолжительности';

  @override
  String get durationType => 'Тип продолжительности';

  @override
  String get earthTheme => 'Земля';

  @override
  String get earthThemeDesc => 'Земляные цвета';

  @override
  String get easy => 'Легко';

  @override
  String get edit => 'Редактировать';

  @override
  String get editButton => 'Редактировать';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get editDeleteTooltip => 'Редактировать / Удалить';

  @override
  String get editEvent => 'Изменить событие';

  @override
  String get editHabit => 'Редактировать привычку';

  @override
  String get editListTitle => 'Редактировать список';

  @override
  String get editOnlyPersonalHabits =>
      'Вы можете редактировать только привычки, добавленные в ваш личный список.';

  @override
  String get education => 'Образование';

  @override
  String get eggRevealMessage => 'The mystical egg has spoken! ✨';

  @override
  String get eggSelectMessage => 'Think of a question and tap an egg 🥚';

  @override
  String get emojiAndColor => 'Эмодзи и Цвет';

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
  String get emojiLabel => 'Эмодзи';

  @override
  String get emotionBlessed => 'Благословенный';

  @override
  String get emotionBored => 'Скучающий';

  @override
  String get emotionConfident => 'Уверенный';

  @override
  String get emotionConfused => 'Сбитый с толку';

  @override
  String get emotionDistracted => 'Отвлеченный';

  @override
  String get emotionEuphoric => 'Эйфорический';

  @override
  String get emotionGuilty => 'Виноватый';

  @override
  String get emotionHopeful => 'Надеющийся';

  @override
  String get emotionInsecure => 'Неуверенный';

  @override
  String get emotionLonely => 'Одинок';

  @override
  String get emotionNumb => 'Онемевший';

  @override
  String get emotionOverwhelmed => 'Перегружен';

  @override
  String get emotionProud => 'Гордый';

  @override
  String get emotionRegretful => 'Сожалеющий';

  @override
  String get emotionUnstoppable => 'Неудержимый';

  @override
  String get emptyHabitSubtitle =>
      'Create your first habit to begin tracking your progress.';

  @override
  String get emptyHabitTitle => 'Start Your Journey';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String get enableReminder => 'Включить напоминание';

  @override
  String get endDate => 'Дата окончания';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => 'День окончания (необязательно)';

  @override
  String get endTime => 'Время окончания';

  @override
  String get enterBothOptions => 'Please enter both options';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Введите месячный план для расчета дневного лимита.';

  @override
  String get enterNameAndDesc => 'Введите название и описание вашей привычки';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => 'Введите значение';

  @override
  String get enterYourName => 'Введите ваше имя';

  @override
  String get entries => 'Записи';

  @override
  String get entryCountLabel => 'Количество записей';

  @override
  String get entrySaved => 'Entry saved successfully!';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get eventDescription => 'Описание';

  @override
  String get eventDetails => 'Детали события';

  @override
  String get eventTitle => 'Название события';

  @override
  String get every => 'Every';

  @override
  String get everyDay => 'Every day';

  @override
  String get everyLabel => 'Every';

  @override
  String everyNDays(Object days) {
    return 'Every $days days';
  }

  @override
  String everyNDaysInfo(Object days) {
    return 'Occurs every $days days';
  }

  @override
  String get everyNDaysQuestion => 'Каждые сколько дней?';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => 'Каждый день';

  @override
  String get exact => 'Точно';

  @override
  String get exactAlarmPermission =>
      'Разрешение на точный будильник (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Пример: $example';
  }

  @override
  String get expenseDelta => 'Расход Δ';

  @override
  String get expenseDistributionPie =>
      'Распределение расходов (круговая диаграмма)';

  @override
  String get expenseEditTitle => 'Редактировать расход';

  @override
  String get expenseLabel => 'Расход';

  @override
  String get expenseNewTitle => 'Новый расход';

  @override
  String failedToLoad(Object error) {
    return 'Не удалось загрузить: $error';
  }

  @override
  String get featureAdvancedFinance => 'Advanced Finance Features';

  @override
  String get featureAdvancedHabits => 'Advanced Habit Creation';

  @override
  String get featureAiBioClock => 'Биологические часы с ИИ';

  @override
  String get featureAiBioClockDesc =>
      'Оптимальное время на основе вашего биоритма';

  @override
  String get featureAiWeeklyReport => 'Еженедельный отчет с ИИ';

  @override
  String get featureAiWeeklyReportDesc =>
      'Детальный ИИ-анализ вашего прогресса';

  @override
  String get featureBackup => 'Backup Feature';

  @override
  String get featurePremiumThemes => 'Премиум темы';

  @override
  String get featureVisionCreation => 'Vision Creation';

  @override
  String get feelingMoreSpecific => 'Можете быть более конкретным?';

  @override
  String get filterTitle => 'Фильтр';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'Финансы';

  @override
  String get financeAddAiStatementOption => 'Загрузить выписку/чек с ИИ';

  @override
  String get financeAddAiStatementSubtitle =>
      'Автоматически добавляет из изображения или PDF';

  @override
  String get financeAddManualOption => 'Добавить вручную';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Финансовый анализ · $month';
  }

  @override
  String get financeLast7Days => 'Финансы · Последние 7 дней';

  @override
  String get financeNet => 'Чистый';

  @override
  String get finish => 'Завершить';

  @override
  String get fitness => 'Фитнес';

  @override
  String get fixedDuration => 'Фиксированная';

  @override
  String get flexiblePlan => 'Flexible plan, cancel anytime';

  @override
  String get flipCoin => 'Flip Coin';

  @override
  String get focusLabel => 'FOCUS';

  @override
  String get focusedZen => 'Focused Zen';

  @override
  String get focusedZenDesc => 'Minimalist, single focus point';

  @override
  String get font => 'Шрифт';

  @override
  String get forestTheme => 'Лес';

  @override
  String get forestThemeDesc => 'Естественная зеленая тема';

  @override
  String get forever => 'Навсегда';

  @override
  String get fortuneDisclaimer =>
      'Гадание предназначено только для развлечения';

  @override
  String fortuneEggSemantic(int index) {
    return 'Яйцо судьбы $index';
  }

  @override
  String get fortuneEggsSubtitle => 'Выберите яйцо, чтобы узнать свою судьбу';

  @override
  String get fortuneNoQuestion => 'Вы еще не задали вопрос';

  @override
  String get fortunePlay => 'Играть';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => 'Что вы хотели бы узнать?';

  @override
  String get fortuneQuestionPrompt => 'Задайте свой вопрос';

  @override
  String get fortuneResultTitle => 'Ваша судьба';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => 'Яйца судьбы';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => 'Частота';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Пт';

  @override
  String get fullName => 'Полное имя';

  @override
  String get fullScreen => 'Полный экран';

  @override
  String get gallery => 'Галерея';

  @override
  String get gamesDescription =>
      'Having trouble deciding? Let fun games help you decide!';

  @override
  String get gamesTitle => 'Игры';

  @override
  String get general => 'Общие';

  @override
  String get generalNotifications => 'Общие уведомления';

  @override
  String get generalRoomStatsHeader => 'ОБЩАЯ СТАТИСТИКА КОМНАТЫ';

  @override
  String get generate => 'Generate';

  @override
  String generatedAtDate(Object date) {
    return 'Создано: $date';
  }

  @override
  String get generating => 'Создание...';

  @override
  String get glasses => 'Стаканы';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'Золотой';

  @override
  String get goldenThemeDesc => 'Теплая золотая тема';

  @override
  String get goodMorning => 'Good morning! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Предоставлено';

  @override
  String get greatDayAhead => 'Today is a great day, you got this!';

  @override
  String get greetingAfternoon => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get guestAccount => 'Guest Account';

  @override
  String get guidedJourney => 'Путешествие с гидом';

  @override
  String get guidedJourneyDesc => 'Step-by-step guided flow';

  @override
  String get habit => 'Привычка';

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
  String get habitBlock => 'Привычка';

  @override
  String habitCreatedMessage(Object title) {
    return 'Привычка создана: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Привычка удалена: $title';
  }

  @override
  String get habitDescription => 'Описание';

  @override
  String get habitDescriptionHint => 'Добавить краткое описание...';

  @override
  String get habitDetails => 'Детали привычки';

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
  String get habitName => 'Название Привычки';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => 'Напр: Пить воду, Читать...';

  @override
  String get habitNameHintTimer => 'Напр: Медитация, Спорт...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => 'Привычка не найдена.';

  @override
  String get habitOfThisVision => 'Привычка этого видения';

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
  String get habitReminders => 'Напоминания о привычках';

  @override
  String get habitRemindersSubtitle =>
      'Ежедневные напоминания о ваших привычках';

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
  String get habitTypePickerSubtitle =>
      'What kind of habit do you want to create?';

  @override
  String get habitTypePickerTitle => 'Choose Habit Type';

  @override
  String get habitUpdatedMessage => 'Привычка обновлена.';

  @override
  String get habits => 'Привычки';

  @override
  String get habitsSection => 'Привычки';

  @override
  String get hard => 'Сложно';

  @override
  String get hardMode => 'Сложный режим';

  @override
  String get headerFocusLabel => 'Фокус';

  @override
  String get headerFocusReady => 'Готово';

  @override
  String get headerHabitsLabel => 'Привычка';

  @override
  String get health => 'Здоровье';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'ч';

  @override
  String get hours => 'Часы';

  @override
  String get hoursSuffixShort => 'ч';

  @override
  String get howAreYouFeeling => 'Как вы себя чувствуете?';

  @override
  String get howDoYouFeel => 'How do you feel today?';

  @override
  String get howOftenDoHabit =>
      'Решите, как часто вы будете выполнять свою привычку';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => 'Как заработать';

  @override
  String get howToTrackHabit =>
      'Выберите, как будет отслеживаться ваша привычка';

  @override
  String get ifCondition => 'Если';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'Импортировать по ссылке';

  @override
  String get importantNotice => 'Важное уведомление';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => 'Δ дохода';

  @override
  String get incomeEditTitle => 'Редактировать доход';

  @override
  String get incomeLabel => 'Доход';

  @override
  String get incomeNewTitle => 'Новый доход';

  @override
  String get incompleteSelectedDay => 'Не завершено (выбранный день)';

  @override
  String get input => 'Ввод';

  @override
  String get insights => 'Insights';

  @override
  String get insufficientTokensWatchAd =>
      'Недостаточно жетонов! Посмотрите рекламу.';

  @override
  String get invalidCodeLengthError => 'Код должен состоять из 6 символов';

  @override
  String get invalidLink => 'Неверная ссылка.';

  @override
  String get invalidValue => 'Неверное значение';

  @override
  String get inviteCodeCopiedSnackbar => 'Код приглашения скопирован!';

  @override
  String get inviteCodeTooltip => 'Код приглашения';

  @override
  String get issueDescription => 'Issue Description';

  @override
  String get issueDescriptionHint => 'Describe the issue in detail...';

  @override
  String get joinButton => 'Присоединиться';

  @override
  String get joinRoomCodeMessage =>
      'Введите 6-значный код приглашения от друга:';

  @override
  String get joinRoomSubtitle =>
      'Присоединитесь к существующей комнате по пригласительному коду';

  @override
  String joinRoomSuccessSnackbar(Object roomName) {
    return 'Вы присоединились к комнате $roomName! 🎉';
  }

  @override
  String get joinRoomTitle => 'Присоединиться к комнате';

  @override
  String joinedAtLabel(Object date) {
    return 'Присоединился: $date';
  }

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
  String get justNow => 'Только что';

  @override
  String get keepItUp => 'Awesome! Keep it up! 💪';

  @override
  String get language => 'Язык';

  @override
  String get languageSelection => 'Выбор языка';

  @override
  String get last7DaysProgressLabel => 'Прогресс за последние 7 дней';

  @override
  String lastBackup(String date) {
    return 'Последняя копия: $date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Lavender Dreams';

  @override
  String get lavenderDreamsDesc => 'Elegant lavender & purple tones';

  @override
  String get leaderboardDetailsTitle => 'Детали рейтинга';

  @override
  String get leaveButton => 'Выйти';

  @override
  String get leaveRoomTitle => 'Покинуть комнату';

  @override
  String get leaveRoomWarning => 'Вы уверены, что хотите покинуть эту комнату?';

  @override
  String get letsPlayGame => 'Let\'s play! 🎮';

  @override
  String get letsStart => 'Let\'s Start';

  @override
  String levelLabel(Object level) {
    return 'Уровень $level';
  }

  @override
  String levelShort(Object level) {
    return 'У$level';
  }

  @override
  String get lightTheme => 'Светлая тема';

  @override
  String get likertAgree => 'Согласен';

  @override
  String get likertDisagree => 'Не согласен';

  @override
  String get likertNeutral => 'Нейтрально';

  @override
  String get likertStronglyAgree => 'Полностью согласен';

  @override
  String get likertStronglyDisagree => 'Совершенно не согласен';

  @override
  String get linkHabits => 'Связать привычки';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'Список создан: $title';
  }

  @override
  String get listLabel => 'Список';

  @override
  String get listNameHint => 'Пример: Здоровье';

  @override
  String get listNameLabel => 'Название списка';

  @override
  String get loadingHabits => 'Загрузка привычек...';

  @override
  String get logout => 'Выйти';

  @override
  String get longestStreak => 'Самая длинная серия';

  @override
  String get longestStreakLabel => 'Самая длинная серия';

  @override
  String get manageLists => 'Управление списками';

  @override
  String get manageListsSubtitle =>
      'Добавить новый список, переименовать или удалить.';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => 'Управление подпиской';

  @override
  String get manageSubscriptionDesc =>
      'Change plan, cancel or view billing info';

  @override
  String get manageSubscriptionSubtitle =>
      'Manage Mira Plus subscription via Google Play';

  @override
  String get manageVisionTasks => 'Manage Tasks';

  @override
  String get manualFallback => 'Create Manually';

  @override
  String get maxOptionsReached => 'Maximum 12 options allowed';

  @override
  String get meditation => 'Медитация';

  @override
  String get medium => 'Средне';

  @override
  String memberCountText(Object count) {
    return '$count участников';
  }

  @override
  String get memberHabitsLabel => 'Привычки участника';

  @override
  String get memberProfileTitle => 'Профиль участника';

  @override
  String get memberTableHeader => 'УЧАСТНИК';

  @override
  String membersCompletedStatus(Object completed, Object total) {
    return '$completed/$total участников выполнили';
  }

  @override
  String membersCountText(Object count) {
    return '$count человек';
  }

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Осознанность';

  @override
  String get mintFresh => 'Свежая мята';

  @override
  String get mintFreshDesc => 'Fresh mint & turquoise tones';

  @override
  String get minutes => 'Минуты';

  @override
  String get minutesSuffixShort => 'мин';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Премиум';

  @override
  String get mondayShort => 'Пн';

  @override
  String get monthCount => 'Количество месяцев';

  @override
  String get monthCountHint => 'Пример: 12';

  @override
  String get monthSuffixShort => 'мес';

  @override
  String get monthly => 'Ежемесячно';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'On specific days of the month';

  @override
  String get monthlyProgress => 'Ежемесячный прогресс';

  @override
  String get monthlyTrend => 'Месячный тренд';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => 'Настроение';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => 'Плохое';

  @override
  String get moodBadDesc => 'Переживаю трудное время';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => 'Отличное';

  @override
  String get moodExcellentDesc => 'Чувствую себя потрясающе';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => 'Отслеживайте свое эмоциональное состояние';

  @override
  String get moodFlowTitle => 'Как вы себя чувствуете?';

  @override
  String get moodGood => 'Хорошее';

  @override
  String get moodGoodDesc => 'Чувствую себя позитивно';

  @override
  String get moodGreat => 'Отличное';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => 'Нейтральное';

  @override
  String get moodNeutralDesc => 'Чувствую себя нормально';

  @override
  String get moodOk => 'Нормальное';

  @override
  String get moodSelection => 'Выбор настроения';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => 'Ужасное';

  @override
  String get moodTerribleDesc => 'Чувствую себя очень плохо';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get moodTrend => 'Mood Trend (Last 30 Days)';

  @override
  String get moreChartsButton => 'Больше графиков';

  @override
  String get mostActiveMemberLabel => 'Самый активный участник';

  @override
  String get mostCommonEmotion => 'Most Common Emotion';

  @override
  String get mostCommonMood => 'Most Common Mood';

  @override
  String get mostCommonReason => 'Most Common Reason';

  @override
  String get motivation => 'Мотивация';

  @override
  String motivationBody(Object percent, Object period) {
    return 'Отличная работа! $period вы достигли $percent% успеха.';
  }

  @override
  String motivationDayStart(Object title) {
    return 'Great day for $title! 🌟';
  }

  @override
  String get motivationJourneyStart =>
      'Every journey begins with a single step!';

  @override
  String get motivationSmallSteps =>
      'Start with small steps to reach big goals 💪';

  @override
  String motivationWaiting(Object title) {
    return '$title ждет тебя 🚀';
  }

  @override
  String get mtdAverageShort => 'Средн. с нач. месяца';

  @override
  String get multiple => 'Несколько';

  @override
  String get multipleSubItems => 'Multiple sub-items';

  @override
  String get multipleSubItemsDesc => 'Multiple sub-items';

  @override
  String get mustBePremiumToUse =>
      'You must be a Premium subscriber to use this feature.';

  @override
  String get myBigGoal => 'My Big Goal';

  @override
  String get myBoard => 'My Board';

  @override
  String get mysticTheme => 'Мистический';

  @override
  String get mysticThemeDesc => 'Мистическая фиолетовая тема';

  @override
  String nDays(Object days) {
    return '$days days';
  }

  @override
  String nDaysLabel(Object count) {
    return '$count дней';
  }

  @override
  String get nameHint => 'Пример: Ежедневная тренировка';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'Требуется название';

  @override
  String get nameYourVision => 'Name Your Vision';

  @override
  String get nameYourVisionDesc => 'Give your vision a meaningful name';

  @override
  String get nameYourVisionSubtitle => 'Give your vision a meaningful name';

  @override
  String get needAtLeastTwoOptions => 'Need at least 2 options';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => 'Новые привычки';

  @override
  String get newList => 'Новый список';

  @override
  String get next => 'Далее';

  @override
  String get nextLabel => 'Далее';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get nextYear => 'Следующий год';

  @override
  String get noActiveHabitsForMember =>
      'У участника пока нет активных привычек.';

  @override
  String get noBackups => 'No Backups';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noBadgesEarned => 'Значки еще не получены.';

  @override
  String get noDataLast7Days => 'Нет данных за последние 7 дней';

  @override
  String get noDataThisMonth => 'Нет данных за этот месяц';

  @override
  String get noEndDate => 'Нет даты окончания';

  @override
  String get noEndDayDefaultsDaily =>
      'Если день окончания не установлен, эта привычка будет появляться каждый день по умолчанию.';

  @override
  String get noEntriesYet => 'Пока нет записей';

  @override
  String get noEvents => 'Событий пока нет';

  @override
  String get noExpenseInThisCategory => 'Нет расходов в этой категории';

  @override
  String get noExpenses => 'Нет расходов';

  @override
  String get noExpensesThisMonth => 'Нет расходов за этот месяц';

  @override
  String get noHabitsAdded => 'Привычки пока не добавлены';

  @override
  String get noHabitsAddedYet => 'Привычки еще не добавлены.';

  @override
  String get noHabitsInRoom => 'Привычки еще не добавлены';

  @override
  String get noHistory => 'Нет истории';

  @override
  String get noIncomeThisMonth => 'Нет доходов за этот месяц';

  @override
  String get noItemsMatchFilters =>
      'Нет элементов, соответствующих выбранным фильтрам';

  @override
  String get noLeaderboardData => 'Нет данных рейтинга';

  @override
  String get noLinkedHabitsInVision =>
      'Нет привычек, связанных с этим видением.';

  @override
  String get noMeasurableDataForMember =>
      'Для этого участника пока нет измеримых данных.';

  @override
  String get noMemberDataYet => 'Данных об участниках пока нет.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noNotesYet => 'Заметок пока нет';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noProgressYet => 'Прогресса пока нет';

  @override
  String get noReadyVisionsFound => 'Готовые видения не найдены.';

  @override
  String get noRecordsThisMonth => 'Нет записей за этот месяц';

  @override
  String get noReportsYet => 'Отчетов пока нет';

  @override
  String get noRoomsJoinedMessage =>
      'Создайте комнату или присоединитесь к ней по коду.\nДостигайте целей вместе с друзьями!';

  @override
  String get noRoomsJoinedTitle =>
      'Вы еще не присоединились ни к одной комнате';

  @override
  String get noStatsAvailable => 'Статистика недоступна';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'Еще не добавлено.';

  @override
  String get notGranted => 'Не предоставлено';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'Не разблокировано';

  @override
  String get noteOptional => 'Примечание (необязательно)';

  @override
  String get noteSharedSnackbar => 'Заметка отправлена! ✨';

  @override
  String get notesSection => '📝 Заметки';

  @override
  String get notificationBehavior => 'Поведение уведомлений';

  @override
  String get notificationPermission => 'Разрешение на уведомления';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get notificationSettingsSubtitle =>
      'Настройте ваши предпочтения уведомлений';

  @override
  String get notificationTroubleshooting =>
      'Для правильной работы уведомлений:\n\n• ОТКЛЮЧИТЕ оптимизацию батареи\n• РАЗРЕШИТЕ фоновую активность\n• Убедитесь, что разрешения на уведомления ВКЛЮЧЕНЫ\n• Проверьте режим \'Не беспокоить\'';

  @override
  String get notificationTypes => 'Типы уведомлений';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsMasterSubtitle =>
      'Управление всеми уведомлениями приложения';

  @override
  String get nudgeButtonLabel => 'Подтолкнуть';

  @override
  String get nudgeDefaultMessage =>
      '👊 Давай, друг, сегодня еще немного усилий! Выполни свои привычки.';

  @override
  String nudgeNotification(Object name) {
    return '👊 $name подталкивает вас!';
  }

  @override
  String nudgeSuccessSnackbar(Object displayName) {
    return '$displayName подталкнут! 👊';
  }

  @override
  String nudgeTitle(Object displayName) {
    return 'Подтолкнуть $displayName 👊';
  }

  @override
  String get numberLabel => 'Число';

  @override
  String get numericExample => 'Выпивать 8 стаканов воды в день';

  @override
  String get numericSettings => 'Настройки числовой цели';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => 'Отслеживание числовой цели';

  @override
  String get numericalGoalShort => 'Числовая цель';

  @override
  String get numericalType => 'Числовое значение';

  @override
  String get oceanTheme => 'Океан';

  @override
  String get oceanThemeDesc => 'Спокойная синяя тема';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'ОК';

  @override
  String get onDailyLimit => 'Вы достигли дневного лимита.';

  @override
  String get onPeriodic => 'С определенными интервалами';

  @override
  String get onSpecificMonthDays => 'В определенные дни месяца';

  @override
  String get onSpecificWeekdays => 'В определенные дни недели';

  @override
  String get onSpecificYearDays => 'В определенные дни года';

  @override
  String get onboardingQ1 =>
      'Мне нравится пробовать новый опыт и исследовать незнакомое.';

  @override
  String get onboardingQ10 => 'Я заранее планирую важные события и задачи.';

  @override
  String get onboardingQ11 =>
      'Мне нравится пробовать разные подходы, а не придерживаться одного метода.';

  @override
  String get onboardingQ12 =>
      'Я сохраняю спокойствие под давлением и быстро восстанавливаюсь после неудач.';

  @override
  String get onboardingQ2 =>
      'Я поддерживаю порядок вокруг себя и предпочитаю структурированный распорядок дня.';

  @override
  String get onboardingQ3 =>
      'Я чувствую прилив энергии среди людей и люблю социальные встречи.';

  @override
  String get onboardingQ4 =>
      'Я предпочитаю работать с другими и считаю сотрудничество эффективнее конкуренции.';

  @override
  String get onboardingQ5 =>
      'Я спокойно справляюсь со стрессовыми ситуациями и редко испытываю тревогу.';

  @override
  String get onboardingQ6 =>
      'Мне нравятся творческие занятия, такие как искусство, музыка или письмо.';

  @override
  String get onboardingQ7 =>
      'Я ставлю перед собой ясные цели и усердно работаю, чтобы их достичь.';

  @override
  String get onboardingQ8 =>
      'Я предпочитаю групповые занятия, а не проводить время в одиночестве.';

  @override
  String get onboardingQ9 =>
      'Перед принятием решений я часто учитываю чувства других людей.';

  @override
  String get onboardingQuizIntro =>
      'Ответьте на несколько вопросов, чтобы помочь нам лучше понять вашу личность. Это основано на научно подтверждённых психологических исследованиях.';

  @override
  String get onboardingWelcomeDesc =>
      'Ваш персональный трекер привычек, который растёт вместе с вами. Давайте откроем вашу уникальную личность и предложим привычки, созданные специально для вас.';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в Mira';

  @override
  String get once => 'Один раз';

  @override
  String get open => 'Open';

  @override
  String get openBatteryOptimization => 'Open battery optimization';

  @override
  String get openNotificationSettings => 'Open notification settings';

  @override
  String get openSystemSettings => 'Open system settings';

  @override
  String get option1 => 'Option 1';

  @override
  String get option2 => 'Option 2';

  @override
  String get optional => 'optional';

  @override
  String get optionalLabel => 'optional';

  @override
  String get other => 'Другое';

  @override
  String get outline => 'Контур';

  @override
  String get outlineColor => 'Цвет контура';

  @override
  String get overall => 'Общий';

  @override
  String get overallProgress => 'Общий прогресс';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'Страницы';

  @override
  String get pastelColors => 'Пастельные цвета';

  @override
  String get pause => 'Пауза';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => 'Периодический';

  @override
  String get periodicDesc => 'At regular intervals';

  @override
  String get periodicSelection => 'Периодический выбор';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Photo';

  @override
  String get pickFromCalendar => 'Pick from Calendar';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => 'Выберите сегодняшнее настроение';

  @override
  String get plannedMonthlySpend => 'Запланированные месячные расходы';

  @override
  String plansLoadError(Object error) {
    return 'Ошибка загрузки планов: $error';
  }

  @override
  String get plateColor => 'Цвет пластины';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get pointsTableHeader => 'ОЧКИ';

  @override
  String get pomodoroAndCustomTimers => 'Pomodoro and custom timers';

  @override
  String get premiumBenefits => 'Premium benefits:';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumFeatureLabel => 'Премиум-функция';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get premiumPlans => 'Premium Plans';

  @override
  String get previous => 'Предыдущий';

  @override
  String get previousYear => 'Предыдущий год';

  @override
  String get prioritizeTaskSubtitle => 'Prioritize this task';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'Конфиденциальность и безопасность';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => 'Продуктивность';

  @override
  String get profile => 'Профиль';

  @override
  String get profileInfo => 'Информация профиля';

  @override
  String get profileUpdated => 'Профиль обновлен';

  @override
  String get progressJourneyMessage =>
      'По мере выполнения привычек этот график будет формироваться вашим успехом ✨';

  @override
  String get progressJourneyStarts => 'Начинается путь прогресса';

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
  String get quickSuggestions => 'Quick Suggestions';

  @override
  String get rankingAndHabitsSection => '🏆 Рейтинг и привычки';

  @override
  String get readBook => 'Читать книгу';

  @override
  String get readyVisionsLoadFailed => 'Не удалось загрузить готовые видения.';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'Здоровье';

  @override
  String get reasonOther => 'Другое';

  @override
  String get reasonPersonalGrowth => 'Personal Growth';

  @override
  String get reasonRelationship => 'Relationship';

  @override
  String get reasonSelection => 'What\'s the reason for this state?';

  @override
  String get reasonSocial => 'Social';

  @override
  String get reasonTitle => 'Причина';

  @override
  String get reasonWeather => 'Weather';

  @override
  String get reasonWork => 'Работа';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc =>
      'Автоматически добавлять каждый месяц в выбранную дату';

  @override
  String get recurringMonthlyTitle => 'Повторяющийся (ежемесячно)';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => 'Перезагрузить';

  @override
  String get remainingToday => 'Осталось сегодня';

  @override
  String get reminder => 'Напоминание';

  @override
  String get reminderDisabled => 'Reminder Off';

  @override
  String get reminderEnabled => 'Reminder On';

  @override
  String get reminderFrequency => 'Частота напоминаний';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'Настройки напоминаний';

  @override
  String get reminderTime => 'Время Напоминания';

  @override
  String get removeFromList => 'Удалить из списка';

  @override
  String get repeatEveryDay => 'Повторяется каждый день';

  @override
  String get repeatEveryNDays => 'Повторять каждые N дней';

  @override
  String get reportAlreadyExists => 'Отчет за эту неделю уже есть.';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reportCreatedSuccess => 'Отчет создан! ✨';

  @override
  String get reset => 'Сбросить';

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
  String get restoreError => 'Restore Error';

  @override
  String get restoreFailed => 'Ошибка восстановления';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'Загружено: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Your data has been successfully restored. We recommend restarting the app for changes to take full effect.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retakePersonalityTestDesc => 'Переоткройте свой тип личности';

  @override
  String get retakeRhythmTest => 'Пройти тест ритма заново';

  @override
  String get retakeRhythmTestDesc => 'Перенастроить биологические часы';

  @override
  String get retry => 'Повторить';

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
  String get rhythmA3_1 => 'Раннее утро';

  @override
  String get rhythmA3_2 => 'Середина утра';

  @override
  String get rhythmA3_3 => 'День';

  @override
  String get rhythmA3_4 => 'Вечер';

  @override
  String get rhythmA3_5 => 'Без разницы';

  @override
  String get rhythmA4_1 => 'Утро';

  @override
  String get rhythmA4_2 => 'Полдень';

  @override
  String get rhythmA4_3 => 'Вечер';

  @override
  String get rhythmA4_4 => 'Ночь';

  @override
  String get rhythmA4_5 => 'По-разному';

  @override
  String get rhythmA5_1 => 'Утро';

  @override
  String get rhythmA5_2 => 'Полдень';

  @override
  String get rhythmA5_3 => 'Вечер';

  @override
  String get rhythmA5_4 => 'Никогда';

  @override
  String get rhythmAnalyzing => 'Live Rhythm анализирует...';

  @override
  String get rhythmBenefit1 => 'Правильная задача в правильное время';

  @override
  String get rhythmBenefit2 => 'Без усталости от решений';

  @override
  String get rhythmBenefit3 => 'Персонализация каждую неделю';

  @override
  String get rhythmChronoEvening => 'Вечерний тип (Сова)';

  @override
  String get rhythmChronoIntermediate => 'Промежуточный тип (Сбалансированный)';

  @override
  String get rhythmChronoMorning => 'Утренний тип (Жаворонок)';

  @override
  String get rhythmDisclaimer =>
      'Это не окончательные результаты. Live Rhythm будет адаптироваться по мере знакомства с вами.';

  @override
  String get rhythmEnergyHint => 'Тренировка, физическая активность';

  @override
  String get rhythmFocusHint => 'Умственная работа, анализ, обучение';

  @override
  String get rhythmHabitSuggestionTitle => 'Рекомендуемые временные блоки:';

  @override
  String get rhythmLightHint => 'Почта, соцсети, мелкие дела';

  @override
  String get rhythmQ1 => 'Во сколько вы обычно ложитесь спать?';

  @override
  String get rhythmQ2 => 'Во сколько вы обычно просыпаетесь?';

  @override
  String get rhythmQ3 =>
      'Когда вам комфортнее всего браться за сложные задачи?';

  @override
  String get rhythmQ4 =>
      'Когда вы чувствуете максимальную ясность для обучения?';

  @override
  String get rhythmQ5 => 'В какой части дня вы чувствуете больше энергии?';

  @override
  String get rhythmReflectionHint => 'Дневник, чтение, отдых';

  @override
  String get rhythmResultGotIt => 'Понятно, начнем';

  @override
  String get rhythmResultSubtitle =>
      'Мы распределили ваш день на основе вашего природного ритма.';

  @override
  String get rhythmResultTitle => 'Ваш профиль биологических часов';

  @override
  String get rhythmTeaserCta => 'Смотреть пакеты';

  @override
  String get rhythmTeaserSkip => 'Пропустить';

  @override
  String get rhythmTeaserSubtitle =>
      'Live Rhythm изучает ваши самые продуктивные моменты и размещает привычки в правильное время.';

  @override
  String get rhythmTeaserTitle =>
      'Максимизируйте свои привычки на основе биологических часов';

  @override
  String get rhythmWindowEnergy => 'Время энергии';

  @override
  String get rhythmWindowEnergyDesc => 'Движение, действие, спорт';

  @override
  String get rhythmWindowFocus => 'Время фокуса';

  @override
  String get rhythmWindowFocusDesc => 'Ясность ума, обучение, анализ';

  @override
  String get rhythmWindowLight => 'Лёгкое время';

  @override
  String get rhythmWindowLightDesc => 'Низкие усилия, мелкие задачи';

  @override
  String get rhythmWindowNoProfileHint =>
      'Пройдите тест ритма для персональных рекомендаций';

  @override
  String get rhythmWindowReflection => 'Время рефлексии';

  @override
  String get rhythmWindowReflectionDesc => 'Дневник, размышления, завершение';

  @override
  String get rhythmWindowStepSubtitle =>
      'Когда вы хотите выполнять эту привычку?';

  @override
  String get rhythmWindowStepTitle => 'Лучшее временное окно';

  @override
  String get roomFabLabel => 'Комната';

  @override
  String get roomMembersLabel => 'УЧАСТНИКИ КОМНАТЫ';

  @override
  String get roomNameHint => 'напр., Команда утренней рутины';

  @override
  String get roomNameLabel => 'Название комнаты';

  @override
  String get roomNotFoundError => 'Комната с таким кодом не найдена';

  @override
  String get roomSummaryHeader => 'СВОДКА КОМНАТЫ';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Правило: Введенная продолжительность ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Правило: Введенная продолжительность ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Правило: Введенная продолжительность = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Правило: Введенное значение ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Правило: Введенное значение ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Правило: Введенное значение = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get save => 'Сохранить';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => 'Сохранено';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => 'План сбережений / бюджета';

  @override
  String get scheduleHabit => 'Установите расписание для своей привычки';

  @override
  String get scheduleLabel => 'Расписание';

  @override
  String get schedulingOptions => 'Параметры планирования';

  @override
  String get seconds => 'Секунды';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => 'Выбрать';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get selectAtLeastOneDay => 'Пожалуйста, выберите хотя бы один день';

  @override
  String get selectCategory => 'Выбрать категорию';

  @override
  String get selectDate => 'Выбрать дату';

  @override
  String get selectDay => 'Выберите день';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'Выбрать дату окончания';

  @override
  String get selectFrequency => 'Выбрать частоту';

  @override
  String get selectHabitLabel => 'Выберите привычку';

  @override
  String get selectHabitType => 'Выбрать тип привычки';

  @override
  String get selectHabitsToAdd =>
      'Выберите привычки, которые вы хотите добавить в свой ежедневный распорядок:';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc => 'Выберите, что влияет на ваше настроение';

  @override
  String get selectReportType => 'Тип отчета:';

  @override
  String get selectSubEmotion => 'Выберите под-эмоцию';

  @override
  String get selectSubEmotionDesc => 'Выберите более конкретную эмоцию';

  @override
  String get selectTime => 'Выбрать время';

  @override
  String get selectYourCurrentMood => 'Выберите ваше текущее настроение';

  @override
  String get selectYourMood => 'Выберите настроение';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => 'Переместить назад';

  @override
  String get setAsTodayFocus => 'Set as Today\'s Focus';

  @override
  String get setVisionTimeline => 'Set the timeline for your vision';

  @override
  String get settings => 'Настройки';

  @override
  String get shareAsLink => 'Поделиться как ссылка';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareButton => 'Поделиться';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareInviteCodeMessage => 'Поделитесь этим кодом с друзьями:';

  @override
  String get shareLinkCopied => 'Ссылка для обмена скопирована в буфер обмена.';

  @override
  String get shareNoteHint => 'Поделитесь своими мыслями...';

  @override
  String get shareNoteTitle => 'Поделиться заметкой';

  @override
  String get shareNoteTooltip => 'Поделиться заметкой';

  @override
  String get shareVision => 'Поделиться видением';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get signInToSaveData => 'Sign in to save data';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithGoogleButton => 'Sign in with Google';

  @override
  String get signInWithGoogleDesc =>
      'Connect your Google account to continue. Your profile info will be filled automatically.';

  @override
  String get signInWithGoogleTitle => 'Sign in with Google';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get simpleHabitColorSubtitle => 'Reflect your habit\'s personality';

  @override
  String get simpleHabitColorTitle => 'Pick a color';

  @override
  String get simpleHabitEmojiSubtitle => 'Make your habit more fun!';

  @override
  String get simpleHabitEmojiTitle => 'Choose an emoji to represent it';

  @override
  String get simpleHabitFrequencySubtitle => 'Установите свои цели';

  @override
  String get simpleHabitFrequencyTitle => 'How often do you want to do it?';

  @override
  String get simpleHabitMonthDaysSubtitle => 'Select the active days';

  @override
  String get simpleHabitMonthDaysTitle => 'Which days of the month?';

  @override
  String get simpleHabitNameSubtitle => 'What do you want to make a habit of?';

  @override
  String get simpleHabitNameTitle => 'Give your habit a name';

  @override
  String get simpleHabitPeriodicSubtitle => 'Set the repeat interval';

  @override
  String get simpleHabitPeriodicTitle => 'How many days apart?';

  @override
  String get simpleHabitPreviewSubtitle => 'Does everything look right?';

  @override
  String get simpleHabitPreviewTitle => 'Awesome! Here\'s your habit';

  @override
  String get simpleHabitReminderSubtitle =>
      'Don\'t miss your habit with daily reminders';

  @override
  String get simpleHabitReminderTitle => 'Shall I remind you?';

  @override
  String get simpleHabitStartDateSubtitle =>
      'Choose a starting point for your journey';

  @override
  String get simpleHabitStartDateTitle => 'When will you start?';

  @override
  String get simpleHabitSubtitle => 'Быстро создать привычку';

  @override
  String get simpleHabitTargetOne => 'Простая привычка (цель = 1)';

  @override
  String get simpleHabitTitle => 'Простая привычка';

  @override
  String get simpleHabitTypeDescription =>
      'For daily check-ins. Complete or skip.';

  @override
  String get simpleHabitWeekdaysSubtitle => 'Select the active days';

  @override
  String get simpleHabitWeekdaysTitle => 'Which days?';

  @override
  String get simpleHabitWizardDesc =>
      'I\'ll guide you step by step. Let\'s create an amazing habit together!';

  @override
  String get simpleHabitWizardTitle => 'Ready to build a new habit?';

  @override
  String get simpleTypeShort => 'Простой';

  @override
  String get skip => 'Пропустить';

  @override
  String get skipOnboarding => 'Пропустить';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => 'Социальное';

  @override
  String get socialFeaturesGuestMessage =>
      'Вам необходимо войти через Google, чтобы создавать комнаты и отслеживать прогресс вместе с друзьями.';

  @override
  String get socialFeaturesTitle => 'Социальные функции';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get socialRoomsTitle => 'Социальные комнаты';

  @override
  String get softCloud => 'Soft Cloud';

  @override
  String get softCloudDesc => 'Cloud-like, dreamy soft';

  @override
  String get softPeach => 'Soft Peach';

  @override
  String get softPeachDesc => 'Warm peach & cream tones';

  @override
  String get sound => 'Звук';

  @override
  String get soundAlerts => 'Звуковые оповещения';

  @override
  String get soundSubtitle => 'Воспроизводить звук при уведомлениях';

  @override
  String get specificDaysOfMonth => 'Определенные дни месяца';

  @override
  String get specificDaysOfWeek => 'Определенные дни недели';

  @override
  String get specificDaysOfYear => 'Определенные дни года';

  @override
  String get spendingAdvisorNoBudget =>
      'Установите бюджет, чтобы получить совет.';

  @override
  String get spendingAdvisorOnTrack => 'Отлично! Вы укладываетесь в бюджет.';

  @override
  String get spendingAdvisorOverBudget =>
      'Вы превысили бюджет. Прекратите траты.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Вы можете тратить $amount в день.';
  }

  @override
  String get spendingAdvisorTitle => 'Советник по расходам';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Сократите ежедневные расходы на $amount, чтобы уложиться в бюджет.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Отлично! Вы тратите на $amount меньше, чем в среднем в день.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Внимание! Вы тратите на $amount больше, чем в среднем в день.';
  }

  @override
  String get spin => 'SPIN';

  @override
  String get spinAgain => 'Spin Again';

  @override
  String get start => 'Начать';

  @override
  String get startDate => 'Дата начала';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => 'День начала (1-365)';

  @override
  String get startJourney => 'Начать путь';

  @override
  String get startTest => 'Start Test';

  @override
  String get startTestDesc =>
      'If you complete the test, you will get personalized suggestions and habit recommendations. You can skip this step if you wish.';

  @override
  String get startTestTitle => 'Do you want to start the personality test?';

  @override
  String get startTime => 'Время начала';

  @override
  String get startTrackingFinances =>
      'Start tracking your finances and take control of your spending.';

  @override
  String get startTrackingMood => 'Start tracking your mood to see analytics';

  @override
  String get startsOn => 'Starts on';

  @override
  String get statsActiveDays => 'Active Days';

  @override
  String get statusLabel => 'Статус';

  @override
  String get step => 'Шаг';

  @override
  String stepOf(Object current, Object total) {
    return 'Шаг $current из $total';
  }

  @override
  String get steps => 'Шаги';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return 'Серия $count дней';
  }

  @override
  String get streakIndicator => 'Индикатор серии';

  @override
  String get streakIndicatorDesc => 'Показывать эффекты пламени и льда';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => 'Злой';

  @override
  String get subEmotionAnxious => 'Тревожный';

  @override
  String get subEmotionBlessed => 'Blessed';

  @override
  String get subEmotionBored => 'Bored';

  @override
  String get subEmotionCalm => 'Спокойный';

  @override
  String get subEmotionCheerful => 'Весёлый';

  @override
  String get subEmotionConfident => 'Уверенный';

  @override
  String get subEmotionConfused => 'Confused';

  @override
  String get subEmotionDemoralized => 'Деморализованный';

  @override
  String get subEmotionDetermined => 'Решительный';

  @override
  String get subEmotionDistracted => 'Distracted';

  @override
  String get subEmotionDrained => 'Измотанный';

  @override
  String get subEmotionEmpty => 'Опустошённый';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'Энтузиазм';

  @override
  String get subEmotionEuphoric => 'Euphoric';

  @override
  String get subEmotionExcited => 'Взволнованный';

  @override
  String get subEmotionExhausted => 'Истощённый';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Guilty';

  @override
  String get subEmotionHappy => 'Счастливый';

  @override
  String get subEmotionHelpless => 'Беспомощный';

  @override
  String get subEmotionHopeful => 'Полный надежд';

  @override
  String get subEmotionHopeless => 'Безнадёжный';

  @override
  String get subEmotionHurt => 'Обиженный';

  @override
  String get subEmotionIndecisive => 'Нерешительный';

  @override
  String get subEmotionInsecure => 'Insecure';

  @override
  String get subEmotionLonely => 'Lonely';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'Мотивированный';

  @override
  String get subEmotionNumb => 'Онемевший';

  @override
  String get subEmotionOrdinary => 'Обычный';

  @override
  String get subEmotionOverwhelmed => 'Overwhelmed';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'Гордый';

  @override
  String get subEmotionRegretful => 'Regretful';

  @override
  String get subEmotionSad => 'Грустный';

  @override
  String get subEmotionSelection => 'Выбор под-эмоции';

  @override
  String get subEmotionStressed => 'Напряжённый';

  @override
  String get subEmotionTired => 'Уставший';

  @override
  String get subEmotionUnstoppable => 'Неудержимый';

  @override
  String get subscribeToEnjoyPremium => 'Subscribe to enjoy premium features';

  @override
  String get subscription => 'Подписка';

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
  String get success => 'Успех';

  @override
  String get successfulDayLegend => 'Успешный день';

  @override
  String successfulDaysCount(Object count) {
    return '$count успешных дней';
  }

  @override
  String get sundayShort => 'Вс';

  @override
  String get systemInfo => 'Системная информация';

  @override
  String get systemTheme => 'Системная тема';

  @override
  String get tapFabToCreate => 'Tap the + button to start';

  @override
  String get tapSpinToStart => 'Tap spin to start';

  @override
  String get tapToPickImage => 'Tap to pick image';

  @override
  String get target => 'Цель';

  @override
  String get targetDurationMinutes => 'Целевая продолжительность (минуты)';

  @override
  String targetShort(Object value) {
    return 'Цель: $value';
  }

  @override
  String get targetType => 'Тип цели';

  @override
  String get targetValue => 'Целевое Значение';

  @override
  String get targetValueLabel => 'Целевое значение';

  @override
  String get taskAdded => 'Task added';

  @override
  String taskAddedSnackbar(Object title) {
    return 'Задача $title добавлена! ✅';
  }

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'Задача удалена: $title';
  }

  @override
  String get taskDescription => 'Описание (Необязательно)';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'Название задачи';

  @override
  String get taskTitleRequired => 'Требуется название задачи';

  @override
  String get tellMeYourDream =>
      'Tell me your dream. I\'ll help you build a Vision Board.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'Детали шаблона не найдены';

  @override
  String get templatesTabManual => 'Вручную';

  @override
  String get templatesTabReady => 'Готово';

  @override
  String get testsSection => 'Тесты';

  @override
  String get textLabel => 'Текст';

  @override
  String get theWinnerIs => 'Победитель:';

  @override
  String get theme => 'Тема';

  @override
  String get themeAbyss => 'Бездна';

  @override
  String get themeAbyssDesc => 'Dark & Sophisticated';

  @override
  String get themeBlush => 'Blush';

  @override
  String get themeBlushDesc => 'Sweet & Feminine';

  @override
  String get themeCotton => 'Хлопок';

  @override
  String get themeCottonDesc => 'Warm & Neutral';

  @override
  String get themeCream => 'Кремовый';

  @override
  String get themeCreamDesc => 'Warm & Soft';

  @override
  String get themeCrimson => 'Малиновый';

  @override
  String get themeCrimsonDesc => 'Смелый и страстный';

  @override
  String get themeDetails => 'Детали темы';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeForestDesc => 'Rich & Organic';

  @override
  String get themeLavender => 'Лаванда';

  @override
  String get themeLavenderDesc => 'Calm & Dreamy';

  @override
  String get themeMatcha => 'Матча';

  @override
  String get themeMatchaDesc => 'Fresh & Natural';

  @override
  String get themeMauve => 'Розовато-лиловый';

  @override
  String get themeMauveDesc => 'Элегантный и романтичный';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightDesc => 'Глубокий и таинственный';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeOceanDesc => 'Deep & Serene';

  @override
  String get themeRose => 'Роза';

  @override
  String get themeRoseDesc => 'Soft & Warm';

  @override
  String get themeSelection => 'Выбор темы';

  @override
  String get themeSky => 'Небо';

  @override
  String get themeSkyDesc => 'Airy & Light';

  @override
  String get themeSlate => 'Сланцевый';

  @override
  String get themeSlateDesc => 'Modern & Cool';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeSunsetDesc => 'Warm & Golden';

  @override
  String get themeVintageRed => 'Theme Vintage Red';

  @override
  String get themeVintageRedDesc => 'Theme Vintage Red Desc';

  @override
  String get thisFeatureIsPremium => 'This feature is Premium';

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get thisYear => 'Этот год';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst =>
      'Сначала создайте привычку с таймером';

  @override
  String get timerDescription => 'Отслеживание на основе времени';

  @override
  String get timerExample => 'Сделать 30-минутную тренировку';

  @override
  String get timerHabitLabel => 'Привычка с таймером';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Ожидаемая продолжительность: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Ожидание: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Перерыв';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Выполненная работа: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Цикл длинного перерыва (например, 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Длинный перерыв (мин)';

  @override
  String get timerPomodoroSettings => 'Настройки Pomodoro';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Короткий перерыв (мин)';

  @override
  String get timerPomodoroSkipPhase => 'Пропустить фазу';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Работа (мин)';

  @override
  String get timerPomodoroWorkPhase => 'Работа';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => 'Сохранить продолжительность';

  @override
  String get timerSaveSessionTitle => 'Сохранить сеанс';

  @override
  String get timerSessionAlreadySaved => 'Этот сеанс уже сохранен';

  @override
  String get timerSetDurationFirst => 'Сначала установите продолжительность';

  @override
  String get timerSettings => 'Настройки таймера';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'Обратный отсчет';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Секундомер';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'Таймер';

  @override
  String get times => 'Раз';

  @override
  String get timezone => 'Часовой пояс';

  @override
  String get titleHint => 'Пример: Продукты, Фриланс и т.д.';

  @override
  String get titleOptional => 'Название (необязательно)';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Today\'s Habits';

  @override
  String get tokenEarnedSuccess => 'Получен +1 жетон! 🎉';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'Общая продолжительность';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalMembersLabel => 'Всего участников';

  @override
  String get totalProgress => 'Общий прогресс';

  @override
  String get totalSuccessfulDays => 'Всего успешных дней';

  @override
  String get totalUnsuccessfulDays => 'Всего неуспешных дней';

  @override
  String get trackEarnings => 'Track your earnings';

  @override
  String get trackSpending => 'Track your spending';

  @override
  String get trends => 'Trends';

  @override
  String get trialCancelEffect =>
      'If you cancel during the free trial, you won\'t be charged immediately.';

  @override
  String get trialInfo => '14-day free trial, cancel anytime.';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get typeEmoji => 'Type an emoji from keyboard';

  @override
  String get typeEmojiHint => 'Type an emoji from keyboard';

  @override
  String get typeLabel => 'Тип';

  @override
  String get typeNotChangeable => 'Тип нельзя изменить';

  @override
  String get unassignLinkedDailyTasks => 'Отвязать связанные ежедневные задачи';

  @override
  String get unassignLinkedHabits => 'Отвязать связанные привычки';

  @override
  String get undo => 'Отменить';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => 'Единица';

  @override
  String get unitAdet => 'шт';

  @override
  String get unitAdim => 'шаг';

  @override
  String get unitBardak => 'стакан';

  @override
  String get unitHint => 'Единица (стакан, шаг, страница...)';

  @override
  String get unitKalori => 'кал';

  @override
  String get unitKez => 'раз';

  @override
  String get unitKm => 'км';

  @override
  String get unitLitre => 'литр';

  @override
  String get unitSayfa => 'стр';

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
  String get update => 'Обновить';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => 'Значение';

  @override
  String get vibration => 'Вибрация';

  @override
  String get vibrationSubtitle => 'Вибрировать при уведомлениях';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'Видение';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Это видение будет использовать последний день в шаблоне: $day.';
  }

  @override
  String get visionBoard => 'Доска визуализации';

  @override
  String get visionBoardDesc =>
      'Create a vision to organize your goals and track your journey';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'Создать видение';

  @override
  String get visionDurationDaysLabel => 'Продолжительность (дни)';

  @override
  String get visionDurationNote =>
      'Примечание: Когда видение начинается, устанавливается общая продолжительность; если день окончания превышает эту продолжительность, она будет автоматически сокращена.';

  @override
  String get visionEditTitle => 'Редактировать видение';

  @override
  String get visionEmptyDescription =>
      'Visualize your goals and add your first vision to turn your dreams into reality.';

  @override
  String get visionEndDayInvalid => 'День окончания должен быть между 1 и 365';

  @override
  String get visionEndDayLess =>
      'День окончания не может быть раньше дня начала';

  @override
  String get visionEndDayQuestion =>
      'В какой день видения оно должно закончиться?';

  @override
  String get visionEndDayRequired => 'Введите день окончания';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo =>
      'День окончания не указан. Видение начнется без определенной продолжительности.';

  @override
  String get visionPlural => 'Видения';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid => 'День начала должен быть между 1 и 365';

  @override
  String get visionStartDayQuestion =>
      'В какой день видения оно должно начаться?';

  @override
  String get visionStartFailed => 'Не удалось начать видение.';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Видение начато: $title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => 'Визуальный';

  @override
  String get warmJournal => 'Warm Journal';

  @override
  String get warmJournalDesc => 'Warm journal & emotion tracking';

  @override
  String get watchAdForToken => 'Смотреть рекламу (+1 жетон)';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => 'Пт';

  @override
  String get weekdaysShortMon => 'Пн';

  @override
  String get weekdaysShortSat => 'Сб';

  @override
  String get weekdaysShortSun => 'Вс';

  @override
  String get weekdaysShortThu => 'Чт';

  @override
  String get weekdaysShortTue => 'Вт';

  @override
  String get weekdaysShortWed => 'Ср';

  @override
  String get weekly => 'Еженедельно';

  @override
  String get weeklyDesc => 'On specific days of the week';

  @override
  String get weeklyEmailSummary => 'Еженедельная сводка по электронной почте';

  @override
  String get weeklyProgress => 'Еженедельный прогресс';

  @override
  String get weeklyReportsTitle => 'Еженедельные отчеты';

  @override
  String get weeklySchedule => 'Еженедельно';

  @override
  String get weeklySummaryEmail => 'Еженедельное сводное письмо';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => 'Какая причина?';

  @override
  String get wheelOfFortuneDescription => 'Add options and spin the wheel';

  @override
  String get wheelOfFortuneTitle => 'Wheel of Fortune';

  @override
  String get whichDays => 'Which days';

  @override
  String get whichDaysActive => 'Какие дни должны быть активны?';

  @override
  String get whichMonthDays => 'Какие дни месяца?';

  @override
  String get whichWeekdays => 'Какие дни недели?';

  @override
  String get whichYearDays => 'Which year days';

  @override
  String get worldTheme => 'Мир';

  @override
  String get worldThemeDesc => 'Гармония всех цветов';

  @override
  String get writeMessage => 'Написать сообщение...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP до следующего уровня';
  }

  @override
  String xpToNextLevel(Object toNext) {
    return 'до следующего уровня';
  }

  @override
  String get yearly => 'Ежегодно';

  @override
  String get yearlyProgress => 'Годовой прогресс';

  @override
  String get yesNoDescription => 'Простое отслеживание да/нет';

  @override
  String get yesNoExample => 'Медитировал ли я сегодня?';

  @override
  String get yesNoType => 'Да/Нет';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get youLabel => 'Вы';

  @override
  String get yourCharacterType => 'Your Character Type';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get yourMoodToday => 'Your Mood Today';
}
