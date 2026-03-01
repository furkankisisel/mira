import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../design_system/theme/theme_variations.dart';
import 'data/detailed_mood_repository.dart';
import 'data/mood_models.dart';
import 'presentation/mood_analytics_screen.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key, required this.variant});

  final ThemeVariant variant;

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final _repo = DetailedMoodRepository();

  bool _loading = true;

  // Selected state
  MoodLevel? _selectedMood;
  Set<SubEmotion> _selectedSubEmotions = {};
  ReasonCategory? _selectedReason;
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final today = DateTime.now();
    // Pre-select if there's already an entry for today
    final existingEntries = await _repo.getMoodEntriesForDate(today);
    if (existingEntries.isNotEmpty) {
      final existing = existingEntries.first;
      _selectedMood = existing.mood;
      _selectedSubEmotions = existing.subEmotions.toSet();
      _selectedReason = existing.reason;
      _noteCtrl.text = existing.journalText;
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveToday() async {
    if (_selectedMood == null) return;

    // Default reason if not selected
    final reason = _selectedReason ?? ReasonCategory.other;

    final entry = MoodEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      mood: _selectedMood!,
      subEmotions: _selectedSubEmotions.toList(),
      reason: reason,
      journalText: _noteCtrl.text.trim(),
    );

    await _repo.saveMoodEntry(entry);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // Define full sub-emotion list for each mood category so all 41 are available
  List<SubEmotion> _getExpandedSubEmotionsForMood(MoodLevel mood) {
    if (mood == MoodLevel.terrible || mood == MoodLevel.bad) {
      // Grouping all negative emotions
      return [
        SubEmotion.exhausted,
        SubEmotion.helpless,
        SubEmotion.hopeless,
        SubEmotion.hurt,
        SubEmotion.drained,
        SubEmotion.angry,
        SubEmotion.sad,
        SubEmotion.anxious,
        SubEmotion.stressed,
        SubEmotion.demoralized,
        SubEmotion.overwhelmed,
        SubEmotion.lonely,
        SubEmotion.regretful,
        SubEmotion.insecure,
        SubEmotion.guilty,
      ];
    } else if (mood == MoodLevel.neutral) {
      // Grouping all neutral emotions
      return [
        SubEmotion.indecisive,
        SubEmotion.tired,
        SubEmotion.ordinary,
        SubEmotion.calm,
        SubEmotion.empty,
        SubEmotion.bored,
        SubEmotion.numb,
        SubEmotion.confused,
        SubEmotion.distracted,
      ];
    } else {
      // Grouping all positive emotions (good, excellent)
      return [
        SubEmotion.happy,
        SubEmotion.cheerful,
        SubEmotion.excited,
        SubEmotion.enthusiastic,
        SubEmotion.determined,
        SubEmotion.motivated,
        SubEmotion.proud,
        SubEmotion.confident,
        SubEmotion.hopeful,
        SubEmotion.amazing,
        SubEmotion.energetic,
        SubEmotion.peaceful,
        SubEmotion.grateful,
        SubEmotion.loving,
        SubEmotion.euphoric,
        SubEmotion.blessed,
        SubEmotion.unstoppable,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to use dark or light mode based on brightness,
    // or just use the current theme dynamically
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Core Dynamic Theme Integration
    final ThemeData theme = Theme.of(context);
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color cardColor = theme.colorScheme.surface;
    final Color primaryColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;

    // Dynamic chip color (darken or lighten based on background brightness)
    final Color chipColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.05);

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textColor),
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          title: const Text("Ruh hali kaydı"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: "Geçmiş",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MoodAnalyticsScreen(variant: widget.variant),
                  ),
                );
              },
            ),
          ],
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : _buildInputContent(
                context, cardColor, primaryColor, chipColor, textColor),
      ),
    );
  }

  Widget _buildInputContent(BuildContext context, Color cardColor,
      Color primaryColor, Color chipColor, Color textColor) {
    List<SubEmotion> availableSubEmotions = [];
    if (_selectedMood != null) {
      availableSubEmotions = _getExpandedSubEmotionsForMood(_selectedMood!);
    }

    // Slightly faded text for descriptions
    final Color hintColor = textColor.withOpacity(0.5);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nasıl hissediyorsunuz?",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...MoodLevel.values.reversed.map((m) {
                    final isSelected = _selectedMood == m;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMood = m;
                              _selectedSubEmotions.clear();
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                // Custom Radio natively styled
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          isSelected ? primaryColor : hintColor,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? primaryColor.withOpacity(0.2)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Icon(Icons.check,
                                              size: 16, color: primaryColor))
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                _getMoodFace(m),
                                const SizedBox(width: 16),
                                Text(
                                  _getMoodTitle(m),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected && m == MoodLevel.terrible)
                                  const Icon(Icons.favorite,
                                      color: Colors.redAccent, size: 16),
                              ],
                            ),
                          ),
                        ),
                        if (m != MoodLevel.values.first)
                          Divider(color: textColor.withOpacity(0.1), height: 1),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  Text(
                    "Ruh hali, uzun süreli genel duygu durumudur.",
                    style: TextStyle(color: hintColor, fontSize: 13),
                  ),
                  if (_selectedMood != null) ...[
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Hangi duygular hislerinizi\nen iyi şekilde ifade ediyor?",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            color: hintColor),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: availableSubEmotions.map((sub) {
                        final isSelected = _selectedSubEmotions.contains(sub);
                        return _buildCustomChip(
                          label: _getSubEmotionLabel(sub),
                          isSelected: isSelected,
                          primaryColor: primaryColor,
                          chipColor: chipColor,
                          textColor: textColor,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedSubEmotions.remove(sub);
                              } else {
                                _selectedSubEmotions.add(sub);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Duygu, bir olay veya anlamlı deneyim nedeniyle\noluşan mutluluk, sinir veya mutsuzluk gibi kısa\nsüreli tepkidir.",
                      style: TextStyle(
                          color: hintColor, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      "Bu şekilde hissetmenizin nedeni\nnedir?",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: ReasonCategory.values.map((reason) {
                        final isSelected = _selectedReason == reason;
                        return _buildCustomChip(
                          label: _getReasonLabel(reason),
                          isSelected: isSelected,
                          primaryColor: primaryColor,
                          chipColor: chipColor,
                          textColor: textColor,
                          onTap: () {
                            setState(() {
                              _selectedReason = isSelected ? null : reason;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      "Ekleyecek başka bir şeyiniz var\nmı?",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _noteCtrl,
                        maxLines: 4,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              "Bu hissi veya anı hatırlamanıza\nyardımcı olacak bir not ekleyin",
                          hintStyle: TextStyle(color: hintColor, height: 1.4),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(24),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Bottom Action Area
        Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
          color: Colors.transparent, // Background shows through
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selectedMood == null ? null : _saveToday,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                _selectedMood == null ? "Sonraki" : "Kaydet",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomChip(
      {required String label,
      required bool isSelected,
      required Color primaryColor,
      required Color chipColor,
      required Color textColor,
      required VoidCallback onTap}) {
    // Dynamic text color for selected vs unselected based on overall contrasting brightness
    final Color selectedTextColor =
        ThemeData.estimateBrightnessForColor(primaryColor) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : chipColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedTextColor : textColor.withOpacity(0.8),
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _getMoodFace(MoodLevel m) {
    Color color;
    IconData icon;
    switch (m) {
      case MoodLevel.excellent:
        color = const Color(0xFF63A4FF); // Soft blue
        icon = Icons.sentiment_very_satisfied_rounded;
        break;
      case MoodLevel.good:
        color = const Color(0xFF4CAF50); // Soft green
        icon = Icons.sentiment_satisfied_alt_rounded;
        break;
      case MoodLevel.neutral:
        color = const Color(0xFFFFC107); // Warm yellow
        icon = Icons.sentiment_neutral_rounded;
        break;
      case MoodLevel.bad:
        color = const Color(0xFFFF7043); // Orange
        icon = Icons.sentiment_dissatisfied_rounded;
        break;
      case MoodLevel.terrible:
        color = const Color(0xFFEF5350); // Red
        icon = Icons.sentiment_very_dissatisfied_rounded;
        break;
    }
    return Icon(icon, color: color, size: 40);
  }

  String _getMoodTitle(MoodLevel m) {
    switch (m) {
      case MoodLevel.excellent:
        return "Muhteşem!";
      case MoodLevel.good:
        return "İyi";
      case MoodLevel.neutral:
        return "Ortalama";
      case MoodLevel.bad:
        return "Kötü";
      case MoodLevel.terrible:
        return "Çok kötü";
    }
  }

  String _getSubEmotionLabel(SubEmotion emotion) {
    switch (emotion) {
      // Positives
      case SubEmotion.cheerful:
        return "Neşeli";
      case SubEmotion.hopeful:
        return "Umutlu";
      case SubEmotion.amazing:
        return "Etkilenmiş";
      case SubEmotion.peaceful:
        return "İçi rahatlamış";
      case SubEmotion.confident:
        return "Güvenli";
      case SubEmotion.happy:
        return "Keyifli";
      case SubEmotion.euphoric:
        return "Coşkulu";
      case SubEmotion.blessed:
        return "Mutlu";
      case SubEmotion.unstoppable:
        return "Tutkulu";
      case SubEmotion.enthusiastic:
        return "Hevesli";
      case SubEmotion.excited:
        return "Heyecanlı";
      case SubEmotion.determined:
        return "Cesur";
      case SubEmotion.proud:
        return "Gururlu";
      case SubEmotion.calm:
        return "Sakin";
      case SubEmotion.motivated:
        return "Meraklı";
      case SubEmotion.grateful:
        return "Minnettar";
      case SubEmotion.loving:
        return "Huzurlu";

      // Negatives/Neutrals
      case SubEmotion.exhausted:
        return "Tükenmiş";
      case SubEmotion.helpless:
        return "Çaresiz";
      case SubEmotion.hopeless:
        return "Umutsuz";
      case SubEmotion.hurt:
        return "Kırgın";
      case SubEmotion.drained:
        return "Bitkin";
      case SubEmotion.angry:
        return "Kızgın";
      case SubEmotion.sad:
        return "Üzgün";
      case SubEmotion.anxious:
        return "Endişeli";
      case SubEmotion.stressed:
        return "Stresli";
      case SubEmotion.demoralized:
        return "Demoralize";
      case SubEmotion.indecisive:
        return "Kararsız";
      case SubEmotion.tired:
        return "Yorgun";
      case SubEmotion.ordinary:
        return "Sıradan";
      case SubEmotion.empty:
        return "Boş";
      case SubEmotion.overwhelmed:
        return "Bunalmış";
      case SubEmotion.lonely:
        return "Yalnız";
      case SubEmotion.regretful:
        return "Pişman";
      case SubEmotion.insecure:
        return "Güvensiz";
      case SubEmotion.guilty:
        return "Suçlu";
      case SubEmotion.bored:
        return "Sıkılmış";
      case SubEmotion.numb:
        return "Hissiz";
      case SubEmotion.confused:
        return "Karmaşık";
      case SubEmotion.distracted:
        return "Dağınık";
      case SubEmotion.energetic:
        return "Enerjik";
    }
  }

  String _getReasonLabel(ReasonCategory reason) {
    switch (reason) {
      case ReasonCategory.health:
        return "Sağlık";
      case ReasonCategory.academic:
        return "Okul";
      case ReasonCategory.work:
        return "İş";
      case ReasonCategory.finance:
        return "Para";
      case ReasonCategory.relationship:
        return "Partner";
      case ReasonCategory.social:
        return "Arkadaşlar";
      case ReasonCategory.personalGrowth:
        return "Hobiler";
      case ReasonCategory.weather:
        return "Hava Durumu";
      case ReasonCategory.other:
        return "Diğer";
    }
  }
}
