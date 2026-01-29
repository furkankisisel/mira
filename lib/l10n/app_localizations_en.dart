// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get weeklyReportsTitle => 'Weekly Reports';

  @override
  String get noReportsYet => 'No reports yet';

  @override
  String get createFirstReportPrompt =>
      'Click + to create your first weekly report';

  @override
  String get generating => 'Generating...';

  @override
  String get createReport => 'Create Report';

  @override
  String costTokens(Object cost) {
    return 'Cost: $cost tokens';
  }

  @override
  String balanceParenthesis(Object balance) {
    return '(Balance: $balance)';
  }

  @override
  String get watchAdForToken => 'Watch Ad (+1 Token)';

  @override
  String get selectReportType => 'Select Report Type:';

  @override
  String generatedAtDate(Object date) {
    return 'Generated: $date';
  }

  @override
  String get insufficientTokensWatchAd =>
      'Insufficient tokens! Watch an ad to earn tokens.';

  @override
  String get reportCreatedSuccess => 'Report created! ✨';

  @override
  String get reportAlreadyExists => 'Report already exists for this week.';

  @override
  String get tokenEarnedSuccess => '+1 token earned! 🎉';

  @override
  String get about => 'About';

  @override
  String get account => 'Account';

  @override
  String get achievements => 'Achievements';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'Active days';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => 'Add';

  @override
  String get addDate => 'Add Date';

  @override
  String get addFirstTransaction => 'Add first transaction';

  @override
  String get addHabit => 'Add Habit';

  @override
  String get addImage => 'Add image';

  @override
  String get addNew => 'Add New';

  @override
  String get addNewHabit => 'Add New Habit';

  @override
  String get addOptionHint => 'Add option...';

  @override
  String get addOptionsToStart => 'Add options to start';

  @override
  String get addSpecialDays => 'Add special days';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'Add Task';

  @override
  String get addText => 'Add text';

  @override
  String get addToList => 'Add to list';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'Advanced Habit';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get aiAssistantOnline => 'Online';

  @override
  String get aiAssistantTitle => 'AI Assistant';

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
  String get aiQuickGamification => 'Explain XP system';

  @override
  String get aiQuickHabit => 'Create a new habit';

  @override
  String get aiQuickMood => 'Analyze my mood';

  @override
  String get aiQuickMotivation => 'Give me motivation';

  @override
  String get aiQuickProfile => 'My AI Character';

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
  String get allLabel => 'All';

  @override
  String get alsoDeleteLinkedHabits => 'Also delete linked habits';

  @override
  String get amount => 'Amount';

  @override
  String get amountLabel => 'Amount';

  @override
  String get analysis => 'Analysis';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Appearance';

  @override
  String get apply => 'Apply';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'This vision lasts about $days days';
  }

  @override
  String get assetsReloadHint =>
      'A full app restart may be required to load some assets.';

  @override
  String get atLeast => 'At Least';

  @override
  String get atMost => 'At Most';

  @override
  String get autoBackupSubtitle =>
      'Automatically backup your data to Google Drive every 24 hours.';

  @override
  String get autoBackupTitle => 'Automatic Backup';

  @override
  String get averageMood => 'Average Mood';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => 'Background plate';

  @override
  String get backupError => 'Backup Error';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String backupSuccess(Object id) {
    return 'Backed up: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get badgeActive100dDesc => 'Be active for 100 days';

  @override
  String get badgeActive100dTitle => 'Companion';

  @override
  String get badgeActive30dDesc => 'Be active for 30 days';

  @override
  String get badgeActive30dTitle => 'Committed';

  @override
  String get badgeActive7dDesc => 'Be active for 7 days';

  @override
  String get badgeActive7dTitle => 'Warming Up';

  @override
  String get badgeCategoryActivity => 'Activity';

  @override
  String get badgeCategoryFinance => 'Finance';

  @override
  String get badgeCategoryHabit => 'Habit';

  @override
  String get badgeCategoryLevel => 'Level';

  @override
  String get badgeCategoryVision => 'Vision';

  @override
  String get badgeCategoryXp => 'Experience';

  @override
  String get badgeFin100Desc => 'Log 100 transactions';

  @override
  String get badgeFin100Title => 'Finance Guru';

  @override
  String get badgeFin10Desc => 'Log 10 transactions';

  @override
  String get badgeFin10Title => 'Thrifty';

  @override
  String get badgeFin250Desc => 'Log 250 transactions';

  @override
  String get badgeFin250Title => 'Banker';

  @override
  String get badgeFin50Desc => 'Log 50 transactions';

  @override
  String get badgeFin50Title => 'Economist';

  @override
  String get badgeHabit100Desc => 'Complete 100 habits';

  @override
  String get badgeHabit100Title => 'Expert';

  @override
  String get badgeHabit10Desc => 'Complete 10 habits';

  @override
  String get badgeHabit10Title => 'Starter';

  @override
  String get badgeHabit200Desc => 'Complete 200 habits';

  @override
  String get badgeHabit200Title => 'Legend';

  @override
  String get badgeHabit50Desc => 'Complete 50 habits';

  @override
  String get badgeHabit50Title => 'Consistent';

  @override
  String get badgeLevel10Desc => 'Reach level 10';

  @override
  String get badgeLevel10Title => 'Journeyman';

  @override
  String get badgeLevel20Desc => 'Reach level 20';

  @override
  String get badgeLevel20Title => 'Master';

  @override
  String get badgeLevel5Desc => 'Reach level 5';

  @override
  String get badgeLevel5Title => 'Apprentice';

  @override
  String get badgeVision10Desc => 'Create 10 visions';

  @override
  String get badgeVision10Title => 'Futurist';

  @override
  String get badgeVision1Desc => 'Create 1 vision';

  @override
  String get badgeVision1Title => 'Dreamer';

  @override
  String get badgeVision5Desc => 'Create 5 visions';

  @override
  String get badgeVision5Title => 'Visionary';

  @override
  String get badgeVisionHabits3Desc => 'Link 3 habits to a vision';

  @override
  String get badgeVisionHabits3Title => 'Goal Oriented';

  @override
  String get badgeXp1000Desc => 'Collect 1000 XP';

  @override
  String get badgeXp1000Title => 'Wise';

  @override
  String get badgeXp500Desc => 'Collect 500 XP';

  @override
  String get badgeXp500Title => 'Experienced';

  @override
  String get badges => 'Badges';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => 'Between 1 and 360';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'A short biography about yourself';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => 'Break';

  @override
  String get breakdownByCategory => 'Breakdown by category';

  @override
  String get bringForward => 'Bring forward';

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
  String get cancel => 'Cancel';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'Category';

  @override
  String get categoryName => 'Category Name';

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
  String get chooseBestCategory => 'Choose the best category for your habit';

  @override
  String get chooseColor => 'Choose Color:';

  @override
  String get chooseEmoji => 'Choose Emoji:';

  @override
  String get choosePhoto => 'Choose Photo';

  @override
  String get choosePhotoSubtitle => 'Choose a photo to motivate you';

  @override
  String get choosePhotoDesc => 'Select a photo that inspires you';

  @override
  String get clear => 'Clear';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get close => 'Close';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'Decide between two options';

  @override
  String get coinFlipInstruction => 'Enter two options and flip the coin!';

  @override
  String get coinFlipTitle => 'Coin Flip';

  @override
  String get colorLabel => 'Color';

  @override
  String get colorTheme => 'Color theme';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'Completed on selected day';

  @override
  String get confirmDeleteAccount => 'Confirm Account Deletion';

  @override
  String get confirmHabits => 'Confirm Habits';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueText => 'Continue';

  @override
  String get cottonCandy => 'Cotton Candy';

  @override
  String get cottonCandyDesc => 'Cotton candy - pink & blue';

  @override
  String get countdownConfigureTitle => 'Configure Countdown';

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
  String get create => 'Create';

  @override
  String get createAdvancedHabit => 'Create Advanced Habit';

  @override
  String get createDailyTask => 'Create Daily Task';

  @override
  String get createFirstHabit => 'Create Habit';

  @override
  String get createFirstVision => 'Create Your First Vision';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => 'Create Habit Template';

  @override
  String get createHabitTitle => 'Create Habit';

  @override
  String get createList => 'Create List';

  @override
  String get createNewCategory => 'Create New Category';

  @override
  String get createNewList => 'Create New List';

  @override
  String get createVision => 'Create Vision';

  @override
  String get createVisionTemplateTitle => 'Create Vision Template';

  @override
  String get createVisionWithAI => 'Create Vision with AI';

  @override
  String get createWithAi => 'Create with AI';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get custom => 'Custom';

  @override
  String get customCategories => 'Custom Categories';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => 'Ex: ✨';

  @override
  String get customEmojiOptional => 'Custom emoji (optional)';

  @override
  String get customFrequency => 'Custom';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => 'Ex: portion, set, km...';

  @override
  String get daily => 'Daily';

  @override
  String get dailyCheck => 'Daily check';

  @override
  String get dailyDesc => 'Every day';

  @override
  String get dailyLimit => 'Daily limit';

  @override
  String get dailyTask => 'Daily Task';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Daily task created successfully';
  }

  @override
  String get dailyTasksSection => 'Daily Tasks';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get date => 'Date';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Fri';

  @override
  String get dayMonShort => 'Mon';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Day $start–$end';
  }

  @override
  String get daySatShort => 'Sat';

  @override
  String dayShort(Object day) {
    return 'Day $day';
  }

  @override
  String get daySunShort => 'Sun';

  @override
  String get dayThuShort => 'Thu';

  @override
  String get dayTueShort => 'Tue';

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
    return '${days}d avg.';
  }

  @override
  String daysCount(Object count) {
    return '$count days';
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
  String get decisionEggDescription => 'Pick a mystical egg for answers';

  @override
  String get decisionEggTitle => 'Decision Egg';

  @override
  String get defaultUnit => 'count';

  @override
  String get delete => 'Delete';

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
    return 'Delete the category \"$name\"?';
  }

  @override
  String get deleteCategoryTitle => 'Delete category';

  @override
  String get deleteCustomCategoryConfirm => 'Delete this custom category?';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to delete this entry?';

  @override
  String deleteHabitConfirm(Object title) {
    return 'Delete habit \"$title\"?';
  }

  @override
  String get deleteListMessage => 'Are you sure you want to delete this list?';

  @override
  String get deleteListTitle => 'Delete List';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage =>
      'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmTitle => 'Delete Task';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'Delete the record \"$title\"?';
  }

  @override
  String get deleteVisionMessage => 'Delete this vision?';

  @override
  String get deleteVisionTitle => 'Delete vision';

  @override
  String get descHint => 'Details about your habit (optional)';

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
  String get difficulty => 'Difficulty Level';

  @override
  String get drinkWater => 'Drink Water';

  @override
  String get duration => 'Duration';

  @override
  String get durationAutoLabel => 'Duration (auto)';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => 'Duration selection';

  @override
  String get durationType => 'Duration Type';

  @override
  String get earthTheme => 'Earth';

  @override
  String get earthThemeDesc => 'Earth colors';

  @override
  String get easy => 'Easy';

  @override
  String get edit => 'Edit';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get editListTitle => 'Edit List';

  @override
  String get education => 'Education';

  @override
  String get eggRevealMessage => 'The mystical egg has spoken! ✨';

  @override
  String get eggSelectMessage => 'Think of a question and tap an egg 🥚';

  @override
  String get emojiAndColor => 'Emoji & Color';

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
      'Create your first habit to begin tracking your progress.';

  @override
  String get emptyHabitTitle => 'Start Your Journey';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableReminder => 'Enable Reminder';

  @override
  String get endDate => 'End Date';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => 'End day (optional)';

  @override
  String get enterBothOptions => 'Please enter both options';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Enter a monthly plan to compute a daily limit.';

  @override
  String get enterNameAndDesc => 'Enter your habit\'s name and description';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => 'Enter value';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get entries => 'Entries';

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
  String get everyNDaysQuestion => 'Every how many days?';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => 'Every Day';

  @override
  String get exact => 'Exact';

  @override
  String get exactAlarmPermission => 'Exact Alarm Permission (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Example: $example';
  }

  @override
  String get expenseDelta => 'Expense Δ';

  @override
  String get expenseDistributionPie => 'Expense distribution (pie)';

  @override
  String get expenseEditTitle => 'Edit Expense';

  @override
  String get expenseLabel => 'Expense';

  @override
  String get expenseNewTitle => 'New Expense';

  @override
  String failedToLoad(Object error) {
    return 'Failed to load: $error';
  }

  @override
  String get featureAdvancedFinance => 'Advanced Finance Features';

  @override
  String get featureAdvancedHabits => 'Advanced Habit Creation';

  @override
  String get featureAiBioClock => 'AI Powered Biological Clock';

  @override
  String get featureAiBioClockDesc =>
      'Optimal timing based on your biological rhythm';

  @override
  String get featureAiWeeklyReport => 'AI Powered Weekly Report';

  @override
  String get featureAiWeeklyReportDesc =>
      'Detailed AI analysis of your progress';

  @override
  String get featureBackup => 'Backup Feature';

  @override
  String get featurePremiumThemes => 'Premium Themes';

  @override
  String get featureVisionCreation => 'Vision Creation';

  @override
  String get feelingMoreSpecific =>
      'Let\'s describe this feeling more specifically';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'Finance';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Finance Analysis · $month';
  }

  @override
  String get financeLast7Days => 'Finance · Last 7 days';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'Finish';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Fixed';

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
  String get font => 'Font';

  @override
  String get forestTheme => 'Forest';

  @override
  String get forestThemeDesc => 'Natural green theme';

  @override
  String get forever => 'Forever';

  @override
  String get fortuneDisclaimer => 'For fun only.';

  @override
  String fortuneEggSemantic(int index) {
    return 'Egg $index';
  }

  @override
  String get fortuneEggsSubtitle => 'Pick one egg below';

  @override
  String get fortuneNoQuestion => 'You didn\'t write a question';

  @override
  String get fortunePlay => 'Fortune Eggs';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => 'Ex: Should I try something new this week?';

  @override
  String get fortuneQuestionPrompt => 'Type the question on your mind';

  @override
  String get fortuneResultTitle => 'Your answer';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => 'Fortune Eggs';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => 'Frequency';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Fri';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullScreen => 'Full screen';

  @override
  String get gallery => 'Gallery';

  @override
  String get gamesDescription =>
      'Having trouble deciding? Let fun games help you decide!';

  @override
  String get gamesTitle => 'Games';

  @override
  String get general => 'General';

  @override
  String get generalNotifications => 'General notifications';

  @override
  String get generate => 'Generate';

  @override
  String get glasses => 'Glasses';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'Golden';

  @override
  String get goldenThemeDesc => 'Warm golden theme';

  @override
  String get goodMorning => 'Good morning! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Granted';

  @override
  String get greatDayAhead => 'Today is a great day, you got this!';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get guestAccount => 'Guest Account';

  @override
  String get guidedJourney => 'Guided Journey';

  @override
  String get guidedJourneyDesc => 'Step-by-step guided flow';

  @override
  String get habit => 'Habit';

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
    return 'Habit created successfully: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Habit deleted';
  }

  @override
  String get habitDescription => 'Description';

  @override
  String get habitDescriptionHint => 'Add a short description...';

  @override
  String get habitDetails => 'Habit Details';

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
  String get habitName => 'Habit Name';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => 'Ex: Drink water, Read pages...';

  @override
  String get habitNameHintTimer => 'Ex: Meditation, Exercise...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => 'Habit not found.';

  @override
  String get habitOfThisVision => 'Habit of this vision';

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
  String get habitReminders => 'Habit Reminders';

  @override
  String get habitRemindersSubtitle => 'Daily reminders for your habits';

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
  String get habitUpdatedMessage => 'Habit updated.';

  @override
  String get habits => 'Habits';

  @override
  String get habitsSection => 'Habits';

  @override
  String get hard => 'Hard';

  @override
  String get hardMode => 'Hard Mode';

  @override
  String get headerFocusLabel => 'Focus';

  @override
  String get headerFocusReady => 'Ready';

  @override
  String get headerHabitsLabel => 'Habit';

  @override
  String get health => 'Health';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'h';

  @override
  String get hours => 'Hours';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get howDoYouFeel => 'How do you feel today?';

  @override
  String get howOftenDoHabit => 'Decide how often you\'ll do your habit';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => 'How to earn';

  @override
  String get howToTrackHabit => 'Choose how your habit will be tracked';

  @override
  String get ifCondition => 'If';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'Import from link';

  @override
  String get importantNotice => 'Important Notice';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => 'Income Δ';

  @override
  String get incomeEditTitle => 'Edit Income';

  @override
  String get incomeLabel => 'Income';

  @override
  String get incomeNewTitle => 'New Income';

  @override
  String get incompleteSelectedDay => 'Incomplete on selected day';

  @override
  String get input => 'Input';

  @override
  String get insights => 'Insights';

  @override
  String get invalidLink => 'Invalid link.';

  @override
  String get invalidValue => 'Invalid value';

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
  String get keepItUp => 'Awesome! Keep it up! 💪';

  @override
  String get language => 'Language';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Lavender Dreams';

  @override
  String get lavenderDreamsDesc => 'Elegant lavender & purple tones';

  @override
  String get letsPlayGame => 'Let\'s play! 🎮';

  @override
  String get letsStart => 'Let\'s Start';

  @override
  String levelLabel(Object level) {
    return 'Level $level';
  }

  @override
  String levelShort(Object level) {
    return 'L$level';
  }

  @override
  String get lightTheme => 'Light theme';

  @override
  String get likertAgree => 'Agree';

  @override
  String get likertDisagree => 'Disagree';

  @override
  String get likertNeutral => 'Neutral';

  @override
  String get likertStronglyAgree => 'Strongly Agree';

  @override
  String get likertStronglyDisagree => 'Strongly Disagree';

  @override
  String get linkHabits => 'Link habits';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'List created successfully';
  }

  @override
  String get listLabel => 'List';

  @override
  String get listNameHint => 'Enter list name';

  @override
  String get listNameLabel => 'List Name';

  @override
  String get loadingHabits => 'Loading habits...';

  @override
  String get logout => 'Log out';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get manageLists => 'Manage lists';

  @override
  String get manageListsSubtitle => 'Organize your habits and tasks';

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
  String get manualFallback => 'Create Manually';

  @override
  String get maxOptionsReached => 'Maximum 12 options allowed';

  @override
  String get meditation => 'Meditation';

  @override
  String get medium => 'Medium';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Mindfulness';

  @override
  String get mintFresh => 'Mint Fresh';

  @override
  String get mintFreshDesc => 'Fresh mint & turquoise tones';

  @override
  String get minutes => 'Minutes';

  @override
  String get minutesSuffixShort => 'min';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Mon';

  @override
  String get monthCount => 'Month count';

  @override
  String get monthCountHint => 'Ex: 12';

  @override
  String get monthSuffixShort => 'mo';

  @override
  String get monthly => 'Monthly';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'On specific days of the month';

  @override
  String get monthlyProgress => 'Monthly progress';

  @override
  String get monthlyTrend => 'Monthly trend';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => 'Mood';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodBadDesc => 'I feel bad';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => 'Excellent';

  @override
  String get moodExcellentDesc => 'I feel excellent';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => 'Select your mood today';

  @override
  String get moodFlowTitle => 'How Are You Feeling?';

  @override
  String get moodGood => 'Good';

  @override
  String get moodGoodDesc => 'I feel good';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodNeutralDesc => 'I feel neutral';

  @override
  String get moodOk => 'Okay';

  @override
  String get moodSelection => 'Mood Selection';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String get moodTerribleDesc => 'I feel terrible';

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
  String get motivation => 'Motivation';

  @override
  String motivationBody(Object percent, Object period) {
    return 'Great! You achieved a $percent% success rate over $period.';
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
    return '$title is waiting for you 🚀';
  }

  @override
  String get mtdAverageShort => 'MTD avg.';

  @override
  String get multiple => 'Multiple';

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
  String get mysticTheme => 'Mystic';

  @override
  String get mysticThemeDesc => 'Mystic purple theme';

  @override
  String nDaysLabel(Object count) {
    return '$count days';
  }

  @override
  String get nameHint => 'Ex: Daily workout';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameYourVision => 'Name Your Vision';

  @override
  String get nameYourVisionDesc => 'Give your vision a meaningful name';

  @override
  String get nameYourVisionSubtitle => 'Give your vision a meaningful name';

  @override
  String get needAtLeastTwoOptions => 'Need at least 2 options';

  @override
  String get newCategory => 'New category';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => 'New habits';

  @override
  String get newList => 'New List';

  @override
  String get next => 'Next';

  @override
  String get nextLabel => 'Next';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get nextYear => 'Next year';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noDataLast7Days => 'No data for last 7 days';

  @override
  String get noDataThisMonth => 'No data for this month';

  @override
  String get noEndDate => 'No end date';

  @override
  String get noEndDayDefaultsDaily =>
      'When no end day is set, this habit will appear every day by default.';

  @override
  String get noEntriesYet => 'No entries yet';

  @override
  String get noExpenseInThisCategory => 'No expenses in this category';

  @override
  String get noExpenses => 'No expenses';

  @override
  String get noExpensesThisMonth => 'No expenses for this month';

  @override
  String get noHabitsAddedYet => 'No habits added yet.';

  @override
  String get noHistory => 'No mood history';

  @override
  String get noIncomeThisMonth => 'No income for this month';

  @override
  String get noItemsMatchFilters => 'No items match the current filters';

  @override
  String get noLinkedHabitsInVision => 'No habits linked to this vision.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => 'No ready visions found.';

  @override
  String get noRecordsThisMonth => 'No records for this month';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'Not added yet.';

  @override
  String get notGranted => 'Not Granted';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'Not unlocked';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get notificationBehavior => 'Notification Behavior';

  @override
  String get notificationPermission => 'Notification Permission';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get notificationSettingsSubtitle =>
      'Configure your notification preferences';

  @override
  String get notificationTroubleshooting =>
      'For notifications to work properly:\n\n• Turn OFF battery optimization (Settings → Apps → Mira → Battery → Unrestricted)\n• ALLOW background activity\n• Ensure notification permissions are ON\n• Check \'Do Not Disturb\' mode';

  @override
  String get notificationTypes => 'Notification Types';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsMasterSubtitle => 'Control all app notifications';

  @override
  String get numberLabel => 'Number';

  @override
  String get numericExample => 'Drink 8 glasses of water per day';

  @override
  String get numericSettings => 'Numerical Goal Settings';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => 'Numerical goal tracking';

  @override
  String get numericalGoalShort => 'Numerical goal';

  @override
  String get numericalType => 'Numerical Value';

  @override
  String get oceanTheme => 'Ocean';

  @override
  String get oceanThemeDesc => 'Calm blue theme';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get onDailyLimit => 'You\'re on your daily limit.';

  @override
  String get onPeriodic => 'At specific intervals';

  @override
  String get onSpecificMonthDays => 'On specific month days';

  @override
  String get onSpecificWeekdays => 'On specific weekdays';

  @override
  String get onSpecificYearDays => 'On specific year days';

  @override
  String get onboardingQ1 =>
      'I enjoy trying new experiences and exploring unfamiliar things.';

  @override
  String get onboardingQ10 => 'I plan ahead for important events and tasks.';

  @override
  String get onboardingQ11 =>
      'I like trying different approaches rather than sticking to one method.';

  @override
  String get onboardingQ12 =>
      'I stay calm under pressure and bounce back quickly from setbacks.';

  @override
  String get onboardingQ2 =>
      'I keep my space organized and prefer having a structured daily routine.';

  @override
  String get onboardingQ3 =>
      'I feel energized when I\'m around other people and enjoy social gatherings.';

  @override
  String get onboardingQ4 =>
      'I prefer working with others and find cooperation more effective than competition.';

  @override
  String get onboardingQ5 =>
      'I handle stressful situations calmly and rarely feel anxious.';

  @override
  String get onboardingQ6 =>
      'I enjoy creative activities like art, music, or writing.';

  @override
  String get onboardingQ7 =>
      'I set clear goals for myself and work diligently to achieve them.';

  @override
  String get onboardingQ8 =>
      'I prefer group activities over spending time alone.';

  @override
  String get onboardingQ9 =>
      'I often consider other people\'s feelings before making decisions.';

  @override
  String get onboardingQuizIntro =>
      'Answer a few questions to help us understand your personality better. This is based on scientifically validated psychological research.';

  @override
  String get onboardingWelcomeDesc =>
      'Your personal habit tracker that grows with you. Let\'s discover your unique personality and suggest habits tailored just for you.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Mira';

  @override
  String get once => 'Once';

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
  String get other => 'Other';

  @override
  String get outline => 'Outline';

  @override
  String get outlineColor => 'Outline color';

  @override
  String get overall => 'Overall';

  @override
  String get overallProgress => 'Overall progress';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'Pages';

  @override
  String get pastelColors => 'Pastel Colors';

  @override
  String get pause => 'Pause';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => 'Periodic';

  @override
  String get periodicDesc => 'At regular intervals';

  @override
  String get periodicSelection => 'Periodic Selection';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Photo';

  @override
  String get pickFromCalendar => 'Pick from Calendar';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => 'Pick today\'s mood';

  @override
  String get plannedMonthlySpend => 'Planned monthly spend';

  @override
  String plansLoadError(Object error) {
    return 'Error loading plans: $error';
  }

  @override
  String get plateColor => 'Plate color';

  @override
  String get playAgain => 'Play Again';

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
  String get previous => 'Previous';

  @override
  String get previousYear => 'Previous year';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'Privacy & security';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => 'Productivity';

  @override
  String get profile => 'Profile';

  @override
  String get profileInfo => 'Profile information';

  @override
  String get profileUpdated => 'Profile updated';

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
  String get readBook => 'Read Book';

  @override
  String get readyVisionsLoadFailed => 'Ready visions couldn\'t be loaded.';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'Health';

  @override
  String get reasonOther => 'Other';

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
  String get reasonWork => 'Work';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc =>
      'Automatically add every month on the selected date';

  @override
  String get recurringMonthlyTitle => 'Recurring (monthly)';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => 'Reload';

  @override
  String get remainingToday => 'Remaining today';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderDisabled => 'Reminder Off';

  @override
  String get reminderEnabled => 'Reminder On';

  @override
  String get reminderFrequency => 'Reminder Frequency';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'Reminder Settings';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get removeFromList => 'Remove from list';

  @override
  String get repeatEveryDay => 'Repeats every day';

  @override
  String get repeatEveryNDays => 'Repeat Every N Days';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reset => 'Reset';

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
  String get restoreFailed => 'Restore failed';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'Downloaded: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Your data has been successfully restored. We recommend restarting the app for changes to take full effect.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => 'Retry';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Rule: Entered duration ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Rule: Entered duration ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Rule: Entered duration = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Rule: Entered value ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Rule: Entered value ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Rule: Entered value = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => 'Saved';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => 'Savings / Budget Plan';

  @override
  String get scheduleHabit => 'Set your habit\'s schedule';

  @override
  String get scheduleLabel => 'Schedule';

  @override
  String get schedulingOptions => 'Scheduling Options';

  @override
  String get seconds => 'Seconds';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => 'Select';

  @override
  String get selectAll => 'Select All';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectFrequency => 'Select Frequency';

  @override
  String get selectHabitType => 'Select Habit Type';

  @override
  String get selectHabitsToAdd =>
      'Select habits you\'d like to add to your daily routine:';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select Reason';

  @override
  String get selectReasonDesc => 'Which factor affected your day the most?';

  @override
  String get selectSubEmotion => 'Select Sub-emotion';

  @override
  String get selectSubEmotionDesc => 'Which sub-emotion best describes you?';

  @override
  String get selectTime => 'Select Time';

  @override
  String get selectYourCurrentMood => 'Select your current mood';

  @override
  String get selectYourMood => 'Select your mood';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => 'Send backward';

  @override
  String get setVisionTimeline => 'Set the timeline for your vision';

  @override
  String get settings => 'Settings';

  @override
  String get shareAsLink => 'Share as link';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied => 'Share link copied to clipboard.';

  @override
  String get shareVision => 'Share vision';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'Shuffle';

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
  String get simpleHabitFrequencySubtitle => 'Set your goals';

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
  String get simpleHabitTargetOne => 'Simple habit (target = 1)';

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
  String get simpleTypeShort => 'Simple';

  @override
  String get skip => 'Skip';

  @override
  String get skipOnboarding => 'Skip';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => 'Social';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get softCloud => 'Soft Cloud';

  @override
  String get softCloudDesc => 'Cloud-like, dreamy soft';

  @override
  String get softPeach => 'Soft Peach';

  @override
  String get softPeachDesc => 'Warm peach & cream tones';

  @override
  String get sound => 'Sound';

  @override
  String get soundAlerts => 'Sound alerts';

  @override
  String get soundSubtitle => 'Play sound with notifications';

  @override
  String get specificDaysOfMonth => 'Specific Days of Month';

  @override
  String get specificDaysOfWeek => 'Specific Days of Week';

  @override
  String get specificDaysOfYear => 'Specific Days of Year';

  @override
  String get spendingAdvisorNoBudget => 'Set a budget to get advice.';

  @override
  String get spendingAdvisorOnTrack =>
      'Great! You are on track with your budget.';

  @override
  String get spendingAdvisorOverBudget => 'You are over budget. Stop spending.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'You can spend $amount per day.';
  }

  @override
  String get spendingAdvisorTitle => 'Spending Advisor';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Reduce daily spending by $amount to stay on track.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Great! You\'re spending $amount less than the daily average.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Warning! You\'re spending $amount more than the daily average.';
  }

  @override
  String get spin => 'SPIN';

  @override
  String get spinAgain => 'Spin Again';

  @override
  String get start => 'Start';

  @override
  String get startDate => 'Start Date';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => 'Start day (1-365)';

  @override
  String get startJourney => 'Start Your Journey';

  @override
  String get startTest => 'Start Test';

  @override
  String get startTestDesc =>
      'If you complete the test, you will get personalized suggestions and habit recommendations. You can skip this step if you wish.';

  @override
  String get startTestTitle => 'Do you want to start the personality test?';

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
  String get statusLabel => 'Status';

  @override
  String get step => 'Step';

  @override
  String stepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get steps => 'Steps';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return '$count Day Streak';
  }

  @override
  String get streakIndicator => 'Streak indicator';

  @override
  String get streakIndicatorDesc => 'Show flame and ice effects';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => 'Angry';

  @override
  String get subEmotionAnxious => 'Anxious';

  @override
  String get subEmotionBlessed => 'Blessed';

  @override
  String get subEmotionBored => 'Bored';

  @override
  String get subEmotionCalm => 'Calm';

  @override
  String get subEmotionCheerful => 'Cheerful';

  @override
  String get subEmotionConfident => 'Confident';

  @override
  String get subEmotionConfused => 'Confused';

  @override
  String get subEmotionDemoralized => 'Demoralized';

  @override
  String get subEmotionDetermined => 'Determined';

  @override
  String get subEmotionDistracted => 'Distracted';

  @override
  String get subEmotionDrained => 'Drained';

  @override
  String get subEmotionEmpty => 'Empty';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'Enthusiastic';

  @override
  String get subEmotionEuphoric => 'Euphoric';

  @override
  String get subEmotionExcited => 'Excited';

  @override
  String get subEmotionExhausted => 'Exhausted';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Guilty';

  @override
  String get subEmotionHappy => 'Happy';

  @override
  String get subEmotionHelpless => 'Helpless';

  @override
  String get subEmotionHopeful => 'Hopeful';

  @override
  String get subEmotionHopeless => 'Hopeless';

  @override
  String get subEmotionHurt => 'Hurt';

  @override
  String get subEmotionIndecisive => 'Indecisive';

  @override
  String get subEmotionInsecure => 'Insecure';

  @override
  String get subEmotionLonely => 'Lonely';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'Motivated';

  @override
  String get subEmotionNumb => 'Numb';

  @override
  String get subEmotionOrdinary => 'Ordinary';

  @override
  String get subEmotionOverwhelmed => 'Overwhelmed';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'Proud';

  @override
  String get subEmotionRegretful => 'Regretful';

  @override
  String get subEmotionSad => 'Sad';

  @override
  String get subEmotionSelection =>
      'Let\'s describe this feeling in more detail';

  @override
  String get subEmotionStressed => 'Stressed';

  @override
  String get subEmotionTired => 'Tired';

  @override
  String get subEmotionUnstoppable => 'Unstoppable';

  @override
  String get subscribeToEnjoyPremium => 'Subscribe to enjoy premium features';

  @override
  String get subscription => 'Subscription';

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
  String get success => 'Success';

  @override
  String get successfulDayLegend => 'Successful day';

  @override
  String successfulDaysCount(Object count) {
    return '$count Successful Days';
  }

  @override
  String get sundayShort => 'Sun';

  @override
  String get systemInfo => 'System Information';

  @override
  String get systemTheme => 'System theme';

  @override
  String get tapFabToCreate => 'Tap the + button to start';

  @override
  String get tapSpinToStart => 'Tap spin to start';

  @override
  String get tapToPickImage => 'Tap to pick image';

  @override
  String get target => 'Target';

  @override
  String get targetDurationMinutes => 'Target Duration (minutes)';

  @override
  String targetShort(Object value) {
    return 'Target: $value';
  }

  @override
  String get targetType => 'Target Type';

  @override
  String get targetValue => 'Target Value';

  @override
  String get targetValueLabel => 'Target Value';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'Task deleted';
  }

  @override
  String get taskDescription => 'Description (Optional)';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskTitleRequired => 'Task title is required';

  @override
  String get tellMeYourDream =>
      'Tell me your dream. I\'ll help you build a Vision Board.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'Template details not found';

  @override
  String get templatesTabManual => 'Manual';

  @override
  String get templatesTabReady => 'Ready';

  @override
  String get textLabel => 'Text';

  @override
  String get theWinnerIs => 'The winner is:';

  @override
  String get theme => 'Theme';

  @override
  String get themeAbyss => 'Abyss';

  @override
  String get themeAbyssDesc => 'Dark & Sophisticated';

  @override
  String get themeBlush => 'Blush';

  @override
  String get themeBlushDesc => 'Sweet & Feminine';

  @override
  String get themeCotton => 'Cotton';

  @override
  String get themeCottonDesc => 'Warm & Neutral';

  @override
  String get themeCream => 'Cream';

  @override
  String get themeCreamDesc => 'Warm & Soft';

  @override
  String get themeCrimson => 'Crimson';

  @override
  String get themeCrimsonDesc => 'Bold & Passionate';

  @override
  String get themeDetails => 'Theme Details';

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
  String get themeMauve => 'Mauve';

  @override
  String get themeMauveDesc => 'Elegant & Romantic';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightDesc => 'Deep & Mysterious';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeOceanDesc => 'Deep & Serene';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeRoseDesc => 'Soft & Warm';

  @override
  String get themeSelection => 'Theme Selection';

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
  String get thisMonth => 'This month';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisYear => 'This year';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst => 'Create a timer habit first';

  @override
  String get timerDescription => 'Time-based tracking';

  @override
  String get timerExample => 'Do a 30-minute workout';

  @override
  String get timerHabitLabel => 'Timer Habit';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Pending duration: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Pending: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Break';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Completed Work: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Long Break Cycle (e.g., 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Long Break (min)';

  @override
  String get timerPomodoroSettings => 'Pomodoro Settings';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Short Break (min)';

  @override
  String get timerPomodoroSkipPhase => 'Skip Phase';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Work (min)';

  @override
  String get timerPomodoroWorkPhase => 'Work';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => 'Save Duration';

  @override
  String get timerSaveSessionTitle => 'Save Session';

  @override
  String get timerSessionAlreadySaved => 'This session is already saved';

  @override
  String get timerSetDurationFirst => 'Set duration first';

  @override
  String get timerSettings => 'Timer Settings';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'Countdown';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Stopwatch';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'Timer';

  @override
  String get times => 'Times';

  @override
  String get timezone => 'Time Zone';

  @override
  String get titleHint => 'Ex: Groceries, Freelance, etc.';

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Today\'s Habits';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'Total Duration';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => 'Total progress';

  @override
  String get totalSuccessfulDays => 'Total successful days';

  @override
  String get totalUnsuccessfulDays => 'Total unsuccessful days';

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
  String get tuesdayShort => 'Tue';

  @override
  String get typeEmoji => 'Type an emoji';

  @override
  String get typeEmojiHint => 'Type an emoji from keyboard';

  @override
  String get typeLabel => 'Type';

  @override
  String get typeNotChangeable => 'Type cannot be changed';

  @override
  String get unassignLinkedDailyTasks => 'Unassign linked daily tasks';

  @override
  String get unassignLinkedHabits => 'Unassign linked habits';

  @override
  String get undo => 'Undo';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => 'Unit';

  @override
  String get unitAdet => 'pcs';

  @override
  String get unitAdim => 'step';

  @override
  String get unitBardak => 'glass';

  @override
  String get unitHint => 'Unit (glass, step, page...)';

  @override
  String get unitKalori => 'cal';

  @override
  String get unitKez => 'times';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'liter';

  @override
  String get unitSayfa => 'page';

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
  String get update => 'Update';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => 'Value';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSubtitle => 'Vibrate with notifications';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'Vision';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'This vision will use the last day in the template: $day.';
  }

  @override
  String get visionBoard => 'Vision Board';

  @override
  String get visionBoardDesc =>
      'Create a vision to organize your goals and track your journey';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'Create Vision';

  @override
  String get visionDurationDaysLabel => 'Duration (days)';

  @override
  String get visionDurationNote =>
      'Note: When the vision starts, a total duration is set; if the end day exceeds this duration it will be shortened automatically.';

  @override
  String get visionEditTitle => 'Edit Vision';

  @override
  String get visionEmptyDescription =>
      'Visualize your goals and add your first vision to turn your dreams into reality.';

  @override
  String get visionEndDayInvalid => 'End day must be between 1 and 365';

  @override
  String get visionEndDayLess => 'End day cannot be less than start day';

  @override
  String get visionEndDayQuestion =>
      'On which day of the vision should it end?';

  @override
  String get visionEndDayRequired => 'Enter the end day';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo =>
      'No end day specified. The vision will start open-ended.';

  @override
  String get visionPlural => 'Visions';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid => 'Start day must be between 1 and 365';

  @override
  String get visionStartDayQuestion =>
      'On which day of the vision should it start?';

  @override
  String get visionStartFailed => 'Could not start the vision.';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Vision started: $title';
  }

  @override
  String get visionTasks => 'Vision Tasks';

  @override
  String get visual => 'Visual';

  @override
  String get warmJournal => 'Warm Journal';

  @override
  String get warmJournalDesc => 'Warm journal & emotion tracking';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => 'Fri';

  @override
  String get weekdaysShortMon => 'Mon';

  @override
  String get weekdaysShortSat => 'Sat';

  @override
  String get weekdaysShortSun => 'Sun';

  @override
  String get weekdaysShortThu => 'Thu';

  @override
  String get weekdaysShortTue => 'Tue';

  @override
  String get weekdaysShortWed => 'Wed';

  @override
  String get weekly => 'Weekly';

  @override
  String get weeklyDesc => 'On specific days of the week';

  @override
  String get weeklyEmailSummary => 'Weekly email summary';

  @override
  String get weeklyProgress => 'Weekly progress';

  @override
  String get weeklySummaryEmail => 'Weekly summary email';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => 'What\'s the cause of this state?';

  @override
  String get wheelOfFortuneDescription => 'Add options and spin the wheel';

  @override
  String get wheelOfFortuneTitle => 'Wheel of Fortune';

  @override
  String get whichDaysActive => 'Which days should be active?';

  @override
  String get whichWeekdays => 'Which weekdays?';

  @override
  String get worldTheme => 'World';

  @override
  String get worldThemeDesc => 'Harmony of all colors';

  @override
  String get writeMessage => 'Write a message...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP to next level';
  }

  @override
  String get xpToNextLevel => 'to next level';

  @override
  String get yearly => 'Yearly';

  @override
  String get yearlyProgress => 'Yearly progress';

  @override
  String get yesNoDescription => 'Simple yes/no tracking';

  @override
  String get yesNoExample => 'Did I meditate today?';

  @override
  String get yesNoType => 'Yes/No';

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
  String get dailyHabitInfo => 'Daily habit info';

  @override
  String get whichDays => 'Which days';

  @override
  String get whichMonthDays => 'Which days of the month?';

  @override
  String get whichYearDays => 'Which year days';

  @override
  String everyNDays(Object days) {
    return 'Every $days days';
  }

  @override
  String nDays(Object days) {
    return '$days days';
  }

  @override
  String everyNDaysInfo(Object days) {
    return 'Occurs every $days days';
  }

  @override
  String get rhythmTeaserTitle =>
      'Maximize Your Habits Based on Your Biological Clock';

  @override
  String get rhythmTeaserSubtitle =>
      'Live Rhythm learns your most productive moments and places habits at the right time.';

  @override
  String get rhythmTeaserSkip => 'Skip';

  @override
  String get rhythmTeaserCta => 'View Packages';

  @override
  String get rhythmWindowFocus => 'Focus Time';

  @override
  String get rhythmWindowFocusDesc => 'Mental clarity, learning, analysis';

  @override
  String get rhythmWindowEnergy => 'Energy Time';

  @override
  String get rhythmWindowEnergyDesc => 'Movement, action, sports';

  @override
  String get rhythmWindowLight => 'Light Time';

  @override
  String get rhythmWindowLightDesc => 'Low effort, small tasks';

  @override
  String get rhythmWindowReflection => 'Reflection Time';

  @override
  String get rhythmWindowReflectionDesc => 'Journaling, contemplation, closure';

  @override
  String get rhythmBenefit1 => 'Right task at the right time';

  @override
  String get rhythmBenefit2 => 'No decision fatigue';

  @override
  String get rhythmBenefit3 => 'Personalization every week';

  @override
  String get rhythmAnalyzing => 'Live Rhythm is analyzing...';

  @override
  String get rhythmDisclaimer =>
      'These are not definitive results. Live Rhythm will adjust as it gets to know you.';

  @override
  String get rhythmQ1 => 'What time do you usually go to sleep?';

  @override
  String get rhythmQ2 => 'What time do you usually wake up?';

  @override
  String get rhythmQ3 => 'When do you tackle difficult tasks most comfortably?';

  @override
  String get rhythmQ4 => 'When do you feel most clear-headed for learning?';

  @override
  String get rhythmQ5 =>
      'During which part of the day do you feel more energetic?';

  @override
  String get rhythmQ6 => 'When does physical exercise feel easiest for you?';

  @override
  String get rhythmQ7 => 'At what time of day do you tend to procrastinate?';

  @override
  String get rhythmQ8 =>
      'What do you usually do during these low-energy times?';

  @override
  String get rhythmQ9 => 'At the end of the day, which feels better to you?';

  @override
  String get rhythmQ10 => 'How does your mind usually feel in the evening?';

  @override
  String get rhythmQ11 => 'Which do you identify with more?';

  @override
  String get rhythmA1_1 => '10:00 PM – 11:00 PM';

  @override
  String get rhythmA1_2 => '11:00 PM – 12:00 AM';

  @override
  String get rhythmA1_3 => '12:00 AM – 1:00 AM';

  @override
  String get rhythmA1_4 => '1:00 AM+';

  @override
  String get rhythmA2_1 => '6:00 AM – 7:00 AM';

  @override
  String get rhythmA2_2 => '7:00 AM – 8:00 AM';

  @override
  String get rhythmA2_3 => '8:00 AM – 9:00 AM';

  @override
  String get rhythmA2_4 => '9:00 AM+';

  @override
  String get rhythmA3_1 => 'Early morning';

  @override
  String get rhythmA3_2 => 'Mid-morning';

  @override
  String get rhythmA3_3 => 'Afternoon';

  @override
  String get rhythmA3_4 => 'Evening';

  @override
  String get rhythmA3_5 => 'No difference';

  @override
  String get rhythmA4_1 => 'Morning';

  @override
  String get rhythmA4_2 => 'Noon';

  @override
  String get rhythmA4_3 => 'Evening';

  @override
  String get rhythmA4_4 => 'Night';

  @override
  String get rhythmA4_5 => 'Varies';

  @override
  String get rhythmA5_1 => 'Morning';

  @override
  String get rhythmA5_2 => 'Noon';

  @override
  String get rhythmA5_3 => 'Evening';

  @override
  String get rhythmA5_4 => 'None';

  @override
  String get rhythmA5_5 => 'Fluctuates throughout the day';

  @override
  String get rhythmA6_1 => 'Morning';

  @override
  String get rhythmA6_2 => 'Afternoon';

  @override
  String get rhythmA6_3 => 'Evening';

  @override
  String get rhythmA6_4 => 'No difference';

  @override
  String get rhythmA7_1 => 'After noon';

  @override
  String get rhythmA7_2 => 'Late afternoon';

  @override
  String get rhythmA7_3 => 'Night';

  @override
  String get rhythmA7_4 => 'Not specific';

  @override
  String get rhythmA8_1 => 'I browse social media';

  @override
  String get rhythmA8_2 => 'I do simple tasks';

  @override
  String get rhythmA8_3 => 'I rest';

  @override
  String get rhythmA8_4 => 'I try to push through';

  @override
  String get rhythmA9_1 => 'Writing / thinking';

  @override
  String get rhythmA9_2 => 'Quiet rest';

  @override
  String get rhythmA9_3 => 'Reading';

  @override
  String get rhythmA9_4 => 'Going straight to sleep';

  @override
  String get rhythmA10_1 => 'Calm and collected';

  @override
  String get rhythmA10_2 => 'Tired but thoughtful';

  @override
  String get rhythmA10_3 => 'Scattered';

  @override
  String get rhythmA10_4 => 'Still active';

  @override
  String get rhythmA11_1 => 'I\'m a morning person';

  @override
  String get rhythmA11_2 => 'I\'m an evening person';

  @override
  String get rhythmA11_3 => 'I\'m in between';

  @override
  String get rhythmA11_4 => 'It changes seasonally';

  @override
  String get testsSection => 'Tests';

  @override
  String get retakePersonalityTestDesc => 'Rediscover your character type';

  @override
  String get retakeRhythmTest => 'Retake Rhythm Test';

  @override
  String get retakeRhythmTestDesc => 'Reconfigure your biological clock';

  @override
  String get rhythmWindowStepTitle => 'Best Time Window';

  @override
  String get rhythmWindowStepSubtitle =>
      'When would you like to do this habit?';

  @override
  String get rhythmWindowNoProfileHint =>
      'Complete the rhythm test to get personalized suggestions';
}
