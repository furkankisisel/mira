import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../design_system/theme/theme_variations.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/premium_gate.dart';
import 'data/ai_finance_service.dart';
import 'data/budget_repository.dart';
import 'data/finance_category.dart';
import 'data/finance_category_repository.dart';
import 'data/transaction_model.dart';
import 'data/transaction_repository.dart';
import 'domain/ai_finance_dto.dart';
import 'finance_analysis_screen.dart';
import 'finance_edit_screen.dart';
import 'finance_wizard_screen.dart';
import 'presentation/ai_finance_preview_dialog.dart';

/// The restored modern Finance Screen adhering to the Cotton Design System:
/// - Floating aesthetic month navigator with quick 'This Month' badge.
/// - Hero Balance Overview card with glowing income/expense pills and net status.
/// - Spending Advisor & Monthly Budget card with dynamic progress and daily allowance.
/// - Aesthetic segmented view switcher [ Tümü | Giderler | Gelirler ].
/// - Animated transaction timeline grouped by date with spring scale tactile cards.
/// - Direct AI Bank Statement / Receipt OCR scanner integration.
class FinanceScreen extends StatefulWidget {
  const FinanceScreen({
    super.key,
    this.variant,
    this.onMonthChanged,
  });

  final ThemeVariant? variant;
  final ValueChanged<DateTime>? onMonthChanged;

  @override
  State<FinanceScreen> createState() => FinanceScreenState();
}

class FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late final TransactionRepository _repo;
  late final FinanceCategoryRepository _catRepo;
  late final BudgetRepository _budgetRepo;
  DateTime _currentMonth = DateTime.now();
  bool _loading = true;
  double? _plannedMonthlySpend;

  // Selected filter tab: 0 = All, 1 = Income, 2 = Expense
  int _selectedFilterIndex = 0;
  int _swipeDirection = 0;
  double _horizontalDragDistance = 0;

  void _nextFilterTab() {
    if (_selectedFilterIndex < 2) {
      HapticFeedback.selectionClick();
      setState(() {
        _swipeDirection = 1;
        _selectedFilterIndex++;
      });
    }
  }

  void _prevFilterTab() {
    if (_selectedFilterIndex > 0) {
      HapticFeedback.selectionClick();
      setState(() {
        _swipeDirection = -1;
        _selectedFilterIndex--;
      });
    }
  }

  void _setFilterTab(int index) {
    if (_selectedFilterIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _swipeDirection = index > _selectedFilterIndex ? 1 : -1;
      _selectedFilterIndex = index;
    });
  }

  DateTime get currentMonth => _currentMonth;
  bool get isViewingCurrentMonth =>
      _currentMonth.year == DateTime.now().year &&
      _currentMonth.month == DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _repo = TransactionRepository();
    _catRepo = FinanceCategoryRepository();
    _budgetRepo = BudgetRepository();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _repo.initialize(),
      _catRepo.initialize(),
      _budgetRepo.initialize(),
    ]);
    if (!mounted) return;
    _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(
      DateTime(_currentMonth.year, _currentMonth.month, 1),
    );
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _repo.dispose();
    _catRepo.dispose();
    _budgetRepo.dispose();
    super.dispose();
  }

  void selectCurrentMonth() {
    final now = DateTime.now();
    setState(() {
      _currentMonth = DateTime(now.year, now.month, 1);
      _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(_currentMonth);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void changeMonth(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
      _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(_currentMonth);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  Future<void> showMonthPicker() async {
    final locale = Localizations.localeOf(context).toString();
    int pickerYear = _currentMonth.year;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final scheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => setSheetState(() => pickerYear -= 1),
                          icon: const Icon(Icons.chevron_left_rounded, size: 22),
                        ),
                        Text(
                          '$pickerYear',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => setSheetState(() => pickerYear += 1),
                          icon: const Icon(Icons.chevron_right_rounded, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = pickerYear == _currentMonth.year &&
                            month == _currentMonth.month;
                        final monthLabel = DateFormat('MMMM', locale).format(
                          DateTime(2000, month, 1),
                        );

                        return Material(
                          color: isSelected
                              ? scheme.primary
                              : (isDark
                                  ? scheme.surfaceContainerHighest
                                  : scheme.surfaceContainerHighest.withValues(alpha: 0.6)),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _currentMonth = DateTime(pickerYear, month, 1);
                                _plannedMonthlySpend = _budgetRepo
                                    .getBudgetForMonth(_currentMonth);
                              });
                              widget.onMonthChanged?.call(_currentMonth);
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                _capitalize(monthLabel),
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontSize: 13,
                                  color: isSelected
                                      ? scheme.onPrimary
                                      : scheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        selectCurrentMonth();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.today_rounded, size: 18),
                      label: Text(AppLocalizations.of(context).thisMonth),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openAddTransaction(TransactionType initialType) async {
    HapticFeedback.lightImpact();
    final result = await Navigator.of(context).push<FinanceTransaction>(
      MaterialPageRoute(
        builder: (_) => FinanceWizardScreen(
          repo: _repo,
          catRepo: _catRepo,
          initialType: initialType,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _openEditTransaction(FinanceTransaction tx) async {
    HapticFeedback.lightImpact();
    final baseId = tx.recurrenceId ?? tx.id;
    final base = _repo.all().firstWhere(
          (e) => e.id == baseId,
          orElse: () => tx,
        );
    final result = await Navigator.of(context).push<FinanceTransaction>(
      MaterialPageRoute(
        builder: (_) => FinanceEditScreen(
          repo: _repo,
          catRepo: _catRepo,
          transaction: base,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteTransaction(FinanceTransaction tx) async {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isTr ? 'İşlemi Sil' : 'Delete Transaction'),
        content: Text(
          isTr
              ? '"${tx.title}" işlemini silmek istediğinizden emin misiniz?'
              : 'Are you sure you want to delete "${tx.title}"?',
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
      final baseId = tx.recurrenceId ?? tx.id;
      await _repo.remove(baseId);
      if (mounted) setState(() {});
    }
  }

  Future<void> _editBudget() async {
    if (!await requirePremium(context)) return;
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final controller = TextEditingController(
      text: _plannedMonthlySpend?.toStringAsFixed(0) ?? '',
    );

    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(isTr ? 'Aylık Harcama Bütçesi' : l10n.spendingAdvisorTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isTr
                  ? 'Bu ay için hedeflediğiniz maksimum harcama limitini belirleyin.'
                  : 'Set your targeted maximum spending limit for this month.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '${NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).currencySymbol} ',
                hintText: '0',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text.trim());
              Navigator.pop(ctx, val);
            },
            child: Text(isTr ? 'Kaydet' : l10n.add),
          ),
        ],
      ),
    );

    if (result != null) {
      await _budgetRepo.setBudgetForMonth(_currentMonth, result);
      setState(() => _plannedMonthlySpend = result);
    }
  }

  Future<void> _pickAndAnalyzeStatement() async {
    if (!await requirePremium(context)) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final file = File(result.files.single.path!);
      final extension = result.files.single.extension?.toLowerCase();
      final service = AiFinanceService();
      AiFinanceResponse? aiResponse;

      if (extension == 'pdf') {
        final bytes = await file.readAsBytes();
        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final String text = PdfTextExtractor(document).extractText();
        document.dispose();
        aiResponse = await service.analyzeStatement(pdfText: text);
      } else {
        final bytes = await file.readAsBytes();
        final String base64Image = base64Encode(bytes);
        aiResponse = await service.analyzeStatement(imageBase64: base64Image);
      }

      if (!mounted) return;
      Navigator.pop(context); // close loader

      final selectedTxs = await Navigator.of(context).push<List<FinanceTransaction>>(
        MaterialPageRoute(
          builder: (_) => AiFinancePreviewDialog(
            parsedTransactions: aiResponse!.transactions,
            catRepo: _catRepo,
          ),
        ),
      );

      if (selectedTxs != null && selectedTxs.isNotEmpty) {
        for (var tx in selectedTxs) {
          await _repo.add(tx);
        }
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  void openAnalysisScreen() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FinanceAnalysisScreen(
          month: DateTime(_currentMonth.year, _currentMonth.month, 1),
          variant: widget.variant,
        ),
      ),
    );
  }

  Future<void> pickAndAnalyzeStatement() => _pickAndAnalyzeStatement();

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final locale = Localizations.localeOf(context).toString();

    // Data computations
    final monthIncomes = _loading ? const <FinanceTransaction>[] : _repo.incomesForMonth(_currentMonth);
    final monthExpenses = _loading ? const <FinanceTransaction>[] : _repo.expensesForMonth(_currentMonth);
    final incomeTotal = monthIncomes.fold<double>(0, (sum, e) => sum + e.amount);
    final expenseTotal = monthExpenses.fold<double>(0, (sum, e) => sum + e.amount);
    final netTotal = incomeTotal - expenseTotal;

    final now = DateTime.now();
    final isViewingCurrentMonth =
        _currentMonth.year == now.year && _currentMonth.month == now.month;

    // Filter items based on active tab: 0 = All, 1 = Income, 2 = Expense
    List<FinanceTransaction> displayItems;
    if (_selectedFilterIndex == 1) {
      displayItems = monthIncomes;
    } else if (_selectedFilterIndex == 2) {
      displayItems = monthExpenses;
    } else {
      displayItems = _loading ? const <FinanceTransaction>[] : _repo.forMonth(_currentMonth);
    }

    final catMap = {for (final c in _catRepo.all()) c.id: c};

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: SafeArea(
                bottom: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: (_) => _horizontalDragDistance = 0,
                  onHorizontalDragUpdate: (details) {
                    _horizontalDragDistance += details.primaryDelta ?? 0;
                  },
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (_horizontalDragDistance < -35 || velocity < -120) {
                      _nextFilterTab();
                    } else if (_horizontalDragDistance > 35 || velocity > 120) {
                      _prevFilterTab();
                    }
                    _horizontalDragDistance = 0;
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    children: [
                      // ── 1. Hero Net Balance & Overview Card ──
                      _buildHeroOverviewCard(theme, scheme, isDark, netTotal, incomeTotal, expenseTotal, locale, isTr),

                      const SizedBox(height: 8),

                      // ── 2. Spending Advisor / Monthly Budget Card ──
                      _buildBudgetAdvisorCard(theme, scheme, isDark, expenseTotal, locale, isTr),

                      const SizedBox(height: 10),

                      // ── 4. Aesthetic Segment Filter Switcher ──
                      _buildSegmentFilter(theme, scheme, isDark, _loading ? 0 : _repo.forMonth(_currentMonth).length, monthExpenses.length, monthIncomes.length, isTr),

                      const SizedBox(height: 12),

                      // ── 5. Transactions List (Grouped by Day) ──
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final inFromRight = _swipeDirection >= 0;
                          final beginOffset = inFromRight
                              ? const Offset(0.08, 0.0)
                              : const Offset(-0.08, 0.0);
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: beginOffset,
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey('tx_tab_$_selectedFilterIndex'),
                          child: displayItems.isEmpty
                              ? _buildEmptyState(theme, scheme, isDark, isTr)
                              : Column(
                                  children: _buildGroupedTransactionCards(
                                    theme,
                                    scheme,
                                    isDark,
                                    displayItems,
                                    catMap,
                                    locale,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }



  Widget _buildHeroOverviewCard(
    ThemeData theme,
    ColorScheme scheme,
    bool isDark,
    double netTotal,
    double incomeTotal,
    double expenseTotal,
    String locale,
    bool isTr,
  ) {
    final currency = NumberFormat.simpleCurrency(locale: locale);
    final isNetPositive = netTotal >= 0;
    final netColor =
        isNetPositive ? const Color(0xFF10B981) : const Color(0xFFF43F5E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Line: Month Navigation & Surplus/Deficit Status
          Row(
            children: [
              Text(
                isTr ? 'Aylık Özet' : 'Monthly Summary',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => changeMonth(-1),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(Icons.chevron_left_rounded,
                      size: 16, color: scheme.onSurfaceVariant),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => changeMonth(1),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(Icons.chevron_right_rounded,
                      size: 16, color: scheme.onSurfaceVariant),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: netColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isNetPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 11,
                      color: netColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isNetPositive
                          ? (isTr ? 'Fazla' : 'Surplus')
                          : (isTr ? 'Açık' : 'Deficit'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: netColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 3 Stats Side-by-Side: Net Durum | Gelir | Gider
          Row(
            children: [
              // 1. Net Durum
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isTr ? 'Net Durum' : 'Net Balance',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${isNetPositive ? '+' : '-'}${currency.currencySymbol}${NumberFormat('#,##0', locale).format(netTotal.abs())}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: netColor,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                height: 26,
                width: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 10),
              // 2. Gelir
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.arrow_downward_rounded,
                            size: 11, color: Color(0xFF10B981)),
                        const SizedBox(width: 2),
                        Text(
                          isTr ? 'Gelir' : 'Income',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+${currency.currencySymbol}${NumberFormat('#,##0', locale).format(incomeTotal)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF10B981),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                height: 26,
                width: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 10),
              // 3. Gider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.arrow_upward_rounded,
                            size: 11, color: Color(0xFFF43F5E)),
                        const SizedBox(width: 2),
                        Text(
                          isTr ? 'Gider' : 'Expense',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '-${currency.currencySymbol}${NumberFormat('#,##0', locale).format(expenseTotal)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFFF43F5E),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetAdvisorCard(
    ThemeData theme,
    ColorScheme scheme,
    bool isDark,
    double spent,
    String locale,
    bool isTr,
  ) {
    final currency = NumberFormat.simpleCurrency(locale: locale);
    final budget = _plannedMonthlySpend;

    if (budget == null || budget <= 0) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _editBudget,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.today_rounded,
                    color: scheme.primary, size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTr
                        ? 'Ay sonuna kadar günlük limiti görmek için bütçe belirle'
                        : 'Set monthly budget to see daily limit until month end',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  isTr ? '+ Bütçe Belirle' : '+ Set Budget',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final ratio = (spent / budget).clamp(0.0, 1.0);
    final remaining = budget - spent;
    final isOver = remaining < 0;

    final progressColor = ratio > 0.95
        ? const Color(0xFFEF4444)
        : (ratio > 0.75 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

    // Daily allowance calculation
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final now = DateTime.now();
    final isCurrentMonth =
        _currentMonth.year == now.year && _currentMonth.month == now.month;
    final remainingDays = isCurrentMonth
        ? (daysInMonth - now.day + 1).clamp(1, daysInMonth)
        : daysInMonth;
    final dailyAllowance = remaining > 0 ? (remaining / remainingDays) : 0.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _editBudget,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Line 1: Ay Sonuna Kadar Günlük Limit (Doğrudan hesaplanmış)
              Row(
                children: [
                  Icon(Icons.today_rounded, size: 14, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    isTr ? 'Ay sonuna kadar günlük: ' : 'Daily until month end: ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    isOver
                        ? (isTr ? '0₺ (Aşıldı)' : '0 (Exceeded)')
                        : '${currency.currencySymbol}${NumberFormat('#,##0', locale).format(dailyAllowance)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isOver ? const Color(0xFFEF4444) : scheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isOver
                        ? (isTr
                            ? 'Bütçe ${currency.currencySymbol}${NumberFormat('#,##0', locale).format(remaining.abs())} aşıldı!'
                            : 'Over ${currency.currencySymbol}${NumberFormat('#,##0', locale).format(remaining.abs())}!')
                        : (isTr
                            ? 'Kalan: ${currency.currencySymbol}${NumberFormat('#,##0', locale).format(remaining)}'
                            : 'Left: ${currency.currencySymbol}${NumberFormat('#,##0', locale).format(remaining)}'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isOver ? const Color(0xFFEF4444) : progressColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Line 2: İnce Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 4,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
              ),
              const SizedBox(height: 4),
              // Line 3: Aylık Bütçe ve Kalan Gün Bilgisi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${isTr ? 'Aylık Bütçe' : 'Monthly Budget'}: ${currency.currencySymbol}${NumberFormat('#,##0', locale).format(budget)} (${currency.currencySymbol}${NumberFormat('#,##0', locale).format(spent)} harcandı)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    isCurrentMonth
                        ? (isTr ? '$remainingDays gün kaldı' : '$remainingDays days left')
                        : (isTr ? 'Düzenle' : 'Edit'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentFilter(
    ThemeData theme,
    ColorScheme scheme,
    bool isDark,
    int allCount,
    int expenseCount,
    int incomeCount,
    bool isTr,
  ) {
    final tabs = [
      {'label': isTr ? 'Tümü' : 'All', 'count': allCount, 'icon': Icons.swap_horiz_rounded},
      {'label': isTr ? 'Gelirler' : 'Incomes', 'count': incomeCount, 'icon': Icons.arrow_downward_rounded},
      {'label': isTr ? 'Giderler' : 'Expenses', 'count': expenseCount, 'icon': Icons.arrow_upward_rounded},
    ];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          final tab = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => _setFilterTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? scheme.surfaceContainerHigh : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        size: 15,
                        color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${tab['count']})',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: (isSelected ? scheme.primary : scheme.onSurfaceVariant).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildGroupedTransactionCards(
    ThemeData theme,
    ColorScheme scheme,
    bool isDark,
    List<FinanceTransaction> items,
    Map<String, FinanceCategory> catMap,
    String locale,
  ) {
    // Group transactions by date
    final groups = <String, List<FinanceTransaction>>{};
    for (final tx in items) {
      final key = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final currency = NumberFormat.simpleCurrency(locale: locale);
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    final widgets = <Widget>[];

    for (final key in sortedKeys) {
      final dayTxs = groups[key]!;
      final dayDate = dayTxs.first.date;
      final dayLabel = DateFormat('d MMMM, EEEE', locale).format(dayDate);

      // Daily net sum
      double dayNet = 0;
      for (final t in dayTxs) {
        dayNet += (t.type == TransactionType.income ? t.amount : -t.amount);
      }
      final isPositive = dayNet >= 0;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6, left: 4, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${isPositive ? '+' : '-'}${currency.currencySymbol}${NumberFormat('#,##0.00', locale).format(dayNet.abs())}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
                ),
              ),
            ],
          ),
        ),
      );

      for (final tx in dayTxs) {
        final cat = tx.categoryId != null ? catMap[tx.categoryId!] : null;
        final isIncome = tx.type == TransactionType.income;
        final amountColor = isIncome ? const Color(0xFF10B981) : const Color(0xFFF43F5E);
        final catColor = cat != null ? Color(cat.colorValue) : (isIncome ? const Color(0xFF10B981) : const Color(0xFFF43F5E));

        widgets.add(
          _FinanceTransactionRow(
            key: ValueKey(tx.id),
            tx: tx,
            category: cat,
            catColor: catColor,
            isIncome: isIncome,
            amountColor: amountColor,
            currencySymbol: currency.currencySymbol,
            locale: locale,
            onTap: () => _openEditTransaction(tx),
            onLongPress: () => _showTransactionActions(tx),
          ),
        );
      }
    }

    return [
      AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 250),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(child: widget),
            ),
            children: widgets,
          ),
        ),
      ),
    ];
  }

  void _showTransactionActions(FinanceTransaction tx) {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${tx.type == TransactionType.income ? '+' : '-'}${tx.amount.toStringAsFixed(2)}',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(ctx);
                _openEditTransaction(tx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(ctx);
                _deleteTransaction(tx);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme scheme, bool isDark, bool isTr) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 36,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isTr ? 'Bu Ay Henüz İşlem Yok' : 'No Records for this Month',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Harcamalarını veya gelirlerini ekleyerek bütçeni kontrol etmeye başla.'
                : 'Start tracking by adding your income and expenses.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => _openAddTransaction(TransactionType.expense),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(isTr ? 'İlk İşlemini Ekle' : 'Add First Record'),
          ),
        ],
      ),
    );
  }
}

/// A tactile, responsive transaction card row matching the Cotton Design System.
class _FinanceTransactionRow extends StatefulWidget {
  final FinanceTransaction tx;
  final FinanceCategory? category;
  final Color catColor;
  final bool isIncome;
  final Color amountColor;
  final String currencySymbol;
  final String locale;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FinanceTransactionRow({
    super.key,
    required this.tx,
    required this.category,
    required this.catColor,
    required this.isIncome,
    required this.amountColor,
    required this.currencySymbol,
    required this.locale,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_FinanceTransactionRow> createState() => _FinanceTransactionRowState();
}

class _FinanceTransactionRowState extends State<_FinanceTransactionRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 130),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final tx = widget.tx;
    final cat = widget.category;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTapDown: (_) => _anim.forward(),
        onTapUp: (_) async {
          await Future.delayed(const Duration(milliseconds: 40));
          if (mounted) _anim.reverse();
          widget.onTap();
        },
        onTapCancel: () => _anim.reverse(),
        onLongPress: widget.onLongPress,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? scheme.surfaceContainerHighest.withValues(alpha: 0.45)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Category icon/emoji avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.catColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: (cat?.emoji != null && cat!.emoji!.isNotEmpty)
                        ? Text(cat.emoji!, style: const TextStyle(fontSize: 20))
                        : Icon(
                            cat?.icon ??
                                (widget.isIncome
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded),
                            color: widget.catColor,
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                // Title and category badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (cat != null) ...[
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (tx.isRecurring) ...[
                            if (cat != null) const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.repeat_rounded,
                                      size: 10, color: scheme.primary),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Aylık',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: scheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Formatted Amount
                Text(
                  '${widget.isIncome ? '+' : '-'}${widget.currencySymbol}${NumberFormat('#,##0.00', widget.locale).format(tx.amount)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: widget.amountColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
