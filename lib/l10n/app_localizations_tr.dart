// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get about => 'Hakkında';

  @override
  String get account => 'Hesap';

  @override
  String get achievements => 'Başarılar';

  @override
  String get active => 'Aktif';

  @override
  String get activeDays => 'Aktif günler';

  @override
  String get adFreeExperience => 'Reklamsız Deneyim';

  @override
  String get add => 'Ekle';

  @override
  String get addDate => 'Tarih ekle';

  @override
  String get addFirstTransaction => 'İlk işlemi ekle';

  @override
  String get addHabit => 'Alışkanlık Ekle';

  @override
  String get addImage => 'Resim Ekle';

  @override
  String get addNew => 'Yeni Ekle';

  @override
  String get addNewHabit => 'Yeni Alışkanlık Ekle';

  @override
  String get addOptionHint => 'Seçenek ekle...';

  @override
  String get addOptionsToStart => 'Başlamak için seçenek ekle';

  @override
  String get addSpecialDays => 'Özel Günler Ekle';

  @override
  String get addSubtask => 'Alt Görev Ekle';

  @override
  String get addTask => 'Görev Ekle';

  @override
  String get addText => 'Metin Ekle';

  @override
  String get addToList => 'Listeye ekle';

  @override
  String get advancedAnalysis => 'İleri Seviye Analiz';

  @override
  String get advancedAnalysisAndReports => 'İleri seviye analiz ve raporlar';

  @override
  String get advancedHabit => 'Gelişmiş Alışkanlık';

  @override
  String get advancedHabitTitle => 'Gelişmiş Alışkanlık';

  @override
  String get advancedTimer => 'Gelişmiş Timer';

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
  String get aiPoweredRecommendations => 'AI destekli öneriler';

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
  String get allDataDeleted => 'Tüm veriler silindi';

  @override
  String get allLabel => 'Tümü';

  @override
  String get alsoDeleteLinkedHabits => 'Bağlı alışkanlıkları da sil';

  @override
  String get amount => 'Miktar';

  @override
  String get amountLabel => 'Tutar';

  @override
  String get analysis => 'Analiz';

  @override
  String get analysisTooltip => 'Analiz';

  @override
  String get annualPlanDesc => '12 ay boyunca kesintisiz erişim';

  @override
  String get appTitle => 'Mira';

  @override
  String get appearance => 'Görünüm';

  @override
  String get apply => 'Uygula';

  @override
  String get applyCode => 'Kodu Uygula';

  @override
  String get applying => 'Uygulanıyor...';

  @override
  String approxVisionDurationDays(Object days) {
    return 'Bu vizyon yaklaşık $days gün sürer';
  }

  @override
  String get assetsReloadHint =>
      'Bazı varlıkların yüklenmesi için uygulamanın tamamen yeniden başlatılması gerekebilir.';

  @override
  String get atLeast => 'En Az';

  @override
  String get atMost => 'En Çok';

  @override
  String get autoBackupSubtitle =>
      'Verilerinizi her 24 saatte bir otomatik olarak Google Drive\'a yedekleyin.';

  @override
  String get autoBackupTitle => 'Otomatik Yedekleme';

  @override
  String get averageMood => 'Ortalama Duygu';

  @override
  String get back => 'Geri';

  @override
  String get backgroundPlate => 'Arka plan plakası';

  @override
  String get backupError => 'Yedekleme hatası';

  @override
  String get backupFailed => 'Yedekleme başarısız';

  @override
  String get backupNow => 'Hemen yedekle';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String backupSuccess(Object id) {
    return 'Yedeklendi: $id';
  }

  @override
  String get backupTitle => 'Yedekleme';

  @override
  String get backupToDrive => 'Drive\'a Yedekle';

  @override
  String get badgeActive100dDesc => '100 farklı günde aktif ol';

  @override
  String get badgeActive100dTitle => '100 Gün Aktif';

  @override
  String get badgeActive30dDesc => '30 farklı günde aktif ol';

  @override
  String get badgeActive30dTitle => '30 Gün Aktif';

  @override
  String get badgeActive7dDesc => '7 farklı günde aktif ol';

  @override
  String get badgeActive7dTitle => '7 Gün Aktif';

  @override
  String get badgeCategoryActivity => 'Aktivite';

  @override
  String get badgeCategoryFinance => 'Finans';

  @override
  String get badgeCategoryHabit => 'Alışkanlık';

  @override
  String get badgeCategoryLevel => 'Seviye';

  @override
  String get badgeCategoryVision => 'Vizyon';

  @override
  String get badgeCategoryXp => 'XP';

  @override
  String get badgeFin100Desc => '100 işlem kaydet';

  @override
  String get badgeFin100Title => 'Finansçı 100';

  @override
  String get badgeFin10Desc => '10 işlem kaydet';

  @override
  String get badgeFin10Title => 'Finansçı 10';

  @override
  String get badgeFin250Desc => '250 işlem kaydet';

  @override
  String get badgeFin250Title => 'Finansçı 250';

  @override
  String get badgeFin50Desc => '50 işlem kaydet';

  @override
  String get badgeFin50Title => 'Finansçı 50';

  @override
  String get badgeHabit100Desc => 'Toplamda 100 alışkanlık tamamla';

  @override
  String get badgeHabit100Title => 'Alışkanlık 100';

  @override
  String get badgeHabit10Desc => 'Toplamda 10 alışkanlık tamamla';

  @override
  String get badgeHabit10Title => 'Alışkanlık 10';

  @override
  String get badgeHabit200Desc => 'Toplamda 200 alışkanlık tamamla';

  @override
  String get badgeHabit200Title => 'Alışkanlık 200';

  @override
  String get badgeHabit50Desc => 'Toplamda 50 alışkanlık tamamla';

  @override
  String get badgeHabit50Title => 'Alışkanlık 50';

  @override
  String get badgeLevel10Desc => '10. seviyeye ulaş';

  @override
  String get badgeLevel10Title => 'Seviye 10';

  @override
  String get badgeLevel20Desc => '20. seviyeye ulaş';

  @override
  String get badgeLevel20Title => 'Seviye 20';

  @override
  String get badgeLevel5Desc => '5. seviyeye ulaş';

  @override
  String get badgeLevel5Title => 'Seviye 5';

  @override
  String get badgeVision10Desc => '10 vizyon oluştur';

  @override
  String get badgeVision10Title => 'Vizyon Büyükustası';

  @override
  String get badgeVision1Desc => 'İlk vizyonunu oluştur';

  @override
  String get badgeVision1Title => 'Vizyoner';

  @override
  String get badgeVision5Desc => '5 vizyon oluştur';

  @override
  String get badgeVision5Title => 'Vizyon Ustası';

  @override
  String get badgeVisionHabits3Desc => 'Bir vizyona 3+ alışkanlık bağla';

  @override
  String get badgeVisionHabits3Title => 'Bağlayıcı';

  @override
  String get badgeXp1000Desc => 'Toplam 1000 XP kazan';

  @override
  String get badgeXp1000Title => '1000 XP';

  @override
  String get badgeXp500Desc => 'Toplam 500 XP kazan';

  @override
  String get badgeXp500Title => '500 XP';

  @override
  String get badges => 'Rozetler';

  @override
  String get becomePremium => 'Premium Olun';

  @override
  String get becomePremiumShort => 'Premium Ol';

  @override
  String get between1And360 => '1 ile 360 arasında';

  @override
  String get billingHistory => 'Fatura Geçmişi';

  @override
  String get bio => 'Biyografi';

  @override
  String get bioHint => 'Kendiniz hakkında kısa bir biyografi';

  @override
  String get breakLabel => 'MOLA';

  @override
  String get breakTime => 'Mola';

  @override
  String get breakdownByCategory => 'Kategoriye göre döküm';

  @override
  String get bringForward => 'Öne getir';

  @override
  String bugReportFailedError(Object error) {
    return 'Hata raporu gönderilemedi: $error';
  }

  @override
  String bugReportFailedStatus(Object statusCode) {
    return 'Hata raporu gönderilemedi: $statusCode';
  }

  @override
  String get bugReportSentSuccess =>
      'Hata raporunuz başarıyla gönderildi. Teşekkür ederiz!';

  @override
  String get buyPremium => 'Premium Satın Al';

  @override
  String get canIGetRefund => 'Geri ödeme alabilir miyim?';

  @override
  String get cancel => 'İptal';

  @override
  String get cancelEffect =>
      'Abonelik süreniz bitene kadar premium özelliklerden faydalanmaya devam edersiniz.';

  @override
  String get cancelInstructions =>
      'Google Play Store → Abonelikler → Mira Plus → İptal Et';

  @override
  String get cannotOpenPlayStore => 'Play Store açılamıyor';

  @override
  String get category => 'Kategori';

  @override
  String get categoryName => 'Kategori Adı';

  @override
  String get characterDescBalancedMindful =>
      'Sakin, istikrarlı ve iç huzura değer veren birisin. Denge sağlamakta ve hayata bilinçlilik ve soğukkanlılıkla yaklaşmakta başarılısın.';

  @override
  String get characterDescExplorer =>
      'Meraklı, yaratıcı ve çeşitliliği seven birisin. Yeni şeyler öğrenmekten ve hayatın zorluklarına farklı yaklaşımlar denemekten keyif alırsın.';

  @override
  String get characterDescPlanner =>
      'Düzenli, hedef odaklı ve yapıdan beslenen birisin. Hayalleri eyleme dönüştürmekte ve disiplinle takip etmekte başarılısın.';

  @override
  String get characterDescSocialConnector =>
      'Sıcakkanlı, empatik ve ilişkilerden enerji alan birisin. Başkalarıyla bağlantı kurmakta ve güçlü topluluklar oluşturmakta anlam bulursun.';

  @override
  String get characterTypeBalancedMindful => 'Dengeli Bilinçli';

  @override
  String get characterTypeExplorer => 'Kaşif';

  @override
  String get characterTypePlanner => 'Planlayıcı';

  @override
  String get characterTypeSocialConnector => 'Sosyal Bağlayıcı';

  @override
  String get checkboxType => 'Onay Kutusu';

  @override
  String get checkboxTypeDesc => 'Basit işaretle';

  @override
  String get checkingPurchases => 'Satın almalar kontrol ediliyor...';

  @override
  String get chooseBestCategory =>
      'Alışkanlığınız için en iyi kategoriyi seçin';

  @override
  String get chooseColor => 'Renk Seç:';

  @override
  String get chooseEmoji => 'Emoji Seç:';

  @override
  String get choosePhoto => 'Fotoğraf Seç';

  @override
  String get choosePhotoSubtitle => 'Seni motive eden bir fotoğraf seç';

  @override
  String get choosePhotoDesc => 'Size ilham veren bir fotoğraf seçin';

  @override
  String get clear => 'Temizle';

  @override
  String get clearFilters => 'Filtreleri temizle';

  @override
  String get clearHistory => 'Geçmişi Temizle';

  @override
  String get close => 'Kapat';

  @override
  String get cloudBackup => 'Bulut Yedekleme';

  @override
  String get coinFlipDescription => 'İki seçenek arasında karar ver';

  @override
  String get coinFlipInstruction => 'İki seçeneği yaz ve parayı çevir!';

  @override
  String get coinFlipTitle => 'Yazı Tura';

  @override
  String get colorLabel => 'Renk';

  @override
  String get colorTheme => 'Renk teması';

  @override
  String get completeAllSubtasksToFinish =>
      'tümünü tamamlayınca alışkanlık tamamlanır';

  @override
  String get completedSelectedDay => 'Tamamlandı (seçilen gün)';

  @override
  String get confirmDeleteAccount => 'Hesabı silmeyi onayla';

  @override
  String get confirmHabits => 'Alışkanlıkları Onayla';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get continueText => 'Devam Et';

  @override
  String get cottonCandy => 'Pamuk Şeker';

  @override
  String get cottonCandyDesc => 'Pamuk şeker - pembe ve mavi';

  @override
  String get countdownConfigureTitle => 'Geri Sayımı Yapılandır';

  @override
  String get countdownLabel => 'GERİ SAYIM';

  @override
  String get cozyJournal => 'Rahat Günlük';

  @override
  String get cozyJournalDesc => 'Kahverengi tonlar ve zaman çizelgesi';

  @override
  String get crashReports => 'Çökme raporları';

  @override
  String get crashReportsSubtitle =>
      'Uygulama çökmelerinde anonim rapor gönder';

  @override
  String get create => 'Oluştur';

  @override
  String get createAdvancedHabit => 'Gelişmiş Alışkanlık Oluştur';

  @override
  String get createDailyTask => 'Günlük Görev Oluştur';

  @override
  String get createFirstHabit => 'Alışkanlık Oluştur';

  @override
  String get createFirstVision => 'İlk Vizyonunuzu Oluşturun';

  @override
  String get createHabit => 'Alışkanlığı Oluştur';

  @override
  String get createHabitAction => 'Alışkanlık Oluştur';

  @override
  String get createHabitTemplateTitle => 'Alışkanlık Şablonu Oluştur';

  @override
  String get createHabitTitle => 'Alışkanlık Oluştur';

  @override
  String get createList => 'Liste Oluştur';

  @override
  String get createNewCategory => 'Yeni Kategori Oluştur';

  @override
  String get createNewList => 'Yeni liste oluştur';

  @override
  String get createVision => 'Vizyon Oluştur';

  @override
  String get createVisionTemplateTitle => 'Vizyon Şablonu Oluştur';

  @override
  String get createVisionWithAI => 'Yapay Zeka ile Vizyon Oluştur';

  @override
  String get createWithAi => 'AI ile Oluştur';

  @override
  String get creatingBackup => 'Yedek oluşturuluyor...';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get custom => 'Özel';

  @override
  String get customCategories => 'Özel Kategoriler';

  @override
  String get customEmoji => 'Özel Emoji';

  @override
  String get customEmojiHint => 'Örn: ✨';

  @override
  String get customEmojiOptional => 'Özel emoji (isteğe bağlı)';

  @override
  String get customFrequency => 'Özel';

  @override
  String get customUnit => 'Özel Birim';

  @override
  String get customUnitHint => 'Örn: porsiyon, set, km...';

  @override
  String get daily => 'Günlük';

  @override
  String get dailyCheck => 'Günlük kontrol';

  @override
  String get dailyDesc => 'Her gün yapılacak';

  @override
  String get dailyLimit => 'Günlük limit';

  @override
  String get dailyTask => 'Günlük Görev';

  @override
  String dailyTaskCreatedMessage(Object title) {
    return 'Günlük görev oluşturuldu: $title';
  }

  @override
  String get dailyTasksSection => 'Günlük Görevler';

  @override
  String get darkTheme => 'Karanlık tema';

  @override
  String get dashboard => 'Panel';

  @override
  String get date => 'Tarih';

  @override
  String get dateRangeLabel => 'Tarih Aralığı';

  @override
  String get dayFriShort => 'Cum';

  @override
  String get dayMonShort => 'Pzt';

  @override
  String dayRangeShort(Object end, Object start) {
    return 'Gün $start–$end';
  }

  @override
  String get daySatShort => 'Cmt';

  @override
  String dayShort(Object day) {
    return 'Gün $day';
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
    return '$days gün önce';
  }

  @override
  String daysAverageShort(Object days) {
    return '${days}g ort.';
  }

  @override
  String daysCount(Object count) {
    return '$count gün';
  }

  @override
  String get daysInterval => 'günde bir';

  @override
  String get daysIntervalLabel => 'günde bir';

  @override
  String daysLater(Object days) {
    return '$days gün sonra';
  }

  @override
  String get daysLeft => 'gün kaldı';

  @override
  String get daysRemaining => 'Kalan Gün';

  @override
  String get decisionEggDescription => 'Mistik yumurtalardan birini seç';

  @override
  String get decisionEggTitle => 'Karar Yumurtası';

  @override
  String get defaultUnit => 'adet';

  @override
  String get delete => 'Sil';

  @override
  String get deleteAccountFailed => 'Hesap silme başarısız';

  @override
  String get deleteAccountRequestSuccess =>
      'Hesap silme talebiniz başarıyla alındı';

  @override
  String get deleteAccountSubtitle =>
      'Hesabınızın ve verilerinizin silinmesini talep edin';

  @override
  String get deleteAccountWarning =>
      'Bu işlem geri alınamaz. Lütfen hesabınızla ilişkili e-posta adresini onaylayın.';

  @override
  String get deleteAction => 'Sil';

  @override
  String get deleteAllData => 'Tüm verileri sil';

  @override
  String get deleteAllDataConfirmContent =>
      'Tüm uygulama verilerinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String deleteCategoryConfirmNamed(Object name) {
    return '\"$name\" kategorisini sil?';
  }

  @override
  String get deleteCategoryTitle => 'Kategoriyi sil';

  @override
  String get deleteCustomCategoryConfirm => 'Bu özel kategoriyi sil?';

  @override
  String get deleteEntryConfirm => 'Bu kaydı silmek istediğinden emin misin?';

  @override
  String deleteHabitConfirm(Object title) {
    return '\"$title\" alışkanlığı silinsin mi?';
  }

  @override
  String get deleteListMessage =>
      'Bu liste silinecek. Bağlı öğeler için işlemi seçin:';

  @override
  String get deleteListTitle => 'Listeyi Sil';

  @override
  String get deleteMyAccount => 'Hesabımı sil';

  @override
  String get deleteTaskConfirm => 'Bu görevi silmek istediğinize emin misiniz?';

  @override
  String get deleteTaskConfirmMessage =>
      'Bu günlük görev silinsin mi? Bu işlem geri alınabilir.';

  @override
  String get deleteTaskConfirmTitle => 'Görev silinsin mi?';

  @override
  String deleteTransactionConfirm(Object title) {
    return '\"$title\" kaydını sil?';
  }

  @override
  String get deleteVisionMessage => 'Bu vizyonu sil?';

  @override
  String get deleteVisionTitle => 'Vizyonu sil';

  @override
  String get descHint => 'Alışkanlığınızla ilgili ayrıntılar (isteğe bağlı)';

  @override
  String get descriptionHintOptional => 'Açıklama ekle (isteğe bağlı)';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get detailedCharts => 'Detaylı grafikler ve istatistikler';

  @override
  String get diagnosticsData => 'Tanılama verileri';

  @override
  String get diagnosticsDataSubtitle =>
      'Uygulama kullanımına dair anonim istatistikleri paylaş';

  @override
  String get difficulty => 'Zorluk Seviyesi';

  @override
  String get drinkWater => 'Su İç';

  @override
  String get duration => 'Süre';

  @override
  String get durationAutoLabel => 'Süre (otomatik)';

  @override
  String get durationIndefinite => 'Süresiz';

  @override
  String durationMonths(Object count) {
    return '$count ay';
  }

  @override
  String get durationSelection => 'Süre seçimi';

  @override
  String get durationType => 'Süre Tipi';

  @override
  String get earthTheme => 'Toprak';

  @override
  String get earthThemeDesc => 'Toprak renkleri';

  @override
  String get easy => 'Kolay';

  @override
  String get edit => 'Düzenle';

  @override
  String get editCategory => 'Kategoriyi Düzenle';

  @override
  String get editHabit => 'Alışkanlığı Düzenle';

  @override
  String get editListTitle => 'Listeyi Düzenle';

  @override
  String get education => 'Eğitim';

  @override
  String get eggRevealMessage => 'Mistik yumurta cevabını verdi! ✨';

  @override
  String get eggSelectMessage =>
      'Aklından bir soru tut ve bir yumurtaya dokun 🥚';

  @override
  String get emojiAndColor => 'Emoji & Renk';

  @override
  String get emojiCategoryAnimals => 'Hayvanlar';

  @override
  String get emojiCategoryCare => 'Bakım';

  @override
  String get emojiCategoryFood => 'Yiyecek';

  @override
  String get emojiCategoryHealth => 'Sağlık';

  @override
  String get emojiCategoryLife => 'Yaşam';

  @override
  String get emojiCategoryNature => 'Doğa';

  @override
  String get emojiCategoryPopular => 'Popüler';

  @override
  String get emojiCategoryProductivity => 'Üretkenlik';

  @override
  String get emojiCategorySport => 'Spor';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get emptyHabitSubtitle =>
      'İlerlemeni takip etmek için ilk alışkanlığını oluştur.';

  @override
  String get emptyHabitTitle => 'Yolculuğuna Başla';

  @override
  String get enableNotifications => 'Bildirimleri Etkinleştir';

  @override
  String get enableReminder => 'Hatırlatıcıyı Etkinleştir';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get endDateLabel => 'Bitiş';

  @override
  String get endDayOptionalLabel => 'Bitiş günü (isteğe bağlı)';

  @override
  String get enterBothOptions => 'Lütfen her iki seçeneği de girin';

  @override
  String get enterMonthlyPlanToComputeDailyLimit =>
      'Günlük bir limit hesaplamak için aylık bir plan girin.';

  @override
  String get enterNameAndDesc => 'Alışkanlığınızın adını ve açıklamasını girin';

  @override
  String get enterPromoCode => 'Lütfen bir promosyon kodu girin';

  @override
  String get enterValueTitle => 'Değer Gir';

  @override
  String get enterYourName => 'Adınızı girin';

  @override
  String get entries => 'Girişler';

  @override
  String get entrySaved => 'Giriş başarıyla kaydedildi!';

  @override
  String get errorPrefix => 'Hata: ';

  @override
  String get every => 'Her';

  @override
  String get everyDay => 'Her gün';

  @override
  String get everyLabel => 'Her';

  @override
  String get everyNDaysQuestion => 'Kaç günde bir?';

  @override
  String everyXDays(Object periodicDays) {
    return 'Her $periodicDays günde bir';
  }

  @override
  String get everyday => 'Her Gün';

  @override
  String get exact => 'Tam';

  @override
  String get exactAlarmPermission => 'Kesin Alarm İzni (Android 12+)';

  @override
  String examplePrefix(Object example) {
    return 'Örnek: $example';
  }

  @override
  String get expenseDelta => 'Gider Δ';

  @override
  String get expenseDistributionPie => 'Gider dağılımı (pasta)';

  @override
  String get expenseEditTitle => 'Gideri Düzenle';

  @override
  String get expenseLabel => 'Gider';

  @override
  String get expenseNewTitle => 'Yeni Gider';

  @override
  String failedToLoad(Object error) {
    return 'Yüklenemedi: $error';
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
  String get feelingMoreSpecific => 'Bu duyguyu daha ayrıntılı tarif edelim';

  @override
  String get filterTitle => 'Filtrele';

  @override
  String get filterTooltip => 'Filtrele';

  @override
  String get finance => 'Finans';

  @override
  String financeAnalysisTitle(Object month) {
    return 'Finans Analizi · $month';
  }

  @override
  String get financeLast7Days => 'Finans · Son 7 gün';

  @override
  String get financeNet => 'Net';

  @override
  String get finish => 'Bitir';

  @override
  String get fitness => 'Fitness';

  @override
  String get fixedDuration => 'Sabit';

  @override
  String get flexiblePlan => 'Esnek plan, istediğin zaman iptal et';

  @override
  String get flipCoin => 'Parayı Çevir';

  @override
  String get focusLabel => 'ODAK';

  @override
  String get focusedZen => 'Odaklanmış Zen';

  @override
  String get focusedZenDesc => 'Minimalist, tek odak noktası';

  @override
  String get font => 'Yazı Tipi';

  @override
  String get forestTheme => 'Orman';

  @override
  String get forestThemeDesc => 'Doğal yeşil tema';

  @override
  String get forever => 'Sonsuza kadar';

  @override
  String get fortuneDisclaimer => 'Eğlence amaçlıdır.';

  @override
  String fortuneEggSemantic(int index) {
    return 'Yumurta $index';
  }

  @override
  String get fortuneEggsSubtitle => 'Aşağıdan bir yumurta seç';

  @override
  String get fortuneNoQuestion => 'Bir soru yazmadın';

  @override
  String get fortunePlay => 'Karar Yumurtaları';

  @override
  String get fortuneProceedToEggs => 'Yumurtalara Geç';

  @override
  String get fortuneQuestionHint =>
      'Örn: Bu hafta yeni bir şey denemeli miyim?';

  @override
  String get fortuneQuestionPrompt => 'Aklındaki soruyu yaz';

  @override
  String get fortuneResultTitle => 'Cevabın';

  @override
  String get fortuneSwipeInstruction =>
      'Yumurtayı sağa/sola kaydırarak değiştirin, üzerine dokununca cevap görünür';

  @override
  String get fortuneTitle => 'Karar Yumurtaları';

  @override
  String get freeTrial14Days => '14 gün ücretsiz deneme';

  @override
  String get frequency => 'Sıklık';

  @override
  String get frequencyLabel => 'Sıklık';

  @override
  String get fridayShort => 'Cum';

  @override
  String get fullName => 'Tam Ad';

  @override
  String get fullScreen => 'Tam ekran';

  @override
  String get gallery => 'Galeri';

  @override
  String get gamesDescription =>
      'Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!';

  @override
  String get gamesTitle => 'Oyunlar';

  @override
  String get general => 'Genel';

  @override
  String get generalNotifications => 'Genel bildirimler';

  @override
  String get generate => 'Oluştur';

  @override
  String get glasses => 'Bardak';

  @override
  String get goToPlayStore => 'Play Store\'a Git';

  @override
  String get goldenTheme => 'Altın';

  @override
  String get goldenThemeDesc => 'Sıcak altın tema';

  @override
  String get goodMorning => 'Günaydın! ☀️';

  @override
  String get googleDrive => 'Google Drive';

  @override
  String get granted => 'Verildi';

  @override
  String get greatDayAhead => 'Bugün harika bir gün, başarabilirsin!';

  @override
  String get greetingAfternoon => 'Tünaydın';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get guestAccount => 'Misafir Hesabı';

  @override
  String get guidedJourney => 'Rehberli Yolculuk';

  @override
  String get guidedJourneyDesc => 'Adım adım rehberli akış';

  @override
  String get habit => 'Alışkanlık';

  @override
  String habitAddError(Object error) {
    return 'Alışkanlıklar eklenirken hata: $error';
  }

  @override
  String habitAddSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alışkanlık eklendi',
      one: '1 alışkanlık eklendi',
      zero: 'Hiç alışkanlık eklenmedi',
    );
    return '$_temp0';
  }

  @override
  String habitCreatedMessage(Object title) {
    return 'Alışkanlık oluşturuldu: $title';
  }

  @override
  String habitDeletedMessage(Object title) {
    return 'Alışkanlık silindi: $title';
  }

  @override
  String get habitDescription => 'Açıklama';

  @override
  String get habitDescriptionHint => 'Kısa bir açıklama ekle...';

  @override
  String get habitDetails => 'Alışkanlık Detayları';

  @override
  String get habitExplorerCreativeProject => 'Yaratıcı Proje Zamanı';

  @override
  String get habitExplorerCreativeProjectDesc =>
      'Hayal gücünüzü ateşleyen bir yaratıcı proje üzerinde çalışın.';

  @override
  String get habitExplorerExplorePlace => 'Yeni Bir Yer Keşfet';

  @override
  String get habitExplorerExplorePlaceDesc =>
      'Bölgenizdeki yeni bir mahalle, park veya yeri ziyaret edin.';

  @override
  String get habitExplorerLearnNewSkill => 'Yeni Bir Şey Öğren';

  @override
  String get habitExplorerLearnNewSkillDesc =>
      'Her hafta yeni bir beceri veya konuya vakit ayırın.';

  @override
  String get habitExplorerReadDiverse => 'Çeşitli İçerik Oku';

  @override
  String get habitExplorerReadDiverseDesc =>
      'Farklı türlerde ve bakış açılarında kitaplar, makaleler veya içerik okuyun.';

  @override
  String get habitExplorerTryNewActivity => 'Yeni Bir Aktivite Dene';

  @override
  String get habitExplorerTryNewActivityDesc =>
      'Konfor alanınızın dışına çıkın ve farklı bir deneyim yaşayın.';

  @override
  String get habitMindfulBreathing => 'Derin Nefes Egzersizi';

  @override
  String get habitMindfulBreathingDesc =>
      'Kendinizi merkezlemek için derin nefes alma teknikleri uygulayın.';

  @override
  String get habitMindfulGratitude => 'Şükür Pratiği';

  @override
  String get habitMindfulGratitudeDesc =>
      'Bugün minnettar olduğunuz üç şeyi yazın.';

  @override
  String get habitMindfulJournaling => 'Yansıtıcı Günlük Tutma';

  @override
  String get habitMindfulJournalingDesc =>
      'Öz farkındalık için düşüncelerinizi ve yansımalarınızı günlüğe yazın.';

  @override
  String get habitMindfulMeditation => 'Meditasyon';

  @override
  String get habitMindfulMeditationDesc =>
      '10-15 dakika bilinçli meditasyon yapın.';

  @override
  String get habitMindfulNatureWalk => 'Doğa Yürüyüşü';

  @override
  String get habitMindfulNatureWalkDesc =>
      'Çevrenize dikkat ederek doğada bilinçli bir yürüyüş yapın.';

  @override
  String get habitName => 'Alışkanlık Adı';

  @override
  String get habitNameHint => 'Örn: Kitap oku, Su iç...';

  @override
  String get habitNameHintNumerical => 'Örn: Su içmek, Sayfa okumak...';

  @override
  String get habitNameHintTimer => 'Örn: Meditasyon, Egzersiz...';

  @override
  String get habitNamePlaceholder => 'Alışkanlık Adı';

  @override
  String get habitNotFound => 'Alışkanlık bulunamadı.';

  @override
  String get habitOfThisVision => 'Bu vizyonun alışkanlığı';

  @override
  String get habitPlannerGoalSetting => 'Aylık Hedef Belirleme';

  @override
  String get habitPlannerGoalSettingDesc =>
      'Gelecek ay için spesifik, ölçülebilir hedefler belirleyin.';

  @override
  String get habitPlannerMorningRoutine => 'Sabah Rutini';

  @override
  String get habitPlannerMorningRoutineDesc =>
      'Her günü verimliliğe uygun bir sabah rutiyle başlatın.';

  @override
  String get habitPlannerTaskPrioritization => 'Günlük Görev Önceliklendirme';

  @override
  String get habitPlannerTaskPrioritizationDesc =>
      'Her sabah gün içindeki en öncelikli 3 görevinizi belirleyin.';

  @override
  String get habitPlannerTimeBlocking => 'Zaman Blokları';

  @override
  String get habitPlannerTimeBlockingDesc =>
      'Derin çalışma için gününüzü odaklı zaman bloklarına ayırın.';

  @override
  String get habitPlannerWeeklyReview => 'Haftalık İnceleme';

  @override
  String get habitPlannerWeeklyReviewDesc =>
      'Her Pazar haftanın ilerlemenizi inceleyin ve gelecek haftayı planlayın.';

  @override
  String get habitReminderBody => 'Alışkanlığını tamamlama zamanı!';

  @override
  String get habitReminders => 'Alışkanlık Hatırlatıcıları';

  @override
  String get habitRemindersSubtitle =>
      'Alışkanlıklarınız için günlük hatırlatıcılar';

  @override
  String get habitSocialCallFriend => 'Bir Arkadaşı Ara';

  @override
  String get habitSocialCallFriendDesc =>
      'Anlamlı bir sohbet için bir arkadaşınızla veya aile üyenizle iletişime geçin.';

  @override
  String get habitSocialCompliment => 'Samimi Bir İltifat Yap';

  @override
  String get habitSocialComplimentDesc =>
      'İçten bir iltifatla birinin gününü aydınlatın.';

  @override
  String get habitSocialFamilyTime => 'Kaliteli Aile Zamanı';

  @override
  String get habitSocialFamilyTimeDesc =>
      'Aile üyeleriyle dikkat dağıtıcı şeyler olmadan özel vakit geçirin.';

  @override
  String get habitSocialGroupActivity => 'Grup Aktivitesine Katıl';

  @override
  String get habitSocialGroupActivityDesc =>
      'Bir grup aktivitesine veya sosyal etkinliğe katılın.';

  @override
  String get habitSocialVolunteer => 'Gönüllü Ol';

  @override
  String get habitSocialVolunteerDesc =>
      'Gönüllü çalışma yoluyla topluluğunuza katkıda bulunun.';

  @override
  String get habitTypeLabel => 'Alışkanlık Tipi';

  @override
  String get habitUpdatedMessage => 'Alışkanlık güncellendi.';

  @override
  String get habits => 'Alışkanlıklar';

  @override
  String get habitsSection => 'Alışkanlıklar';

  @override
  String get hard => 'Zor';

  @override
  String get hardMode => 'Zor Mod';

  @override
  String get headerFocusLabel => 'Odak';

  @override
  String get headerFocusReady => 'Hazır';

  @override
  String get headerHabitsLabel => 'Alışkanlık';

  @override
  String get health => 'Sağlık';

  @override
  String get helpAndSupport => 'Yardım ve Destek';

  @override
  String get history => 'Geçmiş';

  @override
  String get historyTitle => 'Geçmiş';

  @override
  String get hourShort => 'sa';

  @override
  String get hours => 'Saat';

  @override
  String get howAreYouFeeling => 'Kendini nasıl hissediyorsun?';

  @override
  String get howDoYouFeel => 'Bugün nasıl hissediyorsun?';

  @override
  String get howOftenDoHabit =>
      'Alışkanlığınızı ne sıklıkla yapacağınıza karar verin';

  @override
  String get howToCancel => 'Nasıl iptal ederim?';

  @override
  String get howToEarn => 'Nasıl kazanılır';

  @override
  String get howToTrackHabit => 'Alışkanlığınızın nasıl izleneceğini seçin';

  @override
  String get ifCondition => 'Eğer';

  @override
  String get ifTrialCancelled => 'Ücretsiz deneme iptal edilirse?';

  @override
  String get importFromLink => 'Bağlantıdan içe aktar';

  @override
  String get importantNotice => 'Önemli Uyarı';

  @override
  String get inactive => 'İnaktif';

  @override
  String get incomeDelta => 'Gelir Δ';

  @override
  String get incomeEditTitle => 'Geliri Düzenle';

  @override
  String get incomeLabel => 'Gelir';

  @override
  String get incomeNewTitle => 'Yeni Gelir';

  @override
  String get incompleteSelectedDay => 'Tamamlanmadı (seçilen gün)';

  @override
  String get input => 'Giriş';

  @override
  String get insights => 'İçgörüler';

  @override
  String get invalidLink => 'Geçersiz bağlantı.';

  @override
  String get invalidValue => 'Geçersiz değer';

  @override
  String get issueDescription => 'Sorun Açıklaması';

  @override
  String get issueDescriptionHint => 'Sorunu detaylı olarak açıklayın...';

  @override
  String get journalEntry => 'Günlük Girişi';

  @override
  String get journalEntryDesc => 'Bugün hakkında yazmak istediğin var mı?';

  @override
  String get journalHint => 'Bugün hakkında yazmak istediğin bir şey...';

  @override
  String get jsonDataExample => 'JSON Veri (örnek):';

  @override
  String get keepItUp => 'Harika! Aynen devam! 💪';

  @override
  String get language => 'Dil';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String lastBackup(String date) {
    return 'Son Yedekleme: $date';
  }

  @override
  String get later => 'Daha Sonra';

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
    return 'Seviye $level';
  }

  @override
  String levelShort(Object level) {
    return 'S$level';
  }

  @override
  String get lightTheme => 'Açık tema';

  @override
  String get likertAgree => 'Katılıyorum';

  @override
  String get likertDisagree => 'Katılmıyorum';

  @override
  String get likertNeutral => 'Kararsızım';

  @override
  String get likertStronglyAgree => 'Kesinlikle Katılıyorum';

  @override
  String get likertStronglyDisagree => 'Kesinlikle Katılmıyorum';

  @override
  String get linkHabits => 'Alışkanlıkları bağla';

  @override
  String listCreated(Object title) {
    return 'Liste oluşturuldu: $title';
  }

  @override
  String listCreatedMessage(Object title) {
    return 'Liste oluşturuldu: $title';
  }

  @override
  String get listLabel => 'Liste';

  @override
  String get listNameHint => 'Örn: Sağlık';

  @override
  String get listNameLabel => 'Liste Adı';

  @override
  String get loadingHabits => 'Alışkanlıklar yükleniyor...';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get longestStreak => 'En uzun seri';

  @override
  String get manageLists => 'Listeleri yönet';

  @override
  String get manageListsSubtitle =>
      'Yeni listeler ekleyin, adlarını değiştirin veya silin.';

  @override
  String get manageOnGooglePlay => 'Aboneliği Google Play\'de Yönet';

  @override
  String get manageSubscription => 'Aboneliği Yönet';

  @override
  String get manageSubscriptionDesc =>
      'Plan değiştir, iptal et veya fatura bilgilerini gör';

  @override
  String get manageSubscriptionSubtitle =>
      'Mira Plus aboneliğini Google Play üzerinden düzenle';

  @override
  String get manageVisionTasks => 'Görevleri Yönet';

  @override
  String get manualFallback => 'Manuel Oluştur';

  @override
  String get maxOptionsReached => 'Maksimum 12 seçenek ekleyebilirsin';

  @override
  String get meditation => 'Meditasyon';

  @override
  String get medium => 'Orta';

  @override
  String get minLabel => 'dk';

  @override
  String get mindfulness => 'Farkındalık';

  @override
  String get mintFresh => 'Taze Nane';

  @override
  String get mintFreshDesc => 'Taze nane ve turkuaz tonları';

  @override
  String get minutes => 'Dakika';

  @override
  String get minutesSuffixShort => 'dk';

  @override
  String get miraPlusActive => 'Mira Plus Aktif';

  @override
  String get miraPlusInactive => 'Mira Plus Aktif Değil';

  @override
  String get miraPremium => 'Mira Premium';

  @override
  String get mondayShort => 'Pzt';

  @override
  String get monthCount => 'Ay sayısı';

  @override
  String get monthCountHint => 'Örn: 12';

  @override
  String get monthSuffixShort => 'ay';

  @override
  String get monthly => 'Aylık';

  @override
  String monthlyDays(Object days) {
    return 'Ayın $days. günleri';
  }

  @override
  String get monthlyDesc => 'Ayın belirli günlerinde';

  @override
  String get monthlyProgress => 'Aylık ilerleme';

  @override
  String get monthlyTrend => 'Aylık trend';

  @override
  String get monthsShort => 'Oca,Şub,Mar,Nis,May,Haz,Tem,Ağu,Eyl,Eki,Kas,Ara';

  @override
  String get mood => 'Ruh Hali';

  @override
  String get moodAnalytics => 'Duygu Analizi';

  @override
  String get moodBad => 'Kötü';

  @override
  String get moodBadDesc => 'Kötü hissediyorum';

  @override
  String get moodDeclining => 'Duygu durumun düşüşte';

  @override
  String get moodDistribution => 'Duygu Dağılımı';

  @override
  String get moodExcellent => 'Mükemmel';

  @override
  String get moodExcellentDesc => 'Harika hissediyorum';

  @override
  String get moodFlow => 'Ruh Hali';

  @override
  String get moodFlowSubtitle => 'Bugünkü ruh halini seç';

  @override
  String get moodFlowTitle => 'Ruh Halin Nasıl?';

  @override
  String get moodGood => 'İyi';

  @override
  String get moodGoodDesc => 'İyi hissediyorum';

  @override
  String get moodGreat => 'Harika';

  @override
  String get moodImproving => 'Duygu durumun iyileşiyor!';

  @override
  String get moodNeutral => 'Normal';

  @override
  String get moodNeutralDesc => 'Normal hissediyorum';

  @override
  String get moodOk => 'Normal';

  @override
  String get moodSelection => 'Ruh Hali Seçimi';

  @override
  String get moodStable => 'Duygu durumun nispeten dengeli';

  @override
  String get moodTerrible => 'Berbat';

  @override
  String get moodTerribleDesc => 'Çok kötü hissediyorum';

  @override
  String get moodTracker => 'Ruh Hali Takibi';

  @override
  String get moodTrend => 'Duygu Trendi (Son 30 Gün)';

  @override
  String get mostCommonEmotion => 'En Yaygın His';

  @override
  String get mostCommonMood => 'En Yaygın Duygu';

  @override
  String get mostCommonReason => 'En Yaygın Sebep';

  @override
  String get motivation => 'Motivasyon';

  @override
  String motivationBody(Object percent, Object period) {
    return 'Tebrikler! $period içinde başarı oranınız $percent%. Harika bir ilerleme kaydettiniz.';
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
  String get mtdAverageShort => 'AYB ort.';

  @override
  String get multiple => 'Çoklu';

  @override
  String get multipleSubItems => 'Çoklu alt maddeler';

  @override
  String get multipleSubItemsDesc => 'Çoklu alt öğeler';

  @override
  String get mustBePremiumToUse =>
      'Bu özelliği kullanmak için Premium abonesi olmalısınız.';

  @override
  String get myBigGoal => 'Büyük Hedefim';

  @override
  String get myBoard => 'Panom';

  @override
  String get mysticTheme => 'Mistik';

  @override
  String get mysticThemeDesc => 'Mistik mor tema';

  @override
  String nDaysLabel(Object count) {
    return '$count gün';
  }

  @override
  String get nameHint => 'Örn: Günlük antrenman';

  @override
  String get nameLabel => 'İsim';

  @override
  String get nameRequired => 'Ad gerekli';

  @override
  String get nameYourVision => 'Vizyonunuza İsim Verin';

  @override
  String get nameYourVisionDesc => 'Vizyonunuza anlamlı bir isim verin';

  @override
  String get nameYourVisionSubtitle => 'Vizyonuna anlamlı bir isim ver';

  @override
  String get needAtLeastTwoOptions => 'En az 2 seçenek gerekli';

  @override
  String get newCategory => 'Yeni kategori';

  @override
  String get newHabit => 'Yeni Alışkanlık';

  @override
  String get newHabits => 'Yeni alışkanlıklar';

  @override
  String get newList => 'Yeni Liste';

  @override
  String get next => 'İleri';

  @override
  String get nextLabel => 'Sonraki';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextYear => 'Gelecek yıl';

  @override
  String get noBackups => 'Yedek bulunamadı';

  @override
  String get noBackupsFound => 'Yedek bulunamadı.';

  @override
  String get noDataLast7Days => 'Son 7 gün için veri yok';

  @override
  String get noDataThisMonth => 'Bu ay için veri yok';

  @override
  String get noEndDate => 'Bitiş tarihi yok';

  @override
  String get noEndDayDefaultsDaily =>
      'Bitiş günü belirlenmediğinde, bu alışkanlık varsayılan olarak her gün görünecektir.';

  @override
  String get noEntriesYet => 'Henüz giriş yok';

  @override
  String get noExpenseInThisCategory => 'Bu kategoride hiç harcama yok';

  @override
  String get noExpenses => 'Harcama yok';

  @override
  String get noExpensesThisMonth => 'Bu ay hiç harcama yok';

  @override
  String get noHabitsAddedYet => 'Henüz alışkanlık eklenmedi.';

  @override
  String get noHistory => 'Geçmiş kaydı yok';

  @override
  String get noIncomeThisMonth => 'Bu ay hiç gelir yok';

  @override
  String get noItemsMatchFilters => 'Seçilen filtrelerle eşleşen öğe yok';

  @override
  String get noLinkedHabitsInVision => 'Bu vizyona bağlı alışkanlık yok.';

  @override
  String get noMoodData => 'Henüz duygu verisi yok';

  @override
  String get noPlansAvailable => 'Şu anda görüntülenecek plan yok.';

  @override
  String get noReadyVisionsFound => 'Hazır vizyon bulunamadı.';

  @override
  String get noRecordsThisMonth => 'Bu ay için kayıt yok';

  @override
  String get noTasksYet => 'Henüz görev yok';

  @override
  String get noTrendData => 'Trend için yeterli veri yok';

  @override
  String get notAddedYet => 'Henüz eklenmedi.';

  @override
  String get notGranted => 'Verilmedi';

  @override
  String get notSelected => 'Seçilmedi';

  @override
  String get notUnlocked => 'Kilidi açılmadı';

  @override
  String get noteOptional => 'Not (isteğe bağlı)';

  @override
  String get notificationBehavior => 'Bildirim Davranışı';

  @override
  String get notificationPermission => 'Bildirim İzni';

  @override
  String get notificationSettings => 'Bildirim ayarları';

  @override
  String get notificationSettingsSubtitle =>
      'Bildirim tercihlerini yapılandırın';

  @override
  String get notificationTroubleshooting =>
      'Bildirimlerin düzgün çalışması için:\n\n• Pil optimizasyonunu KAPATIN (Ayarlar → Uygulamalar → Mira → Pil → Sınırsız)\n• Arka planda çalışmaya İZİN VERİN\n• Bildirim izinlerinin AÇIK olduğundan emin olun\n• \'Rahatsız etmeyin\' modunu kontrol edin';

  @override
  String get notificationTypes => 'Bildirim Türleri';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationsMasterSubtitle =>
      'Tüm uygulama bildirimlerini kontrol et';

  @override
  String get numberLabel => 'Sayı';

  @override
  String get numericExample => 'Günde 8 bardak su iç';

  @override
  String get numericSettings => 'Sayısal Hedef Ayarları';

  @override
  String get numericTypeDesc => 'Sayı takibi';

  @override
  String get numericalDescription => 'Sayısal hedef takibi';

  @override
  String get numericalGoalShort => 'Sayısal hedef';

  @override
  String get numericalType => 'Sayısal Değer';

  @override
  String get oceanTheme => 'Okyanus';

  @override
  String get oceanThemeDesc => 'Sakin mavi tema';

  @override
  String get off => 'Kapalı';

  @override
  String get offLabel => 'Kapalı';

  @override
  String get ok => 'Tamam';

  @override
  String get onDailyLimit => 'Günlük limitinizdesiniz.';

  @override
  String get onPeriodic => 'Belirli aralıklarla';

  @override
  String get onSpecificMonthDays => 'Ayın belirli günlerinde';

  @override
  String get onSpecificWeekdays => 'Haftanın belirli günlerinde';

  @override
  String get onSpecificYearDays => 'Yılın belirli günlerinde';

  @override
  String get onboardingQ1 =>
      'Yeni deneyimler yaşamaktan ve tanımadığım şeyleri keşfetmekten hoşlanırım.';

  @override
  String get onboardingQ10 =>
      'Önemli etkinlikler ve görevler için önceden plan yaparım.';

  @override
  String get onboardingQ11 =>
      'Tek bir yönteme bağlı kalmaktansa farklı yaklaşımlar denemeyi severim.';

  @override
  String get onboardingQ12 =>
      'Baskı altında sakin kalırım ve aksiliklerden çabuk toparlanırım.';

  @override
  String get onboardingQ2 =>
      'Alanımı düzenli tutarım ve yapılandırılmış bir günlük rutine sahip olmayı tercih ederim.';

  @override
  String get onboardingQ3 =>
      'İnsanların yanında olduğumda enerjilenirim ve sosyal etkinliklerden keyif alırım.';

  @override
  String get onboardingQ4 =>
      'Başkalarıyla çalışmayı tercih ederim ve işbirliğinin rekabetten daha etkili olduğuna inanırım.';

  @override
  String get onboardingQ5 =>
      'Stresli durumlarla sakin bir şekilde başa çıkarım ve nadiren endişelenirim.';

  @override
  String get onboardingQ6 =>
      'Sanat, müzik veya yazma gibi yaratıcı aktivitelerden hoşlanırım.';

  @override
  String get onboardingQ7 =>
      'Kendime net hedefler koyarım ve bunları gerçekleştirmek için gayretle çalışırım.';

  @override
  String get onboardingQ8 =>
      'Grup aktivitelerini yalnız vakit geçirmeye tercih ederim.';

  @override
  String get onboardingQ9 =>
      'Karar vermeden önce genellikle başkalarının duygularını dikkate alırım.';

  @override
  String get onboardingQuizIntro =>
      'Kişiliğini daha iyi anlayabilmemiz için birkaç soruyu cevaplayın. Bu, bilimsel olarak doğrulanmış psikolojik araştırmalara dayanmaktadır.';

  @override
  String get onboardingWelcomeDesc =>
      'Seninle birlikte büyüyen kişisel alışkanlık takipçin. Benzersiz kişiliğini keşfedelim ve sana özel alışkanlıklar önerelim.';

  @override
  String get onboardingWelcomeTitle => 'Mira\'ya Hoş Geldin';

  @override
  String get once => 'Bir kez';

  @override
  String get open => 'Aç';

  @override
  String get openBatteryOptimization => 'Pil optimizasyonunu aç';

  @override
  String get openNotificationSettings => 'Bildirim ayarlarını aç';

  @override
  String get openSystemSettings => 'Sistem ayarlarını aç';

  @override
  String get option1 => 'Seçenek 1';

  @override
  String get option2 => 'Seçenek 2';

  @override
  String get optional => 'isteğe bağlı';

  @override
  String get optionalLabel => 'opsiyonel';

  @override
  String get other => 'Diğer';

  @override
  String get outline => 'Anahat';

  @override
  String get outlineColor => 'Anahat rengi';

  @override
  String get overall => 'Genel';

  @override
  String get overallProgress => 'Genel ilerleme';

  @override
  String get overview => 'Genel Bakış';

  @override
  String get pages => 'Sayfa';

  @override
  String get pastelColors => 'Pastel Tonlar';

  @override
  String get pause => 'Duraklat';

  @override
  String get perMonth => '/ay';

  @override
  String get perYear => '/yıl';

  @override
  String get periodic => 'Periyodik';

  @override
  String get periodicDesc => 'Belirli gün aralıklarıyla';

  @override
  String get periodicSelection => 'Periyodik Seçim';

  @override
  String get personalizedInsights => 'Kişiselleştirilmiş İçgörüler';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get pickFromCalendar => 'Takvimden Seç';

  @override
  String get pickTime => 'Saat Seç';

  @override
  String get pickTodaysMood => 'Bugünün ruh halini seç';

  @override
  String get plannedMonthlySpend => 'Planlanan aylık harcama';

  @override
  String plansLoadError(Object error) {
    return 'Planlar yüklenirken hata oluştu: $error';
  }

  @override
  String get plateColor => 'Plaka rengi';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get pleaseEnterEmail => 'Lütfen e-posta girin';

  @override
  String get pleaseFillAllFields => 'Lütfen tüm alanları doldurun';

  @override
  String get pomodoroAndCustomTimers => 'Pomodoro ve özel zamanlayıcılar';

  @override
  String get premiumBenefits => 'Premium avantajları:';

  @override
  String get premiumFeature => 'Premium Özellik';

  @override
  String get premiumFeatures => 'Premium Özellikler';

  @override
  String get premiumPlans => 'Premium Planlar';

  @override
  String get previous => 'Önceki';

  @override
  String get previousYear => 'Geçen yıl';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicyTitle => 'Gizlilik Politikası';

  @override
  String get privacySecurity => 'Gizlilik ve güvenlik';

  @override
  String get privacySecuritySubtitle =>
      'Ayarları ve veri silme seçeneklerini yönetin';

  @override
  String get processingWait => 'İşlem başlatılıyor, lütfen bekleyin...';

  @override
  String get productivity => 'Üretkenlik';

  @override
  String get profile => 'Profil';

  @override
  String get profileInfo => 'Profil bilgileri';

  @override
  String get profileUpdated => 'Profil güncellendi';

  @override
  String get promoCodeActiveMessage =>
      'Premium erişiminiz promosyon kodu ile aktifleştirildi ✨';

  @override
  String get promoCodeAlreadyUsed =>
      'Bu hesapta daha önce bir promosyon kodu kullanılmış.';

  @override
  String get promoCodeHint => 'Promosyon kodunuzu girin';

  @override
  String get promoCodeInvalid =>
      'Geçersiz promosyon kodu. Lütfen kontrol edip tekrar deneyin.';

  @override
  String get promoCodeLabel => 'Promosyon Kodu';

  @override
  String get promoCodeSuccess =>
      '🎉 Promosyon kodu başarıyla uygulandı! Premium erişiminiz aktifleştirildi.';

  @override
  String get quickSuggestions => 'Hızlı Öneriler';

  @override
  String get readBook => 'Kitap Oku';

  @override
  String get readyVisionsLoadFailed => 'Hazır vizyonlar yüklenemedi.';

  @override
  String get reasonAcademic => 'Akademik';

  @override
  String get reasonFinance => 'Finans';

  @override
  String get reasonHealth => 'Sağlık';

  @override
  String get reasonOther => 'Diğer';

  @override
  String get reasonPersonalGrowth => 'Kişisel Gelişim';

  @override
  String get reasonRelationship => 'İlişki';

  @override
  String get reasonSelection => 'Bu durumun sebebi nedir?';

  @override
  String get reasonSocial => 'Sosyal';

  @override
  String get reasonWeather => 'Hava Durumu';

  @override
  String get reasonWork => 'İş';

  @override
  String get recommendedHabits => 'Senin İçin Önerilen Alışkanlıklar';

  @override
  String get recurringMonthlyDesc =>
      'Seçilen tarihte her ay otomatik olarak ekle';

  @override
  String get recurringMonthlyTitle => 'Yinelenen (aylık)';

  @override
  String get refreshList => 'Listeyi Yenile';

  @override
  String get refundPolicy =>
      'Geri ödeme talepleri Google Play politikalarına tabidir. Play Store\'dan başvurabilirsiniz.';

  @override
  String get reload => 'Yeniden Yükle';

  @override
  String get remainingToday => 'Bugün kalan';

  @override
  String get reminder => 'Hatırlatıcı';

  @override
  String get reminderDisabled => 'Hatırlatıcı Kapalı';

  @override
  String get reminderEnabled => 'Hatırlatıcı Açık';

  @override
  String get reminderFrequency => 'Hatırlatma Sıklığı';

  @override
  String get reminderLabel => 'Hatırlatıcı';

  @override
  String get reminderSettings => 'Hatırlatıcı Ayarları';

  @override
  String get reminderTime => 'Hatırlatma Zamanı';

  @override
  String get removeFromList => 'Listeden kaldır';

  @override
  String get repeatEveryDay => 'Her gün tekrarlanır';

  @override
  String get repeatEveryNDays => 'Her N Günde Bir Tekrarla';

  @override
  String get reportBug => 'Hata Bildir';

  @override
  String get reportBugDescription =>
      'Karşılaştığınız sorunu aşağıya detaylı olarak yazın.';

  @override
  String get reportBugSubtitle => 'Karşılaştığınız sorunları bildirin';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resetAction => 'Sıfırla';

  @override
  String get resetOnboarding => 'Tanıtımı sıfırla';

  @override
  String get resetOnboardingDescription =>
      'Bu işlem mevcut kişilik testi sonuçlarınızı silecek ve testi tekrar yapmanızı sağlayacaktır.';

  @override
  String get resetOnboardingTitle => 'Tanıtımı Sıfırla?';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get restoreError => 'Geri yükleme hatası';

  @override
  String get restoreFailed => 'Geri yükleme başarısız';

  @override
  String get restoreLatest => 'Son yedеği geri yükle';

  @override
  String get restorePurchases => 'Satın Almaları Geri Yükle';

  @override
  String restoreSuccess(Object content) {
    return 'İndirildi: $content';
  }

  @override
  String get restoreSuccessMessage =>
      'Verileriniz başarıyla geri yüklendi. Değişikliklerin tam olarak uygulanması için uygulamayı yeniden başlatmanızı öneririz.';

  @override
  String get retakePersonalityTest => 'Kişilik testini tekrar yap';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get roundCorners => 'Köşeleri yuvarlat';

  @override
  String ruleEnteredDurationAtLeast(Object target) {
    return 'Kural: Girilen süre ≥ $target';
  }

  @override
  String ruleEnteredDurationAtMost(Object target) {
    return 'Kural: Girilen süre ≤ $target';
  }

  @override
  String ruleEnteredDurationExactly(Object target) {
    return 'Kural: Girilen süre = $target';
  }

  @override
  String ruleEnteredValueAtLeast(Object target) {
    return 'Kural: Girilen değer ≥ $target';
  }

  @override
  String ruleEnteredValueAtMost(Object target) {
    return 'Kural: Girilen değer ≤ $target';
  }

  @override
  String ruleEnteredValueExactly(Object target) {
    return 'Kural: Girilen değer = $target';
  }

  @override
  String get runningLabel => 'ÇALIŞIYOR';

  @override
  String get saturdayShort => 'Cmt';

  @override
  String get save => 'Kaydet';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get saveEntry => 'Girişi Kaydet';

  @override
  String get saveError => 'Kaydederken bir hata oluştu';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get saving => 'Kaydediliyor...';

  @override
  String get savingsBudgetPlan => 'Tasarruf / Bütçe Planı';

  @override
  String get scheduleHabit => 'Alışkanlığınızın programını ayarlayın';

  @override
  String get scheduleLabel => 'Program';

  @override
  String get schedulingOptions => 'Zamanlama Seçenekleri';

  @override
  String get seconds => 'Saniye';

  @override
  String get seeFullSubscriptionInfo => 'Tam abonelik bilgilerinizi görün';

  @override
  String get select => 'Seç';

  @override
  String get selectAll => 'Tümünü Seç';

  @override
  String get selectCategory => 'Kategori Seç';

  @override
  String get selectDate => 'Tarih Seç';

  @override
  String get selectDuration => 'Süre Seç';

  @override
  String get selectEmoji => 'Emoji seç';

  @override
  String get selectEndDate => 'Bitiş tarihini seç';

  @override
  String get selectFrequency => 'Sıklık Seç';

  @override
  String get selectHabitType => 'Alışkanlık Türü Seç';

  @override
  String get selectHabitsToAdd =>
      'Günlük rutinine eklemek istediğin alışkanlıkları seç:';

  @override
  String get selectMonthTooltip => 'Ay seç';

  @override
  String get selectReason => 'Sebep Seç';

  @override
  String get selectReasonDesc => 'Günümüzü en çok hangi faktör etkiledi?';

  @override
  String get selectSubEmotion => 'Alt Duygu Seç';

  @override
  String get selectSubEmotionDesc => 'Hangi alt duygu seni en iyi tanımlıyor?';

  @override
  String get selectTime => 'Zaman Seç';

  @override
  String get selectYourCurrentMood => 'Şu anki ruh halini seç';

  @override
  String get selectYourMood => 'Ruh halini seç';

  @override
  String selectedDaysOfMonth(Object sorted) {
    return 'Ayın $sorted. günleri';
  }

  @override
  String get send => 'Gönder';

  @override
  String get sendBackward => 'Geriye gönder';

  @override
  String get setVisionTimeline =>
      'Vizyonunuz için zaman çizelgesini belirleyin';

  @override
  String get settings => 'Ayarlar';

  @override
  String get shareAsLink => 'Bağlantı olarak paylaş';

  @override
  String get shareBoard => 'Panoyu paylaş';

  @override
  String get shareDashboard => 'Panoyu paylaş';

  @override
  String get shareLinkCopied => 'Paylaşım bağlantısı panoya kopyalandı.';

  @override
  String get shareVision => 'Vizyonu paylaş';

  @override
  String get showProgress => 'İlerlemeyi göster';

  @override
  String get showText => 'Yazıları göster';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get signInFailed => 'Giriş başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get signInToSaveData => 'Verileri kaydetmek için giriş yap';

  @override
  String get signInWithGoogle => 'Google ile giriş yap';

  @override
  String get signInWithGoogleButton => 'Google ile giriş yap';

  @override
  String get signInWithGoogleDesc =>
      'Devam etmek için Google hesabını bağla. Profil bilgilerin otomatik dolacak.';

  @override
  String get signInWithGoogleTitle => 'Google hesabınla giriş yap';

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
  String get simpleHabitTargetOne => 'Basit alışkanlık (hedef = 1)';

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
  String get simpleTypeShort => 'Basit';

  @override
  String get skip => 'Geç';

  @override
  String get skipOnboarding => 'Geç';

  @override
  String get skipTest => 'Testi Atla';

  @override
  String get social => 'Sosyal';

  @override
  String get socialFeedTitle => 'Akış';

  @override
  String get softCloud => 'Yumuşak Bulut';

  @override
  String get softCloudDesc => 'Bulut gibi, rüya gibi yumuşak';

  @override
  String get softPeach => '(Şeftali) Soft Peach';

  @override
  String get softPeachDesc => 'Sıcak şeftali ve krem tonları';

  @override
  String get sound => 'Ses';

  @override
  String get soundAlerts => 'Sesli uyarılar';

  @override
  String get soundSubtitle => 'Bildirimlerle birlikte ses çal';

  @override
  String get specificDaysOfMonth => 'Ayın Belirli Günleri';

  @override
  String get specificDaysOfWeek => 'Haftanın Belirli Günleri';

  @override
  String get specificDaysOfYear => 'Yılın Belirli Günleri';

  @override
  String get spendingAdvisorNoBudget =>
      'Tavsiye almak için bir bütçe belirleyin.';

  @override
  String get spendingAdvisorOnTrack => 'Harika! Bütçenizle tam uyumlusunuz.';

  @override
  String get spendingAdvisorOverBudget =>
      'Bütçeyi aştınız. Harcamalarınızı durdurun.';

  @override
  String spendingAdvisorSafe(Object amount) {
    return 'Günde $amount harcayabilirsiniz.';
  }

  @override
  String get spendingAdvisorTitle => 'Harcama Danışmanı';

  @override
  String spendingAdvisorWarning(Object amount) {
    return 'Limitinizde kalmak için günlük harcamayı $amount azaltın.';
  }

  @override
  String spendingLessThanDailyAvg(Object amount) {
    return 'Harika! Günlük ortalamadan $amount daha az harcıyorsunuz.';
  }

  @override
  String spendingMoreThanDailyAvg(Object amount) {
    return 'Uyarı! Günlük ortalamadan $amount daha fazla harcıyorsunuz.';
  }

  @override
  String get spin => 'ÇEVİR';

  @override
  String get spinAgain => 'Tekrar Çevir';

  @override
  String get start => 'Başlat';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get startDateLabel => 'Başlangıç';

  @override
  String get startDayLabel => 'Başlangıç günü (1-365)';

  @override
  String get startJourney => 'Yolculuğuna Başla';

  @override
  String get startTest => 'Testi Başlat';

  @override
  String get startTestDesc =>
      'Testi tamamlarsan kişiliğine uygun öneriler ve önerilen alışkanlıklar alırsın. İstersen bu adımı şimdi atlayabilirsin.';

  @override
  String get startTestTitle => 'Kişilik testine başlamak ister misin?';

  @override
  String get startTrackingFinances =>
      'Finanslarınızı takip etmeye başlayın ve harcamalarınızı kontrol altına alın.';

  @override
  String get startTrackingMood =>
      'Analizleri görmek için duygu durumunu kaydetmeye başla';

  @override
  String get startsOn => 'Başlangıç';

  @override
  String get statsActiveDays => 'Aktif Gün';

  @override
  String get statusLabel => 'Durum';

  @override
  String get step => 'Adım';

  @override
  String stepOf(Object current, Object total) {
    return 'Adım $current / $total';
  }

  @override
  String get steps => 'Adımlar';

  @override
  String get stopwatchLabel => 'KRONOMETRE';

  @override
  String streakDays(Object count) {
    return '$count Günlük Seri';
  }

  @override
  String get streakIndicator => 'Seri göstergesi';

  @override
  String get streakIndicatorDesc => 'Alev ve buz efektlerini göster';

  @override
  String get subEmotionAmazing => 'Harika';

  @override
  String get subEmotionAngry => 'Kızgın';

  @override
  String get subEmotionAnxious => 'Endişeli';

  @override
  String get subEmotionBlessed => 'Şanslı';

  @override
  String get subEmotionBored => 'Sıkılmış';

  @override
  String get subEmotionCalm => 'Sakin';

  @override
  String get subEmotionCheerful => 'Neşeli';

  @override
  String get subEmotionConfident => 'Kendinden Emin';

  @override
  String get subEmotionConfused => 'Kafası Karışık';

  @override
  String get subEmotionDemoralized => 'Morali Bozuk';

  @override
  String get subEmotionDetermined => 'Kararlı';

  @override
  String get subEmotionDistracted => 'Dikkati Dağınık';

  @override
  String get subEmotionDrained => 'Boşalmış';

  @override
  String get subEmotionEmpty => 'Boş';

  @override
  String get subEmotionEnergetic => 'Enerjik';

  @override
  String get subEmotionEnthusiastic => 'Coşkulu';

  @override
  String get subEmotionEuphoric => 'Coşkulu';

  @override
  String get subEmotionExcited => 'Heyecanlı';

  @override
  String get subEmotionExhausted => 'Bitkin';

  @override
  String get subEmotionGrateful => 'Minnettar';

  @override
  String get subEmotionGuilty => 'Suçlu';

  @override
  String get subEmotionHappy => 'Mutlu';

  @override
  String get subEmotionHelpless => 'Çaresiz';

  @override
  String get subEmotionHopeful => 'Umutlu';

  @override
  String get subEmotionHopeless => 'Umutsuz';

  @override
  String get subEmotionHurt => 'İncinmiş';

  @override
  String get subEmotionIndecisive => 'Kararsız';

  @override
  String get subEmotionInsecure => 'Güvensiz';

  @override
  String get subEmotionLonely => 'Yalnız';

  @override
  String get subEmotionLoving => 'Sevgi Dolu';

  @override
  String get subEmotionMotivated => 'Motive';

  @override
  String get subEmotionNumb => 'Hissiz';

  @override
  String get subEmotionOrdinary => 'Sıradan';

  @override
  String get subEmotionOverwhelmed => 'Bunalmış';

  @override
  String get subEmotionPeaceful => 'Huzurlu';

  @override
  String get subEmotionProud => 'Gururlu';

  @override
  String get subEmotionRegretful => 'Pişman';

  @override
  String get subEmotionSad => 'Üzgün';

  @override
  String get subEmotionSelection => 'Bu duyguyu daha detaylı tarif edelim';

  @override
  String get subEmotionStressed => 'Stresli';

  @override
  String get subEmotionTired => 'Yorgun';

  @override
  String get subEmotionUnstoppable => 'Durdurulamaz';

  @override
  String get subscribeToEnjoyPremium =>
      'Premium özelliklerin keyfini çıkarmak için abone olun';

  @override
  String get subscription => 'Abonelik';

  @override
  String get subscriptionDetails => 'Abonelik Detayları';

  @override
  String subtaskIndex(Object index) {
    return 'Alt görev $index';
  }

  @override
  String get subtasks => 'Alt görevler';

  @override
  String get subtasksTitle => 'Alt Görevler';

  @override
  String get subtasksType => 'Alt Görevler';

  @override
  String get subtasksTypeDesc => 'Çoklu görev';

  @override
  String get success => 'Başarı';

  @override
  String get successfulDayLegend => 'Başarılı gün';

  @override
  String successfulDaysCount(Object count) {
    return '$count Başarılı Gün';
  }

  @override
  String get sundayShort => 'Paz';

  @override
  String get systemInfo => 'Sistem Bilgisi';

  @override
  String get systemTheme => 'Sistem teması';

  @override
  String get tapFabToCreate => 'Başlamak için + butonuna basın';

  @override
  String get tapSpinToStart => 'Çarkı çevirmek için ortadaki butona dokun';

  @override
  String get tapToPickImage => 'Resim seçmek için dokunun';

  @override
  String get target => 'Hedef';

  @override
  String get targetDurationMinutes => 'Hedef Süre (dakika)';

  @override
  String targetShort(Object value) {
    return 'Hedef: $value';
  }

  @override
  String get targetType => 'Hedef Tipi';

  @override
  String get targetValue => 'Hedef Değer';

  @override
  String get targetValueLabel => 'Hedef Değer';

  @override
  String get taskAdded => 'Görev eklendi';

  @override
  String get taskCompleted => 'Tamamlandı';

  @override
  String taskDeletedMessage(Object title) {
    return 'Görev silindi: $title';
  }

  @override
  String get taskDescription => 'Açıklama (İsteğe Bağlı)';

  @override
  String get taskPending => 'Bekliyor';

  @override
  String get taskTitle => 'Görev Başlığı';

  @override
  String get taskTitleRequired => 'Görev başlığı zorunlu';

  @override
  String get tellMeYourDream =>
      'Hayalini anlat. Vizyon Panosu oluşturmana yardım edeyim.';

  @override
  String get tellUsMore => 'Biraz daha anlat';

  @override
  String get templateDetailsNotFound => 'Şablon ayrıntıları bulunamadı';

  @override
  String get templatesTabManual => 'Manuel';

  @override
  String get templatesTabReady => 'Hazır';

  @override
  String get textLabel => 'Metin';

  @override
  String get theWinnerIs => 'Kazanan:';

  @override
  String get theme => 'Tema';

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
  String get themeCottonDesc => 'Nötr ve sıcak';

  @override
  String get themeCream => 'Krem';

  @override
  String get themeCreamDesc => 'Sıcak ve yumuşak';

  @override
  String get themeCrimson => 'Bordo';

  @override
  String get themeCrimsonDesc => 'Cesur ve tutkulu';

  @override
  String get themeDetails => 'Tema Detayları';

  @override
  String get themeForest => 'Orman';

  @override
  String get themeForestDesc => 'Zengin ve organik';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeLavenderDesc => 'Sakin mor';

  @override
  String get themeMatcha => 'Matcha';

  @override
  String get themeMatchaDesc => 'Taze yeşil';

  @override
  String get themeMauve => 'Leylak';

  @override
  String get themeMauveDesc => 'Zarif ve romantik';

  @override
  String get themeMidnight => 'Gece Yarısı';

  @override
  String get themeMidnightDesc => 'Derin ve gizemli';

  @override
  String get themeOcean => 'Okyanus';

  @override
  String get themeOceanDesc => 'Derin ve serin';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeRoseDesc => 'Sıcak gül';

  @override
  String get themeSelection => 'Tema Seçimi';

  @override
  String get themeSky => 'Sky';

  @override
  String get themeSkyDesc => 'Ferah mavi';

  @override
  String get themeSlate => 'Slate';

  @override
  String get themeSlateDesc => 'Modern gri';

  @override
  String get themeSunset => 'Gün Batımı';

  @override
  String get themeSunsetDesc => 'Sıcak ve altın';

  @override
  String get themeVintageRed => 'Vintage Kırmızı';

  @override
  String get themeVintageRedDesc => 'Klasik ve zamansız kırmızı';

  @override
  String get thisFeatureIsPremium => 'Bu özellik Premium\'da';

  @override
  String get thisMonth => 'Bu ay';

  @override
  String get thisWeek => 'Bu hafta';

  @override
  String get thisYear => 'Bu yıl';

  @override
  String get thursdayShort => 'Per';

  @override
  String get timer => 'Sayaç';

  @override
  String get timerCreateTimerHabitFirst =>
      'Önce bir zamanlayıcı alışkanlığı oluşturun';

  @override
  String get timerDescription => 'Zaman tabanlı takip';

  @override
  String get timerExample => '30 dakikalık bir antrenman yap';

  @override
  String get timerHabitLabel => 'Zamanlayıcı Alışkanlığı';

  @override
  String get timerPause => 'Duraklat';

  @override
  String timerPendingDurationLabel(Object duration) {
    return 'Bekleyen süre: $duration';
  }

  @override
  String timerPendingLabel(Object duration) {
    return 'Beklemede: $duration';
  }

  @override
  String get timerPomodoroBreakPhase => 'Mola';

  @override
  String timerPomodoroCompletedWork(Object count) {
    return 'Tamamlanan Çalışma: $count';
  }

  @override
  String get timerPomodoroLongBreakIntervalLabel =>
      'Uzun Mola Döngüsü (örn. 4)';

  @override
  String get timerPomodoroLongBreakMinutesLabel => 'Uzun Mola (dk)';

  @override
  String get timerPomodoroSettings => 'Pomodoro Ayarları';

  @override
  String get timerPomodoroShortBreakMinutesLabel => 'Kısa Mola (dk)';

  @override
  String get timerPomodoroSkipPhase => 'Aşamayı Atla';

  @override
  String get timerPomodoroWorkMinutesLabel => 'Çalışma (dk)';

  @override
  String get timerPomodoroWorkPhase => 'Çalışma';

  @override
  String get timerQuickPresets => 'Hızlı Ayarlar';

  @override
  String get timerResume => 'Devam';

  @override
  String get timerSaveDurationTitle => 'Süreyi Kaydet';

  @override
  String get timerSaveSessionTitle => 'Oturumu Kaydet';

  @override
  String get timerSessionAlreadySaved => 'Bu oturum zaten kaydedilmiş';

  @override
  String get timerSetDurationFirst => 'Önce süreyi ayarla';

  @override
  String get timerSettings => 'Zamanlayıcı Ayarları';

  @override
  String get timerStop => 'Bitir';

  @override
  String get timerTabCountdown => 'Geri Sayım';

  @override
  String get timerTabPomodoro => 'Pomodoro';

  @override
  String get timerTabStopwatch => 'Kronometre';

  @override
  String get timerTracking => 'Süre takibi';

  @override
  String get timerType => 'Zamanlayıcı';

  @override
  String get times => 'Kere';

  @override
  String get timezone => 'Zaman Dilimi';

  @override
  String get titleHint => 'Örn: Market, Serbest Çalışma, vb.';

  @override
  String get titleOptional => 'Başlık (isteğe bağlı)';

  @override
  String get today => 'Bugün';

  @override
  String get todaysHabits => 'Bugünün Alışkanlıkları';

  @override
  String get tomorrow => 'Yarın';

  @override
  String get topCategories => 'En İyi Kategoriler';

  @override
  String get totalDuration => 'Toplam Süre';

  @override
  String get totalEntries => 'Toplam Kayıt';

  @override
  String get totalProgress => 'Toplam ilerleme';

  @override
  String get totalSuccessfulDays => 'Toplam başarılı gün';

  @override
  String get totalUnsuccessfulDays => 'Toplam başarısız gün';

  @override
  String get trackEarnings => 'Gelirlerini takip et';

  @override
  String get trackSpending => 'Harcamalarını takip et';

  @override
  String get trends => 'Trendler';

  @override
  String get trialCancelEffect =>
      'Ücretsiz deneme sırasında iptal ederseniz hemen ücretlendirilmezsiniz.';

  @override
  String get trialInfo => '14 gün ücretsiz deneme, istediğin zaman iptal et.';

  @override
  String get tuesdayShort => 'Sal';

  @override
  String get typeEmoji => 'Bir emoji girin';

  @override
  String get typeEmojiHint => 'Klavyeden bir emoji yazın';

  @override
  String get typeLabel => 'Tür';

  @override
  String get typeNotChangeable => 'Tür değiştirilemez';

  @override
  String get unassignLinkedDailyTasks =>
      'Bağlı günlük görevlerin atamasını kaldır';

  @override
  String get unassignLinkedHabits => 'Bağlı alışkanlıkların atamasını kaldır';

  @override
  String get undo => 'Geri al';

  @override
  String get uninterruptedUsage => 'Kesintisiz kullanım';

  @override
  String get unit => 'Birim';

  @override
  String get unitAdet => 'adet';

  @override
  String get unitAdim => 'adım';

  @override
  String get unitBardak => 'bardak';

  @override
  String get unitHint => 'Birim (bardak, adım, sayfa...)';

  @override
  String get unitKalori => 'kalori';

  @override
  String get unitKez => 'kez';

  @override
  String get unitKm => 'km';

  @override
  String get unitLitre => 'litre';

  @override
  String get unitSayfa => 'sayfa';

  @override
  String get unknownList => 'Bilinmeyen Liste';

  @override
  String get unlimitedDataStorage => 'Sınırsız veri depolama';

  @override
  String get unlistedItems => 'Listelenmemiş';

  @override
  String get unlockAllFeatures => 'Tüm özellikleri açın ve sınırları kaldırın.';

  @override
  String get unnamedBackup => 'adsız';

  @override
  String get update => 'Güncelle';

  @override
  String get usePlayStoreToManage =>
      'Aboneliğinizi yönetmek için Google Play Store\'u kullanın.';

  @override
  String get validity => 'Geçerlilik';

  @override
  String get valueLabel => 'Değer';

  @override
  String get vibration => 'Titreşim';

  @override
  String get vibrationSubtitle => 'Bildirimlerle birlikte titreşim';

  @override
  String get viewInvoicesOnPlayStore =>
      'Google Play Store\'dan faturalarınızı görüntüleyin';

  @override
  String get vision => 'Vizyon';

  @override
  String visionAutoDurationInfo(Object day) {
    return 'Bu vizyon şablondaki son günü kullanacak: $day.';
  }

  @override
  String get visionBoard => 'Vizyon Panosu';

  @override
  String get visionBoardDesc =>
      'Hedeflerinizi organize etmek ve yolculuğunuzu takip etmek için bir vizyon oluşturun';

  @override
  String get visionBoardViewTooltip => 'Pano görünümü';

  @override
  String get visionCreateTitle => 'Vizyon Oluştur';

  @override
  String get visionDurationDaysLabel => 'Süre (gün)';

  @override
  String get visionDurationNote =>
      'Not: Vizyon başladığında toplam bir süre belirlenir; bitiş günü bu süreyi aşarsa otomatik olarak kısaltılır.';

  @override
  String get visionEditTitle => 'Vizyonu Düzenle';

  @override
  String get visionEmptyDescription =>
      'Hedeflerinizi görselleştirin ve hayallerinizi gerçeğe dönüştürmek için ilk vizyonunuzu ekleyin.';

  @override
  String get visionEndDayInvalid => 'Bitiş günü 1 ile 365 arasında olmalıdır';

  @override
  String get visionEndDayLess => 'Bitiş günü başlangıç gününden küçük olamaz';

  @override
  String get visionEndDayQuestion => 'Vizyonun hangi gününde bitmeli?';

  @override
  String get visionEndDayRequired => 'Bitiş gününü girin';

  @override
  String get visionFreeformTooltip => 'Serbest pano';

  @override
  String get visionNoEndDurationInfo =>
      'Bitiş günü belirtilmedi. Vizyon ucu açık başlayacak.';

  @override
  String get visionPlural => 'Vizyonlar';

  @override
  String get visionSettingsTooltip => 'Serbest pano ayarları';

  @override
  String get visionStartDayInvalid =>
      'Başlangıç günü 1 ile 365 arasında olmalıdır';

  @override
  String get visionStartDayQuestion => 'Vizyonun hangi gününde başlamalı?';

  @override
  String get visionStartFailed => 'Vizyon başlatılamadı.';

  @override
  String get visionStartLabel => 'Vizyon başlangıcı: ';

  @override
  String visionStartedMessage(Object title) {
    return 'Vizyon başladı: $title';
  }

  @override
  String get visionTasks => 'Vizyon Görevleri';

  @override
  String get visual => 'Görsel';

  @override
  String get warmJournal => 'Sıcak Günlük';

  @override
  String get warmJournalDesc => 'Sıcak günlük ve duygu takibi';

  @override
  String get wednesdayShort => 'Çar';

  @override
  String get weekDaysShort => 'Pzt,Sal,Çar,Per,Cum,Cmt,Paz';

  @override
  String get weekdaysShortFri => 'Cum';

  @override
  String get weekdaysShortMon => 'Pzt';

  @override
  String get weekdaysShortSat => 'Cmt';

  @override
  String get weekdaysShortSun => 'Paz';

  @override
  String get weekdaysShortThu => 'Per';

  @override
  String get weekdaysShortTue => 'Sal';

  @override
  String get weekdaysShortWed => 'Çar';

  @override
  String get weekly => 'Haftalık';

  @override
  String get weeklyDesc => 'Haftanın belirli günlerinde';

  @override
  String get weeklyEmailSummary => 'Haftalık e-posta özeti';

  @override
  String get weeklyProgress => 'Haftalık ilerleme';

  @override
  String get weeklySummaryEmail => 'Haftalık özet e-postası';

  @override
  String get whatHappensIfCancel => 'İptal edersem ne olur?';

  @override
  String get whatsTheCause => 'Bu durumun sebebi nedir?';

  @override
  String get wheelOfFortuneDescription => 'Seçeneklerini yaz ve çarkı çevir';

  @override
  String get wheelOfFortuneTitle => 'Çark Çevirme';

  @override
  String get whichDaysActive => 'Hangi günler aktif olmalı?';

  @override
  String get whichWeekdays => 'Hangi hafta günleri?';

  @override
  String get worldTheme => 'Dünya';

  @override
  String get worldThemeDesc => 'Tüm renklerin uyumu';

  @override
  String get writeMessage => 'Bir mesaj yaz...';

  @override
  String xpProgressSummary(Object current, Object toNext, Object total) {
    return '$current / $total XP • Sonraki seviye için $toNext XP';
  }

  @override
  String get xpToNextLevel => 'sonraki seviyeye';

  @override
  String get yearly => 'Yıllık';

  @override
  String get yearlyProgress => 'Yıllık ilerleme';

  @override
  String get yesNoDescription => 'Basit evet/hayır takibi';

  @override
  String get yesNoExample => 'Bugün meditasyon yaptım mı?';

  @override
  String get yesNoType => 'Evet/Hayır';

  @override
  String get yesterday => 'Dün';

  @override
  String get yourCharacterType => 'Senin Karakter Tipin';

  @override
  String get yourEmail => 'E-posta adresiniz';

  @override
  String get yourEmailAddress => 'E-posta Adresiniz';

  @override
  String get yourMoodToday => 'Bugünkü Ruh Halin';

  @override
  String get dailyHabitInfo => 'Günlük';

  @override
  String get whichDays => 'Hangi günler';

  @override
  String get whichMonthDays => 'Ayın hangi günleri';

  @override
  String get whichYearDays => 'Yılın hangi günleri';

  @override
  String everyNDays(Object days) {
    return 'Her $days günde bir';
  }

  @override
  String nDays(Object days) {
    return '$days gün';
  }

  @override
  String everyNDaysInfo(Object days) {
    return 'Her $days günde bir gerçekleşir';
  }
}
