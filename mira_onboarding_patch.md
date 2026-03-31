# Mira Onboarding — Soru Döngüsü Düzeltme Patch'i

Bu dosya `mira_onboarding_brief.md`'ye ek olarak uygulanacak düzeltmeleri içerir.
Brief'teki ile çakışma varsa bu dosya önceliklidir.

---

## Problem
- Sorular bitmiyor, 8'i aşıyor
- AI alakasız konulara giriyor
- is_final kararı AI'a bırakıldığı için güvenilmiyor

## Çözüm: 3 Değişiklik

---

## Değişiklik 1 — ProfileDraft'a helper metodlar ekle

`lib/models/profile_draft.dart` dosyasına şu metodları ekle:

```dart
// Dolu olan alanların listesi
List<String> filledFields() {
  final filled = <String>[];
  if (pain != null) filled.add('pain');
  if (goal != null) filled.add('goal');
  if (blocker != null) filled.add('blocker');
  if (energyTime != null) filled.add('energy_time');
  return filled;
}

// Boş olan alanların listesi
List<String> emptyFields() {
  final empty = <String>[];
  if (pain == null) empty.add('pain');
  if (goal == null) empty.add('goal');
  if (blocker == null) empty.add('blocker');
  if (energyTime == null) empty.add('energy_time');
  return empty;
}

// Kritik 4 alan dolu mu?
bool isComplete() {
  return pain != null && goal != null && blocker != null && energyTime != null;
}
```

---

## Değişiklik 2 — Controller'da bitiş kararını AI'dan al, kodda doğrula

`lib/controllers/onboarding_controller.dart` içindeki `submitAnswer` metodunu şöyle yaz:

```dart
Future<AdaptiveQuestion?> submitAnswer(String answer) async {
  // Profili güncelle
  _profileDraft = _profileDraft.copyWith(
    /* dönen profileUpdate ile */
  );
  _questionIndex++;

  // Bitiş koşulları — AI'a güvenme, kendin kontrol et
  final shouldFinish =
      (_questionIndex >= 5 && _profileDraft.isComplete()) || // erken bitir
      (_questionIndex >= 7);                                  // zorla bitir

  if (shouldFinish) {
    await generateResult();
    return null; // null dönünce UI final ekranına geçer
  }

  // Devam et
  return await _service.getNextQuestion(
    currentProfile: _profileDraft,
    lastAnswer: answer,
    questionIndex: _questionIndex,
  );
}
```

---

## Değişiklik 3 — Groq'a giden User mesajını zenginleştir

`lib/services/groq_onboarding_service.dart` içinde `getNextQuestion` çağrısında
user mesajını şu formatta gönder:

```dart
final userMessage = '''
Soru numarası: $_questionIndex / 7
Dolu profil alanları: ${currentProfile.filledFields().join(', ')}
Boş profil alanları: ${currentProfile.emptyFields().join(', ')}
Mevcut profil: ${currentProfile.toJson()}
Kullanıcının son cevabı: $lastAnswer
''';
```

---

## Değişiklik 4 — PROMPT 1'i güncelle (RULES bölümü)

Brief'teki PROMPT 1'in tamamını sil, yerine bunu kullan:

```
You are Mira's onboarding assistant. Your job is to deeply understand the user through a natural, warm conversation — not a form.

LANGUAGE: Always respond in the same language the user writes in. If Turkish, respond in Turkish. If English, respond in English.

YOUR GOAL:
Build a compressed user profile by asking up to 7 adaptive questions. Each question must follow logically from the previous answer. Never ask generic questions.

PROFILE YOU ARE BUILDING:
- pain: what is currently wrong in their life (emotional, not situational)
- goal: who they want to become — their identity, not a task
- blocker: what has stopped them before when they tried to improve
- energy_time: when they have energy during the day and how many minutes they have for themselves

STRICT QUESTION RULES:
- You will be told which question number this is (out of 7) and which fields are already filled
- Questions 1–2: focus ONLY on pain and current emotional state. Make them poetic and human.
- Questions 3–4: focus ONLY on desired future identity and goals. Never ask "what is your goal?" directly.
- Questions 5–6: focus ONLY on blockers and available energy/time
- Question 7: ONLY ask if a critical field is still empty. Otherwise set is_final: true.
- NEVER revisit a topic that is already in the filled fields list
- NEVER ask about specific habits, routines, or behaviors — only feelings, identity, and desires
- If all 4 fields (pain, goal, blocker, energy_time) are filled, set is_final: true immediately regardless of question number
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
    "energy_time": "..."
  },
  "is_final": false
}

For fields you do not yet know, use null.
profile_update must reflect everything you know SO FAR across all turns, not just this turn.
identity field is removed — you infer it internally for the final output only.
```

---

## Özet: Ne Değişti

| # | Ne | Neden |
|---|----|-------|
| 1 | ProfileDraft'a `isComplete()`, `filledFields()`, `emptyFields()` eklendi | Controller'ın bitiş kararı için |
| 2 | Bitiş kararı controller'a alındı | AI'a güvenmek yerine kod kontrol ediyor |
| 3 | User mesajına index + dolu/boş alanlar eklendi | AI hangi konuya odaklanacağını biliyor |
| 4 | PROMPT 1 RULES bölümü sertleştirildi | Alan bazlı soru yönlendirmesi, tekrar yok |
