import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for HapticFeedback
import 'dart:math' as math;
import '../../l10n/app_localizations.dart';
import '../../core/timer/timer_controller.dart';
import '../../design_system/theme/theme_variations.dart';

import '../../ui/premium_gate.dart';
import '../habit/domain/habit_repository.dart';
import '../habit/domain/habit_types.dart';
import 'widgets/landscape_timer_screen.dart';
import 'widgets/elite_timer_dial.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, this.variant, this.showAppBar = true});
  final ThemeVariant? variant;
  final bool showAppBar;
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  final controller = TimerController.instance;
  late TabController _tabController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  static const double _historySectionHeight = 180;

  // Countdown inputs
  final _cdHours = TextEditingController(text: '0');
  final _cdMinutes = TextEditingController(text: '0');
  final _cdSeconds = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    // Sync initial tab with active mode
    int initialIndex = 0;
    switch (controller.activeMode) {
      case TimerMode.stopwatch:
        initialIndex = 0;
        break;
      case TimerMode.countdown:
        initialIndex = 1;
        break;
      case TimerMode.pomodoro:
        initialIndex = 2;
        break;
    }

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    // Listen for tab changes (swipes)
    _tabController.addListener(_handleTabSelection);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    controller.addListener(_onChange);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return; // Wait for animation
    // Only update if index actually changed to avoid redundant calls
    final index = _tabController.index;
    TimerMode newMode = TimerMode.stopwatch;
    if (index == 1) newMode = TimerMode.countdown;
    if (index == 2) newMode = TimerMode.pomodoro;

    if (controller.activeMode != newMode) {
      controller.setMode(newMode);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onChange);
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _cdHours.dispose();
    _cdMinutes.dispose();
    _cdSeconds.dispose();
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  // Normalize and apply countdown duration
  void _applyCountdown() {
    int h = int.tryParse(_cdHours.text) ?? 0;
    int m = int.tryParse(_cdMinutes.text) ?? 0;
    int s = int.tryParse(_cdSeconds.text) ?? 0;
    if (h < 0) h = 0;
    if (m < 0) m = 0;
    if (s < 0) s = 0;
    m += s ~/ 60;
    s %= 60;
    h += m ~/ 60;
    m %= 60;
    controller.setCountdown(Duration(hours: h, minutes: m, seconds: s));
  }

  Color _getAccentColor(BuildContext context) {
    final theme = Theme.of(context);
    final bool isWorld = false;
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = _getAccentColor(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final bgColor = theme.scaffoldBackgroundColor;

    final mainContent = Column(
      children: [
        if (widget.showAppBar) ...[
          _buildTopHeader(context, l10n, accent, textColor, isDark),
          const SizedBox(height: 6),
        ] else
          const SizedBox(height: 10),
        _buildSlidingCapsuleTabBar(accent, textColor, isDark, l10n),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildStopwatch(context),
              _buildCountdown(context),
              _buildPomodoro(context),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: widget.showAppBar
          ? SafeArea(
              bottom: false,
              child: mainContent,
            )
          : mainContent,
    );
  }

  // Unified Top Header with Title, Focus Context, and Action Controls
  Widget _buildTopHeader(
    BuildContext context,
    AppLocalizations l10n,
    Color accent,
    Color textColor,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Screen Title & Dynamic Focus Context
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.timerType,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final isHard = controller.hardMode;
                    final activeHabitId = controller.activeTimerHabitId;
                    String subtitleText = l10n.timerTabStopwatch;
                    if (controller.activeMode == TimerMode.countdown) {
                      subtitleText = l10n.timerTabCountdown;
                    } else if (controller.activeMode == TimerMode.pomodoro) {
                      subtitleText = l10n.timerTabPomodoro;
                    }
                    if (activeHabitId != null) {
                      final h =
                          HabitRepository.instance.findById(activeHabitId);
                      if (h != null)
                        subtitleText = '${h.title} • $subtitleText';
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isRunning
                                ? Colors.green
                                : (isHard ? Colors.red : accent),
                            boxShadow: controller.isRunning
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.green.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            subtitleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.55),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Right: Action buttons (Hard Mode & Landscape Desk Clock)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hard Mode Toggle Button
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final isHardMode = controller.hardMode;
                  return Tooltip(
                    message: l10n.hardMode,
                    child: _BouncingTapWrapper(
                      lowerBound: 0.90,
                      duration: const Duration(milliseconds: 100),
                      onTap: () {
                        _feedback();
                        controller.toggleHardMode();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHardMode
                              ? Colors.red
                                  .withValues(alpha: isDark ? 0.22 : 0.12)
                              : colorScheme.surfaceContainerHigh,
                          border: Border.all(
                            color: isHardMode
                                ? Colors.red.withValues(alpha: 0.5)
                                : colorScheme.outlineVariant.withValues(
                                    alpha: isDark ? 0.45 : 0.7,
                                  ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isHardMode
                                  ? Colors.red.withValues(alpha: 0.15)
                                  : Colors.black
                                      .withValues(alpha: isDark ? 0.25 : 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isHardMode
                              ? Icons.lock_rounded
                              : Icons.lock_open_rounded,
                          color: isHardMode
                              ? Colors.red
                              : textColor.withValues(alpha: 0.7),
                          size: 19,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),

              // Landscape Desk Clock Button
              Tooltip(
                message: l10n.fullScreen,
                child: _BouncingTapWrapper(
                  lowerBound: 0.90,
                  duration: const Duration(milliseconds: 100),
                  onTap: () async {
                    if (!await requirePremium(context)) return;
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            LandscapeTimerScreen(variant: widget.variant),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: isDark ? 0.45 : 0.7,
                        ),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.25 : 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.stay_current_landscape_rounded,
                      color: textColor.withValues(alpha: 0.7),
                      size: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Real-Time Sliding Capsule Tab Switcher
  Widget _buildSlidingCapsuleTabBar(
    Color accent,
    Color textColor,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? Color.alphaBlend(
                  accent.withValues(alpha: 0.08),
                  theme.colorScheme.surfaceContainerHigh,
                )
              : Color.alphaBlend(
                  accent.withValues(alpha: 0.07),
                  Color.alphaBlend(
                    Colors.black.withValues(alpha: 0.04),
                    theme.colorScheme.surfaceContainerLow,
                  ),
                ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: isDark ? 0.45 : 0.7,
            ),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.8),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double pillWidth = (constraints.maxWidth - 2) / 3;

            return Stack(
              children: [
                // Real-time sliding indicator pill
                AnimatedBuilder(
                  animation: _tabController.animation!,
                  builder: (context, child) {
                    final animVal = (_tabController.animation?.value ??
                            _tabController.index.toDouble())
                        .clamp(0.0, 2.0);
                    final leftOffset = (animVal / 2.0) *
                        (constraints.maxWidth - pillWidth - 2);

                    return Positioned(
                      left: leftOffset,
                      top: 0,
                      bottom: 0,
                      width: pillWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.25 : 0.35,
                            ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.22),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.20 : 0.04,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Interactive 3 tabs
                Row(
                  children: [
                    Expanded(
                      child: _buildSlidingTabItem(
                        index: 0,
                        title: l10n.timerTabStopwatch,
                        icon: Icons.timer_outlined,
                        textColor: textColor,
                      ),
                    ),
                    Expanded(
                      child: _buildSlidingTabItem(
                        index: 1,
                        title: l10n.timerTabCountdown,
                        icon: Icons.hourglass_bottom_rounded,
                        textColor: textColor,
                      ),
                    ),
                    Expanded(
                      child: _buildSlidingTabItem(
                        index: 2,
                        title: l10n.timerTabPomodoro,
                        icon: Icons.local_fire_department_rounded,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlidingTabItem({
    required int index,
    required String title,
    required IconData icon,
    required Color textColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        _tabController.animateTo(
          index,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
        if (index == 0) controller.setMode(TimerMode.stopwatch);
        if (index == 1) controller.setMode(TimerMode.countdown);
        if (index == 2) controller.setMode(TimerMode.pomodoro);
      },
      child: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          final animVal = (_tabController.animation?.value ??
                  _tabController.index.toDouble())
              .clamp(0.0, 2.0);
          final diff = (animVal - index).abs();
          final weight = (1.0 - diff).clamp(0.0, 1.0);
          final activeColor = Colors.white;
          final inactiveColor = textColor.withValues(alpha: 0.65);
          final itemColor = Color.lerp(inactiveColor, activeColor, weight)!;

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: itemColor,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 12.5,
                      fontWeight:
                          weight > 0.5 ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularTimer({
    required BuildContext context,
    required Duration duration,
    required double progress,
    required bool isRunning,
    String? subtitle,
    Color? progressColor,
  }) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = progressColor ?? _getAccentColor(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Format time as HH:MM:SS or MM:SS
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final timeText = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Subtitle label
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: theme.textTheme.labelLarge?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Simple large time display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              timeText,
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: 2,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final accent = color ?? _getAccentColor(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final buttonColor = isDestructive
        ? Colors.red
        : isPrimary
            ? accent
            : (isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
                : colorScheme.surfaceContainerHighest);

    final textColor = isDestructive || isPrimary
        ? Colors.white
        : (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : colorScheme.onSurface);

    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary || isDestructive
            ? null
            : Border.all(
                color: isDark
                    ? colorScheme.outline.withValues(alpha: 0.15)
                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
                width: 1,
              ),
        boxShadow: isPrimary || isDestructive
            ? [
                BoxShadow(
                  color: (isDestructive ? Colors.red : accent).withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(
    BuildContext context, {
    required bool isRunning,
    required VoidCallback onPlayPause,
    required VoidCallback? onFinish,
    required VoidCallback? onReset,
    VoidCallback? onSettings,
    VoidCallback? onSkip,
    bool isPomodoro = false,
  }) {
    final l10n = AppLocalizations.of(context);
    final accent = _getAccentColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final leftWidgets = <Widget>[];
    final rightWidgets = <Widget>[];

    final buttonSize = isPomodoro ? 44.0 : 46.0;
    final itemSpacing = isPomodoro ? 8.0 : 10.0;
    final heroMargin = isPomodoro ? 16.0 : 20.0;

    if (isPomodoro) {
      // 1. Pomodoro layout: Symmetrical 5-button balanced horizon
      // Left: Reset + Finish (save early)
      leftWidgets.add(
        _buildMiniIconAction(
          icon: Icons.refresh_rounded,
          tooltip: l10n.reset,
          onPressed: onReset,
          size: buttonSize,
        ),
      );
      leftWidgets.add(
        _buildMiniIconAction(
          icon: Icons.flag_rounded,
          tooltip: l10n.finish,
          onPressed: onFinish,
          color: const Color(0xFF10B981),
          size: buttonSize,
        ),
      );

      // Right: Skip phase + Settings
      rightWidgets.add(
        _buildMiniIconAction(
          icon: Icons.skip_next_rounded,
          tooltip: l10n.timerPomodoroSkipPhase,
          onPressed: onSkip,
          color: const Color(0xFFF59E0B),
          size: buttonSize,
        ),
      );
      rightWidgets.add(
        _buildMiniIconAction(
          icon: Icons.tune_rounded,
          tooltip: l10n.settings,
          onPressed: onSettings,
          size: buttonSize,
        ),
      );
    } else if (onSettings != null) {
      // 2. Countdown layout
      leftWidgets.add(
        _buildMiniIconAction(
          icon: Icons.refresh_rounded,
          tooltip: l10n.reset,
          onPressed: onReset,
          size: buttonSize,
        ),
      );

      if (onFinish != null) {
        rightWidgets.add(
          _buildMiniIconAction(
            icon: Icons.flag_rounded,
            tooltip: l10n.finish,
            onPressed: onFinish,
            color: const Color(0xFF10B981),
            size: buttonSize,
          ),
        );
      }
      rightWidgets.add(
        _buildMiniIconAction(
          icon: Icons.tune_rounded,
          tooltip: l10n.settings,
          onPressed: onSettings,
          size: buttonSize,
        ),
      );
    } else {
      // 3. Stopwatch layout: Classic symmetrical 3-button chronometer
      leftWidgets.add(
        _buildMiniIconAction(
          icon: Icons.refresh_rounded,
          tooltip: l10n.reset,
          onPressed: onReset,
          size: buttonSize,
        ),
      );
      rightWidgets.add(
        _buildMiniIconAction(
          icon: Icons.flag_rounded,
          tooltip: l10n.finish,
          onPressed: onFinish,
          color: const Color(0xFF10B981),
          size: buttonSize,
        ),
      );
    }

    final rowContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left satellites
        for (int i = 0; i < leftWidgets.length; i++) ...[
          if (i > 0) SizedBox(width: itemSpacing),
          leftWidgets[i],
        ],

        SizedBox(width: heroMargin),

        // Hero Play / Pause Button
        _buildHeroPlayButton(
          isRunning: isRunning,
          onPlayPause: onPlayPause,
          accent: accent,
          isDark: isDark,
        ),

        SizedBox(width: heroMargin),

        // Right satellites
        for (int i = 0; i < rightWidgets.length; i++) ...[
          if (i > 0) SizedBox(width: itemSpacing),
          rightWidgets[i],
        ],
      ],
    );

    // If there's pending duration, show modern pending card below buttons
    if (controller.hasPending) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          rowContent,
          const SizedBox(height: 14),
          _buildPendingCard(context),
        ],
      );
    }

    return rowContent;
  }

  Widget _buildHeroPlayButton({
    required bool isRunning,
    required VoidCallback onPlayPause,
    required Color accent,
    required bool isDark,
  }) {
    final heroGradient = isRunning
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFB923C), Color(0xFFEA580C)],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.95),
              Color.lerp(accent, Colors.black, isDark ? 0.22 : 0.12)!,
            ],
          );

    final glowColor = isRunning ? const Color(0xFFEA580C) : accent;

    return _BouncingTapWrapper(
      lowerBound: 0.91,
      duration: const Duration(milliseconds: 100),
      onTap: () {
        _feedback();
        onPlayPause();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: heroGradient,
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.30 : 0.65),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: isDark ? 0.35 : 0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner concentric highlight ring for watch chronometer pusher feel
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.0,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: isRunning
                  ? const Icon(
                      Icons.pause_rounded,
                      key: ValueKey('pause'),
                      size: 32,
                      color: Colors.white,
                    )
                  : Padding(
                      key: const ValueKey('play'),
                      padding: const EdgeInsets.only(left: 2.5),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formattedPending =
        controller.formatDuration(controller.pendingDuration);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.35 : 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.12 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: Color(0xFFF59E0B),
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.timerPendingDurationLabel(formattedPending),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFFCD34D)
                        : const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  formattedPending,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white : const Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
          _BouncingTapWrapper(
            lowerBound: 0.92,
            duration: const Duration(milliseconds: 90),
            onTap: () {
              _feedback();
              _showSaveDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_add_rounded,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    l10n.save,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.skip,
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: () {
              _feedback();
              controller.discardPending();
            },
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  void _feedback() {
    HapticFeedback.lightImpact();
  }

  // Compact action buttons for Pomodoro screen
  Widget _buildCompactActionButtons(
    BuildContext context, {
    required bool isRunning,
    required VoidCallback onPlayPause,
    required VoidCallback? onFinish,
    required VoidCallback? onReset,
    VoidCallback? onSettings,
    VoidCallback? onSkip,
  }) {
    return _buildFloatingActionButtons(
      context,
      isRunning: isRunning,
      onPlayPause: onPlayPause,
      onFinish: onFinish,
      onReset: onReset,
      onSettings: onSettings,
      onSkip: onSkip,
      isPomodoro: true,
    );
  }

  Widget _buildMiniIconAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    Color? color,
    double size = 46,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final isEnabled = onPressed != null;

    final isColored = color != null && isEnabled;
    final bgColor = isColored
        ? color.withValues(alpha: isDark ? 0.20 : 0.12)
        : colorScheme.surfaceContainerHigh;
    final borderColor = isColored
        ? color.withValues(alpha: isDark ? 0.40 : 0.30)
        : colorScheme.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7);
    final iconColor = isColored
        ? color
        : (isEnabled
            ? textColor.withValues(alpha: 0.78)
            : textColor.withValues(alpha: 0.28));

    return Tooltip(
      message: tooltip,
      child: _BouncingTapWrapper(
        lowerBound: 0.90,
        duration: const Duration(milliseconds: 90),
        onTap: isEnabled
            ? () {
                _feedback();
                onPressed();
              }
            : () {},
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEnabled ? 1.0 : 0.32,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 1.2,
              ),
              boxShadow: [
                if (isEnabled) ...[
                  BoxShadow(
                    color: isColored
                        ? color.withValues(alpha: 0.18)
                        : Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  if (!isDark && !isColored)
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                      offset: Offset(0, -1),
                    ),
                ],
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: size * 0.46, color: iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySectionDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.07)
          : Colors.black.withValues(alpha: 0.06),
    );
  }

  Widget _buildStopwatch(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _getAccentColor(context);
    final isRunning =
        controller.isRunning && controller.activeMode == TimerMode.stopwatch;
    final elapsed = controller.elapsed;

    return Column(
      children: [
        // Dial Display
        Expanded(
          flex: 5,
          child: Center(
            child: EliteTimerDial(
              mode: TimerDialMode.stopwatch,
              duration: elapsed,
              isRunning: isRunning,
              accentColor: accent,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildFloatingActionButtons(
              context,
              isRunning: isRunning,
              onPlayPause: () =>
                  isRunning ? controller.pause() : controller.start(),
              onFinish: elapsed.inSeconds > 0 ? controller.finish : null,
              onReset: elapsed.inSeconds > 0 ? controller.reset : null,
            ),
          ),
        ),
        if (controller.sessions.isNotEmpty) ...[
          _buildHistorySectionDivider(isDark),
          SizedBox(height: _historySectionHeight, child: _buildHistoryList()),
        ],
      ],
    );
  }

  Widget _buildCountdown(BuildContext context) {
    final rem = controller.countdownRemaining;
    final total = controller.countdownTotal;
    final hasDuration = controller.hasCountdown;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _getAccentColor(context);
    final isRunning =
        controller.isRunning && controller.activeMode == TimerMode.countdown;

    return Column(
      children: [
        // Dial Display + Quick Presets
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: EliteTimerDial(
                    mode: TimerDialMode.countdown,
                    duration: rem,
                    totalDuration: total,
                    isRunning: isRunning,
                    accentColor: accent,
                    onTap: isRunning ? null : _showCountdownConfigDialog,
                  ),
                ),
              ),
              _buildCountdownPresetsRow(context, accent, isDark, isRunning),
              const SizedBox(height: 6),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildFloatingActionButtons(
              context,
              isRunning: isRunning,
              onPlayPause: !hasDuration
                  ? _showCountdownConfigDialog
                  : () => isRunning
                      ? controller.pause()
                      : controller.startCountdown(),
              onFinish:
                  hasDuration && (rem != total) ? controller.finish : null,
              onReset: hasDuration ? controller.reset : null,
              onSettings: _showCountdownConfigDialog,
            ),
          ),
        ),
        if (controller.sessions.isNotEmpty) ...[
          _buildHistorySectionDivider(isDark),
          SizedBox(height: _historySectionHeight, child: _buildHistoryList()),
        ],
      ],
    );
  }

  Widget _buildCountdownPresetsRow(
    BuildContext context,
    Color accent,
    bool isDark,
    bool isRunning,
  ) {
    final presets = [5, 15, 25, 30, 45, 60];
    final currentMinutes = controller.countdownTotal.inMinutes;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final mins in presets) ...[
            _buildPresetChip(
              label: '$mins ${AppLocalizations.of(context).minutesSuffixShort}',
              isSelected: controller.hasCountdown && currentMinutes == mins,
              accent: accent,
              isDark: isDark,
              onTap: isRunning
                  ? null
                  : () {
                      _feedback();
                      controller.setCountdown(Duration(minutes: mins));
                      _cdHours.text = '0';
                      _cdMinutes.text = mins.toString();
                      _cdSeconds.text = '0';
                    },
            ),
            const SizedBox(width: 8),
          ],
          _buildPresetChip(
            label: AppLocalizations.of(context).custom,
            icon: Icons.tune_rounded,
            isSelected: false,
            accent: accent,
            isDark: isDark,
            onTap: isRunning
                ? null
                : () {
                    _feedback();
                    _showCountdownConfigDialog();
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required Color accent,
    required bool isDark,
    required VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onTap != null;
    final bgColor = isSelected ? accent : colorScheme.surfaceContainerHigh;
    final borderColor = isSelected
        ? accent
        : colorScheme.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7);
    final textColor = isSelected ? Colors.white : colorScheme.onSurfaceVariant;

    return _BouncingTapWrapper(
      lowerBound: 0.92,
      duration: const Duration(milliseconds: 90),
      onTap: onTap ?? () {},
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.45,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.1),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: textColor),
                const SizedBox(width: 4.5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPomodoro(BuildContext context) {
    final isRunning =
        controller.isRunning && controller.activeMode == TimerMode.pomodoro;
    final isWorkPhase = controller.pomodoroWorkPhase;
    final remaining = controller.pomodoroRemaining;
    final total = isWorkPhase
        ? controller.pomodoroWorkDuration
        : (controller.pomodoroCompletedWorkSessions %
                    controller.pomodoroLongBreakInterval ==
                0
            ? controller.pomodoroLongBreakDuration
            : controller.pomodoroShortBreakDuration);

    final accent = _getAccentColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Dial Display (flex: 5)
        Expanded(
          flex: 5,
          child: Center(
            child: EliteTimerDial(
              mode: TimerDialMode.pomodoro,
              duration: remaining,
              totalDuration: total,
              isRunning: isRunning,
              accentColor: accent,
              isWorkPhase: isWorkPhase,
              pomodoroCycle: controller.pomodoroCompletedWorkSessions,
              pomodoroTotalCycles: controller.pomodoroLongBreakInterval,
              onTap: isRunning ? null : _showPomodoroConfigDialog,
            ),
          ),
        ),

        // Action Buttons (flex: 2)
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildCompactActionButtons(
                context,
                isRunning: isRunning,
                onPlayPause: () =>
                    isRunning ? controller.pause() : controller.startPomodoro(),
                onFinish: controller.finish,
                onReset: controller.reset,
                onSettings: _showPomodoroConfigDialog,
                onSkip: controller.activeMode == TimerMode.pomodoro
                    ? controller.skipPomodoroPhase
                    : null,
              ),
            ),
          ),
        ),
        if (controller.sessions.isNotEmpty) ...[
          _buildHistorySectionDivider(isDark),
          SizedBox(height: _historySectionHeight, child: _buildHistoryList()),
        ],
      ],
    );
  }

  Widget _buildHistoryList() {
    final l10n = AppLocalizations.of(context);
    final sessions = controller.sessions;
    final accent = _getAccentColor(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

    if (sessions.isEmpty) {
      return Center(
        child: Text(
          l10n.noEntriesYet,
          style:
              TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 4),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 16,
                color: textColor.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.historyTitle,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${sessions.length}',
                  style: TextStyle(
                    color: accent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              _BouncingTapWrapper(
                lowerBound: 0.90,
                duration: const Duration(milliseconds: 90),
                onTap: () {
                  _feedback();
                  controller.clearHistory();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 13,
                        color: textColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.clearHistory,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.5),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final s = sessions[index];
              final modeLabel = switch (s.mode) {
                TimerMode.stopwatch => l10n.timerTabStopwatch,
                TimerMode.countdown => l10n.timerTabCountdown,
                TimerMode.pomodoro => s.label ?? l10n.timerTabPomodoro,
              };
              final durStr = controller.formatDuration(s.duration);

              return _BouncingTapWrapper(
                lowerBound: 0.93,
                duration: const Duration(milliseconds: 90),
                onTap: () => _onSessionTap(index),
                child: Container(
                  width: 148,
                  margin: const EdgeInsets.only(right: 12, bottom: 8, top: 2),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: s.assigned
                        ? (isDark
                            ? accent.withValues(alpha: 0.14)
                            : accent.withValues(alpha: 0.08))
                        : theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: s.assigned
                          ? accent.withValues(alpha: isDark ? 0.45 : 0.35)
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: isDark ? 0.45 : 0.7,
                            ),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: s.assigned
                            ? accent.withValues(alpha: isDark ? 0.16 : 0.08)
                            : Colors.black
                                .withValues(alpha: isDark ? 0.22 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: s.assigned
                                  ? accent.withValues(alpha: 0.2)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFF1F5F9)),
                            ),
                            child: Icon(
                              _iconForMode(s.mode),
                              size: 14,
                              color: s.assigned
                                  ? accent
                                  : textColor.withValues(alpha: 0.6),
                            ),
                          ),
                          const Spacer(),
                          if (s.assigned)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 11,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    l10n.saved,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+ ${l10n.addHabit}',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            durStr,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            modeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDeleteSession(int index) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor:
            isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        title: Text(
          l10n.delete,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.removeSessionAt(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  IconData _iconForMode(TimerMode mode) => switch (mode) {
        TimerMode.stopwatch => Icons.timer_outlined,
        TimerMode.countdown => Icons.hourglass_bottom_outlined,
        TimerMode.pomodoro => Icons.local_fire_department_outlined,
      };

  void _showSaveDialog() {
    final l10n = AppLocalizations.of(context);
    final repo = HabitRepository.instance;
    final timerHabits =
        repo.habits.where((h) => h.habitType == HabitType.timer).toList();
    if (timerHabits.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.timerCreateTimerHabitFirst)));
      return;
    }
    String? selectedId = controller.activeTimerHabitId ??
        (timerHabits.isNotEmpty ? timerHabits.first.id : null);

    final accent = _getAccentColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor:
            isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        title: Text(
          l10n.timerSaveDurationTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.15),
                    accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accent.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time, color: accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    controller.formatDuration(controller.pendingDuration),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedId,
              decoration: InputDecoration(
                labelText: l10n.habit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: timerHabits
                  .map(
                    (h) => DropdownMenuItem(value: h.id, child: Text(h.title)),
                  )
                  .toList(),
              onChanged: (v) => selectedId = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedId != null) {
                await controller.savePendingToHabit(selectedId!);
                controller.setActiveTimerHabit(selectedId);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _onSessionTap(int index) {
    final l10n = AppLocalizations.of(context);
    final sessions = controller.sessions;
    if (index < 0 || index >= sessions.length) return;
    final s = sessions[index];
    if (s.assigned) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.timerSessionAlreadySaved)));
      return;
    }
    final repo = HabitRepository.instance;
    final timerHabits =
        repo.habits.where((h) => h.habitType == HabitType.timer).toList();
    if (timerHabits.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.timerCreateTimerHabitFirst)));
      return;
    }
    String? selectedId = controller.activeTimerHabitId ?? timerHabits.first.id;
    final accent = _getAccentColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor:
            isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        title: Text(
          l10n.timerSaveSessionTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.15),
                    accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accent.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time, color: accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    controller.formatDuration(s.duration),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedId,
              decoration: InputDecoration(
                labelText: l10n.habit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: timerHabits
                  .map(
                    (h) => DropdownMenuItem(value: h.id, child: Text(h.title)),
                  )
                  .toList(),
              onChanged: (v) => selectedId = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedId != null) {
                await controller.assignSessionToHabit(index, selectedId!);
                controller.setActiveTimerHabit(selectedId);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  // Countdown settings popup
  void _showCountdownConfigDialog() {
    final l10n = AppLocalizations.of(context);
    final accent = _getAccentColor(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.countdownConfigureTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _modernTimeField(
                    controller: _cdHours,
                    label: l10n.hours,
                    accent: accent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 24, color: accent),
                  ),
                ),
                Expanded(
                  child: _modernTimeField(
                    controller: _cdMinutes,
                    label: l10n.minutes,
                    accent: accent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 24, color: accent),
                  ),
                ),
                Expanded(
                  child: _modernTimeField(
                    controller: _cdSeconds,
                    label: l10n.seconds,
                    accent: accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.timerQuickPresets,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _modernPresetButton('1m', accent, minutes: 1),
                _modernPresetButton('5m', accent, minutes: 5),
                _modernPresetButton('10m', accent, minutes: 10),
                _modernPresetButton('15m', accent, minutes: 15),
                _modernPresetButton('25m', accent, minutes: 25),
                _modernPresetButton('30m', accent, minutes: 30),
                _modernPresetButton('45m', accent, minutes: 45),
                _modernPresetButton('1h', accent, hours: 1),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _BouncingTapWrapper(
                lowerBound: 0.94,
                duration: const Duration(milliseconds: 90),
                onTap: () {
                  _feedback();
                  _applyCountdown();
                  Navigator.pop(ctx);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernTimeField({
    required TextEditingController controller,
    required String label,
    required Color accent,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.white.withValues(alpha: 0.05),
                    ]
                  : [
                      colorScheme.surfaceContainerHighest,
                      colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.7,
                      ),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? colorScheme.outline.withValues(alpha: 0.15)
                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: accent,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 18),
            ),
            onSubmitted: (_) => _applyCountdown(),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _modernPresetButton(
    String label,
    Color accent, {
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _BouncingTapWrapper(
      lowerBound: 0.90,
      duration: const Duration(milliseconds: 80),
      onTap: () {
        _feedback();
        _cdHours.text = hours.toString();
        _cdMinutes.text = minutes.toString();
        _cdSeconds.text = seconds.toString();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: isDark ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent.withValues(alpha: isDark ? 0.35 : 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Pomodoro settings popup
  void _showPomodoroConfigDialog() {
    final l10n = AppLocalizations.of(context);
    final accent = _getAccentColor(context);
    final workCtrl = TextEditingController(
      text: controller.pomodoroWorkDuration.inMinutes.toString(),
    );
    final shortCtrl = TextEditingController(
      text: controller.pomodoroShortBreakDuration.inMinutes.toString(),
    );
    final longCtrl = TextEditingController(
      text: controller.pomodoroLongBreakDuration.inMinutes.toString(),
    );
    final intervalCtrl = TextEditingController(
      text: controller.pomodoroLongBreakInterval.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.timerPomodoroSettings,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _modernSettingField(
              controller: workCtrl,
              label: l10n.timerPomodoroWorkMinutesLabel,
              icon: Icons.laptop_mac,
              accent: accent,
            ),
            const SizedBox(height: 16),
            _modernSettingField(
              controller: shortCtrl,
              label: l10n.timerPomodoroShortBreakMinutesLabel,
              icon: Icons.coffee,
              accent: Colors.green,
            ),
            const SizedBox(height: 16),
            _modernSettingField(
              controller: longCtrl,
              label: l10n.timerPomodoroLongBreakMinutesLabel,
              icon: Icons.self_improvement,
              accent: Colors.blue,
            ),
            const SizedBox(height: 16),
            _modernSettingField(
              controller: intervalCtrl,
              label: l10n.timerPomodoroLongBreakIntervalLabel,
              icon: Icons.repeat,
              accent: Colors.orange,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _BouncingTapWrapper(
                lowerBound: 0.94,
                duration: const Duration(milliseconds: 90),
                onTap: () {
                  _feedback();
                  final w = int.tryParse(workCtrl.text) ?? 25;
                  final s = int.tryParse(shortCtrl.text) ?? 5;
                  final l = int.tryParse(longCtrl.text) ?? 15;
                  final iv = int.tryParse(intervalCtrl.text) ?? 4;
                  controller.setPomodoroConfig(
                    work: Duration(minutes: w),
                    shortBreak: Duration(minutes: s),
                    longBreak: Duration(minutes: l),
                    longBreakInterval: iv,
                  );
                  Navigator.pop(ctx);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernSettingField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accent,
  }) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.white.withValues(alpha: 0.05),
                ]
              : [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.15)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.20),
                  accent.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.85)
                    : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accent,
                fontFamily: 'monospace',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Text(
            l10n.minLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for circular progress
class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    required this.isAnimating,
    required this.animationValue,
  });

  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool isAnimating;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Animated glow effect when running
    if (isAnimating && progress > 0) {
      final glowPaint = Paint()
        ..color = progressColor.withValues(
          alpha: 0.3 * (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi)),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isAnimating != isAnimating ||
        oldDelegate.animationValue != animationValue;
  }
}

class _BouncingTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double lowerBound;
  final Duration duration;

  const _BouncingTapWrapper({
    required this.child,
    required this.onTap,
    this.lowerBound = 0.93,
    this.duration = const Duration(milliseconds: 110),
  });

  @override
  State<_BouncingTapWrapper> createState() => _BouncingTapWrapperState();
}

class _BouncingTapWrapperState extends State<_BouncingTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.lowerBound,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
