// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get about => 'について';

  @override
  String get account => 'アカウント';

  @override
  String get achievements => '成果';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'アクティブな日数';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => '追加';

  @override
  String get addDate => '日付を追加';

  @override
  String get addFirstTransaction => 'İlk işlemi ekle';

  @override
  String get addHabit => '習慣を追加';

  @override
  String get addImage => '画像を追加';

  @override
  String get addNew => '新規追加';

  @override
  String get addNewHabit => '新しい習慣を追加';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Başlamak için seçenek ekle';

  @override
  String get addSpecialDays => '特別な日を追加';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get addText => 'テキストを追加';

  @override
  String get addToList => 'リストに追加';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => '高度な習慣';

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
  String get allLabel => 'すべて';

  @override
  String get alsoDeleteLinkedHabits => 'リンクされた習慣も削除する';

  @override
  String get amount => '量';

  @override
  String get amountLabel => '金額';

  @override
  String get analysis => '分析';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => '外観';

  @override
  String get apply => '適用';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'このビジョンは約$days日間続きます';
  }

  @override
  String get assetsReloadHint => '一部のアセットを読み込むには、アプリの完全な再起動が必要な場合があります。';

  @override
  String get atLeast => '以上';

  @override
  String get atMost => '以下';

  @override
  String get autoBackupSubtitle =>
      'Verilerinizi her 24 saatte bir otomatik olarak Google Drive\'a yedekleyin.';

  @override
  String get autoBackupTitle => 'Otomatik Yedekleme';

  @override
  String get averageMood => '平均的な気分';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => '背景プレート';

  @override
  String get backupError => 'Backup Error';

  @override
  String get backupFailed => 'バックアップに失敗しました';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String backupSuccess(Object id) {
    return 'バックアップ完了: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get badgeActive100dDesc => '100日間アクティブであること';

  @override
  String get badgeActive100dTitle => '100日間のアクティビティ';

  @override
  String get badgeActive30dDesc => '30日間アクティブであること';

  @override
  String get badgeActive30dTitle => '30日間のアクティビティ';

  @override
  String get badgeActive7dDesc => '7日間アクティブであること';

  @override
  String get badgeActive7dTitle => '7日間のアクティビティ';

  @override
  String get badgeCategoryActivity => 'アクティビティ';

  @override
  String get badgeCategoryFinance => 'ファイナンス';

  @override
  String get badgeCategoryHabit => '習慣';

  @override
  String get badgeCategoryLevel => 'レベル';

  @override
  String get badgeCategoryVision => 'ビジョン';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => '100件の取引を記録する';

  @override
  String get badgeFin100Title => 'フィナンシェ100';

  @override
  String get badgeFin10Desc => '10件の取引を記録する';

  @override
  String get badgeFin10Title => 'フィナンシェ10';

  @override
  String get badgeFin250Desc => '250件の取引を記録する';

  @override
  String get badgeFin250Title => 'フィナンシェ250';

  @override
  String get badgeFin50Desc => '50件の取引を記録する';

  @override
  String get badgeFin50Title => 'フィナンシェ50';

  @override
  String get badgeHabit100Desc => '合計100個の習慣を完了する';

  @override
  String get badgeHabit100Title => '習慣100';

  @override
  String get badgeHabit10Desc => '合計10個の習慣を完了する';

  @override
  String get badgeHabit10Title => '習慣10';

  @override
  String get badgeHabit200Desc => '合計200個の習慣を完了する';

  @override
  String get badgeHabit200Title => '習慣200';

  @override
  String get badgeHabit50Desc => '合計50個の習慣を完了する';

  @override
  String get badgeHabit50Title => '習慣50';

  @override
  String get badgeLevel10Desc => 'レベル10に到達';

  @override
  String get badgeLevel10Title => 'レベル10';

  @override
  String get badgeLevel20Desc => 'レベル20に到達';

  @override
  String get badgeLevel20Title => 'レベル20';

  @override
  String get badgeLevel5Desc => 'レベル5に到達';

  @override
  String get badgeLevel5Title => 'レベル5';

  @override
  String get badgeVision10Desc => '10個のビジョンを作成する';

  @override
  String get badgeVision10Title => 'ビジョングランドマスター';

  @override
  String get badgeVision1Desc => '最初のビジョンを作成する';

  @override
  String get badgeVision1Title => 'ビジョナリー';

  @override
  String get badgeVision5Desc => '5個のビジョンを作成する';

  @override
  String get badgeVision5Title => 'ビジョンマスター';

  @override
  String get badgeVisionHabits3Desc => '3つ以上の習慣をビジョンにリンクする';

  @override
  String get badgeVisionHabits3Title => 'コネクター';

  @override
  String get badgeXp1000Desc => '合計1000 XPを獲得';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => '合計500 XPを獲得';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => 'バッジ';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => '1から360の間';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => '経歴';

  @override
  String get bioHint => 'あなたについての短い経歴';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => '休憩';

  @override
  String get breakdownByCategory => 'カテゴリ別の内訳';

  @override
  String get bringForward => '前面へ移動';

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
  String get cancel => 'キャンセル';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'カテゴリ';

  @override
  String get categoryName => 'カテゴリ名';

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
  String get chooseBestCategory => 'あなたの習慣に最適なカテゴリを選択してください';

  @override
  String get chooseColor => '色を選択:';

  @override
  String get chooseEmoji => '絵文字を選択:';

  @override
  String get choosePhoto => 'Fotoğraf Seç';

  @override
  String get choosePhotoSubtitle => 'Seni motive eden bir fotoğraf seç';

  @override
  String get choosePhotoDesc => 'Size ilham veren bir fotoğraf seçin';

  @override
  String get clear => 'クリア';

  @override
  String get clearFilters => 'フィルターをクリア';

  @override
  String get clearHistory => '履歴をクリア';

  @override
  String get close => '閉じる';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'İki seçenek arasında karar ver';

  @override
  String get coinFlipInstruction => 'İki seçeneği yaz ve parayı çevir!';

  @override
  String get coinFlipTitle => 'Yazı Tura';

  @override
  String get colorLabel => '色';

  @override
  String get colorTheme => 'カラーテーマ';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => '完了（選択日）';

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
  String get countdownConfigureTitle => 'カウントダウンを設定';

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
  String get create => '作成';

  @override
  String get createAdvancedHabit => '高度な習慣を作成';

  @override
  String get createDailyTask => '日課を作成';

  @override
  String get createFirstHabit => 'Alışkanlık Oluştur';

  @override
  String get createFirstVision => 'İlk Vizyonunuzu Oluşturun';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => '習慣テンプレートを作成';

  @override
  String get createHabitTitle => '習慣を作成';

  @override
  String get createList => 'リストを作成';

  @override
  String get createNewCategory => '新しいカテゴリを作成';

  @override
  String get createNewList => '新しいリストを作成';

  @override
  String get createVision => 'ビジョンを作成';

  @override
  String get createVisionTemplateTitle => 'ビジョンテンプレートを作成';

  @override
  String get createVisionWithAI => 'Yapay Zeka ile Vizyon Oluştur';

  @override
  String get createWithAi => 'AI ile Oluştur';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => '現在の連続記録';

  @override
  String get custom => 'カスタム';

  @override
  String get customCategories => 'カスタムカテゴリ';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => '例: ✨';

  @override
  String get customEmojiOptional => 'カスタム絵文字（任意）';

  @override
  String get customFrequency => 'カスタム';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => '例：ポーション、セット、km...';

  @override
  String get daily => '毎日';

  @override
  String get dailyCheck => '毎日のチェック';

  @override
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => '1日の制限';

  @override
  String get dailyTask => '日課';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return '日課が作成されました: $title';
  }

  @override
  String get dailyTasksSection => '日課';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get date => '日付';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Cum';

  @override
  String get dayMonShort => 'Pzt';

  @override
  String dayRangeShort(Object end, Object start) {
    return '$start日目～$end日目';
  }

  @override
  String get daySatShort => 'Cmt';

  @override
  String dayShort(Object day) {
    return '$day日目';
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
    return '$days日平均';
  }

  @override
  String daysCount(Object count) {
    return '$count日間';
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
  String get delete => '削除';

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
    return 'カテゴリ「$name」を削除しますか？';
  }

  @override
  String get deleteCategoryTitle => 'カテゴリを削除';

  @override
  String get deleteCustomCategoryConfirm => 'このカスタムカテゴリを削除しますか？';

  @override
  String get deleteEntryConfirm => 'このエントリを削除しますか？';

  @override
  String deleteHabitConfirm(Object title) {
    return '習慣「$title」を削除しますか？';
  }

  @override
  String get deleteListMessage => 'このリストは削除されます。リンクされたアイテムの処理を選択してください:';

  @override
  String get deleteListTitle => 'リストを削除';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage => 'この日課を削除しますか？この操作は元に戻すことができます。';

  @override
  String get deleteTaskConfirmTitle => 'タスクを削除しますか？';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'レコード「$title」を削除しますか？';
  }

  @override
  String get deleteVisionMessage => 'このビジョンを削除しますか？';

  @override
  String get deleteVisionTitle => 'ビジョンを削除';

  @override
  String get descHint => 'あなたの習慣に関する詳細（任意）';

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
  String get difficulty => '難易度';

  @override
  String get drinkWater => 'Su İç';

  @override
  String get duration => '期間';

  @override
  String get durationAutoLabel => '期間（自動）';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => '期間の選択';

  @override
  String get durationType => '期間タイプ';

  @override
  String get earthTheme => 'アース';

  @override
  String get earthThemeDesc => '大地の色';

  @override
  String get easy => '簡単';

  @override
  String get edit => '編集';

  @override
  String get editCategory => 'カテゴリを編集';

  @override
  String get editHabit => '習慣を編集';

  @override
  String get editListTitle => 'リストを編集';

  @override
  String get education => '教育';

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
  String get emojiLabel => '絵文字';

  @override
  String get emptyHabitSubtitle =>
      'İlerlemeni takip etmek için ilk alışkanlığını oluştur.';

  @override
  String get emptyHabitTitle => 'Yolculuğuna Başla';

  @override
  String get enableNotifications => '通知を有効にする';

  @override
  String get enableReminder => 'リマインダーを有効にする';

  @override
  String get endDate => '終了日';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => '終了日（任意）';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      '1日の制限を計算するために月間プランを入力してください。';

  @override
  String get enterNameAndDesc => '習慣の名前と説明を入力してください';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => '値を入力';

  @override
  String get enterYourName => 'あなたの名前を入力してください';

  @override
  String get entries => 'エントリ';

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
  String get everyNDaysQuestion => '何日ごとですか？';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => '毎日';

  @override
  String get exact => '正確';

  @override
  String get exactAlarmPermission => '正確なアラームの許可（Android 12以降）';

  @override
  String examplePrefix(Object example) {
    return '例: $example';
  }

  @override
  String get expenseDelta => '支出Δ';

  @override
  String get expenseDistributionPie => '支出分布（円グラフ）';

  @override
  String get expenseEditTitle => '支出を編集';

  @override
  String get expenseLabel => '支出';

  @override
  String get expenseNewTitle => '新しい支出';

  @override
  String failedToLoad(Object error) {
    return '読み込みに失敗しました: $error';
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
  String get feelingMoreSpecific => 'もう少し具体的に教えてください';

  @override
  String get filterTitle => 'フィルター';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'ファイナンス';

  @override
  String financeAnalysisTitle(Object month) {
    return '財務分析・$month';
  }

  @override
  String get financeLast7Days => '財務・過去7日間';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => '完了';

  @override
  String get fitness => 'フィットネス';

  @override
  String get fixedDuration => '固定';

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
  String get font => 'フォント';

  @override
  String get forestTheme => 'フォレスト';

  @override
  String get forestThemeDesc => '自然な緑のテーマ';

  @override
  String get forever => '無期限';

  @override
  String get fortuneDisclaimer => '占いはエンターテインメント目的のみです';

  @override
  String fortuneEggSemantic(int index) {
    return '運勢たまご $index';
  }

  @override
  String get fortuneEggsSubtitle => 'たまごを選んで運勢を見る';

  @override
  String get fortuneNoQuestion => 'まだ質問をしていません';

  @override
  String get fortunePlay => '遊ぶ';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => '何を知りたいですか？';

  @override
  String get fortuneQuestionPrompt => '質問を入力してください';

  @override
  String get fortuneResultTitle => 'あなたの運勢';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => '運勢たまご';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => '頻度';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'フルネーム';

  @override
  String get fullScreen => '全画面';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get gamesDescription =>
      'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!';

  @override
  String get gamesTitle => 'Oyunlar';

  @override
  String get general => '一般';

  @override
  String get generalNotifications => '一般通知';

  @override
  String get generate => 'Oluştur';

  @override
  String get glasses => 'グラス';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'ゴールデン';

  @override
  String get goldenThemeDesc => '暖かい金色のテーマ';

  @override
  String get goodMorning => 'Günaydın! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => '許可済み';

  @override
  String get greatDayAhead => 'Bugün harika bir gün, başarabilirsin!';

  @override
  String get greetingAfternoon => 'こんにちは';

  @override
  String get greetingEvening => 'こんばんは';

  @override
  String get greetingMorning => 'おはようございます';

  @override
  String get guestAccount => 'Misafir Hesabı';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

  @override
  String get habit => '習慣';

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
    return '習慣が作成されました: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return '習慣が削除されました: $title';
  }

  @override
  String get habitDescription => '説明';

  @override
  String get habitDescriptionHint => '短い説明を追加...';

  @override
  String get habitDetails => '習慣の詳細';

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
  String get habitName => '習慣名';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => '例：水を飲む、読書...';

  @override
  String get habitNameHintTimer => '例：瞑想、運動...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => '習慣が見つかりません。';

  @override
  String get habitOfThisVision => 'このビジョンの習慣';

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
  String get habitReminders => '習慣のリマインダー';

  @override
  String get habitRemindersSubtitle => '習慣の毎日のリマインダー';

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
  String get habitUpdatedMessage => '習慣が更新されました。';

  @override
  String get habits => '習慣';

  @override
  String get habitsSection => '習慣';

  @override
  String get hard => '難しい';

  @override
  String get hardMode => 'Zor Mod';

  @override
  String get headerFocusLabel => '集中';

  @override
  String get headerFocusReady => '準備完了';

  @override
  String get headerHabitsLabel => '習慣';

  @override
  String get health => '健康';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'sa';

  @override
  String get hours => '時間';

  @override
  String get howAreYouFeeling => '気分はいかがですか？';

  @override
  String get howDoYouFeel => 'Bugün nasıl hissediyorsun?';

  @override
  String get howOftenDoHabit => '習慣をどのくらいの頻度で行うか決めてください';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => '獲得方法';

  @override
  String get howToTrackHabit => '習慣をどのように追跡するかを選択します';

  @override
  String get ifCondition => 'もし';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'リンクからインポート';

  @override
  String get importantNotice => '重要なお知らせ';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => '収入Δ';

  @override
  String get incomeEditTitle => '収入を編集';

  @override
  String get incomeLabel => '収入';

  @override
  String get incomeNewTitle => '新しい収入';

  @override
  String get incompleteSelectedDay => '未完了（選択日）';

  @override
  String get input => '入力';

  @override
  String get insights => 'Insights';

  @override
  String get invalidLink => '無効なリンクです。';

  @override
  String get invalidValue => '無効な値';

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
  String get language => '言語';

  @override
  String get languageSelection => '言語選択';

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
    return 'レベル$level';
  }

  @override
  String levelShort(Object level) {
    return 'L$level';
  }

  @override
  String get lightTheme => 'ライトテーマ';

  @override
  String get likertAgree => '賛成';

  @override
  String get likertDisagree => '反対';

  @override
  String get likertNeutral => '中立';

  @override
  String get likertStronglyAgree => '強く賛成';

  @override
  String get likertStronglyDisagree => '強く反対';

  @override
  String get linkHabits => '習慣をリンク';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'リストが作成されました: $title';
  }

  @override
  String get listLabel => 'リスト';

  @override
  String get listNameHint => '例: 健康';

  @override
  String get listNameLabel => 'リスト名';

  @override
  String get loadingHabits => '習慣を読み込み中...';

  @override
  String get logout => 'ログアウト';

  @override
  String get longestStreak => '最長連続記録';

  @override
  String get manageLists => 'リストを管理';

  @override
  String get manageListsSubtitle => '新しいリストの追加、名前の変更、削除を行います。';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => 'サブスクリプションの管理';

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
  String get medium => '普通';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'マインドフルネス';

  @override
  String get mintFresh => 'Taze Nane';

  @override
  String get mintFreshDesc => 'Taze nane ve turkuaz tonları';

  @override
  String get minutes => '分';

  @override
  String get minutesSuffixShort => '分';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Pzt';

  @override
  String get monthCount => '月数';

  @override
  String get monthCountHint => '例: 12';

  @override
  String get monthSuffixShort => '月';

  @override
  String get monthly => '毎月';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'Ayın belirli günlerinde';

  @override
  String get monthlyProgress => '月間進捗';

  @override
  String get monthlyTrend => '月間トレンド';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => '気分';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => '悪い';

  @override
  String get moodBadDesc => 'つらい時期を過ごしている';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => '素晴らしい';

  @override
  String get moodExcellentDesc => '素晴らしい気分';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => '感情の健康を記録する';

  @override
  String get moodFlowTitle => '気分はいかがですか？';

  @override
  String get moodGood => '良い';

  @override
  String get moodGoodDesc => '前向きな気分';

  @override
  String get moodGreat => '最高';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => '普通';

  @override
  String get moodNeutralDesc => '普通';

  @override
  String get moodOk => '普通';

  @override
  String get moodSelection => '気分の選択';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => '最悪';

  @override
  String get moodTerribleDesc => 'とても落ち込んでいる';

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
  String get motivation => 'モチベーション';

  @override
  String motivationBody(Object percent, Object period) {
    return '素晴らしい！$period、あなたは$percent%の成功率を達成しました。';
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
  String get mtdAverageShort => '月間平均';

  @override
  String get multiple => '複数';

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
  String get mysticTheme => 'ミスティック';

  @override
  String get mysticThemeDesc => '神秘的な紫のテーマ';

  @override
  String nDaysLabel(Object count) {
    return '$count日間';
  }

  @override
  String get nameHint => '例: 毎日のトレーニング';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => '名前は必須です';

  @override
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get newCategory => '新しいカテゴリ';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => '新しい習慣';

  @override
  String get newList => '新しいリスト';

  @override
  String get next => '次へ';

  @override
  String get nextLabel => '次へ';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => '来年';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noDataLast7Days => '過去7日間のデータがありません';

  @override
  String get noDataThisMonth => '今月のデータがありません';

  @override
  String get noEndDate => '終了日なし';

  @override
  String get noEndDayDefaultsDaily => '終了日が設定されていない場合、この習慣はデフォルトで毎日表示されます。';

  @override
  String get noEntriesYet => 'まだエントリがありません';

  @override
  String get noExpenseInThisCategory => 'このカテゴリには支出がありません';

  @override
  String get noExpenses => '支出がありません';

  @override
  String get noExpensesThisMonth => '今月の支出はありません';

  @override
  String get noHabitsAddedYet => 'まだ習慣が追加されていません。';

  @override
  String get noHistory => '履歴なし';

  @override
  String get noIncomeThisMonth => '今月の収入はありません';

  @override
  String get noItemsMatchFilters => '選択したフィルターに一致するアイテムがありません';

  @override
  String get noLinkedHabitsInVision => 'このビジョンにリンクされた習慣はありません。';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => '既製のビジョンが見つかりません。';

  @override
  String get noRecordsThisMonth => '今月の記録はありません';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'まだ追加されていません。';

  @override
  String get notGranted => '未許可';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'ロックされていない';

  @override
  String get noteOptional => 'メモ（任意）';

  @override
  String get notificationBehavior => '通知の動作';

  @override
  String get notificationPermission => '通知の許可';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationSettingsSubtitle => '通知の設定を変更します';

  @override
  String get notificationTroubleshooting =>
      '通知を正常に動作させるには：\n\n• バッテリー最適化をオフにする\n• バックグラウンドアクティビティを許可する\n• 通知の許可がオンになっていることを確認する\n• 「おやすみモード」を確認する';

  @override
  String get notificationTypes => '通知の種類';

  @override
  String get notifications => '通知';

  @override
  String get notificationsMasterSubtitle => 'すべてのアプリ通知を管理';

  @override
  String get numberLabel => '数値';

  @override
  String get numericExample => '1日に8杯の水を飲む';

  @override
  String get numericSettings => '数値目標設定';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => '数値目標の追跡';

  @override
  String get numericalGoalShort => '数値目標';

  @override
  String get numericalType => '数値';

  @override
  String get oceanTheme => 'オーシャン';

  @override
  String get oceanThemeDesc => '穏やかな青いテーマ';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get onDailyLimit => '1日の制限に達しました。';

  @override
  String get onPeriodic => '特定の間隔で';

  @override
  String get onSpecificMonthDays => '特定の月の日に';

  @override
  String get onSpecificWeekdays => '特定の曜日に';

  @override
  String get onSpecificYearDays => '特定の年の日に';

  @override
  String get onboardingQ1 => '新しい体験に挑戦し、未知のことを探求するのが好きです。';

  @override
  String get onboardingQ10 => '重要な出来事やタスクは事前に計画します。';

  @override
  String get onboardingQ11 => '一つの方法にこだわるより、さまざまなアプローチを試すのが好きです。';

  @override
  String get onboardingQ12 => 'プレッシャーの中でも落ち着いて対処し、失敗から素早く立ち直ります。';

  @override
  String get onboardingQ2 => '身の回りを整理整頓し、規則的な日課を好みます。';

  @override
  String get onboardingQ3 => '人と一緒にいると元気が出て、交流の場を楽しみます。';

  @override
  String get onboardingQ4 => '他者と協力して働くことを好み、競争よりも協力の方が効果的だと感じます。';

  @override
  String get onboardingQ5 => 'ストレスの多い状況でも落ち着いて対処し、不安を感じることはほとんどありません。';

  @override
  String get onboardingQ6 => 'アート、音楽、執筆などの創造的な活動を楽しみます。';

  @override
  String get onboardingQ7 => '明確な目標を立て、達成に向けて粘り強く取り組みます。';

  @override
  String get onboardingQ8 => '一人で過ごすよりも、グループでの活動を好みます。';

  @override
  String get onboardingQ9 => '意思決定の前に、相手の気持ちをよく考えます。';

  @override
  String get onboardingQuizIntro =>
      'あなたの個性をよりよく理解するために、いくつかの質問にお答えください。これは科学的に検証された心理学研究に基づいています。';

  @override
  String get onboardingWelcomeDesc =>
      'あなたとともに成長するパーソナル習慣トラッカーです。あなたの個性を見つけ、あなたに合った習慣を提案します。';

  @override
  String get onboardingWelcomeTitle => 'Miraへようこそ';

  @override
  String get once => '1回';

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
  String get other => 'その他';

  @override
  String get outline => 'アウトライン';

  @override
  String get outlineColor => 'アウトラインの色';

  @override
  String get overall => '全体';

  @override
  String get overallProgress => '全体の進捗';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'ページ';

  @override
  String get pastelColors => 'パステルカラー';

  @override
  String get pause => '一時停止';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => '定期的';

  @override
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => '定期的な選択';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => '今日の気分を選択';

  @override
  String get plannedMonthlySpend => '計画された月間支出';

  @override
  String plansLoadError(Object error) {
    return 'プランの読み込みエラー: $error';
  }

  @override
  String get plateColor => 'プレートの色';

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
  String get previous => '前へ';

  @override
  String get previousYear => '前年';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'プライバシーとセキュリティ';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => '生産性';

  @override
  String get profile => 'プロファイル';

  @override
  String get profileInfo => 'プロフィール情報';

  @override
  String get profileUpdated => 'プロフィールが更新されました';

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
  String get readyVisionsLoadFailed => '既製のビジョンを読み込めませんでした。';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => '健康';

  @override
  String get reasonOther => 'その他';

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
  String get reasonWork => '仕事';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc => '選択した日に毎月自動的に追加';

  @override
  String get recurringMonthlyTitle => '定期的（毎月）';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => '再読み込み';

  @override
  String get remainingToday => '今日残り';

  @override
  String get reminder => 'リマインダー';

  @override
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

  @override
  String get reminderFrequency => 'リマインダーの頻度';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'リマインダー設定';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get removeFromList => 'リストから削除';

  @override
  String get repeatEveryDay => '毎日繰り返す';

  @override
  String get repeatEveryNDays => 'N日ごとに繰り返す';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reset => 'リセット';

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
  String get restoreFailed => '復元に失敗しました';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'ダウンロード完了: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => '再試行';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'ルール: 入力期間 ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'ルール: 入力期間 ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'ルール: 入力期間 = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'ルール: 入力値 ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'ルール: 入力値 ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'ルール: 入力値 = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get save => '保存';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => '保存済み';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => '貯蓄・予算計画';

  @override
  String get scheduleHabit => '習慣のスケジュールを設定';

  @override
  String get scheduleLabel => 'スケジュール';

  @override
  String get schedulingOptions => 'スケジュールオプション';

  @override
  String get seconds => '秒';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => '選択';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get selectCategory => 'カテゴリを選択';

  @override
  String get selectDate => '日付を選択';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => '終了日を選択';

  @override
  String get selectFrequency => '頻度を選択';

  @override
  String get selectHabitType => '習慣タイプを選択';

  @override
  String get selectHabitsToAdd => '日々の習慣に追加したい項目を選んでください:';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc => '気分に影響を与えているものを選択';

  @override
  String get selectSubEmotion => '詳細な感情を選択';

  @override
  String get selectSubEmotionDesc => 'より具体的な感情を選択';

  @override
  String get selectTime => '時刻を選択';

  @override
  String get selectYourCurrentMood => '現在の気分を選択';

  @override
  String get selectYourMood => '気分を選択';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => '背面へ移動';

  @override
  String get setVisionTimeline =>
      'Vizyonunuz için zaman çizelgesini belirleyin';

  @override
  String get settings => '設定';

  @override
  String get shareAsLink => 'リンクとして共有';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied => '共有リンクがクリップボードにコピーされました。';

  @override
  String get shareVision => 'ビジョンを共有';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'シャッフル';

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
  String get simpleHabitTargetOne => '単純な習慣（目標=1）';

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
  String get simpleTypeShort => '単純';

  @override
  String get skip => 'スキップ';

  @override
  String get skipOnboarding => 'スキップ';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => 'ソーシャル';

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
  String get sound => 'サウンド';

  @override
  String get soundAlerts => '音声アラート';

  @override
  String get soundSubtitle => '通知でサウンドを再生';

  @override
  String get specificDaysOfMonth => '特定の月の日にち';

  @override
  String get specificDaysOfWeek => '特定の曜日';

  @override
  String get specificDaysOfYear => '特定の年の日にち';

  @override
  String get spendingAdvisorNoBudget => 'アドバイスを受けるには予算を設定してください。';

  @override
  String get spendingAdvisorOnTrack => '素晴らしい！予算通りに進んでいます。';

  @override
  String get spendingAdvisorOverBudget => '予算を超過しています。支出を控えてください。';

  @override
  String spendingAdvisorSafe(Object amount) {
    return '1日あたり$amount使えます。';
  }

  @override
  String get spendingAdvisorTitle => '支出アドバイザー';

  @override
  String spendingAdvisorWarning(Object amount) {
    return '予算内に収めるには、1日の支出を$amount減らしてください。';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return '素晴らしい！1日の平均より$amount少なく使っています。';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return '警告！1日の平均より$amount多く使っています。';
  }

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get start => '開始';

  @override
  String get startDate => '開始日';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => '開始日（1-365）';

  @override
  String get startJourney => 'はじめる';

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
  String get statusLabel => 'ステータス';

  @override
  String get step => 'ステップ';

  @override
  String stepOf(Object current, Object total) {
    return '$total中のステップ$current';
  }

  @override
  String get steps => 'ステップ';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return '$count日間の連続記録';
  }

  @override
  String get streakIndicator => '連続記録インジケーター';

  @override
  String get streakIndicatorDesc => '炎と氷のエフェクトを表示';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => '怒っている';

  @override
  String get subEmotionAnxious => '不安';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => '穏やか';

  @override
  String get subEmotionCheerful => '陽気';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => '意気消沈';

  @override
  String get subEmotionDetermined => '決意した';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => '消耗した';

  @override
  String get subEmotionEmpty => '空虚';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => '熱心';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => '興奮している';

  @override
  String get subEmotionExhausted => '疲れ果てた';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => '幸せ';

  @override
  String get subEmotionHelpless => '無力';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => '絶望的';

  @override
  String get subEmotionHurt => '傷ついた';

  @override
  String get subEmotionIndecisive => '優柔不断';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'やる気がある';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => '普通';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => '誇らしい';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => '悲しい';

  @override
  String get subEmotionSelection => '詳細な感情の選択';

  @override
  String get subEmotionStressed => 'ストレスを感じる';

  @override
  String get subEmotionTired => '疲れた';

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
  String get success => '成功';

  @override
  String get successfulDayLegend => '成功した日';

  @override
  String successfulDaysCount(Object count) {
    return '$count回の成功日';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'システム情報';

  @override
  String get systemTheme => 'システムテーマ';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

  @override
  String get target => '目標';

  @override
  String get targetDurationMinutes => '目標期間（分）';

  @override
  String targetShort(Object value) {
    return '目標: $value';
  }

  @override
  String get targetType => '目標タイプ';

  @override
  String get targetValue => '目標値';

  @override
  String get targetValueLabel => '目標値';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'タスクが削除されました: $title';
  }

  @override
  String get taskDescription => '説明（任意）';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'タスクタイトル';

  @override
  String get taskTitleRequired => 'タスクタイトルは必須です';

  @override
  String get tellMeYourDream =>
      'Hayalini anlat. Vizyon Panosu oluşturmana yardım edeyim.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'テンプレートの詳細が見つかりません';

  @override
  String get templatesTabManual => '手動';

  @override
  String get templatesTabReady => '既製';

  @override
  String get textLabel => 'テキスト';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'テーマ';

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
  String get themeDetails => 'テーマ詳細';

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
  String get themeSelection => 'テーマ選択';

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
  String get thisMonth => '今月';

  @override
  String get thisWeek => '今週';

  @override
  String get thisYear => '今年';

  @override
  String get thursdayShort => 'Per';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst => '最初にタイマー習慣を作成してください';

  @override
  String get timerDescription => '時間ベースの追跡';

  @override
  String get timerExample => '30分のトレーニングをする';

  @override
  String get timerHabitLabel => 'タイマー習慣';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return '保留中の期間: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return '保留中: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => '休憩';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return '完了した作業: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel => '長い休憩のサイクル（例: 4）';

  @override
  String get timerPomodoroLongBreakMinutesLabel => '長い休憩（分）';

  @override
  String get timerPomodoroSettings => 'ポモドーロ設定';

  @override
  String get timerPomodoroShortBreakMinutesLabel => '短い休憩（分）';

  @override
  String get timerPomodoroSkipPhase => 'フェーズをスキップ';

  @override
  String get timerPomodoroWorkMinutesLabel => '作業（分）';

  @override
  String get timerPomodoroWorkPhase => '作業';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => '期間を保存';

  @override
  String get timerSaveSessionTitle => 'セッションを保存';

  @override
  String get timerSessionAlreadySaved => 'このセッションは既に保存されています';

  @override
  String get timerSetDurationFirst => '最初に期間を設定してください';

  @override
  String get timerSettings => 'タイマー設定';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'カウントダウン';

  @override
  String get timerTabPomodoro => 'ポモドーロ';

  @override
  String get timerTabStopwatch => 'ストップウォッチ';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'タイマー';

  @override
  String get times => '回';

  @override
  String get timezone => 'タイムゾーン';

  @override
  String get titleHint => '例: 食料品、フリーランスなど';

  @override
  String get titleOptional => 'タイトル（任意）';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => '合計期間';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => '全体の進捗';

  @override
  String get totalSuccessfulDays => '成功した合計日数';

  @override
  String get totalUnsuccessfulDays => '失敗した合計日数';

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
  String get typeLabel => 'タイプ';

  @override
  String get typeNotChangeable => 'タイプは変更できません';

  @override
  String get unassignLinkedDailyTasks => 'リンクされた日課の割り当てを解除';

  @override
  String get unassignLinkedHabits => 'リンクされた習慣の割り当てを解除';

  @override
  String get undo => '元に戻す';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => '単位';

  @override
  String get unitAdet => '個';

  @override
  String get unitAdim => '歩';

  @override
  String get unitBardak => '杯';

  @override
  String get unitHint => '単位（グラス、ステップ、ページ...）';

  @override
  String get unitKalori => 'cal';

  @override
  String get unitKez => '回';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'リットル';

  @override
  String get unitSayfa => 'ページ';

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
  String get update => '更新';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => '値';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get vibrationSubtitle => '通知でバイブレーション';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'ビジョン';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'このビジョンはテンプレートの最終日を使用します: $day。';
  }

  @override
  String get visionBoard => 'Vizyon Panosu';

  @override
  String get visionBoardDesc =>
      'Hedeflerinizi organize etmek ve yolculuğunuzu takip etmek için bir vizyon oluşturun';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'ビジョンを作成';

  @override
  String get visionDurationDaysLabel => '期間（日数）';

  @override
  String get visionDurationNote =>
      '注意: ビジョンが開始されると、合計期間が設定されます。終了日がこの期間を超える場合、自動的に短縮されます。';

  @override
  String get visionEditTitle => 'ビジョンを編集';

  @override
  String get visionEmptyDescription =>
      'Hedeflerinizi görselleştirin ve hayallerinizi gerçeğe dönüştürmek için ilk vizyonunuzu ekleyin.';

  @override
  String get visionEndDayInvalid => '終了日は1から365の間でなければなりません';

  @override
  String get visionEndDayLess => '終了日は開始日より前にすることはできません';

  @override
  String get visionEndDayQuestion => 'ビジョンの何日目に終了しますか？';

  @override
  String get visionEndDayRequired => '終了日を入力してください';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo => '終了日が指定されていません。ビジョンは無期限で開始されます。';

  @override
  String get visionPlural => 'ビジョン';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid => '開始日は1から365の間でなければなりません';

  @override
  String get visionStartDayQuestion => 'ビジョンの何日目に開始しますか？';

  @override
  String get visionStartFailed => 'ビジョンを開始できませんでした。';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'ビジョンが開始されました: $title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => 'ビジュアル';

  @override
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => '金';

  @override
  String get weekdaysShortMon => '月';

  @override
  String get weekdaysShortSat => '土';

  @override
  String get weekdaysShortSun => '日';

  @override
  String get weekdaysShortThu => '木';

  @override
  String get weekdaysShortTue => '火';

  @override
  String get weekdaysShortWed => '水';

  @override
  String get weekly => '毎週';

  @override
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => '週間メール要約';

  @override
  String get weeklyProgress => '週間進捗';

  @override
  String get weeklySummaryEmail => '週間サマリーメール';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => '原因は何ですか？';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => 'どの日をアクティブにしますか？';

  @override
  String get whichWeekdays => 'どの曜日ですか？';

  @override
  String get worldTheme => 'ワールド';

  @override
  String get worldThemeDesc => 'すべての色の調和';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • 次のレベルまで$toNext XP';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get yearly => '毎年';

  @override
  String get yearlyProgress => '年間進捗';

  @override
  String get yesNoDescription => '単純なはい/いいえの追跡';

  @override
  String get yesNoExample => '今日瞑想しましたか？';

  @override
  String get yesNoType => 'はい/いいえ';

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
  String get whichMonthDays => '月のどの日ですか？';

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
