import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../design_system/theme/theme_variations.dart';
import '../../l10n/app_localizations.dart';
import 'data/budget_repository.dart';
import 'data/finance_category_repository.dart';
import 'data/transaction_model.dart';
import 'data/transaction_repository.dart';

// Mode for the analysis period selector
enum PeriodMode { month, year }

// Deterministic soft color mapping per emoji to keep chart colors consistent and modern.
Color _colorForEmoji(String? emoji, TransactionType? type) {
  if (emoji == null || emoji.isEmpty) {
    return type == TransactionType.income
        ? const Color(0xFF10B981)
        : const Color(0xFFF43F5E);
  }
  const palette = <Color>[
    Color(0xFFF43F5E), // Rose / Coral
    Color(0xFFEC4899), // Pink
    Color(0xFFA855F7), // Purple
    Color(0xFF6366F1), // Indigo
    Color(0xFF3B82F6), // Blue
    Color(0xFF0EA5E9), // Sky
    Color(0xFF06B6D4), // Cyan
    Color(0xFF14B8A6), // Teal
    Color(0xFF10B981), // Emerald
    Color(0xFF84CC16), // Lime
    Color(0xFFEAB308), // Amber
    Color(0xFFF97316), // Orange
    Color(0xFF78716C), // Stone
    Color(0xFF64748B), // Slate
  ];
  int hash = 0;
  for (final r in emoji.runes) {
    hash = 0x1fffffff & (hash * 31 + r);
  }
  return palette[hash % palette.length];
}

class FinanceAnalysisScreen extends StatefulWidget {
  const FinanceAnalysisScreen({super.key, required this.month, this.variant});

  final DateTime month;
  final ThemeVariant? variant;

  @override
  State<FinanceAnalysisScreen> createState() => _FinanceAnalysisScreenState();
}

class _FinanceAnalysisScreenState extends State<FinanceAnalysisScreen> {
  late PeriodMode _mode;
  late DateTime _selectedPeriod;
  late final TransactionRepository _repo;
  late final FinanceCategoryRepository _catRepo;
  late final BudgetRepository _budgetRepo;
  double? _plannedMonthlySpend;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = TransactionRepository();
    _catRepo = FinanceCategoryRepository();
    _budgetRepo = BudgetRepository();
    _mode = PeriodMode.month;
    _selectedPeriod = widget.month;
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _repo.initialize(),
      _catRepo.initialize(),
      _budgetRepo.initialize(),
    ]);
    if (!mounted) return;
    _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(
      DateTime(_selectedPeriod.year, _selectedPeriod.month, 1),
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

  void _changePeriod(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_mode == PeriodMode.month) {
        _selectedPeriod =
            DateTime(_selectedPeriod.year, _selectedPeriod.month + delta, 1);
        _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(
          DateTime(_selectedPeriod.year, _selectedPeriod.month, 1),
        );
      } else {
        _selectedPeriod = DateTime(_selectedPeriod.year + delta, 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');
    final l10n = AppLocalizations.of(context);

    final titleStr = _mode == PeriodMode.month
        ? DateFormat.yMMMM(locale).format(_selectedPeriod)
        : DateFormat.y(locale).format(DateTime(_selectedPeriod.year));

    // Compute transactions according to selected mode (month vs year)
    final incomes = _loading
        ? const <FinanceTransaction>[]
        : (_mode == PeriodMode.month
            ? _repo.incomesForMonth(_selectedPeriod)
            : _aggregateIncomesForYear(_selectedPeriod.year));
    final expenses = _loading
        ? const <FinanceTransaction>[]
        : (_mode == PeriodMode.month
            ? _repo.expensesForMonth(_selectedPeriod)
            : _aggregateExpensesForYear(_selectedPeriod.year));
    final allTx = _loading
        ? const <FinanceTransaction>[]
        : (_mode == PeriodMode.month
            ? _repo.forMonth(_selectedPeriod)
            : _aggregateForYear(_selectedPeriod.year));

    final incomeTotal = incomes.fold<double>(0, (s, e) => s + e.amount);
    final expenseTotal = expenses.fold<double>(0, (s, e) => s + e.amount);
    final net = incomeTotal - expenseTotal;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: scheme.primary,
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Modern Floating AppBar ──
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor:
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  title: Text(
                    isTr ? 'Finansal Analiz' : 'Finance Analytics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      fontSize: 20,
                    ),
                  ),
                  centerTitle: false,
                ),

                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── 1. Mode Switcher (Month / Year) & Period Capsule ──
                      _buildModeAndPeriodControls(
                        theme: theme,
                        scheme: scheme,
                        isDark: isDark,
                        locale: locale,
                        isTr: isTr,
                      ),

                      const SizedBox(height: 16),

                      // ── 2. Hero Financial Health & Summary Card ──
                      _FinancialSummaryCard(
                        income: incomeTotal,
                        expense: expenseTotal,
                        net: net,
                        locale: locale,
                        isTr: isTr,
                      ),

                      const SizedBox(height: 16),

                      // ── 3. Monthly Budget & Savings Planner (Month Mode only) ──
                      if (_mode == PeriodMode.month) ...[
                        _BudgetPlanner(
                          month: _selectedPeriod,
                          plannedMonthlySpend: _plannedMonthlySpend,
                          currentSpend: expenseTotal,
                          locale: locale,
                          isTr: isTr,
                          onSave: (v) async {
                            await _budgetRepo.setBudgetForMonth(
                              DateTime(_selectedPeriod.year,
                                  _selectedPeriod.month, 1),
                              v,
                            );
                            if (mounted) {
                              setState(() => _plannedMonthlySpend = v);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── 4. Cash Flow Trend Chart ──
                      _buildSectionHeader(
                        title: _mode == PeriodMode.month
                            ? (isTr ? 'Günlük Nakit Akışı' : l10n.monthlyTrend)
                            : (isTr
                                ? 'Yıllık Gelişim & Trend'
                                : l10n.yearlyProgress),
                        icon: Icons.insights_rounded,
                        scheme: scheme,
                      ),
                      const SizedBox(height: 10),
                      if (_mode == PeriodMode.month)
                        _MonthlyTrendChart(
                          month: _selectedPeriod,
                          transactions: allTx,
                          locale: locale,
                          isTr: isTr,
                        )
                      else
                        _YearlyTrendChart(
                          year: _selectedPeriod.year,
                          transactions: allTx,
                          locale: locale,
                          isTr: isTr,
                        ),

                      const SizedBox(height: 24),

                      // ── 5. Expense Distribution Donut Chart ──
                      _buildSectionHeader(
                        title: isTr
                            ? 'Gider Dağılımı'
                            : l10n.expenseDistributionPie,
                        icon: Icons.pie_chart_rounded,
                        scheme: scheme,
                      ),
                      const SizedBox(height: 10),
                      _ExpensePieChart(
                        month: _selectedPeriod,
                        repo: _repo,
                        catRepo: _catRepo,
                        transactions: expenses,
                        locale: locale,
                        isTr: isTr,
                        onSelect: (catId) =>
                            _showCategoryDetails(context, catId),
                      ),

                      const SizedBox(height: 24),

                      // ── 6. Category Breakdown List ──
                      _buildSectionHeader(
                        title: isTr
                            ? 'Kategori Dağılımı'
                            : l10n.breakdownByCategory,
                        icon: Icons.category_rounded,
                        scheme: scheme,
                      ),
                      const SizedBox(height: 10),
                      _CategoryBreakdown(
                        month: _selectedPeriod,
                        transactions: allTx,
                        repo: _repo,
                        catRepo: _catRepo,
                        locale: locale,
                        isTr: isTr,
                        onSelect: (catId) =>
                            _showCategoryDetails(context, catId),
                      ),

                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required ColorScheme scheme,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: scheme.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildModeAndPeriodControls({
    required ThemeData theme,
    required ColorScheme scheme,
    required bool isDark,
    required String locale,
    required bool isTr,
  }) {
    final periodText = _mode == PeriodMode.month
        ? DateFormat.yMMMM(locale).format(_selectedPeriod)
        : DateFormat.y(locale).format(DateTime(_selectedPeriod.year));

    return Column(
      children: [
        // Mode pill switcher: [ Aylık | Yıllık ]
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildModeTab(
                  title: isTr ? 'Aylık Analiz' : 'Monthly',
                  isSelected: _mode == PeriodMode.month,
                  scheme: scheme,
                  isDark: isDark,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _mode = PeriodMode.month);
                  },
                ),
              ),
              Expanded(
                child: _buildModeTab(
                  title: isTr ? 'Yıllık Analiz' : 'Yearly',
                  isSelected: _mode == PeriodMode.year,
                  scheme: scheme,
                  isDark: isDark,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _mode = PeriodMode.year);
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Period navigator capsule: <   📅 Eylül 2026   >
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.45)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                onPressed: () => _changePeriod(-1),
                splashRadius: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (_mode == PeriodMode.month) {
                      final picked = await showCustomMonthPicker(
                        context: context,
                        initial: _selectedPeriod,
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedPeriod =
                              DateTime(picked.year, picked.month, 1);
                          _plannedMonthlySpend = _budgetRepo.getBudgetForMonth(
                            DateTime(picked.year, picked.month, 1),
                          );
                        });
                      }
                    } else {
                      final pickedYear = await showCustomYearPicker(
                        context: context,
                        initialYear: _selectedPeriod.year,
                      );
                      if (pickedYear != null) {
                        setState(() {
                          _selectedPeriod = DateTime(pickedYear, 1, 1);
                        });
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          periodText,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                onPressed: () => _changePeriod(1),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeTab({
    required String title,
    required bool isSelected,
    required ColorScheme scheme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? scheme.primary.withValues(alpha: 0.25) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? scheme.primary
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDetails(BuildContext context, String? categoryId) {
    final nf = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
      decimalDigits: 0,
    );
    final cats = {for (final c in _catRepo.all()) c.id: c};
    final l10n = AppLocalizations.of(context);
    final isTr = Localizations.localeOf(context).toString().startsWith('tr');
    final name = categoryId == null
        ? l10n.other
        : (cats[categoryId]?.name ?? l10n.other);
    final color = categoryId == null
        ? Theme.of(context).colorScheme.primary
        : _colorForEmoji(cats[categoryId]?.emoji, cats[categoryId]?.type);
    final catEmoji = cats[categoryId]?.emoji;

    final txs = (_mode == PeriodMode.month
            ? _repo.expensesForMonth(_selectedPeriod)
            : _aggregateExpensesForYear(_selectedPeriod.year))
        .where((e) => (e.categoryId ?? '_none') == (categoryId ?? '_none'))
        .toList();

    final catTotal = txs.fold<double>(0, (s, e) => s + e.amount);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final scheme = Theme.of(ctx).colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
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

                  // Category Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: catEmoji != null && catEmoji.isNotEmpty
                            ? Text(catEmoji,
                                style: const TextStyle(fontSize: 22))
                            : Icon(Icons.category_rounded,
                                color: color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style:
                                  Theme.of(ctx).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        letterSpacing: -0.3,
                                      ),
                            ),
                            Text(
                              isTr
                                  ? '${txs.length} işlem kaydı'
                                  : '${txs.length} transactions',
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF43F5E).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${nf.format(catTotal)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF43F5E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  Expanded(
                    child: txs.isEmpty
                        ? Center(
                            child: Text(
                              l10n.noExpenseInThisCategory,
                              style:
                                  Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: txs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (_, i) {
                              final t = txs[i];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? scheme.surfaceContainerHighest
                                          .withValues(alpha: 0.3)
                                      : Colors.grey.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            DateFormat(
                                              'dd MMMM yyyy',
                                              Localizations.localeOf(ctx)
                                                  .toString(),
                                            ).format(t.date),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: scheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '-${nf.format(t.amount)}',
                                      style: const TextStyle(
                                        color: Color(0xFFF43F5E),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Hero Financial Summary Card with modern gradient tone, net status, and sub-stat pills.
class _FinancialSummaryCard extends StatelessWidget {
  const _FinancialSummaryCard({
    required this.income,
    required this.expense,
    required this.net,
    required this.locale,
    required this.isTr,
  });

  final double income;
  final double expense;
  final double net;
  final String locale;
  final bool isTr;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    final numFmt = NumberFormat('#,##0', locale);

    final isPositiveNet = net >= 0;
    final netColor =
        isPositiveNet ? const Color(0xFF10B981) : const Color(0xFFF43F5E);

    // Savings rate if income > 0
    final double? savingsRate =
        income > 0 ? ((net / income) * 100).clamp(0, 100).toDouble() : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Net Balance Header Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTr ? 'Net Bakiye' : l10n.financeNet,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: netColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositiveNet
                          ? Icons.check_circle_outline_rounded
                          : Icons.warning_amber_rounded,
                      size: 13,
                      color: netColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPositiveNet
                          ? (isTr ? 'Tasarruf' : 'Surplus')
                          : (isTr ? 'Açık' : 'Deficit'),
                      style: TextStyle(
                        fontSize: 11,
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

          // Net Amount Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${isPositiveNet ? '+' : '-'}$currencySymbol',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: netColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                numFmt.format(net.abs()),
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Sub-stats: Income & Expense cards
          Row(
            children: [
              // Income Pill
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981)
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTr ? 'Toplam Gelir' : l10n.incomeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+$currencySymbol${numFmt.format(income)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF10B981),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Expense Pill
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF43F5E)
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          size: 14,
                          color: Color(0xFFF43F5E),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTr ? 'Toplam Gider' : l10n.expenseLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '-$currencySymbol${numFmt.format(expense)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFF43F5E),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Savings Rate Tracker (if income > 0)
          if (savingsRate != null) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isTr ? 'Tasarruf Oranı' : 'Savings Rate',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '%${savingsRate.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: savingsRate > 20
                        ? const Color(0xFF10B981)
                        : scheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (savingsRate / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation(
                  savingsRate > 20 ? const Color(0xFF10B981) : scheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Modern Category Breakdown List with progress indicators and tactile rows
class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({
    required this.month,
    required this.transactions,
    required this.repo,
    required this.catRepo,
    required this.locale,
    required this.isTr,
    this.onSelect,
  });

  final DateTime month;
  final List<FinanceTransaction> transactions;
  final TransactionRepository repo;
  final FinanceCategoryRepository catRepo;
  final String locale;
  final bool isTr;
  final void Function(String? categoryId)? onSelect;

  @override
  Widget build(BuildContext context) {
    final cats = {for (final c in catRepo.all()) c.id: c};
    final txs = transactions;

    final byCat = <String, double>{};
    for (final tx in txs) {
      final weight = tx.type == TransactionType.income ? tx.amount : -tx.amount;
      final id = tx.categoryId ?? '_none';
      byCat.update(id, (v) => v + weight, ifAbsent: () => weight);
    }

    final entries = byCat.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));

    final maxVal = entries.isEmpty ? 1.0 : entries.first.value.abs();

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          isTr
              ? 'Bu dönemde henüz kategori verisi yok'
              : AppLocalizations.of(context).noDataThisMonth,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _CategoryRow(
              categoryId: e.key == '_none' ? null : e.key,
              name: e.key == '_none'
                  ? AppLocalizations.of(context).other
                  : (cats[e.key]?.name ?? AppLocalizations.of(context).other),
              emoji: cats[e.key]?.emoji,
              color: e.key == '_none'
                  ? Theme.of(context).colorScheme.primary
                  : _colorForEmoji(cats[e.key]?.emoji, cats[e.key]?.type),
              value: e.value,
              progress:
                  (e.value.abs() / (maxVal > 0 ? maxVal : 1)).clamp(0.0, 1.0),
              locale: locale,
              onTap: onSelect,
            ),
          ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    this.categoryId,
    required this.name,
    required this.color,
    required this.value,
    required this.progress,
    required this.locale,
    this.emoji,
    this.onTap,
  });

  final String? categoryId;
  final String name;
  final String? emoji;
  final Color color;
  final double value;
  final double progress;
  final String locale;
  final void Function(String? categoryId)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    final numFmt = NumberFormat('#,##0', locale);

    final isIncome = value >= 0;
    final amountColor =
        isIncome ? const Color(0xFF10B981) : const Color(0xFFF43F5E);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap?.call(categoryId),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: emoji != null && emoji!.isNotEmpty
                          ? Text(emoji!, style: const TextStyle(fontSize: 20))
                          : Icon(Icons.category_rounded,
                              color: color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Subtle Mini Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${isIncome ? '+' : '-'}$currencySymbol${numFmt.format(value.abs())}',
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern Daily Cash Flow Trend BarChart matching the Cotton Design System.
class _MonthlyTrendChart extends StatelessWidget {
  const _MonthlyTrendChart({
    required this.month,
    required this.transactions,
    required this.locale,
    required this.isTr,
  });

  final DateTime month;
  final List<FinanceTransaction> transactions;
  final String locale;
  final bool isTr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;

    final end = DateTime(month.year, month.month + 1, 1)
        .subtract(const Duration(days: 1));
    final days = end.day;

    final totals = List<double>.generate(days, (_) => 0.0);
    for (final tx in transactions) {
      final dayIdx = tx.date.day - 1;
      if (dayIdx >= 0 && dayIdx < days) {
        totals[dayIdx] +=
            tx.type == TransactionType.expense ? -tx.amount : tx.amount;
      }
    }

    final groups = <BarChartGroupData>[];
    double maxAbs = 0;
    for (var i = 0; i < days; i++) {
      final v = totals[i];
      final isPos = v >= 0;
      groups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: v == 0 ? 0.01 : v,
              color: isPos ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
              width: 7,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(show: false),
            ),
          ],
        ),
      );
      if (v.abs() > maxAbs) maxAbs = v.abs();
    }
    final maxY = ((maxAbs * 1.25).clamp(100.0, double.infinity)).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini Legend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildChartLegend(
                color: const Color(0xFF10B981),
                label: isTr ? 'Gelir / Fazla' : 'Income',
              ),
              const SizedBox(width: 12),
              _buildChartLegend(
                color: const Color(0xFFF43F5E),
                label: isTr ? 'Gider / Eksi' : 'Expense',
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                minY: -maxY,
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.spaceBetween,
                barGroups: groups,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (v, meta) {
                        final d = v.toInt();
                        if (d > days) return const SizedBox.shrink();
                        if (d == 1 ||
                            d == 5 ||
                            d == 10 ||
                            d == 15 ||
                            d == 20 ||
                            d == 25 ||
                            d == days) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '$d',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: isDark ? Colors.white24 : Colors.black12,
                      strokeWidth: 1.2,
                      dashArray: [4, 4],
                    ),
                  ],
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => scheme.surfaceContainerHighest,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final val = rod.toY;
                      final isPos = val >= 0;
                      return BarTooltipItem(
                        '${group.x}. Gün\n',
                        const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${isPos ? '+' : ''}$currencySymbol${val.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: isPos
                                  ? const Color(0xFF6EE7B7)
                                  : const Color(0xFFFDA4AF),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// Modern Yearly Trend BarChart
class _YearlyTrendChart extends StatelessWidget {
  const _YearlyTrendChart({
    required this.year,
    required this.transactions,
    required this.locale,
    required this.isTr,
  });

  final int year;
  final List<FinanceTransaction> transactions;
  final String locale;
  final bool isTr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;

    final months = List<double>.generate(12, (_) => 0.0);
    for (final tx in transactions) {
      if (tx.date.year != year) continue;
      final idx = tx.date.month - 1;
      months[idx] +=
          tx.type == TransactionType.expense ? -tx.amount : tx.amount;
    }

    final groups = <BarChartGroupData>[];
    double maxAbs = 0;
    for (var i = 0; i < 12; i++) {
      final v = months[i];
      final isPos = v >= 0;
      groups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: v == 0 ? 0.01 : v,
              color: isPos ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
              width: 14,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
      if (v.abs() > maxAbs) maxAbs = v.abs();
    }
    final maxY = ((maxAbs * 1.25).clamp(100.0, double.infinity)).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                minY: -maxY,
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.spaceBetween,
                barGroups: groups,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (v, meta) {
                        final m = v.toInt();
                        if (m < 1 || m > 12) return const SizedBox.shrink();
                        final monthName =
                            DateFormat.MMM(locale).format(DateTime(year, m, 1));
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            monthName.length > 3
                                ? monthName.substring(0, 3)
                                : monthName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: isDark ? Colors.white24 : Colors.black12,
                      strokeWidth: 1.2,
                      dashArray: [4, 4],
                    ),
                  ],
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => scheme.surfaceContainerHighest,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final m = group.x.toInt();
                      final monthName =
                          DateFormat.MMMM(locale).format(DateTime(year, m, 1));
                      final val = rod.toY;
                      final isPos = val >= 0;
                      return BarTooltipItem(
                        '$monthName\n',
                        const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${isPos ? '+' : ''}$currencySymbol${val.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: isPos
                                  ? const Color(0xFF6EE7B7)
                                  : const Color(0xFFFDA4AF),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern Donut Chart with center metric and category legend
class _ExpensePieChart extends StatelessWidget {
  const _ExpensePieChart({
    required this.month,
    required this.repo,
    required this.catRepo,
    required this.transactions,
    required this.locale,
    required this.isTr,
    this.onSelect,
  });

  final DateTime month;
  final TransactionRepository repo;
  final FinanceCategoryRepository catRepo;
  final List<FinanceTransaction> transactions;
  final String locale;
  final bool isTr;
  final void Function(String? categoryId)? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cats = {for (final c in catRepo.all()) c.id: c};
    final expenses =
        transactions.where((t) => t.type == TransactionType.expense).toList();

    if (expenses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          isTr
              ? 'Bu dönemde harcama kaydı yok'
              : AppLocalizations.of(context).noExpenses,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      );
    }

    final byCat = <String, double>{};
    for (final tx in expenses) {
      final id = tx.categoryId ?? '_none';
      byCat.update(id, (v) => v + tx.amount, ifAbsent: () => tx.amount);
    }
    final total = byCat.values.fold<double>(0, (s, e) => s + e);
    final entries = byCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sections = <PieChartSectionData>[];
    final colorMap = <String, Color>{};

    for (final entry in entries) {
      final id = entry.key;
      final cat = cats[id];
      colorMap[id] = id == '_none'
          ? scheme.primary
          : _colorForEmoji(cat?.emoji, cat?.type);
    }

    for (final e in entries) {
      final color = colorMap[e.key] ?? scheme.primary;
      sections.add(
        PieChartSectionData(
          color: color,
          value: e.value,
          radius: 22,
          showTitle: false,
        ),
      );
    }

    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    final numFmt = NumberFormat('#,##0', locale);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Donut with center total
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 4,
                    centerSpaceRadius: 65,
                    borderData: FlBorderData(show: false),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isTr ? 'Toplam Gider' : 'Total Expense',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$currencySymbol${numFmt.format(total)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Legend list (Top 5 categories)
          Column(
            children: entries.take(5).map((e) {
              final percent = total > 0 ? (e.value / total * 100) : 0;
              final cat = cats[e.key];
              final catName = e.key == '_none'
                  ? AppLocalizations.of(context).other
                  : (cat?.name ?? AppLocalizations.of(context).other);
              final color = colorMap[e.key] ?? scheme.primary;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: InkWell(
                  onTap: () => onSelect?.call(e.key == '_none' ? null : e.key),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (cat?.emoji != null && cat!.emoji!.isNotEmpty) ...[
                          Text(cat.emoji!,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            catName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$currencySymbol${numFmt.format(e.value)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '%${percent.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
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
}

/// Modern Budget Planner card matching the Cotton Design System.
class _BudgetPlanner extends StatelessWidget {
  const _BudgetPlanner({
    required this.month,
    required this.plannedMonthlySpend,
    required this.currentSpend,
    required this.locale,
    required this.isTr,
    required this.onSave,
  });

  final DateTime month;
  final double? plannedMonthlySpend;
  final double currentSpend;
  final String locale;
  final bool isTr;
  final Future<void> Function(double) onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol =
        NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    final numFmt = NumberFormat('#,##0', locale);

    final target = plannedMonthlySpend;
    double progress = 0.0;
    Color progressColor = scheme.primary;

    if (target != null && target > 0) {
      progress = (currentSpend / target).clamp(0.0, 1.0);
      if (currentSpend > target) {
        progressColor = const Color(0xFFF43F5E);
      } else if (progress > 0.85) {
        progressColor = const Color(0xFFF59E0B);
      }
    }

    final double remaining = target != null ? (target - currentSpend) : 0;
    final now = DateTime.now();
    final isCurrentMonth = month.year == now.year && month.month == now.month;
    final endOfMonth = DateTime(month.year, month.month + 1, 0).day;
    final remainingDays = isCurrentMonth
        ? (endOfMonth - now.day + 1).clamp(1, endOfMonth)
        : endOfMonth;
    final double dailyAllowance =
        (remaining > 0 && remainingDays > 0) ? (remaining / remainingDays) : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isTr
                        ? 'Aylık Bütçe Planı'
                        : AppLocalizations.of(context).savingsBudgetPlan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final newTarget = await _showEditBudgetSheet(
                    context: context,
                    initial: target,
                    currencySymbol: currencySymbol,
                    isTr: isTr,
                  );
                  if (newTarget != null && newTarget > 0) {
                    await onSave(newTarget);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (target == null) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    final newTarget = await _showEditBudgetSheet(
                      context: context,
                      initial: null,
                      currencySymbol: currencySymbol,
                      isTr: isTr,
                    );
                    if (newTarget != null && newTarget > 0) {
                      await onSave(newTarget);
                    }
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label:
                      Text(isTr ? 'Bütçe Hedefi Belirle' : 'Set Budget Goal'),
                ),
              ),
            ),
          ] else ...[
            // Progress Track
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation(progressColor),
              ),
            ),
            const SizedBox(height: 12),

            // Spent vs Planned Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTr ? 'Harcanan' : 'Spent',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$currencySymbol${numFmt.format(currentSpend)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isTr ? 'Hedef Bütçe' : 'Target Budget',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$currencySymbol${numFmt.format(target)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Allowance Row: Remaining & Daily Limit
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        remaining >= 0
                            ? Icons.savings_outlined
                            : Icons.report_problem_outlined,
                        size: 16,
                        color: remaining >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF43F5E),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          remaining >= 0
                              ? (isTr
                                  ? 'Kalan: $currencySymbol${numFmt.format(remaining)}'
                                  : 'Left: $currencySymbol${numFmt.format(remaining)}')
                              : (isTr
                                  ? 'Aşıldı: $currencySymbol${numFmt.format(remaining.abs())}'
                                  : 'Exceeded: $currencySymbol${numFmt.format(remaining.abs())}'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: remaining >= 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF43F5E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (remaining > 0)
                  Text(
                    isTr
                        ? 'Günlük: $currencySymbol${numFmt.format(dailyAllowance)}'
                        : 'Daily: $currencySymbol${numFmt.format(dailyAllowance)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Modern Bottom Sheet to edit monthly budget
Future<double?> _showEditBudgetSheet({
  required BuildContext context,
  required double? initial,
  required String currencySymbol,
  required bool isTr,
}) async {
  final controller = TextEditingController(
    text: initial != null ? initial.round().toString() : '',
  );

  return showModalBottomSheet<double?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final scheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SafeArea(
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
                isTr ? 'Aylık Bütçe Belirle' : 'Set Monthly Budget',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isTr
                    ? 'Bu ay için harcamayı hedeflediğin maksimum tutar.'
                    : 'Maximum spending limit target for this month.',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      currencySymbol,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  filled: true,
                  fillColor: isDark
                      ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Quick suggestions
              Wrap(
                spacing: 8,
                children: [5000, 10000, 20000, 35000, 50000].map((v) {
                  return ActionChip(
                    label: Text('+$v'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      final cur = int.tryParse(controller.text) ?? 0;
                      controller.text = (cur + v).toString();
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final v = double.tryParse(controller.text.trim());
                    Navigator.of(ctx).pop(v);
                  },
                  child: Text(
                    isTr ? 'Bütçeyi Kaydet' : 'Save Budget',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Custom month picker dialog matching Cotton aesthetics
Future<DateTime?> showCustomMonthPicker({
  required BuildContext context,
  required DateTime initial,
}) async {
  return showDialog<DateTime>(
    context: context,
    builder: (ctx) {
      int year = initial.year;
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final scheme = Theme.of(ctx).colorScheme;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: () => setState(() => year = year - 1),
                      ),
                      Expanded(
                        child: Text(
                          year.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: () => setState(() => year = year + 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children: List.generate(12, (i) {
                      final m = i + 1;
                      final label = DateFormat.MMM(
                        Localizations.localeOf(context).toString(),
                      ).format(DateTime(year, m, 1));
                      final selected =
                          (year == initial.year && m == initial.month);

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop(DateTime(year, m, 1));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? scheme.primary
                                : (isDark
                                    ? scheme.surfaceContainerHighest
                                        .withValues(alpha: 0.35)
                                    : Colors.grey.withValues(alpha: 0.08)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                              color: selected ? scheme.onPrimary : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () =>
                            Navigator.of(context).pop(DateTime.now()),
                        child: const Text('Bu Ay'),
                      ),
                    ],
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

/// Custom year picker matching Cotton aesthetics
Future<int?> showCustomYearPicker({
  required BuildContext context,
  required int initialYear,
}) async {
  final minYear = 2020;
  final maxYear = 2035;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final scheme = Theme.of(context).colorScheme;

  return showDialog<int>(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Yıl Seçin',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.2,
                  children: List.generate(maxYear - minYear + 1, (idx) {
                    final y = minYear + idx;
                    final selected = y == initialYear;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(ctx).pop(y);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? scheme.primary
                              : (isDark
                                  ? scheme.surfaceContainerHighest
                                      .withValues(alpha: 0.35)
                                  : Colors.grey.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          y.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
                            color: selected ? scheme.onPrimary : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

// Client-side yearly aggregation helper
extension on _FinanceAnalysisScreenState {
  List<FinanceTransaction> _aggregateForYear(int year) {
    final all = <FinanceTransaction>[];
    for (var m = 1; m <= 12; m++) {
      all.addAll(_repo.forMonth(DateTime(year, m, 1)));
    }
    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  List<FinanceTransaction> _aggregateIncomesForYear(int year) =>
      _aggregateForYear(year)
          .where((e) => e.type == TransactionType.income)
          .toList();

  List<FinanceTransaction> _aggregateExpensesForYear(int year) =>
      _aggregateForYear(year)
          .where((e) => e.type == TransactionType.expense)
          .toList();
}
