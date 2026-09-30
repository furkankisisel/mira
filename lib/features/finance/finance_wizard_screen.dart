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

/// Finans işlemi oluşturma wizard'ı - Cotton Design System 4 adımlı akış
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

  static const int _totalPages = 4;

  Color get _accentColor => _type == TransactionType.income
      ? const Color(0xFF10B981)
      : const Color(0xFFF43F5E);

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

      try {
        final cats = widget.catRepo.byType(_type);
        if (cats.isNotEmpty && tx.categoryId != null) {
          _selectedCategory = cats.firstWhere(
            (c) => c.id == tx.categoryId,
            orElse: () => cats.first,
          );
        }
      } catch (_) {}
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
    HapticFeedback.lightImpact();
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
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

  void _quickAddAmount(double add) {
    HapticFeedback.selectionClick();
    final current = _parsedAmount();
    final updated = current + add;
    final localeName = Localizations.localeOf(context).toString();
    _amountCtrl.text = NumberFormat.decimalPattern(localeName).format(updated);
    setState(() {});
  }

  Future<void> _saveTransaction() async {
    HapticFeedback.mediumImpact();
    final tx = FinanceTransaction(
      id: widget.existing?.id ?? 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim().isNotEmpty
          ? _titleCtrl.text.trim()
          : (_selectedCategory?.name ?? 'İşlem'),
      amount: _parsedAmount(),
      date: _selectedDate,
      type: _type,
      categoryId: _selectedCategory?.id,
      isRecurring: _isRecurring,
      recurringForever: _recurringForever,
      recurringMonths:
          _isRecurring && !_recurringForever ? _recurringMonths : null,
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
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final scheme = Theme.of(ctx).colorScheme;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E24) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 14,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(ctx).newCategory,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                                : Colors.black.withValues(alpha: 0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.primary.withValues(alpha: 0.3),
                              width: 1.5,
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
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.03),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(ctx).quickSuggestions,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 140,
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(AppLocalizations.of(ctx).cancel),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if (nameCtrl.text.trim().isEmpty ||
                                  (selectedEmoji == null || selectedEmoji!.isEmpty)) {
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
          );
        },
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
            ? const Color(0xFF10B981).value
            : const Color(0xFFF43F5E).value,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SafeArea(
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
                leading: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E)),
                title: Text(
                  AppLocalizations.of(ctx).deleteCategoryTitle,
                  style: const TextStyle(color: Color(0xFFF43F5E)),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(AppLocalizations.of(dctx).delete),
                          content: Text(
                            AppLocalizations.of(dctx)
                                .deleteCategoryConfirmNamed(cat.name),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dctx, false),
                              child: Text(AppLocalizations.of(dctx).cancel),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF43F5E),
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
            ],
          ),
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
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final scheme = Theme.of(ctx).colorScheme;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E24) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 14,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(ctx).editCategory,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                                : Colors.black.withValues(alpha: 0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.primary.withValues(alpha: 0.3),
                              width: 1.5,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.03),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hızlı Öneriler',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(AppLocalizations.of(ctx).cancel),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if (nameCtrl.text.trim().isEmpty) return;
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
          );
        },
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
          _buildTypeCategoryPage(),
          _buildTitleAmountPage(),
          _buildDateRecurringPage(),
          _buildPreviewPage(),
        ],
      ),
    );
  }

  Widget _buildTypeCategoryPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final categories = widget.catRepo.byType(_type);

    return WizardPage(
      emoji: _type == TransactionType.income ? '💵' : '💸',
      title: _type == TransactionType.income ? 'Gelir Ekle' : 'Gider Ekle',
      subtitle: 'Tür ve Kategori Seçimi',
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: _selectedCategory != null,
        accentColor: _accentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Tip Seçimi ───
          Row(
            children: [
              Expanded(
                child: _buildTypeCard(
                  type: TransactionType.expense,
                  emoji: '💸',
                  title: l10n.expenseLabel,
                  description: l10n.trackSpending,
                  color: const Color(0xFFF43F5E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeCard(
                  type: TransactionType.income,
                  emoji: '💵',
                  title: l10n.incomeLabel,
                  description: l10n.trackEarnings,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─── Kategori Seçimi ───
          Text(
            l10n.category,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          _CategoryGrid(
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
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _type == type;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _type = type;
          _selectedCategory = null;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.18 : 0.1)
              : (isDark
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : Colors.grey.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: isSelected ? color : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAmountPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localeName = Localizations.localeOf(context).toString();
    final currencyFmt = NumberFormat.simpleCurrency(locale: localeName);
    final currencySymbol = currencyFmt.currencySymbol;

    final isValid = _parsedAmount() > 0;

    return WizardPage(
      emoji: '💳',
      title: l10n.amountLabel,
      subtitle: 'Tutar ve İşlem Başlığı',
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        isNextEnabled: isValid,
        accentColor: _accentColor,
      ),
      child: Column(
        children: [
          // ─── Tutar Girişi Hero Card ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _accentColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currencySymbol,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: _accentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: IntrinsicWidth(
                        child: TextField(
                          controller: _amountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            color: _accentColor,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quick Increment Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [50, 100, 250, 500, 1000].map((v) {
                    return ActionChip(
                      label: Text('+$v$currencySymbol'),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () => _quickAddAmount(v.toDouble()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── İsim Girişi ───
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.nameLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            decoration: InputDecoration(
              hintText: _selectedCategory != null
                  ? '${_selectedCategory!.name} harcaması'
                  : l10n.titleOptional,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark
                  ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.08),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
            onSubmitted: (_) => _nextPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRecurringPage() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return WizardPage(
      emoji: '📅',
      title: l10n.date,
      subtitle: 'Tarih ve Tekrarlama Sıklığı',
      bottomWidget: WizardNavigationButtons(
        onNext: _nextPage,
        accentColor: _accentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Tarih Seçimi ───
          Text(
            l10n.date,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildDateChip(
                label: l10n.today,
                date: today,
                icon: Icons.today_rounded,
              ),
              const SizedBox(width: 8),
              _buildDateChip(
                label: l10n.yesterday,
                date: yesterday,
                icon: Icons.history_rounded,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                          : Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 20, color: colorScheme.primary),
                        const SizedBox(height: 3),
                        Text(
                          DateFormat.MMMd().format(_selectedDate),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─── Tekrarlama ───
          Text(
            'Tekrarlama',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isRecurring
                  ? _accentColor.withValues(alpha: 0.1)
                  : (isDark
                      ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                      : Colors.grey.withValues(alpha: 0.08)),
              borderRadius: BorderRadius.circular(18),
              border: _isRecurring ? Border.all(color: _accentColor, width: 1.5) : null,
            ),
            child: Row(
              children: [
                Icon(
                  _isRecurring ? Icons.repeat_rounded : Icons.repeat_one_rounded,
                  color: _isRecurring ? _accentColor : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isRecurring ? 'Aylık Tekrarlayan İşlem' : 'Tek Seferlik İşlem',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _isRecurring ? _accentColor : null,
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
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildDurationOption(
                    title: l10n.durationIndefinite,
                    isSelected: _recurringForever,
                    onTap: () => setState(() => _recurringForever = true),
                  ),
                ),
                const SizedBox(width: 10),
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
              const SizedBox(height: 10),
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

  Widget _buildDateChip({
    required String label,
    required DateTime date,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedDate = date);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? _accentColor.withValues(alpha: 0.12)
                : (isDark
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(14),
            border: isSelected ? Border.all(color: _accentColor, width: 1.5) : null,
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? _accentColor : colorScheme.onSurfaceVariant),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 11,
                  color: isSelected ? _accentColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _accentColor.withValues(alpha: 0.12)
              : (isDark
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : Colors.grey.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? Border.all(color: _accentColor, width: 1.5) : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            fontSize: 13,
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
    final isDark = theme.brightness == Brightness.dark;
    final localeName = Localizations.localeOf(context).toString();
    final currencyFmt = NumberFormat.simpleCurrency(locale: localeName);

    final formattedAmount = currencyFmt.format(_parsedAmount());
    final typeText =
        _type == TransactionType.income ? l10n.incomeLabel : l10n.expenseLabel;

    final tags = [
      typeText,
      DateFormat.yMMMd(localeName).format(_selectedDate),
      if (_isRecurring) 'Aylık Tekrarlayan',
    ];

    return WizardPage(
      emoji: '✨',
      title: 'İşlem Özeti',
      subtitle: 'Bilgileri Kontrol Edin ve Kaydedin',
      bottomWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saveTransaction,
            style: FilledButton.styleFrom(
              backgroundColor: _accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.save,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          WizardPreviewCard(
            emoji: _selectedCategory?.emoji ?? '💰',
            title: _titleCtrl.text.trim().isNotEmpty
                ? _titleCtrl.text.trim()
                : (_selectedCategory?.name ?? 'İşlem'),
            subtitle: formattedAmount,
            color: _accentColor,
            tags: tags,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? _accentColor.withValues(alpha: 0.12)
                  : _accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '${_type == TransactionType.income ? '+' : '-'}$formattedAmount',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeText,
                  style: TextStyle(
                    color: _accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
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
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (c.hasEmoji)
                    Text(c.emoji!, style: const TextStyle(fontSize: 17))
                  else
                    Icon(c.icon, size: 17, color: Color(c.colorValue)),
                  const SizedBox(width: 8),
                  Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              onSelected: (_) => onSelect(c),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            onTap: onCreateNew,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context).newCategory,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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
        int cols =
            ((constraints.maxWidth + spacing) / (tileSize + spacing)).floor();
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
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSel
                          ? scheme.primary.withValues(alpha: 0.2)
                          : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: isSel
                          ? Border.all(color: scheme.primary, width: 1.5)
                          : null,
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
