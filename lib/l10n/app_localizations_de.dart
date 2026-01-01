// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über';

  @override
  String get account => 'Konto';

  @override
  String get achievements => 'Erfolge';

  @override
  String get activeDays => 'Aktive Tage';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addHabit => 'Gewohnheit hinzufügen';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get addNew => 'Neu hinzufügen';

  @override
  String get addNewHabit => 'Neue Gewohnheit hinzufügen';

  @override
  String get addSpecialDays => 'Besondere Tage hinzufügen';

  @override
  String get addText => 'Text hinzufügen';

  @override
  String get advancedHabit => 'Erweiterte Gewohnheit';

  @override
  String get allLabel => 'Alle';

  @override
  String get alsoDeleteLinkedHabits =>
      'Verknüpfte Gewohnheiten ebenfalls löschen';

  @override
  String get amountLabel => 'Betrag';

  @override
  String get socialFeedTitle => 'Feed';

  @override
  String get spendingAdvisorTitle => 'Ausgabenberater';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Sie können täglich $amount ausgeben.';
  }

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Reduzieren Sie die täglichen Ausgaben um $amount, um im Plan zu bleiben.';
  }

  @override
  String get spendingAdvisorOnTrack =>
      'Großartig! Sie liegen mit Ihrem Budget im Plan.';

  @override
  String get spendingAdvisorOverBudget =>
      'Sie haben das Budget überschritten. Stoppen Sie die Ausgaben.';

  @override
  String get spendingAdvisorNoBudget =>
      'Legen Sie ein Budget fest, um Ratschläge zu erhalten.';

  @override
  String get appTitle => 'Mira';

  @override
  String get signInToSaveData => 'Verileri kaydetmek için giriş yap';

  @override
  String get guestAccount => 'Misafir Hesabı';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String get subscription => 'Abonelik';

  @override
  String get manageSubscription => 'Abonnement verwalten';

  @override
  String get backupNow => 'Backup Now';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get emptyHabitTitle => 'Yolculuğuna Başla';

  @override
  String get emptyHabitSubtitle =>
      'İlerlemeni takip etmek için ilk alışkanlığını oluştur.';

  @override
  String get createFirstHabit => 'Alışkanlık Oluştur';

  @override
  String get enterValueTitle => 'Wert eingeben';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notificationSettingsSubtitle =>
      'Konfigurieren Sie Ihre Benachrichtigungseinstellungen';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get notificationsMasterSubtitle =>
      'Alle App-Benachrichtigungen steuern';

  @override
  String get notificationTypes => 'Benachrichtigungstypen';

  @override
  String get habitReminders => 'Gewohnheitserinnerungen';

  @override
  String get habitRemindersSubtitle =>
      'Tägliche Erinnerungen für Ihre Gewohnheiten';

  @override
  String get notificationBehavior => 'Benachrichtigungsverhalten';

  @override
  String get sound => 'Ton';

  @override
  String get soundSubtitle => 'Ton bei Benachrichtigungen abspielen';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSubtitle => 'Bei Benachrichtigungen vibrieren';

  @override
  String get systemInfo => 'Systeminformationen';

  @override
  String get timezone => 'Zeitzone';

  @override
  String get notificationPermission => 'Benachrichtigungsberechtigung';

  @override
  String get exactAlarmPermission => 'Genaue Alarmberechtigung (Android 12+)';

  @override
  String get granted => 'Gewährt';

  @override
  String get notGranted => 'Nicht gewährt';

  @override
  String get importantNotice => 'Wichtiger Hinweis';

  @override
  String get notificationTroubleshooting =>
      'Damit Benachrichtigungen ordnungsgemäß funktionieren:\n\n• Schalten Sie die Akkuoptimierung AUS\n• ERLAUBEN Sie Hintergrundaktivitäten\n• Stellen Sie sicher, dass die Benachrichtigungsberechtigungen EINgeschaltet sind\n• Überprüfen Sie den \'Nicht stören\'-Modus';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Diese Vision dauert etwa $days Tage';
  }

  @override
  String get assetsReloadHint =>
      'Ein vollständiger Neustart der App kann erforderlich sein, um einige Assets zu laden.';

  @override
  String get atLeast => 'Mindestens';

  @override
  String get atMost => 'Höchstens';

  @override
  String get backgroundPlate => 'Hintergrundplatte';

  @override
  String get badgeActive100dDesc => 'Sei an 100 verschiedenen Tagen aktiv';

  @override
  String get badgeActive100dTitle => '100 Tage aktiv';

  @override
  String get badgeActive30dDesc => 'Sei an 30 verschiedenen Tagen aktiv';

  @override
  String get badgeActive30dTitle => '30 Tage aktiv';

  @override
  String get badgeActive7dDesc => 'Sei an 7 verschiedenen Tagen aktiv';

  @override
  String get badgeActive7dTitle => '7 Tage aktiv';

  @override
  String get badgeCategoryActivity => 'Aktivität';

  @override
  String get badgeCategoryFinance => 'Finanzen';

  @override
  String get badgeCategoryHabit => 'Gewohnheit';

  @override
  String get badgeCategoryLevel => 'Level';

  @override
  String get badgeCategoryVision => 'Vision';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => '100 Transaktionen protokollieren';

  @override
  String get badgeFin100Title => 'Finanzier 100';

  @override
  String get badgeFin10Desc => '10 Transaktionen protokollieren';

  @override
  String get badgeFin10Title => 'Finanzier 10';

  @override
  String get badgeFin250Desc => '250 Transaktionen protokollieren';

  @override
  String get badgeFin250Title => 'Finanzier 250';

  @override
  String get badgeFin50Desc => '50 Transaktionen protokollieren';

  @override
  String get badgeFin50Title => 'Finanzier 50';

  @override
  String get badgeHabit100Desc => 'Insgesamt 100 Gewohnheiten abschließen';

  @override
  String get badgeHabit100Title => 'Gewohnheit 100';

  @override
  String get badgeHabit10Desc => 'Insgesamt 10 Gewohnheiten abschließen';

  @override
  String get badgeHabit10Title => 'Gewohnheit 10';

  @override
  String get badgeHabit200Desc => 'Insgesamt 200 Gewohnheiten abschließen';

  @override
  String get badgeHabit200Title => 'Gewohnheit 200';

  @override
  String get badgeHabit50Desc => 'Insgesamt 50 Gewohnheiten abschließen';

  @override
  String get badgeHabit50Title => 'Gewohnheit 50';

  @override
  String get badgeLevel10Desc => 'Erreiche Level 10';

  @override
  String get badgeLevel10Title => 'Level 10';

  @override
  String get badgeLevel20Desc => 'Erreiche Level 20';

  @override
  String get badgeLevel20Title => 'Level 20';

  @override
  String get badgeLevel5Desc => 'Erreiche Level 5';

  @override
  String get badgeLevel5Title => 'Level 5';

  @override
  String get badgeVision10Desc => '10 Visionen erstellen';

  @override
  String get badgeVision10Title => 'Visions-Großmeister';

  @override
  String get badgeVision1Desc => 'Erstelle deine erste Vision';

  @override
  String get badgeVision1Title => 'Visionär';

  @override
  String get badgeVision5Desc => '5 Visionen erstellen';

  @override
  String get badgeVision5Title => 'Visions-Meister';

  @override
  String get badgeVisionHabits3Desc =>
      'Verknüpfe 3+ Gewohnheiten mit einer Vision';

  @override
  String get badgeVisionHabits3Title => 'Verbinder';

  @override
  String get badgeXp1000Desc => 'Verdiene insgesamt 1000 XP';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => 'Verdiene insgesamt 500 XP';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get between1And360 => 'Zwischen 1 und 360';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Eine kurze Biografie über dich';

  @override
  String get breakTime => 'Pause';

  @override
  String get breakdownByCategory => 'Aufschlüsselung nach Kategorie';

  @override
  String get bringForward => 'Nach vorne bringen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get category => 'Kategorie';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get chooseBestCategory =>
      'Wähle die beste Kategorie für deine Gewohnheit';

  @override
  String get chooseColor => 'Farbe wählen:';

  @override
  String get chooseEmoji => 'Emoji wählen:';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get close => 'Schließen';

  @override
  String get colorLabel => 'Farbe';

  @override
  String get colorTheme => 'Farbdesign';

  @override
  String get countdownConfigureTitle => 'Countdown konfigurieren';

  @override
  String get continueText => 'Devam Et';

  @override
  String get create => 'Erstellen';

  @override
  String get createAdvancedHabit => 'Erweiterte Gewohnheit erstellen';

  @override
  String get createDailyTask => 'Tägliche Aufgabe erstellen';

  @override
  String get createHabitTemplateTitle => 'Gewohnheitsvorlage erstellen';

  @override
  String get createList => 'Liste erstellen';

  @override
  String get createNewCategory => 'Neue Kategorie erstellen';

  @override
  String get createVision => 'Vision erstellen';

  @override
  String get createVisionTemplateTitle => 'Visionsvorlage erstellen';

  @override
  String get customCategories => 'Benutzerdefinierte Kategorien';

  @override
  String get customEmojiHint => 'Bsp.: ✨';

  @override
  String get customEmojiOptional => 'Benutzerdefiniertes Emoji (optional)';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get enableReminder => 'Erinnerung aktivieren';

  @override
  String get selectTime => 'Zeit auswählen';

  @override
  String get customFrequency => 'Benutzerdefiniert';

  @override
  String get daily => 'Täglich';

  @override
  String get dailyCheck => 'Tägliche Überprüfung';

  @override
  String get dailyLimit => 'Tageslimit';

  @override
  String get dailyTask => 'Tägliche Aufgabe';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get date => 'Datum';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Tag $start–$end';
  }

  @override
  String dayShort(Object day) {
    return 'Tag $day';
  }

  @override
  String daysAverageShort(Object days) {
    return '${days}T Durschn.';
  }

  @override
  String get delete => 'Löschen';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return 'Die Kategorie \"$name\" löschen?';
  }

  @override
  String get deleteCategoryTitle => 'Kategorie löschen';

  @override
  String get deleteCustomCategoryConfirm =>
      'Diese benutzerdefinierte Kategorie löschen?';

  @override
  String get deleteEntryConfirm => 'Diesen Eintrag löschen?';

  @override
  String deleteTransactionConfirm(Object title) {
    return 'Den Datensatz \"$title\" löschen?';
  }

  @override
  String get deleteVisionMessage => 'Diese Vision löschen?';

  @override
  String get deleteVisionTitle => 'Vision löschen';

  @override
  String get descHint => 'Details zu deiner Gewohnheit (optional)';

  @override
  String get difficulty => 'Schwierigkeitsgrad';

  @override
  String get duration => 'Dauer';

  @override
  String get durationAutoLabel => 'Dauer (automatisch)';

  @override
  String get durationSelection => 'Dauerauswahl';

  @override
  String get durationType => 'Dauertyp';

  @override
  String get earthTheme => 'Erde';

  @override
  String get earthThemeDesc => 'Erdfarben';

  @override
  String get easy => 'Einfach';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get editHabit => 'Gewohnheit bearbeiten';

  @override
  String get education => 'Bildung';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get endDate => 'Enddatum';

  @override
  String get endDayOptionalLabel => 'Endtag (optional)';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Gib einen Monatsplan ein, um ein Tageslimit zu berechnen.';

  @override
  String get enterNameAndDesc =>
      'Gib den Namen und die Beschreibung deiner Gewohnheit ein';

  @override
  String get enterYourName => 'Gib deinen Namen ein';

  @override
  String get entries => 'Einträge';

  @override
  String get everyNDaysQuestion => 'Alle wie viele Tage?';

  @override
  String get everyday => 'Jeden Tag';

  @override
  String get exact => 'Genau';

  @override
  String examplePrefix(Object example) {
    return 'Beispiel: $example';
  }

  @override
  String get expenseDelta => 'Ausgaben Δ';

  @override
  String get expenseDistributionPie => 'Ausgabenverteilung (Kuchen)';

  @override
  String get expenseEditTitle => 'Ausgabe bearbeiten';

  @override
  String get expenseLabel => 'Ausgabe';

  @override
  String get expenseNewTitle => 'Neue Ausgabe';

  @override
  String failedToLoad(Object error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String get filterTitle => 'Filter';

  @override
  String get finance => 'Finanzen';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Finanzanalyse · $month';
  }

  @override
  String get financeLast7Days => 'Finanzen · Letzte 7 Tage';

  @override
  String get finish => 'Fertig';

  @override
  String get historyTitle => 'History';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Fest';

  @override
  String get font => 'Schriftart';

  @override
  String get forestTheme => 'Wald';

  @override
  String get forestThemeDesc => 'Natürliches grünes Design';

  @override
  String get forever => 'Für immer';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get fullScreen => 'Vollbild';

  @override
  String get gallery => 'Galerie';

  @override
  String get general => 'Allgemein';

  @override
  String get generalNotifications => 'Allgemeine Benachrichtigungen';

  @override
  String get glasses => 'Gläser';

  @override
  String get goldenTheme => 'Golden';

  @override
  String get goldenThemeDesc => 'Warmes goldenes Design';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get habit => 'Gewohnheit';

  @override
  String get habitDescription => 'Beschreibung';

  @override
  String get habitDetails => 'Gewohnheitsdetails';

  @override
  String get habitName => 'Gewohnheitsname';

  @override
  String get habitOfThisVision => 'Gewohnheit dieser Vision';

  @override
  String get habits => 'Gewohnheit';

  @override
  String get hard => 'Schwer';

  @override
  String get headerFocusLabel => 'Fokus';

  @override
  String get headerFocusReady => 'Bereit';

  @override
  String get headerHabitsLabel => 'Gewohnheit';

  @override
  String get health => 'Gesundheit';

  @override
  String get hours => 'Stunden';

  @override
  String get howOftenDoHabit =>
      'Entscheide, wie oft du deine Gewohnheit ausführen möchtest';

  @override
  String get howToEarn => 'Wie man verdient';

  @override
  String get howToTrackHabit =>
      'Wähle aus, wie deine Gewohnheit verfolgt werden soll';

  @override
  String get ifCondition => 'Wenn';

  @override
  String get importFromLink => 'Aus Link importieren';

  @override
  String get incomeDelta => 'Einkommens-Δ';

  @override
  String get incomeEditTitle => 'Einkommen bearbeiten';

  @override
  String get incomeLabel => 'Einkommen';

  @override
  String get incomeNewTitle => 'Neues Einkommen';

  @override
  String get input => 'Eingabe';

  @override
  String get invalidLink => 'Ungültiger Link.';

  @override
  String get language => 'Sprache';

  @override
  String get languageSelection => 'Sprachauswahl';

  @override
  String levelLabel(Object level) {
    return 'Level $level';
  }

  @override
  String levelShort(Object level) {
    return 'L$level';
  }

  @override
  String get lightTheme => 'Helles Design';

  @override
  String get linkHabits => 'Gewohnheiten verknüpfen';

  @override
  String get listLabel => 'Liste';

  @override
  String get loadingHabits => 'Gewohnheiten werden geladen...';

  @override
  String get logout => 'Abmelden';

  @override
  String get manageLists => 'Listen verwalten';

  @override
  String get medium => 'Mittel';

  @override
  String get mindfulness => 'Achtsamkeit';

  @override
  String get minutes => 'Minuten';

  @override
  String get minutesSuffixShort => 'min';

  @override
  String get monthCount => 'Anzahl der Monate';

  @override
  String get monthCountHint => 'Bsp.: 12';

  @override
  String get monthSuffixShort => 'Mo';

  @override
  String get monthly => 'Monatlich';

  @override
  String get monthlyTrend => 'Monatlicher Trend';

  @override
  String get mood => 'Stimmung';

  @override
  String get moodBad => 'Schlecht';

  @override
  String get moodGood => 'Gut';

  @override
  String get moodGreat => 'Großartig';

  @override
  String get moodOk => 'Okay';

  @override
  String get moodTerrible => 'Saugt';

  @override
  String get mtdAverageShort => 'MTD Durschn.';

  @override
  String get multiple => 'Mehrere';

  @override
  String get mysticTheme => 'Mystisch';

  @override
  String get mysticThemeDesc => 'Mystisches lila Design';

  @override
  String nDaysLabel(Object count) {
    return '$count Tage';
  }

  @override
  String get nameHint => 'Bsp.: Tägliches Training';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get newHabits => 'Neue Gewohnheiten';

  @override
  String get next => 'Weiter';

  @override
  String get nextLabel => 'Weiter';

  @override
  String get nextYear => 'Nächstes Jahr';

  @override
  String get noDataLast7Days => 'Keine Daten für die letzten 7 Tage';

  @override
  String get noDataThisMonth => 'Keine Daten für diesen Monat';

  @override
  String get noEndDate => 'Kein Enddatum';

  @override
  String get noEndDayDefaultsDaily =>
      'Wenn kein Endtag festgelegt ist, wird diese Gewohnheit standardmäßig jeden Tag angezeigt.';

  @override
  String get noEntriesYet => 'Noch keine Einträge';

  @override
  String get noExpenseInThisCategory => 'Keine Ausgaben in dieser Kategorie';

  @override
  String get noExpenses => 'Keine Ausgaben';

  @override
  String get noExpensesThisMonth => 'Keine Ausgaben für diesen Monat';

  @override
  String get noHabitsAddedYet => 'Noch keine Gewohnheiten hinzugefügt.';

  @override
  String get noIncomeThisMonth => 'Kein Einkommen für diesen Monat';

  @override
  String get noLinkedHabitsInVision =>
      'Keine Gewohnheiten mit dieser Vision verknüpft.';

  @override
  String get noReadyVisionsFound => 'Keine fertigen Visionen gefunden.';

  @override
  String get noRecordsThisMonth => 'Keine Datensätze für diesen Monat';

  @override
  String get notAddedYet => 'Noch nicht hinzugefügt.';

  @override
  String get notUnlocked => 'Nicht freigeschaltet';

  @override
  String get noteOptional => 'Notiz (optional)';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get numberLabel => 'Nummer';

  @override
  String get numericExample => 'Trinke 8 Gläser Wasser pro Tag';

  @override
  String get numericSettings => 'Numerische Zieleinstellungen';

  @override
  String get numericalDescription => 'Numerische Zielverfolgung';

  @override
  String get numericalGoalShort => 'Numerisches Ziel';

  @override
  String get numericalType => 'Numerischer Wert';

  @override
  String get oceanTheme => 'Ozean';

  @override
  String get oceanThemeDesc => 'Ruhiges blaues Design';

  @override
  String get onDailyLimit => 'Du hast dein Tageslimit erreicht.';

  @override
  String get onPeriodic => 'In bestimmten Intervallen';

  @override
  String get onSpecificMonthDays => 'An bestimmten Monatstagen';

  @override
  String get onSpecificWeekdays => 'An bestimmten Wochentagen';

  @override
  String get onSpecificYearDays => 'An bestimmten Jahrestagen';

  @override
  String get once => 'Einmal';

  @override
  String get other => 'Sonstiges';

  @override
  String get outline => 'Umriss';

  @override
  String get outlineColor => 'Umrissfarbe';

  @override
  String get pages => 'Seiten';

  @override
  String get pause => 'Pause';

  @override
  String get periodicSelection => 'Periodische Auswahl';

  @override
  String get pickTodaysMood => 'Wähle die heutige Stimmung';

  @override
  String get plannedMonthlySpend => 'Geplante monatliche Ausgaben';

  @override
  String get plateColor => 'Plattenfarbe';

  @override
  String get previous => 'Zurück';

  @override
  String get previousYear => 'Vorheriges Jahr';

  @override
  String get privacySecurity => 'Datenschutz & Sicherheit';

  @override
  String get productivity => 'Produktivität';

  @override
  String get profile => 'Profil';

  @override
  String get profileInfo => 'Profilinformationen';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get readyVisionsLoadFailed =>
      'Fertige Visionen konnten nicht geladen werden.';

  @override
  String get recurringMonthlyDesc =>
      'Jeden Monat am ausgewählten Datum automatisch hinzufügen';

  @override
  String get recurringMonthlyTitle => 'Wiederkehrend (monatlich)';

  @override
  String get reload => 'Neu laden';

  @override
  String get remainingToday => 'Heute verbleibend';

  @override
  String get reminderFrequency => 'Erinnerungshäufigkeit';

  @override
  String get reminderSettings => 'Erinnerungseinstellungen';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get repeatEveryDay => 'Wiederholt sich jeden Tag';

  @override
  String get repeatEveryNDays => 'Alle N Tage wiederholen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Regel: Eingegebene Dauer ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Regel: Eingegebene Dauer ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Regel: Eingegebene Dauer = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Regel: Eingegebener Wert ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Regel: Eingegebener Wert ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Regel: Eingegebener Wert = $target';
  }

  @override
  String get save => 'Speichern';

  @override
  String get saved => 'Gespeichert';

  @override
  String get savingsBudgetPlan => 'Spar- / Budgetplan';

  @override
  String get scheduleHabit => 'Lege den Zeitplan für deine Gewohnheit fest';

  @override
  String get scheduleLabel => 'Zeitplan';

  @override
  String get schedulingOptions => 'Planungsoptionen';

  @override
  String get seconds => 'Sekunden';

  @override
  String get select => 'Auswählen';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get selectCategory => 'Kategorie auswählen';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get selectEndDate => 'Enddatum auswählen';

  @override
  String get selectFrequency => 'Häufigkeit auswählen';

  @override
  String get selectHabitType => 'Gewohnheitstyp auswählen';

  @override
  String get sendBackward => 'Nach hinten senden';

  @override
  String get settings => 'Einstellungen';

  @override
  String get shareAsLink => 'Als Link teilen';

  @override
  String get shareLinkCopied => 'Teilen-Link in die Zwischenablage kopiert.';

  @override
  String get shareVision => 'Vision teilen';

  @override
  String get social => 'Sozial';

  @override
  String get soundAlerts => 'Akustische Warnungen';

  @override
  String get specificDaysOfMonth => 'Bestimmte Tage des Monats';

  @override
  String get specificDaysOfWeek => 'Bestimmte Tage der Woche';

  @override
  String get specificDaysOfYear => 'Bestimmte Tage des Jahres';

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Großartig! Du gibst $amount weniger aus als der Tagesdurchschnitt.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Warnung! Du gibst $amount mehr aus als der Tagesdurchschnitt.';
  }

  @override
  String get start => 'Start';

  @override
  String get startDate => 'Startdatum';

  @override
  String get startDayLabel => 'Starttag (1-365)';

  @override
  String get statusLabel => 'Status';

  @override
  String get step => 'Schritt';

  @override
  String stepOf(Object current, Object total) {
    return 'Schritt $current von $total';
  }

  @override
  String get steps => 'Schritte';

  @override
  String streakDays(Object count) {
    return '$count Tage Serie';
  }

  @override
  String get streakIndicator => 'Serienanzeige';

  @override
  String get streakIndicatorDesc => 'Flammen- und Eiseffekte anzeigen';

  @override
  String successfulDaysCount(Object count) {
    return '$count erfolgreiche Tage';
  }

  @override
  String get systemTheme => 'Systemdesign';

  @override
  String get targetDurationMinutes => 'Zieldauer (Minuten)';

  @override
  String targetShort(Object value) {
    return 'Ziel: $value';
  }

  @override
  String get targetType => 'Zieltyp';

  @override
  String get targetValue => 'Zielwert';

  @override
  String get targetValueLabel => 'Zielwert';

  @override
  String get taskDescription => 'Beschreibung (Optional)';

  @override
  String get taskTitle => 'Aufgabentitel';

  @override
  String get templateDetailsNotFound => 'Vorlagendetails nicht gefunden';

  @override
  String get templatesTabManual => 'Manuell';

  @override
  String get templatesTabReady => 'Fertig';

  @override
  String get enterPromoCode => 'Please enter a promo code';

  @override
  String get promoCodeSuccess =>
      '🎉 Promo code applied successfully! Premium access activated.';

  @override
  String get promoCodeAlreadyUsed =>
      'A promo code has already been used on this account.';

  @override
  String get promoCodeInvalid =>
      'Invalid promo code. Please check and try again.';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get promoCodeLabel => 'Promo Code';

  @override
  String get promoCodeActiveMessage =>
      'Your Premium access is activated via promo code ✨';

  @override
  String get promoCodeHint => 'Enter your promo code';

  @override
  String get applying => 'Applying...';

  @override
  String get applyCode => 'Apply Code';

  @override
  String get visionSettingsTooltip => 'Freeform board settings';

  @override
  String get visionBoardViewTooltip => 'Board view';

  @override
  String get visionFreeformTooltip => 'Freeform board';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get selectMonthTooltip => 'Select month';

  @override
  String get analysisTooltip => 'Analysis';

  @override
  String get shareBoard => 'Share board';

  @override
  String get roundCorners => 'Round Corners';

  @override
  String get showText => 'Show text';

  @override
  String get showProgress => 'Show progress';

  @override
  String get myBoard => 'My Board';

  @override
  String get textLabel => 'Text';

  @override
  String get theme => 'Design';

  @override
  String get themeCotton => 'Cotton';

  @override
  String get themeCottonDesc => 'Warm & Neutral';

  @override
  String get themeMatcha => 'Matcha';

  @override
  String get themeMatchaDesc => 'Fresh & Natural';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeLavenderDesc => 'Calm & Dreamy';

  @override
  String get themeSky => 'Sky';

  @override
  String get themeSkyDesc => 'Airy & Light';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeRoseDesc => 'Soft & Warm';

  @override
  String get themeSlate => 'Slate';

  @override
  String get themeSlateDesc => 'Modern & Cool';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeOceanDesc => 'Deep & Serene';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeSunsetDesc => 'Warm & Golden';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeForestDesc => 'Rich & Organic';

  @override
  String get themeDetails => 'Design-Details';

  @override
  String get themeSelection => 'Design-Auswahl';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get timerCreateTimerHabitFirst =>
      'Erstelle zuerst eine Timer-Gewohnheit';

  @override
  String get timerDescription => 'Zeitbasiertes Tracking';

  @override
  String get timerExample => 'Mache ein 30-minütiges Training';

  @override
  String get timerHabitLabel => 'Timer-Gewohnheit';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Ausstehende Dauer: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Ausstehend: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Pause';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Abgeschlossene Arbeit: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Langer Pausenzyklus (z. B. 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Lange Pause (min)';

  @override
  String get timerPomodoroSettings => 'Pomodoro-Einstellungen';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Kurze Pause (min)';

  @override
  String get timerPomodoroSkipPhase => 'Phase überspringen';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Arbeit (min)';

  @override
  String get timerPomodoroWorkPhase => 'Arbeit';

  @override
  String get timerSaveDurationTitle => 'Dauer speichern';

  @override
  String get timerSaveSessionTitle => 'Sitzung speichern';

  @override
  String get timerQuickPresets => 'Quick Presets';

  @override
  String get timerSessionAlreadySaved =>
      'Diese Sitzung ist bereits gespeichert';

  @override
  String get totalDuration => 'Gesamtdauer';

  @override
  String get timerSetDurationFirst => 'Zuerst Dauer einstellen';

  @override
  String get timerSettings => 'Timer-Einstellungen';

  @override
  String get timerTabCountdown => 'Countdown';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Stoppuhr';

  @override
  String get timerType => 'Timer';

  @override
  String get checkboxType => 'Checkbox';

  @override
  String get subtasksType => 'Subtasks';

  @override
  String get times => 'Mal';

  @override
  String get titleHint => 'Bsp.: Lebensmittel, Freiberuflich, etc.';

  @override
  String get titleOptional => 'Titel (optional)';

  @override
  String get typeLabel => 'Typ';

  @override
  String get unit => 'Einheit';

  @override
  String get unitHint => 'Einheit (Glas, Schritt, Seite...)';

  @override
  String get update => 'Aktualisieren';

  @override
  String get vision => 'Vision';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Diese Vision verwendet den letzten Tag in der Vorlage: $day.';
  }

  @override
  String get visionCreateTitle => 'Vision erstellen';

  @override
  String get visionDurationNote =>
      'Hinweis: Wenn die Vision beginnt, wird eine Gesamtdauer festgelegt; wenn der Endtag diese Dauer überschreitet, wird er automatisch verkürzt.';

  @override
  String get visionEditTitle => 'Vision bearbeiten';

  @override
  String get visionEndDayInvalid => 'Endtag muss zwischen 1 und 365 liegen';

  @override
  String get visionEndDayLess => 'Endtag darf nicht vor dem Starttag liegen';

  @override
  String get visionEndDayQuestion =>
      'An welchem Tag der Vision soll sie enden?';

  @override
  String get visionEndDayRequired => 'Gib den Endtag ein';

  @override
  String get visionNoEndDurationInfo =>
      'Kein Endtag angegeben. Die Vision beginnt unbefristet.';

  @override
  String get visionPlural => 'Visionen';

  @override
  String get visionStartDayInvalid => 'Starttag muss zwischen 1 und 365 liegen';

  @override
  String get visionStartDayQuestion =>
      'An welchem Tag der Vision soll sie beginnen?';

  @override
  String get visionDurationDaysLabel => 'Dauer (Tage)';

  @override
  String get visionStartFailed => 'Die Vision konnte nicht gestartet werden.';

  @override
  String visionStartedMessage(Object title) {
    return 'Vision gestartet: $title';
  }

  @override
  String get visionStartLabel => 'Vision start: ';

  @override
  String get visual => 'Visuell';

  @override
  String get weekdaysShortFri => 'Fr';

  @override
  String get weekdaysShortMon => 'Mo';

  @override
  String get fortuneTitle => 'Glückseier';

  @override
  String get fortuneQuestionPrompt => 'Stellen Sie Ihre Frage';

  @override
  String get fortuneQuestionHint => 'Was möchten Sie wissen?';

  @override
  String get fortuneEggsSubtitle =>
      'Wählen Sie ein Ei, um Ihr Glück zu enthüllen';

  @override
  String get fortuneResultTitle => 'Ihr Glück';

  @override
  String get fortuneNoQuestion => 'Sie haben noch keine Frage gestellt';

  @override
  String get fortuneDisclaimer => 'Wahrsagerei dient nur der Unterhaltung';

  @override
  String fortuneEggSemantic(int index) {
    return 'Glücksei $index';
  }

  @override
  String get fortunePlay => 'Spielen';

  @override
  String get shuffle => 'Mischen';

  @override
  String get ok => 'OK';

  @override
  String get weekdaysShortSat => 'Sa';

  @override
  String get weekdaysShortSun => 'So';

  @override
  String get weekdaysShortThu => 'Do';

  @override
  String get weekdaysShortTue => 'Di';

  @override
  String get weekdaysShortWed => 'Mi';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get weeklyEmailSummary => 'Wöchentliche E-Mail-Zusammenfassung';

  @override
  String get weeklySummaryEmail => 'Wöchentliche Zusammenfassung per E-Mail';

  @override
  String get whichDaysActive => 'Welche Tage sollen aktiv sein?';

  @override
  String get whichMonthDays => 'Welche Tage des Monats?';

  @override
  String get whichWeekdays => 'Welche Wochentage?';

  @override
  String get worldTheme => 'Welt';

  @override
  String get worldThemeDesc => 'Harmonie aller Farben';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • $toNext XP zum nächsten Level';
  }

  @override
  String get yesNoDescription => 'Einfache Ja/Nein-Verfolgung';

  @override
  String get yesNoExample => 'Habe ich heute meditiert?';

  @override
  String get yesNoType => 'Ja/Nein';

  @override
  String get analysis => 'Analyse';

  @override
  String get apply => 'Anwenden';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get simpleTypeShort => 'Einfach';

  @override
  String get completedSelectedDay => 'Abgeschlossen (ausgewählter Tag)';

  @override
  String get incompleteSelectedDay => 'Unvollständig (ausgewählter Tag)';

  @override
  String get manageListsSubtitle =>
      'Neue Liste hinzufügen, umbenennen oder löschen.';

  @override
  String get editListTitle => 'Liste bearbeiten';

  @override
  String get listNameLabel => 'Listenname';

  @override
  String get deleteListTitle => 'Liste löschen';

  @override
  String get deleteListMessage =>
      'Diese Liste wird gelöscht. Wähle, was mit verknüpften Elementen geschehen soll:';

  @override
  String get unassignLinkedHabits => 'Verknüpfte Gewohnheiten aufheben';

  @override
  String get unassignLinkedDailyTasks =>
      'Verknüpfte tägliche Aufgaben aufheben';

  @override
  String listCreatedMessage(Object title) {
    return 'Liste erstellt: $title';
  }

  @override
  String get removeFromList => 'Von Liste entfernen';

  @override
  String get createNewList => 'Neue Liste erstellen';

  @override
  String get dailyTasksSection => 'Tägliche Aufgaben';

  @override
  String get addToList => 'Zur Liste hinzufügen';

  @override
  String get deleteTaskConfirmTitle => 'Aufgabe löschen?';

  @override
  String get deleteTaskConfirmMessage =>
      'Möchtest du diese tägliche Aufgabe löschen? Diese Aktion kann rückgängig gemacht werden.';

  @override
  String get undo => 'Rückgängig';

  @override
  String get habitsSection => 'Gewohnheiten';

  @override
  String get noItemsMatchFilters =>
      'Keine Elemente entsprechen den ausgewählten Filtern';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Tägliche Aufgabe erstellt: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Gewohnheit gelöscht: $title';
  }

  @override
  String habitCreatedMessage(Object title) {
    return 'Gewohnheit erstellt: $title';
  }

  @override
  String deleteHabitConfirm(Object title) {
    return 'Die Gewohnheit \"$title\" löschen?';
  }

  @override
  String get valueLabel => 'Wert';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get longestStreak => 'Längste Serie';

  @override
  String daysCount(Object count) {
    return '$count Tage';
  }

  @override
  String get success => 'Erfolg';

  @override
  String get successfulDayLegend => 'Erfolgreicher Tag';

  @override
  String get privacySecuritySubtitle =>
      'Manage settings and data deletion options';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugSubtitle => 'Report issues you encounter';

  @override
  String get reportBugDescription =>
      'Describe the issue you encountered in detail below.';

  @override
  String get yourEmailAddress => 'Your Email Address';

  @override
  String get issueDescription => 'Issue Description';

  @override
  String get issueDescriptionHint => 'Describe the issue in detail...';

  @override
  String get send => 'Send';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get bugReportSentSuccess =>
      'Your bug report has been sent successfully. Thank you!';

  @override
  String bugReportFailedStatus(Object statusCode) {
    return 'Failed to send bug report: $statusCode';
  }

  @override
  String bugReportFailedError(Object error) {
    return 'Failed to send bug report: $error';
  }

  @override
  String get resetOnboardingTitle => 'Reset Onboarding?';

  @override
  String get resetOnboardingDescription =>
      'This will clear your current personality results and let you retake the quiz.';

  @override
  String get resetAction => 'Reset';

  @override
  String get deleteAllDataConfirmContent =>
      'Are you sure you want to delete all your app data? This action cannot be undone.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get diagnosticsData => 'Diagnostics data';

  @override
  String get diagnosticsDataSubtitle => 'Share anonymous usage statistics';

  @override
  String get crashReports => 'Crash reports';

  @override
  String get crashReportsSubtitle => 'Send anonymous reports on app crashes';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get stopwatchLabel => 'STOPWATCH';

  @override
  String get runningLabel => 'RUNNING';

  @override
  String get countdownLabel => 'COUNTDOWN';

  @override
  String get focusLabel => 'FOCUS';

  @override
  String get breakLabel => 'BREAK';

  @override
  String get minLabel => 'min';

  @override
  String get emojiCategoryPopular => 'Popular';

  @override
  String get emojiCategoryHealth => 'Health';

  @override
  String get emojiCategorySport => 'Sport';

  @override
  String get emojiCategoryLife => 'Life';

  @override
  String get emojiCategoryProductivity => 'Productivity';

  @override
  String get emojiCategoryFood => 'Food';

  @override
  String get emojiCategoryNature => 'Nature';

  @override
  String get emojiCategoryAnimals => 'Animals';

  @override
  String get emojiCategoryCare => 'Care';

  @override
  String get habitTypeLabel => 'Habit Type';

  @override
  String get nameLabel => 'Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get optionalLabel => 'optional';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get dateRangeLabel => 'Date Range';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get advancedHabitTitle => 'Advanced Habit';

  @override
  String get habitNamePlaceholder => 'Habit Name';

  @override
  String get numericTypeDesc => 'Number tracking';

  @override
  String get checkboxTypeDesc => 'Simple check';

  @override
  String get subtasksTypeDesc => 'Multi-task';

  @override
  String get selectEmoji => 'Select Emoji';

  @override
  String get customEmoji => 'Custom Emoji';

  @override
  String get typeEmojiHint => 'Type an emoji from keyboard';

  @override
  String get everyDay => 'Every day';

  @override
  String get periodic => 'Periodisch';

  @override
  String get everyLabel => 'Every';

  @override
  String get daysIntervalLabel => 'days';

  @override
  String get offLabel => 'Off';

  @override
  String get completeAllSubtasksToFinish => 'complete all to finish habit';

  @override
  String subtaskIndex(Object index) {
    return 'Subtask $index';
  }

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get createHabitAction => 'Create Habit';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Days $sorted of the month';
  }

  @override
  String everyXDays(Object periodicDays) {
    return 'Every $periodicDays days';
  }

  @override
  String get startDateLabel => 'Start';

  @override
  String get endDateLabel => 'End';

  @override
  String get notSelected => 'Not selected';

  @override
  String get motivation => 'Motivation';

  @override
  String motivationBody(Object percent, Object period) {
    return 'Gute Arbeit! $period hast du eine Erfolgsquote von $percent% erreicht.';
  }

  @override
  String get weeklyProgress => 'Wöchentlicher Fortschritt';

  @override
  String get monthlyProgress => 'Monatlicher Fortschritt';

  @override
  String get yearlyProgress => 'Jährlicher Fortschritt';

  @override
  String get overall => 'Insgesamt';

  @override
  String get overallProgress => 'Gesamtfortschritt';

  @override
  String get totalSuccessfulDays => 'Gesamte erfolgreiche Tage';

  @override
  String get totalUnsuccessfulDays => 'Gesamte erfolglose Tage';

  @override
  String get totalProgress => 'Gesamtfortschritt';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisYear => 'Dieses Jahr';

  @override
  String get badges => 'Abzeichen';

  @override
  String get yearly => 'Jährlich';

  @override
  String get newList => 'Neue Liste';

  @override
  String taskDeletedMessage(Object title) {
    return 'Aufgabe gelöscht: $title';
  }

  @override
  String get clear => 'Löschen';

  @override
  String get createHabitTitle => 'Gewohnheit erstellen';

  @override
  String get addDate => 'Datum hinzufügen';

  @override
  String get listNameHint => 'Bsp.: Gesundheit';

  @override
  String get taskTitleRequired => 'Aufgabentitel ist erforderlich';

  @override
  String get moodFlowTitle => 'Wie fühlen Sie sich?';

  @override
  String get moodFlowSubtitle => 'Verfolgen Sie Ihr emotionales Wohlbefinden';

  @override
  String get moodSelection => 'Stimmungsauswahl';

  @override
  String get selectYourCurrentMood => 'Wählen Sie Ihre aktuelle Stimmung';

  @override
  String get moodTerribleDesc => 'Fühle mich sehr niedergeschlagen';

  @override
  String get moodBadDesc => 'Habe eine schwere Zeit';

  @override
  String get moodNeutralDesc => 'Fühle mich in Ordnung';

  @override
  String get moodGoodDesc => 'Fühle mich positiv';

  @override
  String get moodExcellentDesc => 'Fühle mich fantastisch';

  @override
  String get feelingMoreSpecific => 'Können Sie genauer sein?';

  @override
  String get selectSubEmotionDesc => 'Wählen Sie eine spezifischere Emotion';

  @override
  String get whatsTheCause => 'Was ist die Ursache?';

  @override
  String get selectReasonDesc =>
      'Wählen Sie aus, was Ihre Stimmung beeinflusst';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodExcellent => 'Ausgezeichnet';

  @override
  String get howAreYouFeeling => 'Wie fühlen Sie sich?';

  @override
  String get selectYourMood => 'Wählen Sie Ihre Stimmung';

  @override
  String get subEmotionSelection => 'Unter-Emotions-Auswahl';

  @override
  String get selectSubEmotion => 'Unter-Emotion auswählen';

  @override
  String get subEmotionExhausted => 'Erschöpft';

  @override
  String get subEmotionHelpless => 'Hilflos';

  @override
  String get subEmotionHopeless => 'Hoffnungslos';

  @override
  String get subEmotionHurt => 'Verletzt';

  @override
  String get subEmotionDrained => 'Ausgelaugt';

  @override
  String get subEmotionAngry => 'Wütend';

  @override
  String get subEmotionSad => 'Traurig';

  @override
  String get subEmotionAnxious => 'Ängstlich';

  @override
  String get subEmotionStressed => 'Gestresst';

  @override
  String get subEmotionDemoralized => 'Demoralisiert';

  @override
  String get subEmotionIndecisive => 'Unentschlossen';

  @override
  String get subEmotionTired => 'Müde';

  @override
  String get subEmotionOrdinary => 'Gewöhnlich';

  @override
  String get subEmotionCalm => 'Ruhig';

  @override
  String get subEmotionEmpty => 'Leer';

  @override
  String get subEmotionHappy => 'Glücklich';

  @override
  String get subEmotionCheerful => 'Fröhlich';

  @override
  String get subEmotionExcited => 'Aufgeregt';

  @override
  String get subEmotionEnthusiastic => 'Enthusiastisch';

  @override
  String get subEmotionDetermined => 'Entschlossen';

  @override
  String get subEmotionMotivated => 'Motiviert';

  @override
  String get subEmotionAmazing => 'Amazing';

  @override
  String get subEmotionEnergetic => 'Energetic';

  @override
  String get subEmotionPeaceful => 'Peaceful';

  @override
  String get subEmotionGrateful => 'Grateful';

  @override
  String get subEmotionLoving => 'Loving';

  @override
  String get reasonSelection => 'What\'s the reason for this state?';

  @override
  String get selectReason => 'Select reason';

  @override
  String get reasonAcademic => 'Academic';

  @override
  String get reasonWork => 'Arbeit';

  @override
  String get reasonRelationship => 'Relationship';

  @override
  String get reasonFinance => 'Finance';

  @override
  String get reasonHealth => 'Gesundheit';

  @override
  String get reasonSocial => 'Social';

  @override
  String get reasonPersonalGrowth => 'Personal Growth';

  @override
  String get reasonWeather => 'Weather';

  @override
  String get reasonOther => 'Sonstiges';

  @override
  String get journalEntry => 'Journal Entry';

  @override
  String get tellUsMore => 'Tell us more';

  @override
  String get journalEntryDesc =>
      'Is there anything you\'d like to write about today?';

  @override
  String get yourMoodToday => 'Your Mood Today';

  @override
  String get journalHint => 'Something you\'d like to write about today...';

  @override
  String get saving => 'Saving...';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get entrySaved => 'Entry saved successfully!';

  @override
  String get saveError => 'An error occurred while saving';

  @override
  String get moodFlow => 'Mood';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get continueButton => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get habitNotFound => 'Gewohnheit nicht gefunden.';

  @override
  String get habitUpdatedMessage => 'Gewohnheit aktualisiert.';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get simpleHabitTargetOne => 'Einfache Gewohnheit (Ziel = 1)';

  @override
  String get typeNotChangeable => 'Typ kann nicht geändert werden';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Mira';

  @override
  String get onboardingWelcomeDesc =>
      'Dein persönlicher Gewohnheitstracker, der mit dir wächst. Lass uns deine einzigartige Persönlichkeit entdecken und passende Gewohnheiten vorschlagen.';

  @override
  String get onboardingQuizIntro =>
      'Beantworte ein paar Fragen, damit wir deine Persönlichkeit besser verstehen. Dies basiert auf wissenschaftlich validierter psychologischer Forschung.';

  @override
  String get onboardingQ1 =>
      'Ich probiere gerne neue Erfahrungen aus und erkunde Unbekanntes.';

  @override
  String get onboardingQ2 =>
      'Ich halte meinen Bereich ordentlich und bevorzuge eine strukturierte tägliche Routine.';

  @override
  String get onboardingQ3 =>
      'Ich fühle mich energiegeladen, wenn ich unter Menschen bin, und genieße soziale Treffen.';

  @override
  String get onboardingQ4 =>
      'Ich arbeite lieber mit anderen zusammen und finde Kooperation effektiver als Konkurrenz.';

  @override
  String get onboardingQ5 =>
      'Ich gehe gelassen mit stressigen Situationen um und fühle mich selten ängstlich.';

  @override
  String get onboardingQ6 =>
      'Ich mag kreative Aktivitäten wie Kunst, Musik oder Schreiben.';

  @override
  String get onboardingQ7 =>
      'Ich setze mir klare Ziele und arbeite gewissenhaft daran, sie zu erreichen.';

  @override
  String get onboardingQ8 =>
      'Ich bevorzuge Gruppenaktivitäten gegenüber Zeit allein.';

  @override
  String get onboardingQ9 =>
      'Ich berücksichtige oft die Gefühle anderer, bevor ich Entscheidungen treffe.';

  @override
  String get onboardingQ10 =>
      'Ich plane wichtige Ereignisse und Aufgaben im Voraus.';

  @override
  String get onboardingQ11 =>
      'Ich probiere gerne unterschiedliche Ansätze aus, statt bei einer Methode zu bleiben.';

  @override
  String get onboardingQ12 =>
      'Ich bleibe unter Druck ruhig und erhole mich schnell von Rückschlägen.';

  @override
  String get likertStronglyDisagree => 'Stimme überhaupt nicht zu';

  @override
  String get likertDisagree => 'Ablehnen';

  @override
  String get likertNeutral => 'Neutral';

  @override
  String get likertAgree => 'Zustimmen';

  @override
  String get likertStronglyAgree => 'Stimme voll zu';

  @override
  String get characterTypePlanner => 'The Planner';

  @override
  String get characterDescPlanner =>
      'You\'re organized, goal-oriented, and thrive on structure. You excel at turning dreams into actionable plans and following through with discipline.';

  @override
  String get characterTypeExplorer => 'The Explorer';

  @override
  String get characterDescExplorer =>
      'You\'re curious, creative, and love variety. You thrive on learning new things and trying different approaches to life\'s challenges.';

  @override
  String get characterTypeSocialConnector => 'The Social Connector';

  @override
  String get characterDescSocialConnector =>
      'You\'re warm, empathetic, and energized by relationships. You find meaning in connecting with others and building strong communities.';

  @override
  String get characterTypeBalancedMindful => 'The Balanced Mindful';

  @override
  String get characterDescBalancedMindful =>
      'You\'re calm, stable, and value inner peace. You excel at maintaining balance and approaching life with mindfulness and composure.';

  @override
  String get yourCharacterType => 'Your Character Type';

  @override
  String get recommendedHabits => 'Recommended Habits for You';

  @override
  String get selectHabitsToAdd =>
      'Wähle Gewohnheiten aus, die du zu deiner täglichen Routine hinzufügen möchtest:';

  @override
  String get startJourney => 'Starte deine Reise';

  @override
  String get skipOnboarding => 'Überspringen';

  @override
  String get back => 'Back';

  @override
  String get habitPlannerMorningRoutine => 'Morning Routine';

  @override
  String get habitPlannerMorningRoutineDesc =>
      'Start each day with a structured morning routine to set the tone for productivity.';

  @override
  String get habitPlannerWeeklyReview => 'Weekly Review';

  @override
  String get habitPlannerWeeklyReviewDesc =>
      'Review your week\'s progress and plan for the next week every Sunday.';

  @override
  String get habitPlannerGoalSetting => 'Monthly Goal Setting';

  @override
  String get habitPlannerGoalSettingDesc =>
      'Set specific, measurable goals for the month ahead.';

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
  String get habitExplorerLearnNewSkill => 'Learn Something New';

  @override
  String get habitExplorerLearnNewSkillDesc =>
      'Dedicate time each week to learning a new skill or subject.';

  @override
  String get habitExplorerTryNewActivity => 'Try a New Activity';

  @override
  String get habitExplorerTryNewActivityDesc =>
      'Step out of your comfort zone and experience something different.';

  @override
  String get habitExplorerReadDiverse => 'Read Diverse Content';

  @override
  String get habitExplorerReadDiverseDesc =>
      'Read books, articles, or content from different genres and perspectives.';

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
  String get habitSocialCallFriend => 'Call a Friend';

  @override
  String get habitSocialCallFriendDesc =>
      'Reach out to a friend or family member for a meaningful conversation.';

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
  String get habitSocialFamilyTime => 'Quality Family Time';

  @override
  String get habitSocialFamilyTimeDesc =>
      'Spend dedicated time with family members without distractions.';

  @override
  String get habitSocialCompliment => 'Give a Genuine Compliment';

  @override
  String get habitSocialComplimentDesc =>
      'Brighten someone\'s day with a sincere compliment.';

  @override
  String get habitMindfulMeditation => 'Meditation';

  @override
  String get habitMindfulMeditationDesc =>
      'Practice mindfulness meditation for 10-15 minutes.';

  @override
  String get habitMindfulGratitude => 'Gratitude Practice';

  @override
  String get aiAssistantTitle => 'Mira Asistan';

  @override
  String get aiAssistantOnline => 'Çevrimiçi';

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
  String aiContextMessage(Object tip) {
    return 'Merhaba! Bu ipucuyla ilgilendiğinizi fark ettim:\n\n\"$tip\"\n\nBunu Mira\'da nasıl uygulayacağınızı göstermemi ister misiniz?';
  }

  @override
  String get aiShowMeHow => 'Evet, nasıl yapacağımı göster';

  @override
  String get habitMindfulGratitudeDesc =>
      'Write down three things you\'re grateful for today.';

  @override
  String get habitMindfulNatureWalk => 'Nature Walk';

  @override
  String get habitMindfulNatureWalkDesc =>
      'Take a mindful walk in nature, paying attention to your surroundings.';

  @override
  String get habitMindfulBreathing => 'Deep Breathing Exercise';

  @override
  String get habitMindfulBreathingDesc =>
      'Practice deep breathing techniques to center yourself.';

  @override
  String get habitMindfulJournaling => 'Reflective Journaling';

  @override
  String get habitMindfulJournalingDesc =>
      'Journal your thoughts and reflections for self-awareness.';

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
  String habitAddError(Object error) {
    return 'Error adding habits: $error';
  }

  @override
  String get unlistedItems => 'Unlisted Items';

  @override
  String get unknownList => 'Unknown List';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String backupSuccess(Object id) {
    return 'Gesichert: $id';
  }

  @override
  String get backupError => 'Backup Error';

  @override
  String restoreSuccess(Object content) {
    return 'Heruntergeladen: $content';
  }

  @override
  String get restoreError => 'Restore Error';

  @override
  String get manageSubscriptionSubtitle =>
      'Mira Plus-Abonnement über Google Play verwalten';

  @override
  String get deleteMyAccount => 'Mein Konto löschen';

  @override
  String get deleteAccountSubtitle =>
      'Löschung Ihres Kontos und Ihrer Daten anfordern';

  @override
  String get confirmDeleteAccount => 'Kontolöschung bestätigen';

  @override
  String get deleteAccountWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Bitte bestätigen Sie die mit Ihrem Konto verknüpfte E-Mail.';

  @override
  String get yourEmail => 'Ihre E-Mail';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get deleteAccountRequestSuccess =>
      'Ihre Anfrage zur Kontolöschung wurde erfolgreich empfangen';

  @override
  String get deleteAccountFailed => 'Account deletion failed';

  @override
  String get resetOnboarding => 'Reset Onboarding';

  @override
  String get retakePersonalityTest => 'Retake Personality Test';

  @override
  String get processingWait => 'Processing, please wait...';

  @override
  String get checkingPurchases => 'Checking purchases...';

  @override
  String get premiumPlans => 'Premium Plans';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get noPlansAvailable => 'No plans available at the moment.';

  @override
  String get cannotOpenPlayStore => 'Cannot open Play Store';

  @override
  String get subscriptionDetails => 'Subscription Details';

  @override
  String get goToPlayStore => 'Go to Play Store';

  @override
  String get becomePremium => 'Become Premium';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumBenefits => 'Premium benefits:';

  @override
  String get later => 'Later';

  @override
  String get becomePremiumShort => 'Get Premium';

  @override
  String get shareDashboard => 'Share Dashboard';

  @override
  String get customUnit => 'Custom Unit';

  @override
  String get pastelColors => 'Pastellfarben';

  @override
  String get habitNameHintTimer => 'Bsp: Meditation, Sport...';

  @override
  String get habitNameHintNumerical => 'Bsp: Wasser trinken, Seiten lesen...';

  @override
  String get habitDescriptionHint => 'Kurze Beschreibung hinzufügen...';

  @override
  String get target => 'Ziel';

  @override
  String get amount => 'Menge';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get customUnitHint => 'Bsp: Portion, Satz, km...';

  @override
  String get unitAdet => 'Stk';

  @override
  String get unitBardak => 'Glas';

  @override
  String get unitSayfa => 'Seite';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'Liter';

  @override
  String get unitKalori => 'kcal';

  @override
  String get unitAdim => 'Schritt';

  @override
  String get unitKez => 'mal';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get featureAdvancedHabits => 'Gelişmiş Alışkanlık Oluşturma';

  @override
  String get featureVisionCreation => 'Vizyon Oluşturma';

  @override
  String get featureAdvancedFinance => 'Gelişmiş Finans Özellikleri';

  @override
  String get featurePremiumThemes => 'Premium Temalar';

  @override
  String get featureBackup => 'Yedekleme Özelliği';

  @override
  String get perMonth => '/mo';

  @override
  String get perYear => '/yr';

  @override
  String get unlockAllFeatures => 'Unlock all features and remove limits.';

  @override
  String get flexiblePlan => 'Flexible plan, cancel anytime';

  @override
  String get annualPlanDesc => 'Uninterrupted access for 12 months';

  @override
  String get trialInfo => '14-day free trial, cancel anytime.';

  @override
  String get miraPlusActive => 'Mira Plus Active';

  @override
  String get miraPlusInactive => 'Mira Plus Inactive';

  @override
  String get validity => 'Validity';

  @override
  String get daysLeft => 'days left';

  @override
  String get subscribeToEnjoyPremium => 'Subscribe to enjoy premium features';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get detailedCharts => 'Detailed charts and statistics';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get uninterruptedUsage => 'Uninterrupted usage';

  @override
  String get advancedTimer => 'Advanced Timer';

  @override
  String get pomodoroAndCustomTimers => 'Pomodoro and custom timers';

  @override
  String get personalizedInsights => 'Personalized Insights';

  @override
  String get aiPoweredRecommendations => 'AI powered recommendations';

  @override
  String get buyPremium => 'Buy Premium';

  @override
  String get manageOnGooglePlay => 'Manage on Google Play';

  @override
  String get manageSubscriptionDesc =>
      'Change plan, cancel or view billing info';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get viewInvoicesOnPlayStore =>
      'View your invoices on Google Play Store';

  @override
  String get seeFullSubscriptionInfo => 'See full subscription info';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get howToCancel => 'How to cancel?';

  @override
  String get cancelInstructions =>
      'Google Play Store → Subscriptions → Mira Plus → Cancel';

  @override
  String get whatHappensIfCancel => 'What happens if I cancel?';

  @override
  String get cancelEffect =>
      'You continue to enjoy premium features until your subscription ends.';

  @override
  String get ifTrialCancelled => 'If free trial is cancelled?';

  @override
  String get trialCancelEffect =>
      'If you cancel during the free trial, you won\'t be charged immediately.';

  @override
  String get canIGetRefund => 'Can I get a refund?';

  @override
  String get refundPolicy =>
      'Refund requests are subject to Google Play policies. You can apply from Play Store.';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get daysRemaining => 'Days Remaining';

  @override
  String get usePlayStoreToManage =>
      'Use Google Play Store to manage your subscription.';

  @override
  String get thisFeatureIsPremium => 'This feature is Premium';

  @override
  String get mustBePremiumToUse =>
      'You must be a Premium subscriber to use this feature.';

  @override
  String get advancedAnalysisAndReports => 'Advanced analysis and reports';

  @override
  String get unlimitedDataStorage => 'Unlimited data storage';

  @override
  String get freeTrial14Days => '14-day free trial';

  @override
  String get backupFailed => 'Sicherung fehlgeschlagen';

  @override
  String get restoreFailed => 'Wiederherstellung fehlgeschlagen';

  @override
  String plansLoadError(Object error) {
    return 'Fehler beim Laden der Pläne: $error';
  }

  @override
  String get optional => 'optional';

  @override
  String get newHabit => 'New Habit';

  @override
  String get typeEmoji => 'Type an emoji from keyboard';

  @override
  String get habitNameHint => 'Ex: Drink water, Read book...';

  @override
  String get weekDaysShort => 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';

  @override
  String get every => 'Every';

  @override
  String get daysInterval => 'days';

  @override
  String get today => 'Today';

  @override
  String get monthsShort => 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysLater(Object days) {
    return '$days days later';
  }

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get off => 'Off';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get pickTime => 'Pick Time';

  @override
  String monthlyDays(Object days) {
    return 'Days $days of the month';
  }

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get signInWithGoogleTitle => 'Sign in with Google';

  @override
  String get signInWithGoogleDesc =>
      'Connect your Google account to continue. Your profile info will be filled automatically.';

  @override
  String get signInWithGoogleButton => 'Sign in with Google';

  @override
  String get startTestTitle => 'Do you want to start the personality test?';

  @override
  String get startTestDesc =>
      'If you complete the test, you will get personalized suggestions and habit recommendations. You can skip this step if you wish.';

  @override
  String get skipTest => 'Skip Test';

  @override
  String get startTest => 'Start Test';

  @override
  String get backupTitle => 'Backup';

  @override
  String get jsonDataExample => 'JSON Data (example):';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get noBackupsFound => 'No backups found.';

  @override
  String get unnamedBackup => 'unnamed';

  @override
  String get restore => 'Restore';

  @override
  String get financeNet => 'Net';

  @override
  String get durationIndefinite => 'Indefinite';

  @override
  String durationMonths(Object count) {
    return '$count months';
  }

  @override
  String get fortuneProceedToEggs => 'Proceed to Eggs';

  @override
  String get fortuneSwipeInstruction =>
      'Swipe left/right to change the egg, tap to reveal the answer';

  @override
  String listCreated(Object title) {
    return 'List created: $title';
  }

  @override
  String get moodAnalytics => 'Mood Analytics';

  @override
  String get overview => 'Overview';

  @override
  String get trends => 'Trends';

  @override
  String get history => 'History';

  @override
  String get noMoodData => 'No mood data yet';

  @override
  String get startTrackingMood => 'Start tracking your mood to see analytics';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get averageMood => 'Durchschnittliche Stimmung';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get mostCommonMood => 'Most Common Mood';

  @override
  String get mostCommonEmotion => 'Most Common Emotion';

  @override
  String get mostCommonReason => 'Most Common Reason';

  @override
  String get moodTrend => 'Mood Trend (Last 30 Days)';

  @override
  String get noTrendData => 'Not enough data for trends';

  @override
  String get insights => 'Insights';

  @override
  String get moodImproving => 'Your mood is improving!';

  @override
  String get moodDeclining => 'Your mood seems to be declining';

  @override
  String get moodStable => 'Your mood is relatively stable';

  @override
  String get noHistory => 'Kein Verlauf';

  @override
  String get open => 'Open';

  @override
  String get openNotificationSettings => 'Open notification settings';

  @override
  String get openSystemSettings => 'Open system settings';

  @override
  String get openBatteryOptimization => 'Open battery optimization';

  @override
  String get habitReminderBody => 'Time to complete your habit!';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerStop => 'Stop';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get visionTasks => 'Tasks';

  @override
  String get addTask => 'Aufgabe hinzufügen';

  @override
  String get taskCompleted => 'Completed';

  @override
  String get taskPending => 'Pending';

  @override
  String get noTasksYet => 'No tasks added yet';

  @override
  String get deleteTaskConfirm => 'Are you sure you want to delete this task?';

  @override
  String get taskAdded => 'Task added';

  @override
  String get manageVisionTasks => 'Manage Tasks';

  @override
  String get createWithAi => 'AI ile Oluştur';

  @override
  String get aiInputHint => 'Kazanmak istediğiniz alışkanlığı tarif edin...';

  @override
  String get generate => 'Oluştur';

  @override
  String get aiPreviewTitle => 'AI Önerileri';

  @override
  String get confirmHabits => 'Alışkanlıkları Onayla';

  @override
  String get aiRetry => 'Tekrar Dene (Sıkı Kurallar)';

  @override
  String get manualFallback => 'Manuel Oluştur';

  @override
  String aiHabitAddedMessage(Object count) {
    return 'AI ile $count alışkanlık eklendi';
  }

  @override
  String get aiQuickHabit => 'Yeni alışkanlık oluştur';

  @override
  String get aiQuickVision => 'Vizyon Panosu yardımı';

  @override
  String get aiQuickTimer => 'Zamanlayıcı nasıl kullanılır?';

  @override
  String get aiQuickGamification => 'XP sistemi nedir?';

  @override
  String get aiQuickMood => 'Ruh halimi analiz et';

  @override
  String get aiQuickFinance => 'Bütçe önerileri';

  @override
  String get aiQuickMotivation => 'Bana motivasyon ver';

  @override
  String get aiQuickProfile => 'Yapay Zeka Karakterim';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutConfirmation => 'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get statsActiveDays => 'Aktif Gün';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionProud => 'Stolz';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionUnstoppable => 'Durdurulamaz';

  @override
  String get gamesTitle => 'Oyunlar';

  @override
  String get letsPlayGame => 'Hadi oynayalım! 🎮';

  @override
  String get gamesDescription =>
      'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!';

  @override
  String get decisionEggTitle => 'Karar Yumurtası';

  @override
  String get decisionEggDescription => 'Mistik yumurtalardan birini seç';

  @override
  String get coinFlipTitle => 'Yazı Tura';

  @override
  String get coinFlipDescription => 'İki seçenek arasında karar ver';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get eggSelectMessage =>
      'Aklından bir soru tut ve bir yumurtaya dokun 🥚';

  @override
  String get eggRevealMessage => 'Mistik yumurta cevabını verdi! ✨';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get coinFlipInstruction => 'İki seçeneği yaz ve parayı çevir!';

  @override
  String get option1 => 'Seçenek 1';

  @override
  String get option2 => 'Seçenek 2';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get flipCoin => 'Parayı Çevir';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get maxOptionsReached => 'Maksimum 12 seçenek ekleyebilirsin';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get addOptionsToStart => 'Başlamak için seçenek ekle';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';
}
