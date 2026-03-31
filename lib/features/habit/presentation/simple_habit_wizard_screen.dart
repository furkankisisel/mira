import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../../../providers/premium_provider.dart';
import '../../../ui/premium_gate.dart';
import '../domain/habit_model.dart';
import '../domain/habit_types.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';

/// Basit alışkanlık oluşturma wizard'ı - 5 sayfalı kompakt akış
class SimpleHabitWizardScreen extends StatefulWidget {
  const SimpleHabitWizardScreen({super.key});

  @override
  State<SimpleHabitWizardScreen> createState() =>
      _SimpleHabitWizardScreenState();
}

class _SimpleHabitWizardScreenState extends State<SimpleHabitWizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Wizard data
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedEmoji = '✅';
  Color _selectedColor = const Color(0xFF6366F1);
  String _selectedFrequency = 'daily';
  final Set<int> _weeklyDays = {};
  final Set<int> _monthDays = {};
  int _periodicDays = 2;
  DateTime _startDate = DateTime.now();
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  RhythmWindow? _selectedRhythmWindow;

  // 5 sayfa:
  // 0: İsim + Açıklama
  // 1: Emoji + Renk
  // 2: Sıklık + Gün seçimi (conditional)
  // 3: Tarih + Hatırlatıcı + Ritim
  // 4: Önizleme
  static const int _totalPages = 5;

  // Renk paleti
  static const List<Color> _colors = [
    Color(0xFF90CAF9),
    Color(0xFFB39DDB),
    Color(0xFFF48FB1),
    Color(0xFFFFCC80),
    Color(0xFFFFF59D),
    Color(0xFFA5D6A7),
    Color(0xFF80CBC4),
    Color(0xFFEF9A9A),
    Color(0xFFBCAAA4),
    Color(0xFF9FA8DA),
  ];

  static const List<String> _quickEmojis = [
    '✅',
    '⭐',
    '💪',
    '🎯',
    '📚',
    '💧',
    '🏃',
    '🧘',
    '💤',
    '🍎',
    '🏋️',
    '🚴',
    '🧠',
    '💊',
    '🌱',
    '☀️',
    '🎨',
    '🎵',
    '🎬',
    '✈️',
    '🐶',
    '🎓',
    '💼',
    '💰',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _totalPages - 1) {
      // Premium kullanıcı için: Schedule sayfasından (3) preview'e geçerken AI analizi yap
      final isPremium = context.read<PremiumProvider>().isPremium;
      if (isPremium && _currentPage == 2) {
        await _showAiAnalysisDialog();
      }

      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _showAiAnalysisDialog() async {
    final l10n = AppLocalizations.of(context);
    final statusTexts = [
      l10n.analyzingHabit,
      l10n.calculatingLifeRhythm,
      l10n.determiningBestReminder,
      l10n.finalizingSettingsProgress,
    ];

    int currentStatus = 0;
    bool dialogActive = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (dialogActive && currentStatus < statusTexts.length - 1) {
                setDialogState(() => currentStatus++);
              }
            });

            return Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _selectedColor.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _selectedColor,
                            _selectedColor.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        statusTexts[currentStatus],
                        key: ValueKey(currentStatus),
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.determiningBestSettings,
                      style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                            color: Theme.of(ctx)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          4,
                          (i) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= currentStatus
                                      ? _selectedColor
                                      : Theme.of(ctx)
                                          .colorScheme
                                          .outlineVariant,
                                ),
                              )),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 5000));
    dialogActive = false;

    final aiRhythmWindow = _determineOptimalRhythmWindow();
    final aiReminderTime = _determineOptimalReminderTime(aiRhythmWindow);

    setState(() {
      _selectedRhythmWindow = aiRhythmWindow;
      _reminderEnabled = true;
      _reminderTime = aiReminderTime;
    });

    if (mounted) Navigator.of(context).pop();
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _saveHabit() async {
    if (!mounted) return;
    await _createAndSaveHabit(
      rhythmWindow: _selectedRhythmWindow,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderEnabled ? _reminderTime : null,
    );
  }

  RhythmWindow _determineOptimalRhythmWindow() {
    final title = _nameController.text.toLowerCase();

    if (title.contains('medita') ||
        title.contains('yat') ||
        title.contains('günlük') ||
        title.contains('journal') ||
        title.contains('uyku') ||
        title.contains('gece')) {
      return RhythmWindow.reflection;
    }
    if (title.contains('spor') ||
        title.contains('egzersiz') ||
        title.contains('koş') ||
        title.contains('yürü') ||
        title.contains('fitness') ||
        title.contains('workout')) {
      return RhythmWindow.energy;
    }
    if (title.contains('oku') ||
        title.contains('öğren') ||
        title.contains('çalış') ||
        title.contains('study') ||
        title.contains('kod') ||
        title.contains('program')) {
      return RhythmWindow.focus;
    }
    return RhythmWindow.light;
  }

  TimeOfDay _determineOptimalReminderTime(RhythmWindow window) {
    switch (window) {
      case RhythmWindow.focus:
        return const TimeOfDay(hour: 9, minute: 0);
      case RhythmWindow.energy:
        return const TimeOfDay(hour: 14, minute: 0);
      case RhythmWindow.light:
        return const TimeOfDay(hour: 17, minute: 0);
      case RhythmWindow.reflection:
        return const TimeOfDay(hour: 21, minute: 0);
    }
  }

  Future<void> _createAndSaveHabit({
    required RhythmWindow? rhythmWindow,
    required bool reminderEnabled,
    required TimeOfDay? reminderTime,
  }) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      String freqText;
      try {
        freqText = _getFrequencyText();
      } catch (e) {
        freqText = mounted ? AppLocalizations.of(context).daily : 'Daily';
      }

      final startDateStr =
          '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}';

      final habit = Habit(
        id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: Icons.check_circle,
        emoji: _selectedEmoji,
        color: _selectedColor,
        habitType: HabitType.simple,
        targetCount: 1,
        unit: '',
        currentStreak: 0,
        isCompleted: false,
        progressDate: dateStr,
        frequencyType: _selectedFrequency,
        frequency: freqText,
        selectedWeekdays:
            _selectedFrequency == 'weekly' ? _weeklyDays.toList() : null,
        selectedMonthDays:
            _selectedFrequency == 'monthly' ? _monthDays.toList() : null,
        periodicDays: _selectedFrequency == 'periodic' ? _periodicDays : null,
        startDate: startDateStr,
        reminderEnabled: reminderEnabled,
        reminderTime: reminderTime,
        rhythmWindow: rhythmWindow,
      );

      if (mounted) {
        Navigator.of(context).pop(habit);
      }
    } catch (e, stack) {
      debugPrint('DEBUG: CRITICAL ERROR in _createAndSaveHabit: $e');
      debugPrint(stack.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  String _getFrequencyText() {
    final l10n = AppLocalizations.of(context);
    switch (_selectedFrequency) {
      case 'daily':
        return l10n.daily;
      case 'weekly':
        return l10n.weekly;
      case 'monthly':
        return l10n.monthly;
      case 'periodic':
        return l10n.everyXDays(_periodicDays);
      default:
        return l10n.daily;
    }
  }

  bool get _isFrequencyPageValid {
    if (_selectedFrequency == 'weekly') return _weeklyDays.isNotEmpty;
    if (_selectedFrequency == 'monthly') return _monthDays.isNotEmpty;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      currentStep: _currentPage,
      totalSteps: _totalPages,
      showProgress: true,
      onBack: _previousPage,
      onClose: () => Navigator.pop(context),
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 0: İsim + Açıklama
          _buildNamePage(),

          // 1: Emoji + Renk
          _buildEmojiColorPage(),

          // 2: Sıklık + Gün seçimi
          _buildFrequencyDaysPage(),

          // 3: Tarih + Hatırlatıcı + Ritim
          _buildSchedulePage(),

          // 4: Önizleme
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    final l10n = AppLocalizations.of(context);
    final isValid = _nameController.text.trim().isNotEmpty;

    return WizardPage(
      emoji: '✏️',
      title: l10n.simpleHabitNameTitle,
      subtitle: l10n.simpleHabitNameSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: l10n.habitNameHint,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (isValid) _nextPage();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: l10n.descriptionHintOptional,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiColorPage() {
    final l10n = AppLocalizations.of(context);

    return WizardPage(
      emoji: '🎨',
      title: l10n.simpleHabitEmojiTitle,
      subtitle: l10n.simpleHabitEmojiSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
      child: Column(
        children: [
          // Emoji seçimi
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ..._quickEmojis.map((emoji) {
                final isSelected = emoji == _selectedEmoji;
                return WizardSelectionCard(
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  size: 52,
                  borderRadius: 14,
                  selectedColor: _selectedColor,
                  child: Text(emoji, style: const TextStyle(fontSize: 26)),
                );
              }),
              WizardSelectionCard(
                isSelected: false,
                onTap: _showCustomEmojiInput,
                size: 52,
                borderRadius: 14,
                selectedColor: _selectedColor,
                child: Icon(
                  Icons.add_reaction_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Renk seçimi
          Text(
            l10n.simpleHabitColorTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: _colors.map((color) {
              final isSelected = color.value == _selectedColor.value;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedColor = color);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 52 : 44,
                  height: isSelected ? 52 : 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 4,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyDaysPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final frequencies = [
      ('daily', l10n.daily, '📅', l10n.dailyDesc),
      ('weekly', l10n.weekly, '📆', l10n.weeklyDesc),
      ('monthly', l10n.monthly, '🗓️', l10n.monthlyDesc),
      ('periodic', l10n.periodic, '🔄', l10n.periodicDesc),
    ];

    return WizardPage(
      emoji: '⏰',
      title: l10n.simpleHabitFrequencyTitle,
      subtitle: l10n.simpleHabitFrequencySubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: _isFrequencyPageValid,
        accentColor: _selectedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sıklık seçimi
          ...frequencies.map((freq) {
            final isSelected = _selectedFrequency == freq.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedFrequency = freq.$1);
                },
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _selectedColor.withOpacity(0.1)
                        : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                        ? Border.all(color: _selectedColor, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(freq.$3, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              freq.$2,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              freq.$4,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle,
                            color: _selectedColor, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Dinamik gün seçimi — sıklığa göre animasyonla açılır
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _selectedFrequency != 'daily'
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildDaysSection(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysSection() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_selectedFrequency == 'weekly') {
      final weekdays = [
        l10n.mondayShort,
        l10n.tuesdayShort,
        l10n.wednesdayShort,
        l10n.thursdayShort,
        l10n.fridayShort,
        l10n.saturdayShort,
        l10n.sundayShort,
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.simpleHabitWeekdaysTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(7, (index) {
              final isSelected = _weeklyDays.contains(index);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    if (isSelected) {
                      _weeklyDays.remove(index);
                    } else {
                      _weeklyDays.add(index);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _selectedColor
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      weekdays[index],
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    }

    if (_selectedFrequency == 'monthly') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.simpleHabitMonthDaysTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: List.generate(31, (index) {
              final day = index + 1;
              final isSelected = _monthDays.contains(day);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    if (isSelected) {
                      _monthDays.remove(day);
                    } else {
                      _monthDays.add(day);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _selectedColor
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    }

    if (_selectedFrequency == 'periodic') {
      return Column(
        children: [
          Text(
            '$_periodicDays ${l10n.days}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _selectedColor,
                ),
          ),
          Slider(
            value: _periodicDays.toDouble(),
            min: 2,
            max: 30,
            divisions: 28,
            activeColor: _selectedColor,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _periodicDays = value.round());
            },
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSchedulePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final quickDates = [
      (today, l10n.today, '📍'),
      (tomorrow, l10n.tomorrow, '➡️'),
      (nextWeek, l10n.nextWeek, '📆'),
    ];

    final hasProfile = LiveRhythmRepository.instance.hasProfile;

    final windows = [
      (
        RhythmWindow.focus,
        '🧠',
        l10n.rhythmWindowFocus,
        l10n.rhythmWindowFocusDesc
      ),
      (
        RhythmWindow.energy,
        '⚡',
        l10n.rhythmWindowEnergy,
        l10n.rhythmWindowEnergyDesc
      ),
      (
        RhythmWindow.light,
        '🌤️',
        l10n.rhythmWindowLight,
        l10n.rhythmWindowLightDesc
      ),
      (
        RhythmWindow.reflection,
        '🌙',
        l10n.rhythmWindowReflection,
        l10n.rhythmWindowReflectionDesc
      ),
    ];

    return WizardPage(
      emoji: '🚀',
      title: l10n.simpleHabitStartDateTitle,
      subtitle: l10n.simpleHabitStartDateSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Başlangıç Tarihi ───
          Text(
            l10n.startDate,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...quickDates.map((qd) {
                final isSelected = isSameDay(_startDate, qd.$1);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _startDate = qd.$1);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withOpacity(0.15)
                              : colorScheme.surfaceContainerHighest
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: _selectedColor, width: 2)
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(qd.$3, style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 2),
                            Text(
                              qd.$2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : null,
                                color: isSelected ? _selectedColor : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_today,
                      color: colorScheme.primary, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ─── Hatırlatıcı ───
          Text(
            l10n.simpleHabitReminderTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _reminderEnabled
                  ? _selectedColor.withOpacity(0.1)
                  : colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: _reminderEnabled
                  ? Border.all(color: _selectedColor, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  _reminderEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off_outlined,
                  color: _reminderEnabled
                      ? _selectedColor
                      : colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _reminderEnabled
                      ? GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _reminderTime,
                            );
                            if (picked != null)
                              setState(() => _reminderTime = picked);
                          },
                          child: Text(
                            _reminderTime.format(context),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _selectedColor,
                            ),
                          ),
                        )
                      : Text(
                          l10n.reminderDisabled,
                          style: theme.textTheme.bodyMedium,
                        ),
                ),
                Switch.adaptive(
                  value: _reminderEnabled,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _reminderEnabled = value);
                  },
                  activeColor: _selectedColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ─── Ritim Penceresi ─── (Premium)
          Text(
            l10n.rhythmWindowStepTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.rhythmWindowStepSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          if (!hasProfile)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.rhythmWindowNoProfileHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: windows.map((w) {
              final isSelected = _selectedRhythmWindow == w.$1;
              final isPremium = context.read<PremiumProvider>().isPremium;
              return GestureDetector(
                onTap: () async {
                  if (!isPremium) {
                    await requirePremium(context);
                    return;
                  }
                  HapticFeedback.lightImpact();
                  setState(
                      () => _selectedRhythmWindow = isSelected ? null : w.$1);
                },
                child: Opacity(
                  opacity: isPremium ? 1.0 : 0.6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _selectedColor.withOpacity(0.15)
                          : colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: _selectedColor, width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(w.$2, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          w.$3,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : null,
                            color: isSelected ? _selectedColor : null,
                          ),
                        ),
                        if (!isPremium) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.lock_outline,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.5)),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final habitName = _nameController.text.trim().isEmpty
        ? l10n.habitNamePlaceholder
        : _nameController.text.trim();

    return WizardPage(
      emoji: '🎉',
      title: l10n.simpleHabitPreviewTitle,
      subtitle: l10n.simpleHabitPreviewSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: () => _saveHabit(),
        nextLabel: l10n.createHabit,
        isLastStep: true,
        accentColor: _selectedColor,
      ),
      child: Column(
        children: [
          WizardPreviewCard(
            emoji: _selectedEmoji,
            title: habitName,
            subtitle: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            color: _selectedColor,
            tags: [
              _getFrequencyText(),
              if (_reminderEnabled) '🔔 ${_reminderTime.format(context)}',
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.calendar_today,
                  l10n.startsOn,
                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                ),
                if (_reminderEnabled)
                  _buildDetailRow(
                    Icons.notifications,
                    l10n.reminder,
                    _reminderTime.format(context),
                  ),
                if (_selectedRhythmWindow != null)
                  _buildDetailRow(
                    Icons.schedule,
                    l10n.rhythmWindowStepTitle,
                    _selectedRhythmWindow!.name,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomEmojiInput() async {
    String? customEmoji;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).customEmoji),
        content: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 32),
          decoration: InputDecoration(
            hintText: '😀',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onChanged: (value) {
            if (value.characters.isNotEmpty) {
              customEmoji = value.characters.first;
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              if (customEmoji != null) {
                setState(() => _selectedEmoji = customEmoji!);
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).select),
          ),
        ],
      ),
    );
  }
}
