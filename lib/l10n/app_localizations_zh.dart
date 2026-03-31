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
  String get active => '活跃';

  @override
  String get activeDays => '活跃天数';

  @override
  String get adFreeExperience => '免广告体验';

  @override
  String get add => '添加';

  @override
  String get addDate => '添加日期';

  @override
  String get addEvent => '添加事件';

  @override
  String get addFabTooltip => '添加';

  @override
  String get addFirstTransaction => '添加首笔交易';

  @override
  String get addHabit => '添加习惯';

  @override
  String get addHabitToRoomPrompt => '使用 + 按钮在房间内添加一个习惯！';

  @override
  String get addImage => '添加图片';

  @override
  String get addNew => '新增';

  @override
  String get addNewHabit => '添加新习惯';

  @override
  String get addOptionHint => '添加选项...';

  @override
  String get addOptionsToStart => '添加选项以开始';

  @override
  String get addRoomButton => '添加房间';

  @override
  String get addSpecialDays => '添加特殊日期';

  @override
  String get addSubtask => '添加子任务';

  @override
  String get addTask => '添加任务';

  @override
  String get addText => '添加文本';

  @override
  String get addToList => '添加到列表';

  @override
  String addedToRoomSnackbar(Object title) {
    return '$title 已添加到房间！ 🎯';
  }

  @override
  String get advancedAnalysis => '高级分析';

  @override
  String get advancedAnalysisAndReports => '高级分析与报告';

  @override
  String get simpleHabit => '简单习惯';

  @override
  String get advancedHabit => '高级习惯';

  @override
  String get advancedHabitSubtitle => '高级版 • 通过详细设置创建习惯';

  @override
  String get advancedHabitTitle => '高级习惯';

  @override
  String get advancedHabitTypeDescription => '数值目标、计时器和详细跟踪。';

  @override
  String get advancedTimer => '高级计时器';

  @override
  String get aiAssistantOnline => '在线';

  @override
  String get aiAssistantTitle => 'Mira 助手';

  @override
  String aiContextMessage(Object tip) {
    return '您好！我注意到您对这个提示感兴趣：\n\n“$tip”\n\n需要我为您演示如何在 Mira 中应用它吗？';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return '通过 AI 已添加 $count 个习惯';
  }

  @override
  String get aiInputHint => '描述你想建立的习惯...';

  @override
  String get aiPoweredRecommendations => 'AI 动力推荐';

  @override
  String get aiPreviewTitle => 'AI 建议';

  @override
  String get aiQuickFinance => '预算建议';

  @override
  String get aiQuickGamification => 'XP 系统是什么？';

  @override
  String get aiQuickHabit => '创建新习惯';

  @override
  String get aiQuickMood => '分析我的情绪';

  @override
  String get aiQuickMotivation => '给我动力';

  @override
  String get aiQuickProfile => '我的 AI 人格';

  @override
  String get aiQuickTimer => '如何使用计时器？';

  @override
  String get aiQuickVision => '愿景板帮助';

  @override
  String get aiRetry => '重试（严格规则）';

  @override
  String get aiShowMeHow => '好的，教我怎么做';

  @override
  String get aiTip0 => '你知道吗？你可以为长期目标创建一个愿景板。';

  @override
  String get aiTip1 => '提示：使用计时器进行专注工作。';

  @override
  String get aiTip2 => '每天记录情绪，查看随时间变化的规律。';

  @override
  String get aiTip3 => '每天在同一时间进行，习惯会更容易养成。';

  @override
  String get aiTip4 => '将宏大的愿景分解为更小、更易管理的任务。';

  @override
  String get aiTip5 => '使用财务选项卡跟踪您的日常支出。';

  @override
  String get aiTip6 => '需要帮助？点击这里咨询 AI 助手！';

  @override
  String get aiTip7 => '坚持是关键！不要断开习惯链。';

  @override
  String get aiWelcomeMessage =>
      '你好！我是你的 Mira 助手。今天我能帮你什么？你可以向我咨询愿景、习惯、计时器或其他功能。';

  @override
  String get allDataDeleted => '所有数据已删除';

  @override
  String get allHabitsLabel => '所有习惯';

  @override
  String get allLabel => '全部';

  @override
  String get alsoDeleteLinkedHabits => '同时删除关联习惯';

  @override
  String get amount => '数量';

  @override
  String get amountLabel => '金额';

  @override
  String get analysis => '分析';

  @override
  String get analysisTooltip => '分析';

  @override
  String get annualPlanDesc => '12 个月连续访问';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => '外观';

  @override
  String get apply => '应用';

  @override
  String get applyCode => '应用代码';

  @override
  String get applying => '应用中...';

  @override
  String approxVisionDurationDays(Object days) {
    return '此愿景大约持续 $days 天';
  }

  @override
  String get assetsReloadHint => '加载某些资源可能需要完全重启应用。';

  @override
  String get atLeast => '至少';

  @override
  String get atMost => '最多';

  @override
  String get autoBackupSubtitle => '每 24 小时自动将数据备份到 Google 云端硬盘。';

  @override
  String get autoBackupTitle => '自动备份';

  @override
  String get averageMood => '平均情绪';

  @override
  String get back => '返回';

  @override
  String get backgroundPlate => '背景底板';

  @override
  String get backupError => '备份错误';

  @override
  String get backupFailed => '备份失败';

  @override
  String get backupNow => '立即备份';

  @override
  String get backupRestore => '备份与恢复';

  @override
  String backupSuccess(Object id) {
    return '备份完成：$id';
  }

  @override
  String get backupTitle => '备份';

  @override
  String get backupToDrive => '备份到云端硬盘';

  @override
  String get badgeActive100dDesc => '在 100 个不同的日子里保持活跃';

  @override
  String get badgeActive100dTitle => '100 天活跃';

  @override
  String get badgeActive30dDesc => '在 30 个不同的日子里保持活跃';

  @override
  String get badgeActive30dTitle => '30 天活跃';

  @override
  String get badgeActive7dDesc => '在 7 个不同的日子里保持活跃';

  @override
  String get badgeActive7dTitle => '7 天活跃';

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
  String get badgeFin100Desc => '记录 100 笔交易';

  @override
  String get badgeFin100Title => '理财达人 100';

  @override
  String get badgeFin10Desc => '记录 10 笔交易';

  @override
  String get badgeFin10Title => '理财达人 10';

  @override
  String get badgeFin250Desc => '记录 250 笔交易';

  @override
  String get badgeFin250Title => '理财达人 250';

  @override
  String get badgeFin50Desc => '记录 50 笔交易';

  @override
  String get badgeFin50Title => '理财达人 50';

  @override
  String get badgeHabit100Desc => '累计完成 100 次习惯';

  @override
  String get badgeHabit100Title => '习惯 100';

  @override
  String get badgeHabit10Desc => '累计完成 10 次习惯';

  @override
  String get badgeHabit10Title => '习惯 10';

  @override
  String get badgeHabit200Desc => '累计完成 200 次习惯';

  @override
  String get badgeHabit200Title => '习惯 200';

  @override
  String get badgeHabit50Desc => '累计完成 50 次习惯';

  @override
  String get badgeHabit50Title => '习惯 50';

  @override
  String get badgeLevel10Desc => '达到等级 10';

  @override
  String get badgeLevel10Title => '等级 10';

  @override
  String get badgeLevel20Desc => '达到等级 20';

  @override
  String get badgeLevel20Title => '等级 20';

  @override
  String get badgeLevel5Desc => '达到等级 5';

  @override
  String get badgeLevel5Title => '等级 5';

  @override
  String get badgeVision10Desc => '创建 10 个愿景';

  @override
  String get badgeVision10Title => '愿景大师';

  @override
  String get badgeVision1Desc => '创建第一个愿景';

  @override
  String get badgeVision1Title => '愿景家';

  @override
  String get badgeVision5Desc => '创建 5 个愿景';

  @override
  String get badgeVision5Title => '愿景专家';

  @override
  String get badgeVisionHabits3Desc => '将 3 个以上习惯与愿景挂钩';

  @override
  String get badgeVisionHabits3Title => '链接者';

  @override
  String get badgeXp1000Desc => '获得累计 1000 XP';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => '获得累计 500 XP';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => '勋章';

  @override
  String balanceParenthesis(Object balance) {
    return '(余额: $balance)';
  }

  @override
  String get becomePremium => '成为高级会员';

  @override
  String get becomePremiumShort => '加入高级版';

  @override
  String get between1And360 => '介于 1 到 360 之间';

  @override
  String get billingHistory => '账单记录';

  @override
  String get bio => '简介';

  @override
  String get bioHint => '关于您的简短介绍';

  @override
  String get breakLabel => '休息';

  @override
  String get breakTime => '休息时间';

  @override
  String get breakdownByCategory => '按类别细分';

  @override
  String get bringForward => '移至顶层';

  @override
  String bugReportFailedError(Object error) {
    return '无法发送错误报告：$error';
  }

  @override
  String bugReportFailedStatus(Object statusCode) {
    return '无法发送错误报告：$statusCode';
  }

  @override
  String get bugReportSentSuccess => '您的错误报告已成功发送。谢谢！';

  @override
  String get buyPremium => '购买高级版';

  @override
  String get canIGetRefund => '我可以退款吗？';

  @override
  String get cancel => '取消';

  @override
  String get cancelButton => '取消';

  @override
  String get cancelEffect => '您的订阅到期前，仍可继续使用高级功能。';

  @override
  String get cancelInstructions => 'Google Play 商店 → 订阅 → Mira Plus → 取消';

  @override
  String get cannotOpenPlayStore => '无法打开 Play 商店';

  @override
  String get category => '类别';

  @override
  String get categoryName => '类别名称';

  @override
  String get characterDescBalancedMindful =>
      '你是一个冷静、稳重且珍视内心平静的人。你擅长保持平衡，并以正念和从容的态度面对生活。';

  @override
  String get characterDescExplorer =>
      '你是一个充满好奇心、创造力且喜欢多样性的人。你热衷于学习新事物，并尝试用不同的方法应对生活的挑战。';

  @override
  String get characterDescPlanner =>
      '你是一个有组织、目标明确且注重结构的人。你擅长将梦想转化为可行的计划，并以自律的精神执行它们。';

  @override
  String get characterDescSocialConnector =>
      '你是一个热心、有同理心且能从人际关系中获得能量的人。你认为与他人建立联系并构建强大的社区很有意义。';

  @override
  String get characterTypeBalancedMindful => '平衡正念者';

  @override
  String get characterTypeExplorer => '探险家';

  @override
  String get characterTypePlanner => '规划者';

  @override
  String get characterTypeSocialConnector => '社交连接者';

  @override
  String get checkboxType => '复选框';

  @override
  String get checkboxTypeDesc => '简单标记';

  @override
  String get checkingPurchases => '正在检查购买项目...';

  @override
  String get chooseBestCategory => '为您的习惯选择最佳类别';

  @override
  String get chooseColor => '选择颜色：';

  @override
  String get chooseEmoji => '选择图标：';

  @override
  String get choosePhoto => '选择照片';

  @override
  String get choosePhotoDesc => '选择一张激发你灵感的照片';

  @override
  String get choosePhotoSubtitle => '选择一张让你有动力的照片';

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
  String get cloudBackup => '云端备份';

  @override
  String get coinFlipDescription => '在两个选项之间做决定';

  @override
  String get coinFlipInstruction => '输入两个选项并抛硬币！';

  @override
  String get coinFlipTitle => '抛硬币';

  @override
  String get colorLabel => '颜色';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get completeAllSubtasksToFinish => '完成所有子任务以完成习惯';

  @override
  String get completedSelectedDay => '已完成（选定日期）';

  @override
  String get completedTableHeader => '完成';

  @override
  String get completionPercentLabel => '完成百分比';

  @override
  String completionsCount(Object count) {
    return '已完成 $count 次';
  }

  @override
  String get confirmDeleteAccount => '确认删除账户';

  @override
  String get confirmHabits => '确认习惯';

  @override
  String get continueAsGuest => '以游客身份继续';

  @override
  String get continueButton => '继续';

  @override
  String get continueText => '继续';

  @override
  String get copyButton => '复制';

  @override
  String get copyCodeTitle => '复制代码';

  @override
  String costTokens(Object cost) {
    return '消耗：$cost 代币';
  }

  @override
  String get cottonCandy => '棉花糖';

  @override
  String get cottonCandyDesc => '棉花糖 - 粉色和蓝色';

  @override
  String get countdownConfigureTitle => '配置倒计时';

  @override
  String get countdownLabel => '倒计时';

  @override
  String get cozyJournal => '温馨日记';

  @override
  String get cozyJournalDesc => '棕色调与时间轴';

  @override
  String get crashReports => '崩溃报告';

  @override
  String get crashReportsSubtitle => '应用崩溃时发送匿名报告';

  @override
  String get create => '创建';

  @override
  String get createAdvancedHabit => '创建高级习惯';

  @override
  String get createButton => '创建';

  @override
  String get createDailyTask => '创建今日任务';

  @override
  String get createFirstHabit => '创建习惯';

  @override
  String get createFirstReportPrompt => '点击 + 按钮创建您的第一份周报';

  @override
  String get createFirstVision => '创建您的第一个愿景';

  @override
  String get createHabit => '创建习惯';

  @override
  String get createHabitAction => '创建习惯';

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
  String get createRoomSubtitle => '创建新房间并邀请朋友';

  @override
  String get createRoomSuccessSnackbar => '房间已创建！ 🎉';

  @override
  String get createRoomTitle => '创建房间';

  @override
  String get createVision => '创建愿景';

  @override
  String get createVisionTemplateTitle => '创建愿景模板';

  @override
  String get createVisionWithAI => '用人工智能创建愿景';

  @override
  String get createWithAi => '用 AI 创建';

  @override
  String get creatingBackup => '正在创建备份...';

  @override
  String get currentStreak => '当前连续天数';

  @override
  String get custom => '自定义';

  @override
  String get customCategories => '自定义类别';

  @override
  String get customEmoji => '自定义图标';

  @override
  String get customEmojiHint => '例如：✨';

  @override
  String get customEmojiOptional => '自定义图标（可选）';

  @override
  String get customEvent => '自定义事件';

  @override
  String get customFrequency => '自定义';

  @override
  String get customUnit => '自定义单位';

  @override
  String get customUnitHint => '例如：杯、组、公里...';

  @override
  String get daily => '每日';

  @override
  String get dailyCheck => '日常检查';

  @override
  String get dailyDesc => '每天进行';

  @override
  String get dailyHabitInfo => '每日习惯信息';

  @override
  String get dailyLimit => '每日上限';

  @override
  String get dailyTask => '今日任务';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return '今日任务已创建：$title';
  }

  @override
  String get dailyTaskSubtitle => '添加今日专属任务';

  @override
  String get dailyTaskTitle => '今日任务';

  @override
  String get dailyTasksSection => '今日任务';

  @override
  String get darkTheme => '深色主题';

  @override
  String get dashboard => '仪表板';

  @override
  String get date => '日期';

  @override
  String get dateRangeLabel => '日期范围';

  @override
  String get dayFriShort => '周五';

  @override
  String get dayMonShort => '周一';

  @override
  String dayRangeShort(Object end, Object start) {
    return '第 $start–$end 天';
  }

  @override
  String get daySatShort => '周六';

  @override
  String dayShort(Object day) {
    return '第 $day 天';
  }

  @override
  String get daySunShort => '周日';

  @override
  String get dayThuShort => '周四';

  @override
  String get dayTueShort => '周二';

  @override
  String get dayWedShort => '周三';

  @override
  String get days => '天';

  @override
  String daysAgo(Object days) {
    return '$days 天前';
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
  String get daysInterval => '天间隔';

  @override
  String get daysIntervalLabel => '天间隔';

  @override
  String daysLater(Object days) {
    return '$days 天后';
  }

  @override
  String get daysLeft => '剩余天数';

  @override
  String get daysRemaining => '剩余天数';

  @override
  String get daysSuffixShort => '天';

  @override
  String get decisionEggDescription => '选择一颗神秘彩蛋获取答案';

  @override
  String get decisionEggTitle => '决策蛋';

  @override
  String get defaultUnit => '个';

  @override
  String get delete => '删除';

  @override
  String get deleteAccountFailed => '删除账户失败';

  @override
  String get deleteAccountRequestSuccess => '您的注销请求已成功接收';

  @override
  String get deleteAccountSubtitle => '申请删除您的账户和数据';

  @override
  String get deleteAccountWarning => '此操作无法撤销。请确认与您账户关联的电子邮件地址。';

  @override
  String get deleteAction => '删除';

  @override
  String get deleteAllData => '删除所有数据';

  @override
  String get deleteAllDataConfirmContent => '您确定要删除所有应用数据吗？此操作无法撤销。';

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
  String get deleteEntryConfirm => '确定要删除此条目吗？';

  @override
  String get deleteEvent => '删除事件';

  @override
  String deleteHabitConfirm(Object title) {
    return '从房间删除“$title”？';
  }

  @override
  String get deleteHabitTitle => '删除习惯';

  @override
  String get deleteListMessage => '此列表将被删除。请选择关联项的处理方式：';

  @override
  String get deleteListTitle => '删除列表';

  @override
  String get deleteMyAccount => '注销账户';

  @override
  String get deleteRoomTitle => '删除房间';

  @override
  String get deleteRoomWarning => '此房间及其所有内容将被永久删除。是否继续？';

  @override
  String get deleteTaskConfirm => '您确定要删除此任务吗？';

  @override
  String get deleteTaskConfirmMessage => '删除此今日任务？此操作可以撤销。';

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
  String get descHint => '关于习惯的详细信息（可选）';

  @override
  String get descriptionHintOptional => '添加描述（可选）';

  @override
  String get descriptionLabel => '描述';

  @override
  String get detailedCharts => '详细图表和统计数据';

  @override
  String get diagnosticsData => '诊断数据';

  @override
  String get diagnosticsDataSubtitle => '共享匿名使用统计数据';

  @override
  String get difficulty => '难度级别';

  @override
  String get drinkWater => '喝水';

  @override
  String get duration => '时长';

  @override
  String get durationAutoLabel => '时长（自动）';

  @override
  String get durationIndefinite => '无限期';

  @override
  String durationMonths(Object count) {
    return '$count 个月';
  }

  @override
  String get durationSelection => '时长选择';

  @override
  String get durationType => '时长类型';

  @override
  String get earthTheme => '地球';

  @override
  String get earthThemeDesc => '大地色系';

  @override
  String get easy => '容易';

  @override
  String get edit => '编辑';

  @override
  String get editButton => '编辑';

  @override
  String get editCategory => '编辑类别';

  @override
  String get editDeleteTooltip => '编辑 / 删除';

  @override
  String get editEvent => '编辑事件';

  @override
  String get editHabit => '编辑习惯';

  @override
  String get editListTitle => '编辑列表';

  @override
  String get editOnlyPersonalHabits => '您只能编辑已添加到个人列表中的习惯。';

  @override
  String get education => '教育';

  @override
  String get eggRevealMessage => '神秘彩蛋给出了答案！ ✨';

  @override
  String get eggSelectMessage => '心想一个问题并点击彩蛋 🥚';

  @override
  String get emojiAndColor => '图标与颜色';

  @override
  String get emojiCategoryAnimals => '动物';

  @override
  String get emojiCategoryCare => '关怀';

  @override
  String get emojiCategoryFood => '食物';

  @override
  String get emojiCategoryHealth => '健康';

  @override
  String get emojiCategoryLife => '生活';

  @override
  String get emojiCategoryNature => '自然';

  @override
  String get emojiCategoryPopular => '热门';

  @override
  String get emojiCategoryProductivity => '效率';

  @override
  String get emojiCategorySport => '运动';

  @override
  String get emojiLabel => '图标';

  @override
  String get emotionBlessed => '幸运/被眷顾';

  @override
  String get emotionBored => '无聊';

  @override
  String get emotionConfident => '自信';

  @override
  String get emotionConfused => '困惑';

  @override
  String get emotionDistracted => '分心';

  @override
  String get emotionEuphoric => '欣喜若狂';

  @override
  String get emotionGuilty => '内疚';

  @override
  String get emotionHopeful => '充满希望';

  @override
  String get emotionInsecure => '缺乏安全感';

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
  String get emptyHabitSubtitle => '创建第一个习惯，开始追踪你的进度。';

  @override
  String get emptyHabitTitle => '开启旅程';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get enableReminder => '启用提醒';

  @override
  String get endDate => '结束日期';

  @override
  String get endDateLabel => '结束';

  @override
  String get endDayOptionalLabel => '结束天（可选）';

  @override
  String get endTime => '结束时间';

  @override
  String get enterBothOptions => '请输入两个选项';

  @override
  String get enterMonthlyPlanToComputeDailyLimit => '输入每月计划以计算每日限额。';

  @override
  String get enterNameAndDesc => '输入您的习惯名称和描述';

  @override
  String get enterPromoCode => '请输入优惠券代码';

  @override
  String get enterValueTitle => '输入数值';

  @override
  String get enterYourName => '输入您的姓名';

  @override
  String get entries => '条目';

  @override
  String get entryCountLabel => '条目数量';

  @override
  String get entrySaved => '条目保存成功！';

  @override
  String get errorPrefix => '错误：';

  @override
  String get eventDescription => '描述';

  @override
  String get eventDetails => '事件详情';

  @override
  String get eventTitle => '事件标题';

  @override
  String get every => '每';

  @override
  String get everyDay => '每天';

  @override
  String get everyLabel => '每';

  @override
  String everyNDays(Object days) {
    return '每 $days 天';
  }

  @override
  String everyNDaysInfo(Object days) {
    return '每 $days 天发生一次';
  }

  @override
  String get everyNDaysQuestion => '每隔多少天？';

  @override
  String everyXDays(Object periodicDays) {
    return '每 $periodicDays 天';
  }

  @override
  String get everyday => '每天';

  @override
  String get exact => '精确';

  @override
  String get exactAlarmPermission => '精确闹钟权限 (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return '例如：$example';
  }

  @override
  String get expenseDelta => '支出 Δ';

  @override
  String get expenseDistributionPie => '支出分布（饼图）';

  @override
  String get expenseEditTitle => '编辑支出';

  @override
  String get expenseLabel => '支出';

  @override
  String get expenseNewTitle => '新支出';

  @override
  String failedToLoad(Object error) {
    return '加载失败：$error';
  }

  @override
  String get featureAdvancedFinance => '高级财务功能';

  @override
  String get featureAdvancedHabits => '高级习惯创建';

  @override
  String get featureAiBioClock => 'AI 动力生物钟';

  @override
  String get featureAiBioClockDesc => '基于生物节律的最佳时机';

  @override
  String get featureAiWeeklyReport => 'AI 动力周报';

  @override
  String get featureAiWeeklyReportDesc => 'AI 详细分析您的进度';

  @override
  String get featureBackup => '备份功能';

  @override
  String get featurePremiumThemes => '高级主题';

  @override
  String get featureVisionCreation => '愿景创建';

  @override
  String get feelingMoreSpecific => '让我们更具体地描述这种感觉';

  @override
  String get filterTitle => '筛选';

  @override
  String get filterTooltip => '筛选';

  @override
  String get finance => '财务';

  @override
  String get financeAddAiStatementOption => '用 AI 上传账单/收据';

  @override
  String get financeAddAiStatementSubtitle => '通过图片或 PDF 自动添加记录';

  @override
  String get financeAddManualOption => '手动添加';

  @override
  String financeAnalysisTitle(Object month) {
    return '财务分析 · $month';
  }

  @override
  String get financeLast7Days => '财务 · 过去 7 天';

  @override
  String get financeNet => '净额';

  @override
  String get finish => '结束';

  @override
  String get fitness => '健身';

  @override
  String get fixedDuration => '固定';

  @override
  String get flexiblePlan => '灵活计划，随时取消';

  @override
  String get flipCoin => '抛硬币';

  @override
  String get focusLabel => '专注';

  @override
  String get focusedZen => '专注禅宗';

  @override
  String get focusedZenDesc => '极简风格，单一焦点';

  @override
  String get font => '字体';

  @override
  String get forestTheme => '森林';

  @override
  String get forestThemeDesc => '自然绿色主题';

  @override
  String get forever => '永久';

  @override
  String get fortuneDisclaimer => '仅供娱乐。';

  @override
  String fortuneEggSemantic(int index) {
    return '彩蛋 $index';
  }

  @override
  String get fortuneEggsSubtitle => '在下方选择一个彩蛋';

  @override
  String get fortuneNoQuestion => '你还没写问题';

  @override
  String get fortunePlay => '决定之蛋';

  @override
  String get fortuneProceedToEggs => '前往选择彩蛋';

  @override
  String get fortuneQuestionHint => '例如：这周我该尝试新鲜事物吗？';

  @override
  String get fortuneQuestionPrompt => '写下你心中的问题';

  @override
  String get fortuneResultTitle => '你的答案';

  @override
  String get fortuneSwipeInstruction => '左右滑动更换彩蛋，点击揭晓答案';

  @override
  String get fortuneTitle => '决定之蛋';

  @override
  String get freeTrial14Days => '14 天免费试用';

  @override
  String get frequency => '频率';

  @override
  String get frequencyLabel => '频率';

  @override
  String get fridayShort => '周五';

  @override
  String get fullName => '姓名';

  @override
  String get fullScreen => '全屏';

  @override
  String get gallery => '图库';

  @override
  String get gamesDescription => '犹豫不决？让趣味小游戏帮你决定！';

  @override
  String get gamesTitle => '游戏';

  @override
  String get general => '常规';

  @override
  String get generalNotifications => '常规通知';

  @override
  String get generalRoomStatsHeader => '房间总体统计';

  @override
  String get generate => '生成';

  @override
  String generatedAtDate(Object date) {
    return '生成于：$date';
  }

  @override
  String get generating => '正在生成...';

  @override
  String get glasses => '杯';

  @override
  String get goToPlayStore => '前往 Play 商店';

  @override
  String get goldenTheme => '金色';

  @override
  String get goldenThemeDesc => '温馨金色主题';

  @override
  String get goodMorning => '早安！ ☀️';

  @override
  String get googleDrive => 'Google 云端硬盘';

  @override
  String get granted => '已授权';

  @override
  String get greatDayAhead => '今天是美好的一天，你可以做到的！';

  @override
  String get greetingAfternoon => '下午好';

  @override
  String get greetingEvening => '晚上好';

  @override
  String get greetingMorning => '早上好';

  @override
  String get guestAccount => '游客账户';

  @override
  String get guidedJourney => '向导旅程';

  @override
  String get guidedJourneyDesc => '逐步向导流程';

  @override
  String get habit => '习惯';

  @override
  String habitAddError(Object error) {
    return '添加习惯时出错：$error';
  }

  @override
  String habitAddSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 个习惯',
      one: '已添加 1 个习惯',
      zero: '未添加习惯',
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
  String get habitExplorerCreativeProject => '创意项目时间';

  @override
  String get habitExplorerCreativeProjectDesc => '开展一个激发你想象力的创意项目。';

  @override
  String get habitExplorerExplorePlace => '探索新地点';

  @override
  String get habitExplorerExplorePlaceDesc => '去你所在地区的新的社区、公园或场所看看。';

  @override
  String get habitExplorerLearnNewSkill => '学习新东西';

  @override
  String get habitExplorerLearnNewSkillDesc => '每周抽出时间学习一项新技能或新课题。';

  @override
  String get habitExplorerReadDiverse => '阅读多样内容';

  @override
  String get habitExplorerReadDiverseDesc => '阅读不同类型和视角的书籍、文章或内容。';

  @override
  String get habitExplorerTryNewActivity => '尝试新活动';

  @override
  String get habitExplorerTryNewActivityDesc => '走出舒适区，体验一些不同的事情。';

  @override
  String get habitMindfulBreathing => '深呼吸练习';

  @override
  String get habitMindfulBreathingDesc => '练习深呼吸技巧以保持专注。';

  @override
  String get habitMindfulGratitude => '感恩练习';

  @override
  String get habitMindfulGratitudeDesc => '写下你今天感恩的三件事。';

  @override
  String get habitMindfulJournaling => '反思日记';

  @override
  String get habitMindfulJournalingDesc => '写日记记录你的想法和反思以提升自我意识。';

  @override
  String get habitMindfulMeditation => '冥想';

  @override
  String get habitMindfulMeditationDesc => '进行 10-15 分钟的正念冥想。';

  @override
  String get habitMindfulNatureWalk => '漫步自然';

  @override
  String get habitMindfulNatureWalkDesc => '在自然中正念漫步，留意你周围的环境。';

  @override
  String get habitName => '习惯名称';

  @override
  String get habitNameHint => '例如：读书、喝水...';

  @override
  String get habitNameHintNumerical => '例如：喝水、阅读页数...';

  @override
  String get habitNameHintTimer => '例如：冥想、运动...';

  @override
  String get habitNamePlaceholder => '习惯名称';

  @override
  String get habitNotFound => '未找到习惯。';

  @override
  String get habitOfThisVision => '此愿景的习惯';

  @override
  String get habitPlannerGoalSetting => '月度目标设定';

  @override
  String get habitPlannerGoalSettingDesc => '为下个月设定具体、可衡量的目标。';

  @override
  String get habitPlannerMorningRoutine => '晨间常规';

  @override
  String get habitPlannerMorningRoutineDesc => '每天以结构化的晨间常规开始，为高效的一天奠定基础。';

  @override
  String get habitPlannerTaskPrioritization => '每日任务优先级';

  @override
  String get habitPlannerTaskPrioritizationDesc => '每天早晨确定当天最重要的 3 个任务。';

  @override
  String get habitPlannerTimeBlocking => '时间块';

  @override
  String get habitPlannerTimeBlockingDesc => '将你的一天安排在专注的时间块中进行深度工作。';

  @override
  String get habitPlannerWeeklyReview => '每周回顾';

  @override
  String get habitPlannerWeeklyReviewDesc => '每周日回顾本周进度并规划下周。';

  @override
  String get habitReminderBody => '该完成你的习惯了！';

  @override
  String get habitReminders => '习惯提醒';

  @override
  String get habitRemindersSubtitle => '习惯的每日提醒';

  @override
  String get habitSocialCallFriend => '给朋友打电话';

  @override
  String get habitSocialCallFriendDesc => '与朋友或家人进行一次有意义的谈话。';

  @override
  String get habitSocialCompliment => '给予真诚的赞美';

  @override
  String get habitSocialComplimentDesc => '用真诚的赞美照亮某人的一天。';

  @override
  String get habitSocialFamilyTime => '高质量家庭时间';

  @override
  String get habitSocialFamilyTimeDesc => '与家人共度专注的时间，不受干扰。';

  @override
  String get habitSocialGroupActivity => '参加集体活动';

  @override
  String get habitSocialGroupActivityDesc => '参加集体活动或社交活动。';

  @override
  String get habitSocialVolunteer => '志愿服务';

  @override
  String get habitSocialVolunteerDesc => '通过志愿工作回馈社区。';

  @override
  String get habitTypeLabel => '习惯类型';

  @override
  String get habitTypePickerSubtitle => '您想创建哪种习惯？';

  @override
  String get habitTypePickerTitle => '选择习惯类型';

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
  String get helpAndSupport => '帮助与支持';

  @override
  String get history => '历史记录';

  @override
  String get historyTitle => '历史记录';

  @override
  String get hourShort => '小时';

  @override
  String get hours => '小时';

  @override
  String get hoursSuffixShort => '小时';

  @override
  String get howAreYouFeeling => '你感觉怎么样？';

  @override
  String get howDoYouFeel => '你今天感觉如何？';

  @override
  String get howOftenDoHabit => '决定你执行习惯的频率';

  @override
  String get howToCancel => '如何取消？';

  @override
  String get howToEarn => '如何获得';

  @override
  String get howToTrackHabit => '选择追踪习惯的方式';

  @override
  String get ifCondition => '如果';

  @override
  String get ifTrialCancelled => '如果取消免费试用？';

  @override
  String get importFromLink => '从链接导入';

  @override
  String get importantNotice => '重要提示';

  @override
  String get inactive => '未激活';

  @override
  String get incomeDelta => '收入 Δ';

  @override
  String get incomeEditTitle => '编辑收入';

  @override
  String get incomeLabel => '收入';

  @override
  String get incomeNewTitle => '新收入';

  @override
  String get incompleteSelectedDay => '未完成（选定日期）';

  @override
  String get input => '输入';

  @override
  String get insights => '见解';

  @override
  String get insufficientTokensWatchAd => '代币不足！观看广告以赚取代币。';

  @override
  String get invalidCodeLengthError => '代码必须为 6 个字符';

  @override
  String get invalidLink => '无效链接。';

  @override
  String get invalidValue => '无效值';

  @override
  String get inviteCodeCopiedSnackbar => '邀请码已复制！';

  @override
  String get inviteCodeTooltip => '邀请码';

  @override
  String get issueDescription => '问题描述';

  @override
  String get issueDescriptionHint => '详细描述该问题...';

  @override
  String get joinButton => '加入';

  @override
  String get joinRoomCodeMessage => '输入朋友发给你的 6 位邀请码：';

  @override
  String get joinRoomSubtitle => '使用邀请码加入现有房间';

  @override
  String joinRoomSuccessSnackbar(Object roomName) {
    return '已加入 $roomName 房间！ 🎉';
  }

  @override
  String get joinRoomTitle => '加入房间';

  @override
  String joinedAtLabel(Object date) {
    return '加入于：$date';
  }

  @override
  String get journalEntry => '日记记录';

  @override
  String get journalEntryDesc => '今天有什么想写的吗？';

  @override
  String get journalHint => '今天想写点什么...';

  @override
  String get jsonDataExample => 'JSON 数据（示例）：';

  @override
  String get justNow => '刚刚';

  @override
  String get keepItUp => '太棒了！继续保持！ 💪';

  @override
  String get language => '语言';

  @override
  String get languageSelection => '语言选择';

  @override
  String get last7DaysProgressLabel => '过去 7 天进度';

  @override
  String lastBackup(String date) {
    return '上次备份：$date';
  }

  @override
  String get later => '以后';

  @override
  String get lavenderDreams => '薰衣草之梦';

  @override
  String get lavenderDreamsDesc => '优雅的薰衣草和紫色调';

  @override
  String get leaderboardDetailsTitle => '排行榜详情';

  @override
  String get leaveButton => '离开';

  @override
  String get leaveRoomTitle => '离开房间';

  @override
  String get leaveRoomWarning => '您确定要离开这个房间吗？';

  @override
  String get letsPlayGame => '我们来玩吧！ 🎮';

  @override
  String get letsStart => '开始吧';

  @override
  String levelLabel(Object level) {
    return '等级 $level';
  }

  @override
  String levelShort(Object level) {
    return 'Lv$level';
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
    return '列表已创建：$title';
  }

  @override
  String listCreatedMessage(Object title) {
    return '列表创建成功';
  }

  @override
  String get listLabel => '列表';

  @override
  String get listNameHint => '例如：健康';

  @override
  String get listNameLabel => '列表名称';

  @override
  String get loadingHabits => '加载习惯中...';

  @override
  String get logout => '注销';

  @override
  String get longestStreak => '最长连续天数';

  @override
  String get longestStreakLabel => '最长连续天数';

  @override
  String get manageLists => '管理列表';

  @override
  String get manageListsSubtitle => '新增、重命名或删除列表。';

  @override
  String get manageOnGooglePlay => '在 Google Play 上管理';

  @override
  String get manageSubscription => '管理订阅';

  @override
  String get manageSubscriptionDesc => '更改计划、取消或查看账单详情';

  @override
  String get manageSubscriptionSubtitle => '通过 Google Play 管理 Mira Plus 订阅';

  @override
  String get manageVisionTasks => '管理任务';

  @override
  String get manualFallback => '手动创建';

  @override
  String get maxOptionsReached => '最多允许 12 个选项';

  @override
  String get meditation => '冥想';

  @override
  String get medium => '中等';

  @override
  String memberCountText(Object count) {
    return '$count 名成员';
  }

  @override
  String get memberHabitsLabel => '成员习惯';

  @override
  String get memberProfileTitle => '成员资料';

  @override
  String get memberTableHeader => '成员';

  @override
  String membersCompletedStatus(Object completed, Object total) {
    return '$completed/$total 名成员已完成';
  }

  @override
  String membersCountText(Object count) {
    return '$count 人';
  }

  @override
  String get minLabel => '分钟';

  @override
  String get mindfulness => '正念';

  @override
  String get mintFresh => '清新薄荷';

  @override
  String get mintFreshDesc => '清新薄荷与蓝绿色调';

  @override
  String get minutes => '分钟';

  @override
  String get minutesSuffixShort => '分钟';

  @override
  String get miraPlusActive => 'Mira Plus 已激活';

  @override
  String get miraPlusInactive => 'Mira Plus 未激活';

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
    return '每月第 $days 天';
  }

  @override
  String get monthlyDesc => '在每月特定日期';

  @override
  String get monthlyProgress => '月进度';

  @override
  String get monthlyTrend => '月趋势';

  @override
  String get monthsShort => '1月,2月,3月,4月,5月,6月,7月,8月,9月,10月,11月,12月';

  @override
  String get mood => '情绪';

  @override
  String get moodAnalytics => '情绪分析';

  @override
  String get moodBad => '不好';

  @override
  String get moodBadDesc => '我过得很糟糕';

  @override
  String get moodDeclining => '您的情绪似乎在下滑';

  @override
  String get moodDistribution => '情绪分布';

  @override
  String get moodExcellent => '极好';

  @override
  String get moodExcellentDesc => '我感觉棒极了';

  @override
  String get moodFlow => '情绪流';

  @override
  String get moodFlowSubtitle => '追踪您的情感健康';

  @override
  String get moodFlowTitle => '你感觉如何？';

  @override
  String get moodGood => '好';

  @override
  String get moodGoodDesc => '我感觉很积极';

  @override
  String get moodGreat => '非常好';

  @override
  String get moodImproving => '您的情绪正在好转！';

  @override
  String get moodNeutral => '一般';

  @override
  String get moodNeutralDesc => '我感觉一般';

  @override
  String get moodOk => '一般';

  @override
  String get moodSelection => '情绪选择';

  @override
  String get moodStable => '您的情绪相对稳定';

  @override
  String get moodTerrible => '糟糕';

  @override
  String get moodTerribleDesc => '我感觉非常糟糕';

  @override
  String get moodTracker => '情绪追踪';

  @override
  String get moodTrend => '情绪趋势（过去 30 天）';

  @override
  String get moreChartsButton => '更多图表';

  @override
  String get mostActiveMemberLabel => '最活跃成员';

  @override
  String get mostCommonEmotion => '最常见的感受';

  @override
  String get mostCommonMood => '最常见的情绪';

  @override
  String get mostCommonReason => '最常见的原因';

  @override
  String get motivation => '动力';

  @override
  String motivationBody(Object percent, Object period) {
    return '干得好！在 $period 内，您的成功率达到了 $percent%。';
  }

  @override
  String motivationDayStart(Object title) {
    return '$title 的美好一天！ 🌟';
  }

  @override
  String get motivationJourneyStart => '千里之行，始于足下！';

  @override
  String get motivationSmallSteps => '从小步开始，达成宏大目标 💪';

  @override
  String motivationWaiting(Object title) {
    return '$title 正等着你 🚀';
  }

  @override
  String get mtdAverageShort => '本月至今平均';

  @override
  String get multiple => '多个';

  @override
  String get multipleSubItems => '多个子项';

  @override
  String get multipleSubItemsDesc => '多个子项';

  @override
  String get mustBePremiumToUse => '您必须是高级版订阅者才能使用此功能。';

  @override
  String get myBigGoal => '我的大目标';

  @override
  String get myBoard => '我的愿景板';

  @override
  String get mysticTheme => '神秘';

  @override
  String get mysticThemeDesc => '神秘紫色主题';

  @override
  String nDays(Object days) {
    return '$days 天';
  }

  @override
  String nDaysLabel(Object count) {
    return '$count 天';
  }

  @override
  String get nameHint => '例如：每日健身';

  @override
  String get nameLabel => '名称';

  @override
  String get nameRequired => '名称是必填项';

  @override
  String get nameYourVision => '为愿景命名';

  @override
  String get nameYourVisionDesc => '给愿景起一个有意义的名字';

  @override
  String get nameYourVisionSubtitle => '给愿景起一个有意义的名字';

  @override
  String get needAtLeastTwoOptions => '至少需要 2 个选项';

  @override
  String get newCategory => '新类别';

  @override
  String get newHabit => '新习惯';

  @override
  String get newHabits => '新习惯';

  @override
  String get newList => '新列表';

  @override
  String get next => '下一步';

  @override
  String get nextLabel => '下一步';

  @override
  String get nextWeek => '下周';

  @override
  String get nextYear => '明年';

  @override
  String get noActiveHabitsForMember => '该成员尚无活跃习惯。';

  @override
  String get noBackups => '未找到备份';

  @override
  String get noBackupsFound => '未找到备份。';

  @override
  String get noBadgesEarned => '尚未获得勋章。';

  @override
  String get noDataLast7Days => '过去 7 天没有数据';

  @override
  String get noDataThisMonth => '本月没有数据';

  @override
  String get noEndDate => '无结束日期';

  @override
  String get noEndDayDefaultsDaily => '未设置结束天时，该习惯默认每天显示。';

  @override
  String get noEntriesYet => '尚无条目';

  @override
  String get noEvents => '尚无事件';

  @override
  String get noExpenseInThisCategory => '此类别下没有支出';

  @override
  String get noExpenses => '没有支出';

  @override
  String get noExpensesThisMonth => '本月没有支出';

  @override
  String get noHabitsAdded => '尚未添加习惯';

  @override
  String get noHabitsAddedYet => '尚未添加任何习惯。';

  @override
  String get noHabitsInRoom => '房间内尚未添加习惯';

  @override
  String get noHistory => '没有历史记录';

  @override
  String get noIncomeThisMonth => '本月没有收入';

  @override
  String get noItemsMatchFilters => '没有匹配当前筛选条件的项';

  @override
  String get noLeaderboardData => '暂无排行榜数据';

  @override
  String get noLinkedHabitsInVision => '愿景中没有关联习惯。';

  @override
  String get noMeasurableDataForMember => '该成员尚无测量数据。';

  @override
  String get noMemberDataYet => '尚无成员数据。';

  @override
  String get noMoodData => '尚无情绪数据';

  @override
  String get noNotesYet => '尚无笔记';

  @override
  String get noPlansAvailable => '目前没有可显示的计划。';

  @override
  String get noProgressYet => '尚无进度';

  @override
  String get noReadyVisionsFound => '未找到现成的愿景。';

  @override
  String get noRecordsThisMonth => '本月没有记录';

  @override
  String get noReportsYet => '尚无报告';

  @override
  String get noRoomsJoinedMessage => '创建一个房间或通过邀请码加入房间。\n和朋友一起达成目标！';

  @override
  String get noRoomsJoinedTitle => '您尚未加入任何房间';

  @override
  String get noStatsAvailable => '暂无统计数据';

  @override
  String get noTasksYet => '尚未添加任务';

  @override
  String get noTrendData => '数据不足，无法显示趋势';

  @override
  String get notAddedYet => '尚未添加。';

  @override
  String get notGranted => '未授权';

  @override
  String get notSelected => '未选择';

  @override
  String get notUnlocked => '未解锁';

  @override
  String get noteOptional => '笔记（可选）';

  @override
  String get noteSharedSnackbar => '笔记已分享！ ✨';

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
      '为确保通知正常工作：\n\n• 关闭电池优化（设置 → 应用 → Mira → 电池 → 不受限制）\n• 允许后台活动\n• 确保通知权限已开启\n• 检查“勿扰模式”';

  @override
  String get notificationTypes => '通知类型';

  @override
  String get notifications => '通知';

  @override
  String get notificationsMasterSubtitle => '控制所有应用通知';

  @override
  String get nudgeButtonLabel => '推一下';

  @override
  String get nudgeDefaultMessage => '👊 嘿朋友，今天再加把劲！完成你的习惯。';

  @override
  String nudgeNotification(Object name) {
    return '👊 $name 推了你一下！';
  }

  @override
  String nudgeSuccessSnackbar(Object displayName) {
    return '已推了 $displayName 一下！ 👊';
  }

  @override
  String nudgeTitle(Object displayName) {
    return '推一下 $displayName 👊';
  }

  @override
  String get numberLabel => '数值';

  @override
  String get numericExample => '每天喝 8 杯水';

  @override
  String get numericSettings => '数值目标设置';

  @override
  String get numericTypeDesc => '数字跟踪';

  @override
  String get numericalDescription => '数值目标跟踪';

  @override
  String get numericalGoalShort => '数值目标';

  @override
  String get numericalType => '数值';

  @override
  String get oceanTheme => '海洋';

  @override
  String get oceanThemeDesc => '宁静蓝色主题';

  @override
  String get off => '关';

  @override
  String get offLabel => '关';

  @override
  String get ok => '好';

  @override
  String get onDailyLimit => '您已达到每日上限。';

  @override
  String get onPeriodic => '以特定间隔';

  @override
  String get onSpecificMonthDays => '在每月特定日期';

  @override
  String get onSpecificWeekdays => '在每周特定日期';

  @override
  String get onSpecificYearDays => '在每年特定日期';

  @override
  String get onboardingQ1 => '我喜欢尝试新的体验并探索陌生的事物。';

  @override
  String get onboardingQ10 => '我会提前计划重要的活动和任务。';

  @override
  String get onboardingQ11 => '我喜欢尝试不同的方法，而不是坚持一种模式。';

  @override
  String get onboardingQ12 => '我在压力下保持冷静，并能从挫折中迅速恢复。';

  @override
  String get onboardingQ2 => '我保持空间整洁，并喜欢有规律的日常生活。';

  @override
  String get onboardingQ3 => '在人群中我会感到充满活力，并享受社交聚会。';

  @override
  String get onboardingQ4 => '我更喜欢与他人合作，并认为合作比竞争更有效。';

  @override
  String get onboardingQ5 => '我能冷静地处理压力大的情况，很少感到焦虑。';

  @override
  String get onboardingQ6 => '我喜欢创意活动，如艺术、音乐或写作。';

  @override
  String get onboardingQ7 => '我为自己设定明确的目标，并努力去实现它们。';

  @override
  String get onboardingQ8 => '比起独处，我更喜欢参加集体活动。';

  @override
  String get onboardingQ9 => '在做决定前，我经常会考虑他人的感受。';

  @override
  String get onboardingQuizIntro => '请回答几个问题，以帮助我们更好地了解您的性格。这基于经过科学验证的心理学研究。';

  @override
  String get onboardingWelcomeDesc => '陪伴你成长的个人习惯追踪器。让我们发现你的独特个性，并为你量身定制习惯建议。';

  @override
  String get onboardingWelcomeTitle => '欢迎来到 Mira';

  @override
  String get once => '一次';

  @override
  String get open => '打开';

  @override
  String get openBatteryOptimization => '打开电池优化';

  @override
  String get openNotificationSettings => '打开通知设置';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get option1 => '选项 1';

  @override
  String get option2 => '选项 2';

  @override
  String get optional => '可选';

  @override
  String get optionalLabel => '可选';

  @override
  String get other => '其他';

  @override
  String get outline => '轮廓';

  @override
  String get outlineColor => '轮廓颜色';

  @override
  String get overall => '整体';

  @override
  String get overallProgress => '整体进度';

  @override
  String get overview => '概览';

  @override
  String get pages => '页';

  @override
  String get pastelColors => '柔和色彩';

  @override
  String get pause => '暂停';

  @override
  String get perMonth => '/月';

  @override
  String get perYear => '/年';

  @override
  String get periodic => '周期性';

  @override
  String get periodicDesc => '每隔若干天';

  @override
  String get periodicSelection => '周期选择';

  @override
  String get personalizedInsights => '个性化见解';

  @override
  String get photo => '照片';

  @override
  String get pickFromCalendar => '从日历选择';

  @override
  String get pickTime => '选择时间';

  @override
  String get pickTodaysMood => '选择今日情绪';

  @override
  String get plannedMonthlySpend => '计划月度支出';

  @override
  String plansLoadError(Object error) {
    return '加载计划时出错：$error';
  }

  @override
  String get plateColor => '底板颜色';

  @override
  String get playAgain => '再玩一次';

  @override
  String get pleaseEnterEmail => '请输入电子邮件';

  @override
  String get pleaseFillAllFields => '请填写所有字段';

  @override
  String get pointsTableHeader => '分数';

  @override
  String get pomodoroAndCustomTimers => '番茄钟与自定义计时器';

  @override
  String get premiumBenefits => '高级版福利：';

  @override
  String get premiumFeature => '高级功能';

  @override
  String get premiumFeatureLabel => '高级功能';

  @override
  String get premiumFeatures => '高级功能';

  @override
  String get premiumPlans => '高级版计划';

  @override
  String get previous => '上一步';

  @override
  String get previousYear => '去年';

  @override
  String get prioritizeTaskSubtitle => '优先处理此任务';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyTitle => '隐私政策';

  @override
  String get privacySecurity => '隐私与安全';

  @override
  String get privacySecuritySubtitle => '管理设置和数据删除选项';

  @override
  String get processingWait => '正在处理，请稍候...';

  @override
  String get productivity => '生产力';

  @override
  String get profile => '资料';

  @override
  String get profileInfo => '资料信息';

  @override
  String get profileUpdated => '资料已更新';

  @override
  String get progressJourneyMessage => '当你完成习惯时，此图表将由你的成就塑造成型 ✨';

  @override
  String get progressJourneyStarts => '进度之旅开启';

  @override
  String get promoCodeActiveMessage => '您的高级版权限已通过优惠券代码激活 ✨';

  @override
  String get promoCodeAlreadyUsed => '此账户已使用过优惠券代码。';

  @override
  String get promoCodeHint => '输入您的代码';

  @override
  String get promoCodeInvalid => '优惠券代码无效。请检查并重试。';

  @override
  String get promoCodeLabel => '优惠券代码';

  @override
  String get promoCodeSuccess => '🎉 优惠券代码应用成功！高级版权限已激活。';

  @override
  String get quickSuggestions => '快速建议';

  @override
  String get rankingAndHabitsSection => '🏆 排行榜与习惯';

  @override
  String get readBook => '看书';

  @override
  String get readyVisionsLoadFailed => '无法加载预设愿景。';

  @override
  String get reasonAcademic => '学业';

  @override
  String get reasonFinance => '财务';

  @override
  String get reasonHealth => '健康';

  @override
  String get reasonOther => '其他';

  @override
  String get reasonPersonalGrowth => '个人成长';

  @override
  String get reasonRelationship => '人际关系';

  @override
  String get reasonSelection => '出现这种情况的原因是什么？';

  @override
  String get reasonSocial => '社交活动';

  @override
  String get reasonTitle => '原因';

  @override
  String get reasonWeather => '天气';

  @override
  String get reasonWork => '工作';

  @override
  String get recommendedHabits => '为您推荐的习惯';

  @override
  String get recurringMonthlyDesc => '每月选定日期自动添加';

  @override
  String get recurringMonthlyTitle => '重复（每月）';

  @override
  String get refreshList => '刷新列表';

  @override
  String get refundPolicy => '退款请求受 Google Play 政策限制。您可以从 Play 商店申请。';

  @override
  String get reload => '重新加载';

  @override
  String get remainingToday => '今日剩余';

  @override
  String get reminder => '提醒';

  @override
  String get reminderDisabled => '提醒关闭';

  @override
  String get reminderEnabled => '提醒开启';

  @override
  String get reminderFrequency => '提醒频率';

  @override
  String get reminderLabel => '提醒';

  @override
  String get reminderSettings => '提醒设置';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get removeFromList => '从列表中移除';

  @override
  String get repeatEveryDay => '每天重复';

  @override
  String repeatEveryNDays(Object days) {
    return '每 N 天重复一次';
  }

  @override
  String get reportAlreadyExists => '本周报告已存在。';

  @override
  String get reportBug => '反馈问题';

  @override
  String get reportBugDescription => '请在下方详细描述您遇到的问题。';

  @override
  String get reportBugSubtitle => '报告您遇到的问题';

  @override
  String get reportCreatedSuccess => '报告已创建！ ✨';

  @override
  String get reset => '重置';

  @override
  String get resetAction => '重置';

  @override
  String get resetOnboarding => '重置介绍';

  @override
  String get resetOnboardingDescription => '这将清除您当前的性格测试结果，并让您重新进行测试。';

  @override
  String get resetOnboardingTitle => '重置介绍？';

  @override
  String get restore => '恢复';

  @override
  String get restoreError => '恢复错误';

  @override
  String get restoreFailed => '恢复失败';

  @override
  String get restoreLatest => '恢复最新备份';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String restoreSuccess(Object content) {
    return '下载完成：$content';
  }

  @override
  String get restoreSuccessMessage => '您的数据已成功恢复。建议重启应用以使更改完全生效。';

  @override
  String get retakePersonalityTest => '重新进行性格测试';

  @override
  String get retakePersonalityTestDesc => '重新发现你的性格类型';

  @override
  String get retakeRhythmTest => '重新进行节律测试';

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
  String get rhythmA1_4 => '01:00 之后';

  @override
  String get rhythmA1_5 => '11:00 – 12:00';

  @override
  String get rhythmA2_1 => '06:00 – 07:00';

  @override
  String get rhythmA2_2 => '07:00 – 08:00';

  @override
  String get rhythmA2_3 => '08:00 – 09:00';

  @override
  String get rhythmA2_4 => '09:00 之后';

  @override
  String get rhythmA3_1 => '清晨';

  @override
  String get rhythmA3_2 => '上午中段';

  @override
  String get rhythmA3_3 => '下午';

  @override
  String get rhythmA3_4 => '晚上';

  @override
  String get rhythmA3_5 => '没区别';

  @override
  String get rhythmA4_1 => '早晨';

  @override
  String get rhythmA4_2 => '中午';

  @override
  String get rhythmA4_3 => '晚上';

  @override
  String get rhythmA4_4 => '深夜';

  @override
  String get rhythmA4_5 => '因天而异';

  @override
  String get rhythmA5_1 => '早起型';

  @override
  String get rhythmA5_2 => '较偏向早起型';

  @override
  String get rhythmA5_3 => '较偏向晚睡型';

  @override
  String get rhythmA5_4 => '晚睡型';

  @override
  String get rhythmAnalyzing => 'Live Rhythm 正在分析...';

  @override
  String get rhythmBenefit1 => '正确的时间做正确的事';

  @override
  String get rhythmBenefit2 => '无决策疲劳';

  @override
  String get rhythmBenefit3 => '每周个性化配置';

  @override
  String get rhythmChronoEvening => '晚睡型（猫头鹰型）';

  @override
  String get rhythmChronoIntermediate => '中间型（平衡型）';

  @override
  String get rhythmChronoMorning => '早起型（云雀型）';

  @override
  String get rhythmDisclaimer => '这些不是最终结果。Live Rhythm 将在了解你的过程中不断调整。';

  @override
  String get rhythmEnergyHint => '锻炼、体力活动';

  @override
  String get rhythmFocusHint => '脑力工作、分析、学习';

  @override
  String get rhythmHabitSuggestionTitle => '为您推荐的时段：';

  @override
  String get rhythmLightHint => '邮件、社交媒体、琐事';

  @override
  String get rhythmQ1 => '你通常几点睡觉？';

  @override
  String get rhythmQ2 => '你通常几点起床？';

  @override
  String get rhythmQ3 => '什么时候处理困难任务你觉得最舒服？';

  @override
  String get rhythmQ4 => '一天中什么时候你感觉状态最好（精力最充沛）？';

  @override
  String get rhythmQ5 => '你认为自己是“早起型”还是“晚起型”？';

  @override
  String get rhythmReflectionHint => '日记、阅读、放松';

  @override
  String get rhythmResultGotIt => '明白了，开始吧';

  @override
  String get rhythmResultSubtitle => '我们根据您的自然节律规划了您的一天。';

  @override
  String get rhythmResultTitle => '您的生物钟概况';

  @override
  String get rhythmTeaserCta => '查看方案';

  @override
  String get rhythmTeaserSkip => '跳过';

  @override
  String get rhythmTeaserSubtitle => 'Live Rhythm 学习您的最高效时刻，并在正确的时间安排习惯。';

  @override
  String get rhythmTeaserTitle => '根据生物钟最大化您的习惯效率';

  @override
  String get rhythmWindowEnergy => '活力时间';

  @override
  String get rhythmWindowEnergyDesc => '活动、行动、运动';

  @override
  String get rhythmWindowFocus => '专注时间';

  @override
  String get rhythmWindowFocusDesc => '头脑清晰、学习、分析';

  @override
  String get rhythmWindowLight => '轻松时间';

  @override
  String get rhythmWindowLightDesc => '低强度、琐碎任务';

  @override
  String get rhythmWindowNoProfileHint => '完成节律测试以获取个性化建议';

  @override
  String get rhythmWindowReflection => '反思时间';

  @override
  String get rhythmWindowReflectionDesc => '写日记、沉思、结束一天';

  @override
  String get rhythmWindowStepSubtitle => '你想在哪个时间段执行此习惯？';

  @override
  String get rhythmWindowStepTitle => '最佳时段';

  @override
  String get roomFabLabel => '房间';

  @override
  String get roomMembersLabel => '房间成员';

  @override
  String get roomNameHint => '例如：晨间常规小组';

  @override
  String get roomNameLabel => '房间名称';

  @override
  String get roomNotFoundError => '未找到此代码对应的房间';

  @override
  String get roomSummaryHeader => '房间摘要';

  @override
  String get roundCorners => '圆角';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return '规则：输入时长 ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return '规则：输入时长 ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return '规则：输入时长 = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return '规则：输入数值 ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return '规则：输入数值 ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return '规则：输入数值 = $target';
  }

  @override
  String get runningLabel => '运行中';

  @override
  String get saturdayShort => '周六';

  @override
  String get save => '保存';

  @override
  String get saveButton => '保存';

  @override
  String get saveChanges => '保存更改';

  @override
  String get saveEntry => '保存条目';

  @override
  String get saveError => '保存时出错';

  @override
  String get saved => '已保存';

  @override
  String get saving => '保存中...';

  @override
  String get savingsBudgetPlan => '储蓄 / 预算计划';

  @override
  String get scheduleHabit => '设置您的习惯计划';

  @override
  String get scheduleLabel => '计划';

  @override
  String get schedulingOptions => '调度选项';

  @override
  String get seconds => '秒';

  @override
  String get seeFullSubscriptionInfo => '查看详细订阅信息';

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
  String get selectDuration => '选择时长';

  @override
  String get selectEmoji => '选择图标';

  @override
  String get selectEndDate => '选择结束日期';

  @override
  String get selectFrequency => '选择频率';

  @override
  String get selectHabitLabel => '选择习惯';

  @override
  String get selectHabitType => '选择习惯类型';

  @override
  String get selectHabitsToAdd => '选择你想添加到日常常规中的习惯：';

  @override
  String get selectMonthTooltip => '选择月份';

  @override
  String get selectReason => '选择原因';

  @override
  String get selectReasonDesc => '哪个因素对您的一天影响最大？';

  @override
  String get selectReportType => '选择报告类型：';

  @override
  String get selectSubEmotion => '选择详细感受';

  @override
  String get selectSubEmotionDesc => '哪种具体感受最能描述你？';

  @override
  String get selectTime => '选择时间';

  @override
  String get selectYourCurrentMood => '选择您当前的情绪';

  @override
  String get selectYourMood => '选择您的情绪';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return '每月第 $sorted 天';
  }

  @override
  String get send => '发送';

  @override
  String get sendBackward => '移至底层';

  @override
  String get setAsTodayFocus => '设为今日焦点';

  @override
  String get setVisionTimeline => '为愿景设置时间轴';

  @override
  String get settings => '设置';

  @override
  String get shareAsLink => '作为链接分享';

  @override
  String get shareBoard => '分享愿景板';

  @override
  String get shareButton => '分享';

  @override
  String get shareDashboard => '分享愿景板';

  @override
  String get shareInviteCodeMessage => '分享此代码给你的朋友：';

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
  String get showProgress => '显示进度';

  @override
  String get showText => '显示文本';

  @override
  String get shuffle => '洗牌';

  @override
  String get signInFailed => '登录失败。请重试。';

  @override
  String get signInToSaveData => '登录以保存数据';

  @override
  String get signInWithGoogle => '使用 Google 登录';

  @override
  String get signInWithGoogleButton => '使用 Google 登录';

  @override
  String get signInWithGoogleDesc => '连接您的 Google 账户以继续。您的资料信息将自动填充。';

  @override
  String get signInWithGoogleTitle => '登录您的 Google 账户';

  @override
  String get signOut => '注销';

  @override
  String get signOutConfirmation => '您确定要注销吗？';

  @override
  String get simpleHabitColorSubtitle => '反映习惯的个性';

  @override
  String get simpleHabitColorTitle => '选择一种颜色';

  @override
  String get simpleHabitEmojiSubtitle => '让习惯更有趣！';

  @override
  String get simpleHabitEmojiTitle => '选择一个图标来代表它';

  @override
  String get simpleHabitFrequencySubtitle => '设定您的目标';

  @override
  String get simpleHabitFrequencyTitle => '您想多久做一次？';

  @override
  String get simpleHabitMonthDaysSubtitle => '选择活跃日期';

  @override
  String get simpleHabitMonthDaysTitle => '在每月的哪几天？';

  @override
  String get simpleHabitNameSubtitle => '你想养成什么习惯？';

  @override
  String get simpleHabitNameTitle => '为习惯起个名字';

  @override
  String get simpleHabitPeriodicSubtitle => '设定重复间隔';

  @override
  String get simpleHabitPeriodicTitle => '每隔多少天一次？';

  @override
  String get simpleHabitPreviewSubtitle => '看起来都正确吗？';

  @override
  String get simpleHabitPreviewTitle => '太棒了！这是您的习惯';

  @override
  String get simpleHabitReminderSubtitle => '通过每日提醒不错过习惯';

  @override
  String get simpleHabitReminderTitle => '需要我提醒您吗？';

  @override
  String get simpleHabitStartDateSubtitle => '为您的旅程选择一个起点';

  @override
  String get simpleHabitStartDateTitle => '您什么时候开始？';

  @override
  String get simpleHabitSubtitle => '快速创建一个习惯';

  @override
  String get simpleHabitTargetOne => '简单习惯（目标 = 1）';

  @override
  String get simpleHabitTitle => '简单习惯';

  @override
  String get simpleHabitTypeDescription => '用于日常打卡。完成或跳过。';

  @override
  String get simpleHabitWeekdaysSubtitle => '选择活跃日期';

  @override
  String get simpleHabitWeekdaysTitle => '在星期几？';

  @override
  String get simpleHabitWizardDesc => '我将分步引导您。让我们一起创建一个超棒的习惯！';

  @override
  String get simpleHabitWizardTitle => '准备好养成一个新习惯了吗？';

  @override
  String get simpleTypeShort => '简单';

  @override
  String get skip => '跳过';

  @override
  String get skipOnboarding => '跳过';

  @override
  String get skipTest => '跳过测试';

  @override
  String get social => '社交';

  @override
  String get socialFeaturesGuestMessage => '您需要使用 Google 登录才能创建房间并与朋友一起追踪进度。';

  @override
  String get socialFeaturesTitle => '社交功能';

  @override
  String get socialFeedTitle => '动态';

  @override
  String get socialRoomsTitle => '社交房间';

  @override
  String get softCloud => '柔云';

  @override
  String get softCloudDesc => '像云朵一样梦幻柔软';

  @override
  String get softPeach => '柔桃';

  @override
  String get softPeachDesc => '温馨的桃色与奶油色调';

  @override
  String get sound => '声音';

  @override
  String get soundAlerts => '声音警报';

  @override
  String get soundSubtitle => '通知时播放声音';

  @override
  String get specificDaysOfMonth => '每月特定日期';

  @override
  String get specificDaysOfWeek => '每周特定日期';

  @override
  String get specificDaysOfYear => '每年特定日期';

  @override
  String get spendingAdvisorNoBudget => '请设定预算以获取建议。';

  @override
  String get spendingAdvisorOnTrack => '太棒了！您的支出完全符合预算。';

  @override
  String get spendingAdvisorOverBudget => '您已超出预算。请停止支出。';

  @override
  String spendingAdvisorSafe(Object amount) {
    return '您每天可以花费 $amount。';
  }

  @override
  String get spendingAdvisorTitle => '支出顾问';

  @override
  String spendingAdvisorWarning(Object amount) {
    return '每天减少支出 $amount 以保持在限额内。';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return '太棒了！您的支出比日平均少 $amount。';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return '警告！您的支出比日平均多 $amount。';
  }

  @override
  String get spin => '旋转';

  @override
  String get spinAgain => '再转一次';

  @override
  String get start => '开始';

  @override
  String get startDate => '开始日期';

  @override
  String get startDateLabel => '开始';

  @override
  String get startDayLabel => '开始天 (1-365)';

  @override
  String get startJourney => '开启旅程';

  @override
  String get startTest => '开始测试';

  @override
  String get startTestDesc => '如果您完成测试，您将获得符合性格的建议和推荐习惯。如果需要，您现在可以跳过此步骤。';

  @override
  String get startTestTitle => '您想开始性格测试吗？';

  @override
  String get startTime => '开始时间';

  @override
  String get startTrackingFinances => '开始追踪财务并掌控支出。';

  @override
  String get startTrackingMood => '开始追踪情绪以查看分析数据';

  @override
  String get startsOn => '开始于';

  @override
  String get statsActiveDays => '活跃天数';

  @override
  String get statusLabel => '状态';

  @override
  String get step => '步骤';

  @override
  String stepOf(Object current, Object total) {
    return '步骤 $current / $total';
  }

  @override
  String get steps => '步骤';

  @override
  String get stopwatchLabel => '秒表';

  @override
  String streakDays(Object count) {
    return '$count 天连续';
  }

  @override
  String get streakIndicator => '连续天数指示器';

  @override
  String get streakIndicatorDesc => '显示火焰和冰霜效果';

  @override
  String get subEmotionAmazing => '太棒了';

  @override
  String get subEmotionAngry => '生气';

  @override
  String get subEmotionAnxious => '焦虑';

  @override
  String get subEmotionBlessed => '被眷顾';

  @override
  String get subEmotionBored => '无聊';

  @override
  String get subEmotionCalm => '冷静';

  @override
  String get subEmotionCheerful => '开朗';

  @override
  String get subEmotionConfident => '自信';

  @override
  String get subEmotionConfused => '困惑';

  @override
  String get subEmotionDemoralized => '士气低落';

  @override
  String get subEmotionDetermined => '坚定';

  @override
  String get subEmotionDistracted => '分心';

  @override
  String get subEmotionDrained => '精疲力竭';

  @override
  String get subEmotionEmpty => '空虚';

  @override
  String get subEmotionEnergetic => '精力充沛';

  @override
  String get subEmotionEnthusiastic => '热情的';

  @override
  String get subEmotionEuphoric => '欣快';

  @override
  String get subEmotionExcited => '兴奋';

  @override
  String get subEmotionExhausted => '筋疲力尽';

  @override
  String get subEmotionGrateful => '感激';

  @override
  String get subEmotionGuilty => '内疚';

  @override
  String get subEmotionHappy => '开心';

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
  String get subEmotionInsecure => '缺乏安全感';

  @override
  String get subEmotionLonely => '孤独';

  @override
  String get subEmotionLoving => '充满爱心';

  @override
  String get subEmotionMotivated => '有动力';

  @override
  String get subEmotionNumb => '麻木';

  @override
  String get subEmotionOrdinary => '平淡';

  @override
  String get subEmotionOverwhelmed => '不知所措';

  @override
  String get subEmotionPeaceful => '平和';

  @override
  String get subEmotionProud => '自豪';

  @override
  String get subEmotionRegretful => '后悔';

  @override
  String get subEmotionSad => '悲伤';

  @override
  String get subEmotionSelection => '让我们更详细地描述这种感受';

  @override
  String get subEmotionStressed => '有压力';

  @override
  String get subEmotionTired => '累';

  @override
  String get subEmotionUnstoppable => '势不可挡';

  @override
  String get subscribeToEnjoyPremium => '订阅以享受高级功能';

  @override
  String get subscription => '订阅';

  @override
  String get subscriptionDetails => '订阅详情';

  @override
  String subtaskIndex(Object index) {
    return '子任务 $index';
  }

  @override
  String get subtasks => '子任务';

  @override
  String get subtasksTitle => '子任务';

  @override
  String get subtasksType => '子任务';

  @override
  String get subtasksTypeDesc => '多任务';

  @override
  String get success => '成功';

  @override
  String get successfulDayLegend => '成功天';

  @override
  String successfulDaysCount(Object count) {
    return '$count 个成功天';
  }

  @override
  String get sundayShort => '周日';

  @override
  String get systemInfo => '系统信息';

  @override
  String get systemTheme => '系统主题';

  @override
  String get tapFabToCreate => '点击 + 按钮开始';

  @override
  String get tapSpinToStart => '点击中间按钮开始旋转';

  @override
  String get tapToPickImage => '点击选择图片';

  @override
  String get target => '目标';

  @override
  String get targetDurationMinutes => '目标时长（分钟）';

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
  String get taskAdded => '任务已添加';

  @override
  String taskAddedSnackbar(Object title) {
    return '$title 任务已添加！ ✅';
  }

  @override
  String get taskCompleted => '已完成';

  @override
  String taskDeletedMessage(Object title) {
    return '任务已删除：$title';
  }

  @override
  String get taskDescription => '描述（可选）';

  @override
  String get taskPending => '待处理';

  @override
  String get taskTitle => '任务标题';

  @override
  String get taskTitleRequired => '任务标题是必填项';

  @override
  String get tellMeYourDream => '告诉我你的梦想。我会帮你构建一个愿景板。';

  @override
  String get tellUsMore => '告诉我们更多';

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
  String get theWinnerIs => '中奖者：';

  @override
  String get theme => '主题';

  @override
  String get themeAbyss => '深渊';

  @override
  String get themeAbyssDesc => '深邃且精致';

  @override
  String get themeBlush => '腮红';

  @override
  String get themeBlushDesc => '甜美且柔美';

  @override
  String get themeCotton => '棉花';

  @override
  String get themeCottonDesc => '中性且温馨';

  @override
  String get themeCream => '奶油';

  @override
  String get themeCreamDesc => '温馨且柔和';

  @override
  String get themeCrimson => '深红';

  @override
  String get themeCrimsonDesc => '大胆且热烈';

  @override
  String get themeDetails => '主题详情';

  @override
  String get themeForest => '森林';

  @override
  String get themeForestDesc => '浓郁且有机';

  @override
  String get themeLavender => '薰衣草';

  @override
  String get themeLavenderDesc => '宁静且梦幻';

  @override
  String get themeMatcha => '抹茶';

  @override
  String get themeMatchaDesc => '清新绿色';

  @override
  String get themeMauve => '淡紫';

  @override
  String get themeMauveDesc => '优雅且浪漫';

  @override
  String get themeMidnight => '午夜';

  @override
  String get themeMidnightDesc => '深邃且神秘';

  @override
  String get themeOcean => '海洋';

  @override
  String get themeOceanDesc => '深邃且沉静';

  @override
  String get themeRose => '玫瑰';

  @override
  String get themeRoseDesc => '温馨玫瑰';

  @override
  String get themeSelection => '选择主题';

  @override
  String get themeSky => '天空';

  @override
  String get themeSkyDesc => '明朗且轻快';

  @override
  String get themeSlate => '石板';

  @override
  String get themeSlateDesc => '现代且清冷';

  @override
  String get themeSunset => '日落';

  @override
  String get themeSunsetDesc => '温馨且金色';

  @override
  String get themeVintageRed => '复古红';

  @override
  String get themeVintageRedDesc => '经典且永恒的红色';

  @override
  String get thisFeatureIsPremium => '此功能属于高级版';

  @override
  String get thisMonth => '本月';

  @override
  String get thisWeek => '本周';

  @override
  String get thisYear => '今年';

  @override
  String get thursdayShort => '周四';

  @override
  String get timer => '计时器';

  @override
  String get timerCreateTimerHabitFirst => '请先创建一个计时习惯';

  @override
  String get timerDescription => '时间追踪';

  @override
  String get timerExample => '进行 30 分钟健身';

  @override
  String get timerHabitLabel => '计时习惯';

  @override
  String get timerPause => '暂停';

  @override
  String timerPendingDurationLabel(Object duration) {
    return '剩余时长：$duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return '待处理：$duration';
  }

  @override
  String get timerPomodoroBreakPhase => '休息';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return '完成周期：$count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel => '长休周期（如：4）';

  @override
  String get timerPomodoroLongBreakMinutesLabel => '长休（分钟）';

  @override
  String get timerPomodoroSettings => '番茄钟设置';

  @override
  String get timerPomodoroShortBreakMinutesLabel => '短休（分钟）';

  @override
  String get timerPomodoroSkipPhase => '跳过阶段';

  @override
  String get timerPomodoroWorkMinutesLabel => '专注（分钟）';

  @override
  String get timerPomodoroWorkPhase => '专注';

  @override
  String get timerQuickPresets => '快捷预设';

  @override
  String get timerResume => '继续';

  @override
  String get timerSaveDurationTitle => '保存时长';

  @override
  String get timerSaveSessionTitle => '保存会话';

  @override
  String get timerSessionAlreadySaved => '此会话已保存';

  @override
  String get timerSetDurationFirst => '请先设置时长';

  @override
  String get timerSettings => '计时器设置';

  @override
  String get timerStop => '结束';

  @override
  String get timerTabCountdown => '倒计时';

  @override
  String get timerTabPomodoro => '番茄钟';

  @override
  String get timerTabStopwatch => '秒表';

  @override
  String get timerTracking => '计时追踪';

  @override
  String get timerType => '计时器';

  @override
  String get times => '次';

  @override
  String get timezone => '时区';

  @override
  String get titleHint => '例如：杂货、自由职业工作等';

  @override
  String get titleOptional => '标题（可选）';

  @override
  String get today => '今天';

  @override
  String get todaysHabits => '今日习惯';

  @override
  String get tokenEarnedSuccess => '获得 +1 代币！ 🎉';

  @override
  String get tomorrow => '明天';

  @override
  String get topCategories => '热门类别';

  @override
  String get totalDuration => '总时长';

  @override
  String get totalEntries => '总条目';

  @override
  String get totalMembersLabel => '成员总数';

  @override
  String get totalProgress => '总进度';

  @override
  String get totalSuccessfulDays => '累计成功天数';

  @override
  String get totalUnsuccessfulDays => '累计不成功天数';

  @override
  String get trackEarnings => '追踪您的收入';

  @override
  String get trackSpending => '追踪您的支出';

  @override
  String get trends => '趋势';

  @override
  String get trialCancelEffect => '如果您在免费试用期间取消，不会立即收费。';

  @override
  String get trialInfo => '14 天免费试用，随时取消。';

  @override
  String get tuesdayShort => '周二';

  @override
  String get typeEmoji => '输入图标';

  @override
  String get typeEmojiHint => '从键盘输入一个图标';

  @override
  String get typeLabel => '类型';

  @override
  String get typeNotChangeable => '类型无法更改';

  @override
  String get unassignLinkedDailyTasks => '取消关联今日任务';

  @override
  String get unassignLinkedHabits => '取消关联习惯';

  @override
  String get undo => '撤销';

  @override
  String get uninterruptedUsage => '无中断使用';

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
  String get unitKalori => '千卡';

  @override
  String get unitKez => '次';

  @override
  String get unitKm => '公里';

  @override
  String get unitLitre => '升';

  @override
  String get unitSayfa => '页';

  @override
  String get unknownList => '未知列表';

  @override
  String get unlimitedDataStorage => '无限数据存储';

  @override
  String get unlistedItems => '未列出';

  @override
  String get unlockAllFeatures => '开启所有功能，解除限制。';

  @override
  String get unnamedBackup => '未命名';

  @override
  String get update => '更新';

  @override
  String get usePlayStoreToManage => '使用 Google Play 商店管理您的订阅。';

  @override
  String get validity => '有效性';

  @override
  String get valueLabel => '值';

  @override
  String get vibration => '震动';

  @override
  String get vibrationSubtitle => '通知时震动';

  @override
  String get viewInvoicesOnPlayStore => '在 Google Play 商店查看账单';

  @override
  String get vision => '愿景';

  @override
  String visionAutoDurationInfo(Object day) {
    return '此愿景将使用模板中的最后一天：$day。';
  }

  @override
  String get visionBoard => '愿景板';

  @override
  String get visionBoardDesc => '创建一个愿景板以组织目标并追踪心路历程';

  @override
  String get visionBoardViewTooltip => '愿景板视图';

  @override
  String get visionCreateTitle => '创建愿景';

  @override
  String get visionDurationDaysLabel => '时长（天）';

  @override
  String get visionDurationNote => '注：愿景开始时会设定总时长；如果结束天超过此时长，它将自动缩短。';

  @override
  String get visionEditTitle => '编辑愿景';

  @override
  String get visionEmptyDescription => '将目标可视化，添加你的第一个愿景，让梦想成真。';

  @override
  String get visionEndDayInvalid => '结束天必须在 1 到 365 之间';

  @override
  String get visionEndDayLess => '结束天不能早于开始天';

  @override
  String get visionEndDayQuestion => '要在愿景的第几天结束？';

  @override
  String get visionEndDayRequired => '请输入结束天';

  @override
  String get visionFreeformTooltip => '自由看板';

  @override
  String get visionNoEndDurationInfo => '未指定结束天。愿景将无期限开始。';

  @override
  String get visionPlural => '愿景';

  @override
  String get visionSettingsTooltip => '自由看板设置';

  @override
  String get visionStartDayInvalid => '开始天必须在 1 到 365 之间';

  @override
  String get visionStartDayQuestion => '要在愿景的第几天开始？';

  @override
  String get visionStartFailed => '无法启动愿景。';

  @override
  String get visionStartLabel => '愿景开始：';

  @override
  String visionStartedMessage(Object title) {
    return '愿景已启动：$title';
  }

  @override
  String get visionTasks => '愿景任务';

  @override
  String get visual => '视觉';

  @override
  String get warmJournal => '温馨日记';

  @override
  String get warmJournalDesc => '温馨日记与情绪追踪';

  @override
  String get watchAdForToken => '观看广告 (+1 代币)';

  @override
  String get wednesdayShort => '周三';

  @override
  String get weekDaysShort => '周一,周二,周三,周四,周五,周六,周日';

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
  String get weeklyDesc => '在每周特定日期';

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
  String get whatHappensIfCancel => '如果取消会怎样？';

  @override
  String get whatsTheCause => '原因是什么？';

  @override
  String get wheelOfFortuneDescription => '添加选项并转动轮盘';

  @override
  String get wheelOfFortuneTitle => '幸运轮盘';

  @override
  String get whichDays => '哪些日期';

  @override
  String get whichDaysActive => '哪些天应该活跃？';

  @override
  String get whichMonthDays => '月份中的哪几天？';

  @override
  String get whichWeekdays => '星期几？';

  @override
  String get whichYearDays => '年份中的哪几天？';

  @override
  String get worldTheme => '世界';

  @override
  String get worldThemeDesc => '所有色彩的和谐';

  @override
  String get writeMessage => '写条消息...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • 距离升级还差 $toNext XP';
  }

  @override
  String xpToNextLevel(Object toNext) {
    return '距离升级';
  }

  @override
  String get yearly => '每年';

  @override
  String get yearlyProgress => '年度进度';

  @override
  String get yesNoDescription => '简单的 是/否 追踪';

  @override
  String get yesNoExample => '我今天冥想了吗？';

  @override
  String get yesNoType => '是/否';

  @override
  String get yesterday => '昨天';

  @override
  String get youLabel => '你';

  @override
  String get yourCharacterType => '您的性格类型';

  @override
  String get yourEmail => '您的电子邮件';

  @override
  String get yourEmailAddress => '您的电子邮件地址';

  @override
  String get yourMoodToday => '你今天的情绪';

  @override
  String get wizardFinish => '完成';

  @override
  String get wizardNext => '下一步';

  @override
  String get wizardSkip => '跳过';

  @override
  String get wizardOptional => '可选';

  @override
  String get analyzingHabit => '🔍 正在分析您的习惯...';

  @override
  String get calculatingLifeRhythm => '🧠 正在计算您的生活节奏...';

  @override
  String get determiningBestReminder => '⏰ 正在确定最佳提醒时间...';

  @override
  String get finalizingSettingsProgress => '✨ 正在进行最后调整...';

  @override
  String get determiningBestSettings => '我们正在为您确定最佳设置';
}
