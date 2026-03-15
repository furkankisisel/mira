import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../domain/habit_model.dart';
import '../domain/habit_types.dart';
import '../domain/subtask_model.dart';
import 'package:provider/provider.dart';
import '../../../ui/premium_gate.dart';
import '../../../providers/premium_provider.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';

/// Gelişmiş alışkanlık oluşturma wizard'ı - 6 sayfalı kompakt akış
class AdvancedHabitWizardScreen extends StatefulWidget {
  const AdvancedHabitWizardScreen({super.key});

  @override
  State<AdvancedHabitWizardScreen> createState() =>
      _AdvancedHabitWizardScreenState();
}

class _AdvancedHabitWizardScreenState extends State<AdvancedHabitWizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Wizard data
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController(text: '1');
  final _unitController = TextEditingController();

  HabitType _habitType = HabitType.numerical;
  String _selectedEmoji = '🎯';
  Color _selectedColor = const Color(0xFF6366F1);
  String _selectedFrequency = 'daily';
  final Set<int> _weeklyDays = {};
  final Set<int> _monthDays = {};
  int _periodicDays = 2;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  RhythmWindow? _selectedRhythmWindow;

  NumericalTargetType _numericalTargetType = NumericalTargetType.minimum;
  final TimerTargetType _timerTargetType = TimerTargetType.minimum;
  Duration _timerDuration = const Duration(minutes: 30);

  final List<TextEditingController> _subtaskControllers = [];

  // 6 sayfa:
  // 0: Tip seçimi
  // 1: İsim + Açıklama
  // 2: Emoji + Renk (birleşik)
  // 3: Hedef + Sıklık + Gün seçimi
  // 4: Tarih aralığı + Hatırlatıcı
  // 5: Önizleme
  static const int _totalPages = 6;

  static const List<Color> _colors = [
    Color(0xFFEF9A9A),
    Color(0xFFF48FB1),
    Color(0xFFCE93D8),
    Color(0xFFB39DDB),
    Color(0xFF9FA8DA),
    Color(0xFF90CAF9),
    Color(0xFF81D4FA),
    Color(0xFF80CBC4),
    Color(0xFFA5D6A7),
    Color(0xFFC5E1A5),
    Color(0xFFFFCC80),
    Color(0xFFFFAB91),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFFA855F7),
    Color(0xFF6366F1),
    Color(0xFF3B82F6),
    Color(0xFF14B8A6),
    Color(0xFF22C55E),
    Color(0xFFEAB308),
    Color(0xFFF97316),
    Color(0xFF374151),
  ];

  static const List<String> _quickEmojis = [
    '🎯', '📊', '⏱️', '✅', '💪', '🏃', '📚', '💧', '🧘', '💤', '🍎', '🏋️',
    '🧠', '💊', '🌱', '☀️', '🎨', '🎵', '🎬', '✈️', '🐶', '🎓', '💼', '💰',
    '✨', '🚀', '💡', '🔥', '📈', '🏠', '🌊', '🌈', '🎮', '🎬', '🍕', '🛒', '🎁', '🔔'
  ];

  @override
  void initState() {
    super.initState();
    _subtaskControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    for (final c in _subtaskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _totalPages - 1) {
      if (_currentPage == 3 && mounted) {
        final isPremium = context.read<PremiumProvider>().isPremium;
        if (isPremium) {
          await _showAiAnalysisDialog();
        }
      }

      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _showAiAnalysisDialog() async {
    final statusTexts = [
      '🔍 Alışkanlığınız analiz ediliyor...',
      '🧠 Canlı Ritminiz hesaplanıyor...',
      '⏰ En uygun hatırlatıcı zamanı belirleniyor...',
      '✨ Son ayarlamalar yapılıyor...',
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
                      'Sizin için en iyi ayarları belirliyoruz',
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

  Future<void> _saveHabit() async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    int targetCount = 1;
    if (_habitType == HabitType.numerical) {
      targetCount = int.tryParse(_targetController.text) ?? 1;
    } else if (_habitType == HabitType.timer) {
      targetCount = _timerDuration.inMinutes;
    }

    List<Subtask>? subtasks;
    if (_habitType == HabitType.subtasks) {
      subtasks = _subtaskControllers
          .where((c) => c.text.trim().isNotEmpty)
          .map(
            (c) => Subtask(
              id: 'subtask_${DateTime.now().millisecondsSinceEpoch}_${_subtaskControllers.indexOf(c)}',
              title: c.text.trim(),
            ),
          )
          .toList();
    }

    final habit = Habit(
      id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
      title: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      icon: Icons.auto_graph,
      emoji: _selectedEmoji,
      color: _selectedColor,
      habitType: _habitType,
      targetCount: targetCount,
      unit:
          _habitType == HabitType.numerical ? _unitController.text.trim() : '',
      currentStreak: 0,
      isCompleted: false,
      progressDate: dateStr,
      frequencyType: _selectedFrequency,
      frequency: _getFrequencyText(),
      selectedWeekdays:
          _selectedFrequency == 'weekly' ? _weeklyDays.toList() : null,
      selectedMonthDays:
          _selectedFrequency == 'monthly' ? _monthDays.toList() : null,
      periodicDays: _selectedFrequency == 'periodic' ? _periodicDays : null,
      startDate:
          '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}',
      endDate: _endDate != null
          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
          : null,
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderEnabled ? _reminderTime : null,
      numericalTargetType: _numericalTargetType,
      timerTargetType: _timerTargetType,
      subtasks: subtasks ?? [],
      rhythmWindow: _selectedRhythmWindow,
    )..isAdvanced = true;

    Navigator.pop(context, habit);
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

  bool get _isTargetFrequencyPageValid {
    if (_habitType == HabitType.numerical) {
      if ((int.tryParse(_targetController.text) ?? 0) <= 0) return false;
    }
    if (_habitType == HabitType.subtasks) {
      if (!_subtaskControllers.any((c) => c.text.trim().isNotEmpty))
        return false;
    }
    // gün seçimi validasyonu
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
          // 0: Tip seçimi
          _buildTypePage(),

          // 1: İsim + Açıklama
          _buildNamePage(),

          // 2: Emoji + Renk
          _buildEmojiColorPage(),

          // 3: Hedef + Sıklık + Gün seçimi
          _buildTargetFrequencyPage(),

          // 4: Tarih aralığı + Hatırlatıcı
          _buildSchedulePage(),

          // 5: Önizleme
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildTypePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final types = [
      (HabitType.numerical, l10n.numericalType, '📊', l10n.numericTypeDesc),
      (HabitType.timer, l10n.timer, '⏱️', l10n.timerTracking),
      (HabitType.simple, l10n.checkboxType, '✅', l10n.checkboxTypeDesc),
      (HabitType.subtasks, l10n.subtasks, '📋', l10n.multipleSubItems),
    ];

    return WizardPage(
      emoji: '🎯',
      title: l10n.habitTypeLabel,
      subtitle: l10n.howToTrackHabit,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
      child: Column(
        children: types.map((type) {
          final isSelected = _habitType == type.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _habitType = type.$1);
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: _selectedColor, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Text(type.$3, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.$2,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            type.$4,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: _selectedColor),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
          Text(
            l10n.simpleHabitColorTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
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
                  width: isSelected ? 42 : 34,
                  height: isSelected ? 42 : 34,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 12,
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

  Widget _buildTargetFrequencyPage() {
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
      emoji: _habitType == HabitType.timer ? '⏱️' : '🎯',
      title: l10n.simpleHabitFrequencyTitle,
      subtitle: l10n.simpleHabitFrequencySubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: _isTargetFrequencyPageValid,
        accentColor: _selectedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Hedef Bölümü ───
          _buildTargetSection(),

          const SizedBox(height: 20),

          // ─── Sıklık Bölümü ───
          Text(
            l10n.simpleHabitFrequencyTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...frequencies.map((freq) {
            final isSelected = _selectedFrequency == freq.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedFrequency = freq.$1);
                },
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
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
                      Text(freq.$3, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
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

          // Gün seçimi animasyonlu
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

  Widget _buildTargetSection() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (_habitType) {
      case HabitType.numerical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.numericalGoalShort,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _selectedColor,
                    ),
                    decoration: InputDecoration(
                      hintText: '1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _unitController,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                    decoration: InputDecoration(
                      hintText: l10n.customUnitHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Hedef tipi
            _buildTargetTypeSelector(),
          ],
        );

      case HabitType.timer:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.duration}: ${_timerDuration.inMinutes} ${l10n.minLabel}',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: _timerDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  setState(() => _timerDuration = newDuration);
                },
              ),
            ),
          ],
        );

      case HabitType.subtasks:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.subtasks,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...List.generate(_subtaskControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subtaskControllers[index],
                        decoration: InputDecoration(
                          hintText: l10n.subtaskIndex(index + 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withOpacity(0.5),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_subtaskControllers.length > 1)
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: colorScheme.error),
                        onPressed: () {
                          setState(() {
                            _subtaskControllers[index].dispose();
                            _subtaskControllers.removeAt(index);
                          });
                        },
                      ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _subtaskControllers.add(TextEditingController());
                });
              },
              icon: Icon(Icons.add, color: _selectedColor),
              label: Text(l10n.addSubtask,
                  style: TextStyle(color: _selectedColor)),
            ),
          ],
        );

      default: // simple
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _selectedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 32, color: _selectedColor),
              const SizedBox(width: 12),
              Text(
                l10n.dailyCheck,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildTargetTypeSelector() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final types = [
      (NumericalTargetType.minimum, l10n.atLeast, Icons.arrow_upward),
      (NumericalTargetType.exact, l10n.exact, Icons.radio_button_checked),
      (NumericalTargetType.maximum, l10n.atMost, Icons.arrow_downward),
    ];

    return Row(
      children: types.map((type) {
        final isSelected = _numericalTargetType == type.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _numericalTargetType = type.$1);
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: _selectedColor, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      type.$3,
                      color: isSelected
                          ? _selectedColor
                          : colorScheme.onSurface.withOpacity(0.6),
                      size: 18,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      type.$2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? _selectedColor
                            : colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
          const SizedBox(height: 8),
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
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _selectedColor
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
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
      emoji: '📆',
      title: l10n.dateRangeLabel,
      subtitle: l10n.simpleHabitStartDateSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Tarih Aralığı ───
          Text(
            l10n.dateRangeLabel,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Başlangıç tarihi
                ListTile(
                  leading: Icon(Icons.play_arrow, color: _selectedColor),
                  title: Text(l10n.startDate),
                  subtitle: Text(
                    '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _selectedColor,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _startDate = picked);
                  },
                ),
                Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
                // Bitiş tarihi
                ListTile(
                  leading: Icon(Icons.stop, color: colorScheme.error),
                  title: Text(l10n.endDate),
                  subtitle: Text(
                    _endDate != null
                        ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                        : l10n.durationIndefinite,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _endDate != null
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_endDate != null)
                        IconButton(
                          icon: Icon(Icons.clear,
                              color: colorScheme.error, size: 18),
                          onPressed: () => setState(() => _endDate = null),
                        ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          _endDate ?? _startDate.add(const Duration(days: 30)),
                      firstDate: _startDate,
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (picked != null) setState(() => _endDate = picked);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

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
                      : Text(l10n.reminderDisabled),
                ),
                Switch(
                  value: _reminderEnabled,
                  activeColor: _selectedColor,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _reminderEnabled = value);
                  },
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

    String targetText = '';
    if (_habitType == HabitType.numerical) {
      final unit = _unitController.text.trim();
      targetText = '${_targetController.text} ${unit.isNotEmpty ? unit : ''}';
    } else if (_habitType == HabitType.timer) {
      targetText = '${_timerDuration.inMinutes} ${l10n.minLabel}';
    } else if (_habitType == HabitType.subtasks) {
      final count =
          _subtaskControllers.where((c) => c.text.trim().isNotEmpty).length;
      targetText = '$count subtasks';
    }

    final habitName = _nameController.text.trim().isEmpty
        ? l10n.habitNamePlaceholder
        : _nameController.text.trim();

    final List<String> tags = [
      if (targetText.isNotEmpty) targetText,
      _getFrequencyText(),
      if (_reminderEnabled) '🔔 ${_reminderTime.format(context)}',
    ];

    return WizardPage(
      emoji: '🎉',
      title: l10n.simpleHabitPreviewTitle,
      subtitle: l10n.simpleHabitPreviewSubtitle,
      bottomWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saveHabit,
            style: FilledButton.styleFrom(
              backgroundColor: _selectedColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.createHabit,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 20),
              ],
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          WizardPreviewCard(
            emoji: _selectedEmoji,
            title: habitName,
            subtitle: _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
            color: _selectedColor,
            tags: tags,
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
