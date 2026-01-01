import 'dart:math';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/config/api_config.dart';
import '../../habit/data/server_ai_habit_service.dart';

/// Decision Egg game - pick a mystical egg to get an AI-generated answer
class DecisionEggScreen extends StatefulWidget {
  const DecisionEggScreen({super.key});

  @override
  State<DecisionEggScreen> createState() => _DecisionEggScreenState();
}

class _DecisionEggScreenState extends State<DecisionEggScreen>
    with TickerProviderStateMixin {
  int? _selectedEgg;
  bool _isRevealing = false;
  bool _showAnswer = false;
  String _answer = '';
  late AnimationController _shakeController;
  late AnimationController _crackController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _crackAnimation;

  final List<_EggData> _eggs = [
    _EggData(Colors.purple.shade300, Colors.deepPurple.shade600, '✨'),
    _EggData(Colors.pink.shade300, Colors.pink.shade600, '💫'),
    _EggData(Colors.teal.shade300, Colors.teal.shade600, '🌟'),
    _EggData(Colors.amber.shade300, Colors.orange.shade600, '⭐'),
    _EggData(Colors.blue.shade300, Colors.indigo.shade600, '🔮'),
    _EggData(Colors.green.shade300, Colors.green.shade700, '🍀'),
  ];

  /// 100+ mystical answers for decision eggs
  final List<String> _localAnswers = [
    // Positive answers (35)
    'Evet, kesinlikle yapmalısın! 🌟',
    'Kesinlikle evet! Şans seninle! 🍀',
    'Evren sana evet diyor! ✨',
    'Bugün şanslı günün! 🎉',
    'Cesur ol, atıl! 💪',
    'Risk al, değecek! 🚀',
    'Yıldızlar senden yana! ⭐',
    'Bu senin zamanın! ⏰',
    'Hiç düşünme, yap! 🎯',
    'Şans kapını çalıyor! 🚪',
    'Rüzgar arkandan esiyor! 🌬️',
    'Evren onaylıyor! ✅',
    'Kaderin bu yönde! 🧭',
    'Işık seni oraya çağırıyor! 💡',
    'Yol açık, ilerle! 🛤️',
    'Evet, şimdi tam zamanı! ⏳',
    'Kalbini dinle, o evet diyor! 💖',
    'Yapabilirsin, inan! 🌈',
    'Bu fırsat bir daha gelmez! 🎁',
    'Ay senden yana! 🌙',
    'Güneş sana gülümsüyor! ☀️',
    'Yüzde yüz evet! 💯',
    'Her şey yolunda gidecek! 🙌',
    'Korkmadan atla! 🦅',
    'Başarı seni bekliyor! 🏆',
    'Pozitif enerji alıyorum! ⚡',
    'Harekete geç! 🏃',
    'Evet, ve muhteşem olacak! 🌟',
    'Kanatlarını aç, uç! 🦋',
    'Hayalini gerçekleştir! 💭',
    'Mükemmel zamanlama! 🎯',
    'Gitmelisin! 🚀',
    'Kesinlikle haklısın! ✨',
    'Yap, pişman olmayacaksın! 😊',
    'Olumlu sinyal alıyorum! 📡',

    // Negative answers (30)
    'Hayır, şimdi zamanı değil. ⏳',
    'Bekle, henüz erken. 🌅',
    'Bu sefer değil. 🚫',
    'Hayır deme, ama temkinli ol. ⚠️',
    'Başka bir yol dene. 🔄',
    'Bu kapı kapalı. 🚪',
    'Sabret, bu değil. 🍃',
    'Hayır, daha iyisi gelecek. 🌸',
    'Şu an için vazgeç. ❌',
    'Riskli görünüyor. ⚡',
    'Bulutlar karanlık. ☁️',
    'Şimdilik dur. 🛑',
    'Geri adım at. 👣',
    'Başka zamana. 📅',
    'Hayır, bekle. ⏰',
    'Dikkatli ol! ⚠️',
    'Bugün değil. 📆',
    'Yıldızlar bu yönde değil. ⭐',
    'Biraz daha beklemeli. 🌙',
    'Şartlar uygun değil. 🌧️',
    'Temkinli yaklaş. 🐢',
    'Bu yol senin için değil. 🛤️',
    'Farklı düşün. 🧠',
    'Alternatifler var. 🔀',
    'Dur ve düşün. 💭',
    'Şimdi sırası değil. ⌛',
    'Ertelemek akıllıca. 🦉',
    'Yavaşla. 🐌',
    'Bu kapıyı zorlamak yok. 🔒',
    'Başka şeylere odaklan. 🎯',

    // Maybe/Neutral answers (35)
    'Belki biraz daha bekle... 🤔',
    'Kalbinin sesini dinle! 💖',
    'İçgüdülerine güven! 🦋',
    'Cevap senin içinde. 🔍',
    'Biraz daha düşün. 💭',
    'Hem evet hem hayır... 🎭',
    'Belirsiz sinyaller... 🌫️',
    'Zamana bırak. ⏳',
    'Belki ama dikkatli ol. 👀',
    'Yarısı evet, yarısı hayır. ⚖️',
    'Sorunu tekrar sor. 🔄',
    'Cevap değişebilir. 🌀',
    'Şu an net değil. 🌫️',
    'İki yol da mümkün. 🛤️',
    'Belki yarın daha net olur. 🌅',
    'Rüyalarında cevabı bul. 🌙',
    'Kalbin ne diyor? 💓',
    'Sezgilerine kulak ver. 👂',
    'Mantığını da dinle. 🧠',
    'Bekleyip görmek lazım. 👁️',
    'Olabilir, ama garantisi yok. 🎲',
    'Şansın var ama risk de var. 🎰',
    'İkisi de mümkün. 🔮',
    'Sadece sen karar verebilirsin. 🪞',
    'Cevap sende gizli. 🗝️',
    'Belki de ikisi birden! 🌈',
    'Ara yol bul. 🛤️',
    'Düşün, hisset, sonra karar ver. 🧘',
    'Zaman her şeyi gösterecek. ⌚',
    'Bazen beklemek en iyisi. 🌸',
    'Kısmet ne derse... 🌌',
    'İşaretleri takip et. 🧭',
    'Evren cevabı gizliyor. 🌌',
    'Bir süre daha bekle. 🕐',
    'Ortası olabilir. 🎯',

    // Mystical/Fun answers (20)
    'Ay dolunay olunca evet! 🌕',
    'Bir dilek tut, gerçekleşecek! 🌠',
    'Üç kere sorsanız evet! 3️⃣',
    'Sihir bu gece seninle! ✨',
    'Gizemli güçler senden yana! 🔮',
    'Kristal küre parlıyor! 💎',
    'Yedi gün sonra cevabın var! 7️⃣',
    'Rüyanda göreceksin! 🌜',
    'Bir işaret bekle! 🎪',
    'Mucize yakında! ⭐',
    'Yumurtadan evet çıktı! 🥚',
    'Kaderin yazılmış! 📜',
    'Büyü yapıldı! 🪄',
    'Gizemli bir evet! 🎩',
    'Sihirli cevap: EVET! ✨',
    'Yıldız tozu seni kutsuyor! 🌟',
    'Ay ışığı yolunu aydınlatacak! 🌙',
    'Kozmik onay alındı! 🚀',
    'Periler evet diyor! 🧚',
    'Ejderha sana güç veriyor! 🐉',
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _crackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _crackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _crackController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _crackController.dispose();
    super.dispose();
  }

  Future<void> _selectEgg(int index) async {
    if (_isRevealing || _selectedEgg != null) return;

    setState(() {
      _selectedEgg = index;
      _isRevealing = true;
    });

    // Shake animation
    await _shakeController.forward();
    _shakeController.reset();

    // Get answer
    _answer = await _getAnswer();

    // Crack animation
    await _crackController.forward();

    setState(() {
      _showAnswer = true;
      _isRevealing = false;
    });
  }

  Future<String> _getAnswer() async {
    // Try AI first
    try {
      final apiKey = ApiConfig.groqApiKey;
      if (apiKey.isNotEmpty) {
        final service = ServerAiHabitService(apiKey: apiKey);
        final response = await service.sendSupportMessage([
          {
            'role': 'user',
            'content':
                'Sen mistik bir kahin yumurtasısın. Kullanıcı aklından bir soru tuttu ve senden cevap bekliyor. '
                'Kısa, gizemli ve eğlenceli bir cevap ver. Maksimum 1-2 cümle. Emoji kullan. '
                'Cevap evet/hayır/belki gibi bir yönlendirme içermeli ama yaratıcı olmalı.',
          },
        ], languageCode: Localizations.localeOf(context).languageCode);
        final message = response['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {}

    // Fallback to local answers
    final random = Random();
    return _localAnswers[random.nextInt(_localAnswers.length)];
  }

  void _reset() {
    setState(() {
      _selectedEgg = null;
      _showAnswer = false;
      _answer = '';
    });
    _crackController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.decisionEggTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _showAnswer ? l10n.eggRevealMessage : l10n.eggSelectMessage,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: _showAnswer
                  ? _buildAnswerView(theme, colorScheme, l10n)
                  : _buildEggGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEggGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75, // Taller for egg shape
      ),
      itemCount: _eggs.length,
      itemBuilder: (context, index) {
        final egg = _eggs[index];
        final isSelected = _selectedEgg == index;

        return AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            double shake = 0;
            if (isSelected && _shakeController.isAnimating) {
              shake = sin(_shakeAnimation.value * pi * 8) * 8;
            }

            return Transform.translate(offset: Offset(shake, 0), child: child);
          },
          child: GestureDetector(
            onTap: () => _selectEgg(index),
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: CustomPaint(
                painter: _EggShapePainter(
                  color1: egg.color1,
                  color2: egg.color2,
                  isSelected: isSelected,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      egg.sparkle,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerView(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final egg = _eggs[_selectedEgg ?? 0];

    return AnimatedBuilder(
      animation: _crackAnimation,
      builder: (context, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cracked egg animation
                Transform.scale(
                  scale: 0.8 + (_crackAnimation.value * 0.4),
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: CustomPaint(
                      painter: _EggShapePainter(
                        color1: egg.color1,
                        color2: egg.color2,
                        isSelected: true,
                        showCracks: _crackAnimation.value > 0.3,
                        crackProgress: _crackAnimation.value,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            egg.sparkle,
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Answer card
                AnimatedOpacity(
                  opacity: _crackAnimation.value > 0.5 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: egg.color2.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      _answer,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.playAgain),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EggData {
  final Color color1;
  final Color color2;
  final String sparkle;

  _EggData(this.color1, this.color2, this.sparkle);
}

/// Custom painter for realistic egg shape
class _EggShapePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final bool isSelected;
  final bool showCracks;
  final double crackProgress;

  _EggShapePainter({
    required this.color1,
    required this.color2,
    this.isSelected = false,
    this.showCracks = false,
    this.crackProgress = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw egg shape using bezier curves - flipped with rounder tips
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start at top center (wide end)
    path.moveTo(w / 2, 0);

    // Left side curve (top wide to bottom narrow)
    path.cubicTo(
      w * 0.0, // control 1 x - wider curve
      h * 0.25, // control 1 y
      w * 0.05, // control 2 x
      h * 0.6, // control 2 y
      w * 0.25, // end x (narrow bottom)
      h * 0.88, // end y
    );

    // Bottom curve (rounder tip)
    path.cubicTo(
      w * 0.35, // control 1 x
      h * 0.97, // control 1 y - rounder
      w * 0.65, // control 2 x
      h * 0.97, // control 2 y - rounder
      w * 0.75, // end x
      h * 0.88, // end y
    );

    // Right side curve (bottom narrow to top wide)
    path.cubicTo(
      w * 0.95, // control 1 x
      h * 0.6, // control 1 y
      w * 1.0, // control 2 x - wider curve
      h * 0.25, // control 2 y
      w / 2, // back to top center
      0,
    );

    path.close();

    // Shadow
    if (isSelected) {
      canvas.drawShadow(path, color2, 16, true);
    } else {
      canvas.drawShadow(path, color2.withOpacity(0.5), 8, true);
    }

    // Fill egg
    canvas.drawPath(path, paint);

    // Highlight (shine effect) - positioned at top-left of wide end
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final highlightPath = Path();
    highlightPath.moveTo(w * 0.25, h * 0.12);
    highlightPath.cubicTo(
      w * 0.18,
      h * 0.18,
      w * 0.15,
      h * 0.28,
      w * 0.18,
      h * 0.35,
    );
    highlightPath.cubicTo(
      w * 0.1,
      h * 0.25,
      w * 0.15,
      h * 0.08,
      w * 0.25,
      h * 0.12,
    );
    canvas.drawPath(highlightPath, highlightPaint);

    // Draw cracks
    if (showCracks && crackProgress > 0) {
      final crackPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final crackPath = Path();

      if (crackProgress > 0.3) {
        crackPath.moveTo(w * 0.5, h * 0.35);
        crackPath.lineTo(w * 0.35, h * 0.45);
        crackPath.lineTo(w * 0.55, h * 0.55);
      }
      if (crackProgress > 0.5) {
        crackPath.moveTo(w * 0.55, h * 0.3);
        crackPath.lineTo(w * 0.7, h * 0.42);
      }
      if (crackProgress > 0.7) {
        crackPath.moveTo(w * 0.4, h * 0.45);
        crackPath.lineTo(w * 0.25, h * 0.6);
      }

      canvas.drawPath(crackPath, crackPaint);
    }
  }

  @override
  bool shouldRepaint(_EggShapePainter oldDelegate) =>
      oldDelegate.color1 != color1 ||
      oldDelegate.color2 != color2 ||
      oldDelegate.isSelected != isSelected ||
      oldDelegate.showCracks != showCracks ||
      oldDelegate.crackProgress != crackProgress;
}
