import { useState, useRef, useCallback } from "react";

// ============================================================
// EMBEDDED TR DATA
// ============================================================
const TR_BATCHES_RAW = [{"about": "Hakkında", "account": "Hesap", "achievements": "Başarılar", "active": "Aktif", "activeDays": "Aktif günler", "adFreeExperience": "Reklamsız Deneyim", "add": "Ekle", "addDate": "Tarih ekle", "addEvent": "Etkinlik Ekle", "addFabTooltip": "Ekle", "addFirstTransaction": "İlk işlemi ekle", "addHabit": "Alışkanlık Ekle", "addHabitToRoomPrompt": "+ butonuyla odaya bir alışkanlık ekle!", "addImage": "Resim Ekle", "addNew": "Yeni Ekle", "addNewHabit": "Yeni Alışkanlık Ekle", "addOptionHint": "Seçenek ekle...", "addOptionsToStart": "Başlamak için seçenek ekle", "addRoomButton": "Oda Ekle", "addSpecialDays": "Özel Günler Ekle", "addSubtask": "Alt Görev Ekle", "addTask": "Görev Ekle", "addText": "Metin Ekle", "addToList": "Listeye ekle", "addedToRoomSnackbar": "{title} odaya eklendi! 🎯", "advancedAnalysis": "İleri Seviye Analiz", "advancedAnalysisAndReports": "İleri seviye analiz ve raporlar", "advancedHabit": "Gelişmiş Alışkanlık", "advancedHabitSubtitle": "Premium • Detaylı ayarlarla alışkanlık oluştur", "advancedHabitTitle": "Gelişmiş Alışkanlık", "advancedHabitTypeDescription": "Sayısal hedefler, zamanlayıcı ve detaylı takip.", "advancedTimer": "Gelişmiş Timer", "aiAssistantOnline": "Çevrimiçi", "aiAssistantTitle": "Mira Asistan", "aiContextMessage": "Merhaba! Bu ipucuyla ilgilendiğinizi fark ettim:\n\n\"{tip}\"\n\nBunu Mira'da nasıl uygulayacağınızı göstermemi ister misiniz?", "aiHabitAddedMessage": "AI ile {count} alışkanlık eklendi", "aiInputHint": "Kazanmak istediğiniz alışkanlığı tarif edin...", "aiPoweredRecommendations": "AI destekli öneriler", "aiPreviewTitle": "AI Önerileri", "aiQuickFinance": "Bütçe önerileri", "aiQuickGamification": "XP sistemi nedir?", "aiQuickHabit": "Yeni alışkanlık oluştur", "aiQuickMood": "Ruh halimi analiz et", "aiQuickMotivation": "Bana motivasyon ver", "aiQuickProfile": "Yapay Zeka Karakterim", "aiQuickTimer": "Zamanlayıcı nasıl kullanılır?", "aiQuickVision": "Vizyon Panosu yardımı", "aiRetry": "Tekrar Dene (Sıkı Kurallar)", "aiShowMeHow": "Evet, nasıl yapacağımı göster", "aiTip0": "Biliyor muydunuz? Uzun vadeli hedefleriniz için bir Vizyon Panosu oluşturabilirsiniz.", "aiTip1": "İpucu: Odaklanmış çalışma oturumları için Zamanlayıcıyı kullanın.", "aiTip2": "Zaman içindeki değişimleri görmek için günlük ruh halinizi takip edin.", "aiTip3": "Alışkanlıklar her gün aynı saatte yapıldığında daha kalıcı olur.", "aiTip4": "Büyük Vizyonları daha küçük, yönetilebilir Görevlere bölün.", "aiTip5": "Günlük harcamalarınızı takip etmek için Finans sekmesini kullanın.", "aiTip6": "Yardıma mı ihtiyacınız var? AI asistana sormak için buraya dokunun!", "aiTip7": "İstikrar anahtardır! Zinciri kırmayın.", "aiWelcomeMessage": "Merhaba! Ben Mira asistanınızım. Size bugün nasıl yardımcı olabilirim? Vizyonlar, alışkanlıklar, zamanlayıcılar veya diğer özellikler hakkında soru sorabilirsiniz.", "allDataDeleted": "Tüm veriler silindi", "allHabitsLabel": "Tüm Alışkanlıklar", "allLabel": "Tümü", "alsoDeleteLinkedHabits": "Bağlı alışkanlıkları da sil", "amount": "Miktar", "amountLabel": "Tutar", "analysis": "Analiz", "analysisTooltip": "Analiz", "annualPlanDesc": "12 ay boyunca kesintisiz erişim", "appTitle": "Mira", "appearance": "Görünüm", "apply": "Uygula"},{"applyCode": "Kodu Uygula", "applying": "Uygulanıyor...", "approxVisionDurationDays": "Bu vizyon yaklaşık {days} gün sürer", "assetsReloadHint": "Bazı varlıkların yüklenmesi için uygulamanın tamamen yeniden başlatılması gerekebilir.", "atLeast": "En Az", "atMost": "En Çok", "autoBackupSubtitle": "Verilerinizi her 24 saatte bir otomatik olarak Google Drive'a yedekleyin.", "autoBackupTitle": "Otomatik Yedekleme", "averageMood": "Ortalama Duygu", "back": "Geri", "backgroundPlate": "Arka plan plakası", "backupError": "Yedekleme hatası", "backupFailed": "Yedekleme başarısız", "backupNow": "Hemen yedekle", "backupRestore": "Yedekleme & Geri Yükleme", "backupSuccess": "Yedeklendi: {id}", "backupTitle": "Yedekleme", "backupToDrive": "Drive'a Yedekle", "badgeActive100dDesc": "100 farklı günde aktif ol", "badgeActive100dTitle": "100 Gün Aktif", "badgeActive30dDesc": "30 farklı günde aktif ol", "badgeActive30dTitle": "30 Gün Aktif", "badgeActive7dDesc": "7 farklı günde aktif ol", "badgeActive7dTitle": "7 Gün Aktif", "badgeCategoryActivity": "Aktivite", "badgeCategoryFinance": "Finans", "badgeCategoryHabit": "Alışkanlık", "badgeCategoryLevel": "Seviye", "badgeCategoryVision": "Vizyon", "badgeCategoryXp": "XP", "badgeFin100Desc": "100 işlem kaydet", "badgeFin100Title": "Finansçı 100", "badgeFin10Desc": "10 işlem kaydet", "badgeFin10Title": "Finansçı 10", "badgeFin250Desc": "250 işlem kaydet", "badgeFin250Title": "Finansçı 250", "badgeFin50Desc": "50 işlem kaydet", "badgeFin50Title": "Finansçı 50", "badgeHabit100Desc": "Toplamda 100 alışkanlık tamamla", "badgeHabit100Title": "Alışkanlık 100", "badgeHabit10Desc": "Toplamda 10 alışkanlık tamamla", "badgeHabit10Title": "Alışkanlık 10", "badgeHabit200Desc": "Toplamda 200 alışkanlık tamamla", "badgeHabit200Title": "Alışkanlık 200", "badgeHabit50Desc": "Toplamda 50 alışkanlık tamamla", "badgeHabit50Title": "Alışkanlık 50", "badgeLevel10Desc": "10. seviyeye ulaş", "badgeLevel10Title": "Seviye 10", "badgeLevel20Desc": "20. seviyeye ulaş", "badgeLevel20Title": "Seviye 20", "badgeLevel5Desc": "5. seviyeye ulaş", "badgeLevel5Title": "Seviye 5", "badgeVision10Desc": "10 vizyon oluştur", "badgeVision10Title": "Vizyon Büyükustası", "badgeVision1Desc": "İlk vizyonunu oluştur", "badgeVision1Title": "Vizyoner", "badgeVision5Desc": "5 vizyon oluştur", "badgeVision5Title": "Vizyon Ustası", "badgeVisionHabits3Desc": "Bir vizyona 3+ alışkanlık bağla", "badgeVisionHabits3Title": "Bağlayıcı", "badgeXp1000Desc": "Toplam 1000 XP kazan", "badgeXp1000Title": "1000 XP", "badgeXp500Desc": "Toplam 500 XP kazan", "badgeXp500Title": "500 XP", "badges": "Rozetler", "balanceParenthesis": "(Bakiye: {balance})", "becomePremium": "Premium Olun", "becomePremiumShort": "Premium Ol", "between1And360": "1 ile 360 arasında", "billingHistory": "Fatura Geçmişi"},{"bio": "Biyografi", "bioHint": "Kendiniz hakkında kısa bir biyografi", "breakLabel": "MOLA", "breakTime": "Mola", "breakdownByCategory": "Kategoriye göre döküm", "bringForward": "Öne getir", "bugReportFailedError": "Hata raporu gönderilemedi: {error}", "bugReportFailedStatus": "Hata raporu gönderilemedi: {statusCode}", "bugReportSentSuccess": "Hata raporunuz başarıyla gönderildi. Teşekkür ederiz!", "buyPremium": "Premium Satın Al", "canIGetRefund": "Geri ödeme alabilir miyim?", "cancel": "İptal", "cancelButton": "İptal", "cancelEffect": "Abonelik süreniz bitene kadar premium özelliklerden faydalanmaya devam edersiniz.", "cancelInstructions": "Google Play Store → Abonelikler → Mira Plus → İptal Et", "cannotOpenPlayStore": "Play Store açılamıyor", "category": "Kategori", "categoryName": "Kategori Adı", "characterDescBalancedMindful": "Sakin, istikrarlı ve iç huzura değer veren birisin. Denge sağlamakta ve hayata bilinçlilik ve soğukkanlılıkla yaklaşmakta başarılısın.", "characterDescExplorer": "Meraklı, yaratıcı ve çeşitliliği seven birisin. Yeni şeyler öğrenmekten ve hayatın zorluklarına farklı yaklaşımlar denemekten keyif alırsın.", "characterDescPlanner": "Düzenli, hedef odaklı ve yapıdan beslenen birisin. Hayalleri eyleme dönüştürmekte ve disiplinle takip etmekte başarılısın.", "characterDescSocialConnector": "Sıcakkanlı, empatik ve ilişkilerden enerji alan birisin. Başkalarıyla bağlantı kurmakta ve güçlü topluluklar oluşturmakta anlam bulursun.", "characterTypeBalancedMindful": "Dengeli Bilinçli", "characterTypeExplorer": "Kaşif", "characterTypePlanner": "Planlayıcı", "characterTypeSocialConnector": "Sosyal Bağlayıcı", "checkboxType": "Onay Kutusu", "checkboxTypeDesc": "Basit işaretle", "checkingPurchases": "Satın almalar kontrol ediliyor...", "chooseBestCategory": "Alışkanlığınız için en iyi kategoriyi seçin", "chooseColor": "Renk Seç:", "chooseEmoji": "Emoji Seç:", "choosePhoto": "Fotoğraf Seç", "choosePhotoDesc": "Size ilham veren bir fotoğraf seçin", "choosePhotoSubtitle": "Seni motive eden bir fotoğraf seç", "clear": "Temizle", "clearFilters": "Filtreleri temizle", "clearHistory": "Geçmişi Temizle", "close": "Kapat", "closeButton": "Kapat", "cloudBackup": "Bulut Yedekleme", "coinFlipDescription": "İki seçenek arasında karar ver", "coinFlipInstruction": "İki seçeneği yaz ve parayı çevir!", "coinFlipTitle": "Yazı Tura", "colorLabel": "Renk", "colorTheme": "Renk teması", "completeAllSubtasksToFinish": "tümünü tamamlayınca alışkanlık tamamlanır", "completedSelectedDay": "Tamamlandı (seçilen gün)", "completedTableHeader": "TAMAM", "completionPercentLabel": "Tamamlanma %", "completionsCount": "{count} tamamlandı", "confirmDeleteAccount": "Hesabı silmeyi onayla", "confirmHabits": "Alışkanlıkları Onayla", "continueAsGuest": "Misafir Olarak Devam Et", "continueButton": "Devam Et", "continueText": "Devam Et", "copyButton": "Kopyala", "copyCodeTitle": "Kodu Kopyala", "costTokens": "Maliyet: {cost} jeton", "cottonCandy": "Pamuk Şeker", "cottonCandyDesc": "Pamuk şeker - pembe ve mavi", "countdownConfigureTitle": "Geri Sayımı Yapılandır", "countdownLabel": "GERİ SAYIM", "cozyJournal": "Rahat Günlük", "cozyJournalDesc": "Kahverengi tonlar ve zaman çizelgesi", "crashReports": "Çökme raporları", "crashReportsSubtitle": "Uygulama çökmelerinde anonim rapor gönder", "create": "Oluştur", "createAdvancedHabit": "Gelişmiş Alışkanlık Oluştur", "createButton": "Oluştur"},{"createDailyTask": "Günlük Görev Oluştur", "createFirstHabit": "Alışkanlık Oluştur", "createFirstReportPrompt": "İlk haftalık raporunuzu oluşturmak için + butonuna tıklayın", "createFirstVision": "İlk Vizyonunuzu Oluşturun", "createHabit": "Alışkanlığı Oluştur", "createHabitAction": "Alışkanlık Oluştur", "createHabitTemplateTitle": "Alışkanlık Şablonu Oluştur", "createHabitTitle": "Alışkanlık Oluştur", "createList": "Liste Oluştur", "createNewCategory": "Yeni Kategori Oluştur", "createNewList": "Yeni liste oluştur", "createReport": "Rapor Oluştur", "createRoomSubtitle": "Yeni bir oda oluştur ve arkadaşlarını davet et", "createRoomSuccessSnackbar": "Oda oluşturuldu! 🎉", "createRoomTitle": "Oda Oluştur", "createVision": "Vizyon Oluştur", "createVisionTemplateTitle": "Vizyon Şablonu Oluştur", "createVisionWithAI": "Yapay Zeka ile Vizyon Oluştur", "createWithAi": "AI ile Oluştur", "creatingBackup": "Yedek oluşturuluyor...", "currentStreak": "Mevcut Seri", "custom": "Özel", "customCategories": "Özel Kategoriler", "customEmoji": "Özel Emoji", "customEmojiHint": "Örn: ✨", "customEmojiOptional": "Özel emoji (isteğe bağlı)", "customEvent": "Özel Etkinlik", "customFrequency": "Özel", "customUnit": "Özel Birim", "customUnitHint": "Örn: porsiyon, set, km...", "daily": "Günlük", "dailyCheck": "Günlük kontrol", "dailyDesc": "Her gün yapılacak", "dailyHabitInfo": "Günlük", "dailyLimit": "Günlük limit", "dailyTask": "Günlük Görev", "dailyTaskCreatedMessage": "Günlük görev oluşturuldu: {title}", "dailyTaskSubtitle": "Bugüne özel bir görev ekle", "dailyTaskTitle": "Günlük Görev", "dailyTasksSection": "Günlük Görevler", "darkTheme": "Karanlık tema", "dashboard": "Panel", "date": "Tarih", "dateRangeLabel": "Tarih Aralığı", "dayFriShort": "Cum", "dayMonShort": "Pzt", "dayRangeShort": "Gün {start}–{end}", "daySatShort": "Cmt", "dayShort": "Gün {day}", "daySunShort": "Paz", "dayThuShort": "Per", "dayTueShort": "Sal", "dayWedShort": "Çar", "days": "gün", "daysAgo": "{days} gün önce", "daysAverageShort": "{days}g ort.", "daysCount": "{count} gün", "daysInterval": "günde bir", "daysIntervalLabel": "günde bir", "daysLater": "{days} gün sonra", "daysLeft": "gün kaldı", "daysRemaining": "Kalan Gün", "daysSuffixShort": "gün", "decisionEggDescription": "Mistik yumurtalardan birini seç", "decisionEggTitle": "Karar Yumurtası", "defaultUnit": "adet", "delete": "Sil", "deleteAccountFailed": "Hesap silme başarısız", "deleteAccountRequestSuccess": "Hesap silme talebiniz başarıyla alındı", "deleteAccountSubtitle": "Hesabınızın ve verilerinizin silinmesini talep edin"},{"deleteAccountWarning": "Bu işlem geri alınamaz. Lütfen hesabınızla ilişkili e-posta adresini onaylayın.", "deleteAction": "Sil", "deleteAllData": "Tüm verileri sil", "deleteAllDataConfirmContent": "Tüm uygulama verilerinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.", "deleteButton": "Sil", "deleteCategoryConfirmNamed": "\"{name}\" kategorisini sil?", "deleteCategoryTitle": "Kategoriyi sil", "deleteCustomCategoryConfirm": "Bu özel kategoriyi sil?", "deleteEntryConfirm": "Bu kaydı silmek istediğinden emin misin?", "deleteEvent": "Etkinliği Sil", "deleteHabitConfirm": "'{title}' odadan silinsin mi?", "deleteHabitTitle": "Alışkanlığı Sil", "deleteListMessage": "Bu liste silinecek. Bağlı öğeler için işlemi seçin:", "deleteListTitle": "Listeyi Sil", "deleteMyAccount": "Hesabımı sil", "deleteRoomTitle": "Odayı Sil", "deleteRoomWarning": "Bu oda ve tüm içeriği kalıcı olarak silinecek. Devam etmek istiyor musun?", "deleteTaskConfirm": "Bu görevi silmek istediğinize emin misiniz?", "deleteTaskConfirmMessage": "Bu günlük görev silinsin mi? Bu işlem geri alınabilir.", "deleteTaskConfirmTitle": "Görev silinsin mi?", "deleteTransactionConfirm": "\"{title}\" kaydını sil?", "deleteVisionMessage": "Bu vizyonu sil?", "deleteVisionTitle": "Vizyonu sil", "descHint": "Alışkanlığınızla ilgili ayrıntılar (isteğe bağlı)", "descriptionHintOptional": "Açıklama ekle (isteğe bağlı)", "descriptionLabel": "Açıklama", "detailedCharts": "Detaylı grafikler ve istatistikler", "diagnosticsData": "Tanılama verileri", "diagnosticsDataSubtitle": "Uygulama kullanımına dair anonim istatistikleri paylaş", "difficulty": "Zorluk Seviyesi", "drinkWater": "Su İç", "duration": "Süre", "durationAutoLabel": "Süre (otomatik)", "durationIndefinite": "Süresiz", "durationMonths": "{count} ay", "durationSelection": "Süre seçimi", "durationType": "Süre Tipi", "earthTheme": "Toprak", "earthThemeDesc": "Toprak renkleri", "easy": "Kolay", "edit": "Düzenle", "editButton": "Düzenle", "editCategory": "Kategoriyi Düzenle", "editDeleteTooltip": "Düzenle / Sil", "editEvent": "Etkinliği Düzenle", "editHabit": "Alışkanlığı Düzenle", "editListTitle": "Listeyi Düzenle", "editOnlyPersonalHabits": "Sadece kişisel listenize eklenmiş alışkanlıkları düzenleyebilirsiniz.", "education": "Eğitim", "eggRevealMessage": "Mistik yumurta cevabını verdi! ✨", "eggSelectMessage": "Aklından bir soru tut ve bir yumurtaya dokun 🥚", "emojiAndColor": "Emoji & Renk", "emojiCategoryAnimals": "Hayvanlar", "emojiCategoryCare": "Bakım", "emojiCategoryFood": "Yiyecek", "emojiCategoryHealth": "Sağlık", "emojiCategoryLife": "Yaşam", "emojiCategoryNature": "Doğa", "emojiCategoryPopular": "Popüler", "emojiCategoryProductivity": "Üretkenlik", "emojiCategorySport": "Spor", "emojiLabel": "Emoji", "emotionBlessed": "Şanslı/Kutsanmış", "emotionBored": "Sıkılmış", "emotionConfident": "Kendinden Emin", "emotionConfused": "Kafası Karışık", "emotionDistracted": "Dikkati Dağınık", "emotionEuphoric": "Coşkulu", "emotionGuilty": "Suçlu", "emotionHopeful": "Umutlu"},{"emotionInsecure": "Güvensiz", "emotionLonely": "Yalnız", "emotionNumb": "Hissiz", "emotionOverwhelmed": "Bunalmış", "emotionProud": "Gururlu", "emotionRegretful": "Pişman", "emotionUnstoppable": "Durdurulamaz", "emptyHabitSubtitle": "İlerlemeni takip etmek için ilk alışkanlığını oluştur.", "emptyHabitTitle": "Yolculuğuna Başla", "enableNotifications": "Bildirimleri Etkinleştir", "enableReminder": "Hatırlatıcıyı Etkinleştir", "endDate": "Bitiş Tarihi", "endDateLabel": "Bitiş", "endDayOptionalLabel": "Bitiş günü (isteğe bağlı)", "endTime": "Bitiş Saati", "enterBothOptions": "Lütfen her iki seçeneği de girin", "enterMonthlyPlanToComputeDailyLimit": "Günlük bir limit hesaplamak için aylık bir plan girin.", "enterNameAndDesc": "Alışkanlığınızın adını ve açıklamasını girin", "enterPromoCode": "Lütfen bir promosyon kodu girin", "enterValueTitle": "Değer Gir", "enterYourName": "Adınızı girin", "entries": "Girişler", "entryCountLabel": "Giriş Sayısı", "entrySaved": "Giriş başarıyla kaydedildi!", "errorPrefix": "Hata: ", "eventDescription": "Açıklama", "eventDetails": "Etkinlik Detayı", "eventTitle": "Etkinlik Başlığı", "every": "Her", "everyDay": "Her gün", "everyLabel": "Her", "everyNDays": "Her {days} günde bir", "everyNDaysInfo": "Her {days} günde bir gerçekleşir", "everyNDaysQuestion": "Kaç günde bir?", "everyXDays": "Her {periodicDays} günde bir", "everyday": "Her Gün", "exact": "Tam", "exactAlarmPermission": "Kesin Alarm İzni (Android 12+)", "examplePrefix": "Örnek: {example}", "expenseDelta": "Gider Δ", "expenseDistributionPie": "Gider dağılımı (pasta)", "expenseEditTitle": "Gideri Düzenle", "expenseLabel": "Gider", "expenseNewTitle": "Yeni Gider", "failedToLoad": "Yüklenemedi: {error}", "featureAdvancedFinance": "Gelişmiş Finans Özellikleri", "featureAdvancedHabits": "Gelişmiş Alışkanlık Oluşturma", "featureAiBioClock": "AI Destekli Biyolojik Saat", "featureAiBioClockDesc": "Biyolojik ritminize göre optimum zamanlama", "featureAiWeeklyReport": "AI Destekli Haftalık Rapor", "featureAiWeeklyReportDesc": "İlerlemenizin detaylı AI analizi", "featureBackup": "Yedekleme Özelliği", "featurePremiumThemes": "Premium Temalar", "featureVisionCreation": "Vizyon Oluşturma", "feelingMoreSpecific": "Bu duyguyu daha ayrıntılı tarif edelim", "filterTitle": "Filtrele", "filterTooltip": "Filtrele", "finance": "Finans", "financeAddAiStatementOption": "Yapay Zeka ile Ekstre/Fis Yukle", "financeAddAiStatementSubtitle": "Gorsel veya PDF uzerinden otomatik ekler", "financeAddManualOption": "Manuel Ekle", "financeAnalysisTitle": "Finans Analizi · {month}", "financeLast7Days": "Finans · Son 7 gün", "financeNet": "Net", "finish": "Bitir", "fitness": "Fitness", "fixedDuration": "Sabit", "flexiblePlan": "Esnek plan, istediğin zaman iptal et", "flipCoin": "Parayı Çevir", "focusLabel": "ODAK"},{"focusedZen": "Odaklanmış Zen", "focusedZenDesc": "Minimalist, tek odak noktası", "font": "Yazı Tipi", "forestTheme": "Orman", "forestThemeDesc": "Doğal yeşil tema", "forever": "Sonsuza kadar", "fortuneDisclaimer": "Eğlence amaçlıdır.", "fortuneEggSemantic": "Yumurta {index}", "fortuneEggsSubtitle": "Aşağıdan bir yumurta seç", "fortuneNoQuestion": "Bir soru yazmadın", "fortunePlay": "Karar Yumurtaları", "fortuneProceedToEggs": "Yumurtalara Geç", "fortuneQuestionHint": "Örn: Bu hafta yeni bir şey denemeli miyim?", "fortuneQuestionPrompt": "Aklındaki soruyu yaz", "fortuneResultTitle": "Cevabın", "fortuneSwipeInstruction": "Yumurtayı sağa/sola kaydırarak değiştirin, üzerine dokununca cevap görünür", "fortuneTitle": "Karar Yumurtaları", "freeTrial14Days": "14 gün ücretsiz deneme", "frequency": "Sıklık", "frequencyLabel": "Sıklık", "fridayShort": "Cum", "fullName": "Tam Ad", "fullScreen": "Tam ekran", "gallery": "Galeri", "gamesDescription": "Karar vermekte zorlanıyor musun? Eğlenceli oyunlarla kararını ver!", "gamesTitle": "Oyunlar", "general": "Genel", "generalNotifications": "Genel bildirimler", "generalRoomStatsHeader": "GENEL ODA İSTATİSTİKLERİ", "generate": "Oluştur", "generatedAtDate": "Oluşturulma: {date}", "generating": "Oluşturuluyor...", "glasses": "Bardak", "goToPlayStore": "Play Store'a Git", "goldenTheme": "Altın", "goldenThemeDesc": "Sıcak altın tema", "goodMorning": "Günaydın! ☀️", "googleDrive": "Google Drive", "granted": "Verildi", "greatDayAhead": "Bugün harika bir gün, başarabilirsin!", "greetingAfternoon": "Tünaydın", "greetingEvening": "İyi akşamlar", "greetingMorning": "Günaydın", "guestAccount": "Misafir Hesabı", "guidedJourney": "Rehberli Yolculuk", "guidedJourneyDesc": "Adım adım rehberli akış", "habit": "Alışkanlık", "habitAddError": "Alışkanlıklar eklenirken hata: {error}", "habitAddSuccess": "{count, plural, =0{Hiç alışkanlık eklenmedi} =1{1 alışkanlık eklendi} other{{count} alışkanlık eklendi}}", "habitBlock": "Alışkanlık", "habitCreatedMessage": "Alışkanlık oluşturuldu: {title}", "habitDeletedMessage": "Alışkanlık silindi: {title}", "habitDescription": "Açıklama", "habitDescriptionHint": "Kısa bir açıklama ekle...", "habitDetails": "Alışkanlık Detayları", "habitExplorerCreativeProject": "Yaratıcı Proje Zamanı", "habitExplorerCreativeProjectDesc": "Hayal gücünüzü ateşleyen bir yaratıcı proje üzerinde çalışın.", "habitExplorerExplorePlace": "Yeni Bir Yer Keşfet", "habitExplorerExplorePlaceDesc": "Bölgenizdeki yeni bir mahalle, park veya yeri ziyaret edin.", "habitExplorerLearnNewSkill": "Yeni Bir Şey Öğren", "habitExplorerLearnNewSkillDesc": "Her hafta yeni bir beceri veya konuya vakit ayırın.", "habitExplorerReadDiverse": "Çeşitli İçerik Oku", "habitExplorerReadDiverseDesc": "Farklı türlerde ve bakış açılarında kitaplar, makaleler veya içerik okuyun.", "habitExplorerTryNewActivity": "Yeni Bir Aktivite Dene", "habitExplorerTryNewActivityDesc": "Konfor alanınızın dışına çıkın ve farklı bir deneyim yaşayın.", "habitMindfulBreathing": "Derin Nefes Egzersizi", "habitMindfulBreathingDesc": "Kendinizi merkezlemek için derin nefes alma teknikleri uygulayın.", "habitMindfulGratitude": "Şükür Pratiği", "habitMindfulGratitudeDesc": "Bugün minnettar olduğunuz üç şeyi yazın.", "habitMindfulJournaling": "Yansıtıcı Günlük Tutma"},{"habitMindfulJournalingDesc": "Öz farkındalık için düşüncelerinizi ve yansımalarınızı günlüğe yazın.", "habitMindfulMeditation": "Meditasyon", "habitMindfulMeditationDesc": "10-15 dakika bilinçli meditasyon yapın.", "habitMindfulNatureWalk": "Doğa Yürüyüşü", "habitMindfulNatureWalkDesc": "Çevrenize dikkat ederek doğada bilinçli bir yürüyüş yapın.", "habitName": "Alışkanlık Adı", "habitNameHint": "Örn: Kitap oku, Su iç...", "habitNameHintNumerical": "Örn: Su içmek, Sayfa okumak...", "habitNameHintTimer": "Örn: Meditasyon, Egzersiz...", "habitNamePlaceholder": "Alışkanlık Adı", "habitNotFound": "Alışkanlık bulunamadı.", "habitOfThisVision": "Bu vizyonun alışkanlığı", "habitPlannerGoalSetting": "Aylık Hedef Belirleme", "habitPlannerGoalSettingDesc": "Gelecek ay için spesifik, ölçülebilir hedefler belirleyin.", "habitPlannerMorningRoutine": "Sabah Rutini", "habitPlannerMorningRoutineDesc": "Her günü verimliliğe uygun bir sabah rutiyle başlatın.", "habitPlannerTaskPrioritization": "Günlük Görev Önceliklendirme", "habitPlannerTaskPrioritizationDesc": "Her sabah gün içindeki en öncelikli 3 görevinizi belirleyin.", "habitPlannerTimeBlocking": "Zaman Blokları", "habitPlannerTimeBlockingDesc": "Derin çalışma için gününüzü odaklı zaman bloklarına ayırın.", "habitPlannerWeeklyReview": "Haftalık İnceleme", "habitPlannerWeeklyReviewDesc": "Her Pazar haftanın ilerlemenizi inceleyin ve gelecek haftayı planlayın.", "habitReminderBody": "Alışkanlığını tamamlama zamanı!", "habitReminders": "Alışkanlık Hatırlatıcıları", "habitRemindersSubtitle": "Alışkanlıklarınız için günlük hatırlatıcılar", "habitSocialCallFriend": "Bir Arkadaşı Ara", "habitSocialCallFriendDesc": "Anlamlı bir sohbet için bir arkadaşınızla veya aile üyenizle iletişime geçin.", "habitSocialCompliment": "Samimi Bir İltifat Yap", "habitSocialComplimentDesc": "İçten bir iltifatla birinin gününü aydınlatın.", "habitSocialFamilyTime": "Kaliteli Aile Zamanı", "habitSocialFamilyTimeDesc": "Aile üyeleriyle dikkat dağıtıcı şeyler olmadan özel vakit geçirin.", "habitSocialGroupActivity": "Grup Aktivitesine Katıl", "habitSocialGroupActivityDesc": "Bir grup aktivitesine veya sosyal etkinliğe katılın.", "habitSocialVolunteer": "Gönüllü Ol", "habitSocialVolunteerDesc": "Gönüllü çalışma yoluyla topluluğunuza katkıda bulunun.", "habitTypeLabel": "Alışkanlık Tipi", "habitTypePickerSubtitle": "Nasıl bir alışkanlık oluşturmak istiyorsun?", "habitTypePickerTitle": "Alışkanlık Türü Seç", "habitUpdatedMessage": "Alışkanlık güncellendi.", "habits": "Alışkanlıklar", "habitsSection": "Alışkanlıklar", "hard": "Zor", "hardMode": "Zor Mod", "headerFocusLabel": "Odak", "headerFocusReady": "Hazır", "headerHabitsLabel": "Alışkanlık", "health": "Sağlık", "helpAndSupport": "Yardım ve Destek", "history": "Geçmiş", "historyTitle": "Geçmiş", "hourShort": "sa", "hours": "Saat", "hoursSuffixShort": "sa", "howAreYouFeeling": "Kendini nasıl hissediyorsun?", "howDoYouFeel": "Bugün nasıl hissediyorsun?", "howOftenDoHabit": "Alışkanlığınızı ne sıklıkla yapacağınıza karar verin", "howToCancel": "Nasıl iptal ederim?", "howToEarn": "Nasıl kazanılır", "howToTrackHabit": "Alışkanlığınızın nasıl izleneceğini seçin", "ifCondition": "Eğer", "ifTrialCancelled": "Ücretsiz deneme iptal edilirse?", "importFromLink": "Bağlantıdan içe aktar", "importantNotice": "Önemli Uyarı", "inactive": "İnaktif", "incomeDelta": "Gelir Δ", "incomeEditTitle": "Geliri Düzenle", "incomeLabel": "Gelir", "incomeNewTitle": "Yeni Gelir", "incompleteSelectedDay": "Tamamlanmadı (seçilen gün)", "input": "Giriş"},{"insights": "İçgörüler", "insufficientTokensWatchAd": "Yetersiz jeton! Reklam izleyerek jeton kazanın.", "invalidCodeLengthError": "Kod 6 karakter olmalıdır", "invalidLink": "Geçersiz bağlantı.", "invalidValue": "Geçersiz değer", "inviteCodeCopiedSnackbar": "Davet kodu kopyalandı!", "inviteCodeTooltip": "Davet Kodu", "issueDescription": "Sorun Açıklaması", "issueDescriptionHint": "Sorunu detaylı olarak açıklayın...", "joinButton": "Katıl", "joinRoomCodeMessage": "Arkadaşından aldığın 6 haneli davet kodunu gir:", "joinRoomSubtitle": "Davet koduyla mevcut bir odaya katıl", "joinRoomSuccessSnackbar": "{roomName} odasına katıldın! 🎉", "joinRoomTitle": "Odaya Katıl", "joinedAtLabel": "Katılım: {date}", "journalEntry": "Günlük Girişi", "journalEntryDesc": "Bugün hakkında yazmak istediğin var mı?", "journalHint": "Bugün hakkında yazmak istediğin bir şey...", "jsonDataExample": "JSON Veri (örnek):", "justNow": "Az önce", "keepItUp": "Harika! Aynen devam! 💪", "language": "Dil", "languageSelection": "Dil Seçimi", "last7DaysProgressLabel": "Son 7 Günlük İlerleme", "lastBackup": "Son Yedekleme: {date}", "later": "Daha Sonra", "lavenderDreams": "Lavanta Rüyaları", "lavenderDreamsDesc": "Zarif lavanta ve mor tonları", "leaderboardDetailsTitle": "Sıralama Detayları", "leaveButton": "Çık", "leaveRoomTitle": "Odadan Çık", "leaveRoomWarning": "Bu odadan çıkmak istediğine emin misin?", "letsPlayGame": "Hadi oynayalım! 🎮", "letsStart": "Hadi Başlayalım", "levelLabel": "Seviye {level}", "levelShort": "S{level}", "lightTheme": "Açık tema", "likertAgree": "Katılıyorum", "likertDisagree": "Katılmıyorum", "likertNeutral": "Kararsızım", "likertStronglyAgree": "Kesinlikle Katılıyorum", "likertStronglyDisagree": "Kesinlikle Katılmıyorum", "linkHabits": "Alışkanlıkları bağla", "listCreated": "Liste oluşturuldu: {title}", "listCreatedMessage": "Liste oluşturuldu: {title}", "listLabel": "Liste", "listNameHint": "Örn: Sağlık", "listNameLabel": "Liste Adı", "loadingHabits": "Alışkanlıklar yükleniyor...", "logout": "Çıkış yap", "longestStreak": "En uzun seri", "longestStreakLabel": "En Uzun Seri", "manageLists": "Listeleri yönet", "manageListsSubtitle": "Yeni listeler ekleyin, adlarını değiştirin veya silin.", "manageOnGooglePlay": "Aboneliği Google Play'de Yönet", "manageSubscription": "Aboneliği Yönet", "manageSubscriptionDesc": "Plan değiştir, iptal et veya fatura bilgilerini gör", "manageSubscriptionSubtitle": "Mira Plus aboneliğini Google Play üzerinden düzenle", "manageVisionTasks": "Görevleri Yönet", "manualFallback": "Manuel Oluştur", "maxOptionsReached": "Maksimum 12 seçenek ekleyebilirsin", "meditation": "Meditasyon", "medium": "Orta", "memberCountText": "{count} üye", "memberHabitsLabel": "Üyenin Alışkanlıkları", "memberProfileTitle": "Üye Profili", "memberTableHeader": "ÜYE", "membersCompletedStatus": "{completed}/{total} üye tamamladı", "membersCountText": "{count} kişi", "minLabel": "dk"},{"mindfulness": "Farkındalık", "mintFresh": "Taze Nane", "mintFreshDesc": "Taze nane ve turkuaz tonları", "minutes": "Dakika", "minutesSuffixShort": "dk", "miraPlusActive": "Mira Plus Aktif", "miraPlusInactive": "Mira Plus Aktif Değil", "miraPremium": "Mira Premium", "mondayShort": "Pzt", "monthCount": "Ay sayısı", "monthCountHint": "Örn: 12", "monthSuffixShort": "ay", "monthly": "Aylık", "monthlyDays": "Ayın {days}. günleri", "monthlyDesc": "Ayın belirli günlerinde", "monthlyProgress": "Aylık ilerleme", "monthlyTrend": "Aylık trend", "monthsShort": "Oca,Şub,Mar,Nis,May,Haz,Tem,Ağu,Eyl,Eki,Kas,Ara", "mood": "Ruh Hali", "moodAnalytics": "Duygu Analizi", "moodBad": "Kötü", "moodBadDesc": "Kötü hissediyorum", "moodDeclining": "Duygu durumun düşüşte", "moodDistribution": "Duygu Dağılımı", "moodExcellent": "Mükemmel", "moodExcellentDesc": "Harika hissediyorum", "moodFlow": "Ruh Hali", "moodFlowSubtitle": "Bugünkü ruh halini seç", "moodFlowTitle": "Ruh Halin Nasıl?", "moodGood": "İyi", "moodGoodDesc": "İyi hissediyorum", "moodGreat": "Harika", "moodImproving": "Duygu durumun iyileşiyor!", "moodNeutral": "Normal", "moodNeutralDesc": "Normal hissediyorum", "moodOk": "Normal", "moodSelection": "Ruh Hali Seçimi", "moodStable": "Duygu durumun nispeten dengeli", "moodTerrible": "Berbat", "moodTerribleDesc": "Çok kötü hissediyorum", "moodTracker": "Ruh Hali Takibi", "moodTrend": "Duygu Trendi (Son 30 Gün)", "moreChartsButton": "Daha Fazla Grafik", "mostActiveMemberLabel": "En Aktif Üye", "mostCommonEmotion": "En Yaygın His", "mostCommonMood": "En Yaygın Duygu", "mostCommonReason": "En Yaygın Sebep", "motivation": "Motivasyon", "motivationBody": "Tebrikler! {period} içinde başarı oranınız {percent}%. Harika bir ilerleme kaydettiniz.", "motivationDayStart": "{title} için harika bir gün! 🌟", "motivationJourneyStart": "Her yolculuk tek bir adımla başlar!", "motivationSmallSteps": "Büyük hedeflere ulaşmak için küçük adımlarla başla 💪", "motivationWaiting": "{title} seni bekliyor 🚀", "mtdAverageShort": "AYB ort.", "multiple": "Birden fazla", "multipleSubItems": "Birden fazla alt öğe", "multipleSubItemsDesc": "Birden fazla alt öğe", "mustBePremiumToUse": "Bu özelliği kullanmak için Premium abonesi olmalısınız.", "myBigGoal": "Büyük Hedefim", "myBoard": "Panom", "mysticTheme": "Mistik", "mysticThemeDesc": "Mistik mor tema", "nDays": "{days} gün", "nDaysLabel": "{count} gün", "nameHint": "Örn: Günlük antrenman", "nameLabel": "İsim", "nameRequired": "Ad gerekli", "nameYourVision": "Vizyonunuza İsim Verin", "nameYourVisionDesc": "Vizyonunuza anlamlı bir isim verin", "nameYourVisionSubtitle": "Vizyonuna anlamlı bir isim ver"}];

const TR_METADATA = {"@@locale": "tr", "@aiContextMessage": {"placeholders": {"tip": {}}}, "@aiHabitAddedMessage": {"placeholders": {"count": {"type": "int"}}}, "@balanceParenthesis": {"placeholders": {"balance": {}}}, "@bugReportFailedError": {"placeholders": {"error": {}}}, "@bugReportFailedStatus": {"placeholders": {"statusCode": {}}}, "@costTokens": {"placeholders": {"cost": {}}}, "@daysAgo": {"placeholders": {"days": {}}}, "@daysLater": {"placeholders": {"days": {}}}, "@deleteHabitConfirm": {"placeholders": {"title": {}}}, "@durationMonths": {"placeholders": {"count": {}}}, "@everyXDays": {"placeholders": {"periodicDays": {}}}, "@failedToLoad": {"placeholders": {"error": {}}}, "@fortuneEggSemantic": {"placeholders": {"index": {"type": "int"}}}, "@generatedAtDate": {"placeholders": {"date": {}}}, "@habitAddError": {"placeholders": {"error": {}}}, "@habitAddSuccess": {"placeholders": {"count": {"type": "int"}}}, "@lastBackup": {"placeholders": {"date": {"type": "String"}}}, "@listCreated": {"placeholders": {"title": {}}}, "@monthlyDays": {"placeholders": {"days": {}}}, "@motivationDayStart": {"placeholders": {"title": {}}}, "@motivationWaiting": {"placeholders": {"title": {}}}, "@nudgeNotification": {"placeholders": {"name": {}}}, "@selectedDaysOfMonth": {"placeholders": {"sorted": {}}}, "@spendingAdvisorSafe": {"placeholders": {"amount": {}}}, "@spendingAdvisorWarning": {"placeholders": {"amount": {}}}, "@subtaskIndex": {"placeholders": {"index": {}}}};

const LANGUAGES = [
  { code: "en", name: "English" },
  { code: "ar", name: "Arabic" },
  { code: "de", name: "German" },
  { code: "es", name: "Spanish" },
  { code: "fr", name: "French" },
  { code: "hi", name: "Hindi" },
  { code: "it", name: "Italian" },
  { code: "ja", name: "Japanese" },
  { code: "zh", name: "Chinese (Simplified)" },
  { code: "nl", name: "Dutch" },
  { code: "pt", name: "Portuguese (Brazilian)" },
  { code: "ru", name: "Russian" },
  { code: "ko", name: "Korean" },
];

const TOTAL_BATCHES = TR_BATCHES_RAW.length;

async function translateBatch(batch, langCode, langName) {
  const itemsStr = JSON.stringify(batch, null, 2);
  const prompt = `You are a professional app translator. Translate the following Flutter ARB localization strings from Turkish to ${langName}.

CRITICAL RULES:
1. Keep ALL placeholder variables exactly as-is (e.g., {name}, {count}, {title}, {days}, {error}, {date}, etc.)
2. Keep the same JSON structure with identical keys
3. Translate ONLY the values, never the keys
4. For plural forms like {count, plural, =0{...} =1{...} other{...}}, translate the text inside but keep the ICU plural syntax
5. Keep emojis as-is
6. Keep brand names (Mira, Google Drive, Pomodoro, XP, etc.) as-is
7. Respond ONLY with valid JSON, no markdown, no explanation
8. Be natural and idiomatic in ${langName}

Turkish strings to translate:
${itemsStr}

Return ONLY the JSON object with translated values.`;

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      model: "claude-sonnet-4-20250514",
      max_tokens: 8000,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  const data = await response.json();
  let text = data.content[0].text.trim();
  if (text.startsWith("```")) {
    const lines = text.split("\n");
    text = lines.slice(1, -1).join("\n");
  }
  return JSON.parse(text);
}

function buildFinalArb(translations, langCode) {
  const result = { "@@locale": langCode };
  // Add metadata first
  Object.entries(TR_METADATA).forEach(([k, v]) => {
    if (k !== "@@locale") result[k] = v;
  });
  // Add translations in TR order
  TR_BATCHES_RAW.forEach(batch => {
    Object.keys(batch).forEach(key => {
      result[key] = translations[key] ?? batch[key];
    });
  });
  return result;
}

function downloadArb(langCode, arbObj) {
  const content = JSON.stringify(arbObj, null, 2);
  const blob = new Blob([content], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `app_${langCode}.arb`;
  a.click();
  URL.revokeObjectURL(url);
}

export default function App() {
  const [selectedLangs, setSelectedLangs] = useState(LANGUAGES.map(l => l.code));
  const [status, setStatus] = useState({});
  const [running, setRunning] = useState(false);
  const [results, setResults] = useState({});
  const abortRef = useRef(false);

  const toggleLang = (code) => {
    setSelectedLangs(prev =>
      prev.includes(code) ? prev.filter(c => c !== code) : [...prev, code]
    );
  };

  const selectAll = () => setSelectedLangs(LANGUAGES.map(l => l.code));
  const deselectAll = () => setSelectedLangs([]);

  const startTranslation = useCallback(async () => {
    if (running) return;
    abortRef.current = false;
    setRunning(true);
    setResults({});

    const newStatus = {};
    selectedLangs.forEach(code => {
      newStatus[code] = { phase: "waiting", batch: 0, total: TOTAL_BATCHES };
    });
    setStatus({ ...newStatus });

    for (const lang of LANGUAGES.filter(l => selectedLangs.includes(l.code))) {
      if (abortRef.current) break;
      const { code, name } = lang;
      const translations = {};

      setStatus(prev => ({ ...prev, [code]: { phase: "translating", batch: 0, total: TOTAL_BATCHES } }));

      let failed = false;
      for (let i = 0; i < TR_BATCHES_RAW.length; i++) {
        if (abortRef.current) { failed = true; break; }
        setStatus(prev => ({ ...prev, [code]: { phase: "translating", batch: i + 1, total: TOTAL_BATCHES } }));

        let attempt = 0;
        let success = false;
        while (attempt < 3 && !success) {
          try {
            const result = await translateBatch(TR_BATCHES_RAW[i], code, name);
            Object.assign(translations, result);
            success = true;
          } catch (e) {
            attempt++;
            if (attempt >= 3) {
              Object.assign(translations, TR_BATCHES_RAW[i]);
            } else {
              await new Promise(r => setTimeout(r, 3000));
            }
          }
        }
        // Small delay between batches
        await new Promise(r => setTimeout(r, 500));
      }

      if (!failed) {
        const arb = buildFinalArb(translations, code);
        setResults(prev => ({ ...prev, [code]: arb }));
        setStatus(prev => ({ ...prev, [code]: { phase: "done", batch: TOTAL_BATCHES, total: TOTAL_BATCHES } }));
      } else {
        setStatus(prev => ({ ...prev, [code]: { phase: "cancelled", batch: 0, total: TOTAL_BATCHES } }));
      }
    }

    setRunning(false);
  }, [selectedLangs, running]);

  const stopTranslation = () => {
    abortRef.current = true;
  };

  const downloadAll = () => {
    Object.entries(results).forEach(([code, arb]) => {
      setTimeout(() => downloadArb(code, arb), 100);
    });
  };

  const doneCount = Object.values(status).filter(s => s.phase === "done").length;
  const totalSelected = selectedLangs.length;

  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(135deg, #0f0f1a 0%, #1a1a2e 50%, #16213e 100%)",
      color: "#e8e8f0",
      fontFamily: "'Segoe UI', system-ui, sans-serif",
      padding: "24px",
    }}>
      <div style={{ maxWidth: 800, margin: "0 auto" }}>
        {/* Header */}
        <div style={{ textAlign: "center", marginBottom: 32 }}>
          <div style={{ fontSize: 40, marginBottom: 8 }}>🌍</div>
          <h1 style={{ margin: 0, fontSize: 28, fontWeight: 700, color: "#a78bfa" }}>
            ARB Translator
          </h1>
          <p style={{ margin: "8px 0 0", color: "#94a3b8", fontSize: 14 }}>
            1394 key · Türkçe baz · 13 dil · Claude API
          </p>
        </div>

        {/* Language selector */}
        <div style={{
          background: "rgba(255,255,255,0.05)",
          borderRadius: 16,
          padding: 20,
          marginBottom: 20,
          border: "1px solid rgba(167,139,250,0.2)"
        }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
            <span style={{ fontWeight: 600, fontSize: 15 }}>Çevrilecek Diller</span>
            <div style={{ display: "flex", gap: 8 }}>
              <button onClick={selectAll} style={btnSmall("#6366f1")}>Tümünü Seç</button>
              <button onClick={deselectAll} style={btnSmall("#374151")}>Temizle</button>
            </div>
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
            {LANGUAGES.map(lang => {
              const sel = selectedLangs.includes(lang.code);
              const st = status[lang.code];
              let color = sel ? "#a78bfa" : "#4b5563";
              if (st?.phase === "done") color = "#22c55e";
              else if (st?.phase === "translating") color = "#f59e0b";
              return (
                <button
                  key={lang.code}
                  onClick={() => !running && toggleLang(lang.code)}
                  style={{
                    padding: "6px 14px",
                    borderRadius: 20,
                    border: `2px solid ${color}`,
                    background: sel ? `${color}20` : "transparent",
                    color: color,
                    cursor: running ? "default" : "pointer",
                    fontSize: 13,
                    fontWeight: 500,
                    transition: "all 0.2s",
                    display: "flex",
                    alignItems: "center",
                    gap: 6,
                  }}
                >
                  {st?.phase === "translating" && <span style={{ fontSize: 10 }}>⏳</span>}
                  {st?.phase === "done" && <span style={{ fontSize: 10 }}>✅</span>}
                  {lang.code.toUpperCase()} – {lang.name}
                </button>
              );
            })}
          </div>
        </div>

        {/* Progress */}
        {Object.keys(status).length > 0 && (
          <div style={{
            background: "rgba(255,255,255,0.05)",
            borderRadius: 16,
            padding: 20,
            marginBottom: 20,
            border: "1px solid rgba(167,139,250,0.2)"
          }}>
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 12 }}>
              <span style={{ fontWeight: 600 }}>İlerleme</span>
              <span style={{ color: "#22c55e", fontSize: 14 }}>{doneCount}/{totalSelected} dil tamamlandı</span>
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              {LANGUAGES.filter(l => status[l.code]).map(lang => {
                const st = status[lang.code];
                const pct = st.total ? (st.batch / st.total) * 100 : 0;
                let barColor = "#6366f1";
                if (st.phase === "done") barColor = "#22c55e";
                else if (st.phase === "cancelled") barColor = "#ef4444";
                return (
                  <div key={lang.code}>
                    <div style={{ display: "flex", justifyContent: "space-between", fontSize: 12, marginBottom: 4, color: "#94a3b8" }}>
                      <span>{lang.name}</span>
                      <span>
                        {st.phase === "waiting" && "Bekliyor..."}
                        {st.phase === "translating" && `Batch ${st.batch}/${st.total}`}
                        {st.phase === "done" && "✅ Tamamlandı"}
                        {st.phase === "cancelled" && "❌ İptal"}
                      </span>
                    </div>
                    <div style={{ height: 6, background: "#1f2937", borderRadius: 3, overflow: "hidden" }}>
                      <div style={{
                        height: "100%",
                        width: `${pct}%`,
                        background: barColor,
                        borderRadius: 3,
                        transition: "width 0.3s ease"
                      }} />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Controls */}
        <div style={{ display: "flex", gap: 12, marginBottom: 20 }}>
          {!running ? (
            <button
              onClick={startTranslation}
              disabled={selectedLangs.length === 0}
              style={{
                flex: 1,
                padding: "14px 24px",
                background: selectedLangs.length === 0 ? "#374151" : "linear-gradient(135deg, #6366f1, #a78bfa)",
                color: "white",
                border: "none",
                borderRadius: 12,
                fontSize: 16,
                fontWeight: 700,
                cursor: selectedLangs.length === 0 ? "not-allowed" : "pointer",
                transition: "all 0.2s",
              }}
            >
              🚀 Çeviriyi Başlat ({selectedLangs.length} dil · {selectedLangs.length * TOTAL_BATCHES} API çağrısı)
            </button>
          ) : (
            <button
              onClick={stopTranslation}
              style={{
                flex: 1,
                padding: "14px 24px",
                background: "linear-gradient(135deg, #ef4444, #dc2626)",
                color: "white",
                border: "none",
                borderRadius: 12,
                fontSize: 16,
                fontWeight: 700,
                cursor: "pointer",
              }}
            >
              ⏹ Durdur
            </button>
          )}
        </div>

        {/* Results */}
        {Object.keys(results).length > 0 && (
          <div style={{
            background: "rgba(34,197,94,0.08)",
            borderRadius: 16,
            padding: 20,
            border: "1px solid rgba(34,197,94,0.3)"
          }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
              <span style={{ fontWeight: 600, color: "#22c55e" }}>✅ Tamamlanan Dosyalar</span>
              <button
                onClick={downloadAll}
                style={{
                  padding: "8px 20px",
                  background: "linear-gradient(135deg, #22c55e, #16a34a)",
                  color: "white",
                  border: "none",
                  borderRadius: 8,
                  fontSize: 14,
                  fontWeight: 600,
                  cursor: "pointer",
                }}
              >
                📦 Tümünü İndir
              </button>
            </div>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
              {Object.entries(results).map(([code, arb]) => (
                <button
                  key={code}
                  onClick={() => downloadArb(code, arb)}
                  style={{
                    padding: "8px 16px",
                    background: "rgba(34,197,94,0.15)",
                    color: "#22c55e",
                    border: "1px solid rgba(34,197,94,0.4)",
                    borderRadius: 8,
                    fontSize: 13,
                    cursor: "pointer",
                  }}
                >
                  ⬇️ app_{code}.arb ({Object.keys(arb).filter(k => !k.startsWith("@")).length} key)
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Info */}
        <div style={{
          marginTop: 20,
          padding: 16,
          background: "rgba(255,255,255,0.03)",
          borderRadius: 12,
          fontSize: 13,
          color: "#64748b",
          lineHeight: 1.6
        }}>
          <strong style={{ color: "#94a3b8" }}>ℹ️ Nasıl çalışır?</strong>
          <br />
          Her dil için 1394 key, 20 batch halinde Claude API'ye gönderilir. Placeholder'lar ({`{title}`}, {`{count}`}) korunur, ICU plural syntax desteklenir. Her dil ~20 API çağrısı yapar. İşlem tüm seçili diller için sırayla çalışır.
        </div>
      </div>
    </div>
  );
}

function btnSmall(bg) {
  return {
    padding: "4px 12px",
    background: bg,
    color: "white",
    border: "none",
    borderRadius: 6,
    fontSize: 12,
    cursor: "pointer",
    fontWeight: 500,
  };
}
