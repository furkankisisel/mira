import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/room_service.dart';
import '../domain/room_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_habit_model.dart';
import '../domain/room_post_model.dart';
import '../domain/room_progress_models.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/daily_task_model.dart';
import '../../habit/domain/daily_task_repository.dart';
import '../../habit/presentation/simple_habit_screen.dart';
import '../../habit/presentation/advanced_habit_wizard_screen.dart';
import '../../habit/presentation/widgets/daily_task_dialog.dart';
import '../../../ui/premium_gate.dart';
import '../../habit/presentation/advanced_habit_screen.dart';
import '../../profile/profile_repository.dart';
import 'room_stats_card.dart';
import 'room_leaderboard_widget.dart';
import 'member_profile_screen.dart';
import '../../../design_system/components/banner_ad_widget.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:async';
import '../../../design_system/components/pressable_scale.dart';
import '../domain/room_score_model.dart';
import 'widgets/room_podium_widget.dart';
import 'widgets/room_overall_leaderboard.dart';

/// Detail view for a social room — live dashboard + notes.
class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUid == room.ownerId;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (room.emoji != null) ...[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(room.emoji!, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                room.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.2),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: colorScheme.outlineVariant
                      .withValues(alpha: isDark ? 0.45 : 0.7),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 18,
                tooltip: l10n.inviteCodeTooltip,
                icon: const Icon(Icons.share_outlined),
                onPressed: () => _showInviteCode(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: colorScheme.outlineVariant
                      .withValues(alpha: isDark ? 0.45 : 0.7),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: 19,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                onSelected: (v) => _handleMenu(context, v, isOwner),
                itemBuilder: (_) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: 'code',
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.copy_rounded),
                      title: Text(l10n.copyCodeTitle),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (isOwner)
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red),
                        title: Text(l10n.deleteRoomTitle,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  else
                    PopupMenuItem(
                      value: 'leave',
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.exit_to_app_rounded,
                            color: Colors.red),
                        title: Text(l10n.leaveRoomTitle,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RoomBody(roomId: room.id),
      floatingActionButton: _buildFloatingActionDock(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionDock(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          if (!isDark)
            const BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(0, -1),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Add Habit / Task Button
          _DockActionButton(
            icon: Icons.add_rounded,
            label: 'Alışkanlık Ekle',
            isPrimary: true,
            accent: cs.primary,
            isDark: isDark,
            onTap: () {
              HapticFeedback.lightImpact();
              _showAddMenu(context);
            },
          ),
          const SizedBox(width: 8),
          // 2. Share Note Button
          _DockActionButton(
            icon: Icons.edit_note_rounded,
            label: 'Not Paylaş',
            isPrimary: false,
            accent: const Color(0xFF10B981),
            isDark: isDark,
            onTap: () {
              HapticFeedback.lightImpact();
              _addNote(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Odaya Ekle',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Grup üyeleriyle birlikte takip edeceğiniz bir hedef belirleyin',
                style: TextStyle(
                  fontSize: 12.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              _AddOptionCard(
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF3B82F6),
                title: l10n.simpleHabitTitle,
                subtitle: l10n.simpleHabitSubtitle,
                onTap: () {
                  Navigator.pop(ctx);
                  _addSimpleHabit(context);
                },
              ),
              const SizedBox(height: 10),
              _AddOptionCard(
                icon: Icons.auto_graph_rounded,
                iconColor: const Color(0xFF8B5CF6),
                title: l10n.advancedHabitTitle,
                subtitle: l10n.advancedHabitSubtitle,
                trailingIcon: Icons.workspace_premium_rounded,
                onTap: () {
                  Navigator.pop(ctx);
                  _addAdvancedHabit(context);
                },
              ),
              const SizedBox(height: 10),
              _AddOptionCard(
                icon: Icons.task_alt_rounded,
                iconColor: const Color(0xFF10B981),
                title: l10n.dailyTaskTitle,
                subtitle: l10n.dailyTaskSubtitle,
                onTap: () {
                  Navigator.pop(ctx);
                  _addDailyTask(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSimpleHabit(BuildContext context) async {
    final habit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (_) => const SimpleHabitScreen()),
    );
    if (habit != null) {
      // 1. Add to local repo FIRST (Bugün screen)
      await HabitRepository.instance.addHabit(habit);
      // 2. Add to room (Firestore) — best-effort
      try {
        await RoomService.instance.addHabitToRoom(room.id, habit);
        await RoomService.instance.syncAllMyProgress();
      } catch (e) {
        debugPrint('Firestore write error: $e');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${habit.title} odaya eklendi! 🎯')),
        );
      }
    }
  }

  void _addAdvancedHabit(BuildContext context) async {
    // Gate: only premium users can create advanced habits
    final ok = await requirePremium(context);
    if (!ok) return;

    final habit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (_) => const AdvancedHabitWizardScreen()),
    );
    if (habit != null) {
      habit.isAdvanced = true;
      // 1. Add to local repo FIRST (Bugün screen)
      await HabitRepository.instance.addHabit(habit);
      // 2. Add to room (Firestore) — best-effort
      try {
        await RoomService.instance.addHabitToRoom(room.id, habit);
        await RoomService.instance.syncAllMyProgress();
      } catch (e) {
        debugPrint('Firestore write error: $e');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${habit.title} odaya eklendi! 🎯')),
        );
      }
    }
  }

  void _addDailyTask(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const DailyTaskDialog(),
    );
    if (result != null) {
      final title = (result['title'] as String?)?.trim() ?? '';
      final description = (result['description'] as String?)?.trim() ?? '';
      if (title.isEmpty) return;

      final now = DateTime.now();
      final dayKey =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // 1. Create DailyTask for local repo FIRST
      final task = DailyTask(
        id: UniqueKey().toString(),
        title: title,
        description: description,
        dateKey: dayKey,
      );
      await DailyTaskRepository.instance.addTask(task);

      // 2. Also store as RoomHabit in Firestore — best-effort
      try {
        final dummyHabit = Habit(
          id: 'task_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          description: description,
          icon: Icons.task_alt,
          emoji: '✅',
          color: const Color(0xFF22C55E),
          habitType: HabitType.simple,
          targetCount: 1,
          unit: '',
          currentStreak: 0,
          isCompleted: false,
          progressDate: dayKey,
          frequency: 'Günlük',
          frequencyType: 'daily',
          startDate: dayKey,
        );
        await RoomService.instance.addHabitToRoom(room.id, dummyHabit);
        await RoomService.instance.syncAllMyProgress();
      } catch (e) {
        debugPrint('Firestore write error: $e');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).taskAddedSnackbar(title))),
        );
      }
    }
  }

  void _addNote(BuildContext context) {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.shareNoteTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Odadaki arkadaşlarına motivasyon verici bir not bırak',
              style: TextStyle(
                fontSize: 12.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  hintText: l10n.shareNoteHint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final text = ctrl.text.trim();
                if (text.isEmpty) return;
                try {
                  await RoomService.instance.shareNote(room.id, text);
                } catch (e) {
                  debugPrint('Share note error: $e');
                }
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.noteSharedSnackbar),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.shareButton,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteCode(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  room.emoji ?? '👥',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.inviteCodeTooltip,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.shareInviteCodeMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: SelectableText(
                  room.inviteCode,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l10n.copyButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: room.inviteCode));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.inviteCodeCopiedSnackbar),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenu(BuildContext context, String value, bool isOwner) async {
    switch (value) {
      case 'code':
        Clipboard.setData(ClipboardData(text: room.inviteCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).inviteCodeCopiedSnackbar)),
        );
        break;
      case 'leave':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(context).leaveRoomTitle),
            content: Text(AppLocalizations.of(context).leaveRoomWarning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(AppLocalizations.of(context).cancelButton)),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(AppLocalizations.of(context).leaveButton)),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await RoomService.instance.leaveRoom(room.id);
          if (context.mounted) Navigator.of(context).pop();
        }
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(context).deleteRoomTitle),
            content: Text(AppLocalizations.of(context).deleteRoomWarning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(AppLocalizations.of(context).cancelButton)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(AppLocalizations.of(context).deleteButton),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await RoomService.instance.deleteRoom(room.id);
          if (context.mounted) Navigator.of(context).pop();
        }
        break;
    }
  }
}

// ─── Floating Action Dock Button ─────────────────────────

class _DockActionButton extends StatefulWidget {
  const _DockActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.accent,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final Color accent;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_DockActionButton> createState() => _DockActionButtonState();
}

class _DockActionButtonState extends State<_DockActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isPrimary
        ? widget.accent
        : (widget.isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFF1F5F9));
    final fg = widget.isPrimary
        ? Colors.white
        : (widget.isDark ? Colors.white : const Color(0xFF1E293B));

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add Option Card (Modal Bottom Sheet) ─────────────────

class _AddOptionCard extends StatefulWidget {
  const _AddOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingIcon,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  @override
  State<_AddOptionCard> createState() => _AddOptionCardState();
}

class _AddOptionCardState extends State<_AddOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      widget.iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (widget.trailingIcon != null) ...[
                          const SizedBox(width: 6),
                          Icon(
                            widget.trailingIcon,
                            size: 16,
                            color: const Color(0xFFFFB800),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Room Body (single scrollable) ───────────────────────

class RoomBody extends StatefulWidget {
  const RoomBody({super.key, required this.roomId});
  final String roomId;

  @override
  State<RoomBody> createState() => _RoomBodyState();
}

class _RoomBodyState extends State<RoomBody> {
  int _selectedTab =
      0; // 0: Sıralama & Podyum, 1: Alışkanlıklar & Görevler, 2: Notlar & Akış

  List<RoomMember> _members = [];
  List<RoomHabit> _habits = [];
  final Map<String, List<MemberProgress>> _progressMap = {};

  StreamSubscription? _membersSub;
  StreamSubscription? _habitsSub;
  final List<StreamSubscription> _progressSubs = [];

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _membersSub =
        RoomService.instance.streamMembers(widget.roomId).listen((members) {
      if (mounted) setState(() => _members = members);
    });

    _habitsSub =
        RoomService.instance.streamRoomHabits(widget.roomId).listen((habits) {
      if (mounted) {
        setState(() => _habits = habits);
        _updateProgressSubs(habits);
      }
    });
  }

  void _updateProgressSubs(List<RoomHabit> habits) {
    for (final s in _progressSubs) {
      s.cancel();
    }
    _progressSubs.clear();

    for (final h in habits) {
      final sub = RoomService.instance
          .streamHabitProgress(widget.roomId, h.id)
          .listen((list) {
        if (mounted) setState(() => _progressMap[h.id] = list);
      });
      _progressSubs.add(sub);
    }
  }

  @override
  void dispose() {
    _membersSub?.cancel();
    _habitsSub?.cancel();
    for (final s in _progressSubs) {
      s.cancel();
    }
    _progressSubs.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');

    final scores = RoomMemberScore.computeScores(
      members: _members,
      habits: _habits,
      habitProgressMap: _progressMap,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nudge banner
          _NudgeBanner(roomId: widget.roomId),

          // Members bar
          _MembersBar(roomId: widget.roomId),

          // Segmented Tabs
          _buildSegmentedTabs(isDark, isTr),
          const SizedBox(height: 6),

          // Tab Content
          if (_selectedTab == 0) ...[
            // ── Tab 0: Liderlik Kürsüsü & Genel Lig ──
            RoomPodiumWidget(
              scores: scores,
              roomId: widget.roomId,
              isDark: isDark,
              isTr: isTr,
            ),
            RoomOverallLeaderboard(
              scores: scores,
              roomId: widget.roomId,
              isDark: isDark,
              isTr: isTr,
            ),
          ] else if (_selectedTab == 1) ...[
            // ── Tab 1: Alışkanlıklar & İstatistik ──
            RoomStatsCard(roomId: widget.roomId),
            const _AdBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.rankingAndHabitsSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            _HabitsDashboard(roomId: widget.roomId),
          ] else ...[
            // ── Tab 2: Notlar & Paylaşımlar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.notesSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            _NotesFeed(roomId: widget.roomId),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs(bool isDark, bool isTr) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141924) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          _buildTabPill(
            index: 0,
            icon: Icons.emoji_events_rounded,
            label: isTr ? 'Sıralama' : 'Leaderboard',
            activeColor: const Color(0xFFF59E0B),
            isDark: isDark,
          ),
          _buildTabPill(
            index: 1,
            icon: Icons.track_changes_rounded,
            label: isTr ? 'Alışkanlıklar' : 'Habits',
            activeColor: const Color(0xFF0284C7),
            isDark: isDark,
          ),
          _buildTabPill(
            index: 2,
            icon: Icons.forum_rounded,
            label: isTr ? 'Notlar' : 'Notes',
            activeColor: const Color(0xFF10B981),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required bool isDark,
  }) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: PressableScale(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF1E2638) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
                    color: activeColor.withValues(alpha: isDark ? 0.35 : 0.20),
                    width: 1,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.06,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? activeColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: -0.2,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Members Bar ──────────────────────────────────────────

class _MembersBar extends StatelessWidget {
  const _MembersBar({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<RoomMember>>(
      stream: RoomService.instance.streamMembers(roomId),
      builder: (context, snap) {
        final members = snap.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.people_alt_rounded,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.roomMembersLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.membersCountText(members.length),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: members.length,
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final m = members[index];
                  final isMe = m.uid == FirebaseAuth.instance.currentUser?.uid;
                  return GestureDetector(
                    onTap: () => _openMemberProfile(context, m),
                    child: ListenableBuilder(
                      listenable: ProfileRepository.instance,
                      builder: (context, _) {
                        final profile = ProfileRepository.instance;
                        final name = isMe
                            ? (profile.name.isNotEmpty
                                ? profile.name
                                : m.displayName)
                            : m.displayName;

                        ImageProvider? avatar;
                        if (isMe) {
                          if (profile.avatarPath != null &&
                              profile.avatarPath!.isNotEmpty) {
                            avatar = FileImage(io.File(profile.avatarPath!));
                          } else if (profile.avatarUrl != null &&
                              profile.avatarUrl!.isNotEmpty) {
                            avatar = NetworkImage(profile.avatarUrl!);
                          }
                        } else if (m.avatarUrl != null) {
                          avatar = NetworkImage(m.avatarUrl!);
                        }

                        return Container(
                          width: 85,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow
                                .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'member_avatar_${m.uid}',
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: avatar == null
                                      ? theme.colorScheme.primaryContainer
                                      : null,
                                  backgroundImage: avatar,
                                  child: avatar == null
                                      ? Text(
                                          name.isNotEmpty
                                              ? name[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: theme
                                                .colorScheme.onPrimaryContainer,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                name,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openMemberProfile(BuildContext context, RoomMember member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MemberProfileScreen(
          roomId: roomId,
          member: member,
        ),
      ),
    );
  }
}

// ─── Habits Dashboard ─────────────────────────────────────

class _HabitsDashboard extends StatelessWidget {
  const _HabitsDashboard({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoomHabit>>(
      stream: RoomService.instance.streamRoomHabits(roomId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final habits = snap.data ?? [];
        if (habits.isEmpty) {
          return _EmptyHabits();
        }
        return Column(
          children:
              habits.map((h) => _HabitCard(roomId: roomId, habit: h)).toList(),
        );
      },
    );
  }
}

class _EmptyHabits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B202D) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.track_changes_rounded,
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Henüz alışkanlık eklenmemiş',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Alttaki dock üzerinden odaya bir alışkanlık veya günlük görev ekleyerek başlayın!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Card showing one room habit with leaderboard ranking.
class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.roomId, required this.habit});
  final String roomId;
  final RoomHabit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habitColor = habit.color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B202D) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: habitColor.withValues(alpha: isDark ? 0.30 : 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          if (!isDark)
            const BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(0, -1),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  habitColor.withOpacity(isDark ? 0.15 : 0.10),
                  habitColor.withOpacity(isDark ? 0.05 : 0.03),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: habitColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: habitColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    habit.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Show overall completion summary
                      StreamBuilder<List<MemberProgress>>(
                        stream: RoomService.instance
                            .streamHabitProgress(roomId, habit.id),
                        builder: (ctx, snap) {
                          final progress = snap.data ?? [];
                          final completed =
                              progress.where((p) => p.isCompleted).length;
                          final total = progress.length;
                          if (total == 0) return const SizedBox.shrink();
                          return Text(
                            '$completed/$total üye tamamladı',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Edit/Delete menu — only visible to creator
                if (FirebaseAuth.instance.currentUser?.uid == habit.createdBy)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert,
                        size: 18, color: theme.colorScheme.onSurfaceVariant),
                    tooltip: AppLocalizations.of(context).editDeleteTooltip,
                    onSelected: (val) async {
                      if (val == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                                AppLocalizations.of(context).deleteHabitTitle),
                            content: Text(AppLocalizations.of(context)
                                .deleteHabitConfirm(habit.title)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                    AppLocalizations.of(context).cancelButton),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: Text(
                                    AppLocalizations.of(context).deleteButton),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await RoomService.instance
                              .deleteRoomHabit(roomId, habit.id);
                        }
                      } else if (val == 'edit') {
                        final localHabit = HabitRepository.instance.habits
                            .where((h) => h.title == habit.title)
                            .firstOrNull;

                        if (localHabit == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .editOnlyPersonalHabits)),
                            );
                          }
                          return;
                        }

                        if (habit.isAdvanced) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdvancedHabitScreen(
                                  existingHabit: localHabit),
                            ),
                          );
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SimpleHabitScreen(existingHabit: localHabit),
                            ),
                          );
                        }

                        final updatedLocal =
                            HabitRepository.instance.findById(localHabit.id);
                        if (updatedLocal != null) {
                          await RoomService.instance.updateRoomHabit(
                            roomId: roomId,
                            habit: habit,
                            newTitle: updatedLocal.title,
                            newEmoji: updatedLocal.emoji,
                            newColorValue: updatedLocal.color.value,
                            newTargetCount: updatedLocal.targetCount,
                          );
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.edit_outlined),
                          title: Text(AppLocalizations.of(context).editButton),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          title: Text(AppLocalizations.of(context).deleteButton,
                              style: const TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Leaderboard (replaces old flat progress tiles)
          StreamBuilder<List<MemberProgress>>(
            stream: RoomService.instance.streamHabitProgress(roomId, habit.id),
            builder: (context, snap) {
              final progress = snap.data ?? [];
              return RoomLeaderboard(
                progressList: progress,
                roomId: roomId,
                habitColor: habitColor,
                habitTitle: habit.title,
              );
            },
          ),
        ],
      ),
    );
  }
}

// _MemberProgressTile removed — replaced by RoomLeaderboard widget.

// ─── Nudge Banner ────────────────────────────────────────

class _NudgeBanner extends StatelessWidget {
  const _NudgeBanner({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<RoomNudge>>(
      stream: RoomService.instance.streamMyNudges(roomId),
      builder: (ctx, snap) {
        final nudges = snap.data ?? [];
        if (nudges.isEmpty) return const SizedBox.shrink();

        return Column(
          children: nudges
              .map((nudge) => _NudgeCard(
                    nudge: nudge,
                    roomId: roomId,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _NudgeCard extends StatelessWidget {
  const _NudgeCard({required this.nudge, required this.roomId});
  final RoomNudge nudge;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFFFF6B35).withOpacity(0.15),
                  const Color(0xFFFFB800).withOpacity(0.08),
                ]
              : [
                  const Color(0xFFFF6B35).withOpacity(0.08),
                  const Color(0xFFFFB800).withOpacity(0.04),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          if (nudge.fromAvatarUrl != null)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(nudge.fromAvatarUrl!),
            )
          else
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFFF6B35).withOpacity(0.15),
              child: Text(
                nudge.fromName.isNotEmpty
                    ? nudge.fromName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF6B35)),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .nudgeNotification(nudge.fromName),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nudge.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
            onPressed: () {
              RoomService.instance.markNudgeRead(roomId, nudge.id);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }
}

// ─── Notes Feed ───────────────────────────────────────────

class _NotesFeed extends StatelessWidget {
  const _NotesFeed({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoomPost>>(
      stream: RoomService.instance.streamPosts(roomId),
      builder: (context, snap) {
        final posts = snap.data ?? [];
        if (posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text(
              AppLocalizations.of(context).noNotesYet,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Column(
          children: posts.map((p) => _NoteCard(post: p)).toList(),
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.post});
  final RoomPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B202D) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          if (!isDark)
            const BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(0, -1),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.authorAvatarUrl != null)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(post.authorAvatarUrl!),
            )
          else
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                post.authorName.isNotEmpty
                    ? post.authorName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
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
                      post.authorName,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _timeAgo(context, post.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  post.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (post.authorUid == currentUid) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 15,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              onPressed: () async {
                await RoomService.instance.deletePost(post.roomId, post.id);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60)
      return '${diff.inMinutes} ${l10n.minutesSuffixShort}';
    if (diff.inHours < 24) return '${diff.inHours} ${l10n.hoursSuffixShort}';
    if (diff.inDays < 7) return '${diff.inDays} ${l10n.daysSuffixShort}';
    return '${dt.day}.${dt.month}.${dt.year}';
  }
}

// ─── Ad Banner Widget ───────────────────────────────────────

class _AdBanner extends StatelessWidget {
  const _AdBanner();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BannerAdWidget(),
    );
  }
}
