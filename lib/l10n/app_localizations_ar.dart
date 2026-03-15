// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get weeklyReportsTitle => 'التقارير الأسبوعية';

  @override
  String get noReportsYet => 'لا توجد تقارير بعد';

  @override
  String get createFirstReportPrompt =>
      'انقر على + لإنشاء تقريرك الأسبوعي الأول';

  @override
  String get generating => 'جارٍ الإنشاء...';

  @override
  String get createReport => 'إنشاء تقرير';

  @override
  String costTokens(Object cost) {
    return 'التكلفة: $cost رموز';
  }

  @override
  String balanceParenthesis(Object balance) {
    return '(الرصيد: $balance)';
  }

  @override
  String get watchAdForToken => 'شاهد إعلان (+1 رمز)';

  @override
  String get selectReportType => 'اختر نوع التقرير:';

  @override
  String generatedAtDate(Object date) {
    return 'تم الإنشاء: $date';
  }

  @override
  String get insufficientTokensWatchAd =>
      'الرموز غير كافية! شاهد إعلانًا لكسب الرموز.';

  @override
  String get reportCreatedSuccess => 'تم إنشاء التقرير! ✨';

  @override
  String get reportAlreadyExists => 'التقرير موجود بالفعل لهذا الأسبوع.';

  @override
  String get tokenEarnedSuccess => 'تم كسب +1 رمز! 🎉';

  @override
  String get about => 'حول';

  @override
  String get account => 'الحساب';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'أيام نشطة';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => 'إضافة';

  @override
  String get addDate => 'إضافة تاريخ';

  @override
  String get addFirstTransaction => 'İlk işlemi ekle';

  @override
  String get addHabit => 'إضافة عادة';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get addNewHabit => 'إضافة عادة جديدة';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Başlamak için seçenek ekle';

  @override
  String get addSpecialDays => 'إضافة أيام خاصة';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get addText => 'إضافة نص';

  @override
  String get addToList => 'إضافة إلى القائمة';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'عادة متقدمة';

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
  String get allLabel => 'الكل';

  @override
  String get alsoDeleteLinkedHabits => 'حذف العادات المرتبطة أيضًا';

  @override
  String get amount => 'الكمية';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get analysis => 'تحليل';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'المظهر';

  @override
  String get apply => 'تطبيق';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'تستمر هذه الرؤية حوالي $days يومًا';
  }

  @override
  String get assetsReloadHint =>
      'قد تكون هناك حاجة إلى إعادة تشغيل كاملة للتطبيق لتحميل بعض الأصول.';

  @override
  String get atLeast => 'على الأقل';

  @override
  String get atMost => 'على الأكثر';

  @override
  String get autoBackupSubtitle =>
      'Verilerinizi her 24 saatte bir otomatik olarak Google Drive\'a yedekleyin.';

  @override
  String get autoBackupTitle => 'Otomatik Yedekleme';

  @override
  String get averageMood => 'المزاج المتوسط';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => 'لوحة الخلفية';

  @override
  String get backupError => 'Backup Error';

  @override
  String get backupFailed => 'فشل النسخ الاحتياطي';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String backupSuccess(Object id) {
    return 'تم النسخ الاحتياطي: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get badgeActive100dDesc => 'كن نشطًا في 100 يوم مختلف';

  @override
  String get badgeActive100dTitle => 'نشط لمدة 100 يوم';

  @override
  String get badgeActive30dDesc => 'كن نشطًا في 30 يومًا مختلفًا';

  @override
  String get badgeActive30dTitle => 'نشط لمدة 30 يومًا';

  @override
  String get badgeActive7dDesc => 'كن نشطًا في 7 أيام مختلفة';

  @override
  String get badgeActive7dTitle => 'نشط لمدة 7 أيام';

  @override
  String get badgeCategoryActivity => 'نشاط';

  @override
  String get badgeCategoryFinance => 'المالية';

  @override
  String get badgeCategoryHabit => 'عادة';

  @override
  String get badgeCategoryLevel => 'مستوى';

  @override
  String get badgeCategoryVision => 'رؤية';

  @override
  String get badgeCategoryXp => 'نقاط خبرة';

  @override
  String get badgeFin100Desc => 'تسجيل 100 معاملة';

  @override
  String get badgeFin100Title => 'خبير مالي 100';

  @override
  String get badgeFin10Desc => 'تسجيل 10 معاملات';

  @override
  String get badgeFin10Title => 'خبير مالي 10';

  @override
  String get badgeFin250Desc => 'تسجيل 250 معاملة';

  @override
  String get badgeFin250Title => 'خبير مالي 250';

  @override
  String get badgeFin50Desc => 'تسجيل 50 معاملة';

  @override
  String get badgeFin50Title => 'خبير مالي 50';

  @override
  String get badgeHabit100Desc => 'أكمل 100 عادة في المجموع';

  @override
  String get badgeHabit100Title => 'عادة 100';

  @override
  String get badgeHabit10Desc => 'أكمل 10 عادات في المجموع';

  @override
  String get badgeHabit10Title => 'عادة 10';

  @override
  String get badgeHabit200Desc => 'أكمل 200 عادة في المجموع';

  @override
  String get badgeHabit200Title => 'عادة 200';

  @override
  String get badgeHabit50Desc => 'أكمل 50 عادة في المجموع';

  @override
  String get badgeHabit50Title => 'عادة 50';

  @override
  String get badgeLevel10Desc => 'الوصول إلى المستوى 10';

  @override
  String get badgeLevel10Title => 'المستوى 10';

  @override
  String get badgeLevel20Desc => 'الوصول إلى المستوى 20';

  @override
  String get badgeLevel20Title => 'المستوى 20';

  @override
  String get badgeLevel5Desc => 'الوصول إلى المستوى 5';

  @override
  String get badgeLevel5Title => 'المستوى 5';

  @override
  String get badgeVision10Desc => 'إنشاء 10 رؤى';

  @override
  String get badgeVision10Title => 'سيد الرؤى الكبير';

  @override
  String get badgeVision1Desc => 'أنشئ رؤيتك الأولى';

  @override
  String get badgeVision1Title => 'صاحب رؤية';

  @override
  String get badgeVision5Desc => 'إنشاء 5 رؤى';

  @override
  String get badgeVision5Title => 'سيد الرؤى';

  @override
  String get badgeVisionHabits3Desc => 'ربط 3+ عادات برؤية';

  @override
  String get badgeVisionHabits3Title => 'الرابط';

  @override
  String get badgeXp1000Desc => 'اكسب ما مجموعه 1000 نقطة خبرة';

  @override
  String get badgeXp1000Title => '1000 نقطة خبرة';

  @override
  String get badgeXp500Desc => 'اكسب ما مجموعه 500 نقطة خبرة';

  @override
  String get badgeXp500Title => '500 نقطة خبرة';

  @override
  String get badges => 'الشارات';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => 'بين 1 و 360';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => 'السيرة الذاتية';

  @override
  String get bioHint => 'سيرة ذاتية قصيرة عن نفسك';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => 'استراحة';

  @override
  String get breakdownByCategory => 'التصنيف حسب الفئة';

  @override
  String get bringForward => 'تقديم';

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
  String get cancel => 'إلغاء';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'الفئة';

  @override
  String get categoryName => 'اسم الفئة';

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
  String get chooseBestCategory => 'اختر أفضل فئة لعادتك';

  @override
  String get chooseColor => 'اختر اللون:';

  @override
  String get chooseEmoji => 'اختر الرمز التعبيري:';

  @override
  String get choosePhoto => 'Fotoğraf Seç';

  @override
  String get choosePhotoSubtitle => 'Seni motive eden bir fotoğraf seç';

  @override
  String get choosePhotoDesc => 'Size ilham veren bir fotoğraf seçin';

  @override
  String get clear => 'مسح';

  @override
  String get clearFilters => 'مسح المرشحات';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get close => 'إغلاق';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'İki seçenek arasında karar ver';

  @override
  String get coinFlipInstruction => 'İki seçeneği yaz ve parayı çevir!';

  @override
  String get coinFlipTitle => 'Yazı Tura';

  @override
  String get colorLabel => 'اللون';

  @override
  String get colorTheme => 'مظهر الألوان';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'مكتمل (اليوم المحدد)';

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
  String get countdownConfigureTitle => 'تكوين العد التنازلي';

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
  String get create => 'إنشاء';

  @override
  String get createAdvancedHabit => 'إنشاء عادة متقدمة';

  @override
  String get createDailyTask => 'إنشاء مهمة يومية';

  @override
  String get createFirstHabit => 'Alışkanlık Oluştur';

  @override
  String get createFirstVision => 'İlk Vizyonunuzu Oluşturun';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => 'إنشاء قالب عادة';

  @override
  String get createHabitTitle => 'إنشاء عادة';

  @override
  String get createList => 'إنشاء قائمة';

  @override
  String get createNewCategory => 'إنشاء فئة جديدة';

  @override
  String get createNewList => 'إنشاء قائمة جديدة';

  @override
  String get createVision => 'إنشاء رؤية';

  @override
  String get createVisionTemplateTitle => 'إنشاء قالب رؤية';

  @override
  String get createVisionWithAI => 'Yapay Zeka ile Vizyon Oluştur';

  @override
  String get createWithAi => 'AI ile Oluştur';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get custom => 'مخصص';

  @override
  String get customCategories => 'فئات مخصصة';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => 'مثال: ✨';

  @override
  String get customEmojiOptional => 'رمز تعبيري مخصص (اختياري)';

  @override
  String get customFrequency => 'مخصص';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => 'مثال: حصة، مجموعة، كم...';

  @override
  String get daily => 'يوميًا';

  @override
  String get dailyCheck => 'تحقق يومي';

  @override
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => 'الحد اليومي';

  @override
  String get dailyTask => 'مهمة يومية';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'تم إنشاء المهمة اليومية: $title';
  }

  @override
  String get dailyTasksSection => 'المهام اليومية';

  @override
  String get darkTheme => 'المظهر الداكن';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get date => 'التاريخ';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Cum';

  @override
  String get dayMonShort => 'Pzt';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'اليوم $start–$end';
  }

  @override
  String get daySatShort => 'Cmt';

  @override
  String dayShort(Object day) {
    return 'اليوم $day';
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
    return 'متوسط $days يوم';
  }

  @override
  String daysCount(Object count) {
    return '$count أيام';
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
  String get delete => 'حذف';

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
    return 'حذف الفئة \"$name\"؟';
  }

  @override
  String get deleteCategoryTitle => 'حذف الفئة';

  @override
  String get deleteCustomCategoryConfirm => 'حذف هذه الفئة المخصصة؟';

  @override
  String get deleteEntryConfirm => 'حذف هذا الإدخال؟';

  @override
  String deleteHabitConfirm(Object title) {
    return 'حذف العادة \"$title\"؟';
  }

  @override
  String get deleteListMessage =>
      'سيتم حذف هذه القائمة. اختر ما يجب فعله بالعناصر المرتبطة:';

  @override
  String get deleteListTitle => 'حذف القائمة';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage =>
      'هل تريد حذف هذه المهمة اليومية؟ يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteTaskConfirmTitle => 'حذف المهمة؟';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'حذف السجل \"$title\"؟';
  }

  @override
  String get deleteVisionMessage => 'حذف هذه الرؤية؟';

  @override
  String get deleteVisionTitle => 'حذف الرؤية';

  @override
  String get descHint => 'تفاصيل حول عادتك (اختياري)';

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
  String get difficulty => 'مستوى الصعوبة';

  @override
  String get drinkWater => 'Su İç';

  @override
  String get duration => 'المدة';

  @override
  String get durationAutoLabel => 'المدة (تلقائي)';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => 'اختيار المدة';

  @override
  String get durationType => 'نوع المدة';

  @override
  String get earthTheme => 'الأرض';

  @override
  String get earthThemeDesc => 'ألوان الأرض';

  @override
  String get easy => 'سهل';

  @override
  String get edit => 'تعديل';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get editHabit => 'تعديل العادة';

  @override
  String get editListTitle => 'تعديل القائمة';

  @override
  String get education => 'تعليم';

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
  String get emojiLabel => 'الرمز التعبيري';

  @override
  String get emptyHabitSubtitle =>
      'İlerlemeni takip etmek için ilk alışkanlığını oluştur.';

  @override
  String get emptyHabitTitle => 'Yolculuğuna Başla';

  @override
  String get enableNotifications => 'تمكين الإشعارات';

  @override
  String get enableReminder => 'تمكين التذكير';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => 'يوم الانتهاء (اختياري)';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'أدخل خطة شهرية لحساب الحد اليومي.';

  @override
  String get enterNameAndDesc => 'أدخل اسم عادتك ووصفها';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => 'أدخل القيمة';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get entries => 'الإدخالات';

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
  String get everyNDaysQuestion => 'كل كم يوم؟';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => 'كل يوم';

  @override
  String get exact => 'بالضبط';

  @override
  String get exactAlarmPermission => 'إذن المنبه الدقيق (أندرويد 12+)';

  @override
  String examplePrefix(Object example) {
    return 'مثال: $example';
  }

  @override
  String get expenseDelta => 'فرق المصروفات';

  @override
  String get expenseDistributionPie => 'توزيع المصروفات (دائري)';

  @override
  String get expenseEditTitle => 'تعديل المصروفات';

  @override
  String get expenseLabel => 'المصروفات';

  @override
  String get expenseNewTitle => 'مصروف جديد';

  @override
  String failedToLoad(Object error) {
    return 'فشل التحميل: $error';
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
  String get feelingMoreSpecific => 'هل يمكنك أن تكون أكثر تحديدًا؟';

  @override
  String get filterTitle => 'مرشح';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'المالية';

  @override
  String financeAnalysisTitle(Object month) {
    return 'تحليل مالي · $month';
  }

  @override
  String get financeLast7Days => 'المالية · آخر 7 أيام';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'إنهاء';

  @override
  String get fitness => 'اللياقة البدنية';

  @override
  String get fixedDuration => 'ثابت';

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
  String get font => 'الخط';

  @override
  String get forestTheme => 'الغابة';

  @override
  String get forestThemeDesc => 'مظهر أخضر طبيعي';

  @override
  String get forever => 'إلى الأبد';

  @override
  String get fortuneDisclaimer => 'قراءة الحظ للترفيه فقط';

  @override
  String fortuneEggSemantic(int index) {
    return 'بيضة حظ $index';
  }

  @override
  String get fortuneEggsSubtitle => 'اختر بيضة لتكشف عن حظك';

  @override
  String get fortuneNoQuestion => 'لم تطرح سؤالاً بعد';

  @override
  String get fortunePlay => 'لعب';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => 'ماذا تريد أن تعرف؟';

  @override
  String get fortuneQuestionPrompt => 'اطرح سؤالك';

  @override
  String get fortuneResultTitle => 'حظك';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => 'بيض الحظ';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => 'التكرار';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullScreen => 'ملء الشاشة';

  @override
  String get gallery => 'المعرض';

  @override
  String get gamesDescription =>
      'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!';

  @override
  String get gamesTitle => 'Oyunlar';

  @override
  String get general => 'عام';

  @override
  String get generalNotifications => 'الإشعارات العامة';

  @override
  String get generate => 'Oluştur';

  @override
  String get glasses => 'نظارات';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'ذهبي';

  @override
  String get goldenThemeDesc => 'مظهر ذهبي دافئ';

  @override
  String get goodMorning => 'Günaydın! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'ممنوح';

  @override
  String get greatDayAhead => 'Bugün harika bir gün, başarabilirsin!';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get guestAccount => 'Misafir Hesabı';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

  @override
  String get habit => 'عادة';

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
    return 'تم إنشاء العادة: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'تم حذف العادة: $title';
  }

  @override
  String get habitDescription => 'الوصف';

  @override
  String get habitDescriptionHint => 'أضف وصفاً قصيراً...';

  @override
  String get habitDetails => 'تفاصيل العادة';

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
  String get habitName => 'اسم العادة';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => 'مثال: شرب ماء، قراءة...';

  @override
  String get habitNameHintTimer => 'مثال: تأمل، رياضة...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => 'لم يتم العثور على العادة.';

  @override
  String get habitOfThisVision => 'عادة هذه الرؤية';

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
  String get habitReminders => 'تذكيرات العادات';

  @override
  String get habitRemindersSubtitle => 'تذكيرات يومية لعاداتك';

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
  String get habitUpdatedMessage => 'تم تحديث العادة.';

  @override
  String get habits => 'العادات';

  @override
  String get habitsSection => 'العادات';

  @override
  String get hard => 'صعب';

  @override
  String get hardMode => 'Zor Mod';

  @override
  String get headerFocusLabel => 'تركيز';

  @override
  String get headerFocusReady => 'جاهز';

  @override
  String get headerHabitsLabel => 'عادة';

  @override
  String get health => 'الصحة';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'sa';

  @override
  String get hours => 'ساعات';

  @override
  String get howAreYouFeeling => 'كيف تشعر؟';

  @override
  String get howDoYouFeel => 'Bugün nasıl hissediyorsun?';

  @override
  String get howOftenDoHabit => 'حدد عدد المرات التي ستقوم فيها بعادتك';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => 'كيف تكسب';

  @override
  String get howToTrackHabit => 'اختر كيف سيتم تتبع عادتك';

  @override
  String get ifCondition => 'إذا';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'استيراد من الرابط';

  @override
  String get importantNotice => 'إشعار مهم';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => 'فرق الدخل';

  @override
  String get incomeEditTitle => 'تعديل الدخل';

  @override
  String get incomeLabel => 'الدخل';

  @override
  String get incomeNewTitle => 'دخل جديد';

  @override
  String get incompleteSelectedDay => 'غير مكتمل (اليوم المحدد)';

  @override
  String get input => 'إدخال';

  @override
  String get insights => 'Insights';

  @override
  String get invalidLink => 'رابط غير صالح.';

  @override
  String get invalidValue => 'قيمة غير صالحة';

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
  String get language => 'اللغة';

  @override
  String get languageSelection => 'اختيار اللغة';

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
    return 'المستوى $level';
  }

  @override
  String levelShort(Object level) {
    return 'L$level';
  }

  @override
  String get lightTheme => 'المظهر الفاتح';

  @override
  String get likertAgree => 'أوافق';

  @override
  String get likertDisagree => 'لا أوافق';

  @override
  String get likertNeutral => 'محايد';

  @override
  String get likertStronglyAgree => 'أوافق بشدة';

  @override
  String get likertStronglyDisagree => 'لا أوافق بشدة';

  @override
  String get linkHabits => 'ربط العادات';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'تم إنشاء القائمة: $title';
  }

  @override
  String get listLabel => 'قائمة';

  @override
  String get listNameHint => 'مثال: الصحة';

  @override
  String get listNameLabel => 'اسم القائمة';

  @override
  String get loadingHabits => 'جاري تحميل العادات...';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get longestStreak => 'أطول سلسلة';

  @override
  String get manageLists => 'إدارة القوائم';

  @override
  String get manageListsSubtitle =>
      'إضافة قائمة جديدة أو إعادة تسميتها أو حذفها.';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => 'Manage Subscription';

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
  String get medium => 'متوسط';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'اليقظة';

  @override
  String get mintFresh => 'Taze Nane';

  @override
  String get mintFreshDesc => 'Taze nane ve turkuaz tonları';

  @override
  String get minutes => 'دقائق';

  @override
  String get minutesSuffixShort => 'دقيقة';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Pzt';

  @override
  String get monthCount => 'عدد الأشهر';

  @override
  String get monthCountHint => 'مثال: 12';

  @override
  String get monthSuffixShort => 'شهر';

  @override
  String get monthly => 'شهريًا';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'Ayın belirli günlerinde';

  @override
  String get monthlyProgress => 'التقدم الشهري';

  @override
  String get monthlyTrend => 'الاتجاه الشهري';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => 'المزاج';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => 'سيء';

  @override
  String get moodBadDesc => 'أمر بوقت صعب';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => 'ممتاز';

  @override
  String get moodExcellentDesc => 'أشعر بروعة';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => 'تتبع صحتك العاطفية';

  @override
  String get moodFlowTitle => 'كيف تشعر؟';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodGoodDesc => 'أشعر بإيجابية';

  @override
  String get moodGreat => 'رائع';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodNeutralDesc => 'أشعر أنني بخير';

  @override
  String get moodOk => 'حسنًا';

  @override
  String get moodSelection => 'اختيار المزاج';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => 'فظيع';

  @override
  String get moodTerribleDesc => 'أشعر بسوء شديد';

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
  String get motivation => 'الدافع';

  @override
  String motivationBody(Object percent, Object period) {
    return 'عمل رائع! $period لقد وصلت إلى معدل نجاح $percent٪.';
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
  String get mtdAverageShort => 'متوسط شهري حتى تاريخه';

  @override
  String get multiple => 'متعدد';

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
  String get mysticTheme => 'صوفي';

  @override
  String get mysticThemeDesc => 'مظهر بنفسجي صوفي';

  @override
  String nDaysLabel(Object count) {
    return '$count أيام';
  }

  @override
  String get nameHint => 'مثال: تمرين يومي';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => 'عادات جديدة';

  @override
  String get newList => 'قائمة جديدة';

  @override
  String get next => 'التالي';

  @override
  String get nextLabel => 'التالي';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => 'العام القادم';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noDataLast7Days => 'لا توجد بيانات لآخر 7 أيام';

  @override
  String get noDataThisMonth => 'لا توجد بيانات لهذا الشهر';

  @override
  String get noEndDate => 'لا يوجد تاريخ انتهاء';

  @override
  String get noEndDayDefaultsDaily =>
      'عندما لا يتم تعيين يوم انتهاء ، ستظهر هذه العادة كل يوم بشكل افتراضي.';

  @override
  String get noEntriesYet => 'لا توجد إدخالات حتى الآن';

  @override
  String get noExpenseInThisCategory => 'لا توجد مصروفات في هذه الفئة';

  @override
  String get noExpenses => 'لا توجد مصروفات';

  @override
  String get noExpensesThisMonth => 'لا توجد مصروفات لهذا الشهر';

  @override
  String get noHabitsAddedYet => 'لم تتم إضافة أي عادات بعد.';

  @override
  String get noHistory => 'لا يوجد سجل';

  @override
  String get noIncomeThisMonth => 'لا يوجد دخل لهذا الشهر';

  @override
  String get noItemsMatchFilters => 'لا توجد عناصر تطابق المرشحات المحددة';

  @override
  String get noLinkedHabitsInVision => 'لا توجد عادات مرتبطة بهذه الرؤية.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => 'لم يتم العثور على رؤى جاهزة.';

  @override
  String get noRecordsThisMonth => 'لا توجد سجلات لهذا الشهر';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'لم تتم الإضافة بعد.';

  @override
  String get notGranted => 'غير ممنوح';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'غير مفتوح';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get notificationBehavior => 'سلوك الإشعارات';

  @override
  String get notificationPermission => 'إذن الإشعارات';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notificationSettingsSubtitle =>
      'قم بتكوين تفضيلات الإشعارات الخاصة بك';

  @override
  String get notificationTroubleshooting =>
      'لكي تعمل الإشعارات بشكل صحيح:\n\n• إيقاف تحسين البطارية\n• السماح بالنشاط في الخلفية\n• تأكد من تشغيل أذونات الإشعارات\n• تحقق من وضع \'عدم الإزعاج\'';

  @override
  String get notificationTypes => 'أنواع الإشعارات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsMasterSubtitle => 'التحكم في جميع إشعارات التطبيق';

  @override
  String get numberLabel => 'رقم';

  @override
  String get numericExample => 'اشرب 8 أكواب من الماء يوميًا';

  @override
  String get numericSettings => 'إعدادات الهدف الرقمي';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => 'تتبع الهدف الرقمي';

  @override
  String get numericalGoalShort => 'هدف رقمي';

  @override
  String get numericalType => 'قيمة رقمية';

  @override
  String get oceanTheme => 'المحيط';

  @override
  String get oceanThemeDesc => 'مظهر أزرق هادئ';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'موافق';

  @override
  String get onDailyLimit => 'لقد وصلت إلى الحد اليومي.';

  @override
  String get onPeriodic => 'على فترات محددة';

  @override
  String get onSpecificMonthDays => 'في أيام محددة من الشهر';

  @override
  String get onSpecificWeekdays => 'في أيام محددة من الأسبوع';

  @override
  String get onSpecificYearDays => 'في أيام محددة من السنة';

  @override
  String get onboardingQ1 =>
      'أستمتع بتجربة تجارب جديدة واستكشاف أمور غير مألوفة.';

  @override
  String get onboardingQ10 => 'أخطط مسبقًا للأحداث والمهام المهمة.';

  @override
  String get onboardingQ11 =>
      'أُفضّل تجربة أساليب مختلفة بدل الالتزام بطريقة واحدة.';

  @override
  String get onboardingQ12 =>
      'أحافظ على هدوئي تحت الضغط وأتعافى سريعًا من الإخفاقات.';

  @override
  String get onboardingQ2 =>
      'أحافظ على تنظيم مكاني وأُفضّل روتينًا يوميًا منظّمًا.';

  @override
  String get onboardingQ3 =>
      'أشعر بالطاقة عند وجودي مع الآخرين وأستمتع بالتجمعات الاجتماعية.';

  @override
  String get onboardingQ4 =>
      'أفضل العمل مع الآخرين وأرى أن التعاون أكثر فعالية من المنافسة.';

  @override
  String get onboardingQ5 =>
      'أتعامل بهدوء مع المواقف المجهدة ونادرًا ما أشعر بالقلق.';

  @override
  String get onboardingQ6 =>
      'أستمتع بالأنشطة الإبداعية مثل الفن أو الموسيقى أو الكتابة.';

  @override
  String get onboardingQ7 => 'أضع أهدافًا واضحة لنفسي وأعمل بجد لتحقيقها.';

  @override
  String get onboardingQ8 => 'أفضل الأنشطة الجماعية على قضاء الوقت بمفردي.';

  @override
  String get onboardingQ9 =>
      'غالبًا ما أضع مشاعر الآخرين في الحسبان قبل اتخاذ القرارات.';

  @override
  String get onboardingQuizIntro =>
      'أجب عن بعض الأسئلة لمساعدتنا على فهم شخصيتك بشكل أفضل. يعتمد هذا على أبحاث نفسية مثبتة علميًا.';

  @override
  String get onboardingWelcomeDesc =>
      'متعقب العادات الشخصي الذي ينمو معك. لنكتشف شخصيتك الفريدة ونقترح عادات مصممة خصيصًا لك.';

  @override
  String get onboardingWelcomeTitle => 'مرحبًا بك في ميرا';

  @override
  String get once => 'مرة واحدة';

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
  String get other => 'أخرى';

  @override
  String get outline => 'مخطط تفصيلي';

  @override
  String get outlineColor => 'لون المخطط التفصيلي';

  @override
  String get overall => 'بشكل عام';

  @override
  String get overallProgress => 'التقدم العام';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'صفحات';

  @override
  String get pastelColors => 'ألوان باستيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => 'دوري';

  @override
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => 'اختيار دوري';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => 'اختر مزاج اليوم';

  @override
  String get plannedMonthlySpend => 'الإنفاق الشهري المخطط له';

  @override
  String plansLoadError(Object error) {
    return 'خطأ في تحميل الخطط: $error';
  }

  @override
  String get plateColor => 'لون اللوحة';

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
  String get previous => 'السابق';

  @override
  String get previousYear => 'العام السابق';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => 'الإنتاجية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileInfo => 'معلومات الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

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
  String get readyVisionsLoadFailed => 'تعذر تحميل الرؤى الجاهزة.';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'الصحة';

  @override
  String get reasonOther => 'آخر';

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
  String get reasonWork => 'العمل';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc => 'إضافة تلقائية كل شهر في التاريخ المحدد';

  @override
  String get recurringMonthlyTitle => 'متكرر (شهريًا)';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => 'إعادة تحميل';

  @override
  String get remainingToday => 'المتبقي اليوم';

  @override
  String get reminder => 'تذكير';

  @override
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

  @override
  String get reminderFrequency => 'تكرار التذكير';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'إعدادات التذكير';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get removeFromList => 'إزالة من القائمة';

  @override
  String get repeatEveryDay => 'يتكرر كل يوم';

  @override
  String get repeatEveryNDays => 'تكرار كل N يوم';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reset => 'إعادة تعيين';

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
  String get restoreFailed => 'فشل الاستعادة';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'تم التنزيل: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'القاعدة: المدة المدخلة ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'القاعدة: المدة المدخلة ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'القاعدة: المدة المدخلة = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'القاعدة: القيمة المدخلة ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'القاعدة: القيمة المدخلة ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'القاعدة: القيمة المدخلة = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get save => 'حفظ';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => 'خطة الادخار / الميزانية';

  @override
  String get scheduleHabit => 'حدد جدول عادتك';

  @override
  String get scheduleLabel => 'الجدول الزمني';

  @override
  String get schedulingOptions => 'خيارات الجدولة';

  @override
  String get seconds => 'ثواني';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => 'تحديد';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get selectCategory => 'تحديد الفئة';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectAtLeastOneDay => 'Lütfen en az bir gün seçin';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'تحديد تاريخ الانتهاء';

  @override
  String get selectFrequency => 'تحديد التكرار';

  @override
  String get selectHabitType => 'تحديد نوع العادة';

  @override
  String get selectHabitsToAdd =>
      'اختر العادات التي ترغب في إضافتها إلى روتينك اليومي:';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc => 'اختر ما يؤثر على مزاجك';

  @override
  String get selectSubEmotion => 'اختر عاطفة فرعية';

  @override
  String get selectSubEmotionDesc => 'اختر عاطفة أكثر تحديدًا';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get selectYourCurrentMood => 'اختر مزاجك الحالي';

  @override
  String get selectYourMood => 'اختر مزاجك';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => 'إرسال إلى الخلف';

  @override
  String get setVisionTimeline =>
      'Vizyonunuz için zaman çizelgesini belirleyin';

  @override
  String get settings => 'الإعدادات';

  @override
  String get shareAsLink => 'مشاركة كرابط';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied => 'تم نسخ رابط المشاركة إلى الحافظة.';

  @override
  String get shareVision => 'مشاركة الرؤية';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'خلط';

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
  String get simpleHabitTargetOne => 'عادة بسيطة (الهدف = 1)';

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
  String get simpleTypeShort => 'بسيط';

  @override
  String get skip => 'تخطي';

  @override
  String get skipOnboarding => 'تخطي';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => 'اجتماعي';

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
  String get sound => 'الصوت';

  @override
  String get soundAlerts => 'التنبيهات الصوتية';

  @override
  String get soundSubtitle => 'تشغيل الصوت مع الإشعارات';

  @override
  String get specificDaysOfMonth => 'أيام محددة من الشهر';

  @override
  String get specificDaysOfWeek => 'أيام محددة من الأسبوع';

  @override
  String get specificDaysOfYear => 'أيام محددة من السنة';

  @override
  String get spendingAdvisorNoBudget => 'حدد ميزانية للحصول على المشورة.';

  @override
  String get spendingAdvisorOnTrack =>
      'رائع! أنت تسير على الطريق الصحيح مع ميزانيتك.';

  @override
  String get spendingAdvisorOverBudget =>
      'لقد تجاوزت الميزانية. توقف عن الإنفاق.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'يمكنك إنفاق $amount يوميًا.';
  }

  @override
  String get spendingAdvisorTitle => 'مستشار الإنفاق';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'قلل الإنفاق اليومي بمقدار $amount للبقاء في المسار الصحيح.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'رائع! أنت تنفق $amount أقل من المتوسط اليومي.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'تحذير! أنت تنفق $amount أكثر من المتوسط اليومي.';
  }

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get start => 'بدء';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => 'يوم البدء (1-365)';

  @override
  String get startJourney => 'ابدأ رحلتك';

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
  String get statusLabel => 'الحالة';

  @override
  String get step => 'خطوة';

  @override
  String stepOf(Object current, Object total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get steps => 'خطوات';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return 'سلسلة $count يوم';
  }

  @override
  String get streakIndicator => 'مؤشر السلسلة';

  @override
  String get streakIndicatorDesc => 'إظهار تأثيرات اللهب والجليد';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => 'غاضب';

  @override
  String get subEmotionAnxious => 'قلق';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => 'هادئ';

  @override
  String get subEmotionCheerful => 'مبتهج';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => 'محبط';

  @override
  String get subEmotionDetermined => 'مُصمم';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => 'مستنزف';

  @override
  String get subEmotionEmpty => 'فارغ';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'متلهف';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => 'متحمس';

  @override
  String get subEmotionExhausted => 'منهك';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => 'سعيد';

  @override
  String get subEmotionHelpless => 'عاجز';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => 'يائس';

  @override
  String get subEmotionHurt => 'مجروح';

  @override
  String get subEmotionIndecisive => 'مُحتار';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'محفز';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => 'عادي';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'فخور';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => 'حزين';

  @override
  String get subEmotionSelection => 'اختيار العاطفة الفرعية';

  @override
  String get subEmotionStressed => 'متوتر';

  @override
  String get subEmotionTired => 'متعب';

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
  String get success => 'نجاح';

  @override
  String get successfulDayLegend => 'يوم ناجح';

  @override
  String successfulDaysCount(Object count) {
    return '$count أيام ناجحة';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'معلومات النظام';

  @override
  String get systemTheme => 'مظهر النظام';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

  @override
  String get target => 'الهدف';

  @override
  String get targetDurationMinutes => 'المدة المستهدفة (دقائق)';

  @override
  String targetShort(Object value) {
    return 'الهدف: $value';
  }

  @override
  String get targetType => 'نوع الهدف';

  @override
  String get targetValue => 'القيمة المستهدفة';

  @override
  String get targetValueLabel => 'القيمة المستهدفة';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'تم حذف المهمة: $title';
  }

  @override
  String get taskDescription => 'الوصف (اختياري)';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'عنوان المهمة';

  @override
  String get taskTitleRequired => 'عنوان المهمة مطلوب';

  @override
  String get tellMeYourDream =>
      'Hayalini anlat. Vizyon Panosu oluşturmana yardım edeyim.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'لم يتم العثور على تفاصيل القالب';

  @override
  String get templatesTabManual => 'يدوي';

  @override
  String get templatesTabReady => 'جاهز';

  @override
  String get textLabel => 'نص';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'المظهر';

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
  String get themeDetails => 'تفاصيل المظهر';

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
  String get themeSelection => 'اختيار المظهر';

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
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get thursdayShort => 'Per';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst => 'أنشئ عادة مؤقت أولاً';

  @override
  String get timerDescription => 'تتبع قائم على الوقت';

  @override
  String get timerExample => 'قم بتمرين لمدة 30 دقيقة';

  @override
  String get timerHabitLabel => 'عادة المؤقت';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'المدة المعلقة: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'معلق: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'استراحة';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'العمل المكتمل: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'دورة الاستراحة الطويلة (على سبيل المثال ، 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'استراحة طويلة (دقيقة)';

  @override
  String get timerPomodoroSettings => 'إعدادات بومودورو';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'استراحة قصيرة (دقيقة)';

  @override
  String get timerPomodoroSkipPhase => 'تخطي المرحلة';

  @override
  String get timerPomodoroWorkMinutesLabel => 'العمل (دقيقة)';

  @override
  String get timerPomodoroWorkPhase => 'العمل';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => 'حفظ المدة';

  @override
  String get timerSaveSessionTitle => 'حفظ الجلسة';

  @override
  String get timerSessionAlreadySaved => 'تم حفظ هذه الجلسة بالفعل';

  @override
  String get timerSetDurationFirst => 'حدد المدة أولاً';

  @override
  String get timerSettings => 'إعدادات المؤقت';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'العد التنازلي';

  @override
  String get timerTabPomodoro => 'بومودورو';

  @override
  String get timerTabStopwatch => 'ساعة توقيت';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'مؤقت';

  @override
  String get times => 'مرات';

  @override
  String get timezone => 'المنطقة الزمنية';

  @override
  String get titleHint => 'مثال: البقالة ، العمل الحر ، إلخ.';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'المدة الإجمالية';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => 'التقدم الإجمالي';

  @override
  String get totalSuccessfulDays => 'إجمالي الأيام الناجحة';

  @override
  String get totalUnsuccessfulDays => 'إجمالي الأيام غير الناجحة';

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
  String get typeLabel => 'النوع';

  @override
  String get typeNotChangeable => 'لا يمكن تغيير النوع';

  @override
  String get unassignLinkedDailyTasks => 'إلغاء تعيين المهام اليومية المرتبطة';

  @override
  String get unassignLinkedHabits => 'إلغاء تعيين العادات المرتبطة';

  @override
  String get undo => 'تراجع';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => 'الوحدة';

  @override
  String get unitAdet => 'قطعة';

  @override
  String get unitAdim => 'خطوة';

  @override
  String get unitBardak => 'كوب';

  @override
  String get unitHint => 'وحدة (كوب ، خطوة ، صفحة ...)';

  @override
  String get unitKalori => 'سعرة';

  @override
  String get unitKez => 'مرات';

  @override
  String get unitKm => 'كم';

  @override
  String get unitLitre => 'لتر';

  @override
  String get unitSayfa => 'صفحة';

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
  String get update => 'تحديث';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => 'القيمة';

  @override
  String get vibration => 'الاهتزاز';

  @override
  String get vibrationSubtitle => 'الاهتزاز مع الإشعارات';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'الرؤية';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'ستستخدم هذه الرؤية آخر يوم في القالب: $day.';
  }

  @override
  String get visionBoard => 'Vizyon Panosu';

  @override
  String get visionBoardDesc =>
      'Hedeflerinizi organize etmek ve yolculuğunuzu takip etmek için bir vizyon oluşturun';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'إنشاء رؤية';

  @override
  String get visionDurationDaysLabel => 'المدة (أيام)';

  @override
  String get visionDurationNote =>
      'ملاحظة: عند بدء الرؤية ، يتم تعيين مدة إجمالية ؛ إذا تجاوز يوم الانتهاء هذه المدة ، فسيتم تقصيرها تلقائيًا.';

  @override
  String get visionEditTitle => 'تعديل الرؤية';

  @override
  String get visionEmptyDescription =>
      'Hedeflerinizi görselleştirin ve hayallerinizi gerçeğe dönüştürmek için ilk vizyonunuzu ekleyin.';

  @override
  String get visionEndDayInvalid => 'يجب أن يكون يوم الانتهاء بين 1 و 365';

  @override
  String get visionEndDayLess =>
      'لا يمكن أن يكون يوم الانتهاء أقل من يوم البدء';

  @override
  String get visionEndDayQuestion => 'في أي يوم من الرؤية يجب أن تنتهي؟';

  @override
  String get visionEndDayRequired => 'أدخل يوم الانتهاء';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo =>
      'لم يتم تحديد يوم انتهاء. ستبدأ الرؤية مفتوحة.';

  @override
  String get visionPlural => 'الرؤى';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid => 'يجب أن يكون يوم البدء بين 1 و 365';

  @override
  String get visionStartDayQuestion => 'في أي يوم من الرؤية يجب أن تبدأ؟';

  @override
  String get visionStartFailed => 'تعذر بدء الرؤية.';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'بدأت الرؤية: $title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => 'مرئي';

  @override
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => 'الجمعة';

  @override
  String get weekdaysShortMon => 'الاثنين';

  @override
  String get weekdaysShortSat => 'السبت';

  @override
  String get weekdaysShortSun => 'الأحد';

  @override
  String get weekdaysShortThu => 'الخميس';

  @override
  String get weekdaysShortTue => 'الثلاثاء';

  @override
  String get weekdaysShortWed => 'الأربعاء';

  @override
  String get weekly => 'أسبوعيًا';

  @override
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => 'ملخص البريد الإلكتروني الأسبوعي';

  @override
  String get weeklyProgress => 'التقدم الأسبوعي';

  @override
  String get weeklySummaryEmail => 'ملخص البريد الإلكتروني الأسبوعي';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => 'ما السبب؟';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => 'ما هي الأيام التي يجب أن تكون نشطة؟';

  @override
  String get whichWeekdays => 'ما هي أيام الأسبوع؟';

  @override
  String get worldTheme => 'العالم';

  @override
  String get worldThemeDesc => 'انسجام جميع الألوان';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total نقطة خبرة • $toNext نقطة خبرة إلى المستوى التالي';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get yearly => 'سنويًا';

  @override
  String get yearlyProgress => 'التقدم السنوي';

  @override
  String get yesNoDescription => 'تتبع بسيط بنعم / لا';

  @override
  String get yesNoExample => 'هل تأملت اليوم؟';

  @override
  String get yesNoType => 'نعم / لا';

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
  String get whichMonthDays => 'ما هي أيام الشهر؟';

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
  String get rhythmTeaserTitle => 'عزز عاداتك بناءً على ساعتك البيولوجية';

  @override
  String get rhythmTeaserSubtitle =>
      'يتعلم الإيقاع الحي أكثر لحظاتك إنتاجية ويضع العادات في الوقت المناسب.';

  @override
  String get rhythmTeaserSkip => 'تخطي';

  @override
  String get rhythmTeaserCta => 'عرض الباقات';

  @override
  String get rhythmWindowFocus => 'وقت التركيز';

  @override
  String get rhythmWindowFocusDesc => 'الوضوح الذهني، التعلم، التحليل';

  @override
  String get rhythmWindowEnergy => 'وقت الطاقة';

  @override
  String get rhythmWindowEnergyDesc => 'الحركة، العمل، الرياضة';

  @override
  String get rhythmWindowLight => 'الوقت الخفيف';

  @override
  String get rhythmWindowLightDesc => 'جهد منخفض، مهام صغيرة';

  @override
  String get rhythmWindowReflection => 'وقت التأمل';

  @override
  String get rhythmWindowReflectionDesc => 'كتابة اليوميات، التأمل، الختام';

  @override
  String get rhythmBenefit1 => 'المهمة الصحيحة في الوقت الصحيح';

  @override
  String get rhythmBenefit2 => 'لا إرهاق في اتخاذ القرار';

  @override
  String get rhythmBenefit3 => 'تخصيص كل أسبوع';

  @override
  String get rhythmAnalyzing => 'الإيقاع الحي يحلل...';

  @override
  String get rhythmDisclaimer =>
      'هذه ليست نتائج نهائية. سيتكيف الإيقاع الحي كلما تعرف عليك.';

  @override
  String get rhythmQ1 => 'متى تذهب للنوم عادة؟';

  @override
  String get rhythmQ2 => 'متى تستيقظ عادة؟';

  @override
  String get rhythmQ3 => 'متى تتعامل مع المهام الصعبة بأريحية أكبر؟';

  @override
  String get rhythmQ4 => 'متى تشعر بأعلى صفاء ذهني للتعلم؟';

  @override
  String get rhythmQ5 => 'في أي جزء من اليوم تشعر بمزيد من الطاقة؟';

  @override
  String get rhythmA1_1 => '22:00 – 23:00';

  @override
  String get rhythmA1_2 => '23:00 – 00:00';

  @override
  String get rhythmA1_3 => '00:00 – 01:00';

  @override
  String get rhythmA1_4 => '+01:00';

  @override
  String get rhythmA1_5 => '11:00 – 12:00';

  @override
  String get rhythmA2_1 => '06:00 – 07:00';

  @override
  String get rhythmA2_2 => '07:00 – 08:00';

  @override
  String get rhythmA2_3 => '08:00 – 09:00';

  @override
  String get rhythmA2_4 => '+09:00';

  @override
  String get rhythmA3_1 => 'الصباح الباكر';

  @override
  String get rhythmA3_2 => 'منتصف الصباح';

  @override
  String get rhythmA3_3 => 'بعد الظهر';

  @override
  String get rhythmA3_4 => 'المساء';

  @override
  String get rhythmA3_5 => 'لا فرق';

  @override
  String get rhythmA4_1 => 'الصباح';

  @override
  String get rhythmA4_2 => 'الظهر';

  @override
  String get rhythmA4_3 => 'المساء';

  @override
  String get rhythmA4_4 => 'الليل';

  @override
  String get rhythmA4_5 => 'يتغير';

  @override
  String get rhythmA5_1 => 'الصباح';

  @override
  String get rhythmA5_2 => 'الظهر';

  @override
  String get rhythmA5_3 => 'المساء';

  @override
  String get rhythmA5_4 => 'لا شيء';

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
  String get testsSection => 'الاختبارات';

  @override
  String get retakePersonalityTestDesc => 'أعد اكتشاف نوع شخصيتك';

  @override
  String get retakeRhythmTest => 'إعادة اختبار الإيقاع';

  @override
  String get retakeRhythmTestDesc => 'أعد تكوين ساعتك البيولوجية';

  @override
  String get rhythmWindowStepTitle => 'أفضل نافذة زمنية';

  @override
  String get rhythmWindowStepSubtitle => 'متى تريد ممارسة هذه العادة؟';

  @override
  String get rhythmWindowNoProfileHint =>
      'أكمل اختبار الإيقاع للحصول على اقتراحات مخصصة';

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
