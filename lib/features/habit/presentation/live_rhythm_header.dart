import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';
import '../../rhythm/presentation/rhythm_onboarding_screen.dart';

/// Live Rhythm Header widget that displays current rhythm window
/// and AI motivational message as a unified card
class LiveRhythmHeader extends StatefulWidget {
  const LiveRhythmHeader({
    super.key,
    this.aiMessage,
    this.isLoadingAiMessage = false,
  });

  /// Optional AI motivational message to display
  final String? aiMessage;

  /// Whether AI message is currently being loaded
  final bool isLoadingAiMessage;

  @override
  State<LiveRhythmHeader> createState() => _LiveRhythmHeaderState();
}

class _LiveRhythmHeaderState extends State<LiveRhythmHeader> {
  RhythmProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await LiveRhythmRepository.instance.initialize();
    final profile = LiveRhythmRepository.instance.profile;
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  String _getWindowEmoji(RhythmWindow window) {
    switch (window) {
      case RhythmWindow.focus:
        return '🧠';
      case RhythmWindow.energy:
        return '⚡';
      case RhythmWindow.light:
        return '🌤️';
      case RhythmWindow.reflection:
        return '🌙';
    }
  }

  String _getWindowName(BuildContext context, RhythmWindow window) {
    final l10n = AppLocalizations.of(context);
    switch (window) {
      case RhythmWindow.focus:
        return l10n.rhythmWindowFocus;
      case RhythmWindow.energy:
        return l10n.rhythmWindowEnergy;
      case RhythmWindow.light:
        return l10n.rhythmWindowLight;
      case RhythmWindow.reflection:
        return l10n.rhythmWindowReflection;
    }
  }

  String _getWindowDescription(BuildContext context, RhythmWindow window) {
    final l10n = AppLocalizations.of(context);
    switch (window) {
      case RhythmWindow.focus:
        return l10n.rhythmWindowFocusDesc;
      case RhythmWindow.energy:
        return l10n.rhythmWindowEnergyDesc;
      case RhythmWindow.light:
        return l10n.rhythmWindowLightDesc;
      case RhythmWindow.reflection:
        return l10n.rhythmWindowReflectionDesc;
    }
  }

  Color _getWindowColor(RhythmWindow window) {
    switch (window) {
      case RhythmWindow.focus:
        return const Color(0xFF6366F1); // Indigo
      case RhythmWindow.energy:
        return const Color(0xFFF59E0B); // Amber
      case RhythmWindow.light:
        return const Color(0xFF10B981); // Emerald
      case RhythmWindow.reflection:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  String _formatTimeRemaining(DateTime? nextTransition) {
    if (nextTransition == null) return '';

    final now = DateTime.now();
    final diff = nextTransition.difference(now);

    if (diff.isNegative) return '';

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours > 0) {
      return '${hours}s ${minutes}dk';
    }
    return '${minutes}dk';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    // If no profile, show teaser to set up rhythm
    if (_profile == null) {
      return _buildSetupTeaser(context);
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentWindow = _profile!.getCurrentWindow();
    final nextTransition = _profile!.getNextTransition();
    final windowColor = _getWindowColor(currentWindow);
    final timeRemaining = _formatTimeRemaining(nextTransition);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            windowColor.withOpacity(0.15),
            windowColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: windowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showRhythmDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Rhythm window info
                Row(
                  children: [
                    // Window emoji with animated glow
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: windowColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: windowColor.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getWindowEmoji(currentWindow),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Window info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getWindowName(context, currentWindow),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: windowColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getWindowDescription(context, currentWindow),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Time remaining badge
                    if (timeRemaining.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: windowColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 12,
                              color: windowColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              timeRemaining,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: windowColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // AI Message Section
                if (widget.aiMessage != null || widget.isLoadingAiMessage) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: windowColor.withOpacity(0.2),
                      ),
                    ),
                    child: widget.isLoadingAiMessage
                        ? Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: windowColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '✨ AI düşünüyor...',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✨',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.aiMessage!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.85),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetupTeaser(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.5),
            colorScheme.primaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RhythmOnboardingScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🧬', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.retakeRhythmTest,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.retakeRhythmTestDesc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRhythmDetails(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_profile == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '🧬 Canlı Ritim',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.rhythmDisclaimer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              // Show all 4 windows
              ...RhythmWindow.values.map((window) {
                final isActive = _profile!.getCurrentWindow() == window;
                final color = _getWindowColor(window);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withOpacity(0.15)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        isActive ? Border.all(color: color, width: 2) : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getWindowEmoji(window),
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _getWindowName(context, window),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isActive ? color : null,
                                  ),
                                ),
                                if (isActive) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'ŞİMDİ',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getWindowDescription(context, window),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              // Reconfigure button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RhythmOnboardingScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.retakeRhythmTest),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
