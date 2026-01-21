import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../rhythm/domain/live_rhythm_model.dart';
import '../../rhythm/domain/live_rhythm_repository.dart';
import '../../rhythm/presentation/rhythm_onboarding_screen.dart';

/// Live Rhythm Header widget with premium breathing animations
class LiveRhythmHeader extends StatefulWidget {
  const LiveRhythmHeader({
    super.key,
    this.aiMessage,
    this.isLoadingAiMessage = false,
    this.onAiMessageTap,
  });

  final String? aiMessage;
  final bool isLoadingAiMessage;
  final VoidCallback? onAiMessageTap;

  @override
  State<LiveRhythmHeader> createState() => _LiveRhythmHeaderState();
}

class _LiveRhythmHeaderState extends State<LiveRhythmHeader>
    with TickerProviderStateMixin {
  RhythmProfile? _profile;
  bool _isLoading = true;

  // Animation controllers
  late AnimationController _breathingController;
  late AnimationController _dotController;
  late AnimationController _scaleController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadProfile();
  }

  void _initAnimations() {
    // 1. Breathing pulse - 5 second cycle
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _breathingAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOutSine,
      ),
    );
    _breathingController.repeat(reverse: true);

    // 2. Dot pulse for AI loading - 1.2 second cycle
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isLoadingAiMessage) {
      _dotController.repeat();
    }

    // 3. Touch scale feedback
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant LiveRhythmHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoadingAiMessage && !oldWidget.isLoadingAiMessage) {
      _dotController.repeat();
    } else if (!widget.isLoadingAiMessage && oldWidget.isLoadingAiMessage) {
      _dotController.stop();
      _dotController.reset();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _dotController.dispose();
    _scaleController.dispose();
    super.dispose();
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

  /// Rounds time remaining to 5-minute blocks
  String _formatTimeRemaining(DateTime? nextTransition) {
    if (nextTransition == null) return '';

    final now = DateTime.now();
    final diff = nextTransition.difference(now);

    if (diff.isNegative) return '';

    final totalMinutes = diff.inMinutes;
    // Round to 5-minute blocks
    final roundedMinutes = ((totalMinutes / 5).ceil() * 5).clamp(5, 9999);

    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    if (hours > 0) {
      return '~${hours}s ${minutes}dk';
    }
    return '~${minutes}dk';
  }

  void _onTapDown(TapDownDetails _) {
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_profile == null) {
      return _buildSetupTeaser(context);
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentWindow = _profile!.getCurrentWindow();
    final nextTransition = _profile!.getNextTransition();
    final windowColor = _getWindowColor(currentWindow);
    final timeRemaining = _formatTimeRemaining(nextTransition);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => _showRhythmDetails(context),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, -0.05),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Container(
            key: ValueKey(currentWindow),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Rhythm window info
                    Row(
                      children: [
                        // Breathing emoji container
                        ListenableBuilder(
                          listenable: _breathingAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: windowColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: windowColor.withOpacity(
                                      0.3 * _breathingAnimation.value,
                                    ),
                                    blurRadius: 12 +
                                        (6 * (1 - _breathingAnimation.value)),
                                    spreadRadius: 2 +
                                        (2 * (1 - _breathingAnimation.value)),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _getWindowEmoji(currentWindow),
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            );
                          },
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
                    if (widget.aiMessage != null ||
                        widget.isLoadingAiMessage) ...[
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
                                  Text(
                                    '🤖',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Canlı Ritim analiz ediyor',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  _AnimatedDots(
                                    controller: _dotController,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: widget.onAiMessageTap,
                                borderRadius: BorderRadius.circular(12),
                                child: Row(
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
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.85),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
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
                    child: Text('⏰', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.rhythmTeaserTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.rhythmTeaserSubtitle,
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
    final colorScheme = theme.colorScheme;
    final currentWindow = _profile!.getCurrentWindow();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
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
              Row(
                children: [
                  Text(
                    '⏰',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.rhythmTeaserTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Window list
              ...RhythmWindow.values.map((window) {
                final isActive = window == currentWindow;
                final color = _getWindowColor(window);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
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
                                Flexible(
                                  child: Text(
                                    _getWindowName(context, window),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isActive ? color : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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

/// Animated 3-dot loading indicator with opacity pulse
class _AnimatedDots extends StatelessWidget {
  const _AnimatedDots({
    required this.controller,
    required this.color,
  });

  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Stagger the animation for each dot
            final delay = index * 0.3;
            final animValue = (controller.value + delay) % 1.0;
            final opacity = (1 - (animValue - 0.5).abs() * 2).clamp(0.3, 1.0);

            return Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Opacity(
                opacity: opacity,
                child: Text(
                  '.',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
