// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get weeklyReportsTitle => 'Rapports Hebdomadaires';

  @override
  String get noReportsYet => 'Aucun rapport';

  @override
  String get createFirstReportPrompt =>
      'Appuyez sur + pour créer votre premier rapport';

  @override
  String get generating => 'Génération...';

  @override
  String get createReport => 'Créer un Rapport';

  @override
  String costTokens(Object cost) {
    return 'Coût : $cost jetons';
  }

  @override
  String balanceParenthesis(Object balance) {
    return '(Solde : $balance)';
  }

  @override
  String get watchAdForToken => 'Voir Pub (+1 Jeton)';

  @override
  String get selectReportType => 'Type de Rapport :';

  @override
  String generatedAtDate(Object date) {
    return 'Généré le : $date';
  }

  @override
  String get insufficientTokensWatchAd =>
      'Jetons insuffisants ! Regardez une pub.';

  @override
  String get reportCreatedSuccess => 'Rapport créé ! ✨';

  @override
  String get reportAlreadyExists => 'Le rapport existe déjà.';

  @override
  String get tokenEarnedSuccess => '+1 jeton gagné ! 🎉';

  @override
  String get about => 'À propos';

  @override
  String get account => 'Compte';

  @override
  String get achievements => 'Réalisations';

  @override
  String get active => 'Active';

  @override
  String get activeDays => 'Jours actifs';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get add => 'Ajouter';

  @override
  String get addDate => 'Ajouter une date';

  @override
  String get addFirstTransaction => 'Ajouter la première transaction';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get addImage => 'Ajouter une image';

  @override
  String get addNew => 'Ajouter nouveau';

  @override
  String get addNewHabit => 'Ajouter une nouvelle habitude';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Ajouter des options pour commencer';

  @override
  String get addSpecialDays => 'Ajouter des jours spéciaux';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get addTask => 'Ajouter une tâche';

  @override
  String get addText => 'Ajouter du texte';

  @override
  String get addToList => 'Ajouter à la liste';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get advancedHabit => 'Habitude Avancée';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get aiAssistantOnline => 'En ligne';

  @override
  String get aiAssistantTitle => 'Mira Asistan';

  @override
  String aiContextMessage(Object tip) {
    return 'Bonjour ! J\'ai remarqué que ce conseil vous intéresse :\n\n\"$tip\"\n\nVoulez-vous que je vous montre comment l\'appliquer dans Mira ?';
  }

  @override
  String aiHabitAddedMessage(int count) {
    return '$count habitudes ajoutées avec l\'IA';
  }

  @override
  String get aiInputHint => 'Décrivez l\'habitude que vous souhaitez créer...';

  @override
  String get aiPoweredRecommendations => 'AI powered recommendations';

  @override
  String get aiPreviewTitle => 'Suggestions de l\'IA';

  @override
  String get aiQuickFinance => 'Conseils budgétaires';

  @override
  String get aiQuickGamification => 'Qu\'est-ce que le système XP ?';

  @override
  String get aiQuickHabit => 'Créer une nouvelle habitude';

  @override
  String get aiQuickMood => 'Analyser mon humeur';

  @override
  String get aiQuickMotivation => 'Donne-moi de la motivation';

  @override
  String get aiQuickProfile => 'Mon personnage IA';

  @override
  String get aiQuickTimer => 'Comment utiliser le minuteur ?';

  @override
  String get aiQuickVision => 'Aide pour le tableau de vision';

  @override
  String get aiRetry => 'Réessayer (Règles plus strictes)';

  @override
  String get aiShowMeHow => 'Oui, montrez-moi comment';

  @override
  String get aiTip0 =>
      'Le saviez-vous ? Vous pouvez créer un tableau de vision pour vos objectifs à long terme.';

  @override
  String get aiTip1 =>
      'Astuce : Utilisez le minuteur pour des sessions de travail concentrées.';

  @override
  String get aiTip2 =>
      'Suivez votre humeur quotidiennement pour voir les changements au fil du temps.';

  @override
  String get aiTip3 =>
      'Les habitudes s\'installent mieux si vous les faites à la même heure chaque jour.';

  @override
  String get aiTip4 =>
      'Divisez les grandes visions en tâches plus petites et gérables.';

  @override
  String get aiTip5 =>
      'Utilisez l\'onglet Finances pour suivre vos dépenses quotidiennes.';

  @override
  String get aiTip6 =>
      'Besoin d\'aide ? Appuyez ici pour demander à l\'assistant IA !';

  @override
  String get aiTip7 => 'La cohérence est la clé ! Ne brisez pas la chaîne.';

  @override
  String get aiWelcomeMessage =>
      'Bonjour ! Je suis votre assistant Mira. Comment puis-je vous aider aujourd\'hui ? Vous pouvez me poser des questions sur les visions, les habitudes, les minuteurs ou d\'autres fonctionnalités.';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get allLabel => 'Tout';

  @override
  String get alsoDeleteLinkedHabits =>
      'Supprimer également les habitudes liées';

  @override
  String get amount => 'Montant';

  @override
  String get amountLabel => 'Montant';

  @override
  String get analysis => 'Analyse';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Apparence';

  @override
  String get apply => 'Appliquer';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get applying => 'Applying...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Cette vision dure environ $days jours';
  }

  @override
  String get assetsReloadHint =>
      'Un redémarrage complet de l\'application peut être nécessaire pour charger certains actifs.';

  @override
  String get atLeast => 'Au moins';

  @override
  String get atMost => 'Au plus';

  @override
  String get autoBackupSubtitle =>
      'Sauvegardez automatiquement vos données sur Google Drive toutes les 24 heures.';

  @override
  String get autoBackupTitle => 'Sauvegarde automatique';

  @override
  String get averageMood => 'Humeur moyenne';

  @override
  String get back => 'Back';

  @override
  String get backgroundPlate => 'Plaque de fond';

  @override
  String get backupError => 'Erreur de sauvegarde';

  @override
  String get backupFailed => 'Échec de la sauvegarde';

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String backupSuccess(Object id) {
    return 'Sauvegardé : $id';
  }

  @override
  String get backupTitle => 'Sauvegarde';

  @override
  String get backupToDrive => 'Sauvegarder sur Drive';

  @override
  String get badgeActive100dDesc => 'Être actif 100 jours différents';

  @override
  String get badgeActive100dTitle => '100 jours d\'activité';

  @override
  String get badgeActive30dDesc => 'Être actif 30 jours différents';

  @override
  String get badgeActive30dTitle => '30 jours d\'activité';

  @override
  String get badgeActive7dDesc => 'Être actif 7 jours différents';

  @override
  String get badgeActive7dTitle => '7 jours d\'activité';

  @override
  String get badgeCategoryActivity => 'Activité';

  @override
  String get badgeCategoryFinance => 'Finance';

  @override
  String get badgeCategoryHabit => 'Habitude';

  @override
  String get badgeCategoryLevel => 'Niveau';

  @override
  String get badgeCategoryVision => 'Vision';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => 'Enregistrer 100 transactions';

  @override
  String get badgeFin100Title => 'Financier 100';

  @override
  String get badgeFin10Desc => 'Enregistrer 10 transactions';

  @override
  String get badgeFin10Title => 'Financier 10';

  @override
  String get badgeFin250Desc => 'Enregistrer 250 transactions';

  @override
  String get badgeFin250Title => 'Financier 250';

  @override
  String get badgeFin50Desc => 'Enregistrer 50 transactions';

  @override
  String get badgeFin50Title => 'Financier 50';

  @override
  String get badgeHabit100Desc => 'Terminer 100 habitudes au total';

  @override
  String get badgeHabit100Title => 'Habitude 100';

  @override
  String get badgeHabit10Desc => 'Terminer 10 habitudes au total';

  @override
  String get badgeHabit10Title => 'Habitude 10';

  @override
  String get badgeHabit200Desc => 'Terminer 200 habitudes au total';

  @override
  String get badgeHabit200Title => 'Habitude 200';

  @override
  String get badgeHabit50Desc => 'Terminer 50 habitudes au total';

  @override
  String get badgeHabit50Title => 'Habitude 50';

  @override
  String get badgeLevel10Desc => 'Atteindre le niveau 10';

  @override
  String get badgeLevel10Title => 'Niveau 10';

  @override
  String get badgeLevel20Desc => 'Atteindre le niveau 20';

  @override
  String get badgeLevel20Title => 'Niveau 20';

  @override
  String get badgeLevel5Desc => 'Atteindre le niveau 5';

  @override
  String get badgeLevel5Title => 'Niveau 5';

  @override
  String get badgeVision10Desc => 'Créer 10 visions';

  @override
  String get badgeVision10Title => 'Grand Maître de la Vision';

  @override
  String get badgeVision1Desc => 'Créez votre première vision';

  @override
  String get badgeVision1Title => 'Visionnaire';

  @override
  String get badgeVision5Desc => 'Créer 5 visions';

  @override
  String get badgeVision5Title => 'Maître de la Vision';

  @override
  String get badgeVisionHabits3Desc => 'Lier 3+ habitudes à une vision';

  @override
  String get badgeVisionHabits3Title => 'Connecteur';

  @override
  String get badgeXp1000Desc => 'Gagner un total de 1000 XP';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => 'Gagner un total de 500 XP';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => 'Badges';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get between1And360 => 'Entre 1 et 360';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Une courte biographie sur vous';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get breakTime => 'Pause';

  @override
  String get breakdownByCategory => 'Répartition par catégorie';

  @override
  String get bringForward => 'Mettre en avant';

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
  String get cancel => 'Annuler';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get category => 'Catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

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
      'Choisissez la meilleure catégorie pour votre habitude';

  @override
  String get chooseColor => 'Choisir la couleur:';

  @override
  String get chooseEmoji => 'Choisir l\'émoji:';

  @override
  String get choosePhoto => 'Choisir une photo';

  @override
  String get choosePhotoSubtitle => 'Choisissez une photo qui vous motive';

  @override
  String get choosePhotoDesc => 'Choisissez une photo qui vous inspire';

  @override
  String get clear => 'Effacer';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get close => 'Fermer';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get coinFlipDescription => 'Décidez entre deux options';

  @override
  String get coinFlipInstruction => 'Écrivez deux options et lancez la pièce !';

  @override
  String get coinFlipTitle => 'Pile ou Face';

  @override
  String get colorLabel => 'Couleur';

  @override
  String get colorTheme => 'Thème de couleur';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String get completedSelectedDay => 'Terminé (jour sélectionné)';

  @override
  String get confirmDeleteAccount => 'Confirmer la suppression du compte';

  @override
  String get confirmHabits => 'Confirmer les habitudes';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueText => 'Devam Et';

  @override
  String get cottonCandy => 'Barbe à papa';

  @override
  String get cottonCandyDesc => 'Barbe à papa - Rose & Bleu';

  @override
  String get countdownConfigureTitle => 'Configurer le compte à rebours';

  @override
  String get countdownLabel => 'COUNTDOWN';

  @override
  String get cozyJournal => 'Journal confortable';

  @override
  String get cozyJournalDesc => 'Tons bruns & Chronologie';

  @override
  String get crashReports => 'Crash reports';

  @override
  String get crashReportsSubtitle => 'Send anonymous reports on app crashes';

  @override
  String get create => 'Créer';

  @override
  String get createAdvancedHabit => 'Créer une habitude avancée';

  @override
  String get createDailyTask => 'Créer une tâche quotidienne';

  @override
  String get createFirstHabit => 'Créer une première habitude';

  @override
  String get createFirstVision => 'Créez votre première vision';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get createHabitTemplateTitle => 'Créer un modèle d\'habitude';

  @override
  String get createHabitTitle => 'Créer une habitude';

  @override
  String get createList => 'Créer une liste';

  @override
  String get createNewCategory => 'Créer une nouvelle catégorie';

  @override
  String get createNewList => 'Créer une nouvelle liste';

  @override
  String get createVision => 'Créer une vision';

  @override
  String get createVisionTemplateTitle => 'Créer un modèle de vision';

  @override
  String get createVisionWithAI => 'Créer une vision avec l\'IA';

  @override
  String get createWithAi => 'Créer avec l\'IA';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String get custom => 'Personnalisé';

  @override
  String get customCategories => 'Catégories personnalisées';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get customEmojiHint => 'Ex: ✨';

  @override
  String get customEmojiOptional => 'Émoji personnalisé (facultatif)';

  @override
  String get customFrequency => 'Personnalisé';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get customUnitHint => 'Ex: portion, série, km...';

  @override
  String get daily => 'Quotidien';

  @override
  String get dailyCheck => 'Vérification quotidienne';

  @override
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => 'Limite quotidienne';

  @override
  String get dailyTask => 'Tâche quotidienne';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Tâche quotidienne créée: $title';
  }

  @override
  String get dailyTasksSection => 'Tâches quotidiennes';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get dashboard => 'Panneau';

  @override
  String get date => 'Date';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get dayFriShort => 'Ven';

  @override
  String get dayMonShort => 'Lun';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Jour $start–$end';
  }

  @override
  String get daySatShort => 'Sam';

  @override
  String dayShort(Object day) {
    return 'Jour $day';
  }

  @override
  String get daySunShort => 'Dim';

  @override
  String get dayThuShort => 'Jeu';

  @override
  String get dayTueShort => 'Mar';

  @override
  String get dayWedShort => 'Mer';

  @override
  String get days => 'gün';

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String daysAverageShort(Object days) {
    return '${days}j moy.';
  }

  @override
  String daysCount(Object count) {
    return '$count jours';
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
  String get decisionEggDescription => 'Choisissez un œuf mystique';

  @override
  String get decisionEggTitle => 'Œuf de Décision';

  @override
  String get defaultUnit => 'adet';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAccountFailed => 'Account deletion failed';

  @override
  String get deleteAccountRequestSuccess =>
      'Votre demande de suppression de compte a été reçue avec succès';

  @override
  String get deleteAccountSubtitle =>
      'Faire une demande de suppression de compte et de données';

  @override
  String get deleteAccountWarning =>
      'Cette action est irréversible. Veuillez confirmer l\'e-mail associé à votre compte.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllDataConfirmContent =>
      'Are you sure you want to delete all your app data? This action cannot be undone.';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return 'Supprimer la catégorie \"$name\"?';
  }

  @override
  String get deleteCategoryTitle => 'Supprimer la catégorie';

  @override
  String get deleteCustomCategoryConfirm =>
      'Supprimer cette catégorie personnalisée?';

  @override
  String get deleteEntryConfirm => 'Supprimer cette entrée?';

  @override
  String deleteHabitConfirm(Object title) {
    return 'Supprimer l\'habitude \"$title\"?';
  }

  @override
  String get deleteListMessage =>
      'Cette liste sera supprimée. Choisissez quoi faire avec les éléments liés:';

  @override
  String get deleteListTitle => 'Supprimer la liste';

  @override
  String get deleteMyAccount => 'Supprimer mon compte';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get deleteTaskConfirmMessage =>
      'Voulez-vous supprimer cette tâche quotidienne? Cette action peut être annulée.';

  @override
  String get deleteTaskConfirmTitle => 'Supprimer la tâche?';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'Supprimer l\'enregistrement \"$title\"?';
  }

  @override
  String get deleteVisionMessage => 'Supprimer cette vision?';

  @override
  String get deleteVisionTitle => 'Supprimer la vision';

  @override
  String get descHint => 'Détails sur votre habitude (facultatif)';

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
  String get difficulty => 'Niveau de difficulté';

  @override
  String get drinkWater => 'Su İç';

  @override
  String get duration => 'Durée';

  @override
  String get durationAutoLabel => 'Durée (auto)';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get durationSelection => 'Sélection de la durée';

  @override
  String get durationType => 'Type de durée';

  @override
  String get earthTheme => 'Terre';

  @override
  String get earthThemeDesc => 'Couleurs de la terre';

  @override
  String get easy => 'Facile';

  @override
  String get edit => 'Modifier';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get editHabit => 'Modifier l\'habitude';

  @override
  String get editListTitle => 'Modifier la liste';

  @override
  String get education => 'Éducation';

  @override
  String get eggRevealMessage => 'L\'œuf mystique a parlé ! ✨';

  @override
  String get eggSelectMessage => 'Pensez à une question et touchez un œuf 🥚';

  @override
  String get emojiAndColor => 'Emoji & Couleur';

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
  String get emojiLabel => 'Émoji';

  @override
  String get emptyHabitSubtitle =>
      'Créez votre première habitude pour suivre vos progrès.';

  @override
  String get emptyHabitTitle => 'Commencez votre voyage';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get enableReminder => 'Activer le rappel';

  @override
  String get endDate => 'Date de fin';

  @override
  String get endDateLabel => 'End';

  @override
  String get endDayOptionalLabel => 'Jour de fin (facultatif)';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Entrez un plan mensuel pour calculer une limite quotidienne.';

  @override
  String get enterNameAndDesc =>
      'Entrez le nom et la description de votre habitude';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get enterValueTitle => 'Entrer la valeur';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get entries => 'Entrées';

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
  String get everyNDaysQuestion => 'Tous les combien de jours?';

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get everyday => 'Tous les jours';

  @override
  String get exact => 'Exact';

  @override
  String get exactAlarmPermission =>
      'Autorisation d\'alarme exacte (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Exemple: $example';
  }

  @override
  String get expenseDelta => 'Dépense Δ';

  @override
  String get expenseDistributionPie => 'Répartition des dépenses (camembert)';

  @override
  String get expenseEditTitle => 'Modifier la dépense';

  @override
  String get expenseLabel => 'Dépense';

  @override
  String get expenseNewTitle => 'Nouvelle dépense';

  @override
  String failedToLoad(Object error) {
    return 'Échec du chargement: $error';
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
  String get feelingMoreSpecific => 'Pouvez-vous être plus précis ?';

  @override
  String get filterTitle => 'Filtre';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get finance => 'Finance';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Analyse financière · $month';
  }

  @override
  String get financeLast7Days => 'Finance · 7 derniers jours';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'Terminer';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Fixe';

  @override
  String get flexiblePlan => 'Flexible plan, cancel anytime';

  @override
  String get flipCoin => 'Lancer la pièce';

  @override
  String get focusLabel => 'FOCUS';

  @override
  String get focusedZen => 'Odaklanmış Zen';

  @override
  String get focusedZenDesc => 'Minimalist, tek odak noktası';

  @override
  String get font => 'Police';

  @override
  String get forestTheme => 'Forêt';

  @override
  String get forestThemeDesc => 'Thème vert naturel';

  @override
  String get forever => 'Pour toujours';

  @override
  String get fortuneDisclaimer =>
      'La divination est uniquement à des fins de divertissement';

  @override
  String fortuneEggSemantic(int index) {
    return 'Œuf de la fortune $index';
  }

  @override
  String get fortuneEggsSubtitle =>
      'Choisissez un œuf pour révéler votre fortune';

  @override
  String get fortuneNoQuestion => 'Vous n\'avez pas encore posé de question';

  @override
  String get fortunePlay => 'Jouer';

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneQuestionHint => 'Que voudriez-vous savoir ?';

  @override
  String get fortuneQuestionPrompt => 'Posez votre question';

  @override
  String get fortuneResultTitle => 'Votre fortune';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String get fortuneTitle => 'Œufs de la fortune';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get frequency => 'Fréquence';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'Nom complet';

  @override
  String get fullScreen => 'Plein écran';

  @override
  String get gallery => 'Galerie';

  @override
  String get gamesDescription =>
      'Du mal à décider ? Prenez votre décision avec des jeux amusants !';

  @override
  String get gamesTitle => 'Jeux';

  @override
  String get general => 'Général';

  @override
  String get generalNotifications => 'Notifications générales';

  @override
  String get generate => 'Générer';

  @override
  String get glasses => 'Verres';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get goldenTheme => 'Doré';

  @override
  String get goldenThemeDesc => 'Thème doré chaleureux';

  @override
  String get goodMorning => 'Bonjour ! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Accordé';

  @override
  String get greatDayAhead =>
      'C\'est une belle journée, vous pouvez le faire !';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get guestAccount => 'Compte invité';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

  @override
  String get habit => 'Habitude';

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
    return 'Habitude créée: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Habitude supprimée: $title';
  }

  @override
  String get habitDescription => 'Description';

  @override
  String get habitDescriptionHint => 'Ajouter une courte description...';

  @override
  String get habitDetails => 'Détails de l\'habitude';

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
  String get habitName => 'Nom de l\'habitude';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get habitNameHintNumerical => 'Ex: Boire de l\'eau, Lire des pages...';

  @override
  String get habitNameHintTimer => 'Ex: Méditation, Exercice...';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get habitNotFound => 'Habitude non trouvée.';

  @override
  String get habitOfThisVision => 'Habitude de cette vision';

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
  String get habitReminders => 'Rappels d\'habitudes';

  @override
  String get habitRemindersSubtitle => 'Rappels quotidiens pour vos habitudes';

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
  String get habitUpdatedMessage => 'Habitude mise à jour.';

  @override
  String get habits => 'Habitudes';

  @override
  String get habitsSection => 'Habitudes';

  @override
  String get hard => 'Difficile';

  @override
  String get hardMode => 'Mode difficile';

  @override
  String get headerFocusLabel => 'Focus';

  @override
  String get headerFocusReady => 'Prêt';

  @override
  String get headerHabitsLabel => 'Habitude';

  @override
  String get health => 'Santé';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get history => 'History';

  @override
  String get historyTitle => 'History';

  @override
  String get hourShort => 'sa';

  @override
  String get hours => 'Heures';

  @override
  String get howAreYouFeeling => 'Comment vous sentez-vous ?';

  @override
  String get howDoYouFeel => 'Comment vous sentez-vous aujourd\'hui ?';

  @override
  String get howOftenDoHabit =>
      'Décidez à quelle fréquence vous ferez votre habitude';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get howToEarn => 'Comment gagner';

  @override
  String get howToTrackHabit => 'Choisissez comment votre habitude sera suivie';

  @override
  String get ifCondition => 'Si';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get importFromLink => 'Importer depuis un lien';

  @override
  String get importantNotice => 'Avis important';

  @override
  String get inactive => 'Inactive';

  @override
  String get incomeDelta => 'Δ de revenus';

  @override
  String get incomeEditTitle => 'Modifier le revenu';

  @override
  String get incomeLabel => 'Revenu';

  @override
  String get incomeNewTitle => 'Nouveau revenu';

  @override
  String get incompleteSelectedDay => 'Incomplet (jour sélectionné)';

  @override
  String get input => 'Entrée';

  @override
  String get insights => 'Insights';

  @override
  String get invalidLink => 'Lien invalide.';

  @override
  String get invalidValue => 'Valeur invalide';

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
  String get keepItUp => 'Génial ! Continuez comme ça ! 💪';

  @override
  String get language => 'Langue';

  @override
  String get languageSelection => 'Sélection de la langue';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get later => 'Later';

  @override
  String get lavenderDreams => 'Rêves de lavande';

  @override
  String get lavenderDreamsDesc => 'Tons élégants de lavande et lilas';

  @override
  String get letsPlayGame => 'Jouons ! 🎮';

  @override
  String get letsStart => 'Commençons';

  @override
  String levelLabel(Object level) {
    return 'Niveau $level';
  }

  @override
  String levelShort(Object level) {
    return 'N$level';
  }

  @override
  String get lightTheme => 'Thème clair';

  @override
  String get likertAgree => 'D\'accord';

  @override
  String get likertDisagree => 'Pas d\'accord';

  @override
  String get likertNeutral => 'Neutre';

  @override
  String get likertStronglyAgree => 'Tout à fait d\'accord';

  @override
  String get likertStronglyDisagree => 'Pas du tout d\'accord';

  @override
  String get linkHabits => 'Lier les habitudes';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'Liste créée: $title';
  }

  @override
  String get listLabel => 'Liste';

  @override
  String get listNameHint => 'Ex: Santé';

  @override
  String get listNameLabel => 'Nom de la liste';

  @override
  String get loadingHabits => 'Chargement des habitudes...';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get longestStreak => 'Plus longue série';

  @override
  String get manageLists => 'Gérer les listes';

  @override
  String get manageListsSubtitle =>
      'Ajouter une nouvelle liste, renommer ou supprimer.';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get manageSubscriptionDesc =>
      'Change plan, cancel or view billing info';

  @override
  String get manageSubscriptionSubtitle =>
      'Gérez l\'abonnement Mira Plus via Google Play';

  @override
  String get manageVisionTasks => 'Manage Tasks';

  @override
  String get manualFallback => 'Créer manuellement';

  @override
  String get maxOptionsReached =>
      'Vous pouvez ajouter un maximum de 12 options';

  @override
  String get meditation => 'Méditation';

  @override
  String get medium => 'Moyen';

  @override
  String get minLabel => 'min';

  @override
  String get mindfulness => 'Pleine conscience';

  @override
  String get mintFresh => 'Menthe fraîche';

  @override
  String get mintFreshDesc => 'Tons frais de menthe et turquoise';

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
  String get mondayShort => 'Pzt';

  @override
  String get monthCount => 'Nombre de mois';

  @override
  String get monthCountHint => 'Ex: 12';

  @override
  String get monthSuffixShort => 'm';

  @override
  String get monthly => 'Mensuel';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get monthlyDesc => 'Ayın belirli günlerinde';

  @override
  String get monthlyProgress => 'Progrès mensuel';

  @override
  String get monthlyTrend => 'Tendance mensuelle';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get mood => 'Humeur';

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get moodBad => 'Mauvaise';

  @override
  String get moodBadDesc => 'Je passe un mauvais moment';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get moodExcellent => 'Excellent';

  @override
  String get moodExcellentDesc => 'Je me sens incroyable';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodFlowSubtitle => 'Suivez votre bien-être émotionnel';

  @override
  String get moodFlowTitle => 'Comment vous sentez-vous ?';

  @override
  String get moodGood => 'Bonne';

  @override
  String get moodGoodDesc => 'Je me sens positif';

  @override
  String get moodGreat => 'Excellente';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodNeutral => 'Neutre';

  @override
  String get moodNeutralDesc => 'Je me sens bien';

  @override
  String get moodOk => 'Ok';

  @override
  String get moodSelection => 'Sélection de l\'humeur';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String get moodTerribleDesc => 'Je me sens très mal';

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
    return 'Excellent travail! $period vous avez atteint un taux de réussite de $percent%.';
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
  String get mtdAverageShort => 'Moy. MTD';

  @override
  String get multiple => 'Multiple';

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
  String get mysticTheme => 'Mystique';

  @override
  String get mysticThemeDesc => 'Thème violet mystique';

  @override
  String nDaysLabel(Object count) {
    return '$count jours';
  }

  @override
  String get nameHint => 'Ex: Entraînement quotidien';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get newHabit => 'New Habit';

  @override
  String get newHabits => 'Nouvelles habitudes';

  @override
  String get newList => 'Nouvelle liste';

  @override
  String get next => 'Suivant';

  @override
  String get nextLabel => 'Suivant';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => 'Année prochaine';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get noDataLast7Days => 'Pas de données pour les 7 derniers jours';

  @override
  String get noDataThisMonth => 'Pas de données pour ce mois';

  @override
  String get noEndDate => 'Pas de date de fin';

  @override
  String get noEndDayDefaultsDaily =>
      'Lorsqu\'aucun jour de fin n\'est défini, cette habitude apparaîtra par défaut tous les jours.';

  @override
  String get noEntriesYet => 'Aucune entrée pour le moment';

  @override
  String get noExpenseInThisCategory => 'Aucune dépense dans cette catégorie';

  @override
  String get noExpenses => 'Aucune dépense';

  @override
  String get noExpensesThisMonth => 'Aucune dépense pour ce mois';

  @override
  String get noHabitsAddedYet => 'Aucune habitude ajoutée pour le moment.';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get noIncomeThisMonth => 'Aucun revenu pour ce mois';

  @override
  String get noItemsMatchFilters =>
      'Aucun élément ne correspond aux filtres sélectionnés';

  @override
  String get noLinkedHabitsInVision => 'Aucune habitude liée à cette vision.';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get noReadyVisionsFound => 'Aucune vision prête trouvée.';

  @override
  String get noRecordsThisMonth => 'Aucun enregistrement pour ce mois';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get notAddedYet => 'Pas encore ajouté.';

  @override
  String get notGranted => 'Non accordé';

  @override
  String get notSelected => 'Not selected';

  @override
  String get notUnlocked => 'Non déverrouillé';

  @override
  String get noteOptional => 'Note (facultatif)';

  @override
  String get notificationBehavior => 'Comportement des notifications';

  @override
  String get notificationPermission => 'Autorisation de notification';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get notificationSettingsSubtitle =>
      'Configurez vos préférences de notification';

  @override
  String get notificationTroubleshooting =>
      'Pour que les notifications fonctionnent correctement :\n\n• Désactivez l\'optimisation de la batterie\n• AUTORISEZ l\'activité en arrière-plan\n• Assurez-vous que les autorisations de notification sont activées\n• Vérifiez le mode \'Ne pas déranger\'';

  @override
  String get notificationTypes => 'Types de notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsMasterSubtitle =>
      'Contrôler toutes les notifications de l\'application';

  @override
  String get numberLabel => 'Nombre';

  @override
  String get numericExample => 'Boire 8 verres d\'eau par jour';

  @override
  String get numericSettings => 'Paramètres de l\'objectif numérique';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get numericalDescription => 'Suivi de l\'objectif numérique';

  @override
  String get numericalGoalShort => 'Objectif numérique';

  @override
  String get numericalType => 'Valeur numérique';

  @override
  String get oceanTheme => 'Océan';

  @override
  String get oceanThemeDesc => 'Thème bleu calme';

  @override
  String get off => 'Off';

  @override
  String get offLabel => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get onDailyLimit => 'Vous avez atteint votre limite quotidienne.';

  @override
  String get onPeriodic => 'À des intervalles spécifiques';

  @override
  String get onSpecificMonthDays => 'Certains jours du mois';

  @override
  String get onSpecificWeekdays => 'Certains jours de la semaine';

  @override
  String get onSpecificYearDays => 'Certains jours de l\'année';

  @override
  String get onboardingQ1 =>
      'J\'aime essayer de nouvelles expériences et explorer l\'inconnu.';

  @override
  String get onboardingQ10 =>
      'Je planifie à l\'avance les événements et tâches importants.';

  @override
  String get onboardingQ11 =>
      'J\'aime essayer différentes approches plutôt que de m\'en tenir à une seule méthode.';

  @override
  String get onboardingQ12 =>
      'Je reste calme sous pression et je me remets rapidement des revers.';

  @override
  String get onboardingQ2 =>
      'Je garde mon espace organisé et je préfère une routine quotidienne structurée.';

  @override
  String get onboardingQ3 =>
      'Je me sens plein d\'énergie en présence d\'autres personnes et j\'apprécie les rassemblements sociaux.';

  @override
  String get onboardingQ4 =>
      'Je préfère travailler avec les autres et je trouve la coopération plus efficace que la compétition.';

  @override
  String get onboardingQ5 =>
      'Je gère calmement les situations stressantes et je me sens rarement anxieux.';

  @override
  String get onboardingQ6 =>
      'J\'apprécie les activités créatives comme l\'art, la musique ou l\'écriture.';

  @override
  String get onboardingQ7 =>
      'Je me fixe des objectifs clairs et je travaille avec assiduité pour les atteindre.';

  @override
  String get onboardingQ8 =>
      'Je préfère les activités de groupe plutôt que de passer du temps seul.';

  @override
  String get onboardingQ9 =>
      'Je prends souvent en compte les sentiments des autres avant de prendre des décisions.';

  @override
  String get onboardingQuizIntro =>
      'Répondez à quelques questions pour nous aider à mieux comprendre votre personnalité. Ceci est basé sur des recherches psychologiques validées scientifiquement.';

  @override
  String get onboardingWelcomeDesc =>
      'Votre suivi d\'habitudes personnel qui grandit avec vous. Découvrons votre personnalité unique et proposons des habitudes adaptées pour vous.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Mira';

  @override
  String get once => 'Une fois';

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
  String get other => 'Autre';

  @override
  String get outline => 'Contour';

  @override
  String get outlineColor => 'Couleur du contour';

  @override
  String get overall => 'Global';

  @override
  String get overallProgress => 'Progrès global';

  @override
  String get overview => 'Overview';

  @override
  String get pages => 'Pages';

  @override
  String get pastelColors => 'Couleurs pastel';

  @override
  String get pause => 'Pause';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get periodic => 'Périodique';

  @override
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => 'Sélection périodique';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get pickTodaysMood => 'Choisissez l\'humeur d\'aujourd\'hui';

  @override
  String get plannedMonthlySpend => 'Dépenses mensuelles prévues';

  @override
  String plansLoadError(Object error) {
    return 'Erreur lors du chargement des plans : $error';
  }

  @override
  String get plateColor => 'Couleur de la plaque';

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
  String get previous => 'Précédent';

  @override
  String get previousYear => 'Année précédente';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacySecurity => 'Confidentialité et sécurité';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get productivity => 'Productivité';

  @override
  String get profile => 'Profil';

  @override
  String get profileInfo => 'Informations du profil';

  @override
  String get profileUpdated => 'Profil mis à jour';

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
      'Les visions prêtes n\'ont pas pu être chargées.';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'Santé';

  @override
  String get reasonOther => 'Autre';

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
  String get reasonWork => 'Travail';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get recurringMonthlyDesc =>
      'Ajouter automatiquement chaque mois à la date sélectionnée';

  @override
  String get recurringMonthlyTitle => 'Récurrent (mensuel)';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get reload => 'Recharger';

  @override
  String get remainingToday => 'Restant aujourd\'hui';

  @override
  String get reminder => 'Rappel';

  @override
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

  @override
  String get reminderFrequency => 'Fréquence du rappel';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderSettings => 'Paramètres du rappel';

  @override
  String get reminderTime => 'Heure de rappel';

  @override
  String get removeFromList => 'Retirer de la liste';

  @override
  String get repeatEveryDay => 'Se répète tous les jours';

  @override
  String get repeatEveryNDays => 'Répéter tous les N jours';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reset => 'Réinitialiser';

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
  String get restoreError => 'Erreur de restauration';

  @override
  String get restoreFailed => 'Échec de la restauration';

  @override
  String get restoreLatest => 'Restaurer la dernière';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String restoreSuccess(Object content) {
    return 'Téléchargé : $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get retry => 'Réessayer';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Règle: Durée saisie ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Règle: Durée saisie ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Règle: Durée saisie = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Règle: Valeur saisie ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Règle: Valeur saisie ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Règle: Valeur saisie = $target';
  }

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get saved => 'Enregistré';

  @override
  String get saving => 'Saving...';

  @override
  String get savingsBudgetPlan => 'Plan d\'épargne / budget';

  @override
  String get scheduleHabit => 'Définissez l\'horaire de votre habitude';

  @override
  String get scheduleLabel => 'Horaire';

  @override
  String get schedulingOptions => 'Options de planification';

  @override
  String get seconds => 'Secondes';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get select => 'Sélectionner';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectAtLeastOneDay => 'Lütfen en az bir gün seçin';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get selectEndDate => 'Sélectionner la date de fin';

  @override
  String get selectFrequency => 'Sélectionner la fréquence';

  @override
  String get selectHabitType => 'Sélectionner le type d\'habitude';

  @override
  String get selectHabitsToAdd =>
      'Sélectionnez les habitudes que vous souhaitez ajouter à votre routine quotidienne :';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get selectReason => 'Select reason';

  @override
  String get selectReasonDesc => 'Sélectionnez ce qui affecte votre humeur';

  @override
  String get selectSubEmotion => 'Sélectionner la sous-émotion';

  @override
  String get selectSubEmotionDesc => 'Sélectionnez une émotion plus spécifique';

  @override
  String get selectTime => 'Sélectionner l\'heure';

  @override
  String get selectYourCurrentMood => 'Sélectionnez votre humeur actuelle';

  @override
  String get selectYourMood => 'Sélectionnez votre humeur';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String get send => 'Send';

  @override
  String get sendBackward => 'Mettre en arrière-plan';

  @override
  String get setVisionTimeline => 'Définis la chronologie de ta vision';

  @override
  String get settings => 'Paramètres';

  @override
  String get shareAsLink => 'Partager en tant que lien';

  @override
  String get shareBoard => 'Share board';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get shareLinkCopied => 'Lien de partage copié dans le presse-papiers.';

  @override
  String get shareVision => 'Partager la vision';

  @override
  String get showProgress => 'Show progress';

  @override
  String get showText => 'Show text';

  @override
  String get shuffle => 'Mélanger';

  @override
  String get signInFailed => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get signInToSaveData => 'Verileri kaydetmek için giriş yap';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

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
      'Laisse la couleur refléter la personnalité de l\'habitude';

  @override
  String get simpleHabitColorTitle => 'Choisis une couleur';

  @override
  String get simpleHabitEmojiSubtitle => 'Rends ton habitude plus amusante !';

  @override
  String get simpleHabitEmojiTitle => 'Choisis un émoji qui la représente';

  @override
  String get simpleHabitFrequencySubtitle => 'Définis tes objectifs';

  @override
  String get simpleHabitFrequencyTitle =>
      'À quelle fréquence veux-tu le faire ?';

  @override
  String get simpleHabitMonthDaysSubtitle => 'Choisis les jours actifs';

  @override
  String get simpleHabitMonthDaysTitle => 'Quels jours du mois ?';

  @override
  String get simpleHabitNameSubtitle => 'Que veux-tu transformer en habitude ?';

  @override
  String get simpleHabitNameTitle => 'Donne un nom à ton habitude';

  @override
  String get simpleHabitPeriodicSubtitle =>
      'Définis l\'intervalle de répétition';

  @override
  String get simpleHabitPeriodicTitle => 'Tous les combien de jours ?';

  @override
  String get simpleHabitPreviewSubtitle => 'Tout semble correct ?';

  @override
  String get simpleHabitPreviewTitle => 'Super ! Voici ton habitude';

  @override
  String get simpleHabitReminderSubtitle =>
      'Ne manque pas ton habitude avec un rappel quotidien';

  @override
  String get simpleHabitReminderTitle => 'Dois-je te le rappeler ?';

  @override
  String get simpleHabitStartDateSubtitle =>
      'Choisis un point de départ pour ton voyage';

  @override
  String get simpleHabitStartDateTitle => 'Quand vas-tu commencer ?';

  @override
  String get simpleHabitTargetOne => 'Habitude simple (objectif = 1)';

  @override
  String get simpleHabitWeekdaysSubtitle => 'Choisis les jours actifs';

  @override
  String get simpleHabitWeekdaysTitle => 'Quels jours ?';

  @override
  String get simpleHabitWizardDesc =>
      'Je vais te guider étape par étape. Créons une super habitude ensemble !';

  @override
  String get simpleHabitWizardTitle =>
      'Prêt à commencer une nouvelle habitude ?';

  @override
  String get simpleTypeShort => 'Simple';

  @override
  String get skip => 'Skip';

  @override
  String get skipOnboarding => 'Ignorer';

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
  String get sound => 'Son';

  @override
  String get soundAlerts => 'Alertes sonores';

  @override
  String get soundSubtitle => 'Jouer un son avec les notifications';

  @override
  String get specificDaysOfMonth => 'Jours spécifiques du mois';

  @override
  String get specificDaysOfWeek => 'Jours spécifiques de la semaine';

  @override
  String get specificDaysOfYear => 'Jours spécifiques de l\'année';

  @override
  String get spendingAdvisorNoBudget =>
      'Définissez un budget pour obtenir des conseils.';

  @override
  String get spendingAdvisorOnTrack =>
      'Génial ! Vous êtes sur la bonne voie avec votre budget.';

  @override
  String get spendingAdvisorOverBudget =>
      'Vous avez dépassé le budget. Arrêtez de dépenser.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Vous pouvez dépenser $amount par jour.';
  }

  @override
  String get spendingAdvisorTitle => 'Conseiller en Dépenses';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Réduisez les dépenses quotidiennes de $amount pour rester sur la bonne voie.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Super! Vous dépensez $amount de moins que la moyenne quotidienne.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Attention! Vous dépensez $amount de plus que la moyenne quotidienne.';
  }

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get start => 'Démarrer';

  @override
  String get startDate => 'Date de début';

  @override
  String get startDateLabel => 'Start';

  @override
  String get startDayLabel => 'Jour de début (1-365)';

  @override
  String get startJourney => 'Commencer votre parcours';

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
  String get statusLabel => 'Statut';

  @override
  String get step => 'Étape';

  @override
  String stepOf(Object current, Object total) {
    return 'Étape $current sur $total';
  }

  @override
  String get steps => 'Pas';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String streakDays(Object count) {
    return 'Série de $count jours';
  }

  @override
  String get streakIndicator => 'Indicateur de série';

  @override
  String get streakIndicatorDesc => 'Afficher les effets de flamme et de glace';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionAngry => 'En colère';

  @override
  String get subEmotionAnxious => 'Anxieux';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => 'Calme';

  @override
  String get subEmotionCheerful => 'Joyeux';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => 'Démoralisé';

  @override
  String get subEmotionDetermined => 'Déterminé';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => 'Épuisé';

  @override
  String get subEmotionEmpty => 'Vide';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionEnthusiastic => 'Enthousiaste';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => 'Excité';

  @override
  String get subEmotionExhausted => 'Épuisé';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => 'Heureux';

  @override
  String get subEmotionHelpless => 'Impuissant';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => 'Désespéré';

  @override
  String get subEmotionHurt => 'Blessé';

  @override
  String get subEmotionIndecisive => 'Indécis';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get subEmotionMotivated => 'Motivé';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => 'Ordinaire';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionProud => 'Fier';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => 'Triste';

  @override
  String get subEmotionSelection => 'Sélection de la sous-émotion';

  @override
  String get subEmotionStressed => 'Stressé';

  @override
  String get subEmotionTired => 'Fatigué';

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
  String get success => 'Succès';

  @override
  String get successfulDayLegend => 'Jour réussi';

  @override
  String successfulDaysCount(Object count) {
    return '$count jours réussis';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'Informations système';

  @override
  String get systemTheme => 'Thème système';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

  @override
  String get target => 'Cible';

  @override
  String get targetDurationMinutes => 'Durée cible (minutes)';

  @override
  String targetShort(Object value) {
    return 'Cible: $value';
  }

  @override
  String get targetType => 'Type de cible';

  @override
  String get targetValue => 'Valeur cible';

  @override
  String get targetValueLabel => 'Valeur cible';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskCompleted => 'Completed';

  @override
  String taskDeletedMessage(Object title) {
    return 'Tâche supprimée: $title';
  }

  @override
  String get taskDescription => 'Description (facultatif)';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskTitle => 'Titre de la tâche';

  @override
  String get taskTitleRequired => 'Le titre de la tâche est requis';

  @override
  String get tellMeYourDream =>
      'Raconte-moi ton rêve. Je t\'aiderai à créer un tableau de vision.';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get templateDetailsNotFound => 'Détails du modèle non trouvés';

  @override
  String get templatesTabManual => 'Manuel';

  @override
  String get templatesTabReady => 'Prêt';

  @override
  String get textLabel => 'Texte';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'Thème';

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
  String get themeDetails => 'Détails du thème';

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
  String get themeSelection => 'Sélection du thème';

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
  String get thisMonth => 'Ce mois-ci';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisYear => 'Cette année';

  @override
  String get thursdayShort => 'Per';

  @override
  String get timer => 'Timer';

  @override
  String get timerCreateTimerHabitFirst =>
      'Créez d\'abord une habitude de minuterie';

  @override
  String get timerDescription => 'Suivi basé sur le temps';

  @override
  String get timerExample => 'Faire une séance d\'entraînement de 30 minutes';

  @override
  String get timerHabitLabel => 'Habitude de minuterie';

  @override
  String get timerPause => 'Pause';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Durée en attente: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'En attente: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Pause';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Travail terminé: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Cycle de pause longue (ex: 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Pause longue (min)';

  @override
  String get timerPomodoroSettings => 'Paramètres Pomodoro';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Pause courte (min)';

  @override
  String get timerPomodoroSkipPhase => 'Passer la phase';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Travail (min)';

  @override
  String get timerPomodoroWorkPhase => 'Travail';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerSaveDurationTitle => 'Enregistrer la durée';

  @override
  String get timerSaveSessionTitle => 'Enregistrer la session';

  @override
  String get timerSessionAlreadySaved => 'Cette session est déjà enregistrée';

  @override
  String get timerSetDurationFirst => 'Définir la durée d\'abord';

  @override
  String get timerSettings => 'Paramètres de la minuterie';

  @override
  String get timerStop => 'Stop';

  @override
  String get timerTabCountdown => 'Compte à rebours';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Chronomètre';

  @override
  String get timerTracking => 'Timer tracking';

  @override
  String get timerType => 'Minuterie';

  @override
  String get times => 'Fois';

  @override
  String get timezone => 'Fuseau horaire';

  @override
  String get titleHint => 'Ex: Courses, Freelance, etc.';

  @override
  String get titleOptional => 'Titre (facultatif)';

  @override
  String get today => 'Today';

  @override
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get totalDuration => 'Durée totale';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalProgress => 'Progrès total';

  @override
  String get totalSuccessfulDays => 'Total des jours réussis';

  @override
  String get totalUnsuccessfulDays => 'Total des jours non réussis';

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
  String get typeLabel => 'Type';

  @override
  String get typeNotChangeable => 'Le type ne peut pas être modifié';

  @override
  String get unassignLinkedDailyTasks =>
      'Désassigner les tâches quotidiennes liées';

  @override
  String get unassignLinkedHabits => 'Désassigner les habitudes liées';

  @override
  String get undo => 'Annuler';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get unit => 'Unité';

  @override
  String get unitAdet => 'pcs';

  @override
  String get unitAdim => 'pas';

  @override
  String get unitBardak => 'verre';

  @override
  String get unitHint => 'Unité (verre, pas, page...)';

  @override
  String get unitKalori => 'cal';

  @override
  String get unitKez => 'fois';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'litre';

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
  String get update => 'Mettre à jour';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get validity => 'Validity';

  @override
  String get valueLabel => 'Valeur';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSubtitle => 'Vibrer avec les notifications';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get vision => 'Vision';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Cette vision utilisera le dernier jour du modèle: $day.';
  }

  @override
  String get visionBoard => 'Tableau de Vision';

  @override
  String get visionBoardDesc =>
      'Crée une vision pour organiser tes objectifs et suivre ton parcours';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionCreateTitle => 'Créer une vision';

  @override
  String get visionDurationDaysLabel => 'Durée (jours)';

  @override
  String get visionDurationNote =>
      'Remarque: Lorsque la vision commence, une durée totale est définie; si le jour de fin dépasse cette durée, il sera automatiquement raccourci.';

  @override
  String get visionEditTitle => 'Modifier la vision';

  @override
  String get visionEmptyDescription =>
      'Visualise tes objectifs et ajoute ta première vision pour transformer tes rêves en réalité.';

  @override
  String get visionEndDayInvalid =>
      'Le jour de fin doit être compris entre 1 et 365';

  @override
  String get visionEndDayLess =>
      'Le jour de fin ne peut pas être antérieur au jour de début';

  @override
  String get visionEndDayQuestion =>
      'Quel jour de la vision doit-elle se terminer?';

  @override
  String get visionEndDayRequired => 'Entrez le jour de fin';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get visionNoEndDurationInfo =>
      'Aucun jour de fin spécifié. La vision commencera sans durée définie.';

  @override
  String get visionPlural => 'Visions';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionStartDayInvalid =>
      'Le jour de début doit être compris entre 1 et 365';

  @override
  String get visionStartDayQuestion =>
      'Quel jour de la vision doit-elle commencer?';

  @override
  String get visionStartFailed => 'Impossible de démarrer la vision.';

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Vision démarrée: $title';
  }

  @override
  String get visionTasks => 'Tasks';

  @override
  String get visual => 'Visuel';

  @override
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get weekdaysShortFri => 'Ven';

  @override
  String get weekdaysShortMon => 'Lun';

  @override
  String get weekdaysShortSat => 'Sam';

  @override
  String get weekdaysShortSun => 'Dim';

  @override
  String get weekdaysShortThu => 'Jeu';

  @override
  String get weekdaysShortTue => 'Mar';

  @override
  String get weekdaysShortWed => 'Mer';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => 'Résumé hebdomadaire par e-mail';

  @override
  String get weeklyProgress => 'Progrès hebdomadaire';

  @override
  String get weeklySummaryEmail => 'E-mail de résumé hebdomadaire';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get whatsTheCause => 'Quelle en est la cause ?';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => 'Quels jours doivent être actifs?';

  @override
  String get whichWeekdays => 'Quels jours de la semaine?';

  @override
  String get worldTheme => 'Monde';

  @override
  String get worldThemeDesc => 'Harmonie de toutes les couleurs';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP pour le niveau suivant';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get yearly => 'Annuel';

  @override
  String get yearlyProgress => 'Progrès annuel';

  @override
  String get yesNoDescription => 'Suivi simple oui/non';

  @override
  String get yesNoExample => 'Ai-je médité aujourd\'hui?';

  @override
  String get yesNoType => 'Oui/Non';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourCharacterType => 'Your Character Type';

  @override
  String get yourEmail => 'Votre e-mail';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get yourMoodToday => 'Your Mood Today';

  @override
  String get dailyHabitInfo => 'Cette habitude se répétera tous les jours';

  @override
  String get whichDays => 'Hangi günler?';

  @override
  String get whichMonthDays => 'Quels jours du mois?';

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
      'Maximisez Vos Habitudes Selon Votre Horloge Biologique';

  @override
  String get rhythmTeaserSubtitle =>
      'Live Rhythm apprend vos moments les plus productifs et place les habitudes au bon moment.';

  @override
  String get rhythmTeaserSkip => 'Passer';

  @override
  String get rhythmTeaserCta => 'Voir les Forfaits';

  @override
  String get rhythmWindowFocus => 'Temps de Concentration';

  @override
  String get rhythmWindowFocusDesc => 'Clarté mentale, apprentissage, analyse';

  @override
  String get rhythmWindowEnergy => 'Temps d\'Énergie';

  @override
  String get rhythmWindowEnergyDesc => 'Mouvement, action, sports';

  @override
  String get rhythmWindowLight => 'Temps Léger';

  @override
  String get rhythmWindowLightDesc => 'Faible effort, petites tâches';

  @override
  String get rhythmWindowReflection => 'Temps de Réflexion';

  @override
  String get rhythmWindowReflectionDesc => 'Journal, contemplation, clôture';

  @override
  String get rhythmBenefit1 => 'La bonne tâche au bon moment';

  @override
  String get rhythmBenefit2 => 'Pas de fatigue décisionnelle';

  @override
  String get rhythmBenefit3 => 'Personnalisation chaque semaine';

  @override
  String get rhythmAnalyzing => 'Live Rhythm analyse...';

  @override
  String get rhythmDisclaimer =>
      'Ce ne sont pas des résultats définitifs. Live Rhythm s\'ajustera en vous connaissant.';

  @override
  String get rhythmQ1 => 'À quelle heure vous couchez-vous habituellement?';

  @override
  String get rhythmQ2 => 'À quelle heure vous réveillez-vous habituellement?';

  @override
  String get rhythmQ3 =>
      'Quand abordez-vous les tâches difficiles le plus confortablement?';

  @override
  String get rhythmQ4 =>
      'Quand vous sentez-vous le plus lucide pour apprendre?';

  @override
  String get rhythmQ5 =>
      'À quel moment de la journée vous sentez-vous plus énergique?';

  @override
  String get rhythmQ6 =>
      'Quand l\'exercice physique vous semble-t-il le plus facile?';

  @override
  String get rhythmQ7 =>
      'À quel moment de la journée avez-vous tendance à procrastiner?';

  @override
  String get rhythmQ8 =>
      'Que faites-vous habituellement pendant ces moments de faible énergie?';

  @override
  String get rhythmQ9 =>
      'À la fin de la journée, qu\'est-ce qui vous convient le mieux?';

  @override
  String get rhythmQ10 => 'Comment votre esprit se sent-il le soir?';

  @override
  String get rhythmQ11 => 'Avec lequel vous identifiez-vous le plus?';

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
  String get rhythmA3_1 => 'Tôt le matin';

  @override
  String get rhythmA3_2 => 'Milieu de matinée';

  @override
  String get rhythmA3_3 => 'Après-midi';

  @override
  String get rhythmA3_4 => 'Soir';

  @override
  String get rhythmA3_5 => 'Pas de différence';

  @override
  String get rhythmA4_1 => 'Matin';

  @override
  String get rhythmA4_2 => 'Midi';

  @override
  String get rhythmA4_3 => 'Soir';

  @override
  String get rhythmA4_4 => 'Nuit';

  @override
  String get rhythmA4_5 => 'Variable';

  @override
  String get rhythmA5_1 => 'Matin';

  @override
  String get rhythmA5_2 => 'Midi';

  @override
  String get rhythmA5_3 => 'Soir';

  @override
  String get rhythmA5_4 => 'Aucun';

  @override
  String get rhythmA5_5 => 'Fluctue au cours de la journée';

  @override
  String get rhythmA6_1 => 'Matin';

  @override
  String get rhythmA6_2 => 'Après-midi';

  @override
  String get rhythmA6_3 => 'Soir';

  @override
  String get rhythmA6_4 => 'Pas de différence';

  @override
  String get rhythmA7_1 => 'Après midi';

  @override
  String get rhythmA7_2 => 'Fin d\'après-midi';

  @override
  String get rhythmA7_3 => 'Nuit';

  @override
  String get rhythmA7_4 => 'Pas spécifique';

  @override
  String get rhythmA8_1 => 'Je navigue sur les réseaux sociaux';

  @override
  String get rhythmA8_2 => 'Je fais des tâches simples';

  @override
  String get rhythmA8_3 => 'Je me repose';

  @override
  String get rhythmA8_4 => 'J\'essaie de tenir';

  @override
  String get rhythmA9_1 => 'Écrire / réfléchir';

  @override
  String get rhythmA9_2 => 'Repos calme';

  @override
  String get rhythmA9_3 => 'Lire';

  @override
  String get rhythmA9_4 => 'Aller dormir directement';

  @override
  String get rhythmA10_1 => 'Calme et posé';

  @override
  String get rhythmA10_2 => 'Fatigué mais réfléchi';

  @override
  String get rhythmA10_3 => 'Dispersé';

  @override
  String get rhythmA10_4 => 'Encore actif';

  @override
  String get rhythmA11_1 => 'Je suis une personne du matin';

  @override
  String get rhythmA11_2 => 'Je suis une personne du soir';

  @override
  String get rhythmA11_3 => 'Je suis entre les deux';

  @override
  String get rhythmA11_4 => 'Ça change selon la saison';

  @override
  String get testsSection => 'Tests';

  @override
  String get retakePersonalityTestDesc =>
      'Redécouvrez votre type de personnalité';

  @override
  String get retakeRhythmTest => 'Refaire le Test de Rythme';

  @override
  String get retakeRhythmTestDesc => 'Reconfigurer votre horloge biologique';

  @override
  String get rhythmWindowStepTitle => 'Meilleur Créneau Horaire';

  @override
  String get rhythmWindowStepSubtitle =>
      'Quand aimeriez-vous faire cette habitude?';

  @override
  String get rhythmWindowNoProfileHint =>
      'Complétez le test de rythme pour obtenir des suggestions personnalisées';

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
