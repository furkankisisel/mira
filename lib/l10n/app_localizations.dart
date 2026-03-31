import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get account;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başarılar'**
  String get achievements;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get active;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktif günler'**
  String get activeDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız Deneyim'**
  String get adFreeExperience;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tarih ekle'**
  String get addDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Ekle'**
  String get addEvent;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get addFabTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlk işlemi ekle'**
  String get addFirstTransaction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Ekle'**
  String get addHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'+ butonuyla odaya bir alışkanlık ekle!'**
  String get addHabitToRoomPrompt;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Resim Ekle'**
  String get addImage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ekle'**
  String get addNew;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Alışkanlık Ekle'**
  String get addNewHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçenek ekle...'**
  String get addOptionHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlamak için seçenek ekle'**
  String get addOptionsToStart;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oda Ekle'**
  String get addRoomButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel Günler Ekle'**
  String get addSpecialDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alt Görev Ekle'**
  String get addSubtask;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev Ekle'**
  String get addTask;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Metin Ekle'**
  String get addText;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeye ekle'**
  String get addToList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{title} odaya eklendi! 🎯'**
  String addedToRoomSnackbar(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İleri Seviye Analiz'**
  String get advancedAnalysis;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İleri seviye analiz ve raporlar'**
  String get advancedAnalysisAndReports;

  /// Simple habit label
  ///
  /// In tr, this message translates to:
  /// **'Basit Alışkanlık'**
  String get simpleHabit;

  /// Advanced habit label
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Alışkanlık'**
  String get advancedHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium • Detaylı ayarlarla alışkanlık oluştur'**
  String get advancedHabitSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Alışkanlık'**
  String get advancedHabitTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayısal hedefler, zamanlayıcı ve detaylı takip.'**
  String get advancedHabitTypeDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Timer'**
  String get advancedTimer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çevrimiçi'**
  String get aiAssistantOnline;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira Asistan'**
  String get aiAssistantTitle;

  /// Mira asistanının bir ipucu hakkında bağlam sağladığı mesaj
  ///
  /// In tr, this message translates to:
  /// **'Merhaba! Bu ipucuyla ilgilendiğinizi fark ettim:\n\n\"{tip}\"\n\nBunu Mira\'da nasıl uygulayacağınızı göstermemi ister misiniz?'**
  String aiContextMessage(Object tip);

  /// AI tarafından eklenen alışkanlık sayısını gösteren mesaj
  ///
  /// In tr, this message translates to:
  /// **'AI ile {count} alışkanlık eklendi'**
  String aiHabitAddedMessage(int count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kazanmak istediğiniz alışkanlığı tarif edin...'**
  String get aiInputHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AI destekli öneriler'**
  String get aiPoweredRecommendations;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AI Önerileri'**
  String get aiPreviewTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bütçe önerileri'**
  String get aiQuickFinance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'XP sistemi nedir?'**
  String get aiQuickGamification;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni alışkanlık oluştur'**
  String get aiQuickHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh halimi analiz et'**
  String get aiQuickMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bana motivasyon ver'**
  String get aiQuickMotivation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yapay Zeka Karakterim'**
  String get aiQuickProfile;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı nasıl kullanılır?'**
  String get aiQuickTimer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Panosu yardımı'**
  String get aiQuickVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene (Sıkı Kurallar)'**
  String get aiRetry;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Evet, nasıl yapacağımı göster'**
  String get aiShowMeHow;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biliyor muydunuz? Uzun vadeli hedefleriniz için bir Vizyon Panosu oluşturabilirsiniz.'**
  String get aiTip0;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İpucu: Odaklanmış çalışma oturumları için Zamanlayıcıyı kullanın.'**
  String get aiTip1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zaman içindeki değişimleri görmek için günlük ruh halinizi takip edin.'**
  String get aiTip2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklar her gün aynı saatte yapıldığında daha kalıcı olur.'**
  String get aiTip3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Büyük Vizyonları daha küçük, yönetilebilir Görevlere bölün.'**
  String get aiTip4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük harcamalarınızı takip etmek için Finans sekmesini kullanın.'**
  String get aiTip5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yardıma mı ihtiyacınız var? AI asistana sormak için buraya dokunun!'**
  String get aiTip6;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İstikrar anahtardır! Zinciri kırmayın.'**
  String get aiTip7;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Merhaba! Ben Mira asistanınızım. Size bugün nasıl yardımcı olabilirim? Vizyonlar, alışkanlıklar, zamanlayıcılar veya diğer özellikler hakkında soru sorabilirsiniz.'**
  String get aiWelcomeMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriler silindi'**
  String get allDataDeleted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm Alışkanlıklar'**
  String get allHabitsLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get allLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlı alışkanlıkları da sil'**
  String get alsoDeleteLinkedHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Miktar'**
  String get amount;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get amountLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Analiz'**
  String get analysis;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Analiz'**
  String get analysisTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'12 ay boyunca kesintisiz erişim'**
  String get annualPlanDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira'**
  String get appTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get appearance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get apply;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kodu Uygula'**
  String get applyCode;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uygulanıyor...'**
  String get applying;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu vizyon yaklaşık {days} gün sürer'**
  String approxVisionDurationDays(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bazı varlıkların yüklenmesi için uygulamanın tamamen yeniden başlatılması gerekebilir.'**
  String get assetsReloadHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Az'**
  String get atLeast;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Çok'**
  String get atMost;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verilerinizi her 24 saatte bir otomatik olarak Google Drive\'a yedekleyin.'**
  String get autoBackupSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Yedekleme'**
  String get autoBackupTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Duygu'**
  String get averageMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Arka plan plakası'**
  String get backgroundPlate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme hatası'**
  String get backupError;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme başarısız'**
  String get backupFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hemen yedekle'**
  String get backupNow;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme & Geri Yükleme'**
  String get backupRestore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedeklendi: {id}'**
  String backupSuccess(Object id);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme'**
  String get backupTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Drive\'a Yedekle'**
  String get backupToDrive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'100 farklı günde aktif ol'**
  String get badgeActive100dDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'100 Gün Aktif'**
  String get badgeActive100dTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'30 farklı günde aktif ol'**
  String get badgeActive30dDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'30 Gün Aktif'**
  String get badgeActive30dTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'7 farklı günde aktif ol'**
  String get badgeActive7dDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'7 Gün Aktif'**
  String get badgeActive7dTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktivite'**
  String get badgeCategoryActivity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get badgeCategoryFinance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık'**
  String get badgeCategoryHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seviye'**
  String get badgeCategoryLevel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon'**
  String get badgeCategoryVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'XP'**
  String get badgeCategoryXp;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'100 işlem kaydet'**
  String get badgeFin100Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finansçı 100'**
  String get badgeFin100Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'10 işlem kaydet'**
  String get badgeFin10Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finansçı 10'**
  String get badgeFin10Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'250 işlem kaydet'**
  String get badgeFin250Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finansçı 250'**
  String get badgeFin250Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'50 işlem kaydet'**
  String get badgeFin50Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finansçı 50'**
  String get badgeFin50Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplamda 100 alışkanlık tamamla'**
  String get badgeHabit100Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık 100'**
  String get badgeHabit100Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplamda 10 alışkanlık tamamla'**
  String get badgeHabit10Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık 10'**
  String get badgeHabit10Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplamda 200 alışkanlık tamamla'**
  String get badgeHabit200Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık 200'**
  String get badgeHabit200Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplamda 50 alışkanlık tamamla'**
  String get badgeHabit50Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık 50'**
  String get badgeHabit50Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'10. seviyeye ulaş'**
  String get badgeLevel10Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seviye 10'**
  String get badgeLevel10Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'20. seviyeye ulaş'**
  String get badgeLevel20Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seviye 20'**
  String get badgeLevel20Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'5. seviyeye ulaş'**
  String get badgeLevel5Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seviye 5'**
  String get badgeLevel5Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'10 vizyon oluştur'**
  String get badgeVision10Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Büyükustası'**
  String get badgeVision10Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlk vizyonunu oluştur'**
  String get badgeVision1Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyoner'**
  String get badgeVision1Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'5 vizyon oluştur'**
  String get badgeVision5Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Ustası'**
  String get badgeVision5Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir vizyona 3+ alışkanlık bağla'**
  String get badgeVisionHabits3Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlayıcı'**
  String get badgeVisionHabits3Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam 1000 XP kazan'**
  String get badgeXp1000Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'1000 XP'**
  String get badgeXp1000Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam 500 XP kazan'**
  String get badgeXp500Desc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'500 XP'**
  String get badgeXp500Title;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rozetler'**
  String get badges;

  /// Kalan bakiye miktarını parantez içinde gösterir
  ///
  /// In tr, this message translates to:
  /// **'(Bakiye: {balance})'**
  String balanceParenthesis(Object balance);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Olun'**
  String get becomePremium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Ol'**
  String get becomePremiumShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'1 ile 360 arasında'**
  String get between1And360;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Fatura Geçmişi'**
  String get billingHistory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biyografi'**
  String get bio;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendiniz hakkında kısa bir biyografi'**
  String get bioHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'MOLA'**
  String get breakLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mola'**
  String get breakTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategoriye göre döküm'**
  String get breakdownByCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Öne getir'**
  String get bringForward;

  /// Hata raporu gönderimi başarısız olduğunda gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hata raporu gönderilemedi: {error}'**
  String bugReportFailedError(Object error);

  /// Hata raporu gönderimi durum kodu ile başarısız olduğunda gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Hata raporu gönderilemedi: {statusCode}'**
  String bugReportFailedStatus(Object statusCode);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hata raporunuz başarıyla gönderildi. Teşekkür ederiz!'**
  String get bugReportSentSuccess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Satın Al'**
  String get buyPremium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri ödeme alabilir miyim?'**
  String get canIGetRefund;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancelButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Abonelik süreniz bitene kadar premium özelliklerden faydalanmaya devam edersiniz.'**
  String get cancelEffect;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google Play Store → Abonelikler → Mira Plus → İptal Et'**
  String get cancelInstructions;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Play Store açılamıyor'**
  String get cannotOpenPlayStore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategori Adı'**
  String get categoryName;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sakin, istikrarlı ve iç huzura değer veren birisin. Denge sağlamakta ve hayata bilinçlilik ve soğukkanlılıkla yaklaşmakta başarılısın.'**
  String get characterDescBalancedMindful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Meraklı, yaratıcı ve çeşitliliği seven birisin. Yeni şeyler öğrenmekten ve hayatın zorluklarına farklı yaklaşımlar denemekten keyif alırsın.'**
  String get characterDescExplorer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düzenli, hedef odaklı ve yapıdan beslenen birisin. Hayalleri eyleme dönüştürmekte ve disiplinle takip etmekte başarılısın.'**
  String get characterDescPlanner;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcakkanlı, empatik ve ilişkilerden enerji alan birisin. Başkalarıyla bağlantı kurmakta ve güçlü topluluklar oluşturmakta anlam bulursun.'**
  String get characterDescSocialConnector;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dengeli Bilinçli'**
  String get characterTypeBalancedMindful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaşif'**
  String get characterTypeExplorer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Planlayıcı'**
  String get characterTypePlanner;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Bağlayıcı'**
  String get characterTypeSocialConnector;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Onay Kutusu'**
  String get checkboxType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Basit işaretle'**
  String get checkboxTypeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Satın almalar kontrol ediliyor...'**
  String get checkingPurchases;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınız için en iyi kategoriyi seçin'**
  String get chooseBestCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Renk Seç:'**
  String get chooseColor;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Emoji Seç:'**
  String get chooseEmoji;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Seç'**
  String get choosePhoto;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Size ilham veren bir fotoğraf seçin'**
  String get choosePhotoDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seni motive eden bir fotoğraf seç'**
  String get choosePhotoSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get clearFilters;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçmişi Temizle'**
  String get clearHistory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get closeButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bulut Yedekleme'**
  String get cloudBackup;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İki seçenek arasında karar ver'**
  String get coinFlipDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İki seçeneği yaz ve parayı çevir!'**
  String get coinFlipInstruction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yazı Tura'**
  String get coinFlipTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Renk'**
  String get colorLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Renk teması'**
  String get colorTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'tümünü tamamlayınca alışkanlık tamamlanır'**
  String get completeAllSubtasksToFinish;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı (seçilen gün)'**
  String get completedSelectedDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'TAMAM'**
  String get completedTableHeader;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma %'**
  String get completionPercentLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} tamamlandı'**
  String completionsCount(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesabı silmeyi onayla'**
  String get confirmDeleteAccount;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıkları Onayla'**
  String get confirmHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Misafir Olarak Devam Et'**
  String get continueAsGuest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueText;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copyButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kodu Kopyala'**
  String get copyCodeTitle;

  /// Bir işlemin jeton maliyetini gösterir
  ///
  /// In tr, this message translates to:
  /// **'Maliyet: {cost} jeton'**
  String costTokens(Object cost);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pamuk Şeker'**
  String get cottonCandy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pamuk şeker - pembe ve mavi'**
  String get cottonCandyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri Sayımı Yapılandır'**
  String get countdownConfigureTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'GERİ SAYIM'**
  String get countdownLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rahat Günlük'**
  String get cozyJournal;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi tonlar ve zaman çizelgesi'**
  String get cozyJournalDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çökme raporları'**
  String get crashReports;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uygulama çökmelerinde anonim rapor gönder'**
  String get crashReportsSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get create;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Alışkanlık Oluştur'**
  String get createAdvancedHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get createButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Görev Oluştur'**
  String get createDailyTask;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Oluştur'**
  String get createFirstHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlk haftalık raporunuzu oluşturmak için + butonuna tıklayın'**
  String get createFirstReportPrompt;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlk Vizyonunuzu Oluşturun'**
  String get createFirstVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığı Oluştur'**
  String get createHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Oluştur'**
  String get createHabitAction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Şablonu Oluştur'**
  String get createHabitTemplateTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Oluştur'**
  String get createHabitTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Liste Oluştur'**
  String get createList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kategori Oluştur'**
  String get createNewCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni liste oluştur'**
  String get createNewList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rapor Oluştur'**
  String get createReport;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni bir oda oluştur ve arkadaşlarını davet et'**
  String get createRoomSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oda oluşturuldu! 🎉'**
  String get createRoomSuccessSnackbar;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oda Oluştur'**
  String get createRoomTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Oluştur'**
  String get createVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Şablonu Oluştur'**
  String get createVisionTemplateTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yapay Zeka ile Vizyon Oluştur'**
  String get createVisionWithAI;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AI ile Oluştur'**
  String get createWithAi;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedek oluşturuluyor...'**
  String get creatingBackup;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Seri'**
  String get currentStreak;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel'**
  String get custom;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel Kategoriler'**
  String get customCategories;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel Emoji'**
  String get customEmoji;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: ✨'**
  String get customEmojiHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel emoji (isteğe bağlı)'**
  String get customEmojiOptional;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel Etkinlik'**
  String get customEvent;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel'**
  String get customFrequency;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Özel Birim'**
  String get customUnit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: porsiyon, set, km...'**
  String get customUnitHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get daily;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük kontrol'**
  String get dailyCheck;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her gün yapılacak'**
  String get dailyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get dailyHabitInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük limit'**
  String get dailyLimit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Görev'**
  String get dailyTask;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük görev oluşturuldu: {title}'**
  String dailyTaskCreatedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugüne özel bir görev ekle'**
  String get dailyTaskSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Görev'**
  String get dailyTaskTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Görevler'**
  String get dailyTasksSection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karanlık tema'**
  String get darkTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Panel'**
  String get dashboard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get date;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tarih Aralığı'**
  String get dateRangeLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get dayFriShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get dayMonShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gün {start}–{end}'**
  String dayRangeShort(Object end, Object start);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get daySatShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gün {day}'**
  String dayShort(Object day);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get daySunShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get dayThuShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get dayTueShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get dayWedShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get days;

  /// Geçmiş bir zaman dilimini gün bazında ifade eder
  ///
  /// In tr, this message translates to:
  /// **'{days} gün önce'**
  String daysAgo(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{days}g ort.'**
  String daysAverageShort(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} gün'**
  String daysCount(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'günde bir'**
  String get daysInterval;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'günde bir'**
  String get daysIntervalLabel;

  /// Gelecek bir zaman dilimini gün bazında ifade eder
  ///
  /// In tr, this message translates to:
  /// **'{days} gün sonra'**
  String daysLater(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'gün kaldı'**
  String get daysLeft;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kalan Gün'**
  String get daysRemaining;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get daysSuffixShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mistik yumurtalardan birini seç'**
  String get decisionEggDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar Yumurtası'**
  String get decisionEggTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'adet'**
  String get defaultUnit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesap silme başarısız'**
  String get deleteAccountFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesap silme talebiniz başarıyla alındı'**
  String get deleteAccountRequestSuccess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızın ve verilerinizin silinmesini talep edin'**
  String get deleteAccountSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Lütfen hesabınızla ilişkili e-posta adresini onaylayın.'**
  String get deleteAccountWarning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteAction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm verileri sil'**
  String get deleteAllData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm uygulama verilerinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'**
  String get deleteAllDataConfirmContent;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" kategorisini sil?'**
  String deleteCategoryConfirmNamed(Object name);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategoriyi sil'**
  String get deleteCategoryTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu özel kategoriyi sil?'**
  String get deleteCustomCategoryConfirm;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu kaydı silmek istediğinden emin misin?'**
  String get deleteEntryConfirm;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Etkinliği Sil'**
  String get deleteEvent;

  /// Bir alışkanlığı silmeden önce onay isteyen soru mesajı
  ///
  /// In tr, this message translates to:
  /// **'\'{title}\' odadan silinsin mi?'**
  String deleteHabitConfirm(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığı Sil'**
  String get deleteHabitTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu liste silinecek. Bağlı öğeler için işlemi seçin:'**
  String get deleteListMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeyi Sil'**
  String get deleteListTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı sil'**
  String get deleteMyAccount;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odayı Sil'**
  String get deleteRoomTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu oda ve tüm içeriği kalıcı olarak silinecek. Devam etmek istiyor musun?'**
  String get deleteRoomWarning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu görevi silmek istediğinize emin misiniz?'**
  String get deleteTaskConfirm;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu günlük görev silinsin mi? Bu işlem geri alınabilir.'**
  String get deleteTaskConfirmMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev silinsin mi?'**
  String get deleteTaskConfirmTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'\"{title}\" kaydını sil?'**
  String deleteTransactionConfirm(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu vizyonu sil?'**
  String get deleteVisionMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonu sil'**
  String get deleteVisionTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınızla ilgili ayrıntılar (isteğe bağlı)'**
  String get descHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açıklama ekle (isteğe bağlı)'**
  String get descriptionHintOptional;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get descriptionLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Detaylı grafikler ve istatistikler'**
  String get detailedCharts;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tanılama verileri'**
  String get diagnosticsData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uygulama kullanımına dair anonim istatistikleri paylaş'**
  String get diagnosticsDataSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zorluk Seviyesi'**
  String get difficulty;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Su İç'**
  String get drinkWater;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get duration;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre (otomatik)'**
  String get durationAutoLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süresiz'**
  String get durationIndefinite;

  /// Aylık süreyi ifade eder
  ///
  /// In tr, this message translates to:
  /// **'{count} ay'**
  String durationMonths(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre seçimi'**
  String get durationSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre Tipi'**
  String get durationType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toprak'**
  String get earthTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toprak renkleri'**
  String get earthThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kolay'**
  String get easy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get editButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategoriyi Düzenle'**
  String get editCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düzenle / Sil'**
  String get editDeleteTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Etkinliği Düzenle'**
  String get editEvent;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığı Düzenle'**
  String get editHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeyi Düzenle'**
  String get editListTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sadece kişisel listenize eklenmiş alışkanlıkları düzenleyebilirsiniz.'**
  String get editOnlyPersonalHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Eğitim'**
  String get education;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mistik yumurta cevabını verdi! ✨'**
  String get eggRevealMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aklından bir soru tut ve bir yumurtaya dokun 🥚'**
  String get eggSelectMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Emoji & Renk'**
  String get emojiAndColor;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hayvanlar'**
  String get emojiCategoryAnimals;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bakım'**
  String get emojiCategoryCare;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yiyecek'**
  String get emojiCategoryFood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get emojiCategoryHealth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yaşam'**
  String get emojiCategoryLife;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Doğa'**
  String get emojiCategoryNature;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Popüler'**
  String get emojiCategoryPopular;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üretkenlik'**
  String get emojiCategoryProductivity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Spor'**
  String get emojiCategorySport;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Emoji'**
  String get emojiLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şanslı/Kutsanmış'**
  String get emotionBlessed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıkılmış'**
  String get emotionBored;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendinden Emin'**
  String get emotionConfident;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kafası Karışık'**
  String get emotionConfused;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dikkati Dağınık'**
  String get emotionDistracted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Coşkulu'**
  String get emotionEuphoric;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Suçlu'**
  String get emotionGuilty;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Umutlu'**
  String get emotionHopeful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Güvensiz'**
  String get emotionInsecure;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yalnız'**
  String get emotionLonely;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hissiz'**
  String get emotionNumb;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bunalmış'**
  String get emotionOverwhelmed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gururlu'**
  String get emotionProud;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pişman'**
  String get emotionRegretful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Durdurulamaz'**
  String get emotionUnstoppable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeni takip etmek için ilk alışkanlığını oluştur.'**
  String get emptyHabitSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğuna Başla'**
  String get emptyHabitTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri Etkinleştir'**
  String get enableNotifications;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcıyı Etkinleştir'**
  String get enableReminder;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş Tarihi'**
  String get endDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get endDateLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş günü (isteğe bağlı)'**
  String get endDayOptionalLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş Saati'**
  String get endTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lütfen her iki seçeneği de girin'**
  String get enterBothOptions;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük bir limit hesaplamak için aylık bir plan girin.'**
  String get enterMonthlyPlanToComputeDailyLimit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınızın adını ve açıklamasını girin'**
  String get enterNameAndDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir promosyon kodu girin'**
  String get enterPromoCode;

  /// Title for value entry dialog
  ///
  /// In tr, this message translates to:
  /// **'Değer girin'**
  String get enterValueTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Adınızı girin'**
  String get enterYourName;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Girişler'**
  String get entries;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Giriş Sayısı'**
  String get entryCountLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarıyla kaydedildi!'**
  String get entrySaved;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hata: '**
  String get errorPrefix;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get eventDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Detayı'**
  String get eventDetails;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik Başlığı'**
  String get eventTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her'**
  String get every;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get everyDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her'**
  String get everyLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her {days} günde bir'**
  String everyNDays(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her {days} günde bir gerçekleşir'**
  String everyNDaysInfo(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaç günde bir?'**
  String get everyNDaysQuestion;

  /// Periyodik gün aralığını ifade eder
  ///
  /// In tr, this message translates to:
  /// **'Her {periodicDays} günde bir'**
  String everyXDays(Object periodicDays);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her Gün'**
  String get everyday;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tam'**
  String get exact;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesin Alarm İzni (Android 12+)'**
  String get exactAlarmPermission;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örnek: {example}'**
  String examplePrefix(Object example);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gider Δ'**
  String get expenseDelta;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gider dağılımı (pasta)'**
  String get expenseDistributionPie;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gideri Düzenle'**
  String get expenseEditTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gider'**
  String get expenseLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Gider'**
  String get expenseNewTitle;

  /// Veri yüklenemediğinde gösterilen genel hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yüklenemedi: {error}'**
  String failedToLoad(Object error);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Finans Özellikleri'**
  String get featureAdvancedFinance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Alışkanlık Oluşturma'**
  String get featureAdvancedHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AI Destekli Biyolojik Saat'**
  String get featureAiBioClock;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik ritminize göre optimum zamanlama'**
  String get featureAiBioClockDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AI Destekli Haftalık Rapor'**
  String get featureAiWeeklyReport;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlerlemenizin detaylı AI analizi'**
  String get featureAiWeeklyReportDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme Özelliği'**
  String get featureBackup;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Temalar'**
  String get featurePremiumThemes;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Oluşturma'**
  String get featureVisionCreation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu duyguyu daha ayrıntılı tarif edelim'**
  String get feelingMoreSpecific;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filterTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filterTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get finance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yapay Zeka ile Ekstre/Fiş Yükle'**
  String get financeAddAiStatementOption;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görsel veya PDF üzerinden otomatik ekler'**
  String get financeAddAiStatementSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Manuel Ekle'**
  String get financeAddManualOption;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finans Analizi · {month}'**
  String financeAnalysisTitle(Object month);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finans · Son 7 gün'**
  String get financeLast7Days;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Net'**
  String get financeNet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get finish;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sabit'**
  String get fixedDuration;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Esnek plan, istediğin zaman iptal et'**
  String get flexiblePlan;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Parayı Çevir'**
  String get flipCoin;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ODAK'**
  String get focusLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odaklanmış Zen'**
  String get focusedZen;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Minimalist, tek odak noktası'**
  String get focusedZenDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yazı Tipi'**
  String get font;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Orman'**
  String get forestTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Doğal yeşil tema'**
  String get forestThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sonsuza kadar'**
  String get forever;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Eğlence amaçlıdır.'**
  String get fortuneDisclaimer;

  /// Karar yumurtası için erişilebilirlik açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Yumurta {index}'**
  String fortuneEggSemantic(int index);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aşağıdan bir yumurta seç'**
  String get fortuneEggsSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir soru yazmadın'**
  String get fortuneNoQuestion;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar Yumurtaları'**
  String get fortunePlay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yumurtalara Geç'**
  String get fortuneProceedToEggs;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Bu hafta yeni bir şey denemeli miyim?'**
  String get fortuneQuestionHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aklındaki soruyu yaz'**
  String get fortuneQuestionPrompt;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cevabın'**
  String get fortuneResultTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yumurtayı sağa/sola kaydırarak değiştirin, üzerine dokununca cevap görünür'**
  String get fortuneSwipeInstruction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar Yumurtaları'**
  String get fortuneTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'14 gün ücretsiz deneme'**
  String get freeTrial14Days;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıklık'**
  String get frequency;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıklık'**
  String get frequencyLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get fridayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tam Ad'**
  String get fullName;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tam ekran'**
  String get fullScreen;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Galeri'**
  String get gallery;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!'**
  String get gamesDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oyunlar'**
  String get gamesTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get general;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Genel bildirimler'**
  String get generalNotifications;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'GENEL ODA İSTATİSTİKLERİ'**
  String get generalRoomStatsHeader;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get generate;

  /// İçeriğin oluşturulma tarihini gösterir
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma: {date}'**
  String generatedAtDate(Object date);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oluşturuluyor...'**
  String get generating;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bardak'**
  String get glasses;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Play Store\'a Git'**
  String get goToPlayStore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Altın'**
  String get goldenTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak altın tema'**
  String get goldenThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günaydın! ☀️'**
  String get goodMorning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verildi'**
  String get granted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün harika bir gün, başarabilirsin!'**
  String get greatDayAhead;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tünaydın'**
  String get greetingAfternoon;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İyi akşamlar'**
  String get greetingEvening;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günaydın'**
  String get greetingMorning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Misafir Hesabı'**
  String get guestAccount;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rehberli Yolculuk'**
  String get guidedJourney;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Adım adım rehberli akış'**
  String get guidedJourneyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık'**
  String get habit;

  /// Alışkanlık eklenirken oluşan hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklar eklenirken hata: {error}'**
  String habitAddError(Object error);

  /// Alışkanlıkların başarıyla eklendiğini gösteren çoğul destekli mesaj
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Hiç alışkanlık eklenmedi} =1{1 alışkanlık eklendi} other{{count} alışkanlık eklendi}}'**
  String habitAddSuccess(int count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık'**
  String get habitBlock;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık oluşturuldu: {title}'**
  String habitCreatedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık silindi: {title}'**
  String habitDeletedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get habitDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kısa bir açıklama ekle...'**
  String get habitDescriptionHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Detayları'**
  String get habitDetails;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yaratıcı Proje Zamanı'**
  String get habitExplorerCreativeProject;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hayal gücünüzü ateşleyen bir yaratıcı proje üzerinde çalışın.'**
  String get habitExplorerCreativeProjectDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bir Yer Keşfet'**
  String get habitExplorerExplorePlace;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bölgenizdeki yeni bir mahalle, park veya yeri ziyaret edin.'**
  String get habitExplorerExplorePlaceDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bir Şey Öğren'**
  String get habitExplorerLearnNewSkill;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her hafta yeni bir beceri veya konuya vakit ayırın.'**
  String get habitExplorerLearnNewSkillDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çeşitli İçerik Oku'**
  String get habitExplorerReadDiverse;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Farklı türlerde ve bakış açılarında kitaplar, makaleler veya içerik okuyun.'**
  String get habitExplorerReadDiverseDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bir Aktivite Dene'**
  String get habitExplorerTryNewActivity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Konfor alanınızın dışına çıkın ve farklı bir deneyim yaşayın.'**
  String get habitExplorerTryNewActivityDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Derin Nefes Egzersizi'**
  String get habitMindfulBreathing;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendinizi merkezlemek için derin nefes alma teknikleri uygulayın.'**
  String get habitMindfulBreathingDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şükür Pratiği'**
  String get habitMindfulGratitude;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün minnettar olduğunuz üç şeyi yazın.'**
  String get habitMindfulGratitudeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yansıtıcı Günlük Tutma'**
  String get habitMindfulJournaling;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Öz farkındalık için düşüncelerinizi ve yansımalarınızı günlüğe yazın.'**
  String get habitMindfulJournalingDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Meditasyon'**
  String get habitMindfulMeditation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'10-15 dakika bilinçli meditasyon yapın.'**
  String get habitMindfulMeditationDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Doğa Yürüyüşü'**
  String get habitMindfulNatureWalk;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çevrenize dikkat ederek doğada bilinçli bir yürüyüş yapın.'**
  String get habitMindfulNatureWalkDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Adı'**
  String get habitName;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Kitap oku, Su iç...'**
  String get habitNameHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Su içmek, Sayfa okumak...'**
  String get habitNameHintNumerical;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Meditasyon, Egzersiz...'**
  String get habitNameHintTimer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Adı'**
  String get habitNamePlaceholder;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık bulunamadı.'**
  String get habitNotFound;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu vizyonun alışkanlığı'**
  String get habitOfThisVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aylık Hedef Belirleme'**
  String get habitPlannerGoalSetting;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelecek ay için spesifik, ölçülebilir hedefler belirleyin.'**
  String get habitPlannerGoalSettingDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sabah Rutini'**
  String get habitPlannerMorningRoutine;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her günü verimliliğe uygun bir sabah rutiyle başlatın.'**
  String get habitPlannerMorningRoutineDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Görev Önceliklendirme'**
  String get habitPlannerTaskPrioritization;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her sabah gün içindeki en öncelikli 3 görevinizi belirleyin.'**
  String get habitPlannerTaskPrioritizationDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zaman Blokları'**
  String get habitPlannerTimeBlocking;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Derin çalışma için gününüzü odaklı zaman bloklarına ayırın.'**
  String get habitPlannerTimeBlockingDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık İnceleme'**
  String get habitPlannerWeeklyReview;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her Pazar haftanın ilerlemenizi inceleyin ve gelecek haftayı planlayın.'**
  String get habitPlannerWeeklyReviewDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığını tamamlama zamanı!'**
  String get habitReminderBody;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Hatırlatıcıları'**
  String get habitReminders;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklarınız için günlük hatırlatıcılar'**
  String get habitRemindersSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir Arkadaşı Ara'**
  String get habitSocialCallFriend;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Anlamlı bir sohbet için bir arkadaşınızla veya aile üyenizle iletişime geçin.'**
  String get habitSocialCallFriendDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Samimi Bir İltifat Yap'**
  String get habitSocialCompliment;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İçten bir iltifatla birinin gününü aydınlatın.'**
  String get habitSocialComplimentDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaliteli Aile Zamanı'**
  String get habitSocialFamilyTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aile üyeleriyle dikkat dağıtıcı şeyler olmadan özel vakit geçirin.'**
  String get habitSocialFamilyTimeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Grup Aktivitesine Katıl'**
  String get habitSocialGroupActivity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir grup aktivitesine veya sosyal etkinliğe katılın.'**
  String get habitSocialGroupActivityDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gönüllü Ol'**
  String get habitSocialVolunteer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gönüllü çalışma yoluyla topluluğunuza katkıda bulunun.'**
  String get habitSocialVolunteerDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Tipi'**
  String get habitTypeLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Nasıl bir alışkanlık oluşturmak istiyorsun?'**
  String get habitTypePickerSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Türü Seç'**
  String get habitTypePickerTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık güncellendi.'**
  String get habitUpdatedMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklar'**
  String get habits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklar'**
  String get habitsSection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zor'**
  String get hard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zor Mod'**
  String get hardMode;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odak'**
  String get headerFocusLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hazır'**
  String get headerFocusReady;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık'**
  String get headerHabitsLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get health;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yardım ve Destek'**
  String get helpAndSupport;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get history;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get historyTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'sa'**
  String get hourShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get hours;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'sa'**
  String get hoursSuffixShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendini nasıl hissediyorsun?'**
  String get howAreYouFeeling;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün nasıl hissediyorsun?'**
  String get howDoYouFeel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınızı ne sıklıkla yapacağınıza karar verin'**
  String get howOftenDoHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Nasıl iptal ederim?'**
  String get howToCancel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Nasıl kazanılır'**
  String get howToEarn;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınızın nasıl izleneceğini seçin'**
  String get howToTrackHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Eğer'**
  String get ifCondition;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz deneme iptal edilirse?'**
  String get ifTrialCancelled;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıdan içe aktar'**
  String get importFromLink;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Önemli Uyarı'**
  String get importantNotice;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İnaktif'**
  String get inactive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelir Δ'**
  String get incomeDelta;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geliri Düzenle'**
  String get incomeEditTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelir'**
  String get incomeLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Gelir'**
  String get incomeNewTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanmadı (seçilen gün)'**
  String get incompleteSelectedDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Giriş'**
  String get input;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İçgörüler'**
  String get insights;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yetersiz jeton! Reklam izleyerek jeton kazanın.'**
  String get insufficientTokensWatchAd;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kod 6 karakter olmalıdır'**
  String get invalidCodeLengthError;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz bağlantı.'**
  String get invalidLink;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz değer'**
  String get invalidValue;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu kopyalandı!'**
  String get inviteCodeCopiedSnackbar;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get inviteCodeTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sorun Açıklaması'**
  String get issueDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sorunu detaylı olarak açıklayın...'**
  String get issueDescriptionHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get joinButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşından aldığın 6 haneli davet kodunu gir:'**
  String get joinRoomCodeMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Davet koduyla mevcut bir odaya katıl'**
  String get joinRoomSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{roomName} odasına katıldın! 🎉'**
  String joinRoomSuccessSnackbar(Object roomName);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odaya Katıl'**
  String get joinRoomTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Katılım: {date}'**
  String joinedAtLabel(Object date);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük Girişi'**
  String get journalEntry;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün hakkında yazmak istediğin var mı?'**
  String get journalEntryDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün hakkında yazmak istediğin bir şey...'**
  String get journalHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'JSON Veri (örnek):'**
  String get jsonDataExample;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Az önce'**
  String get justNow;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika! Aynen devam! 💪'**
  String get keepItUp;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçimi'**
  String get languageSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Son 7 Günlük İlerleme'**
  String get last7DaysProgressLabel;

  /// Son başarılı yedekleme zamanını gösterir
  ///
  /// In tr, this message translates to:
  /// **'Son Yedekleme: {date}'**
  String lastBackup(String date);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Daha Sonra'**
  String get later;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lavanta Rüyaları'**
  String get lavenderDreams;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zarif lavanta ve mor tonları'**
  String get lavenderDreamsDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıralama Detayları'**
  String get leaderboardDetailsTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çık'**
  String get leaveButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odadan Çık'**
  String get leaveRoomTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu odadan çıkmak istediğine emin misin?'**
  String get leaveRoomWarning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hadi oynayalım! 🎮'**
  String get letsPlayGame;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hadi Başlayalım'**
  String get letsStart;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seviye {level}'**
  String levelLabel(Object level);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'S{level}'**
  String levelShort(Object level);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açık tema'**
  String get lightTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Katılıyorum'**
  String get likertAgree;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Katılmıyorum'**
  String get likertDisagree;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kararsızım'**
  String get likertNeutral;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesinlikle Katılıyorum'**
  String get likertStronglyAgree;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesinlikle Katılmıyorum'**
  String get likertStronglyDisagree;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıkları bağla'**
  String get linkHabits;

  /// Yeni bir liste oluşturulduğunda gösterilen bildirim
  ///
  /// In tr, this message translates to:
  /// **'Liste oluşturuldu: {title}'**
  String listCreated(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Liste oluşturuldu: {title}'**
  String listCreatedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get listLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Sağlık'**
  String get listNameHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Liste Adı'**
  String get listNameLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklar yükleniyor...'**
  String get loadingHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get logout;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En uzun seri'**
  String get longestStreak;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Uzun Seri'**
  String get longestStreakLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeleri yönet'**
  String get manageLists;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni listeler ekleyin, adlarını değiştirin veya silin.'**
  String get manageListsSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aboneliği Google Play\'de Yönet'**
  String get manageOnGooglePlay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aboneliği Yönet'**
  String get manageSubscription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Plan değiştir, iptal et veya fatura bilgilerini gör'**
  String get manageSubscriptionDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira Plus aboneliğini Google Play üzerinden düzenle'**
  String get manageSubscriptionSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görevleri Yönet'**
  String get manageVisionTasks;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Manuel Oluştur'**
  String get manualFallback;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Maksimum 12 seçenek ekleyebilirsin'**
  String get maxOptionsReached;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Meditasyon'**
  String get meditation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get medium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} üye'**
  String memberCountText(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üyenin Alışkanlıkları'**
  String get memberHabitsLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üye Profili'**
  String get memberProfileTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ÜYE'**
  String get memberTableHeader;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{completed}/{total} üye tamamladı'**
  String membersCompletedStatus(Object completed, Object total);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} kişi'**
  String membersCountText(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'dk'**
  String get minLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Farkındalık'**
  String get mindfulness;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Taze Nane'**
  String get mintFresh;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Taze nane ve turkuaz tonları'**
  String get mintFreshDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dakika'**
  String get minutes;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'dk'**
  String get minutesSuffixShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira Plus Aktif'**
  String get miraPlusActive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira Plus Aktif Değil'**
  String get miraPlusInactive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira Premium'**
  String get miraPremium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get mondayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ay sayısı'**
  String get monthCount;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: 12'**
  String get monthCountHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ay'**
  String get monthSuffixShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get monthly;

  /// Ayın belirli günlerini ifade eden metin
  ///
  /// In tr, this message translates to:
  /// **'Ayın {days}. günleri'**
  String monthlyDays(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayın belirli günlerinde'**
  String get monthlyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aylık ilerleme'**
  String get monthlyProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aylık trend'**
  String get monthlyTrend;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oca,Şub,Mar,Nis,May,Haz,Tem,Ağu,Eyl,Eki,Kas,Ara'**
  String get monthsShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh Hali'**
  String get mood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu Analizi'**
  String get moodAnalytics;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kötü'**
  String get moodBad;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kötü hissediyorum'**
  String get moodBadDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu durumun düşüşte'**
  String get moodDeclining;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu Dağılımı'**
  String get moodDistribution;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mükemmel'**
  String get moodExcellent;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika hissediyorum'**
  String get moodExcellentDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh Hali'**
  String get moodFlow;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü ruh halini seç'**
  String get moodFlowSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh Halin Nasıl?'**
  String get moodFlowTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get moodGood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İyi hissediyorum'**
  String get moodGoodDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika'**
  String get moodGreat;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu durumun iyileşiyor!'**
  String get moodImproving;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get moodNeutral;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Normal hissediyorum'**
  String get moodNeutralDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get moodOk;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh Hali Seçimi'**
  String get moodSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu durumun nispeten dengeli'**
  String get moodStable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Berbat'**
  String get moodTerrible;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çok kötü hissediyorum'**
  String get moodTerribleDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh Hali Takibi'**
  String get moodTracker;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duygu Trendi (Son 30 Gün)'**
  String get moodTrend;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Grafik'**
  String get moreChartsButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Aktif Üye'**
  String get mostActiveMemberLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Yaygın His'**
  String get mostCommonEmotion;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Yaygın Duygu'**
  String get mostCommonMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Yaygın Sebep'**
  String get mostCommonReason;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Motivasyon'**
  String get motivation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! {period} içinde başarı oranınız {percent}%. Harika bir ilerleme kaydettiniz.'**
  String motivationBody(Object percent, Object period);

  /// Güne başlarken verilen motivasyon mesajı
  ///
  /// In tr, this message translates to:
  /// **'{title} için harika bir gün! 🌟'**
  String motivationDayStart(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her yolculuk tek bir adımla başlar!'**
  String get motivationJourneyStart;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Büyük hedeflere ulaşmak için küçük adımlarla başla 💪'**
  String get motivationSmallSteps;

  /// Tamamlanmayı bekleyen bir görev için hatırlatıcı mesaj
  ///
  /// In tr, this message translates to:
  /// **'{title} seni bekliyor 🚀'**
  String motivationWaiting(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'AYB ort.'**
  String get mtdAverageShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla'**
  String get multiple;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla alt öğe'**
  String get multipleSubItems;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla alt öğe'**
  String get multipleSubItemsDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu özelliği kullanmak için Premium abonesi olmalısınız.'**
  String get mustBePremiumToUse;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Büyük Hedefim'**
  String get myBigGoal;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Panom'**
  String get myBoard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mistik'**
  String get mysticTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mistik mor tema'**
  String get mysticThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{days} gün'**
  String nDays(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} gün'**
  String nDaysLabel(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Günlük antrenman'**
  String get nameHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İsim'**
  String get nameLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ad gerekli'**
  String get nameRequired;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonunuza İsim Verin'**
  String get nameYourVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonunuza anlamlı bir isim verin'**
  String get nameYourVisionDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonuna anlamlı bir isim ver'**
  String get nameYourVisionSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En az 2 seçenek gerekli'**
  String get needAtLeastTwoOptions;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni kategori'**
  String get newCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Alışkanlık'**
  String get newHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni alışkanlıklar'**
  String get newHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni Liste'**
  String get newList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get next;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sonraki'**
  String get nextLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelecek Hafta'**
  String get nextWeek;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelecek yıl'**
  String get nextYear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üyenin henüz aktif alışkanlığı yok.'**
  String get noActiveHabitsForMember;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedek bulunamadı'**
  String get noBackups;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yedek bulunamadı.'**
  String get noBackupsFound;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz rozet kazanılmamış.'**
  String get noBadgesEarned;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Son 7 gün için veri yok'**
  String get noDataLast7Days;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu ay için veri yok'**
  String get noDataThisMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihi yok'**
  String get noEndDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş günü belirlenmediğinde, bu alışkanlık varsayılan olarak her gün görünecektir.'**
  String get noEndDayDefaultsDaily;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz giriş yok'**
  String get noEntriesYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz etkinlik yok'**
  String get noEvents;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride hiç harcama yok'**
  String get noExpenseInThisCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harcama yok'**
  String get noExpenses;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu ay hiç harcama yok'**
  String get noExpensesThisMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz alışkanlık eklenmemiş'**
  String get noHabitsAdded;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz alışkanlık eklenmedi.'**
  String get noHabitsAddedYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz alışkanlık eklenmemiş'**
  String get noHabitsInRoom;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş kaydı yok'**
  String get noHistory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu ay hiç gelir yok'**
  String get noIncomeThisMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçilen filtrelerle eşleşen öğe yok'**
  String get noItemsMatchFilters;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıralama Bulunmuyor'**
  String get noLeaderboardData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu vizyona bağlı alışkanlık yok.'**
  String get noLinkedHabitsInVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu üye için henüz ölçülebilir veri bulunmamaktadır.'**
  String get noMeasurableDataForMember;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz üye verisi yok.'**
  String get noMemberDataYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz duygu verisi yok'**
  String get noMoodData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz not yok'**
  String get noNotesYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şu anda görüntülenecek plan yok.'**
  String get noPlansAvailable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz ilerleme yok'**
  String get noProgressYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hazır vizyon bulunamadı.'**
  String get noReadyVisionsFound;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu ay için kayıt yok'**
  String get noRecordsThisMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz rapor yok'**
  String get noReportsYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir oda oluştur veya davet koduyla bir odaya katıl.\nArkadaşlarınla birlikte hedeflerine ulaş!'**
  String get noRoomsJoinedMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir odaya katılmadın'**
  String get noRoomsJoinedTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İstatistik Bulunmuyor'**
  String get noStatsAvailable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz görev yok'**
  String get noTasksYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Trend için yeterli veri yok'**
  String get noTrendData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Henüz eklenmedi.'**
  String get notAddedYet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verilmedi'**
  String get notGranted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçilmedi'**
  String get notSelected;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kilidi açılmadı'**
  String get notUnlocked;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get noteOptional;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Not paylaşıldı! ✨'**
  String get noteSharedSnackbar;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'📝 Notlar'**
  String get notesSection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Davranışı'**
  String get notificationBehavior;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim İzni'**
  String get notificationPermission;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim ayarları'**
  String get notificationSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim tercihlerini yapılandırın'**
  String get notificationSettingsSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerin düzgün çalışması için:\n\n• Pil optimizasyonunu KAPATIN (Ayarlar → Uygulamalar → Mira → Pil → Sınırsız)\n• Arka planda çalışmaya İZİN VERİN\n• Bildirim izinlerinin AÇIK olduğundan emin olun\n• \'Rahatsız etmeyin\' modunu kontrol edin'**
  String get notificationTroubleshooting;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Türleri'**
  String get notificationTypes;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm uygulama bildirimlerini kontrol et'**
  String get notificationsMasterSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dürt'**
  String get nudgeButtonLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'👊 Hadi dostum, bugün biraz daha gayret! Alışkanlıklarını tamamla.'**
  String get nudgeDefaultMessage;

  /// Bir arkadaşın kullanıcıyı dürttüğünde aldığı bildirim
  ///
  /// In tr, this message translates to:
  /// **'👊 {name} seni dürtüyor!'**
  String nudgeNotification(Object name);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{displayName} dürtüldü! 👊'**
  String nudgeSuccessSnackbar(Object displayName);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{displayName} kişisini dürt 👊'**
  String nudgeTitle(Object displayName);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayı'**
  String get numberLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günde 8 bardak su iç'**
  String get numericExample;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayısal Hedef Ayarları'**
  String get numericSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayı takibi'**
  String get numericTypeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayısal hedef takibi'**
  String get numericalDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayısal hedef'**
  String get numericalGoalShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayısal Değer'**
  String get numericalType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Okyanus'**
  String get oceanTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sakin mavi tema'**
  String get oceanThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get off;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get offLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük limitinizdesiniz.'**
  String get onDailyLimit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Belirli aralıklarla'**
  String get onPeriodic;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayın belirli günlerinde'**
  String get onSpecificMonthDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftanın belirli günlerinde'**
  String get onSpecificWeekdays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yılın belirli günlerinde'**
  String get onSpecificYearDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni deneyimler yaşamaktan ve tanımadığım şeyleri keşfetmekten hoşlanırım.'**
  String get onboardingQ1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Önemli etkinlikler ve görevler için önceden plan yaparım.'**
  String get onboardingQ10;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tek bir yönteme bağlı kalmaktansa farklı yaklaşımlar denemeyi severim.'**
  String get onboardingQ11;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Baskı altında sakin kalırım ve aksiliklerden çabuk toparlanırım.'**
  String get onboardingQ12;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alanımı düzenli tutarım ve yapılandırılmış bir günlük rutine sahip olmayı tercih ederim.'**
  String get onboardingQ2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İnsanların yanında olduğumda enerjilenirim ve sosyal etkinliklerden keyif alırım.'**
  String get onboardingQ3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başkalarıyla çalışmayı tercih ederim ve işbirliğinin rekabetten daha etkili olduğuna inanırım.'**
  String get onboardingQ4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Stresli durumlarla sakin bir şekilde başa çıkarım ve nadiren endişelenirim.'**
  String get onboardingQ5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sanat, müzik veya yazma gibi yaratıcı aktivitelerden hoşlanırım.'**
  String get onboardingQ6;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendime net hedefler koyarım ve bunları gerçekleştirmek için gayretle çalışırım.'**
  String get onboardingQ7;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Grup aktivitelerini yalnız vakit geçirmeye tercih ederim.'**
  String get onboardingQ8;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar vermeden önce genellikle başkalarının duygularını dikkate alırım.'**
  String get onboardingQ9;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kişiliğini daha iyi anlayabilmemiz için birkaç soruyu cevaplayın. Bu, bilimsel olarak doğrulanmış psikolojik araştırmalara dayanmaktadır.'**
  String get onboardingQuizIntro;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seninle birlikte büyüyen kişisel alışkanlık takipçin. Benzersiz kişiliğini keşfedelim ve sana özel alışkanlıklar önerelim.'**
  String get onboardingWelcomeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mira\'ya Hoş Geldin'**
  String get onboardingWelcomeTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir kez'**
  String get once;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get open;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pil optimizasyonunu aç'**
  String get openBatteryOptimization;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirim ayarlarını aç'**
  String get openNotificationSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sistem ayarlarını aç'**
  String get openSystemSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçenek 1'**
  String get option1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçenek 2'**
  String get option2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'isteğe bağlı'**
  String get optional;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'opsiyonel'**
  String get optionalLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get other;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Anahat'**
  String get outline;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Anahat rengi'**
  String get outlineColor;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get overall;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Genel ilerleme'**
  String get overallProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Genel Bakış'**
  String get overview;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayfa'**
  String get pages;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pastel Tonlar'**
  String get pastelColors;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get pause;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'/ay'**
  String get perMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'/yıl'**
  String get perYear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Periyodik'**
  String get periodic;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Belirli gün aralıklarıyla'**
  String get periodicDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Periyodik Seçim'**
  String get periodicSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kişiselleştirilmiş İçgörüler'**
  String get personalizedInsights;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf'**
  String get photo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Takvimden Seç'**
  String get pickFromCalendar;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Saat Seç'**
  String get pickTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugünün ruh halini seç'**
  String get pickTodaysMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Planlanan aylık harcama'**
  String get plannedMonthlySpend;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Planlar yüklenirken hata oluştu: {error}'**
  String plansLoadError(Object error);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Plaka rengi'**
  String get plateColor;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Oyna'**
  String get playAgain;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta girin'**
  String get pleaseEnterEmail;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tüm alanları doldurun'**
  String get pleaseFillAllFields;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'PUAN'**
  String get pointsTableHeader;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro ve özel zamanlayıcılar'**
  String get pomodoroAndCustomTimers;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium avantajları:'**
  String get premiumBenefits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Özellik'**
  String get premiumFeature;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Özellik'**
  String get premiumFeatureLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Özellikler'**
  String get premiumFeatures;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium Planlar'**
  String get premiumPlans;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get previous;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçen yıl'**
  String get previousYear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu görevi önceliklendir'**
  String get prioritizeTaskSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyPolicy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyPolicyTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik ve güvenlik'**
  String get privacySecurity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayarları ve veri silme seçeneklerini yönetin'**
  String get privacySecuritySubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İşlem başlatılıyor, lütfen bekleyin...'**
  String get processingWait;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üretkenlik'**
  String get productivity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Profil bilgileri'**
  String get profileInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Profil güncellendi'**
  String get profileUpdated;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlıklarını tamamladıkça bu grafik senin başarınla şekillenecek ✨'**
  String get progressJourneyMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlerleme Yolculuğu Başlıyor'**
  String get progressJourneyStarts;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium erişiminiz promosyon kodu ile aktifleştirildi ✨'**
  String get promoCodeActiveMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu hesapta daha önce bir promosyon kodu kullanılmış.'**
  String get promoCodeAlreadyUsed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Promosyon kodunuzu girin'**
  String get promoCodeHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz promosyon kodu. Lütfen kontrol edip tekrar deneyin.'**
  String get promoCodeInvalid;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Promosyon Kodu'**
  String get promoCodeLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'🎉 Promosyon kodu başarıyla uygulandı! Premium erişiminiz aktifleştirildi.'**
  String get promoCodeSuccess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Öneriler'**
  String get quickSuggestions;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'🏆 Sıralama & Alışkanlıklar'**
  String get rankingAndHabitsSection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kitap Oku'**
  String get readBook;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hazır vizyonlar yüklenemedi.'**
  String get readyVisionsLoadFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Akademik'**
  String get reasonAcademic;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get reasonFinance;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get reasonHealth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get reasonOther;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Gelişim'**
  String get reasonPersonalGrowth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlişki'**
  String get reasonRelationship;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu durumun sebebi nedir?'**
  String get reasonSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sosyal'**
  String get reasonSocial;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Neden'**
  String get reasonTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hava Durumu'**
  String get reasonWeather;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İş'**
  String get reasonWork;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Senin İçin Önerilen Alışkanlıklar'**
  String get recommendedHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçilen tarihte her ay otomatik olarak ekle'**
  String get recurringMonthlyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yinelenen (aylık)'**
  String get recurringMonthlyTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeyi Yenile'**
  String get refreshList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri ödeme talepleri Google Play politikalarına tabidir. Play Store\'dan başvurabilirsiniz.'**
  String get refundPolicy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Yükle'**
  String get reload;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün kalan'**
  String get remainingToday;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminder;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Kapalı'**
  String get reminderDisabled;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Açık'**
  String get reminderEnabled;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma Sıklığı'**
  String get reminderFrequency;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminderLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı Ayarları'**
  String get reminderSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma Zamanı'**
  String get reminderTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listeden kaldır'**
  String get removeFromList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her gün tekrarlanır'**
  String get repeatEveryDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her N Günde Bir Tekrarla'**
  String repeatEveryNDays(Object days);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta için rapor zaten mevcut.'**
  String get reportAlreadyExists;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hata Bildir'**
  String get reportBug;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştığınız sorunu aşağıya detaylı olarak yazın.'**
  String get reportBugDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştığınız sorunları bildirin'**
  String get reportBugSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rapor oluşturuldu! ✨'**
  String get reportCreatedSuccess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get resetAction;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tanıtımı sıfırla'**
  String get resetOnboarding;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem mevcut kişilik testi sonuçlarınızı silecek ve testi tekrar yapmanızı sağlayacaktır.'**
  String get resetOnboardingDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tanıtımı Sıfırla?'**
  String get resetOnboardingTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri Yükle'**
  String get restore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri yükleme hatası'**
  String get restoreError;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri yükleme başarısız'**
  String get restoreFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Son yedеği geri yükle'**
  String get restoreLatest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Satın Almaları Geri Yükle'**
  String get restorePurchases;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İndirildi: {content}'**
  String restoreSuccess(Object content);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.'**
  String get restoreSuccessMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kişilik Testini Yeniden Yap'**
  String get retakePersonalityTest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karakter tipini tekrar keşfet'**
  String get retakePersonalityTestDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Canlı Ritim Testini Yeniden Yap'**
  String get retakeRhythmTest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik saatini tekrar belirle'**
  String get retakeRhythmTestDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'05:00 – 06:30'**
  String get rhythmA1_1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'06:30 – 07:45'**
  String get rhythmA1_2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'07:45 – 09:45'**
  String get rhythmA1_3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'09:45 – 11:00'**
  String get rhythmA1_4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'11:00 – 12:00'**
  String get rhythmA1_5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çok yorgun'**
  String get rhythmA2_1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oldukça yorgun'**
  String get rhythmA2_2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biraz yorgun'**
  String get rhythmA2_3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hiç yorgun değil'**
  String get rhythmA2_4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'20:00 – 21:00'**
  String get rhythmA3_1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'21:00 – 22:15'**
  String get rhythmA3_2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'22:15 – 00:30'**
  String get rhythmA3_3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'00:30 – 01:45'**
  String get rhythmA3_4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'01:45 – 03:00'**
  String get rhythmA3_5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'05:00 – 09:00'**
  String get rhythmA4_1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'09:00 – 14:00'**
  String get rhythmA4_2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'14:00 – 17:00'**
  String get rhythmA4_3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'17:00 – 21:00'**
  String get rhythmA4_4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'21:00 – 05:00'**
  String get rhythmA4_5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesinlikle sabah insanı'**
  String get rhythmA5_1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Daha çok sabah insanı'**
  String get rhythmA5_2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Daha çok akşam insanı'**
  String get rhythmA5_3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesinlikle akşam insanı'**
  String get rhythmA5_4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Canlı Ritim analiz ediyor...'**
  String get rhythmAnalyzing;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Doğru zamanda doğru iş'**
  String get rhythmBenefit1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karar yorgunluğu yok'**
  String get rhythmBenefit2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her hafta kişiselleşme'**
  String get rhythmBenefit3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Akşam İnsanı (Gece Kuşu)'**
  String get rhythmChronoEvening;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ara Tip (Dengeli)'**
  String get rhythmChronoIntermediate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sabah İnsanı (Erkenci Kuş)'**
  String get rhythmChronoMorning;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bunlar kesin sonuçlar değil. Canlı Ritim seni tanıdıkça ayarlanacak.'**
  String get rhythmDisclaimer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Antrenman, fiziksel aktivite'**
  String get rhythmEnergyHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zihinsel çalışma, analiz, öğrenme'**
  String get rhythmFocusHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sizin İçin Önerilen Saatler:'**
  String get rhythmHabitSuggestionTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'E-postalar, sosyal medya, ufak işler'**
  String get rhythmLightHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamen kendi isteğinize bırakılsaydı ve ertesi gün zorunlu bir işiniz olmasaydı, saat kaçta kalkardınız?'**
  String get rhythmQ1;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sabah uyandıktan sonraki ilk yarım saatte kendinizi genelde ne kadar yorgun hissedersiniz?'**
  String get rhythmQ2;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Akşamları tamamen serbestsiniz ve ertesi gün bir zorunluluğunuz yok. Saat kaçta uyurdunuz?'**
  String get rhythmQ3;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günün hangi saatinde kendinizi en iyi (enerjik) hissedersiniz?'**
  String get rhythmQ4;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'\"Sabah insanı\" mı yoksa \"Akşam insanı\" mı olduğunuzu düşünüyorsunuz?'**
  String get rhythmQ5;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük, kitap, uykuya hazırlık'**
  String get rhythmReflectionHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika, Başlayalım'**
  String get rhythmResultGotIt;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verilerinize dayanarak gününüzü sizin için bölümlere ayırdık.'**
  String get rhythmResultSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Saat Profiliniz'**
  String get rhythmResultTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paketleri İncele'**
  String get rhythmTeaserCta;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get rhythmTeaserSkip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Canlı Ritim, en verimli anlarınızı öğrenir ve alışkanlıklarınızı doğru zamana yerleştirir.'**
  String get rhythmTeaserSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Saatinize Göre Alışkanlıkları Maksimum Verimle Kazanın'**
  String get rhythmTeaserTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Enerji Zamanı'**
  String get rhythmWindowEnergy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hareket, aksiyon, spor'**
  String get rhythmWindowEnergyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Odak Zamanı'**
  String get rhythmWindowFocus;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zihinsel netlik, öğrenme, analiz'**
  String get rhythmWindowFocusDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hafif Zaman'**
  String get rhythmWindowLight;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düşük efor, küçük işler'**
  String get rhythmWindowLightDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ritim testini tamamlayarak kişiselleştirilmiş öneriler alabilirsin'**
  String get rhythmWindowNoProfileHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Refleksiyon Zamanı'**
  String get rhythmWindowReflection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük, tefekkür, kapanış'**
  String get rhythmWindowReflectionDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu alışkanlığı hangi zaman diliminde yapmak istersin?'**
  String get rhythmWindowStepSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En Uygun Zaman Dilimi'**
  String get rhythmWindowStepTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oda'**
  String get roomFabLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ODA ÜYELERİ'**
  String get roomMembersLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Sabah Rutini Ekibi'**
  String get roomNameHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oda Adı'**
  String get roomNameLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu kodla bir oda bulunamadı'**
  String get roomNotFoundError;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ODA ÖZETİ'**
  String get roomSummaryHeader;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Köşeleri yuvarlat'**
  String get roundCorners;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen süre ≥ {target}'**
  String ruleEnteredDurationAtLeast(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen süre ≤ {target}'**
  String ruleEnteredDurationAtMost(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen süre = {target}'**
  String ruleEnteredDurationExactly(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen değer ≥ {target}'**
  String ruleEnteredValueAtLeast(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen değer ≤ {target}'**
  String ruleEnteredValueAtMost(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kural: Girilen değer = {target}'**
  String ruleEnteredValueExactly(Object target);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ÇALIŞIYOR'**
  String get runningLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get saturdayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get saveButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Kaydet'**
  String get saveChanges;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Girişi Kaydet'**
  String get saveEntry;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaydederken bir hata oluştu'**
  String get saveError;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi'**
  String get saved;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor...'**
  String get saving;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tasarruf / Bütçe Planı'**
  String get savingsBudgetPlan;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığınızın programını ayarlayın'**
  String get scheduleHabit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Program'**
  String get scheduleLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zamanlama Seçenekleri'**
  String get schedulingOptions;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Saniye'**
  String get seconds;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tam abonelik bilgilerinizi görün'**
  String get seeFullSubscriptionInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get select;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Seç'**
  String get selectAll;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lütfen en az bir gün seçin'**
  String get selectAtLeastOneDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kategori Seç'**
  String get selectCategory;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tarih Seç'**
  String get selectDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gün Seçin'**
  String get selectDay;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre Seç'**
  String get selectDuration;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Emoji seç'**
  String get selectEmoji;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihini seç'**
  String get selectEndDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıklık Seç'**
  String get selectFrequency;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Seç'**
  String get selectHabitLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlık Türü Seç'**
  String get selectHabitType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük rutinine eklemek istediğin alışkanlıkları seç:'**
  String get selectHabitsToAdd;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ay seç'**
  String get selectMonthTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sebep Seç'**
  String get selectReason;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günümüzü en çok hangi faktör etkiledi?'**
  String get selectReasonDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rapor Türü Seçin:'**
  String get selectReportType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alt Duygu Seç'**
  String get selectSubEmotion;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hangi alt duygu seni en iyi tanımlıyor?'**
  String get selectSubEmotionDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zaman Seç'**
  String get selectTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şu anki ruh halini seç'**
  String get selectYourCurrentMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ruh halini seç'**
  String get selectYourMood;

  /// Ay içinde seçilen günlerin özeti
  ///
  /// In tr, this message translates to:
  /// **'Ayın {sorted}. günleri'**
  String selectedDaysOfMonth(Object sorted);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get send;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geriye gönder'**
  String get sendBackward;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugünün Odağı Yap'**
  String get setAsTodayFocus;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonunuz için zaman çizelgesini belirleyin'**
  String get setVisionTimeline;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı olarak paylaş'**
  String get shareAsLink;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Panoyu paylaş'**
  String get shareBoard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get shareButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Panoyu paylaş'**
  String get shareDashboard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu kodu arkadaşlarınla paylaş:'**
  String get shareInviteCodeMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım bağlantısı panoya kopyalandı.'**
  String get shareLinkCopied;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Düşüncelerini paylaş...'**
  String get shareNoteHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Not Paylaş'**
  String get shareNoteTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Not Paylaş'**
  String get shareNoteTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonu paylaş'**
  String get shareVision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeyi göster'**
  String get showProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yazıları göster'**
  String get showText;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karıştır'**
  String get shuffle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarısız oldu. Lütfen tekrar deneyin.'**
  String get signInFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Verileri kaydetmek için giriş yap'**
  String get signInToSaveData;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yap'**
  String get signInWithGoogle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yap'**
  String get signInWithGoogleButton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için Google hesabını bağla. Profil bilgilerin otomatik dolacak.'**
  String get signInWithGoogleDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google hesabınla giriş yap'**
  String get signInWithGoogleTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get signOut;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapmak istediğinize emin misiniz?'**
  String get signOutConfirmation;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığının kişiliğini yansıtsın'**
  String get simpleHabitColorSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir renk seç'**
  String get simpleHabitColorTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığını daha eğlenceli hale getir!'**
  String get simpleHabitEmojiSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Onu temsil edecek bir emoji seç'**
  String get simpleHabitEmojiTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerini belirle'**
  String get simpleHabitFrequencySubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ne sıklıkla yapmak istiyorsun?'**
  String get simpleHabitFrequencyTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktif olacağı günleri seç'**
  String get simpleHabitMonthDaysSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayın hangi günlerinde?'**
  String get simpleHabitMonthDaysTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Neyi alışkanlık haline getirmek istiyorsun?'**
  String get simpleHabitNameSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alışkanlığına bir isim ver'**
  String get simpleHabitNameTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tekrar aralığını belirle'**
  String get simpleHabitPeriodicSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kaç günde bir?'**
  String get simpleHabitPeriodicTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Her şey doğru görünüyor mu?'**
  String get simpleHabitPreviewSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika! İşte alışkanlığın'**
  String get simpleHabitPreviewTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük hatırlatıcıyla alışkanlığını kaçırma'**
  String get simpleHabitReminderSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sana hatırlatayım mı?'**
  String get simpleHabitReminderTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğun için bir başlangıç noktası seç'**
  String get simpleHabitStartDateSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman başlayacaksın?'**
  String get simpleHabitStartDateTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hızlıca bir alışkanlık oluştur'**
  String get simpleHabitSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Basit alışkanlık (hedef = 1)'**
  String get simpleHabitTargetOne;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Basit Alışkanlık'**
  String get simpleHabitTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Günlük yapılacaklar için. Tamamla veya tamamlama.'**
  String get simpleHabitTypeDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktif olacağı günleri seç'**
  String get simpleHabitWeekdaysSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hangi günlerde?'**
  String get simpleHabitWeekdaysTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seni adım adım yönlendireceğim. Birlikte harika bir alışkanlık oluşturalım!'**
  String get simpleHabitWizardDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yeni bir alışkanlık kazanmaya hazır mısın?'**
  String get simpleHabitWizardTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Basit'**
  String get simpleTypeShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geç'**
  String get skip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geç'**
  String get skipOnboarding;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Testi Atla'**
  String get skipTest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sosyal'**
  String get social;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarınla oda oluşturup birbirinizin ilerlemesini takip etmek için Google ile giriş yapman gerekiyor.'**
  String get socialFeaturesGuestMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Özellikler'**
  String get socialFeaturesTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Akış'**
  String get socialFeedTitle;

  /// Social rooms section title
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Odalar'**
  String get socialRoomsTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak Bulut'**
  String get softCloud;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bulut gibi, rüya gibi yumuşak'**
  String get softCloudDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'(Şeftali) Soft Peach'**
  String get softPeach;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak şeftali ve krem tonları'**
  String get softPeachDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ses'**
  String get sound;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sesli uyarılar'**
  String get soundAlerts;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerle birlikte ses çal'**
  String get soundSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayın Belirli Günleri'**
  String get specificDaysOfMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftanın Belirli Günleri'**
  String get specificDaysOfWeek;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yılın Belirli Günleri'**
  String get specificDaysOfYear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tavsiye almak için bir bütçe belirleyin.'**
  String get spendingAdvisorNoBudget;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika! Bütçenizle tam uyumlusunuz.'**
  String get spendingAdvisorOnTrack;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bütçeyi aştınız. Harcamalarınızı durdurun.'**
  String get spendingAdvisorOverBudget;

  /// Günlük güvenli harcama limitini gösteren danışman mesajı
  ///
  /// In tr, this message translates to:
  /// **'Günde {amount} harcayabilirsiniz.'**
  String spendingAdvisorSafe(Object amount);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harcama Danışmanı'**
  String get spendingAdvisorTitle;

  /// Bütçe aşımını önlemek için azaltılması gereken tutarı gösteren mesaj
  ///
  /// In tr, this message translates to:
  /// **'Limitinizde kalmak için günlük harcamayı {amount} azaltın.'**
  String spendingAdvisorWarning(Object amount);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika! Günlük ortalamadan {amount} daha az harcıyorsunuz.'**
  String spendingLessThanDailyAvg(Object amount);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uyarı! Günlük ortalamadan {amount} daha fazla harcıyorsunuz.'**
  String spendingMoreThanDailyAvg(Object amount);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'ÇEVİR'**
  String get spin;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Çevir'**
  String get spinAgain;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlat'**
  String get start;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Tarihi'**
  String get startDate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get startDateLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç günü (1-365)'**
  String get startDayLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğuna Başla'**
  String get startJourney;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Testi Başlat'**
  String get startTest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Testi tamamlarsan kişiliğine uygun öneriler ve önerilen alışkanlıklar alırsın. İstersen bu adımı şimdi atlayabilirsin.'**
  String get startTestDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kişilik testine başlamak ister misin?'**
  String get startTestTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Saati'**
  String get startTime;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Finanslarınızı takip etmeye başlayın ve harcamalarınızı kontrol altına alın.'**
  String get startTrackingFinances;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Analizleri görmek için duygu durumunu kaydetmeye başla'**
  String get startTrackingMood;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get startsOn;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aktif Gün'**
  String get statsActiveDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get statusLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Adım'**
  String get step;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Adım {current} / {total}'**
  String stepOf(Object current, Object total);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Adımlar'**
  String get steps;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'KRONOMETRE'**
  String get stopwatchLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} gün'**
  String streakDays(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seri göstergesi'**
  String get streakIndicator;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alev ve buz efektlerini göster'**
  String get streakIndicatorDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harika'**
  String get subEmotionAmazing;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kızgın'**
  String get subEmotionAngry;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Endişeli'**
  String get subEmotionAnxious;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şanslı'**
  String get subEmotionBlessed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıkılmış'**
  String get subEmotionBored;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sakin'**
  String get subEmotionCalm;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Neşeli'**
  String get subEmotionCheerful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kendinden Emin'**
  String get subEmotionConfident;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kafası Karışık'**
  String get subEmotionConfused;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Morali Bozuk'**
  String get subEmotionDemoralized;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kararlı'**
  String get subEmotionDetermined;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dikkati Dağınık'**
  String get subEmotionDistracted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Boşalmış'**
  String get subEmotionDrained;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Boş'**
  String get subEmotionEmpty;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Enerjik'**
  String get subEmotionEnergetic;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Coşkulu'**
  String get subEmotionEnthusiastic;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Coşkulu'**
  String get subEmotionEuphoric;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Heyecanlı'**
  String get subEmotionExcited;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitkin'**
  String get subEmotionExhausted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Minnettar'**
  String get subEmotionGrateful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Suçlu'**
  String get subEmotionGuilty;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mutlu'**
  String get subEmotionHappy;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çaresiz'**
  String get subEmotionHelpless;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Umutlu'**
  String get subEmotionHopeful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Umutsuz'**
  String get subEmotionHopeless;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İncinmiş'**
  String get subEmotionHurt;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kararsız'**
  String get subEmotionIndecisive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Güvensiz'**
  String get subEmotionInsecure;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yalnız'**
  String get subEmotionLonely;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sevgi Dolu'**
  String get subEmotionLoving;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Motive'**
  String get subEmotionMotivated;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hissiz'**
  String get subEmotionNumb;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıradan'**
  String get subEmotionOrdinary;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bunalmış'**
  String get subEmotionOverwhelmed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Huzurlu'**
  String get subEmotionPeaceful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gururlu'**
  String get subEmotionProud;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pişman'**
  String get subEmotionRegretful;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Üzgün'**
  String get subEmotionSad;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu duyguyu daha detaylı tarif edelim'**
  String get subEmotionSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Stresli'**
  String get subEmotionStressed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yorgun'**
  String get subEmotionTired;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Durdurulamaz'**
  String get subEmotionUnstoppable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Premium özelliklerin keyfini çıkarmak için abone olun'**
  String get subscribeToEnjoyPremium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Abonelik'**
  String get subscription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Abonelik Detayları'**
  String get subscriptionDetails;

  /// Alt görevlerin sırasını belirtir
  ///
  /// In tr, this message translates to:
  /// **'Alt görev {index}'**
  String subtaskIndex(Object index);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alt görevler'**
  String get subtasks;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alt Görevler'**
  String get subtasksTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Alt Görevler'**
  String get subtasksType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çoklu görev'**
  String get subtasksTypeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başarı'**
  String get success;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başarılı gün'**
  String get successfulDayLegend;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{count} Başarılı Gün'**
  String successfulDaysCount(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get sundayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sistem Bilgisi'**
  String get systemInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sistem teması'**
  String get systemTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlamak için + butonuna basın'**
  String get tapFabToCreate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çarkı çevirmek için ortadaki butona dokun'**
  String get tapSpinToStart;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Resim seçmek için dokunun'**
  String get tapToPickImage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef'**
  String get target;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef Süre (dakika)'**
  String get targetDurationMinutes;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef: {value}'**
  String targetShort(Object value);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef Tipi'**
  String get targetType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef Değer'**
  String get targetValue;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedef Değer'**
  String get targetValueLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev eklendi'**
  String get taskAdded;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{title} görevi eklendi! ✅'**
  String taskAddedSnackbar(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get taskCompleted;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev silindi: {title}'**
  String taskDeletedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (İsteğe Bağlı)'**
  String get taskDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get taskPending;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev Başlığı'**
  String get taskTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görev başlığı zorunlu'**
  String get taskTitleRequired;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hayalini anlat. Vizyon Panosu oluşturmana yardım edeyim.'**
  String get tellMeYourDream;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Biraz daha anlat'**
  String get tellUsMore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Şablon ayrıntıları bulunamadı'**
  String get templateDetailsNotFound;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Manuel'**
  String get templatesTabManual;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hazır'**
  String get templatesTabReady;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Testler'**
  String get testsSection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Metin'**
  String get textLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kazanan:'**
  String get theWinnerIs;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Derinlik'**
  String get themeAbyss;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Karanlık ve sofistike'**
  String get themeAbyssDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Allık'**
  String get themeBlush;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tatlı ve feminen'**
  String get themeBlushDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cotton'**
  String get themeCotton;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Nötr ve sıcak'**
  String get themeCottonDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Krem'**
  String get themeCream;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak ve yumuşak'**
  String get themeCreamDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bordo'**
  String get themeCrimson;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cesur ve tutkulu'**
  String get themeCrimsonDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tema Detayları'**
  String get themeDetails;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Orman'**
  String get themeForest;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zengin ve organik'**
  String get themeForestDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Lavender'**
  String get themeLavender;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sakin mor'**
  String get themeLavenderDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Matcha'**
  String get themeMatcha;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Taze yeşil'**
  String get themeMatchaDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Leylak'**
  String get themeMauve;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zarif ve romantik'**
  String get themeMauveDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gece Yarısı'**
  String get themeMidnight;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Derin ve gizemli'**
  String get themeMidnightDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Okyanus'**
  String get themeOcean;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Derin ve serin'**
  String get themeOceanDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Rose'**
  String get themeRose;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak gül'**
  String get themeRoseDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tema Seçimi'**
  String get themeSelection;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sky'**
  String get themeSky;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ferah mavi'**
  String get themeSkyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Slate'**
  String get themeSlate;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Modern gri'**
  String get themeSlateDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gün Batımı'**
  String get themeSunset;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak ve altın'**
  String get themeSunsetDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vintage Kırmızı'**
  String get themeVintageRed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Klasik ve zamansız kırmızı'**
  String get themeVintageRedDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu özellik Premium\'da'**
  String get thisFeatureIsPremium;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu ay'**
  String get thisMonth;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta'**
  String get thisWeek;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu yıl'**
  String get thisYear;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get thursdayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sayaç'**
  String get timer;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Önce bir zamanlayıcı alışkanlığı oluşturun'**
  String get timerCreateTimerHabitFirst;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zaman tabanlı takip'**
  String get timerDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'30 dakikalık bir antrenman yap'**
  String get timerExample;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı Alışkanlığı'**
  String get timerHabitLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get timerPause;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen süre: {duration}'**
  String timerPendingDurationLabel(Object duration);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Beklemede: {duration}'**
  String timerPendingLabel(Object duration);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Mola'**
  String get timerPomodoroBreakPhase;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Çalışma: {count}'**
  String timerPomodoroCompletedWork(Object count);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uzun Mola Döngüsü (örn. 4)'**
  String get timerPomodoroLongBreakIntervalLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Uzun Mola (dk)'**
  String get timerPomodoroLongBreakMinutesLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro Ayarları'**
  String get timerPomodoroSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kısa Mola (dk)'**
  String get timerPomodoroShortBreakMinutesLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aşamayı Atla'**
  String get timerPomodoroSkipPhase;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çalışma (dk)'**
  String get timerPomodoroWorkMinutesLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çalışma'**
  String get timerPomodoroWorkPhase;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Ayarlar'**
  String get timerQuickPresets;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get timerResume;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süreyi Kaydet'**
  String get timerSaveDurationTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Oturumu Kaydet'**
  String get timerSaveSessionTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu oturum zaten kaydedilmiş'**
  String get timerSessionAlreadySaved;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Önce süreyi ayarla'**
  String get timerSetDurationFirst;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı Ayarları'**
  String get timerSettings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get timerStop;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri Sayım'**
  String get timerTabCountdown;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro'**
  String get timerTabPomodoro;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kronometre'**
  String get timerTabStopwatch;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre takibi'**
  String get timerTracking;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı'**
  String get timerType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kere'**
  String get times;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Zaman Dilimi'**
  String get timezone;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Örn: Market, Serbest Çalışma, vb.'**
  String get titleHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlık (isteğe bağlı)'**
  String get titleOptional;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugünün Alışkanlıkları'**
  String get todaysHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'+1 jeton kazandınız! 🎉'**
  String get tokenEarnedSuccess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get tomorrow;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'En İyi Kategoriler'**
  String get topCategories;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam Süre'**
  String get totalDuration;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam Kayıt'**
  String get totalEntries;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam üye'**
  String get totalMembersLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam ilerleme'**
  String get totalProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam başarılı gün'**
  String get totalSuccessfulDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Toplam başarısız gün'**
  String get totalUnsuccessfulDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Gelirlerini takip et'**
  String get trackEarnings;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Harcamalarını takip et'**
  String get trackSpending;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Trendler'**
  String get trends;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz deneme sırasında iptal ederseniz hemen ücretlendirilmezsiniz.'**
  String get trialCancelEffect;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'14 gün ücretsiz deneme, istediğin zaman iptal et.'**
  String get trialInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get tuesdayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir emoji girin'**
  String get typeEmoji;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Klavyeden bir emoji yazın'**
  String get typeEmojiHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get typeLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tür değiştirilemez'**
  String get typeNotChangeable;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlı günlük görevlerin atamasını kaldır'**
  String get unassignLinkedDailyTasks;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bağlı alışkanlıkların atamasını kaldır'**
  String get unassignLinkedHabits;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get undo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Kesintisiz kullanım'**
  String get uninterruptedUsage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Birim'**
  String get unit;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'adet'**
  String get unitAdet;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'adım'**
  String get unitAdim;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'bardak'**
  String get unitBardak;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Birim (bardak, adım, sayfa...)'**
  String get unitHint;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'kalori'**
  String get unitKalori;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'kez'**
  String get unitKez;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'km'**
  String get unitKm;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'litre'**
  String get unitLitre;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'sayfa'**
  String get unitSayfa;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen Liste'**
  String get unknownList;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız veri depolama'**
  String get unlimitedDataStorage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Listelenmemiş'**
  String get unlistedItems;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm özellikleri açın ve sınırları kaldırın.'**
  String get unlockAllFeatures;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'adsız'**
  String get unnamedBackup;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Aboneliğinizi yönetmek için Google Play Store\'u kullanın.'**
  String get usePlayStoreToManage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Geçerlilik'**
  String get validity;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Değer'**
  String get valueLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get vibration;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerle birlikte titreşim'**
  String get vibrationSubtitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Google Play Store\'dan faturalarınızı görüntüleyin'**
  String get viewInvoicesOnPlayStore;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon'**
  String get vision;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu vizyon şablondaki son günü kullanacak: {day}.'**
  String visionAutoDurationInfo(Object day);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Panosu'**
  String get visionBoard;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinizi organize etmek ve yolculuğunuzu takip etmek için bir vizyon oluşturun'**
  String get visionBoardDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pano görünümü'**
  String get visionBoardViewTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Oluştur'**
  String get visionCreateTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Süre (gün)'**
  String get visionDurationDaysLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Not: Vizyon başladığında toplam bir süre belirlenir; bitiş günü bu süreyi aşarsa otomatik olarak kısaltılır.'**
  String get visionDurationNote;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonu Düzenle'**
  String get visionEditTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinizi görselleştirin ve hayallerinizi gerçeğe dönüştürmek için ilk vizyonunuzu ekleyin.'**
  String get visionEmptyDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş günü 1 ile 365 arasında olmalıdır'**
  String get visionEndDayInvalid;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş günü başlangıç gününden küçük olamaz'**
  String get visionEndDayLess;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonun hangi gününde bitmeli?'**
  String get visionEndDayQuestion;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş gününü girin'**
  String get visionEndDayRequired;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Serbest pano'**
  String get visionFreeformTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bitiş günü belirtilmedi. Vizyon ucu açık başlayacak.'**
  String get visionNoEndDurationInfo;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonlar'**
  String get visionPlural;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Serbest pano ayarları'**
  String get visionSettingsTooltip;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç günü 1 ile 365 arasında olmalıdır'**
  String get visionStartDayInvalid;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyonun hangi gününde başlamalı?'**
  String get visionStartDayQuestion;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon başlatılamadı.'**
  String get visionStartFailed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon başlangıcı: '**
  String get visionStartLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon başladı: {title}'**
  String visionStartedMessage(Object title);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Vizyon Görevleri'**
  String get visionTasks;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Görsel'**
  String get visual;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak Günlük'**
  String get warmJournal;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sıcak günlük ve duygu takibi'**
  String get warmJournalDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Reklam İzle (+1 Jeton)'**
  String get watchAdForToken;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get wednesdayShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pzt,Sal,Çar,Per,Cum,Cmt,Paz'**
  String get weekDaysShort;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get weekdaysShortFri;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get weekdaysShortMon;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get weekdaysShortSat;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get weekdaysShortSun;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get weekdaysShortThu;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get weekdaysShortTue;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get weekdaysShortWed;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get weekly;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftanın belirli günlerinde'**
  String get weeklyDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık e-posta özeti'**
  String get weeklyEmailSummary;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık ilerleme'**
  String get weeklyProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Raporlar'**
  String get weeklyReportsTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get weeklySchedule;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Haftalık özet e-postası'**
  String get weeklySummaryEmail;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'İptal edersem ne olur?'**
  String get whatHappensIfCancel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bu durumun sebebi nedir?'**
  String get whatsTheCause;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Seçeneklerini yaz ve çarkı çevir'**
  String get wheelOfFortuneDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Çark Çevirme'**
  String get wheelOfFortuneTitle;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hangi günler'**
  String get whichDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hangi günler aktif olmalı?'**
  String get whichDaysActive;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Ayın hangi günleri'**
  String get whichMonthDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Hangi hafta günleri?'**
  String get whichWeekdays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yılın hangi günleri'**
  String get whichYearDays;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dünya'**
  String get worldTheme;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Tüm renklerin uyumu'**
  String get worldThemeDesc;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bir mesaj yaz...'**
  String get writeMessage;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'{current} / {total} XP • Sonraki seviye için {toNext} XP'**
  String xpProgressSummary(Object current, Object toNext, Object total);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'sonraki seviyeye'**
  String xpToNextLevel(Object toNext);

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get yearly;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Yıllık ilerleme'**
  String get yearlyProgress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Basit evet/hayır takibi'**
  String get yesNoDescription;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugün meditasyon yaptım mı?'**
  String get yesNoExample;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Evet/Hayır'**
  String get yesNoType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get yesterday;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get youLabel;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Senin Karakter Tipin'**
  String get yourCharacterType;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresiniz'**
  String get yourEmail;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresiniz'**
  String get yourEmailAddress;

  /// Auto-generated metadata
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü Ruh Halin'**
  String get yourMoodToday;

  /// Wizard bitirme butonu metni
  ///
  /// In tr, this message translates to:
  /// **'Tamamla'**
  String get wizardFinish;

  /// Wizard sonraki buton metni
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get wizardNext;

  /// Wizard atlama butonu metni
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get wizardSkip;

  /// Optional selection label
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı'**
  String get wizardOptional;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'nl',
        'pt',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
