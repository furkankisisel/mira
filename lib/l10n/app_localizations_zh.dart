// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get about => '关于';

  @override
  String get account => '账户';

  @override
  String get achievements => '成就';

  @override
  String get active => 'Active';

  @override
  String get activeDays => '活跃天数';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => '添加';

  @override
  String get addDate => '添加日期';

  @override
  String get addEvent => '添加活动';

  @override
  String get addFabTooltip => '添加';

  @override
  String get addFirstTransaction => 'Add first transaction';

  @override
  String get addHabit => '添加习惯';

  @override
  String get addHabitToRoomPrompt => '使用 + 按钮向房间添加习惯！';

  @override
  String get addImage => '添加图片';

  @override
  String get addNew => '添加新项';

  @override
  String get addNewHabit => '添加新习惯';

  @override
  String get addOptionHint => 'Add option...';

  @override
  String get addOptionsToStart => 'Add options to start';

  @override
  String get addRoomButton => 'Add Room';

  @override
  String get addSpecialDays => '添加特殊日子';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => '添加任务';

  @override
  String get addText => '添加文本';

  @override
  String get addToList => '添加到列表';

  @override
  String addedToRoomSnackbar(Object title) {
    return '$title 已添加到房间！🎯';
  }

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => '高级习惯';

  @override
  String get advancedHabitSubtitle => '高级版 • 通过详细设置创建习惯';

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
  String get aiAssistantTitle => 'Mira 助手';

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
  String get aiQuickGamification => '什么是经验值系统？';

  @override
  String get aiQuickHabit => 'Create a new habit';

  @override
  String get aiQuickMood => '分析我的心情';

  @override
  String get aiQuickMotivation => '给我动力';

  @override
  String get aiQuickProfile => '我的 AI 角色';

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
  String get allHabitsLabel => '所有习惯';

  @override
  String get allLabel => '全部';

  @override
  String get alsoDeleteLinkedHabits => '同时删除关联的习惯';

  @override
  String get amount => '数量';

  @override
  String get amountLabel => '金额';

  @override
  String get analysis => '分析';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => '外观';

  @override
  String get apply => '应用';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return '此愿景持续约 $days 天';
  }

  @override
  String get assetsReloadHint => '可能需要完全重启应用才能加载某些资产。';

  @override
  String get atLeast => '至少';

  @override
  String get atMost => '至多';

  @override
  String get autoBackupSubtitle => '每 24 小时自动将数据备份到 Google 云端硬盘。';

  @override
  String get autoBackupTitle => '自动备份';

  @override
  String get averageMood => '平均心情';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => '背景板';

  @override
  String get backupError => 'Backup Error';

  @override
  String get backupFailed => '备份失败';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String backupSuccess(Object id) {
    return '已备份: $id';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get badgeActive100dDesc => '在100个不同的日子里保持活跃';

  @override
  String get badgeActive100dTitle => '活跃100天';

  @override
  String get badgeActive30dDesc => '在30个不同的日子里保持活跃';

  @override
  String get badgeActive30dTitle => '活跃30天';

  @override
  String get badgeActive7dDesc => '在7个不同的日子里保持活跃';

  @override
  String get badgeActive7dTitle => '活跃7天';

  @override
  String get badgeCategoryActivity => '活动';

  @override
  String get badgeCategoryFinance => '财务';

  @override
  String get badgeCategoryHabit => '习惯';

  @override
  String get badgeCategoryLevel => '等级';

  @override
  String get badgeCategoryVision => '愿景';

  @override
  String get badgeCategoryXp => '经验值';

  @override
  String get badgeFin100Desc => '记录100笔交易';

  @override
  String get badgeFin100Title => '理财能手100';

  @override
  String get badgeFin10Desc => '记录10笔交易';

  @override
  String get badgeFin10Title => '理财能手10';

  @override
  String get badgeFin250Desc => '记录250笔交易';

  @override
  String get badgeFin250Title => '理财能手250';

  @override
  String get badgeFin50Desc => '记录50笔交易';

  @override
  String get badgeFin50Title => '理财能手50';

  @override
  String get badgeHabit100Desc => '总共完成100个习惯';

  @override
  String get badgeHabit100Title => '习惯100';

  @override
  String get badgeHabit10Desc => '总共完成10个习惯';

  @override
  String get badgeHabit10Title => '习惯10';

  @override
  String get badgeHabit200Desc => '总共完成200个习惯';

  @override
  String get badgeHabit200Title => '习惯200';

  @override
  String get badgeHabit50Desc => '总共完成50个习惯';

  @override
  String get badgeHabit50Title => '习惯50';

  @override
  String get badgeLevel10Desc => '达到10级';

  @override
  String get badgeLevel10Title => '10级';

  @override
  String get badgeLevel20Desc => '达到20级';

  @override
  String get badgeLevel20Title => '20级';

  @override
  String get badgeLevel5Desc => '达到5级';

  @override
  String get badgeLevel5Title => '5级';

  @override
  String get badgeVision10Desc => '创建10个愿景';

  @override
  String get badgeVision10Title => '愿景大师';

  @override
  String get badgeVision1Desc => '创建你的第一个愿景';

  @override
  String get badgeVision1Title => '远见者';

  @override
  String get badgeVision5Desc => '创建5个愿景';

  @override
  String get badgeVision5Title => '愿景专家';

  @override
  String get badgeVisionHabits3Desc => '将3个以上的习惯链接到一个愿景';

  @override
  String get badgeVisionHabits3Title => '连接者';

  @override
  String get badgeXp1000Desc => '总共获得1000经验值';

  @override
  String get badgeXp1000Title => '1000经验值';

  @override
  String get badgeXp500Desc => '总共获得500经验值';

  @override
  String get badgeXp500Title => '500经验值';

  @override
  String get badges => '徽章';

  @override
  String balanceParenthesis(Object balance) {
    return '(余额: $balance)';
  }

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => '介于1和360之间';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => '个人简介';

  @override
  String get bioHint => '关于您自己的简短传记';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => '休息';

  @override
  String get breakdownByCategory => '按类别细分';

  @override
  String get bringForward => '向前移动';

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
  String get cancel => '取消';

  @override
  String get cancelButton => '取消';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => '类别';

  @override
  String get categoryName => '类别名称';

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
  String get chooseBestCategory => '为你的习惯选择最佳类别';

  @override
  String get chooseColor => '选择颜色：';

  @override
  String get chooseEmoji => '选择表情符号：';

  @override
  String get choosePhoto => 'Choose Photo';

  @override
  String get choosePhotoDesc => 'Select a photo that inspires you';

  @override
  String get choosePhotoSubtitle => 'Choose a photo to motivate you';

  @override
  String get clear => '清除';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get clearHistory => '清除历史记录';

  @override
  String get close => '关闭';

  @override
  String get closeButton => '关闭';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'Decide between two options';

  @override
  String get coinFlipInstruction => 'Enter two options and flip the coin!';

  @override
  String get coinFlipTitle => 'Coin Flip';

  @override
  String get colorLabel => '颜色';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => '已完成（选定日期）';

  @override
  String get completedTableHeader => '完成';

  @override
  String get completionPercentLabel => '完成率 %';

  @override
  String completionsCount(Object count) {
    return '$count 次完成';
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
  String get continueText => '继续';

  @override
  String get copyButton => '复制';

  @override
  String get copyCodeTitle => '复制邀请码';

  @override
  String costTokens(Object cost) {
    return '消耗: $cost 代币';
  }

  @override
  String get cottonCandy => 'Cotton Candy';

  @override
  String get cottonCandyDesc => 'Cotton candy - pink & blue';

  @override
  String get countdownConfigureTitle => '配置倒计时';

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
  String get create => '创建';

  @override
  String get createAdvancedHabit => '创建高级习惯';

  @override
  String get createButton => '创建';

  @override
  String get createDailyTask => '创建每日任务';

  @override
  String get createFirstHabit => 'Create Habit';

  @override
  String get createFirstReportPrompt => '点击 + 创建您的第一份周报';

  @override
  String get createFirstVision => 'Create Your First Vision';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => '创建习惯模板';

  @override
  String get createHabitTitle => '创建习惯';

  @override
  String get createList => '创建列表';

  @override
  String get createNewCategory => '创建新类别';

  @override
  String get createNewList => '创建新列表';

  @override
  String get createReport => '创建报告';

  @override
  String get createRoomSubtitle => '创建一个新房间并邀请朋友';

  @override
  String get createRoomSuccessSnackbar => '房间已创建！🎉';

  @override
  String get createRoomTitle => '创建房间';

  @override
  String get createVision => '创建愿景';

  @override
  String get createVisionTemplateTitle => '创建愿景模板';

  @override
  String get createVisionWithAI => 'Create Vision with AI';

  @override
  String get createWithAi => 'Create with AI';

  @override
  String get creatingBackup => 'Creating Backup';

  @override
  String get currentStreak => '当前连续记录';

  @override
  String get custom => '自定义';

  @override
  String get customCategories => '自定义类别';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => '例如：✨';

  @override
  String get customEmojiOptional => '自定义表情符号（可选）';

  @override
  String get customEvent => '自定义活动';

  @override
  String get customFrequency => '自定义';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => '例如：份，组，公里...';

  @override
  String get daily => '每日';

  @override
  String get dailyCheck => '每日签到';

  @override
  String get dailyDesc => 'Every day';

  @override
  String get dailyHabitInfo => 'Daily habit info';

  @override
  String get dailyLimit => '每日限制';

  @override
  String get dailyTask => '每日任务';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return '每日任务已创建：$title';
  }

  @override
  String get dailyTaskSubtitle => '添加今天的特定任务';

  @override
  String get dailyTaskTitle => '每日任务';

  @override
  String get dailyTasksSection => '每日任务';

  @override
  String get darkTheme => '深色主题';

  @override
  String get dashboard => '仪表板';

  @override
  String get date => '日期';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => '五';

  @override
  String get dayMonShort => '一';

  @override
  String dayRangeShort(Object end, Object start) {
    return '第 $start–$end 天';
  }

  @override
  String get daySatShort => '六';

  @override
  String dayShort(Object day) {
    return '第 $day 天';
  }

  @override
  String get daySunShort => '日';

  @override
  String get dayThuShort => '四';

  @override
  String get dayTueShort => '二';

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
    return '$days天平均';
  }

  @override
  String daysCount(Object count) {
    return '$count 天';
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
  String get daysSuffixShort => '天';

  @override
  String get decisionEggDescription => 'Pick a mystical egg for answers';

  @override
  String get decisionEggTitle => 'Decision Egg';

  @override
  String get defaultUnit => '件';

  @override
  String get delete => '删除';

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
  String get deleteButton => '删除';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return '删除类别“$name”？';
  }

  @override
  String get deleteCategoryTitle => '删除类别';

  @override
  String get deleteCustomCategoryConfirm => '删除此自定义类别？';

  @override
  String get deleteEntryConfirm => '删除此条目？';

  @override
  String get deleteEvent => '删除活动';

  @override
  String deleteHabitConfirm(Object title) {
    return '删除习惯“$title”？';
  }

  @override
  String get deleteHabitTitle => '删除习惯';

  @override
  String get deleteListMessage => '此列表将被删除。选择如何处理关联的项目：';

  @override
  String get deleteListTitle => '删除列表';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get deleteRoomTitle => '删除房间';

  @override
  String get deleteRoomWarning => '该房间及其所有内容将被永久删除。是否继续？';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage => '您想删除此每日任务吗？此操作可以撤销。';

  @override
  String get deleteTaskConfirmTitle => '删除任务？';

  @override
  String deleteTransactionConfirm(Object title) {
    return '删除记录“$title”？';
  }

  @override
  String get deleteVisionMessage => '删除此愿景？';

  @override
  String get deleteVisionTitle => '删除愿景';

  @override
  String get descHint => '关于您习惯的详细信息（可选）';

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
  String get difficulty => '难度级别';

  @override
  String get drinkWater => 'Drink Water';

  @override
  String get duration => '持续时间';

  @override
  String get durationAutoLabel => '持续时间（自动）';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => '持续时间选择';

  @override
  String get durationType => '持续时间类型';

  @override
  String get earthTheme => '大地';

  @override
  String get earthThemeDesc => '大地色彩';

  @override
  String get easy => '简单';

  @override
  String get edit => '编辑';

  @override
  String get editButton => '编辑';

  @override
  String get editCategory => '编辑类别';

  @override
  String get editDeleteTooltip => '编辑 / 删除';

  @override
  String get editEvent => '编辑活动';

  @override
  String get editHabit => '编辑习惯';

  @override
  String get editListTitle => '编辑列表';

  @override
  String get editOnlyPersonalHabits => '你只能编辑添加到个人列表中的习惯。';

  @override
  String get education => '教育';

  @override
  String get eggRevealMessage => 'The mystical egg has spoken! ✨';

  @override
  String get eggSelectMessage => 'Think of a question and tap an egg 🥚';

  @override
  String get emojiAndColor => '表情符号和颜色';

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
  String get emojiLabel => '表情符号';

  @override
  String get emotionBlessed => '荣幸';

  @override
  String get emotionBored => '无聊';

  @override
  String get emotionConfident => '自信';

  @override
  String get emotionConfused => '困惑';

  @override
  String get emotionDistracted => '分心';

  @override
  String get emotionEuphoric => '欣快';

  @override
  String get emotionGuilty => '内疚';

  @override
  String get emotionHopeful => '充满希望';

  @override
  String get emotionInsecure => '不安全感';

  @override
  String get emotionLonely => '孤独';

  @override
  String get emotionNumb => '麻木';

  @override
  String get emotionOverwhelmed => '不知所措';

  @override
  String get emotionProud => '自豪';

  @override
  String get emotionRegretful => '后悔';

  @override
  String get emotionUnstoppable => '势不可挡';

  @override
  String get emptyHabitSubtitle =>
      'Create your first habit to begin tracking your progress.';

  @override
  String get emptyHabitTitle => 'Start Your Journey';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get enableReminder => '启用提醒';

  @override
  String get endDate => '结束日期';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => '结束日（可选）';

  @override
  String get endTime => '结束时间';

  @override
  String get enterBothOptions => 'Please enter both options';

  @override
  String get enterMonthlyPlanToComputeDailyLimit => '输入月度计划以计算每日限额。';

  @override
  String get enterNameAndDesc => '输入您习惯的名称和描述';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => '输入值';

  @override
  String get enterYourName => '输入您的姓名';

  @override
  String get entries => '条目';

  @override
  String get entryCountLabel => '记录次数';

  @override
  String get entrySaved => 'Entry saved successfully!';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get eventDescription => '描述';

  @override
  String get eventDetails => '活动详情';

  @override
  String get eventTitle => '活动标题';

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
  String get everyNDaysQuestion => '每隔几天？';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => '每天';

  @override
  String get exact => '精确';

  @override
  String get exactAlarmPermission => '精确闹钟权限（Android 12+）';

  @override
  String examplePrefix(Object example) {
    return '例如：$example';
  }

  @override
  String get expenseDelta => '支出Δ';

  @override
  String get expenseDistributionPie => '支出分布（饼图）';

  @override
  String get expenseEditTitle => '编辑支出';

  @override
  String get expenseLabel => '支出';

  @override
  String get expenseNewTitle => '新增支出';

  @override
  String failedToLoad(Object error) {
    return '加载失败：$error';
  }

  @override
  String get featureAdvancedFinance => 'Advanced Finance Features';

  @override
  String get featureAdvancedHabits => 'Advanced Habit Creation';

  @override
  String get featureAiBioClock => 'AI 驱动的生物钟';

  @override
  String get featureAiBioClockDesc => '基于您的生物节律的最佳时机';

  @override
  String get featureAiWeeklyReport => 'AI 驱动的每周报告';

  @override
  String get featureAiWeeklyReportDesc => '详细的 AI 进度分析';

  @override
  String get featureBackup => 'Backup Feature';

  @override
  String get featurePremiumThemes => '高级主题';

  @override
  String get featureVisionCreation => 'Vision Creation';

  @override
  String get feelingMoreSpecific => '能更具体一些吗？';

  @override
  String get filterTitle => '筛选';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => '财务';

  @override
  String get financeAddAiStatementOption => '使用AI上传账单/收据';

  @override
  String get financeAddAiStatementSubtitle => '从图片或PDF自动添加记录';

  @override
  String get financeAddManualOption => '手动添加';

  @override
  String financeAnalysisTitle(Object month) {
    return '财务分析 · $month';
  }

  @override
  String get financeLast7Days => '财务 · 最近7天';

  @override
  String get financeNet => '净额';

  @override
  String get finish => '完成';

  @override
  String get fitness => '健身';

  @override
  String get fixedDuration => '固定';

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
  String get font => '字体';

  @override
  String get forestTheme => '森林';

  @override
  String get forestThemeDesc => '自然绿色主题';

  @override
  String get forever => '永久';

  @override
  String get fortuneDisclaimer => '占卜仅供娱乐';

  @override
  String fortuneEggSemantic(int index) {
    return '运势蛋 $index';
  }

  @override
  String get fortuneEggsSubtitle => '选择一个蛋来揭示您的运势';

  @override
  String get fortuneNoQuestion => '您还没有提问';

  @override
  String get fortunePlay => '开始';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => '您想知道什么？';

  @override
  String get fortuneQuestionPrompt => '提出您的问题';

  @override
  String get fortuneResultTitle => '您的运势';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => '运势蛋';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => '频率';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => '周五';

  @override
  String get fullName => '全名';

  @override
  String get fullScreen => '全屏';

  @override
  String get gallery => '图库';

  @override
  String get gamesDescription =>
      'Having trouble deciding? Let fun games help you decide!';

  @override
  String get gamesTitle => '游戏';

  @override
  String get general => '通用';

  @override
  String get generalNotifications => '常规通知';

  @override
  String get generalRoomStatsHeader => '房间总体统计';

  @override
  String get generate => 'Generate';

  @override
  String generatedAtDate(Object date) {
    return '生成时间: $date';
  }

  @override
  String get generating => '生成中...';

  @override
  String get glasses => '眼镜';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => '金色';

  @override
  String get goldenThemeDesc => '温暖的金色主题';

  @override
  String get goodMorning => 'Good morning! ☀️';

  @override
  String get googleDrive => 'Google 云端硬盘';

  @override
  String get granted => '已授予';

  @override
  String get greatDayAhead => 'Today is a great day, you got this!';

  @override
  String get greetingAfternoon => '下午好';

  @override
  String get greetingEvening => '晚上好';

  @override
  String get greetingMorning => '早上好';

  @override
  String get guestAccount => 'Guest Account';

  @override
  String get guidedJourney => '引导式旅程';

  @override
  String get guidedJourneyDesc => 'Step-by-step guided flow';

  @override
  String get habit => '习惯';

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
  String get habitBlock => '习惯';

  @override
  String habitCreatedMessage(Object title) {
    return '习惯已创建：$title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return '习惯已删除：$title';
  }

  @override
  String get habitDescription => '描述';

  @override
  String get habitDescriptionHint => '添加简短描述...';

  @override
  String get habitDetails => '习惯详情';

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
  String get habitName => '习惯名称';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => '例如：喝水，阅读...';

  @override
  String get habitNameHintTimer => '例如：冥想，运动...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => '未找到习惯。';

  @override
  String get habitOfThisVision => '此愿景的习惯';

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
  String get habitReminders => '习惯提醒';

  @override
  String get habitRemindersSubtitle => '您习惯的每日提醒';

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
  String get habitUpdatedMessage => '习惯已更新。';

  @override
  String get habits => '习惯';

  @override
  String get habitsSection => '习惯';

  @override
  String get hard => '困难';

  @override
  String get hardMode => '困难模式';

  @override
  String get headerFocusLabel => '专注';

  @override
  String get headerFocusReady => '准备就绪';

  @override
  String get headerHabitsLabel => '习惯';

  @override
  String get health => '健康';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => '小时';

  @override
  String get hours => '小时';

  @override
  String get hoursSuffixShort => '小时';

  @override
  String get howAreYouFeeling => '您感觉如何？';

  @override
  String get howDoYouFeel => 'How do you feel today?';

  @override
  String get howOftenDoHabit => '决定你多久做一次你的习惯';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => '如何赚取';

  @override
  String get howToTrackHabit => '选择如何跟踪您的习惯';

  @override
  String get ifCondition => '如果';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => '从链接导入';

  @override
  String get importantNotice => '重要通知';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => '收入Δ';

  @override
  String get incomeEditTitle => '编辑收入';

  @override
  String get incomeLabel => '收入';

  @override
  String get incomeNewTitle => '新增收入';

  @override
  String get incompleteSelectedDay => '未完成（选定日期）';

  @override
  String get input => '输入';

  @override
  String get insights => 'Insights';

  @override
  String get insufficientTokensWatchAd => '代币不足！观看广告获取代币。';

  @override
  String get invalidCodeLengthError => '邀请码必须为 6 位';

  @override
  String get invalidLink => '无效链接。';

  @override
  String get invalidValue => '无效值';

  @override
  String get inviteCodeCopiedSnackbar => '邀请码已复制！';

  @override
  String get inviteCodeTooltip => '邀请码';

  @override
  String get issueDescription => 'Issue Description';

  @override
  String get issueDescriptionHint => 'Describe the issue in detail...';

  @override
  String get joinButton => '加入';

  @override
  String get joinRoomCodeMessage => '输入好友发给您的 6 位邀请码：';

  @override
  String get joinRoomSubtitle => '使用邀请码加入现有房间';

  @override
  String joinRoomSuccessSnackbar(Object roomName) {
    return '已加入 $roomName 房间！🎉';
  }

  @override
  String get joinRoomTitle => '加入房间';

  @override
  String joinedAtLabel(Object date) {
    return '加入时间：$date';
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
  String get justNow => '刚刚';

  @override
  String get keepItUp => 'Awesome! Keep it up! 💪';

  @override
  String get language => '语言';

  @override
  String get languageSelection => '语言选择';

  @override
  String get last7DaysProgressLabel => '最近 7 天的进度';

  @override
  String lastBackup(String date) {
    return '上次备份：$date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Lavender Dreams';

  @override
  String get lavenderDreamsDesc => 'Elegant lavender & purple tones';

  @override
  String get leaderboardDetailsTitle => '排名详情';

  @override
  String get leaveButton => '离开';

  @override
  String get leaveRoomTitle => '退出房间';

  @override
  String get leaveRoomWarning => '您确定要退出该房间吗？';

  @override
  String get letsPlayGame => 'Let\'s play! 🎮';

  @override
  String get letsStart => 'Let\'s Start';

  @override
  String levelLabel(Object level) {
    return '等级 $level';
  }

  @override
  String levelShort(Object level) {
    return 'L$level';
  }

  @override
  String get lightTheme => '浅色主题';

  @override
  String get likertAgree => '同意';

  @override
  String get likertDisagree => '不同意';

  @override
  String get likertNeutral => '中立';

  @override
  String get likertStronglyAgree => '非常同意';

  @override
  String get likertStronglyDisagree => '非常不同意';

  @override
  String get linkHabits => '关联习惯';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return '列表已创建：$title';
  }

  @override
  String get listLabel => '列表';

  @override
  String get listNameHint => '例如：健康';

  @override
  String get listNameLabel => '列表名称';

  @override
  String get loadingHabits => '正在加载习惯...';

  @override
  String get logout => '退出登录';

  @override
  String get longestStreak => '最长连续记录';

  @override
  String get longestStreakLabel => '最长连续记录';

  @override
  String get manageLists => '管理列表';

  @override
  String get manageListsSubtitle => '添加新列表、重命名或删除。';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => '管理订阅';

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
  String get meditation => '冥想';

  @override
  String get medium => '中等';

  @override
  String memberCountText(Object count) {
    return '$count 位成员';
  }

  @override
  String get memberHabitsLabel => '成员的习惯';

  @override
  String get memberProfileTitle => '成员资料';

  @override
  String get memberTableHeader => '成员';

  @override
  String membersCompletedStatus(Object completed, Object total) {
    return '$completed/$total 位成员已完成';
  }

  @override
  String membersCountText(Object count) {
    return '$count 人';
  }

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => '正念';

  @override
  String get mintFresh => '清新薄荷';

  @override
  String get mintFreshDesc => 'Fresh mint & turquoise tones';

  @override
  String get minutes => '分钟';

  @override
  String get minutesSuffixShort => '分钟';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get miraPremium => 'Mira 高级版';

  @override
  String get mondayShort => '周一';

  @override
  String get monthCount => '月数';

  @override
  String get monthCountHint => '例如：12';

  @override
  String get monthSuffixShort => '月';

  @override
  String get monthly => '每月';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'On specific days of the month';

  @override
  String get monthlyProgress => '每月进度';

  @override
  String get monthlyTrend => '月度趋势';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => '心情';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => '差';

  @override
  String get moodBadDesc => '度过艰难时期';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => '优秀';

  @override
  String get moodExcellentDesc => '感觉很棒';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => '追踪您的情绪健康';

  @override
  String get moodFlowTitle => '您感觉如何？';

  @override
  String get moodGood => '好';

  @override
  String get moodGoodDesc => '感觉积极';

  @override
  String get moodGreat => '很棒';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => '中性';

  @override
  String get moodNeutralDesc => '感觉还好';

  @override
  String get moodOk => '还行';

  @override
  String get moodSelection => '心情选择';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => '糟糕';

  @override
  String get moodTerribleDesc => '感觉非常低落';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get moodTrend => 'Mood Trend (Last 30 Days)';

  @override
  String get moreChartsButton => '更多图表';

  @override
  String get mostActiveMemberLabel => '最活跃成员';

  @override
  String get mostCommonEmotion => 'Most Common Emotion';

  @override
  String get mostCommonMood => 'Most Common Mood';

  @override
  String get mostCommonReason => 'Most Common Reason';

  @override
  String get motivation => '动力';

  @override
  String motivationBody(Object percent, Object period) {
    return '干得好！$period您已达到$percent%的成功率。';
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
    return '$title 正在等你 🚀';
  }

  @override
  String get mtdAverageShort => '月均';

  @override
  String get multiple => '多个';

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
  String get mysticTheme => '神秘';

  @override
  String get mysticThemeDesc => '神秘紫色主题';

  @override
  String nDays(Object days) {
    return '$days days';
  }

  @override
  String nDaysLabel(Object count) {
    return '$count 天';
  }

  @override
  String get nameHint => '例如：每日锻炼';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => '名称为必填项';

  @override
  String get nameYourVision => 'Name Your Vision';

  @override
  String get nameYourVisionDesc => 'Give your vision a meaningful name';

  @override
  String get nameYourVisionSubtitle => 'Give your vision a meaningful name';

  @override
  String get needAtLeastTwoOptions => 'Need at least 2 options';

  @override
  String get newCategory => '新类别';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => '新习惯';

  @override
  String get newList => '新列表';

  @override
  String get next => '下一步';

  @override
  String get nextLabel => '下一步';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get nextYear => '明年';

  @override
  String get noActiveHabitsForMember => '该成员尚未有活跃习惯。';

  @override
  String get noBackups => 'No Backups';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noBadgesEarned => '尚未获得勋章。';

  @override
  String get noDataLast7Days => '最近7天无数据';

  @override
  String get noDataThisMonth => '本月无数据';

  @override
  String get noEndDate => '无结束日期';

  @override
  String get noEndDayDefaultsDaily => '如果未设置结束日期，此习惯将默认每天出现。';

  @override
  String get noEntriesYet => '尚无条目';

  @override
  String get noEvents => '暂无活动';

  @override
  String get noExpenseInThisCategory => '此类别下无支出';

  @override
  String get noExpenses => '无支出';

  @override
  String get noExpensesThisMonth => '本月无支出';

  @override
  String get noHabitsAdded => '尚未添加任何习惯';

  @override
  String get noHabitsAddedYet => '尚未添加习惯。';

  @override
  String get noHabitsInRoom => '尚未添加任何习惯';

  @override
  String get noHistory => '无历史记录';

  @override
  String get noIncomeThisMonth => '本月无收入';

  @override
  String get noItemsMatchFilters => '没有与所选筛选器匹配的项目';

  @override
  String get noLeaderboardData => '暂无排名数据';

  @override
  String get noLinkedHabitsInVision => '没有与此愿景关联的习惯。';

  @override
  String get noMeasurableDataForMember => '该成员目前尚无衡量数据。';

  @override
  String get noMemberDataYet => '尚未有成员数据。';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noNotesYet => '暂无笔记';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noProgressYet => '暂无进度';

  @override
  String get noReadyVisionsFound => '未找到现成的愿景。';

  @override
  String get noRecordsThisMonth => '本月无记录';

  @override
  String get noReportsYet => '暂无报告';

  @override
  String get noRoomsJoinedMessage => '创建一个房间或使用邀请码加入一个。\n与好友一起实现目标！';

  @override
  String get noRoomsJoinedTitle => '您尚未加入任何房间';

  @override
  String get noStatsAvailable => '暂无统计数据';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => '尚未添加。';

  @override
  String get notGranted => '未授予';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => '未解锁';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get noteSharedSnackbar => '笔记已分享！✨';

  @override
  String get notesSection => '📝 笔记';

  @override
  String get notificationBehavior => '通知行为';

  @override
  String get notificationPermission => '通知权限';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notificationSettingsSubtitle => '配置您的通知偏好';

  @override
  String get notificationTroubleshooting =>
      '为确保通知正常工作：\\n\\n• 关闭电池优化\\n• 允许后台活动\\n• 确保通知权限已开启\\n• 检查\"勿扰模式\"';

  @override
  String get notificationTypes => '通知类型';

  @override
  String get notifications => '通知';

  @override
  String get notificationsMasterSubtitle => '管理所有应用通知';

  @override
  String get nudgeButtonLabel => '提醒';

  @override
  String get nudgeDefaultMessage => '👊 朋友，再努力一点！完成你的习惯。';

  @override
  String nudgeNotification(Object name) {
    return '👊 $name 正在提醒你！';
  }

  @override
  String nudgeSuccessSnackbar(Object displayName) {
    return '已提醒 $displayName！👊';
  }

  @override
  String nudgeTitle(Object displayName) {
    return '提醒 $displayName 👊';
  }

  @override
  String get numberLabel => '数字';

  @override
  String get numericExample => '每天喝8杯水';

  @override
  String get numericSettings => '数字目标设置';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => '数字目标跟踪';

  @override
  String get numericalGoalShort => '数字目标';

  @override
  String get numericalType => '数值';

  @override
  String get oceanTheme => '海洋';

  @override
  String get oceanThemeDesc => '宁静的蓝色主题';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => '确定';

  @override
  String get onDailyLimit => '您已达到每日限额。';

  @override
  String get onPeriodic => '按特定间隔';

  @override
  String get onSpecificMonthDays => '在特定月份的日期';

  @override
  String get onSpecificWeekdays => '在特定工作日';

  @override
  String get onSpecificYearDays => '在特定年份的日期';

  @override
  String get onboardingQ1 => '我喜欢尝试新的体验并探索陌生的事物。';

  @override
  String get onboardingQ10 => '我会提前规划重要的事件和任务。';

  @override
  String get onboardingQ11 => '相比于只坚持一种方法，我更喜欢尝试不同的方式。';

  @override
  String get onboardingQ12 => '在压力下我能保持冷静，并能迅速从挫折中恢复。';

  @override
  String get onboardingQ2 => '我保持环境整洁，并且更喜欢有条理的日常安排。';

  @override
  String get onboardingQ3 => '当我与他人在一起时会感到更有活力，并且喜欢社交聚会。';

  @override
  String get onboardingQ4 => '我更喜欢与他人合作，认为合作比竞争更有效。';

  @override
  String get onboardingQ5 => '我能冷静应对压力情境，很少感到焦虑。';

  @override
  String get onboardingQ6 => '我喜欢艺术、音乐或写作等创造性活动。';

  @override
  String get onboardingQ7 => '我会为自己设定明确目标，并努力实现它们。';

  @override
  String get onboardingQ8 => '相比独处，我更喜欢参加集体活动。';

  @override
  String get onboardingQ9 => '在做决定之前，我经常会考虑他人的感受。';

  @override
  String get onboardingQuizIntro => '回答一些问题，帮助我们更好地了解你的个性。这基于经过科学验证的心理学研究。';

  @override
  String get onboardingWelcomeDesc => '与你共同成长的个人习惯追踪器。让我们发现你的独特个性，并为你量身推荐习惯。';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Mira';

  @override
  String get once => '一次';

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
  String get other => '其他';

  @override
  String get outline => '轮廓';

  @override
  String get outlineColor => '轮廓颜色';

  @override
  String get overall => '总体';

  @override
  String get overallProgress => '总体进度';

  @override
  String get overview => 'Overview';

  @override
  String get pages => '页数';

  @override
  String get pastelColors => '柔和色彩';

  @override
  String get pause => '暂停';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => '定期的';

  @override
  String get periodicDesc => 'At regular intervals';

  @override
  String get periodicSelection => '定期选择';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Photo';

  @override
  String get pickFromCalendar => 'Pick from Calendar';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => '选择今天的心情';

  @override
  String get plannedMonthlySpend => '计划每月支出';

  @override
  String plansLoadError(Object error) {
    return '加载计划错误: $error';
  }

  @override
  String get plateColor => '底板颜色';

  @override
  String get playAgain => '再玩一次';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get pointsTableHeader => '积分';

  @override
  String get pomodoroAndCustomTimers => 'Pomodoro and custom timers';

  @override
  String get premiumBenefits => 'Premium benefits:';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumFeatureLabel => '高级版功能';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get premiumPlans => 'Premium Plans';

  @override
  String get previous => '上一步';

  @override
  String get previousYear => '上一年';

  @override
  String get prioritizeTaskSubtitle => 'Prioritize this task';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => '隐私与安全';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => '效率';

  @override
  String get profile => '个人资料';

  @override
  String get profileInfo => '个人资料信息';

  @override
  String get profileUpdated => '个人资料已更新';

  @override
  String get progressJourneyMessage => '随着你完成习惯，这张图会被你的成功逐步塑造 ✨';

  @override
  String get progressJourneyStarts => '进度旅程开始了';

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
  String get rankingAndHabitsSection => '🏆 排名与习惯';

  @override
  String get readBook => '看书';

  @override
  String get readyVisionsLoadFailed => '无法加载现成的愿景。';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => '健康';

  @override
  String get reasonOther => '其他';

  @override
  String get reasonPersonalGrowth => 'Personal Growth';

  @override
  String get reasonRelationship => 'Relationship';

  @override
  String get reasonSelection => 'What\'s the reason for this state?';

  @override
  String get reasonSocial => 'Social';

  @override
  String get reasonTitle => '原因';

  @override
  String get reasonWeather => 'Weather';

  @override
  String get reasonWork => '工作';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc => '在选定日期每月自动添加';

  @override
  String get recurringMonthlyTitle => '重复（每月）';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => '重新加载';

  @override
  String get remainingToday => '今日剩余';

  @override
  String get reminder => '提醒';

  @override
  String get reminderDisabled => 'Reminder Off';

  @override
  String get reminderEnabled => 'Reminder On';

  @override
  String get reminderFrequency => '提醒频率';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => '提醒设置';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get removeFromList => '从列表中删除';

  @override
  String get repeatEveryDay => '每天重复';

  @override
  String get repeatEveryNDays => '每N天重复一次';

  @override
  String get reportAlreadyExists => '本周报告已存在。';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reportCreatedSuccess => '报告已创建！ ✨';

  @override
  String get reset => '重置';

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
  String get restoreFailed => '恢复失败';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return '已下载: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Your data has been successfully restored. We recommend restarting the app for changes to take full effect.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retakePersonalityTestDesc => '重新发现您的性格类型';

  @override
  String get retakeRhythmTest => '重新进行节奏测试';

  @override
  String get retakeRhythmTestDesc => '重新配置您的生物钟';

  @override
  String get retry => '重试';

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
  String get rhythmA3_1 => '清晨';

  @override
  String get rhythmA3_2 => '上午中段';

  @override
  String get rhythmA3_3 => '下午';

  @override
  String get rhythmA3_4 => '傍晚';

  @override
  String get rhythmA3_5 => '没有区别';

  @override
  String get rhythmA4_1 => '早上';

  @override
  String get rhythmA4_2 => '中午';

  @override
  String get rhythmA4_3 => '傍晚';

  @override
  String get rhythmA4_4 => '夜晚';

  @override
  String get rhythmA4_5 => '不定';

  @override
  String get rhythmA5_1 => '早上';

  @override
  String get rhythmA5_2 => '中午';

  @override
  String get rhythmA5_3 => '傍晚';

  @override
  String get rhythmA5_4 => '没有';

  @override
  String get rhythmAnalyzing => 'Live Rhythm 正在分析...';

  @override
  String get rhythmBenefit1 => '在正确的时间做正确的事';

  @override
  String get rhythmBenefit2 => '没有决策疲劳';

  @override
  String get rhythmBenefit3 => '每周个性化';

  @override
  String get rhythmChronoEvening => '晚睡型 (夜猫子)';

  @override
  String get rhythmChronoIntermediate => '中间型 (平衡)';

  @override
  String get rhythmChronoMorning => '早起型 (晨型人)';

  @override
  String get rhythmDisclaimer => '这些不是最终结果。Live Rhythm 会随着对您的了解而调整。';

  @override
  String get rhythmEnergyHint => '锻炼、体育活动';

  @override
  String get rhythmFocusHint => '脑力工作、分析、学习';

  @override
  String get rhythmHabitSuggestionTitle => '推荐的时间段：';

  @override
  String get rhythmLightHint => '电子邮件、社交媒体、杂务';

  @override
  String get rhythmQ1 => '您通常几点睡觉？';

  @override
  String get rhythmQ2 => '您通常几点起床？';

  @override
  String get rhythmQ3 => '您什么时候最轻松地处理困难任务？';

  @override
  String get rhythmQ4 => '您什么时候感觉学习最清晰？';

  @override
  String get rhythmQ5 => '一天中哪个时段您感觉更有活力？';

  @override
  String get rhythmReflectionHint => '日记、阅读、放松';

  @override
  String get rhythmResultGotIt => '明白了，开始吧';

  @override
  String get rhythmResultSubtitle => '我们根据您的自然节奏规划了您的一天。';

  @override
  String get rhythmResultTitle => '您的生物钟概况';

  @override
  String get rhythmTeaserCta => '查看套餐';

  @override
  String get rhythmTeaserSkip => '跳过';

  @override
  String get rhythmTeaserSubtitle => 'Live Rhythm 学习您最高效的时刻，并在正确的时间安排习惯。';

  @override
  String get rhythmTeaserTitle => '根据您的生物钟最大化您的习惯';

  @override
  String get rhythmWindowEnergy => '能量时间';

  @override
  String get rhythmWindowEnergyDesc => '运动、行动、体育';

  @override
  String get rhythmWindowFocus => '专注时间';

  @override
  String get rhythmWindowFocusDesc => '精神清晰、学习、分析';

  @override
  String get rhythmWindowLight => '轻松时间';

  @override
  String get rhythmWindowLightDesc => '低强度、小任务';

  @override
  String get rhythmWindowNoProfileHint => '完成节奏测试以获取个性化建议';

  @override
  String get rhythmWindowReflection => '反思时间';

  @override
  String get rhythmWindowReflectionDesc => '日记、冥想、结束';

  @override
  String get rhythmWindowStepSubtitle => '您想什么时候做这个习惯？';

  @override
  String get rhythmWindowStepTitle => '最佳时间窗口';

  @override
  String get roomFabLabel => '房间';

  @override
  String get roomMembersLabel => '房间成员';

  @override
  String get roomNameHint => '例如：早起例行团队';

  @override
  String get roomNameLabel => '房间名称';

  @override
  String get roomNotFoundError => '未找到使用该邀请码的房间';

  @override
  String get roomSummaryHeader => '房间摘要';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return '规则：输入持续时间 ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return '规则：输入持续时间 ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return '规则：输入持续时间 = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return '规则：输入值 ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return '规则：输入值 ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return '规则：输入值 = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => '周六';

  @override
  String get save => '保存';

  @override
  String get saveButton => '保存';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => '已保存';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => '储蓄/预算计划';

  @override
  String get scheduleHabit => '设置您的习惯日程';

  @override
  String get scheduleLabel => '日程';

  @override
  String get schedulingOptions => '日程安排选项';

  @override
  String get seconds => '秒';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => '选择';

  @override
  String get selectAll => '全选';

  @override
  String get selectAtLeastOneDay => '请至少选择一天';

  @override
  String get selectCategory => '选择类别';

  @override
  String get selectDate => '选择日期';

  @override
  String get selectDay => '选择日期';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => '选择结束日期';

  @override
  String get selectFrequency => '选择频率';

  @override
  String get selectHabitLabel => '选择习惯';

  @override
  String get selectHabitType => '选择习惯类型';

  @override
  String get selectHabitsToAdd => '选择你想添加到日常中的习惯：';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc => '选择影响您心情的因素';

  @override
  String get selectReportType => '选择报告类型:';

  @override
  String get selectSubEmotion => '选择细分情绪';

  @override
  String get selectSubEmotionDesc => '选择更具体的情绪';

  @override
  String get selectTime => '选择时间';

  @override
  String get selectYourCurrentMood => '选择您当前的心情';

  @override
  String get selectYourMood => '选择您的心情';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => '后退';

  @override
  String get setAsTodayFocus => 'Set as Today\'s Focus';

  @override
  String get setVisionTimeline => 'Set the timeline for your vision';

  @override
  String get settings => '设置';

  @override
  String get shareAsLink => '以链接形式分享';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareButton => '分享';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareInviteCodeMessage => '与好友分享此邀请码：';

  @override
  String get shareLinkCopied => '分享链接已复制到剪贴板。';

  @override
  String get shareNoteHint => '分享你的想法...';

  @override
  String get shareNoteTitle => '分享笔记';

  @override
  String get shareNoteTooltip => '分享笔记';

  @override
  String get shareVision => '分享愿景';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => '洗牌';

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
  String get simpleHabitFrequencySubtitle => '设定你的目标';

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
  String get simpleHabitSubtitle => '快速创建一个习惯';

  @override
  String get simpleHabitTargetOne => '简单习惯（目标=1）';

  @override
  String get simpleHabitTitle => '简单习惯';

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
  String get simpleTypeShort => '简单';

  @override
  String get skip => '跳过';

  @override
  String get skipOnboarding => '跳过';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get social => '社交';

  @override
  String get socialFeaturesGuestMessage => '您需要使用 Google 登录才能创建房间并与好友一起跟踪进度。';

  @override
  String get socialFeaturesTitle => '社交功能';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get socialRoomsTitle => '社交房间';

  @override
  String get softCloud => 'Soft Cloud';

  @override
  String get softCloudDesc => 'Cloud-like, dreamy soft';

  @override
  String get softPeach => 'Soft Peach';

  @override
  String get softPeachDesc => 'Warm peach & cream tones';

  @override
  String get sound => '声音';

  @override
  String get soundAlerts => '声音提醒';

  @override
  String get soundSubtitle => '通知时播放声音';

  @override
  String get specificDaysOfMonth => '特定月份的日期';

  @override
  String get specificDaysOfWeek => '特定星期几';

  @override
  String get specificDaysOfYear => '特定年份的日期';

  @override
  String get spendingAdvisorNoBudget => '设置预算以获取建议。';

  @override
  String get spendingAdvisorOnTrack => '太棒了！您的预算正如期进行。';

  @override
  String get spendingAdvisorOverBudget => '您已超出预算。停止支出。';

  @override
  String spendingAdvisorSafe(Object amount) {
    return '您每天可以花费 $amount。';
  }

  @override
  String get spendingAdvisorTitle => '支出顾问';

  @override
  String spendingAdvisorWarning(Object amount) {
    return '将每日支出减少 $amount 以保持正轨。';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return '太棒了！您的支出比每日平均水平少$amount。';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return '警告！您的支出比每日平均水平多$amount。';
  }

  @override
  String get spin => 'SPIN';

  @override
  String get spinAgain => 'Spin Again';

  @override
  String get start => '开始';

  @override
  String get startDate => '开始日期';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => '开始日（1-365）';

  @override
  String get startJourney => '开始你的旅程';

  @override
  String get startTest => 'Start Test';

  @override
  String get startTestDesc =>
      'If you complete the test, you will get personalized suggestions and habit recommendations. You can skip this step if you wish.';

  @override
  String get startTestTitle => 'Do you want to start the personality test?';

  @override
  String get startTime => '开始时间';

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
  String get statusLabel => '状态';

  @override
  String get step => '步';

  @override
  String stepOf(Object current, Object total) {
    return '第 $current 步，共 $total 步';
  }

  @override
  String get steps => '步数';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return '$count 天连续记录';
  }

  @override
  String get streakIndicator => '连续记录指示器';

  @override
  String get streakIndicatorDesc => '显示火焰和冰雪效果';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => '愤怒';

  @override
  String get subEmotionAnxious => '焦虑';

  @override
  String get subEmotionBlessed => 'Blessed';

  @override
  String get subEmotionBored => 'Bored';

  @override
  String get subEmotionCalm => '平静';

  @override
  String get subEmotionCheerful => '愉快';

  @override
  String get subEmotionConfident => '自信';

  @override
  String get subEmotionConfused => 'Confused';

  @override
  String get subEmotionDemoralized => '士气低落';

  @override
  String get subEmotionDetermined => '坚定';

  @override
  String get subEmotionDistracted => 'Distracted';

  @override
  String get subEmotionDrained => '疲惫不堪';

  @override
  String get subEmotionEmpty => '空虚';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => '热情';

  @override
  String get subEmotionEuphoric => 'Euphoric';

  @override
  String get subEmotionExcited => '兴奋';

  @override
  String get subEmotionExhausted => '精疲力竭';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Guilty';

  @override
  String get subEmotionHappy => '快乐';

  @override
  String get subEmotionHelpless => '无助';

  @override
  String get subEmotionHopeful => '充满希望';

  @override
  String get subEmotionHopeless => '绝望';

  @override
  String get subEmotionHurt => '受伤';

  @override
  String get subEmotionIndecisive => '犹豫不决';

  @override
  String get subEmotionInsecure => 'Insecure';

  @override
  String get subEmotionLonely => 'Lonely';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => '有动力';

  @override
  String get subEmotionNumb => '麻木';

  @override
  String get subEmotionOrdinary => '普通';

  @override
  String get subEmotionOverwhelmed => 'Overwhelmed';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => '自豪';

  @override
  String get subEmotionRegretful => 'Regretful';

  @override
  String get subEmotionSad => '悲伤';

  @override
  String get subEmotionSelection => '细分情绪选择';

  @override
  String get subEmotionStressed => '压力大';

  @override
  String get subEmotionTired => '疲倦';

  @override
  String get subEmotionUnstoppable => '势不可挡';

  @override
  String get subscribeToEnjoyPremium => 'Subscribe to enjoy premium features';

  @override
  String get subscription => '订阅';

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
  String get successfulDayLegend => '成功日';

  @override
  String successfulDaysCount(Object count) {
    return '$count 个成功日';
  }

  @override
  String get sundayShort => '周日';

  @override
  String get systemInfo => '系统信息';

  @override
  String get systemTheme => '系统主题';

  @override
  String get tapFabToCreate => 'Tap the + button to start';

  @override
  String get tapSpinToStart => 'Tap spin to start';

  @override
  String get tapToPickImage => 'Tap to pick image';

  @override
  String get target => '目标';

  @override
  String get targetDurationMinutes => '目标持续时间（分钟）';

  @override
  String targetShort(Object value) {
    return '目标：$value';
  }

  @override
  String get targetType => '目标类型';

  @override
  String get targetValue => '目标值';

  @override
  String get targetValueLabel => '目标值';

  @override
  String get taskAdded => 'Task added';

  @override
  String taskAddedSnackbar(Object title) {
    return '$title 任务已添加！✅';
  }

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return '任务已删除：$title';
  }

  @override
  String get taskDescription => '描述（可选）';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => '任务标题';

  @override
  String get taskTitleRequired => '任务标题为必填项';

  @override
  String get tellMeYourDream =>
      'Tell me your dream. I\'ll help you build a Vision Board.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => '未找到模板详情';

  @override
  String get templatesTabManual => '手动';

  @override
  String get templatesTabReady => '现成';

  @override
  String get testsSection => '测试';

  @override
  String get textLabel => '文本';

  @override
  String get theWinnerIs => '获胜者是：';

  @override
  String get theme => '主题';

  @override
  String get themeAbyss => '深渊';

  @override
  String get themeAbyssDesc => 'Dark & Sophisticated';

  @override
  String get themeBlush => 'Blush';

  @override
  String get themeBlushDesc => 'Sweet & Feminine';

  @override
  String get themeCotton => '棉花';

  @override
  String get themeCottonDesc => 'Warm & Neutral';

  @override
  String get themeCream => '奶油';

  @override
  String get themeCreamDesc => 'Warm & Soft';

  @override
  String get themeCrimson => '绯红';

  @override
  String get themeCrimsonDesc => '大胆而充满激情';

  @override
  String get themeDetails => '主题详情';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeForestDesc => 'Rich & Organic';

  @override
  String get themeLavender => '薰衣草';

  @override
  String get themeLavenderDesc => 'Calm & Dreamy';

  @override
  String get themeMatcha => '抹茶';

  @override
  String get themeMatchaDesc => 'Fresh & Natural';

  @override
  String get themeMauve => '淡紫色';

  @override
  String get themeMauveDesc => '优雅而浪漫';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightDesc => '深邃且神秘';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeOceanDesc => 'Deep & Serene';

  @override
  String get themeRose => '玫瑰';

  @override
  String get themeRoseDesc => 'Soft & Warm';

  @override
  String get themeSelection => '主题选择';

  @override
  String get themeSky => '天空';

  @override
  String get themeSkyDesc => 'Airy & Light';

  @override
  String get themeSlate => '石板灰';

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
  String get thisMonth => '本月';

  @override
  String get thisWeek => '本周';

  @override
  String get thisYear => '今年';

  @override
  String get thursdayShort => '周四';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst => '请先创建一个计时器习惯';

  @override
  String get timerDescription => '基于时间的跟踪';

  @override
  String get timerExample => '进行30分钟的锻炼';

  @override
  String get timerHabitLabel => '计时器习惯';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return '待定持续时间：$duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return '待定：$duration';
  }

  @override
  String get timerPomodoroBreakPhase => '休息';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return '已完成工作：$count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel => '长休息周期（例如，4）';

  @override
  String get timerPomodoroLongBreakMinutesLabel => '长休息（分钟）';

  @override
  String get timerPomodoroSettings => '番茄钟设置';

  @override
  String get timerPomodoroShortBreakMinutesLabel => '短休息（分钟）';

  @override
  String get timerPomodoroSkipPhase => '跳过阶段';

  @override
  String get timerPomodoroWorkMinutesLabel => '工作（分钟）';

  @override
  String get timerPomodoroWorkPhase => '工作';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => '保存持续时间';

  @override
  String get timerSaveSessionTitle => '保存会话';

  @override
  String get timerSessionAlreadySaved => '此会话已保存';

  @override
  String get timerSetDurationFirst => '请先设置持续时间';

  @override
  String get timerSettings => '计时器设置';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => '倒计时';

  @override
  String get timerTabPomodoro => '番茄钟';

  @override
  String get timerTabStopwatch => '秒表';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => '计时器';

  @override
  String get times => '次数';

  @override
  String get timezone => '时区';

  @override
  String get titleHint => '例如：杂货，自由职业等';

  @override
  String get titleOptional => '标题（可选）';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Today\'s Habits';

  @override
  String get tokenEarnedSuccess => '获得 +1 代币！ 🎉';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => '总持续时间';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalMembersLabel => '成员总数';

  @override
  String get totalProgress => '总进度';

  @override
  String get totalSuccessfulDays => '总成功天数';

  @override
  String get totalUnsuccessfulDays => '总不成功天数';

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
  String get tuesdayShort => '周二';

  @override
  String get typeEmoji => 'Type an emoji from keyboard';

  @override
  String get typeEmojiHint => 'Type an emoji from keyboard';

  @override
  String get typeLabel => '类型';

  @override
  String get typeNotChangeable => '类型不可更改';

  @override
  String get unassignLinkedDailyTasks => '取消关联的每日任务';

  @override
  String get unassignLinkedHabits => '取消关联的习惯';

  @override
  String get undo => '撤销';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => '单位';

  @override
  String get unitAdet => '个';

  @override
  String get unitAdim => '步';

  @override
  String get unitBardak => '杯';

  @override
  String get unitHint => '单位（杯、步、页...）';

  @override
  String get unitKalori => '卡路里';

  @override
  String get unitKez => '次';

  @override
  String get unitKm => '公里';

  @override
  String get unitLitre => '升';

  @override
  String get unitSayfa => '页';

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
  String get valueLabel => '值';

  @override
  String get vibration => '振动';

  @override
  String get vibrationSubtitle => '通知时振动';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => '愿景';

  @override
  String visionAutoDurationInfo(Object day) {
    return '此愿景将使用模板中的最后一天：$day。';
  }

  @override
  String get visionBoard => '愿景板';

  @override
  String get visionBoardDesc =>
      'Create a vision to organize your goals and track your journey';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => '创建愿景';

  @override
  String get visionDurationDaysLabel => '持续时间（天）';

  @override
  String get visionDurationNote => '注意：愿景开始时，会设置总持续时间；如果结束日超过此持续时间，将自动缩短。';

  @override
  String get visionEditTitle => '编辑愿景';

  @override
  String get visionEmptyDescription =>
      'Visualize your goals and add your first vision to turn your dreams into reality.';

  @override
  String get visionEndDayInvalid => '结束日必须介于1和365之间';

  @override
  String get visionEndDayLess => '结束日不能小于开始日';

  @override
  String get visionEndDayQuestion => '愿景应该在哪一天结束？';

  @override
  String get visionEndDayRequired => '输入结束日';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo => '未指定结束日。愿景将无限期开始。';

  @override
  String get visionPlural => '愿景';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid => '开始日必须介于1和365之间';

  @override
  String get visionStartDayQuestion => '愿景应该在哪一天开始？';

  @override
  String get visionStartFailed => '无法启动愿景。';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return '愿景已启动：$title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => '视觉';

  @override
  String get warmJournal => 'Warm Journal';

  @override
  String get warmJournalDesc => 'Warm journal & emotion tracking';

  @override
  String get watchAdForToken => '观看广告 (+1 代币)';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => '周五';

  @override
  String get weekdaysShortMon => '周一';

  @override
  String get weekdaysShortSat => '周六';

  @override
  String get weekdaysShortSun => '周日';

  @override
  String get weekdaysShortThu => '周四';

  @override
  String get weekdaysShortTue => '周二';

  @override
  String get weekdaysShortWed => '周三';

  @override
  String get weekly => '每周';

  @override
  String get weeklyDesc => 'On specific days of the week';

  @override
  String get weeklyEmailSummary => '每周邮件摘要';

  @override
  String get weeklyProgress => '每周进度';

  @override
  String get weeklyReportsTitle => '周报';

  @override
  String get weeklySchedule => '每周';

  @override
  String get weeklySummaryEmail => '每周摘要邮件';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => '原因是什么？';

  @override
  String get wheelOfFortuneDescription => 'Add options and spin the wheel';

  @override
  String get wheelOfFortuneTitle => 'Wheel of Fortune';

  @override
  String get whichDays => 'Which days';

  @override
  String get whichDaysActive => '哪些天应该活跃？';

  @override
  String get whichMonthDays => '月份中的哪几天？';

  @override
  String get whichWeekdays => '星期几？';

  @override
  String get whichYearDays => 'Which year days';

  @override
  String get worldTheme => '世界';

  @override
  String get worldThemeDesc => '所有颜色的和谐';

  @override
  String get writeMessage => '写一条消息...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total 经验值 • $toNext 经验值到下一级';
  }

  @override
  String xpToNextLevel(Object toNext) {
    return '距离下一等级还需要';
  }

  @override
  String get yearly => '每年';

  @override
  String get yearlyProgress => '年度进展';

  @override
  String get yesNoDescription => '简单的“是/否”跟踪';

  @override
  String get yesNoExample => '我今天冥想了吗？';

  @override
  String get yesNoType => '是/否';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get youLabel => '你';

  @override
  String get yourCharacterType => 'Your Character Type';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get yourMoodToday => 'Your Mood Today';
}
