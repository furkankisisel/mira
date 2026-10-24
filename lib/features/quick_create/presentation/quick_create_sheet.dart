import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import '../../../design_system/components/pressable_scale.dart';
import '../../../design_system/theme/theme_variations.dart';
import '../../../ui/premium_gate.dart';
import '../../finance/data/finance_category_repository.dart';
import '../../finance/data/transaction_repository.dart';
import '../../finance/finance_wizard_screen.dart';
import '../../habit/domain/daily_task_model.dart';
import '../../habit/domain/daily_task_repository.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/list_model.dart';
import '../../habit/domain/list_repository.dart';
import '../../habit/presentation/advanced_habit_wizard_screen.dart';
import '../../habit/presentation/simple_habit_wizard_screen.dart';
import '../../habit/presentation/widgets/daily_task_dialog.dart';
import '../../habit/presentation/widgets/list_creation_dialog.dart';
import '../../vision/data/vision_repository.dart';
import '../../vision/presentation/vision_wizard_screen.dart';

/// Available creation actions returned by the quick create modal sheet.
enum QuickCreateAction {
  simpleHabit,
  advancedHabit,
  dailyTask,
  newList,
  vision,
  finance,
}

/// Opens the unified Quick Create sheet from the bottom navbar.
///
/// Returns the selected action and executes navigation using the stable
/// root [context] to prevent deactivated widget lifecycle issues.
Future<void> showQuickCreateSheet(
  BuildContext context, {
  ThemeVariant variant = ThemeVariant.cotton,
}) async {
  final action = await showModalBottomSheet<QuickCreateAction>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.38),
    builder: (ctx) => QuickCreateSheet(variant: variant),
  );

  if (action == null || !context.mounted) return;

  final locale = Localizations.localeOf(context).toString();
  final isTr = locale.startsWith('tr');

  switch (action) {
    case QuickCreateAction.simpleHabit:
      final habit = await Navigator.of(context).push<Habit>(
        MaterialPageRoute(
          builder: (_) => const SimpleHabitWizardScreen(),
        ),
      );
      if (habit != null && context.mounted) {
        await HabitRepository.instance.addHabit(habit);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isTr
                    ? 'Alışkanlık oluşturuldu: ${habit.title}'
                    : 'Habit created: ${habit.title}',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
      break;

    case QuickCreateAction.advancedHabit:
      if (!await requirePremium(context)) return;
      if (!context.mounted) return;
      final habit = await Navigator.of(context).push<Habit>(
        MaterialPageRoute(
          builder: (_) => const AdvancedHabitWizardScreen(),
        ),
      );
      if (habit != null && context.mounted) {
        habit.isAdvanced = true;
        await HabitRepository.instance.addHabit(habit);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isTr
                    ? 'Alışkanlık oluşturuldu: ${habit.title}'
                    : 'Habit created: ${habit.title}',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
      break;

    case QuickCreateAction.dailyTask:
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => const DailyTaskDialog(),
      );
      if (result != null && context.mounted) {
        final title = (result['title'] as String?)?.trim() ?? '';
        final description = (result['description'] as String?)?.trim() ?? '';
        if (title.isEmpty) return;

        final now = DateTime.now();
        final dayKey =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final task = DailyTask(
          id: UniqueKey().toString(),
          title: title,
          description: description,
          dateKey: dayKey,
        );
        await DailyTaskRepository.instance.addTask(task);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isTr
                    ? 'Görev oluşturuldu: $title'
                    : 'Daily task created: $title',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
      break;

    case QuickCreateAction.newList:
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => const ListCreationDialog(),
      );
      if (result != null && context.mounted) {
        final title = (result['title'] as String?)?.trim() ?? '';
        if (title.isEmpty) return;

        final newList = AppList(id: UniqueKey().toString(), title: title);
        await ListRepository.instance.addList(newList);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isTr ? 'Liste oluşturuldu: $title' : 'List created: $title',
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
      break;

    case QuickCreateAction.vision:
      if (!await requirePremium(context)) return;
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              VisionWizardScreen(repo: VisionRepository.instance),
        ),
      );
      break;

    case QuickCreateAction.finance:
      final txRepo = TransactionRepository();
      final catRepo = FinanceCategoryRepository();
      await Future.wait([
        txRepo.initialize(),
        catRepo.initialize(),
      ]);
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FinanceWizardScreen(
            repo: txRepo,
            catRepo: catRepo,
          ),
        ),
      );
      break;
  }
}

/// The unified quick creation hub designed as a sweet, aesthetic, tactile
/// bento-launcher matching the floating frosted-glass capsule navbar.
class QuickCreateSheet extends StatefulWidget {
  const QuickCreateSheet({
    super.key,
    this.variant = ThemeVariant.cotton,
  });

  final ThemeVariant variant;

  @override
  State<QuickCreateSheet> createState() => _QuickCreateSheetState();
}

class _QuickCreateSheetState extends State<QuickCreateSheet> {
  bool _showHabitTypes = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');

    // Translucent frosted glass background matching CottonBottomBar
    final capsuleBgColor = isDark
        ? Color.alphaBlend(
            scheme.surfaceContainerHighest.withValues(alpha: 0.88),
            const Color(0xFF141715),
          )
        : Colors.white.withValues(alpha: 0.95);

    final capsuleBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.90);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          14 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
              if (!isDark)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.7),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: capsuleBgColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: capsuleBorderColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sleek Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.22)
                                : Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Animated view transition between Main and Habit Types
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: _showHabitTypes
                            ? _buildHabitTypesView(
                                context, isTr, scheme, isDark, theme)
                            : _buildMainView(
                                context, isTr, scheme, isDark, theme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Main Creation Options View ──

  Widget _buildMainView(
    BuildContext context,
    bool isTr,
    ColorScheme scheme,
    bool isDark,
    ThemeData theme,
  ) {
    return Column(
      key: const ValueKey('main_view'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sheet Header with Mini 3D Action Icon & Close Button
        Row(
          children: [
            // Mini Claymorphic Icon matching navbar action button
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary,
                    Color.lerp(scheme.primary, Colors.black, 0.14) ??
                        scheme.primary,
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: scheme.onPrimary,
                  size: 21,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isTr ? 'Hızlı Oluştur' : 'Quick Create',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '✨',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    isTr
                        ? 'Bugün ne başlatmak istersin?'
                        : 'What would you like to start?',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            PressableScale(
              scale: 0.88,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Bento Grid: Row 1 (Alışkanlık & Günlük Görev) ──
        Row(
          children: [
            Expanded(
              child: _QuickCreateGridCard(
                icon: Icons.repeat_rounded,
                iconGradient: const [
                  Color(0xFF8B5CF6),
                  Color(0xFF6D28D9),
                ],
                title: isTr ? 'Alışkanlık' : 'Habit',
                subtitle: isTr
                    ? 'Yeni rutin oluştur'
                    : 'Track a routine',
                trailingIcon: Icons.arrow_forward_ios_rounded,
                trailingIconSize: 11,
                onTap: () {
                  setState(() {
                    _showHabitTypes = true;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCreateGridCard(
                icon: Icons.check_circle_outline_rounded,
                iconGradient: const [
                  Color(0xFF10B981),
                  Color(0xFF059669),
                ],
                title: isTr ? 'Günlük Görev' : 'Daily Task',
                subtitle: isTr
                    ? 'Bugünün listesi'
                    : 'Add to-do item',
                trailingIcon: Icons.add_rounded,
                trailingIconSize: 16,
                onTap: () {
                  Navigator.of(context).pop(QuickCreateAction.dailyTask);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Bento Grid: Row 2 (Finans Kaydı & Yeni Liste) ──
        Row(
          children: [
            Expanded(
              child: _QuickCreateGridCard(
                icon: Icons.account_balance_wallet_rounded,
                iconGradient: const [
                  Color(0xFFF43F5E),
                  Color(0xFFE11D48),
                ],
                title: isTr ? 'Finans Kaydı' : 'Finance Entry',
                subtitle: isTr
                    ? 'Gelir veya gider'
                    : 'Income or expense',
                trailingIcon: Icons.add_rounded,
                trailingIconSize: 16,
                onTap: () {
                  Navigator.of(context).pop(QuickCreateAction.finance);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCreateGridCard(
                icon: Icons.format_list_bulleted_rounded,
                iconGradient: const [
                  Color(0xFFF59E0B),
                  Color(0xFFD97706),
                ],
                title: isTr ? 'Yeni Liste' : 'New List',
                subtitle: isTr
                    ? 'Ögeleri grupla'
                    : 'Group your items',
                trailingIcon: Icons.add_rounded,
                trailingIconSize: 16,
                onTap: () {
                  Navigator.of(context).pop(QuickCreateAction.newList);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Featured Banner: Vizyon Panosu ──
        _QuickCreateBannerCard(
          icon: Icons.auto_awesome_mosaic_rounded,
          iconGradient: const [
            Color(0xFF3B82F6),
            Color(0xFF1D4ED8),
          ],
          title: isTr ? 'Vizyon Panosu' : 'Vision Board',
          badge: 'PRO',
          subtitle: isTr
              ? 'Büyük hedeflerini görselleştir & planla'
              : 'Visualize long-term goals & dreams',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.vision);
          },
        ),
      ],
    );
  }

  // ── Habit Types Subview (Simple vs Advanced) ──

  Widget _buildHabitTypesView(
    BuildContext context,
    bool isTr,
    ColorScheme scheme,
    bool isDark,
    ThemeData theme,
  ) {
    return Column(
      key: const ValueKey('habit_types_view'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subview Header with Back button, Icon, and Close button
        Row(
          children: [
            PressableScale(
              scale: 0.88,
              onTap: () {
                setState(() {
                  _showHabitTypes = false;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.14)
                        : Colors.white.withValues(alpha: 0.9),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 19,
                  color: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF6D28D9),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.repeat_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTr ? 'Alışkanlık Türü' : 'Habit Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    isTr
                        ? 'Nasıl bir rutin başlatmak istersin? 🌱'
                        : 'How would you like to track it? 🌱',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            PressableScale(
              scale: 0.88,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        _QuickCreateOptionCard(
          icon: Icons.check_circle_outline_rounded,
          iconGradient: const [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
          title: isTr ? 'Basit Alışkanlık' : 'Simple Habit',
          badge: isTr ? 'PRATİK' : 'EASY',
          badgeGradient: const [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
          subtitle: isTr
              ? 'Günde tek dokunuşla evet/hayır tamamlama. Su içmek, kitap okumak gibi günlük rutinler için ideal.'
              : 'Quick daily yes/no completion. Ideal for drinking water, reading, or waking early.',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.simpleHabit);
          },
        ),
        const SizedBox(height: 12),

        _QuickCreateOptionCard(
          icon: Icons.auto_graph_rounded,
          iconGradient: const [
            Color(0xFF8B5CF6),
            Color(0xFF6366F1),
          ],
          badge: 'PRO',
          badgeGradient: const [
            Color(0xFFF59E0B),
            Color(0xFFD97706),
          ],
          title: isTr ? 'Gelişmiş Alışkanlık' : 'Advanced Habit',
          subtitle: isTr
              ? 'Hedefli sayaç (10.000 adım, 2 lt su) veya alt görevlerle detaylı takip.'
              : 'Target-based counters (10,000 steps, 2L water) or checklists with subtasks.',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.advancedHabit);
          },
        ),
      ],
    );
  }
}

/// A compact, tactile bento grid card for quick creation actions.
class _QuickCreateGridCard extends StatelessWidget {
  const _QuickCreateGridCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingIcon = Icons.arrow_forward_ios_rounded,
    this.trailingIconSize = 11,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final double trailingIconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark
        ? const Color(0xFF1F2220)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.90);

    return PressableScale(
      scale: 0.94,
      onTap: onTap,
      child: Container(
        height: 104,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: iconGradient.first.withValues(alpha: isDark ? 0.18 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
            if (!isDark)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 2,
                offset: const Offset(0, -1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 3D squircle icon badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: iconGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: iconGradient.first.withValues(alpha: 0.38),
                        blurRadius: 8,
                        offset: const Offset(0, 2.5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 19),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                  ),
                  child: Center(
                    child: Icon(
                      trailingIcon,
                      size: trailingIconSize,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    letterSpacing: -0.2,
                    color: scheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
                    fontSize: 11,
                    letterSpacing: -0.1,
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
  }
}

/// A sleek, tactile featured banner card spanning full width.
class _QuickCreateBannerCard extends StatelessWidget {
  const _QuickCreateBannerCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark
        ? const Color(0xFF1F2220)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.90);

    return PressableScale(
      scale: 0.95,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: iconGradient.first.withValues(alpha: isDark ? 0.16 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
            if (!isDark)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 2,
                offset: const Offset(0, -1),
              ),
          ],
        ),
        child: Row(
          children: [
            // 3D squircle icon container
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: iconGradient,
                ),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.first.withValues(alpha: 0.38),
                    blurRadius: 8,
                    offset: const Offset(0, 2.5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 21),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: -0.2,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B)
                                    .withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
                      fontSize: 11.5,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A detailed tactile option card for habit sub-selection.
class _QuickCreateOptionCard extends StatelessWidget {
  const _QuickCreateOptionCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.badgeGradient,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;
  final List<Color>? badgeGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark
        ? const Color(0xFF1F2220)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.95);

    return PressableScale(
      scale: 0.96,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: iconGradient.first.withValues(alpha: isDark ? 0.16 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            if (!isDark)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 2,
                offset: const Offset(0, -1),
              ),
          ],
        ),
        child: Row(
          children: [
            // Squircle icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: iconGradient,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.first.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2.5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: -0.2,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: badgeGradient ??
                                  const [
                                    Color(0xFFF59E0B),
                                    Color(0xFFD97706),
                                  ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: (badgeGradient?.first ??
                                        const Color(0xFFF59E0B))
                                    .withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : const Color(0xFFF1F3F5),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 17,
                color: iconGradient.first,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
