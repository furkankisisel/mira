import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_rhythm_model.dart';

class RhythmResultsScreen extends StatelessWidget {
  final RhythmProfile profile;

  const RhythmResultsScreen({super.key, required this.profile});

  String _getChronoTitle(BuildContext context, ChronoType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case ChronoType.morning:
        return l10n.rhythmChronoMorning;
      case ChronoType.evening:
        return l10n.rhythmChronoEvening;
      case ChronoType.intermediate:
      case ChronoType.variable:
        return l10n.rhythmChronoIntermediate;
    }
  }

  String _formatTimeRange(TimeRange r) {
    return '${r.startHour.toString().padLeft(2, '0')}:00 - ${r.endHour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(l10n.rhythmResultTitle),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.primaryColor.withOpacity(0.8), theme.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wb_sunny_rounded, size: 64, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          _getChronoTitle(context, profile.chronoType),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    l10n.rhythmResultSubtitle,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.rhythmHabitSuggestionTitle,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeBlock(
                    context,
                    l10n.rhythmWindowFocus,
                    _formatTimeRange(profile.focusWindow),
                    l10n.rhythmFocusHint,
                    Icons.psychology,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildTimeBlock(
                    context,
                    l10n.rhythmWindowEnergy,
                    _formatTimeRange(profile.energyWindow),
                    l10n.rhythmEnergyHint,
                    Icons.fitness_center,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildTimeBlock(
                    context,
                    l10n.rhythmWindowLight,
                    _formatTimeRange(profile.lightWindow),
                    l10n.rhythmLightHint,
                    Icons.task_alt,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildTimeBlock(
                    context,
                    l10n.rhythmWindowReflection,
                    _formatTimeRange(profile.reflectionWindow),
                    l10n.rhythmReflectionHint,
                    Icons.self_improvement,
                    Colors.purple,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.rhythmResultGotIt),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBlock(
    BuildContext context,
    String title,
    String time,
    String hint,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hint,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
