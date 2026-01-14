import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../domain/habit_model.dart';
import '../domain/habit_types.dart';
import '../domain/subtask_model.dart';

/// Gelişmiş alışkanlık oluşturma wizard'ı
/// Kullanıcıyı adım adım yönlendiren, konuşma tarzı akış
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

  // Hedef tipi
  NumericalTargetType _numericalTargetType = NumericalTargetType.minimum;
  final TimerTargetType _timerTargetType = TimerTargetType.minimum;
  Duration _timerDuration = const Duration(minutes: 30);

  // Subtasks
  final List<TextEditingController> _subtaskControllers = [];

  // Page indices
  static const int _frequencyPage = 5;
  static const int _daysPage = 6;

  // Renk paleti
  // Pastel Renk paleti
  // Renk paleti - Genişletilmiş
  static const List<Color> _colors = [
    // Pastels
    Color(0xFFEF9A9A), // Red 200
    Color(0xFFF48FB1), // Pink 200
    Color(0xFFCE93D8), // Purple 200
    Color(0xFFB39DDB), // Deep Purple 200
    Color(0xFF9FA8DA), // Indigo 200
    Color(0xFF90CAF9), // Blue 200
    Color(0xFF81D4FA), // Light Blue 200
    Color(0xFF80CBC4), // Teal 200
    Color(0xFFA5D6A7), // Green 200
    Color(0xFFC5E1A5), // Light Green 200
    Color(0xFFFFCC80), // Orange 200
    Color(0xFFFFAB91), // Deep Orange 200
    Color(0xFFBCAAA4), // Brown 200
    Color(0xFFB0BEC5), // Blue Grey 200
    // Vibrants
    Color(0xFFEF4444), // Red 500
    Color(0xFFEC4899), // Pink 500
    Color(0xFFA855F7), // Purple 500
    Color(0xFF6366F1), // Indigo 500
    Color(0xFF3B82F6), // Blue 500
    Color(0xFF0EA5E9), // Sky 500
    Color(0xFF14B8A6), // Teal 500
    Color(0xFF22C55E), // Green 500
    Color(0xFFEAB308), // Yellow 500
    Color(0xFFF97316), // Orange 500
    Color(0xFFF43F5E), // Rose 500
    Color(0xFF78716C), // Stone 500
    // Deep/Dark
    Color(0xFFB91C1C), // Red 700
    Color(0xFFBE185D), // Pink 700
    Color(0xFF7E22CE), // Purple 700
    Color(0xFF4338CA), // Indigo 700
    Color(0xFF1D4ED8), // Blue 700
    Color(0xFF0F766E), // Teal 700
    Color(0xFF15803D), // Green 700
    Color(0xFFA16207), // Yellow 700
    Color(0xFFC2410C), // Orange 700
    Color(0xFF374151), // Gray 700
  ];

  // Emoji kategorileri
  static const List<String> _quickEmojis = [
    '🎯',
    '📊',
    '⏱️',
    '✅',
    '💪',
    '🏃',
    '📚',
    '💧',
    '🧘',
    '💤',
    '🍎',
    '🏋️',
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

  int get _totalPages {
    // Sıklığa göre gün seçimi sayfası logic ile atlanıyor ama
    // PageView children sayısı sabittir. Navigation logic'i _nextPage içinde yönetildiği için
    // burası toplam sayfa sayısını (children length) dönmelidir.
    return 10;
  }

  @override
  void initState() {
    super.initState();
    // Varsayılan 1 subtask ekle
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

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      int nextPage = _currentPage + 1;

      // Sıklık sayfasından çıkarken daily seçiliyse gün seçimi sayfasını atla
      if (_currentPage == _frequencyPage && _selectedFrequency == 'daily') {
        nextPage = _currentPage + 2;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      int prevPage = _currentPage - 1;

      // Tarih sayfasından geriye giderken daily seçiliyse gün seçimi sayfasını atla
      if (_currentPage == _daysPage + 1 && _selectedFrequency == 'daily') {
        prevPage = _currentPage - 2;
      }

      _pageController.animateToPage(
        prevPage,
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

    // Parse target
    int targetCount = 1;
    if (_habitType == HabitType.numerical) {
      targetCount = int.tryParse(_targetController.text) ?? 1;
    } else if (_habitType == HabitType.timer) {
      targetCount = _timerDuration.inMinutes;
    } else if (_habitType == HabitType.simple) {
      targetCount = 1;
    }

    // Build subtasks if applicable
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
      unit: _habitType == HabitType.numerical
          ? _unitController.text.trim()
          : '',
      currentStreak: 0,
      isCompleted: false,
      progressDate: dateStr,
      frequencyType: _selectedFrequency,
      frequency: _getFrequencyText(),
      selectedWeekdays: _selectedFrequency == 'weekly'
          ? _weeklyDays.toList()
          : null,
      selectedMonthDays: _selectedFrequency == 'monthly'
          ? _monthDays.toList()
          : null,
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

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      currentStep: _currentPage,
      totalSteps: _totalPages,
      showProgress: _currentPage > 0,
      onBack: _previousPage,
      onClose: () => Navigator.pop(context),
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 0: Karşılama sayfası
          _buildWelcomePage(),

          // 1: Tip seçimi sayfası
          _buildTypePage(),

          // 2: İsim sayfası
          _buildNamePage(),

          // 3: Emoji sayfası
          _buildEmojiPage(),

          // 4: Hedef ayarları sayfası (tipe göre değişir)
          _buildTargetPage(),

          // 5: Sıklık sayfası
          _buildFrequencyPage(),

          // 6: Gün seçimi sayfası (koşullu)
          _buildDaysPage(),

          // 7: Tarih aralığı sayfası
          _buildDateRangePage(),

          // 8: Hatırlatıcı sayfası
          _buildReminderPage(),

          // 9: Önizleme sayfası
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    final l10n = AppLocalizations.of(context);
    return WizardWelcomePage(
      emoji: '🚀',
      title: l10n.advancedHabitTitle,
      description: l10n.advancedAnalysisAndReports,
      buttonText: l10n.letsStart,
      onStart: _nextPage,
      accentColor: _selectedColor,
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

  Widget _buildEmojiPage() {
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
                  size: 56,
                  borderRadius: 14,
                  selectedColor: _selectedColor,
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                );
              }),
              // Özel emoji ekle butonu
              WizardSelectionCard(
                isSelected: false,
                onTap: _showCustomEmojiInput,
                size: 56,
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
          // Renk seçimi de burada gösterelim
          Text(
            l10n.simpleHabitColorTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
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
                  width: isSelected ? 44 : 36,
                  height: isSelected ? 44 : 36,
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

  Widget _buildTargetPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content;
    String title;
    String subtitle;

    switch (_habitType) {
      case HabitType.numerical:
        title = l10n.numericalGoalShort;
        subtitle = l10n.enterValueTitle;
        content = Column(
          children: [
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
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _unitController,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                    decoration: InputDecoration(
                      hintText: l10n.customUnitHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Hedef tipi seçimi
            _buildTargetTypeSelector(),
          ],
        );
        break;

      case HabitType.timer:
        title = l10n.duration;
        subtitle = l10n.timerPendingLabel('');
        content = Column(
          children: [
            Text(
              '${_timerDuration.inMinutes} ${l10n.minLabel}',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _selectedColor,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: _timerDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  // TimerPicker 0 seçilmesine izin veriyor ama habits için mantıksız olabilir,
                  // fakat kullanıcı deneyimi için anlık tepki verelim, validasyon butonda yapılır.
                  setState(() => _timerDuration = newDuration);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.duration,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        );
        break;

      case HabitType.subtasks:
        title = l10n.subtasks;
        subtitle = l10n.addSubtask;
        content = Column(
          children: [
            ...List.generate(_subtaskControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    if (_subtaskControllers.length > 1)
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: colorScheme.error,
                        ),
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
              label: Text(
                l10n.addSubtask,
                style: TextStyle(color: _selectedColor),
              ),
            ),
          ],
        );
        break;

      default:
        title = l10n.checkboxType;
        subtitle = l10n.checkboxTypeDesc;
        content = Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _selectedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 64, color: _selectedColor),
              const SizedBox(height: 16),
              Text(
                l10n.dailyCheck,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }

    bool isValid = true;
    if (_habitType == HabitType.numerical) {
      isValid = (int.tryParse(_targetController.text) ?? 0) > 0;
    } else if (_habitType == HabitType.subtasks) {
      isValid = _subtaskControllers.any((c) => c.text.trim().isNotEmpty);
    }

    return WizardPage(
      emoji: _habitType == HabitType.timer ? '⏱️' : '🎯',
      title: title,
      subtitle: subtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
      child: content,
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _numericalTargetType = type.$1);
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.$2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
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

  Widget _buildFrequencyPage() {
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
        accentColor: _selectedColor,
      ),
      child: Column(
        children: frequencies.map((freq) {
          final isSelected = _selectedFrequency == freq.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedFrequency = freq.$1);
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
                    Text(freq.$3, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            freq.$2,
                            style: theme.textTheme.titleMedium?.copyWith(
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

  Widget _buildDaysPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content;
    String title;
    String subtitle;

    switch (_selectedFrequency) {
      case 'weekly':
        title = l10n.simpleHabitWeekdaysTitle;
        subtitle = l10n.simpleHabitWeekdaysSubtitle;
        final weekdays = [
          l10n.mondayShort,
          l10n.tuesdayShort,
          l10n.wednesdayShort,
          l10n.thursdayShort,
          l10n.fridayShort,
          l10n.saturdayShort,
          l10n.sundayShort,
        ];
        content = Wrap(
          spacing: 12,
          runSpacing: 12,
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
                width: 48,
                height: 48,
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
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
        break;

      case 'monthly':
        title = l10n.simpleHabitMonthDaysTitle;
        subtitle = l10n.simpleHabitMonthDaysSubtitle;
        content = Wrap(
          spacing: 8,
          runSpacing: 8,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
        break;

      case 'periodic':
        title = l10n.simpleHabitPeriodicTitle;
        subtitle = l10n.simpleHabitPeriodicSubtitle;
        content = Column(
          children: [
            Text(
              '$_periodicDays',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _selectedColor,
              ),
            ),
            Text(
              l10n.days,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
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
        break;

      default:
        title = '';
        subtitle = '';
        content = const SizedBox.shrink();
    }

    bool isValid = true;
    if (_selectedFrequency == 'weekly') {
      isValid = _weeklyDays.isNotEmpty;
    } else if (_selectedFrequency == 'monthly') {
      isValid = _monthDays.isNotEmpty;
    }

    return WizardPage(
      emoji: '📅',
      title: title,
      subtitle: subtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
      child: content,
    );
  }

  Widget _buildDateRangePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WizardPage(
      emoji: '📆',
      title: l10n.dateRangeLabel,
      subtitle: l10n.simpleHabitStartDateSubtitle,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
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
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _startDate = picked);
              }
            },
          ),
          const Divider(),
          // Bitiş tarihi (isteğe bağlı)
          ListTile(
            leading: Icon(Icons.stop, color: colorScheme.error),
            title: Text(l10n.endDate),
            subtitle: Text(
              _endDate != null
                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                  : l10n.durationIndefinite,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_endDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.error),
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
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (picked != null) {
                setState(() => _endDate = picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReminderPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WizardPage(
      emoji: '🔔',
      title: l10n.simpleHabitReminderTitle,
      subtitle: l10n.simpleHabitReminderSubtitle,
      isOptional: true,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        onSkip: _nextPage,
        showSkip: !_reminderEnabled,
        accentColor: _selectedColor,
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _reminderEnabled
                  ? _selectedColor.withOpacity(0.1)
                  : colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: _reminderEnabled
                  ? Border.all(color: _selectedColor, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _reminderEnabled
                        ? _selectedColor.withOpacity(0.2)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _reminderEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off_outlined,
                    color: _reminderEnabled
                        ? _selectedColor
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _reminderEnabled
                        ? l10n.reminderEnabled
                        : l10n.reminderDisabled,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          if (_reminderEnabled) ...[
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime,
                );
                if (picked != null) {
                  setState(() => _reminderTime = picked);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, color: _selectedColor),
                    const SizedBox(width: 12),
                    Text(
                      _reminderTime.format(context),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _selectedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      final count = _subtaskControllers
          .where((c) => c.text.trim().isNotEmpty)
          .length;
      targetText = '$count subtasks';
    }

    // Build tags list
    final List<String> tags = [
      if (targetText.isNotEmpty) targetText,
      _getFrequencyText(),
      '${l10n.startsOn}: ${_startDate.day}/${_startDate.month}/${_startDate.year}',
      if (_reminderEnabled) _reminderTime.format(context),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 20),
              ],
            ),
          ),
        ),
      ),
      child: WizardPreviewCard(
        emoji: _selectedEmoji,
        title: _nameController.text.trim(),
        subtitle: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        color: _selectedColor,
        tags: tags,
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
            // Sadece ilk karakteri/emojiyi al
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
