import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/utils/emoji_presets.dart';
import '../../l10n/app_localizations.dart';
import 'data/finance_category.dart';
import 'data/finance_category_repository.dart';
import 'data/transaction_model.dart';
import 'data/transaction_repository.dart';

/// The restored modern Finance Edit Screen:
/// - Tactile Income/Expense Segment Switcher.
/// - Big, aesthetic hero amount card with quick increment chips.
/// - Modern category picker with pastel emoji tiles and custom category creator.
/// - Date selector and monthly recurrence configuration.
/// - Full-width elevated save button with smooth haptics.
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
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _scrollController = ScrollController();

  TransactionType _type = TransactionType.expense;
  FinanceCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  bool _recurringForever = true;
  int _recurringMonths = 12;

  Color get _accentColor => _type == TransactionType.income
      ? const Color(0xFF10B981)
      : const Color(0xFFF43F5E);

  @override
  void initState() {
    super.initState();
    _loadExistingTransaction();
  }

  void _loadExistingTransaction() {
    final tx = widget.transaction;
    _type = tx.type;
    _titleCtrl.text = tx.title;
    _amountCtrl.text = tx.amount.toStringAsFixed(tx.amount.truncateToDouble() == tx.amount ? 0 : 2);
    _selectedDate = tx.date;
    _isRecurring = tx.isRecurring;
    _recurringForever = tx.recurringForever;
    _recurringMonths = tx.recurringMonths ?? 12;

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
    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) return 0.0;
    try {
      final normalized = raw
          .replaceAll(RegExp(r'[^0-9.,]'), '')
          .replaceAll(',', '.');
      return double.tryParse(normalized) ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  void _addQuickAmount(double delta) {
    HapticFeedback.lightImpact();
    final current = _parsedAmount();
    final next = current + delta;
    _amountCtrl.text = next.toStringAsFixed(next.truncateToDouble() == next ? 0 : 2);
    setState(() {});
  }

  Future<void> _saveTransaction() async {
    final amount = _parsedAmount();
    if (amount <= 0) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir tutar girin')),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    final tx = FinanceTransaction(
      id: widget.transaction.id,
      title: _titleCtrl.text.trim().isEmpty ? (_selectedCategory?.name ?? 'İşlem') : _titleCtrl.text.trim(),
      amount: amount,
      date: _selectedDate,
      type: _type,
      categoryId: _selectedCategory?.id,
      isRecurring: _isRecurring,
      recurringForever: _recurringForever,
      recurringMonths: _isRecurring && !_recurringForever ? _recurringMonths : null,
    );

    await widget.repo.update(tx);

    if (mounted) {
      Navigator.pop(context, tx);
    }
  }

  Future<void> _deleteTransaction() async {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isTr ? 'İşlemi Sil' : 'Delete Transaction'),
        content: Text(
          isTr
              ? 'Bu işlemi silmek istediğinizden emin misiniz?'
              : 'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final baseId = widget.transaction.recurrenceId ?? widget.transaction.id;
      await widget.repo.remove(baseId);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    HapticFeedback.lightImpact();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _accentColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _createNewCategory() async {
    final nameCtrl = TextEditingController();
    String selectedEmoji = '🏷️';
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isTr ? 'Yeni Kategori Ekle' : 'New Category',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: isTr ? 'Kategori Adı' : 'Category Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isTr ? 'İkon / Emoji Seçin' : 'Select Emoji',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: kEmojiPresets.length,
                      itemBuilder: (context, index) {
                        final e = kEmojiPresets[index];
                        final isSel = selectedEmoji == e;
                        return GestureDetector(
                          onTap: () => setSheetState(() => selectedEmoji = e),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSel
                                  ? _accentColor.withValues(alpha: 0.2)
                                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: isSel ? Border.all(color: _accentColor, width: 2) : null,
                            ),
                            child: Center(
                              child: Text(e, style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isNotEmpty) {
                        final newCat = FinanceCategory(
                          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          iconCodePoint: Icons.category_rounded.codePoint,
                          emoji: selectedEmoji,
                          type: _type,
                          colorValue: _accentColor.value,
                        );
                        await widget.catRepo.add(newCat);
                        setState(() => _selectedCategory = newCat);
                        Navigator.pop(ctx, true);
                      }
                    },
                    child: Text(isTr ? 'Kategoriyi Kaydet' : 'Save Category', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (created == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final currency = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());

    final categories = widget.catRepo.byType(_type);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isTr ? 'İşlemi Düzenle' : 'Edit Transaction',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: _deleteTransaction,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // ── 1. Type Switcher [ Gider | Gelir ] ──
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _type = TransactionType.expense;
                                final cats = widget.catRepo.byType(_type);
                                if (cats.isNotEmpty) _selectedCategory = cats.first;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _type == TransactionType.expense
                                    ? (isDark ? scheme.surfaceContainerHigh : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _type == TransactionType.expense
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 16,
                                    color: _type == TransactionType.expense
                                        ? const Color(0xFFF43F5E)
                                        : scheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isTr ? 'Gider' : 'Expense',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _type == TransactionType.expense
                                          ? const Color(0xFFF43F5E)
                                          : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _type = TransactionType.income;
                                final cats = widget.catRepo.byType(_type);
                                if (cats.isNotEmpty) _selectedCategory = cats.first;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: _type == TransactionType.income
                                    ? (isDark ? scheme.surfaceContainerHigh : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _type == TransactionType.income
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 16,
                                    color: _type == TransactionType.income
                                        ? const Color(0xFF10B981)
                                        : scheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isTr ? 'Gelir' : 'Income',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _type == TransactionType.income
                                          ? const Color(0xFF10B981)
                                          : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── 2. Hero Amount Card ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _accentColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _accentColor.withValues(alpha: isDark ? 0.15 : 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          isTr ? 'Tutar' : 'Amount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currency.currencySymbol,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: _accentColor,
                                  letterSpacing: -1,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Quick increment chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildQuickChip('+50'),
                              const SizedBox(width: 8),
                              _buildQuickChip('+100'),
                              const SizedBox(width: 8),
                              _buildQuickChip('+250'),
                              const SizedBox(width: 8),
                              _buildQuickChip('+500'),
                              const SizedBox(width: 8),
                              _buildQuickChip('+1000'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── 3. Title / Description Input ──
                  Text(
                    isTr ? 'Açıklama / Başlık' : 'Title',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: TextField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(
                        hintText: isTr ? 'Örn: Market alışverişi, Maaş...' : 'E.g. Groceries',
                        prefixIcon: Icon(Icons.edit_note_rounded, color: _accentColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── 4. Category Selector ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isTr ? 'Kategori' : 'Category',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _createNewCategory,
                        child: Text(
                          isTr ? '+ Yeni Kategori' : '+ New',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSel = _selectedCategory?.id == cat.id;
                      final catColor = Color(cat.colorValue);

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedCategory = cat);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel
                                ? catColor.withValues(alpha: isDark ? 0.25 : 0.15)
                                : (isDark
                                    ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
                                    : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSel ? catColor : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cat.emoji != null && cat.emoji!.isNotEmpty)
                                Text(cat.emoji!, style: const TextStyle(fontSize: 16))
                              else
                                Icon(cat.icon, size: 16, color: catColor),
                              const SizedBox(width: 6),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                  color: isSel ? (isDark ? Colors.white : Colors.black87) : scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // ── 5. Date & Recurrence Card ──
                  Text(
                    isTr ? 'Tarih ve Tekrarlama' : 'Date & Schedule',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Date picker row
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _accentColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.calendar_today_rounded, size: 18, color: _accentColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DateFormat('d MMMM yyyy, EEEE', Localizations.localeOf(context).toString()).format(_selectedDate),
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // Recurring switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.repeat_rounded, size: 18, color: scheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isTr ? 'Aylık Tekrarlayan İşlem' : 'Monthly Recurring',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      isTr ? 'Her ay otomatik yenilenir' : 'Repeats every month',
                                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Switch.adaptive(
                              value: _isRecurring,
                              activeColor: _accentColor,
                              onChanged: (val) {
                                HapticFeedback.selectionClick();
                                setState(() => _isRecurring = val);
                              },
                            ),
                          ],
                        ),
                        if (_isRecurring) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildDurationChip(isTr ? 'Sürekli' : 'Forever', _recurringForever, () {
                                setState(() => _recurringForever = true);
                              }),
                              const SizedBox(width: 8),
                              _buildDurationChip('3 Ay', !_recurringForever && _recurringMonths == 3, () {
                                setState(() {
                                  _recurringForever = false;
                                  _recurringMonths = 3;
                                });
                              }),
                              const SizedBox(width: 8),
                              _buildDurationChip('6 Ay', !_recurringForever && _recurringMonths == 6, () {
                                setState(() {
                                  _recurringForever = false;
                                  _recurringMonths = 6;
                                });
                              }),
                              const SizedBox(width: 8),
                              _buildDurationChip('12 Ay', !_recurringForever && _recurringMonths == 12, () {
                                setState(() {
                                  _recurringForever = false;
                                  _recurringMonths = 12;
                                });
                              }),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom Save Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 3,
                  ),
                  onPressed: _saveTransaction,
                  child: Text(
                    isTr ? 'Değişiklikleri Kaydet' : 'Save Changes',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    final delta = double.tryParse(label.replaceAll('+', '')) ?? 0.0;
    return ActionChip(
      label: Text(label),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: _accentColor,
      ),
      backgroundColor: _accentColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide.none,
      onPressed: () => _addQuickAmount(delta),
    );
  }

  Widget _buildDurationChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? _accentColor.withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: _accentColor) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? _accentColor : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
