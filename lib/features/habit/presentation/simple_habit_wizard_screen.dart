import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widgets/wizard_base_widgets.dart';
import '../domain/habit_model.dart';
import '../domain/habit_types.dart';

/// Basit alışkanlık oluşturma wizard'ı
/// Kullanıcıyı adım adım yönlendiren, konuşma tarzı akış
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

  // Page indices
  static const int _frequencyPage = 4;
  static const int _startDatePage = 6;

  // Total pages (dinamik olarak hesaplanacak)
  int get _totalPages {
    // Sıklığa göre gün seçimi sayfası gösterilecek mi?
    if (_selectedFrequency == 'daily') {
      return 8; // Gün seçimi sayfası yok
    }
    return 9; // Gün seçimi sayfası var
  }

  // Renk paleti
  // Pastel Renk paleti
  static const List<Color> _colors = [
    Color(0xFF90CAF9), // Pastel Blue
    Color(0xFFB39DDB), // Pastel Indigo
    Color(0xFFF48FB1), // Pastel Pink
    Color(0xFFFFCC80), // Pastel Orange
    Color(0xFFFFF59D), // Pastel Yellow
    Color(0xFFA5D6A7), // Pastel Green
    Color(0xFF80CBC4), // Pastel Teal
    Color(0xFFEF9A9A), // Pastel Red
    Color(0xFFBCAAA4), // Pastel Brown
    Color(0xFF9FA8DA), // Pastel Periwinkle
  ];

  // Emoji kategorileri
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

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      int nextPage = _currentPage + 1;

      // Sıklık sayfasındayken (page 4) ve günlük seçiliyse gün seçimi sayfasını (page 5) atla
      if (_currentPage == _frequencyPage && _selectedFrequency == 'daily') {
        nextPage = _currentPage + 2; // page 5'i atlayıp page 6'ya git
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

      // Günlük seçiliyse gün seçimi sayfasını atla (geri giderken)
      if (_currentPage == _startDatePage && _selectedFrequency == 'daily') {
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

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _saveHabit() async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

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
      reminderEnabled: _reminderEnabled,
      reminderTime: _reminderEnabled ? _reminderTime : null,
    );

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

          // 1: İsim sayfası
          _buildNamePage(),

          // 2: Emoji sayfası
          _buildEmojiPage(),

          // 3: Renk sayfası
          _buildColorPage(),

          // 4: Sıklık sayfası
          _buildFrequencyPage(),

          // 5: Gün seçimi sayfası (koşullu)
          _buildDaysPage(),

          // 6: Başlangıç tarihi sayfası
          _buildStartDatePage(),

          // 7: Hatırlatıcı sayfası
          _buildReminderPage(),

          // 8: Önizleme sayfası
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    final l10n = AppLocalizations.of(context);
    return WizardWelcomePage(
      emoji: '🌟',
      title: l10n.simpleHabitWizardTitle,
      description: l10n.simpleHabitWizardDesc,
      buttonText: l10n.letsStart,
      onStart: _nextPage,
      accentColor: _selectedColor,
    );
  }

  Widget _buildNamePage() {
    final l10n = AppLocalizations.of(context);
    final isValid = _nameController.text.trim().isNotEmpty;

    return WizardPage(
      emoji: '✏️',
      title: l10n.simpleHabitNameTitle,
      subtitle: l10n.simpleHabitNameSubtitle,
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
          // Açıklama (isteğe bağlı)
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
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
    );
  }

  Widget _buildEmojiPage() {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return WizardPage(
      emoji: '🎨',
      title: l10n.simpleHabitEmojiTitle,
      subtitle: l10n.simpleHabitEmojiSubtitle,
      child: Wrap(
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
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
    );
  }

  Widget _buildColorPage() {
    final l10n = AppLocalizations.of(context);

    return WizardPage(
      emoji: '🌈',
      title: l10n.simpleHabitColorTitle,
      subtitle: l10n.simpleHabitColorSubtitle,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
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
              width: isSelected ? 56 : 48,
              height: isSelected ? 56 : 48,
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
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
      ),
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
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
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
      child: content,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _selectedColor,
      ),
    );
  }

  Widget _buildStartDatePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final quickDates = [
      (today, l10n.today, '📍'),
      (tomorrow, l10n.tomorrow, '➡️'),
      (nextWeek, l10n.nextWeek, '📆'),
    ];

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    return WizardPage(
      emoji: '🚀',
      title: l10n.simpleHabitStartDateTitle,
      subtitle: l10n.simpleHabitStartDateSubtitle,
      child: Column(
        children: [
          // Hızlı seçenekler
          ...quickDates.map((qd) {
            final isSelected = isSameDay(_startDate, qd.$1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _startDate = qd.$1);
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
                      Text(qd.$3, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 16),
                      Text(
                        qd.$2,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: _selectedColor),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          // Takvimden seç butonu
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _startDate = picked);
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(l10n.pickFromCalendar),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _selectedColor,
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
      child: Column(
        children: [
          // Toggle
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

          // Saat seçici
          if (_reminderEnabled) ...[
            const SizedBox(height: 20),
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
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: _selectedColor),
                    const SizedBox(width: 12),
                    Text(
                      _reminderTime.format(context),
                      style: theme.textTheme.headlineSmall?.copyWith(
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
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        onSkip: _nextPage,
        showSkip: !_reminderEnabled,
        accentColor: _selectedColor,
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
      child: Column(
        children: [
          // Önizleme kartı
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

          const SizedBox(height: 24),

          // Detaylar
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
              ],
            ),
          ),
        ],
      ),
      bottomWidget: WizardNavigationButtons(
        onNext: _saveHabit,
        nextLabel: l10n.createHabit,
        isLastStep: true,
        accentColor: _selectedColor,
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
        title: const Text('Özel Emoji'),
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
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              if (customEmoji != null) {
                setState(() => _selectedEmoji = customEmoji!);
              }
              Navigator.pop(context);
            },
            child: const Text('Seç'),
          ),
        ],
      ),
    );
  }
}
