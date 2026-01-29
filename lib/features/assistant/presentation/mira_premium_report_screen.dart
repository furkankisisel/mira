import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../reports/domain/report_model.dart';

class MiraPremiumReportScreen extends StatefulWidget {
  final WeeklyReport report;
  final VoidCallback? onBack;

  const MiraPremiumReportScreen({
    super.key,
    required this.report,
    this.onBack,
  });

  @override
  State<MiraPremiumReportScreen> createState() =>
      _MiraPremiumReportScreenState();
}

class _MiraPremiumReportScreenState extends State<MiraPremiumReportScreen> {
  bool _showDetails = false;

  Map<String, dynamic> get _data => widget.report.metadata ?? {};
  Map<String, dynamic>? get _habitStats =>
      _data['habitStats'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _financeStats =>
      _data['financeStats'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _moodStats =>
      _data['moodStats'] as Map<String, dynamic>?;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.report.title,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
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
            // --- ÖZET KISMI (Her zaman görünür) ---
            _buildHeroCard(context),
            const SizedBox(height: 24),
            _buildQuickMetrics(context),
            const SizedBox(height: 24),
            _buildMotivationCard(context),
            const SizedBox(height: 24),

            // --- DETAYLARI GÖR BUTONU ---
            if (!_showDetails)
              _buildExpandButton(context)
            else ...[
              // --- DETAYLI KISIM ---
              _buildDetailedSection(context),
            ],

            const SizedBox(height: 32),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Hero skor kartı - büyük dairesel progress
  Widget _buildHeroCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int score = 0;
    String subtitle = '';

    if (widget.report.type == ReportType.habits ||
        widget.report.type == ReportType.combined) {
      score = (_habitStats?['rate'] as num?)?.toInt() ?? 0;
      subtitle = 'Haftalık Alışkanlık Başarısı';
    } else if (widget.report.type == ReportType.finance) {
      final savings = (_financeStats?['savings'] as num?)?.toDouble() ?? 0;
      score = savings >= 0 ? 100 : 50;
      subtitle = savings >= 0 ? 'Bütçe Dengede' : 'Harcama Fazlası';
    } else if (widget.report.type == ReportType.mood) {
      final avgScore = (_moodStats?['avgScore'] as num?)?.toDouble() ?? 0;
      score = (avgScore * 20).toInt().clamp(0, 100);
      subtitle = 'Ortalama Ruh Hali';
    }

    final scoreColor = _getScoreColor(score, colorScheme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withOpacity(0.15),
            scoreColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: scoreColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score.toDouble()),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: value / 100,
                      strokeWidth: 12,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${value.toInt()}%',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        _getScoreEmoji(score),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            _getScoreMessage(score),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Hızlı metrikler - 3-4 küçük kart
  Widget _buildQuickMetrics(BuildContext context) {
    final metrics = <_MetricData>[];

    if (_habitStats != null) {
      final topHabits = _habitStats!['topHabits'] as List? ?? [];
      final topHabit = topHabits.isNotEmpty ? topHabits.first : null;

      metrics.add(_MetricData(
        icon: Icons.star,
        label: 'En İyi',
        value: topHabit != null ? (topHabit['emoji'] ?? '⭐') : '-',
        subtitle: topHabit != null ? '${topHabit['streak']} gün seri' : '',
        color: Colors.amber,
      ));

      metrics.add(_MetricData(
        icon: Icons.calendar_today,
        label: 'En Verimli Gün',
        value: _formatDayName(_habitStats!['bestDay'] as String? ?? ''),
        subtitle: '%${_habitStats!['bestDayRate'] ?? 0}',
        color: Colors.blue,
      ));
    }

    if (_financeStats != null) {
      final savings = (_financeStats!['savings'] as num?)?.toDouble() ?? 0;
      metrics.add(_MetricData(
        icon: savings >= 0 ? Icons.trending_up : Icons.trending_down,
        label: 'Net Durum',
        value: '${savings >= 0 ? '+' : ''}${savings.toStringAsFixed(0)}₺',
        subtitle: savings >= 0 ? 'Tasarruf' : 'Açık',
        color: savings >= 0 ? Colors.green : Colors.red,
      ));
    }

    if (_moodStats != null) {
      metrics.add(_MetricData(
        icon: Icons.emoji_emotions,
        label: 'Genel Mod',
        value: _moodStats!['mostCommon'] as String? ?? '-',
        subtitle: '${_moodStats!['entries'] ?? 0} kayıt',
        color: Colors.purple,
      ));
    }

    if (metrics.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: metrics.map((m) => _buildMetricCard(context, m)).toList(),
    );
  }

  Widget _buildMetricCard(BuildContext context, _MetricData metric) {
    final theme = Theme.of(context);

    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: metric.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: metric.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: 18),
              const SizedBox(width: 6),
              Text(
                metric.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: metric.color,
            ),
          ),
          if (metric.subtitle.isNotEmpty)
            Text(
              metric.subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Motivasyon kartı - AI'dan gelen kısa mesaj
  Widget _buildMotivationCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract first paragraph as summary
    final content = widget.report.content;
    final summary = content.split('\n').take(3).join('\n').trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome,
                    color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Mira\'nın Özeti',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.isEmpty ? 'Harika bir hafta geçirdin! 🎉' : summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// "Detayları Gör" butonu
  Widget _buildExpandButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: FilledButton.icon(
        onPressed: () => setState(() => _showDetails = true),
        icon: const Icon(Icons.expand_more),
        label: const Text('Detayları Gör'),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
    );
  }

  /// Detaylı bölüm - grafikler ve analizler
  Widget _buildDetailedSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grafik
        if (widget.report.type == ReportType.habits ||
            widget.report.type == ReportType.combined)
          _buildHabitChart(context),
        if (widget.report.type == ReportType.finance)
          _buildFinancePieChart(context),
        if (widget.report.type == ReportType.mood)
          _buildMoodDistribution(context),

        const SizedBox(height: 24),

        // Detaylı liste
        if (_habitStats != null) ...[
          _buildHabitLists(context),
          const SizedBox(height: 24),
        ],

        if (_financeStats != null) ...[
          _buildFinanceInsights(context),
          const SizedBox(height: 24),
        ],

        // AI Detaylı Öneriler
        _buildDetailedSuggestions(context),

        // Daralt butonu
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () => setState(() => _showDetails = false),
            icon: const Icon(Icons.expand_less),
            label: const Text('Daralt'),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dailyData =
        (_habitStats?['dailyRates'] as Map<String, dynamic>?) ?? {};
    final days = dailyData.keys.toList()..sort();

    if (days.isEmpty) return const SizedBox.shrink();

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
            children: [
              Icon(Icons.insights, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Haftalık Trend',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
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
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}%',
                        TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold),
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
                          final day = days[value.toInt()].split('-').last;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(day, style: theme.textTheme.labelSmall),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outlineVariant.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(days.length, (index) {
                  final rawValue = dailyData[days[index]];
                  final value = (rawValue as num?)?.toDouble() ?? 0.0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        gradient: LinearGradient(
                          colors: value >= 80
                              ? [Colors.green.shade300, Colors.green]
                              : value >= 50
                                  ? [Colors.orange.shade300, Colors.orange]
                                  : [Colors.red.shade300, Colors.red],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
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

  Widget _buildHabitLists(BuildContext context) {
    final theme = Theme.of(context);
    final topHabits =
        (_habitStats?['topHabits'] as List?)?.cast<Map<String, dynamic>>() ??
            [];
    final strugglingHabits = (_habitStats?['strugglingHabits'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topHabits.isNotEmpty) ...[
          _buildListSection(
            context,
            '🏆 En Başarılı Alışkanlıklar',
            topHabits,
            Colors.green,
          ),
          const SizedBox(height: 16),
        ],
        if (strugglingHabits.isNotEmpty)
          _buildListSection(
            context,
            '💪 Üzerine Düşülmesi Gerekenler',
            strugglingHabits,
            Colors.orange,
          ),
      ],
    );
  }

  Widget _buildListSection(BuildContext context, String title,
      List<Map<String, dynamic>> items, Color color) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(item['emoji'] ?? '📌',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item['title'] ?? '',
                        style: theme.textTheme.bodyMedium),
                  ),
                  if (item['streak'] != null && item['streak'] > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 14, color: color),
                          const SizedBox(width: 4),
                          Text('${item['streak']}',
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildFinancePieChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final breakdown =
        (_financeStats?['categoryBreakdown'] as Map<String, dynamic>?) ?? {};

    if (breakdown.isEmpty) return const SizedBox.shrink();

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];
    final entries = breakdown.entries.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategori Dağılımı',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: List.generate(entries.length.clamp(0, 6), (i) {
                  final e = entries[i];
                  return PieChartSectionData(
                    value: (e.value as num).toDouble(),
                    color: colors[i % colors.length],
                    title: '',
                    radius: 50,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: List.generate(entries.length.clamp(0, 6), (i) {
              final e = entries[i];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text('${e.key}: ${(e.value as num).toStringAsFixed(0)}₺',
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceInsights(BuildContext context) {
    final theme = Theme.of(context);
    final warning = _financeStats?['warningCategory'] as String?;
    final lowest = _financeStats?['lowestCategory'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (warning != null)
          _buildInsightCard(
              context,
              '⚠️ Dikkat',
              '$warning kategorisinde yüksek harcama tespit edildi.',
              Colors.orange),
        if (lowest != null)
          _buildInsightCard(context, '✅ Tasarruf',
              '$lowest kategorisinde tutumlu davrandın!', Colors.green),
      ],
    );
  }

  Widget _buildInsightCard(
      BuildContext context, String title, String message, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildMoodDistribution(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final distribution =
        (_moodStats?['distribution'] as Map<String, dynamic>?) ?? {};

    if (distribution.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ruh Hali Dağılımı',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...distribution.entries.map((e) {
            final total =
                distribution.values.fold<num>(0, (a, b) => a + (b as num));
            final percent = total > 0 ? (e.value as num) / total : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 80, child: Text(e.key)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent.toDouble(),
                        minHeight: 8,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${(percent * 100).toInt()}%'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDetailedSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Parse content into sections
    final sections = _parseContentSections(widget.report.content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        final sectionColor = _getSectionColor(section.title, colorScheme);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: sectionColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sectionColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: sectionColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getSectionIcon(section.title),
                      color: sectionColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.title.replaceAll(RegExp(r'^##\s*'), ''),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: sectionColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Section Content
              ...section.items.map((item) {
                final isBullet = item.startsWith('•') || item.startsWith('-');
                final cleanItem = item.replaceFirst(RegExp(r'^[•\-]\s*'), '');

                if (isBullet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 7, right: 10),
                          decoration: BoxDecoration(
                            color: sectionColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cleanItem,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  );
                }
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<_ContentSection> _parseContentSections(String content) {
    final sections = <_ContentSection>[];
    final lines = content.split('\n');

    String currentTitle = '📝 Genel';
    List<String> currentItems = [];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('##')) {
        // Save previous section
        if (currentItems.isNotEmpty) {
          sections
              .add(_ContentSection(title: currentTitle, items: currentItems));
          currentItems = [];
        }
        currentTitle = trimmed;
      } else {
        currentItems.add(trimmed);
      }
    }

    // Add last section
    if (currentItems.isNotEmpty) {
      sections.add(_ContentSection(title: currentTitle, items: currentItems));
    }

    return sections.isEmpty
        ? [
            _ContentSection(title: '📝 Analiz', items: [content])
          ]
        : sections;
  }

  Color _getSectionColor(String title, ColorScheme colors) {
    if (title.contains('Başarı') || title.contains('✅')) return Colors.green;
    if (title.contains('Gelişim') || title.contains('⚠️')) return Colors.orange;
    if (title.contains('Öneri') || title.contains('💡')) return Colors.blue;
    if (title.contains('Hedef') || title.contains('🎯')) return Colors.purple;
    if (title.contains('Değerlendirme') || title.contains('📊'))
      return colors.primary;
    return colors.tertiary;
  }

  IconData _getSectionIcon(String title) {
    if (title.contains('Başarı') || title.contains('✅'))
      return Icons.emoji_events;
    if (title.contains('Gelişim') || title.contains('⚠️'))
      return Icons.trending_up;
    if (title.contains('Öneri') || title.contains('💡')) return Icons.lightbulb;
    if (title.contains('Hedef') || title.contains('🎯')) return Icons.flag;
    if (title.contains('Değerlendirme') || title.contains('📊'))
      return Icons.analytics;
    return Icons.article;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---

  Color _getScoreColor(int score, ColorScheme colors) {
    if (score >= 80) return Colors.green;
    if (score >= 50) return colors.primary;
    return colors.error;
  }

  String _getScoreMessage(int score) {
    if (score >= 90) return 'Efsanesin!';
    if (score >= 70) return 'Harika Gidiyorsun!';
    if (score >= 50) return 'Gayet İyisin';
    if (score >= 30) return 'Biraz Daha Gayret';
    return 'Yeni Başlangıç';
  }

  String _getScoreEmoji(int score) {
    if (score >= 90) return '🌟';
    if (score >= 70) return '🔥';
    if (score >= 50) return '👍';
    if (score >= 30) return '💪';
    return '🌱';
  }

  String _formatDayName(String dateKey) {
    if (dateKey.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateKey);
      const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
      return days[date.weekday - 1];
    } catch (_) {
      return dateKey.split('-').last;
    }
  }
}

class _MetricData {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}

class _ContentSection {
  final String title;
  final List<String> items;

  _ContentSection({required this.title, required this.items});
}
