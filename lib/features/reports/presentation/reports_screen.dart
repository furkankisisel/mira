import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mira/features/assistant/presentation/mira_premium_report_screen.dart';
import '../../../providers/premium_provider.dart';
import '../../../services/token_repository.dart';
import '../../../services/rewarded_ad_service.dart';
import '../domain/report_model.dart';
import '../data/report_repository.dart';
import '../data/report_generation_service.dart';

/// Screen for viewing and generating weekly reports
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await TokenRepository.instance.initialize();
    await ReportRepository.instance.initialize();
    await ReportGenerationService.instance.initialize();

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haftalık Raporlar'),
        centerTitle: true,
        actions: [
          // Token balance for non-premium
          if (!context.watch<PremiumProvider>().isPremium)
            ListenableBuilder(
              listenable: TokenRepository.instance,
              builder: (context, _) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.toll, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${TokenRepository.instance.balance}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context),
      floatingActionButton: _isLoading ? null : _buildFab(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListenableBuilder(
      listenable: ReportRepository.instance,
      builder: (context, _) {
        final reports = ReportRepository.instance.reports;

        if (reports.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          itemBuilder: (context, index) => _buildReportCard(reports[index]),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz rapor yok',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'İlk haftalık raporunuzu oluşturmak için + butonuna tıklayın',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(WeeklyReport report) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showReportDetail(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    report.type.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateRange(report.weekStart, report.weekEnd),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final isPremium = context.watch<PremiumProvider>().isPremium;

    return FloatingActionButton.extended(
      onPressed: _isGenerating ? null : () => _showGenerateDialog(context),
      icon: _isGenerating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.add),
      label: Text(_isGenerating ? 'Oluşturuluyor...' : 'Rapor Oluştur'),
    );
  }

  void _showGenerateDialog(BuildContext context) {
    final isPremium = context.read<PremiumProvider>().isPremium;
    final tokenBalance = TokenRepository.instance.balance;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _GenerateReportSheet(
        isPremium: isPremium,
        tokenBalance: tokenBalance,
        onGenerate: (type) => _generateReport(type),
        onWatchAd: _watchAdForToken,
      ),
    );
  }

  Future<void> _generateReport(ReportType type) async {
    final isPremium = context.read<PremiumProvider>().isPremium;

    // Non-premium must spend tokens
    if (!isPremium) {
      final success = await TokenRepository.instance.spendForReport();
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Yetersiz jeton! Reklam izleyerek jeton kazanın.')),
          );
        }
        return;
      }
    }

    setState(() => _isGenerating = true);
    Navigator.pop(context); // Close bottom sheet

    try {
      final report =
          await ReportGenerationService.instance.generateReport(type);

      if (mounted) {
        if (report != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rapor oluşturuldu! ✨')),
          );
          _showReportDetail(report);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bu hafta için rapor zaten mevcut.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _watchAdForToken() async {
    final success = await RewardedAdService.instance.showAdAndEarnToken();

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('+1 jeton kazandınız! 🎉')),
      );
    }
  }

  void _showReportDetail(WeeklyReport report) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MiraPremiumReportScreen(report: report),
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    return '${start.day}.${start.month} - ${end.day}.${end.month}.${end.year}';
  }
}

/// Bottom sheet for generating new report
class _GenerateReportSheet extends StatelessWidget {
  const _GenerateReportSheet({
    required this.isPremium,
    required this.tokenBalance,
    required this.onGenerate,
    required this.onWatchAd,
  });

  final bool isPremium;
  final int tokenBalance;
  final Function(ReportType) onGenerate;
  final VoidCallback onWatchAd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canAfford = isPremium || tokenBalance >= TokenRepository.reportCost;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Rapor Oluştur',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Cost info
          if (!isPremium) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.toll, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Maliyet: ${TokenRepository.reportCost} jeton',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '(Bakiye: $tokenBalance)',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Watch ad button if not enough tokens
            if (!canAfford)
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onWatchAd();
                },
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Reklam İzle (+1 Jeton)'),
              ),
            const SizedBox(height: 16),
          ],

          // Report type options
          Text(
            'Rapor Türü Seçin:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          ...ReportType.values.map((type) => ListTile(
                leading: Text(type.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(type.displayName),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: canAfford ? () => onGenerate(type) : null,
                enabled: canAfford,
              )),
        ],
      ),
    );
  }
}

/// Bottom sheet for viewing report detail
class _ReportDetailSheet extends StatelessWidget {
  const _ReportDetailSheet({required this.report});

  final WeeklyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(report.type.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Oluşturulma: ${_formatDate(report.generatedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  report.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
