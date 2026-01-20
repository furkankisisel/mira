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
  String get addFirstTransaction => 'İlk işlemi ekle';

  @override
  String get addHabit => 'Добавить привычку';

  @override
  String get addImage => 'Добавить изображение';

  @override
  String get addNew => 'Добавить новое';

  @override
  String get addNewHabit => 'Добавить новую привычку';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Başlamak için seçenek ekle';

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
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'Продвинутая Привычка';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get aiAssistantOnline => 'Çevrimiçi';

  @override
  String get aiAssistantTitle => 'Mira Asistan';

  @override
  String aiContextMessage(Object tip) {
    return 'Merhaba! Bu ipucuyla ilgilendiğinizi fark ettim:\n\n\"$tip\"\n\nBunu Mira\'da nasıl uygulayacağınızı göstermemi ister misiniz?';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return 'AI ile $count alışkanlık eklendi';
  }

  @override
  String get aiInputHint => 'Kazanmak istediğiniz alışkanlığı tarif edin...';

  @override
  String get aiPoweredRecommendations => 'AI powered recommendations';

  @override
  String get aiPreviewTitle => 'AI Önerileri';

  @override
  String get aiQuickFinance => 'Bütçe önerileri';

  @override
  String get aiQuickGamification => 'XP sistemi nedir?';

  @override
  String get aiQuickHabit => 'Yeni alışkanlık oluştur';

  @override
  String get aiQuickMood => 'Ruh halimi analiz et';

  @override
  String get aiQuickMotivation => 'Bana motivasyon ver';

  @override
  String get aiQuickProfile => 'Yapay Zeka Karakterim';

  @override
  String get aiQuickTimer => 'Zamanlayıcı nasıl kullanılır?';

  @override
  String get aiQuickVision => 'Vizyon Panosu yardımı';

  @override
  String get aiRetry => 'Tekrar Dene (Sıkı Kurallar)';

  @override
  String get aiShowMeHow => 'Evet, nasıl yapacağımı göster';

  @override
  String get aiTip0 =>
      'Biliyor muydunuz? Uzun vadeli hedefleriniz için bir Vizyon Panosu oluşturabilirsiniz.';

  @override
  String get aiTip1 =>
      'İpucu: Odaklanmış çalışma oturumları için Zamanlayıcıyı kullanın.';

  @override
  String get aiTip2 =>
      'Zaman içindeki değişimleri görmek için günlük ruh halinizi takip edin.';

  @override
  String get aiTip3 =>
      'Alışkanlıklar her gün aynı saatte yapıldığında daha kalıcı olur.';

  @override
  String get aiTip4 =>
      'Büyük Vizyonları daha küçük, yönetilebilir Görevlere bölün.';

  @override
  String get aiTip5 =>
      'Günlük harcamalarınızı takip etmek için Finans sekmesini kullanın.';

  @override
  String get aiTip6 =>
      'Yardıma mı ihtiyacınız var? AI asistana sormak için buraya dokunun!';

  @override
  String get aiTip7 => 'İstikrar anahtardır! Zinciri kırmayın.';

  @override
  String get aiWelcomeMessage =>
      'Merhaba! Ben Mira asistanınızım. Size bugün nasıl yardımcı olabilirim? Vizyonlar, alışkanlıklar, zamanlayıcılar veya diğer özellikler hakkında soru sorabilirsiniz.';

  @override
  String get allDataDeleted => 'All data deleted';

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
      'Verilerinizi her 24 saatte bir otomatik olarak Google Drive\'a yedekleyin.';

  @override
  String get autoBackupTitle => 'Otomatik Yedekleme';

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
  String get backupRestore => 'Yedekleme & Geri Yükleme';

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
  String get choosePhoto => 'Fotoğraf Seç';

  @override
  String get choosePhotoSubtitle => 'Seni motive eden bir fotoğraf seç';

  @override
  String get choosePhotoDesc => 'Size ilham veren bir fotoğraf seçin';

  @override
  String get clear => 'Очистить';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get close => 'Закрыть';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'İki seçenek arasında karar ver';

  @override
  String get coinFlipInstruction => 'İki seçeneği yaz ve parayı çevir!';

  @override
  String get coinFlipTitle => 'Yazı Tura';

  @override
  String get colorLabel => 'Цвет';

  @override
  String get colorTheme => 'Цветовая тема';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'Завершено (выбранный день)';

  @override
  String get confirmDeleteAccount => 'Confirm Account Deletion';

  @override
  String get confirmHabits => 'Alışkanlıkları Onayla';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueText => 'Devam Et';

  @override
  String get cottonCandy => 'Pamuk Şeker';

  @override
  String get cottonCandyDesc => 'Pamuk şeker - pembe ve mavi';

  @override
  String get countdownConfigureTitle => 'Настроить обратный отсчет';

  @override
  String get countdownLabel => 'COUNTDOWN';

  @override
  String get cozyJournal => 'Rahat Günlük';

  @override
  String get cozyJournalDesc => 'Kahverengi tonlar ve zaman çizelgesi';

  @override
  String get crashReports => 'Crash reports';

  @override
  String get crashReportsSubtitle => 'Send anonymous reports on app crashes';

  @override
  String get create => 'Создать';

  @override
  String get createAdvancedHabit => 'Создать Продвинутую Привычку';

  @override
  String get createDailyTask => 'Создать ежедневную задачу';

  @override
  String get createFirstHabit => 'Alışkanlık Oluştur';

  @override
  String get createFirstVision => 'İlk Vizyonunuzu Oluşturun';

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
  String get createVision => 'Создать видение';

  @override
  String get createVisionTemplateTitle => 'Создать шаблон видения';

  @override
  String get createVisionWithAI => 'Yapay Zeka ile Vizyon Oluştur';

  @override
  String get createWithAi => 'AI ile Oluştur';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

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
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => 'Дневной лимит';

  @override
  String get dailyTask => 'Ежедневная задача';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Ежедневная задача создана: $title';
  }

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
  String get dayFriShort => 'Cum';

  @override
  String get dayMonShort => 'Pzt';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'День $start–$end';
  }

  @override
  String get daySatShort => 'Cmt';

  @override
  String dayShort(Object day) {
    return 'День $day';
  }

  @override
  String get daySunShort => 'Paz';

  @override
  String get dayThuShort => 'Per';

  @override
  String get dayTueShort => 'Sal';

  @override
  String get dayWedShort => 'Çar';

  @override
  String get days => 'gün';

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
  String get decisionEggDescription => 'Mistik yumurtalardan birini seç';

  @override
  String get decisionEggTitle => 'Karar Yumurtası';

  @override
  String get defaultUnit => 'adet';

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
  String deleteHabitConfirm(Object title) {
    return 'Удалить привычку \"$title\"?';
  }

  @override
  String get deleteListMessage =>
      'Этот список будет удален. Выберите, что делать со связанными элементами:';

  @override
  String get deleteListTitle => 'Удалить список';

  @override
  String get deleteMyAccount => 'Delete My Account';

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
  String get difficulty => 'Уровень Сложности';

  @override
  String get drinkWater => 'Su İç';

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
  String get editCategory => 'Редактировать категорию';

  @override
  String get editHabit => 'Редактировать привычку';

  @override
  String get editListTitle => 'Редактировать список';

  @override
  String get education => 'Образование';

  @override
  String get eggRevealMessage => 'Mistik yumurta cevabını verdi! ✨';

  @override
  String get eggSelectMessage =>
      'Aklından bir soru tut ve bir yumurtaya dokun 🥚';

  @override
  String get emojiAndColor => 'Emoji & Renk';

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
  String get emptyHabitSubtitle =>
      'İlerlemeni takip etmek için ilk alışkanlığını oluştur.';

  @override
  String get emptyHabitTitle => 'Yolculuğuna Başla';

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
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

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
  String get featureAdvancedFinance => 'Gelişmiş Finans Özellikleri';

  @override
  String get featureAdvancedHabits => 'Gelişmiş Alışkanlık Oluşturma';

  @override
  String get featureBackup => 'Yedekleme Özelliği';

  @override
  String get featurePremiumThemes => 'Premium Temalar';

  @override
  String get featureVisionCreation => 'Vizyon Oluşturma';

  @override
  String get feelingMoreSpecific => 'Можете быть более конкретным?';

  @override
  String get filterTitle => 'Фильтр';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'Финансы';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Финансовый анализ · $month';
  }

  @override
  String get financeLast7Days => 'Финансы · Последние 7 дней';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'Завершить';

  @override
  String get fitness => 'Фитнес';

  @override
  String get fixedDuration => 'Фиксированная';

  @override
  String get flexiblePlan => 'Flexible plan, cancel anytime';

  @override
  String get flipCoin => 'Parayı Çevir';

  @override
  String get focusLabel => 'FOCUS';

  @override
  String get focusedZen => 'Odaklanmış Zen';

  @override
  String get focusedZenDesc => 'Minimalist, tek odak noktası';

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
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'Полное имя';

  @override
  String get fullScreen => 'Полный экран';

  @override
  String get gallery => 'Галерея';

  @override
  String get gamesDescription =>
      'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!';

  @override
  String get gamesTitle => 'Oyunlar';

  @override
  String get general => 'Общие';

  @override
  String get generalNotifications => 'Общие уведомления';

  @override
  String get generate => 'Oluştur';

  @override
  String get glasses => 'Стаканы';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'Золотой';

  @override
  String get goldenThemeDesc => 'Теплая золотая тема';

  @override
  String get goodMorning => 'Günaydın! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Предоставлено';

  @override
  String get greatDayAhead => 'Bugün harika bir gün, başarabilirsin!';

  @override
  String get greetingAfternoon => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get guestAccount => 'Misafir Hesabı';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

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
  String get habitUpdatedMessage => 'Привычка обновлена.';

  @override
  String get habits => 'Привычки';

  @override
  String get habitsSection => 'Привычки';

  @override
  String get hard => 'Сложно';

  @override
  String get hardMode => 'Zor Mod';

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
  String get hourShort => 'sa';

  @override
  String get hours => 'Часы';

  @override
  String get howAreYouFeeling => 'Как вы себя чувствуете?';

  @override
  String get howDoYouFeel => 'Bugün nasıl hissediyorsun?';

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
  String get invalidLink => 'Неверная ссылка.';

  @override
  String get invalidValue => 'Неверное значение';

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
  String get keepItUp => 'Harika! Aynen devam! 💪';

  @override
  String get language => 'Язык';

  @override
  String get languageSelection => 'Выбор языка';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Lavanta Rüyaları';

  @override
  String get lavenderDreamsDesc => 'Zarif lavanta ve mor tonları';

  @override
  String get letsPlayGame => 'Hadi oynayalım! 🎮';

  @override
  String get letsStart => 'Hadi Başlayalım';

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
  String get manualFallback => 'Manuel Oluştur';

  @override
  String get maxOptionsReached => 'Maksimum 12 seçenek ekleyebilirsin';

  @override
  String get meditation => 'Meditasyon';

  @override
  String get medium => 'Средне';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Осознанность';

  @override
  String get mintFresh => 'Taze Nane';

  @override
  String get mintFreshDesc => 'Taze nane ve turkuaz tonları';

  @override
  String get minutes => 'Минуты';

  @override
  String get minutesSuffixShort => 'мин';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Pzt';

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
  String get monthlyDesc => 'Ayın belirli günlerinde';

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
  String get mtdAverageShort => 'Средн. с нач. месяца';

  @override
  String get multiple => 'Несколько';

  @override
  String get multipleSubItems => 'Multiple sub-items';

  @override
  String get multipleSubItemsDesc => 'Çoklu alt öğeler';

  @override
  String get mustBePremiumToUse =>
      'You must be a Premium subscriber to use this feature.';

  @override
  String get myBigGoal => 'Büyük Hedefim';

  @override
  String get myBoard => 'My Board';

  @override
  String get mysticTheme => 'Мистический';

  @override
  String get mysticThemeDesc => 'Мистическая фиолетовая тема';

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
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

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
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => 'Следующий год';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

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
  String get noExpenseInThisCategory => 'Нет расходов в этой категории';

  @override
  String get noExpenses => 'Нет расходов';

  @override
  String get noExpensesThisMonth => 'Нет расходов за этот месяц';

  @override
  String get noHabitsAddedYet => 'Привычки еще не добавлены.';

  @override
  String get noHistory => 'Нет истории';

  @override
  String get noIncomeThisMonth => 'Нет доходов за этот месяц';

  @override
  String get noItemsMatchFilters =>
      'Нет элементов, соответствующих выбранным фильтрам';

  @override
  String get noLinkedHabitsInVision =>
      'Нет привычек, связанных с этим видением.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => 'Готовые видения не найдены.';

  @override
  String get noRecordsThisMonth => 'Нет записей за этот месяц';

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
  String get option1 => 'Seçenek 1';

  @override
  String get option2 => 'Seçenek 2';

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
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => 'Периодический выбор';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

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
  String get previous => 'Предыдущий';

  @override
  String get previousYear => 'Предыдущий год';

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
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

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
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

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
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => 'Повторить';

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
  String get saturdayShort => 'Cmt';

  @override
  String get save => 'Сохранить';

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
  String get selectCategory => 'Выбрать категорию';

  @override
  String get selectDate => 'Выбрать дату';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'Выбрать дату окончания';

  @override
  String get selectFrequency => 'Выбрать частоту';

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
  String get setVisionTimeline =>
      'Vizyonunuz için zaman çizelgesini belirleyin';

  @override
  String get settings => 'Настройки';

  @override
  String get shareAsLink => 'Поделиться как ссылка';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied => 'Ссылка для обмена скопирована в буфер обмена.';

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
  String get signInToSaveData => 'Verileri kaydetmek için giriş yap';

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
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutConfirmation => 'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get simpleHabitColorSubtitle => 'Alışkanlığının kişiliğini yansıtsın';

  @override
  String get simpleHabitColorTitle => 'Bir renk seç';

  @override
  String get simpleHabitEmojiSubtitle =>
      'Alışkanlığını daha eğlenceli hale getir!';

  @override
  String get simpleHabitEmojiTitle => 'Onu temsil edecek bir emoji seç';

  @override
  String get simpleHabitFrequencySubtitle => 'Hedeflerini belirle';

  @override
  String get simpleHabitFrequencyTitle => 'Ne sıklıkla yapmak istiyorsun?';

  @override
  String get simpleHabitMonthDaysSubtitle => 'Aktif olacağı günleri seç';

  @override
  String get simpleHabitMonthDaysTitle => 'Ayın hangi günlerinde?';

  @override
  String get simpleHabitNameSubtitle =>
      'Neyi alışkanlık haline getirmek istiyorsun?';

  @override
  String get simpleHabitNameTitle => 'Alışkanlığına bir isim ver';

  @override
  String get simpleHabitPeriodicSubtitle => 'Tekrar aralığını belirle';

  @override
  String get simpleHabitPeriodicTitle => 'Kaç günde bir?';

  @override
  String get simpleHabitPreviewSubtitle => 'Her şey doğru görünüyor mu?';

  @override
  String get simpleHabitPreviewTitle => 'Harika! İşte alışkanlığın';

  @override
  String get simpleHabitReminderSubtitle =>
      'Günlük hatırlatıcıyla alışkanlığını kaçırma';

  @override
  String get simpleHabitReminderTitle => 'Sana hatırlatayım mı?';

  @override
  String get simpleHabitStartDateSubtitle =>
      'Yolculuğun için bir başlangıç noktası seç';

  @override
  String get simpleHabitStartDateTitle => 'Ne zaman başlayacaksın?';

  @override
  String get simpleHabitTargetOne => 'Простая привычка (цель = 1)';

  @override
  String get simpleHabitWeekdaysSubtitle => 'Aktif olacağı günleri seç';

  @override
  String get simpleHabitWeekdaysTitle => 'Hangi günlerde?';

  @override
  String get simpleHabitWizardDesc =>
      'Seni adım adım yönlendireceğim. Birlikte harika bir alışkanlık oluşturalım!';

  @override
  String get simpleHabitWizardTitle =>
      'Yeni bir alışkanlık kazanmaya hazır mısın?';

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
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

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
  String get startTrackingFinances =>
      'Finanslarınızı takip etmeye başlayın ve harcamalarınızı kontrol altına alın.';

  @override
  String get startTrackingMood => 'Start tracking your mood to see analytics';

  @override
  String get startsOn => 'Başlangıç';

  @override
  String get statsActiveDays => 'Aktif Gün';

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
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => 'Спокойный';

  @override
  String get subEmotionCheerful => 'Весёлый';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => 'Деморализованный';

  @override
  String get subEmotionDetermined => 'Решительный';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => 'Измотанный';

  @override
  String get subEmotionEmpty => 'Опустошённый';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'Энтузиазм';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => 'Взволнованный';

  @override
  String get subEmotionExhausted => 'Истощённый';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => 'Счастливый';

  @override
  String get subEmotionHelpless => 'Беспомощный';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => 'Безнадёжный';

  @override
  String get subEmotionHurt => 'Обиженный';

  @override
  String get subEmotionIndecisive => 'Нерешительный';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'Мотивированный';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => 'Обычный';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'Гордый';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => 'Грустный';

  @override
  String get subEmotionSelection => 'Выбор под-эмоции';

  @override
  String get subEmotionStressed => 'Напряжённый';

  @override
  String get subEmotionTired => 'Уставший';

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
  String get success => 'Успех';

  @override
  String get successfulDayLegend => 'Успешный день';

  @override
  String successfulDaysCount(Object count) {
    return '$count успешных дней';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'Системная информация';

  @override
  String get systemTheme => 'Системная тема';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

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
      'Hayalini anlat. Vizyon Panosu oluşturmana yardım edeyim.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'Детали шаблона не найдены';

  @override
  String get templatesTabManual => 'Вручную';

  @override
  String get templatesTabReady => 'Готово';

  @override
  String get textLabel => 'Текст';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'Тема';

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
  String get themeDetails => 'Детали темы';

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
  String get themeSelection => 'Выбор темы';

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
  String get thisMonth => 'Этот месяц';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get thisYear => 'Этот год';

  @override
  String get thursdayShort => 'Per';

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
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'Общая продолжительность';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => 'Общий прогресс';

  @override
  String get totalSuccessfulDays => 'Всего успешных дней';

  @override
  String get totalUnsuccessfulDays => 'Всего неуспешных дней';

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
  String get visionBoard => 'Vizyon Panosu';

  @override
  String get visionBoardDesc =>
      'Hedeflerinizi organize etmek ve yolculuğunuzu takip etmek için bir vizyon oluşturun';

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
      'Hedeflerinizi görselleştirin ve hayallerinizi gerçeğe dönüştürmek için ilk vizyonunuzu ekleyin.';

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
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

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
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => 'Еженедельная сводка по электронной почте';

  @override
  String get weeklyProgress => 'Еженедельный прогресс';

  @override
  String get weeklySummaryEmail => 'Еженедельное сводное письмо';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => 'Какая причина?';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => 'Какие дни должны быть активны?';

  @override
  String get whichWeekdays => 'Какие дни недели?';

  @override
  String get worldTheme => 'Мир';

  @override
  String get worldThemeDesc => 'Гармония всех цветов';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP до следующего уровня';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

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
  String get yourCharacterType => 'Your Character Type';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get yourMoodToday => 'Your Mood Today';

  @override
  String get dailyHabitInfo => 'Bu alışkanlık her gün tekrarlanacak';

  @override
  String get whichDays => 'Hangi günler?';

  @override
  String get whichMonthDays => 'Какие дни месяца?';

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
      'Biyolojik Saatinize Göre Alışkanlıkları Maksimum Verimle Kazanın';

  @override
  String get rhythmTeaserSubtitle =>
      'Canlı Ritim, en verimli anlarınızı öğrenir ve alışkanlıklarınızı doğru zamana yerleştirir.';

  @override
  String get rhythmTeaserSkip => 'Atla';

  @override
  String get rhythmTeaserCta => 'Paketleri İncele';

  @override
  String get rhythmWindowFocus => 'Odak Zamanı';

  @override
  String get rhythmWindowFocusDesc => 'Zihinsel netlik, öğrenme, analiz';

  @override
  String get rhythmWindowEnergy => 'Enerji Zamanı';

  @override
  String get rhythmWindowEnergyDesc => 'Hareket, aksiyon, spor';

  @override
  String get rhythmWindowLight => 'Hafif Zaman';

  @override
  String get rhythmWindowLightDesc => 'Düşük efor, küçük işler';

  @override
  String get rhythmWindowReflection => 'Refleksiyon Zamanı';

  @override
  String get rhythmWindowReflectionDesc => 'Günlük, tefekkür, kapanış';

  @override
  String get rhythmBenefit1 => 'Doğru zamanda doğru iş';

  @override
  String get rhythmBenefit2 => 'Karar yorgunluğu yok';

  @override
  String get rhythmBenefit3 => 'Her hafta kişiselleşme';

  @override
  String get rhythmAnalyzing => 'Canlı Ritim analiz ediyor...';

  @override
  String get rhythmDisclaimer =>
      'Bunlar kesin sonuçlar değil. Canlı Ritim seni tanıdıkça ayarlanacak.';

  @override
  String get rhythmQ1 => 'Genelde kaçta uyuyorsun?';

  @override
  String get rhythmQ2 => 'Genelde kaçta uyanıyorsun?';

  @override
  String get rhythmQ3 => 'Zor bir işi en rahat ne zaman yaparsın?';

  @override
  String get rhythmQ4 =>
      'Yeni bir şey öğrenirken kendini en net hissettiğin zaman?';

  @override
  String get rhythmQ5 => 'Günün hangi bölümünde daha hareketli hissedersin?';

  @override
  String get rhythmQ6 =>
      'Spor veya fiziksel işler sana ne zaman daha kolay gelir?';

  @override
  String get rhythmQ7 =>
      'Günün hangi saatlerinde çabuk sıkılırsın veya ertelemeye yatkın olursun?';

  @override
  String get rhythmQ8 => 'Bu düşük enerji zamanlarında genelde ne yaparsın?';

  @override
  String get rhythmQ9 => 'Günün sonunda hangisi sana daha iyi gelir?';

  @override
  String get rhythmQ10 => 'Akşam saatlerinde zihnin genelde nasıl olur?';

  @override
  String get rhythmQ11 => 'Kendini hangisine daha yakın hissediyorsun?';

  @override
  String get rhythmA1_1 => '22:00 – 23:00';

  @override
  String get rhythmA1_2 => '23:00 – 00:00';

  @override
  String get rhythmA1_3 => '00:00 – 01:00';

  @override
  String get rhythmA1_4 => '01:00+';

  @override
  String get rhythmA2_1 => '06:00 – 07:00';

  @override
  String get rhythmA2_2 => '07:00 – 08:00';

  @override
  String get rhythmA2_3 => '08:00 – 09:00';

  @override
  String get rhythmA2_4 => '09:00+';

  @override
  String get rhythmA3_1 => 'Sabah erken';

  @override
  String get rhythmA3_2 => 'Sabah ortası';

  @override
  String get rhythmA3_3 => 'Öğleden sonra';

  @override
  String get rhythmA3_4 => 'Akşam';

  @override
  String get rhythmA3_5 => 'Fark etmez';

  @override
  String get rhythmA4_1 => 'Sabah';

  @override
  String get rhythmA4_2 => 'Öğlen';

  @override
  String get rhythmA4_3 => 'Akşam';

  @override
  String get rhythmA4_4 => 'Gece';

  @override
  String get rhythmA4_5 => 'Değişiyor';

  @override
  String get rhythmA5_1 => 'Sabah';

  @override
  String get rhythmA5_2 => 'Öğlen';

  @override
  String get rhythmA5_3 => 'Akşam';

  @override
  String get rhythmA5_4 => 'Hiçbiri';

  @override
  String get rhythmA5_5 => 'Gün içinde dalgalı';

  @override
  String get rhythmA6_1 => 'Sabah';

  @override
  String get rhythmA6_2 => 'Öğleden sonra';

  @override
  String get rhythmA6_3 => 'Akşam';

  @override
  String get rhythmA6_4 => 'Hiç fark etmez';

  @override
  String get rhythmA7_1 => 'Öğle sonrası';

  @override
  String get rhythmA7_2 => 'Akşamüstü';

  @override
  String get rhythmA7_3 => 'Gece';

  @override
  String get rhythmA7_4 => 'Belirgin değil';

  @override
  String get rhythmA8_1 => 'Sosyal medyada oyalanırım';

  @override
  String get rhythmA8_2 => 'Basit işler yaparım';

  @override
  String get rhythmA8_3 => 'Dinlenirim';

  @override
  String get rhythmA8_4 => 'Kendimi zorlamaya çalışırım';

  @override
  String get rhythmA9_1 => 'Yazmak / düşünmek';

  @override
  String get rhythmA9_2 => 'Sessizce dinlenmek';

  @override
  String get rhythmA9_3 => 'Okumak';

  @override
  String get rhythmA9_4 => 'Direkt uyumak';

  @override
  String get rhythmA10_1 => 'Sakin ve toparlayıcı';

  @override
  String get rhythmA10_2 => 'Yorgun ama düşünceli';

  @override
  String get rhythmA10_3 => 'Dağınık';

  @override
  String get rhythmA10_4 => 'Hâlâ aktif';

  @override
  String get rhythmA11_1 => 'Sabah insanıyım';

  @override
  String get rhythmA11_2 => 'Akşam insanıyım';

  @override
  String get rhythmA11_3 => 'Ortadayım';

  @override
  String get rhythmA11_4 => 'Dönemsel değişiyor';

  @override
  String get testsSection => 'Testler';

  @override
  String get retakePersonalityTestDesc => 'Karakter tipini tekrar keşfet';

  @override
  String get retakeRhythmTest => 'Canlı Ritim Testini Yeniden Yap';

  @override
  String get retakeRhythmTestDesc => 'Biyolojik saatini tekrar belirle';
}
