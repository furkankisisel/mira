import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/utils/emoji_presets.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/wizard_base_widgets.dart';
import 'data/finance_category.dart';
import 'data/finance_category_repository.dart';
import 'data/transaction_model.dart';
import 'data/transaction_repository.dart';

/// Finans işlemi oluşturma wizard'ı
/// Kullanıcıyı adım adım yönlendiren, konuşma tarzı akış
class FinanceWizardScreen extends StatefulWidget {
  const FinanceWizardScreen({
    super.key,
    required this.repo,
    required this.catRepo,
    this.initialType = TransactionType.expense,
    this.existing,
  });

  final TransactionRepository repo;
  final FinanceCategoryRepository catRepo;
  final TransactionType initialType;
  final FinanceTransaction? existing;

  @override
  State<FinanceWizardScreen> createState() => _FinanceWizardScreenState();
}

class _FinanceWizardScreenState extends State<FinanceWizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Wizard data
  TransactionType _type = TransactionType.expense;
  FinanceCategory? _selectedCategory;
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  bool _recurringForever = true;
  int _recurringMonths = 12;

  // Total pages
  static const int _totalPages = 6;

  // Accent colors
  Color get _accentColor => _type == TransactionType.income
      ? const Color(0xFF22C55E) // Green for income
      : const Color(0xFFEF4444); // Red for expense

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final tx = widget.existing!;
      _type = tx.type;
      _titleCtrl.text = tx.title;
      _amountCtrl.text = NumberFormat.decimalPattern(
        Localizations.localeOf(context).toString(),
      ).format(tx.amount);
      _selectedDate = tx.date;
      _isRecurring = tx.isRecurring;
      _recurringForever = tx.recurringForever;
      _recurringMonths = tx.recurringMonths ?? 12;

      // Try to match category synchronously if possible
      try {
        final cats = widget.catRepo.byType(_type);
        if (cats.isNotEmpty && tx.categoryId != null) {
          _selectedCategory = cats.firstWhere(
            (c) => c.id == tx.categoryId,
            orElse: () => cats.first,
          );
        }
      } catch (e) {
        // ignore
      }
    } else {
      _type = widget.initialType;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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

  double _parsedAmount() {
    final localeName = Localizations.localeOf(context).toString();
    final raw = _amountCtrl.text.trim();
    try {
      final num parsed = NumberFormat.decimalPattern(localeName).parse(raw);
      return parsed.toDouble();
    } catch (_) {
      final normalized = raw
          .replaceAll(RegExp('[^0-9.,-]'), '')
          .replaceAll('.', '')
          .replaceAll(',', '.');
      return double.tryParse(normalized) ?? 0;
    }
  }

  Future<void> _saveTransaction() async {
    final tx = FinanceTransaction(
      id: widget.existing?.id ?? 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      amount: _parsedAmount(),
      date: _selectedDate,
      type: _type,
      categoryId: _selectedCategory?.id,
      isRecurring: _isRecurring,
      recurringForever: _recurringForever,
      recurringMonths: _isRecurring && !_recurringForever
          ? _recurringMonths
          : null,
    );

    if (widget.existing != null) {
      await widget.repo.update(tx);
    } else {
      await widget.repo.add(tx);
    }

    if (mounted) {
      Navigator.pop(context, tx);
    }
  }

  Future<FinanceCategory?> _createNewCategory(
    BuildContext context,
    TransactionType type,
  ) async {
    final nameCtrl = TextEditingController();
    final emojiCtrl = TextEditingController();
    String? selectedEmoji;

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(ctx).newCategory,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  // Emoji Picker Section
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: emojiCtrl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '😊',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          if (v.characters.length > 1) {
                            emojiCtrl.text = v.characters.last;
                            emojiCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: emojiCtrl.text.length),
                            );
                          }
                          setSheetState(() {
                            selectedEmoji = emojiCtrl.text;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      AppLocalizations.of(ctx).chooseEmoji.replaceAll(':', ''),
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(ctx).categoryName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(ctx).quickSuggestions,
                    style: Theme.of(ctx).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: SingleChildScrollView(
                      child: _EmojiGrid(
                        selectedEmoji: selectedEmoji,
                        onSelect: (e) => setSheetState(() {
                          selectedEmoji = e;
                          emojiCtrl.text = e;
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(AppLocalizations.of(ctx).cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty ||
                              (selectedEmoji == null ||
                                  selectedEmoji!.isEmpty)) {
                            return;
                          }
                          Navigator.pop(ctx, true);
                        },
                        child: Text(AppLocalizations.of(ctx).create),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (created == true) {
      final cat = FinanceCategory(
        id: 'user_${DateTime.now().microsecondsSinceEpoch}',
        name: nameCtrl.text.trim(),
        iconCodePoint: Icons.category.codePoint,
        emoji: selectedEmoji,
        type: type,
        colorValue: type == TransactionType.income
            ? const Color(0xFF22C55E).value
            : const Color(0xFFEF4444).value,
      );
      await widget.catRepo.add(cat);
      return cat;
    }
    return null;
  }

  Future<void> _showCategoryActions(
    BuildContext context,
    FinanceCategory cat,
  ) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(AppLocalizations.of(ctx).editCategory),
              onTap: () {
                Navigator.pop(ctx);
                _editCategory(context, cat);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red[600]),
              title: Text(
                AppLocalizations.of(ctx).deleteCategoryTitle,
                style: TextStyle(color: Colors.red[600]),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed =
                    await showDialog<bool>(
                      context: context,
                      builder: (dctx) => AlertDialog(
                        title: Text(AppLocalizations.of(dctx).delete),
                        content: Text(
                          AppLocalizations.of(
                            dctx,
                          ).deleteCategoryConfirmNamed(cat.name),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dctx, false),
                            child: Text(AppLocalizations.of(dctx).cancel),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red[600],
                            ),
                            onPressed: () => Navigator.pop(dctx, true),
                            child: Text(AppLocalizations.of(dctx).delete),
                          ),
                        ],
                      ),
                    ) ??
                    false;
                if (confirmed) {
                  await widget.catRepo.remove(cat.id);
                  if (_selectedCategory?.id == cat.id) {
                    setState(() => _selectedCategory = null);
                  } else {
                    setState(() {});
                  }
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _editCategory(BuildContext context, FinanceCategory cat) async {
    final nameCtrl = TextEditingController(text: cat.name);
    final emojiCtrl = TextEditingController(text: cat.emoji ?? '');
    String? selectedEmoji = cat.emoji;
    int selectedIcon = cat.iconCodePoint;
    Color selectedColor = Color(cat.colorValue);

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(ctx).editCategory,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: emojiCtrl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '😊',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          if (v.characters.length > 1) {
                            emojiCtrl.text = v.characters.last;
                            emojiCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: emojiCtrl.text.length),
                            );
                          }
                          setSheetState(() {
                            selectedEmoji = emojiCtrl.text;
                            selectedIcon = Icons.category.codePoint;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(ctx).categoryName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Quick Suggestions',
                    style: Theme.of(ctx).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      child: _EmojiGrid(
                        selectedEmoji: selectedEmoji,
                        onSelect: (e) => setSheetState(() {
                          selectedEmoji = e;
                          emojiCtrl.text = e;
                          selectedIcon = Icons.category.codePoint;
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(AppLocalizations.of(ctx).cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) {
                            return;
                          }
                          Navigator.pop(ctx, true);
                        },
                        child: Text(AppLocalizations.of(ctx).update),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (updated == true) {
      final newCat = FinanceCategory(
        id: cat.id,
        name: nameCtrl.text.trim(),
        iconCodePoint: selectedIcon,
        emoji: selectedEmoji,
        type: cat.type,
        colorValue: selectedColor.value,
      );
      await widget.catRepo.update(newCat);
      if (_selectedCategory?.id == newCat.id) {
        setState(() => _selectedCategory = newCat);
      } else {
        setState(() {});
      }
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
          // 0: Karşılama + Tip seçimi
          _buildTypePage(),

          // 1: Kategori seçimi
          _buildCategoryPage(),

          // 2: Tutar girişi
          _buildAmountPage(),

          // 3: Tarih seçimi
          _buildDatePage(),

          // 4: Tekrarlama ayarları
          _buildRecurringPage(),

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

    return WizardPage(
      emoji: '💰',
      title: l10n.add,
      subtitle: l10n.category,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _accentColor,
      ),
      child: Column(
        children: [
          _buildTypeCard(
            type: TransactionType.expense,
            emoji: '💸',
            title: l10n.expenseLabel,
            description: l10n.trackSpending,
            color: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          // Income option
          _buildTypeCard(
            type: TransactionType.income,
            emoji: '💵',
            title: l10n.incomeLabel,
            description: l10n.trackEarnings,
            color: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required TransactionType type,
    required String emoji,
    required String title,
    required String description,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _type == type;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _type = type;
          _selectedCategory = null;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage() {
    final l10n = AppLocalizations.of(context);

    final categories = widget.catRepo.byType(_type);

    return WizardPage(
      emoji: '🏷️',
      title: l10n.category,
      subtitle: l10n.selectCategory,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: _selectedCategory != null,
        accentColor: _accentColor,
      ),
      child: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: _CategoryGrid(
            categories: categories,
            selected: _selectedCategory,
            onSelect: (cat) {
              HapticFeedback.lightImpact();
              setState(() => _selectedCategory = cat);
            },
            onLongPress: (cat) => _showCategoryActions(context, cat),
            onCreateNew: () async {
              final newCat = await _createNewCategory(context, _type);
              if (newCat != null) {
                setState(() => _selectedCategory = newCat);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAmountPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final currencyFmt = NumberFormat.simpleCurrency(locale: localeName);
    final currencySymbol = currencyFmt.currencySymbol;

    final isValid = _parsedAmount() > 0;

    return WizardPage(
      emoji: _type == TransactionType.income ? '💵' : '💸',
      title: l10n.amountLabel,
      subtitle: l10n.amountLabel,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _accentColor,
      ),
      child: Column(
        children: [
          // Amount input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currencySymbol,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: _accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _accentColor,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Optional title
          TextField(
            controller: _titleCtrl,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: l10n.titleOptional,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(
                0.3,
              ),
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

  Widget _buildDatePage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final dateOptions = [
      (l10n.today, today, Icons.today),
      (l10n.yesterday, yesterday, Icons.history),
      (l10n.pickFromCalendar, null, Icons.calendar_month),
    ];

    return WizardPage(
      emoji: '📅',
      title: l10n.date,
      subtitle: l10n.selectDate,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _accentColor,
      ),
      child: Column(
        children: dateOptions.map((option) {
          final isCalendar = option.$2 == null;
          final isSelected =
              !isCalendar &&
              _selectedDate.year == option.$2!.year &&
              _selectedDate.month == option.$2!.month &&
              _selectedDate.day == option.$2!.day;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () async {
                HapticFeedback.lightImpact();
                if (isCalendar) {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                } else {
                  setState(() => _selectedDate = option.$2!);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _accentColor.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: _accentColor, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(option.$3, color: isSelected ? _accentColor : null),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        isCalendar
                            ? '${option.$1}: ${DateFormat.yMMMd().format(_selectedDate)}'
                            : option.$1,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: _accentColor),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecurringPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WizardPage(
      emoji: '🔄',
      title: 'Recurring',
      subtitle: 'Make this a monthly transaction',
      isOptional: true,
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        onSkip: _nextPage,
        showSkip: !_isRecurring,
        accentColor: _accentColor,
      ),
      child: Column(
        children: [
          // Recurring toggle
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isRecurring
                  ? _accentColor.withOpacity(0.1)
                  : colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: _isRecurring
                  ? Border.all(color: _accentColor, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isRecurring
                        ? _accentColor.withOpacity(0.2)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _isRecurring ? Icons.repeat : Icons.repeat_outlined,
                    color: _isRecurring
                        ? _accentColor
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _isRecurring ? 'Recurring enabled' : 'One-time transaction',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: _isRecurring,
                  activeColor: _accentColor,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _isRecurring = value);
                  },
                ),
              ],
            ),
          ),
          if (_isRecurring) ...[
            const SizedBox(height: 24),
            // Duration options
            Row(
              children: [
                Expanded(
                  child: _buildDurationOption(
                    title: l10n.durationIndefinite,
                    isSelected: _recurringForever,
                    onTap: () => setState(() => _recurringForever = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDurationOption(
                    title: l10n.durationMonths(_recurringMonths),
                    isSelected: !_recurringForever,
                    onTap: () => setState(() => _recurringForever = false),
                  ),
                ),
              ],
            ),
            if (!_recurringForever) ...[
              const SizedBox(height: 16),
              Slider(
                value: _recurringMonths.toDouble(),
                min: 1,
                max: 24,
                divisions: 23,
                activeColor: _accentColor,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() => _recurringMonths = value.round());
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDurationOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _accentColor.withOpacity(0.1)
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: _accentColor, width: 2) : null,
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? _accentColor : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPreviewPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final currencyFmt = NumberFormat.simpleCurrency(locale: localeName);

    final formattedAmount = currencyFmt.format(_parsedAmount());
    final typeText = _type == TransactionType.income
        ? l10n.incomeLabel
        : l10n.expenseLabel;

    final tags = [
      typeText,
      DateFormat.yMMMd(localeName).format(_selectedDate),
      if (_isRecurring) 'Monthly',
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
            onPressed: _saveTransaction,
            style: FilledButton.styleFrom(
              backgroundColor: _accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.save,
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
      child: Column(
        children: [
          // Preview card
          WizardPreviewCard(
            emoji: _selectedCategory?.emoji ?? '💰',
            title: _titleCtrl.text.trim().isNotEmpty
                ? _titleCtrl.text.trim()
                : (_selectedCategory?.name ?? 'Transaction'),
            subtitle: formattedAmount,
            color: _accentColor,
            tags: tags,
          ),
          const SizedBox(height: 24),
          // Amount highlight
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  formattedAmount,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _accentColor.withOpacity(0.8),
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

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.selected,
    required this.onSelect,
    this.onLongPress,
    required this.onCreateNew,
  });

  final List<FinanceCategory> categories;
  final FinanceCategory? selected;
  final ValueChanged<FinanceCategory> onSelect;
  final ValueChanged<FinanceCategory>? onLongPress;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (final c in categories)
          GestureDetector(
            onLongPress: () => onLongPress?.call(c),
            child: ChoiceChip(
              selected: selected?.id == c.id,
              showCheckmark: false,
              avatar: null,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (c.hasEmoji)
                    Text(c.emoji!, style: const TextStyle(fontSize: 18))
                  else
                    Icon(c.icon, size: 18, color: Color(c.colorValue)),
                  const SizedBox(width: 8),
                  Text(c.name),
                ],
              ),
              onSelected: (_) => onSelect(c),
            ),
          ),

        // Prominent "New Category" Button
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            onTap: onCreateNew,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context).newCategory,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({required this.selectedEmoji, required this.onSelect});

  final String? selectedEmoji;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        const tileSize = 44.0;
        const spacing = 8.0;
        int cols = ((constraints.maxWidth + spacing) / (tileSize + spacing))
            .floor();
        cols = cols.clamp(4, 12);
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: cols * tileSize + (cols - 1) * spacing,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: 1,
              ),
              itemCount: kEmojiPresets.length,
              itemBuilder: (context, i) {
                final e = kEmojiPresets[i];
                final isSel = selectedEmoji == e;
                return InkWell(
                  onTap: () => onSelect(e),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSel
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
