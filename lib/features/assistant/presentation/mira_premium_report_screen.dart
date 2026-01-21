import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../habit/domain/habit_model.dart';
import '../../reports/domain/report_model.dart';

class MiraPremiumReportScreen extends StatelessWidget {
  final WeeklyReport report;
  final VoidCallback? onBack;

  const MiraPremiumReportScreen({
    super.key,
    required this.report,
    this.onBack,
  });

  // Helper getters to extract data safely
  Map<String, dynamic> get _data => report.metadata ?? {};

  // Habit Helpers
  Map<String, dynamic>? get _habitStats =>
      _data['habitStats'] as Map<String, dynamic>?;
  List<Habit> get _topHabits {
    // Ideally metadata should store full objects or we fetch them.
    // For simplicity, let's assume we might need to fetch them OR
    // we stored a simplified version in metadata.
    // The ReportGenerationService stored IDs. This is tricky.
    // If we only have IDs, we can't show title/icon without fetching.
    // Let's assume for this step we will skip detailed list tile if we can't resolve it,
    // OR we update ReportGenerationService to store basic habit info (title, icon) in metadata.
    // Let's rely on what we have. If we only stored IDs, we have a problem.
    // Fix: Update ReportGenerationService to store 'topHabitsData' list with title/icon.
    return [];
  }

  // For now, let's implement the structure and I will update Generation Service to store better data
  // or I'll simple hide specific tiles until then.

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate Score based on type
    int score = 0;
    if (report.type == ReportType.habits ||
        report.type == ReportType.combined) {
      score = (_habitStats?['rate'] as num?)?.toInt() ?? 0;
    } else {
      // Default score 100 for other types purely visual or logic
      score = 100;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        title: Text(
          report.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.type == ReportType.habits ||
                report.type == ReportType.combined)
              _buildScoreSection(context, score),
            const SizedBox(height: 32),
            _buildChartSection(context),
            const SizedBox(height: 32),
            // Parse Content for Suggestions/Text
            Text(report.content),
            const SizedBox(height: 32),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, int score) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 12,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: _getScoreColor(score, colorScheme),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score%',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Başarı',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getScoreMessage(score),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Son 7 günde hedeflerinin %$score kadarını tamamladın.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    if (report.type == ReportType.finance) return _buildFinanceChart(context);
    if (report.type == ReportType.mood) return _buildMoodChart(context);

    // Default to Habit Chart
    return _buildHabitChart(context);
  }

  Widget _buildHabitChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dailyData =
        (_habitStats?['dailyRates'] as Map<String, dynamic>?) ?? {};
    final days = dailyData.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Haftalık Trend',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.bar_chart_rounded,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}%',
                        TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          // Format: YYYY-MM-DD -> DD
                          final dateStr = days[value.toInt()];
                          final day = dateStr.split('-').last;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              day,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outlineVariant.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(days.length, (index) {
                  final key = days[index];
                  final rawValue = dailyData[key];
                  final double value = (rawValue as num?)?.toDouble() ?? 0.0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        gradient: LinearGradient(
                          colors: value >= 80
                              ? [Colors.greenAccent, Colors.green]
                              : value >= 50
                                  ? [Colors.orangeAccent, Colors.orange]
                                  : [Colors.redAccent, Colors.red],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceChart(BuildContext context) {
    final stats = _data['financeStats'] as Map<String, dynamic>?;
    if (stats == null) return const SizedBox.shrink();

    final income = (stats['income'] as num?)?.toDouble() ?? 0.0;
    final expense = (stats['expense'] as num?)?.toDouble() ?? 0.0;
    final savings = (stats['savings'] as num?)?.toDouble() ?? 0.0;

    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Finansal Özet',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildFinanceCard(context, 'Gelir', income,
                        Colors.green, Icons.arrow_downward)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildFinanceCard(context, 'Gider', expense,
                        Colors.red, Icons.arrow_upward)),
              ],
            ),
            const SizedBox(height: 12),
            _buildFinanceCard(context, 'Net Durum', savings, Colors.blue,
                Icons.account_balance_wallet,
                isWide: true),
          ],
        ));
  }

  Widget _buildFinanceCard(BuildContext context, String label, double amount,
      Color color, IconData icon,
      {bool isWide = false}) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount.toStringAsFixed(0),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChart(BuildContext context) {
    final stats = _data['moodStats'] as Map<String, dynamic>?;
    if (stats == null) return const SizedBox.shrink();

    final entries = stats['entries'] as int? ?? 0;
    final avgScore = stats['avgScore'] as num?;
    final avg = avgScore?.toDouble().toStringAsFixed(1) ?? '-';
    final common = stats['mostCommon'] as String? ?? '-';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodStat(context, 'Kayıt', entries.toString(), Icons.book),
              _buildMoodStat(context, 'Ortalama', avg, Icons.bar_chart),
              _buildMoodStat(context, 'Mod', common, Icons.sentiment_satisfied),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMoodStat(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildHabitTile(BuildContext context, Habit habit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(habit.color.value).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: habit.emoji != null
                ? Text(
                    habit.emoji!,
                    style: const TextStyle(fontSize: 24),
                  )
                : Icon(
                    habit.icon,
                    color: Color(habit.color.value),
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (habit.description.isNotEmpty)
                  Text(
                    habit.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  '${habit.currentStreak} gün',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, '💡 Mira\'nın Önerileri'),
        const SizedBox(height: 12),
        if (report.content.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('Veri bulunamadı.',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.5),
              ),
            ),
            child: Text(
              report.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.format_list_bulleted_add,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 8),
            Text(
              'Henüz veri yok',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Alışkanlıklarını takip ettikçe burada detaylı analizler göreceksin.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(), // Just close for now
            child: const Text('Kapat'),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score, ColorScheme colors) {
    if (score >= 80) return Colors.green;
    if (score >= 50) return colors.primary;
    return colors.error;
  }

  String _getScoreMessage(int score) {
    if (score >= 90) return 'Efsanesin! 🌟';
    if (score >= 70) return 'Harika Gidiyorsun! 🔥';
    if (score >= 50) return 'Gayet İyisin 👍';
    if (score >= 30) return 'Biraz Daha Gayret 💪';
    return 'Yeni Bir Başlangıç Yapalım 🌱';
  }
}
