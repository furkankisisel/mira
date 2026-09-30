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

/// The unified quick creation hub designed to match the floating frosted-glass
/// capsule navbar with elevated tactile pill items.
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
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.85)
        : const Color(0xFFF1F3F5).withValues(alpha: 0.94);

    final capsuleBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.85);

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
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.22)
                                : Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Animated view transition between Main and Habit Types
                      if (_showHabitTypes)
                        _buildHabitTypesView(context, isTr, scheme, isDark, theme)
                      else
                        _buildMainView(context, isTr, scheme, isDark, theme),
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
                  Text(
                    isTr ? 'Hızlı Oluştur' : 'Quick Create',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    isTr
                        ? 'Ne eklemek istersiniz?'
                        : 'What would you like to add?',
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

        // Category 1: Gündelik & Rutin
        _buildCategoryHeader(
          context,
          title: isTr ? 'RUTİN VE GÖREV' : 'ROUTINES & TASKS',
          icon: Icons.wb_sunny_rounded,
        ),
        const SizedBox(height: 8),

        _QuickCreateTile(
          icon: Icons.repeat_rounded,
          iconColor: const Color(0xFF8B5CF6),
          title: isTr ? 'Alışkanlık' : 'Habit',
          subtitle: isTr
              ? 'Yeni rutin veya hedef takibi oluştur'
              : 'Track a new daily routine or goal',
          trailingIcon: Icons.arrow_forward_ios_rounded,
          trailingIconSize: 13,
          onTap: () {
            setState(() {
              _showHabitTypes = true;
            });
          },
        ),
        const SizedBox(height: 8),

        _QuickCreateTile(
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF10B981),
          title: isTr ? 'Günlük Görev' : 'Daily Task',
          subtitle: isTr
              ? 'Günün yapılacaklar listesine iş ekle'
              : 'Add a to-do item for today',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.dailyTask);
          },
        ),
        const SizedBox(height: 8),

        _QuickCreateTile(
          icon: Icons.format_list_bulleted_rounded,
          iconColor: const Color(0xFFF59E0B),
          title: isTr ? 'Yeni Liste' : 'New List',
          subtitle: isTr
              ? 'Alışkanlık ve görevleri grupla'
              : 'Group habits and tasks into a list',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.newList);
          },
        ),
        const SizedBox(height: 16),

        // Category 2: Gelecek & Finans
        _buildCategoryHeader(
          context,
          title: isTr ? 'GELECEK VE FİNANS' : 'FUTURE & WEALTH',
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 8),

        _QuickCreateTile(
          icon: Icons.auto_awesome_mosaic_rounded,
          iconColor: const Color(0xFF3B82F6),
          title: isTr ? 'Vizyon' : 'Vision',
          subtitle: isTr
              ? 'Uzun vadeli vizyon ve hedefler'
              : 'Long-term vision and goals',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.vision);
          },
        ),
        const SizedBox(height: 8),

        _QuickCreateTile(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: const Color(0xFFEC4899),
          title: isTr ? 'Finans Kaydı' : 'Finance Entry',
          subtitle: isTr
              ? 'Gelir veya harcama işlemi ekle'
              : 'Log an income or expense transaction',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.finance);
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
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
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
                        ? 'Nasıl bir alışkanlık oluşturmak istersiniz?'
                        : 'What kind of habit would you like?',
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

        _QuickCreateTile(
          icon: Icons.check_circle_outline_rounded,
          iconColor: scheme.primary,
          title: isTr ? 'Basit Alışkanlık' : 'Simple Habit',
          subtitle: isTr
              ? 'Günlük evet/hayır şeklinde pratik tamamlama'
              : 'Quick yes/no completion for daily routines',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.simpleHabit);
          },
        ),
        const SizedBox(height: 10),

        _QuickCreateTile(
          icon: Icons.auto_graph_rounded,
          iconColor: const Color(0xFF6366F1),
          badge: 'PRO',
          title: isTr ? 'Gelişmiş Alışkanlık' : 'Advanced Habit',
          subtitle: isTr
              ? 'Hedefli, alt görevli veya sayaç takipli'
              : 'Target-based, numerical or with subtasks',
          onTap: () {
            Navigator.of(context).pop(QuickCreateAction.advancedHabit);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark
                  ? scheme.primary.withValues(alpha: 0.18)
                  : scheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 11,
                  color: scheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// An aesthetic tactile elevated pill tile used for each creation option,
/// matching the active tab pill in CottonBottomBar.
class _QuickCreateTile extends StatelessWidget {
  const _QuickCreateTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.trailingIcon = Icons.add_rounded,
    this.trailingIconSize = 17,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;
  final IconData trailingIcon;
  final double trailingIconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Active pill background color matching CottonBottomBar
    final pillColor = isDark ? scheme.surfaceContainerHigh : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.95);

    return PressableScale(
      scale: 0.96,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: [
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
            // Squircle icon container with soft colored tint
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconColor.withValues(alpha: 0.18),
                    iconColor.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.20),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 22),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                      fontSize: 11.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tactile mini circular action icon
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
                trailingIcon,
                size: trailingIconSize,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
