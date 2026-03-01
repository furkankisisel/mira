import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import 'data/finance_category.dart';
import 'data/finance_category_repository.dart';
import 'data/transaction_model.dart';
import 'data/transaction_repository.dart';
import '../../core/utils/emoji_presets.dart';

/// Finans işlemi düzenleme ekranı - Tek sayfa düzeni
class FinanceEditScreen extends StatefulWidget {
  const FinanceEditScreen({
    super.key,
    required this.repo,
    required this.catRepo,
    required this.transaction,
  });

  final TransactionRepository repo;
  final FinanceCategoryRepository catRepo;
  final FinanceTransaction transaction;

  @override
  State<FinanceEditScreen> createState() => _FinanceEditScreenState();
}

class _FinanceEditScreenState extends State<FinanceEditScreen> {
  // Controllers
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _scrollController = ScrollController();

  // State
  TransactionType _type = TransactionType.expense;
  FinanceCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  bool _recurringForever = true;
  int _recurringMonths = 12;

  // Accent colors
  Color get _accentColor => _type == TransactionType.income
      ? const Color(0xFF22C55E) // Green for income
      : const Color(0xFFEF4444); // Red for expense

  @override
  void initState() {
    super.initState();
    _loadExistingTransaction();
  }

  void _loadExistingTransaction() {
    final tx = widget.transaction;
    _type = tx.type;
    _titleCtrl.text = tx.title;
    _amountCtrl.text = tx.amount.toStringAsFixed(2);
    _selectedDate = tx.date;
    _isRecurring = tx.isRecurring;
    _recurringForever = tx.recurringForever;
    _recurringMonths = tx.recurringMonths ?? 12;

    // Find category
    final cats = widget.catRepo.byType(_type);
    if (cats.isNotEmpty && tx.categoryId != null) {
      _selectedCategory = cats.firstWhere(
        (c) => c.id == tx.categoryId,
        orElse: () => cats.first,
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
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
    if (_parsedAmount() <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).amountLabel)),
      );
      return;
    }

    final tx = FinanceTransaction(
      id: widget.transaction.id,
      title: _titleCtrl.text.trim(),
      amount: _parsedAmount(),
      date: _selectedDate,
      type: _type,
      categoryId: _selectedCategory?.id,
      isRecurring: _isRecurring,
      recurringForever: _recurringForever,
      recurringMonths:
          _isRecurring && !_recurringForever ? _recurringMonths : null,
    );

    await widget.repo.update(tx);

    if (mounted) {
      Navigator.pop(context, tx);
    }
  }

  Future<void> _createNewCategory() async {
    final nameCtrl = TextEditingController();
    final emojiCtrl = TextEditingController();
    String selectedEmoji = '😊';
    int selectedIcon = Icons.category.codePoint;
    final l10n = AppLocalizations.of(context);

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
                    l10n.newCategory,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(ctx).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(ctx)
                              .colorScheme
                              .outline
                              .withOpacity(0.2),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.categoryName,
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
                    height: 200,
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
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) return;
                          Navigator.pop(ctx, true);
                        },
                        child: Text(l10n.add),
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
      final newCat = FinanceCategory(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: nameCtrl.text.trim(),
        iconCodePoint: selectedIcon,
        emoji: selectedEmoji,
        type: _type,
        colorValue: _accentColor.value,
      );
      await widget.catRepo.add(newCat);
      setState(() => _selectedCategory = newCat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final currencyFmt = NumberFormat.simpleCurrency(locale: localeName);
    final currencySymbol = currencyFmt.currencySymbol;

    final categories = widget.catRepo.byType(_type);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar.large(
            title: Text(l10n.edit),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: _saveTransaction,
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    color: _accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Type Section
                _buildSection(
                  title: l10n.category,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          type: TransactionType.expense,
                          emoji: '💸',
                          title: l10n.expenseLabel,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeOption(
                          type: TransactionType.income,
                          emoji: '💵',
                          title: l10n.incomeLabel,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Amount Section
                _buildSection(
                  title: l10n.amountLabel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
                                decimal: true),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _accentColor,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: theme.textTheme.displaySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.2),
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title (optional)
                TextField(
                  controller: _titleCtrl,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: l10n.titleOptional,
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                        colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Section
                _buildSection(
                  title: l10n.category,
                  child: SizedBox(
                    height: 200,
                    child: StreamBuilder<List<FinanceCategory>>(
                      stream: widget.catRepo.stream,
                      initialData: widget.catRepo.all(),
                      builder: (context, snapshot) {
                        final categories = snapshot.data
                                ?.where((c) => c.type == _type)
                                .toList() ??
                            [];
                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ...categories.map((cat) {
                                final isSelected =
                                    _selectedCategory?.id == cat.id;
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() => _selectedCategory = cat);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _accentColor.withOpacity(0.15)
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(14),
                                      border: isSelected
                                          ? Border.all(
                                              color: _accentColor,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (cat.emoji != null &&
                                            cat.emoji!.isNotEmpty)
                                          Text(cat.emoji!,
                                              style:
                                                  const TextStyle(fontSize: 20))
                                        else
                                          Icon(cat.icon,
                                              size: 20,
                                              color: Color(cat.colorValue)),
                                        const SizedBox(width: 8),
                                        Text(
                                          cat.name,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              // Add Category Button
                              GestureDetector(
                                onTap: _createNewCategory,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          colorScheme.primary.withOpacity(0.3),
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add,
                                          size: 20, color: colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.add,
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Date Section
                _buildSection(
                  title: l10n.date,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.calendar_today, color: _accentColor),
                    ),
                    title: Text(
                      DateFormat.yMMMd(localeName).format(_selectedDate),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _accentColor,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate:
                            DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Recurring Section
                _buildSection(
                  title: 'Recurring',
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isRecurring
                              ? _accentColor.withOpacity(0.1)
                              : colorScheme.surfaceContainerHighest
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: _isRecurring
                              ? Border.all(color: _accentColor, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isRecurring
                                  ? Icons.repeat
                                  : Icons.repeat_outlined,
                              color: _isRecurring
                                  ? _accentColor
                                  : colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _isRecurring
                                    ? 'Recurring enabled'
                                    : 'One-time transaction',
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
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDurationOption(
                                title: l10n.durationIndefinite,
                                isSelected: _recurringForever,
                                onTap: () =>
                                    setState(() => _recurringForever = true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDurationOption(
                                title: l10n.durationMonths(_recurringMonths),
                                isSelected: !_recurringForever,
                                onTap: () =>
                                    setState(() => _recurringForever = false),
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
                              HapticFeedback.lightImpact();
                              setState(() => _recurringMonths = value.toInt());
                            },
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
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
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTypeOption({
    required TransactionType type,
    required String emoji,
    required String title,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle, color: color, size: 20),
              ),
          ],
        ),
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
          border: isSelected ? Border.all(color: _accentColor) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? _accentColor : null,
          ),
        ),
      ),
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
