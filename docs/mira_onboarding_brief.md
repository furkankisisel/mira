# Mira — Adaptive Onboarding System — Code Agent Brief

## Görev
Mevcut statik onboarding sistemini, Groq tabanlı adaptif AI onboarding sistemiyle değiştir.
Kullanıcı her soruyu cevapladıkça bir sonraki soru ona özel üretilir.
Sorular bitince vizyon + kişilik kartı + alışkanlıklar tek seferde oluşturulur.
Alışkanlıklar vizyonun 3 sütunundan (pillar) türer — random öneri değil.

---

## Mimari Özet

### Kaç Groq Çağrısı Yapılır?
- Soru başına: 1 çağrı (5–8 soru arası, AI karar verir)
- Final: 1 çağrı
- Toplam: maksimum 9 çağrı

### Token Verimliliği
- Soru döngüsünde konuşma geçmişi TAŞINMAZ
- Her turda sadece `profile_draft` (sıkıştırılmış) + son cevap gider
- Final çağrıda dolu profil gider, büyük ama tek seferlik

### Model Seçimi
| Aşama | Model | Neden |
|-------|-------|-------|
| Soru döngüsü | `llama-3.1-8b-instant` | Hızlı, ucuz, kullanıcı bekliyor |
| Final çağrı | `llama-3.3-70b-versatile` | Kaliteli çıktı, 1 kez yapılıyor |

---

## Veri Yapıları

### ProfileDraft (soru döngüsü boyunca birikir)
```dart
class ProfileDraft {
  String? pain;         // şu an hayatında ne yanlış
  String? goal;         // kim olmak istiyor (ne yapmak değil)
  String? blocker;      // daha önce neden olmadı
  String? energyTime;   // ne zaman enerjili, günde kaç dakika
  String? identity;     // AI'ın sessizce çıkardığı kişilik tipi

  Map<String, dynamic> toJson() => {
    'pain': pain,
    'goal': goal,
    'blocker': blocker,
    'energy_time': energyTime,
    'identity': identity,
  };
}
```

### AdaptiveQuestion (Groq'tan dönen soru)
```dart
class AdaptiveQuestion {
  final String question;
  final String inputType;     // 'text' | 'chips' | 'slider'
  final List<String>? options; // chips ise
  final double? sliderMin;    // slider ise
  final double? sliderMax;
  final String? sliderUnit;
  final ProfileDraft profileUpdate; // AI'ın bu tura kadar bildiği profil
  final bool isFinal;         // true ise soru döngüsü bitti
}
```

### OnboardingResult (final çağrıdan döner)
```dart
class OnboardingResult {
  final Vision vision;
  final PersonalityCard personality;
  final List<HabitSuggestion> habits;
}

class Vision {
  final String title;
  final String description;
  final List<String> pillars; // 3 adet
}

class PersonalityCard {
  final String type;        // "Yorgun Mükemmeliyetçi" gibi
  final String description;
}

class HabitSuggestion {
  final String name;
  final String icon;        // emoji
  final String pillar;      // vizyonun hangi sütunundan geldiği
  final String type;        // 'binary' | 'numeric' | 'duration'
  final double? targetValue;
  final String? targetUnit;
  final String frequency;   // 'daily' | 'weekdays' | 'weekends' | 'weekly'
  final String visionReason; // neden bu vizyona uygun
}
```

---

## Servis Katmanı

### GroqOnboardingService
`lib/services/groq_onboarding_service.dart` dosyasını oluştur.

```dart
class GroqOnboardingService {

  // Soru döngüsü çağrısı — llama-3.1-8b-instant
  Future<AdaptiveQuestion> getNextQuestion({
    required ProfileDraft currentProfile,
    required String lastAnswer,
    required int questionIndex,
  });

  // Final çağrı — llama-3.3-70b-versatile
  Future<OnboardingResult> generateResult({
    required ProfileDraft finalProfile,
  });
}
```

#### getNextQuestion içinde Groq'a gidecek mesaj:
```
System: [PROMPT 1 — aşağıda]

User: 
Mevcut profil: {currentProfile.toJson()}
Soru numarası: {questionIndex}
Kullanıcının son cevabı: {lastAnswer}
```

#### generateResult içinde Groq'a gidecek mesaj:
```
System: [PROMPT 2 — aşağıda, {profile_json} yerine finalProfile.toJson() inject edilmiş]

User: Generate the plan.
```

---

## PROMPT 1 — Soru Döngüsü (llama-3.1-8b-instant)

```
You are Mira's onboarding assistant. Your job is to deeply understand the user through a natural, warm conversation — not a form.

LANGUAGE: Always respond in the same language the user writes in. If Turkish, respond in Turkish. If English, respond in English.

YOUR GOAL:
Build a compressed user profile by asking 5 to 8 adaptive questions. Each question must follow logically from the previous answer. Never ask generic questions.

PROFILE YOU ARE BUILDING:
- pain: what is currently wrong in their life
- goal: who they want to become (not what they want to do)
- blocker: what has stopped them before
- energy_time: when they have energy and how much daily time they have
- identity: personality type you infer silently (never ask directly)

RULES:
- Never ask "what is your goal?" directly
- Every question must feel like it was written specifically for this person
- Maximum 8 questions, minimum 5
- Only set is_final to true when you have enough for all 5 profile fields
- The first question is always about their current emotional state or morning feeling — make it poetic and human
- Options for chips must be 3 to 5 items, short and real-sounding, not corporate
- Slider questions must include a unit

RESPOND ONLY IN THIS JSON FORMAT — no extra text, no markdown:
{
  "question": "...",
  "input_type": "text | chips | slider",
  "options": ["...", "..."],
  "slider_min": 0,
  "slider_max": 0,
  "slider_unit": "...",
  "profile_update": {
    "pain": "...",
    "goal": "...",
    "blocker": "...",
    "energy_time": "...",
    "identity": "..."
  },
  "is_final": false
}

For fields you do not yet know, use null.
profile_update must reflect everything you know SO FAR, not just what you learned this turn.
```

---

## PROMPT 2 — Final Çağrı (llama-3.3-70b-versatile)

```
You are Mira's onboarding engine. Based on the user profile below, generate a complete personalized life plan.

USER PROFILE:
{profile_json}

YOUR OUTPUT HAS 3 PARTS:

PART 1 — VISION
Create a vision that feels personal and aspirational, not generic.
- title: 4 to 7 words, powerful, written to the user ("sen" in Turkish, "you" in English)
- description: 2 to 3 sentences, written directly to the user, referencing their specific pain and goal
- pillars: exactly 3 thematic pillars derived from the profile (examples: zihin/beden/rutin or focus/energy/connection)

PART 2 — PERSONALITY CARD
- type: a creative 2-word label for their personality (examples: "Yorgun Mükemmeliyetçi", "Sessiz Gelişimci", "Dağınık Hayalperest")
- description: 2 sentences max, honest but kind, references their blocker

PART 3 — HABITS
Generate 5 to 7 habits. Each habit MUST:
- belong to one of the 3 vision pillars
- directly address the user's pain, goal, or blocker
- be realistically sized for their available time and energy
- include a vision_reason that connects it explicitly to the vision title

Habit types:
- binary: done or not done
- numeric: has a target number with a unit
- duration: has a target in seconds

RESPOND ONLY IN THIS JSON FORMAT — no extra text, no markdown:
{
  "vision": {
    "title": "...",
    "description": "...",
    "pillars": ["...", "...", "..."]
  },
  "personality": {
    "type": "...",
    "description": "..."
  },
  "habits": [
    {
      "name": "...",
      "icon": "...",
      "pillar": "...",
      "type": "binary | numeric | duration",
      "target_value": 0,
      "target_unit": "...",
      "frequency": "daily | weekdays | weekends | weekly",
      "vision_reason": "..."
    }
  ]
}

icon must be a single relevant emoji.
target_value and target_unit are only required for numeric and duration types. For binary set them to null.
All text must be in the same language as the user profile.
```

---

## Controller

`lib/controllers/onboarding_controller.dart` dosyasını oluştur (Riverpod veya Provider — projede hangisi varsa).

```dart
class OnboardingController {
  final GroqOnboardingService _service;

  ProfileDraft _profileDraft = ProfileDraft();
  List<AdaptiveQuestion> _questionHistory = [];
  int _questionIndex = 0;

  // İlk soruyu getir (lastAnswer boş string)
  Future<AdaptiveQuestion> startOnboarding();

  // Kullanıcı cevap verdi, sonraki soruyu getir
  // Eğer dönen soru.isFinal == true ise generateResult() çağır
  Future<AdaptiveQuestion?> submitAnswer(String answer);

  // Tüm sorular bitti, final çağrısı yap
  Future<OnboardingResult> generateResult();
}
```

---

## Ekran Akışı

Mevcut onboarding ekranını aşağıdaki akışa göre güncelle:

```
OnboardingScreen
│
├── State: currentQuestion (AdaptiveQuestion)
├── State: isLoading (bool)
├── State: questionNumber (int)
│
├── inputType == 'text'   → TextField göster
├── inputType == 'chips'  → Wrap + ChoiceChip göster
├── inputType == 'slider' → Slider + birim etiketi göster
│
├── "Devam" butonuna basınca:
│     controller.submitAnswer(answer) çağır
│     isFinal == false → yeni soruyu göster (animasyonlu geçiş)
│     isFinal == true  → LoadingScreen'e geç (final çağrı yapılıyor)
│
└── OnboardingResult gelince → ResultScreen'e geç
      └── Vizyon başlığı + kişilik kartı + alışkanlık listesi göster
          Kullanıcı onaylarsa mevcut habit/vision sistemine kaydet
```

---

## Mevcut Sistemle Entegrasyon

OnboardingResult geldiğinde şunları yap:

1. `vision.title` ve `vision.description` → mevcut Vision/VisionBoard modeline kaydet
2. `habits` listesini döngüye al → her biri için mevcut `Habit` modeline dönüştür:
   - `type: 'binary'` → mevcut binary habit tipine map et
   - `type: 'numeric'` → hedef değerli habit tipine map et
   - `type: 'duration'` → süreli habit tipine map et
3. `pillar` alanını habit'in kategori/tag alanına yaz (UI'da vizyon bağlantısı göstermek için)
4. `personality.type` → kullanıcı profiline kaydet (ileride UI'da gösterilebilir)

---

## Önemli Notlar

- Groq API key'i mevcut Gemini key yönetimi ile aynı pattern'da sakla
- Her Groq response'u parse etmeden önce JSON validity kontrolü yap, hata varsa retry (max 2)
- `is_final: true` gelen soruda hâlâ bir soru metni olabilir — onu gösterme, direkt final'e geç
- Soru animasyonu: sağdan sola kayma (PageView veya AnimatedSwitcher)
- Loading ekranında "Vizyonun oluşturuluyor..." gibi Mira'ya özgü bir metin göster, spinner yeterli

---

## Dosya Listesi (Oluşturulacak / Güncellenecek)

| Dosya | İşlem |
|-------|--------|
| `lib/services/groq_onboarding_service.dart` | YENİ OLUŞTUR |
| `lib/models/adaptive_question.dart` | YENİ OLUŞTUR |
| `lib/models/onboarding_result.dart` | YENİ OLUŞTUR |
| `lib/controllers/onboarding_controller.dart` | YENİ OLUŞTUR |
| `lib/screens/onboarding/onboarding_screen.dart` | GÜNCELLE |
| `lib/screens/onboarding/onboarding_result_screen.dart` | YENİ OLUŞTUR |
