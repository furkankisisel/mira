/// A small, answer-dependent starter plan, available without an AI connection.
/// Answers are preferences, not a clinical assessment or a fixed personality.
class StarterPlan {
  static Map<String, dynamic> build(List<int> answers,
      {required String languageCode}) {
    if (answers.length != 12 || answers.any((a) => a < 0 || a > 4)) {
      throw ArgumentError('Twelve answers in the range 0–4 are required.');
    }
    final tr = languageCode == 'tr';
    String t(String turkish, String english) => tr ? turkish : english;
    double mean(List<int> indices) =>
        indices.map((i) => answers[i] + 1).reduce((a, b) => a + b) /
        indices.length;
    final likesStructure = mean([1, 6, 9]) >= 3.5;
    final wantsCalm = mean([4, 11]) < 3;
    final likesVariety = mean([0, 5, 10]) >= 3.5;
    final likesCompany = mean([2, 7]) >= 3.5;

    Map<String, dynamic> habit(String title, String description, String reason,
            {int minutes = 2,
            List<String>? days,
            String category = 'Productivity',
            String emoji = '🌱'}) =>
        {
          'title': title,
          'description': description,
          'rationale': reason,
          'type': 'timer',
          'duration_minutes': minutes,
          'target_value': minutes,
          'frequency': 'daily',
          'days': ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'],
          'category': category,
          'emoji': emoji,
          'color_code': '#71836A',
          'is_task': false,
        };

    final planning = likesStructure
        ? habit(
            t('Haftana küçük bir plan', 'Make a small weekly plan'),
            t('Akşam yemeğinden sonra 3 dakika ayır. Günün ve haftanın önceliğini ve ona atacağın ilk adımı takvimine yaz. Yoğun bir günde yalnızca önceliği yazman yeterli.',
                'After dinner, spend 3 minutes writing your priority and its first step in your calendar. On a busy day, just write the priority.'),
            t('Düzen ve planlamayla ilgili yanıtların yapılandırılmış bir yaklaşımı tercih edebileceğini gösteriyor. Tek öncelik, planı uygulanabilir tutmana yardımcı olabilir.',
                'Your planning answers suggest you may enjoy structure. One priority can help keep the plan manageable.'),
            minutes: 3,
            emoji: '🗓️')
        : habit(
            t('Yarın için tek küçük adım', 'One small step for tomorrow'),
            t('Akşam telefonunu şarja taktıktan sonra 2 dakika ayır. Yarın başlayabileceğin tek küçük işi yaz ve gereken malzemeyi hazırla. Zor bir günde sadece işin adını yaz.',
                'After plugging in your phone in the evening, take 2 minutes to write one small action for tomorrow and prepare what you need. On a hard day, just name the action.'),
            t('Düzen ve hedef sorularındaki yanıtların için esnek, kısa bir başlangıç seçtik. Uzun bir liste yerine tek adım, başlama yükünü azaltabilir.',
                'We chose a flexible starting point for your routine and goal answers. A single action may feel easier to begin than a long list.'),
            emoji: '📝');

    final balance = wantsCalm
        ? habit(
            t('Kendine iki dakika', 'A two-minute check-in'),
            t('Gün sonunda oturduğunda 2 dakika ayır. Mira’ya nasıl hissettiğini ve bugün seni etkileyen bir olayı yaz. Çözüm bulmak zorunda değilsin; yoğun bir günde tek kelime yeter.',
                'When you sit down at the end of the day, take 2 minutes to record your mood and one thing that affected it in Mira. No need to solve anything; one word is enough on a busy day.'),
            t('Stres altında sakin kalma ifadelerine daha az katıldığın için kısa bir duraklama öneriyoruz. Kayıtlarını gözden geçirmek sana iyi gelen koşulları fark etmene yardımcı olabilir.',
                'You agreed less with staying calm under pressure, so we suggest a brief pause. Looking back at your notes may help you notice conditions that support you.'),
            category: 'Mindfulness',
            emoji: '🍃')
        : habit(
            t('Üç dakikalık odak başlangıcı', 'A three-minute focus start'),
            t('Günün ilk işine başlamadan önce bildirimleri sessize al. 3 dakika boyunca seçtiğin tek işin en küçük parçasıyla ilgilen. Devam etmek isteğe bağlı; zor bir günde malzemeyi açmak yeter.',
                'Before your first task, silence notifications and spend 3 minutes on its smallest part. Continuing is optional; on a hard day, simply open what you need.'),
            t('Sakin kalma yanıtlarınla birlikte düşük yükte bir odak denemesi seçtik. Kısa bir başlangıç, sürdürebileceğin süreyi kendin gözlemlemene alan bırakır.',
                'Alongside your calmness answers, we chose a low-pressure focus experiment. A short start leaves room to discover what duration works for you.'),
            minutes: 3,
            emoji: '⏳');

    final growth = likesCompany
        ? habit(
            t('Bir kişiye içten bir mesaj', 'Send one thoughtful message'),
            t('Öğle molandan sonra 2 dakika ayır. Görüşmek istediğin birine nasıl olduğunu soran kısa bir mesaj yaz. Yanıt alma zorunluluğu yok; çok yoğunsan mesaj taslağı yeter.',
                'After your lunch break, take 2 minutes to check in with someone you would like to connect with. A reply is not required; a draft is enough on a busy day.'),
            t('Sosyal ortam ve grup etkinliği yanıtların birlikte vakit geçirmekten hoşlanabileceğini gösteriyor. Bu küçük adım, bağ kurmaya düzenli bir yer açar.',
                'Your social and group activity answers suggest you may enjoy company. This small step makes regular room for connection.'),
            category: 'Social',
            emoji: '💬')
        : likesVariety
            ? habit(
                t('Merakına beş dakika', 'Five minutes of curiosity'),
                t('Bir molanın ardından 5 dakika ayır. Merak ettiğin konuda bir sayfa oku veya küçük bir çizim dene. Günün sonunda aklında kalan bir şeyi not et. Zor günlerde tek cümle oku.',
                    'After a break, spend 5 minutes reading a page or trying a small sketch about something that interests you. Note one thing you remember at the end of the day. On a hard day, read one sentence.'),
                t('Yeni deneyim, yaratıcılık ve farklı yöntem sorularındaki yanıtların keşfe açık olduğunu düşündürüyor. Konuyu sen seçerken süreyi küçük tutuyoruz.',
                    'Your novelty, creativity and variety answers suggest you may enjoy exploration. You choose the topic while keeping the commitment small.'),
                minutes: 5,
                category: 'Study',
                emoji: '📖')
            : habit(
                t('Sana iyi geleni tekrar et', 'Repeat something you enjoy'),
                t('Akşam yemeğinden sonra 2 dakika boyunca sevdiğin tanıdık bir etkinliği yap: bir sayfa okumak, çizmek veya müzik dinlemek gibi. Bir hafta aynı etkinliği dene; yoğun günlerde 30 saniye yeter.',
                    'After dinner, spend 2 minutes on something familiar you enjoy, such as reading a page, sketching or listening to music. Try the same activity for a week; 30 seconds is enough on busy days.'),
                t('Yanıtlarında yenilik arayışı belirgin olmadığı için tanıdık bir etkinlik öneriyoruz. Sana uygun gelmezse değiştirebilirsin; bu bir başlangıç denemesi.',
                    'Because novelty-seeking was not prominent in your answers, we suggest a familiar activity. Change it if it does not fit; this is a starting experiment.'),
                category: 'Personal',
                emoji: '🎵');

    return {
      'vision': {
        'title':
            t('Sana uygun küçük başlangıçlar', 'Small beginnings that fit you'),
        'description': t(
            'Yanıtlarına göre ${likesStructure ? 'kısa bir haftalık plan' : 'esnek ve küçük adımlar'} ile ${likesCompany ? 'bağ kurmaya' : likesVariety ? 'merakına' : 'tanıdık etkinliklere'} yer ayıran bir başlangıç hazırladık. Bu kısa test kesin bir kişilik tanımı yapmaz; sana uyan önerileri deneyerek seçebilirsin.',
            'Based on your answers, we prepared a start with ${likesStructure ? 'a short weekly plan' : 'small, flexible steps'} and room for ${likesCompany ? 'connection' : likesVariety ? 'curiosity' : 'familiar activities'}. This short quiz does not define your personality; try the suggestions and choose what fits.'),
        'emoji': '🌱',
        'color_code': '#71836A',
        'motivation_sentence': t(
            'İlk hafta bir alışkanlık seç. Amaç kusursuz bir seri değil, sana uyan bir başlangıç bulmak.',
            'Choose one habit for the first week. Aim to find a start that fits, rather than a perfect streak.'),
        'time_horizon': t('İlk 7 gün', 'Your first 7 days'),
        'tasks': [
          t('Bugün: Bir öneri seç ve ne zaman yapacağını belirle. Hatırlatıcıyı kendi günlük düzenine göre ayarla.',
              'Today: Choose one suggestion and decide when to do it. Set a reminder around your own daily routine.'),
          t('Zor bir günde: Açıklamadaki küçük sürümü uygula. Bir günü kaçırırsan telafi yükü eklemeden bir sonraki fırsatta devam et.',
              'On a hard day: Use the smaller version in the description. If you miss a day, return at the next opportunity without adding catch-up work.'),
          t('7 gün sonra: Sana iyi geldi mi, zamanına uydu mu? Kolaylaştıysa süreyi biraz artır; zor geldiyse küçült veya başka bir öneri dene.',
              'After 7 days: Did it help and fit your time? If it felt easy, increase it slightly; if it felt difficult, reduce it or try another suggestion.'),
        ],
        'habits': [
          if (wantsCalm) balance,
          planning,
          if (!wantsCalm) balance,
          growth
        ],
      }
    };
  }

  /// Reject empty, incomplete or overly demanding model plans before display.
  static bool isUsable(Map<String, dynamic> json) {
    final vision = json['vision'];
    if (vision is! Map) return false;
    bool text(dynamic value) => value is String && value.trim().isNotEmpty;
    if (!text(vision['title']) ||
        !text(vision['description']) ||
        !text(vision['motivation_sentence'])) return false;
    final tasks = vision['tasks'];
    if (tasks is! List || tasks.length < 2 || !tasks.every(text)) return false;
    final habits = vision['habits'];
    if (habits is! List || habits.length < 3 || habits.length > 5) return false;
    final titles = <String>{};
    for (final h in habits) {
      if (h is! Map ||
          !text(h['title']) ||
          !text(h['description']) ||
          !text(h['rationale'])) return false;
      if (!titles.add((h['title'] as String).trim().toLowerCase()))
        return false;
      if (!['simple', 'timer'].contains(h['type']) ||
          !['daily', 'weekly'].contains(h['frequency'])) return false;
      final days = h['days'];
      if (days is! List ||
          days.isEmpty ||
          !days.every((d) =>
              ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].contains(d)))
        return false;
      if (h['frequency'] == 'daily' && days.toSet().length != 7) return false;
      if (h['type'] == 'timer') {
        final minutes = h['duration_minutes'];
        if (minutes is! int || minutes < 1 || minutes > 10) return false;
      }
      if (h['is_task'] == true) return false;
    }
    return true;
  }
}
