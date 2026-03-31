import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/onboarding_result_ai.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';
import '../../habit/domain/habit_repository.dart';
import '../data/onboarding_repository.dart';

/// Adaptif AI onboarding sonuç ekranı.
///
/// 3 kart gösterilir:
///   1. Vizyon kartı (title, description, 3 pillar chip)
///   2. Kişilik kartı (type, description)
///   3. Alışkanlık listesi (seçilebilir toggle)
///
/// "Mira'mı Oluştur" CTA'sı ile seçili habitler kaydedilir.
class OnboardingResultScreen extends StatefulWidget {
  final OnboardingResultAi result;
  final bool isRetake;

  const OnboardingResultScreen({
    super.key,
    required this.result,
    this.isRetake = false,
  });

  @override
  State<OnboardingResultScreen> createState() => _OnboardingResultScreenState();
}

class _OnboardingResultScreenState extends State<OnboardingResultScreen> {
  late final Set<int> _selectedHabits;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // tüm habitler varsayılan olarak seçili
    _selectedHabits = Set.from(
      List.generate(widget.result.habits.length, (i) => i),
    );
  }

  Future<void> _saveAndProceed() async {
    setState(() => _isSaving = true);

    try {
      final repo = HabitRepository.instance;
      await repo.initialize();

      // Seçili habit önerilerini Habit'e dönüştür ve kaydet
      final colors = _pillarColors(context, widget.result.vision.pillars);
      for (final i in _selectedHabits) {
        final suggestion = widget.result.habits[i];
        final habit = _mapToHabit(suggestion, colors);
        await repo.addHabit(habit);
      }

      // Onboarding tamamlandı olarak işaretle
      await OnboardingRepository().setOnboardingCompleted(true);

      if (!mounted) return;

      if (widget.isRetake) {
        Navigator.of(context).pop();
      } else {
        // Ana uygulamaya geç — tüm route stack'i temizle
        Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kaydetme hatası: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mira Planın ✨',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Vizyon Kartı ──────────────────────────────
                _SectionLabel(label: 'Vizyonun 🌄'),
                const SizedBox(height: 12),
                _VisionCard(vision: result.vision),
                const SizedBox(height: 28),

                // ── Kişilik Kartı ─────────────────────────────
                _SectionLabel(label: 'Kişilik Kartın 🧠'),
                const SizedBox(height: 12),
                _PersonalityCard(personality: result.personality),
                const SizedBox(height: 28),

                // ── Alışkanlık Listesi ────────────────────────
                _SectionLabel(
                  label: 'Alışkanlık Önerileri 🌱',
                  subtitle: 'İstediğin önerilerin seçimini kaldırabilirsin',
                ),
                const SizedBox(height: 12),
                ...List.generate(result.habits.length, (i) {
                  final habit = result.habits[i];
                  final selected = _selectedHabits.contains(i);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HabitSuggestionTile(
                      suggestion: habit,
                      isSelected: selected,
                      onToggle: () => setState(() {
                        if (selected) {
                          _selectedHabits.remove(i);
                        } else {
                          _selectedHabits.add(i);
                        }
                      }),
                    ),
                  );
                }),
              ]),
            ),
          ),
        ],
      ),

      // Sticky bottom CTA
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: (_isSaving || _selectedHabits.isEmpty)
                ? null
                : _saveAndProceed,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Mira'mı Oluştur (${_selectedHabits.length} alışkanlık)",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ─── Habit Mapping ──────────────────────────────────────────────────────

  Habit _mapToHabit(AiHabitSuggestion s, Map<String, Color> pillarColors) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final color =
        pillarColors[s.pillar] ?? Theme.of(context).colorScheme.primary;

    HabitType habitType;
    int targetCount;
    String? unit;

    switch (s.type) {
      case 'numeric':
        habitType = HabitType.numerical;
        targetCount = (s.targetValue ?? 1).round();
        unit = s.targetUnit;
        break;
      case 'duration':
        habitType = HabitType.timer;
        // brief'te targetValue saniye cinsinden; dakikaya çevir
        targetCount = ((s.targetValue ?? 60) / 60).ceil().clamp(1, 9999);
        unit = 'dk';
        break;
      default: // 'binary'
        habitType = HabitType.simple;
        targetCount = 1;
        unit = null;
    }

    // Frequency mapping
    String? frequency;
    String? frequencyType;
    List<int>? selectedWeekdays;

    switch (s.frequency) {
      case 'weekdays':
        frequency = 'weekly';
        frequencyType = 'specificWeekdays';
        selectedWeekdays = [1, 2, 3, 4, 5];
        break;
      case 'weekends':
        frequency = 'weekly';
        frequencyType = 'specificWeekdays';
        selectedWeekdays = [6, 7];
        break;
      case 'weekly':
        frequency = 'weekly';
        frequencyType = 'specificWeekdays';
        selectedWeekdays = [1]; // Pazartesi
        break;
      default: // 'daily'
        frequency = 'daily';
        frequencyType = 'daily';
    }

    return Habit(
      id: _generateId(),
      title: s.name,
      description: s.visionReason,
      icon: Icons.star_rounded,
      emoji: s.icon,
      color: color,
      targetCount: targetCount,
      habitType: habitType,
      unit: unit,
      frequency: frequency,
      frequencyType: frequencyType,
      selectedWeekdays: selectedWeekdays,
      currentStreak: 0,
      isCompleted: false,
      progressDate: dateStr,
      startDate: dateStr,
      categoryName: s.pillar,
    );
  }

  /// Pillar'lara tema renk havuzundan sıra ile renk ata.
  Map<String, Color> _pillarColors(
      BuildContext context, List<String> pillars) {
    final cs = Theme.of(context).colorScheme;
    final palette = [cs.primary, cs.secondary, cs.tertiary];
    final map = <String, Color>{};
    for (int i = 0; i < pillars.length; i++) {
      map[pillars[i]] = palette[i % palette.length];
    }
    return map;
  }

  String _generateId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(99999)}';
}

// ─── Section Label ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? subtitle;

  const _SectionLabel({required this.label, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Vision Card ───────────────────────────────────────────────────────────

class _VisionCard extends StatelessWidget {
  final AiVision vision;

  const _VisionCard({required this.vision});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vision.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onPrimaryContainer,
              letterSpacing: -0.3,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            vision.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              height: 1.6,
            ),
          ),
          if (vision.pillars.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: vision.pillars
                  .map(
                    (p) => Chip(
                      label: Text(
                        p,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.secondaryContainer
                          .withOpacity(0.7),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 0),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Personality Card ──────────────────────────────────────────────────────

class _PersonalityCard extends StatelessWidget {
  final AiPersonalityCard personality;

  const _PersonalityCard({required this.personality});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: theme.colorScheme.onTertiaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personality.type,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  personality.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Habit Suggestion Tile ─────────────────────────────────────────────────

class _HabitSuggestionTile extends StatelessWidget {
  final AiHabitSuggestion suggestion;
  final bool isSelected;
  final VoidCallback onToggle;

  const _HabitSuggestionTile({
    required this.suggestion,
    required this.isSelected,
    required this.onToggle,
  });

  String _typeLabel(String type, double? target, String? unit) {
    switch (type) {
      case 'numeric':
        return '${target?.round() ?? ''} ${unit ?? ''}'.trim();
      case 'duration':
        final mins = ((target ?? 60) / 60).ceil();
        return '$mins dk';
      default:
        return 'Günlük';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeLabel = _typeLabel(
      suggestion.type,
      suggestion.targetValue,
      suggestion.targetUnit,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withOpacity(0.45)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.15)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    suggestion.icon,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name + reason
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      suggestion.visionReason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.55),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _TagChip(
                          label: suggestion.pillar,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        _TagChip(
                          label: typeLabel,
                          color: theme.colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
