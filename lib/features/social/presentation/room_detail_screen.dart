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
import '../../habit/domain/subtask_model.dart';
import '../../habit/presentation/simple_habit_wizard_screen.dart';
import '../../habit/presentation/advanced_habit_wizard_screen.dart';
import '../../habit/presentation/simple_habit_screen.dart';
import '../../habit/presentation/advanced_habit_screen.dart';
import '../../habit/presentation/widgets/habit_card.dart';
import '../../profile/profile_repository.dart';
import 'room_stats_card.dart';
import 'member_profile_screen.dart';
import '../../../design_system/components/banner_ad_widget.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:async';
import '../../../design_system/components/pressable_scale.dart';
import '../domain/room_score_model.dart';
import 'widgets/room_podium_widget.dart';
import 'widgets/room_overall_leaderboard.dart';
import 'widgets/room_date_selector_bar.dart';
import 'package:intl/intl.dart';

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
    final l10n = AppLocalizations.of(context);

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
            label: l10n.addHabit,
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
            label: l10n.shareNoteTitle,
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
    _openRoomHabitCreationFlow(context, room.id);
  }


  void _addNote(BuildContext context) {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTr = l10n.localeName.startsWith('tr');

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
              isTr
                  ? 'Odadaki arkadaşlarına motivasyon verici bir not bırak'
                  : 'Leave an encouraging note for your room members',
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
        : Theme.of(context).colorScheme.onSurface;

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
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

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
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  StreamSubscription? _membersSub;
  StreamSubscription? _habitsSub;
  final List<StreamSubscription> _progressSubs = [];
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initStreams();
  }

  void _initStreams() {
    _membersSub =
        RoomService.instance.streamMembers(widget.roomId).listen((members) {
      if (mounted) {
        final changed = _members.length != members.length ||
            !_members.every((oldM) => members.any((newM) =>
                newM.uid == oldM.uid &&
                newM.displayName == oldM.displayName &&
                newM.avatarUrl == oldM.avatarUrl));
        _members = members;
        if (changed) {
          setState(() {});
        }
      }
    });

    _habitsSub =
        RoomService.instance.streamRoomHabits(widget.roomId).listen((habits) {
      if (mounted) {
        final changed = _habits.length != habits.length ||
            !_habits.every((oldH) => habits.any((newH) =>
                newH.id == oldH.id &&
                newH.title == oldH.title &&
                newH.targetCount == oldH.targetCount &&
                newH.color == oldH.color));
        _habits = habits;
        if (changed) {
          setState(() {});
          _updateProgressSubs(habits);
        }
      }
    });
  }

  void _updateProgressSubs(List<RoomHabit> habits) {
    for (final s in _progressSubs) {
      s.cancel();
    }
    _progressSubs.clear();

    for (final h in habits) {
      final cached = RoomService.instance
          .getHabitProgressInMemory(widget.roomId, h.id);
      if (cached.isNotEmpty) {
        _progressMap[h.id] = cached;
      }
      final sub = RoomService.instance
          .streamHabitProgress(widget.roomId, h.id)
          .listen((list) {
        _progressMap[h.id] = list;
        // Only trigger setState if currently viewing Leaderboard (tab 1), where scores depend on progressMap!
        if (mounted && _selectedTab == 1) {
          setState(() {});
        }
      });
      _progressSubs.add(sub);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    final habitsForDate = _habits
        .where((h) => h.isScheduledForDate(_selectedDate))
        .toList();

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 110),
      physics: const ClampingScrollPhysics(),
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
            // ── Tab 0: Alışkanlıklar & İlerleme ──
            RoomDateSelectorBar(
              selectedDate: _selectedDate,
              onDateSelected: (newDate) {
                setState(() {
                  _selectedDate = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                  );
                });
              },
            ),
            RoomStatsCard(roomId: widget.roomId, habits: habitsForDate),
            const _AdBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Text(
                    isTr ? 'Oda Alışkanlıkları' : 'Room Habits',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${habitsForDate.length} ${isTr ? "hedef" : "goals"}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _HabitsDashboard(
              roomId: widget.roomId,
              roomMembers: _members,
              habits: habitsForDate,
              allRoomHabitsCount: _habits.length,
              selectedDate: _selectedDate,
              onResetToToday: () {
                setState(() {
                  final now = DateTime.now();
                  _selectedDate = DateTime(now.year, now.month, now.day);
                });
              },
            ),
          ] else if (_selectedTab == 1) ...[
            // ── Tab 1: Sıralama & Podyum ──
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
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        children: [
          _buildTabPill(
            index: 0,
            icon: Icons.track_changes_rounded,
            label: l10n.habits,
            activeColor: const Color(0xFF0284C7),
            isDark: isDark,
          ),
          _buildTabPill(
            index: 1,
            icon: Icons.emoji_events_rounded,
            label: isTr ? 'Sıralama' : 'Leaderboard',
            activeColor: const Color(0xFFF59E0B),
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
    final colorScheme = Theme.of(context).colorScheme;

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
                ? colorScheme.surfaceContainerHighest
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
                size: 15,
                color: isSelected
                    ? activeColor
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: -0.2,
                    color: isSelected
                        ? colorScheme.onSurface
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
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
    final isTr = l10n.localeName.startsWith('tr');

    return StreamBuilder<List<RoomMember>>(
      stream: RoomService.instance.streamMembers(roomId),
      builder: (context, snap) {
        final members = snap.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    size: 15,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.roomMembersLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${members.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                separatorBuilder: (context, _) => const SizedBox(width: 10),
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

                        return SizedBox(
                          width: 52,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'member_avatar_${m.uid}',
                                child: Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isMe
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outlineVariant
                                              .withValues(alpha: 0.35),
                                      width: isMe ? 1.8 : 1.1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 17,
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
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: theme
                                                  .colorScheme.onPrimaryContainer,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isMe ? (isTr ? 'Sen' : 'You') : name,
                                style: TextStyle(
                                  fontWeight:
                                      isMe ? FontWeight.w800 : FontWeight.w600,
                                  fontSize: 10,
                                  color: isMe
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
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

// ─── Habits Dashboard ─────────────────────────────────────

class _HabitsDashboard extends StatelessWidget {
  const _HabitsDashboard({
    required this.roomId,
    required this.roomMembers,
    required this.habits,
    required this.allRoomHabitsCount,
    required this.selectedDate,
    required this.onResetToToday,
  });

  final String roomId;
  final List<RoomMember> roomMembers;
  final List<RoomHabit> habits;
  final int allRoomHabitsCount;
  final DateTime selectedDate;
  final VoidCallback onResetToToday;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      if (allRoomHabitsCount == 0) {
        return _EmptyHabits(roomId: roomId);
      }
      return _EmptyHabitsForDate(
        roomId: roomId,
        selectedDate: selectedDate,
        onResetToToday: onResetToToday,
      );
    }
    return Column(
      children: habits
          .map((h) => _InteractiveRoomHabitCard(
                key: ValueKey(
                    'room_habit_${h.id}_${selectedDate.year}_${selectedDate.month}_${selectedDate.day}'),
                roomId: roomId,
                habit: h,
                roomMembers: roomMembers,
                selectedDate: selectedDate,
              ))
          .toList(),
    );
  }
}

class _EmptyHabitsForDate extends StatelessWidget {
  const _EmptyHabitsForDate({
    required this.roomId,
    required this.selectedDate,
    required this.onResetToToday,
  });

  final String roomId;
  final DateTime selectedDate;
  final VoidCallback onResetToToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isFuture = targetDay.isAfter(today);

    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');
    final dateStr = DateFormat.MMMMd(locale).format(selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isFuture
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.12)
                    : theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFuture
                    ? Icons.event_available_rounded
                    : Icons.calendar_today_rounded,
                size: 26,
                color: isFuture
                    ? const Color(0xFFF59E0B)
                    : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isTr ? 'Bu Tarihte Hedef Yok' : 'No Habits on this Date',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isTr
                  ? '$dateStr tarihinde odada planlanmış aktif bir alışkanlık veya görev bulunmuyor.'
                  : 'No active habits scheduled for $dateStr in this room.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12.5,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onResetToToday,
              icon: const Icon(Icons.today_rounded, size: 17),
              label: Text(isTr ? 'Bugüne Dön' : 'Back to Today'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHabits extends StatelessWidget {
  const _EmptyHabits({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.track_changes_rounded,
                size: 30,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.noHabitsInRoom,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.addHabitToRoomPrompt,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12.5,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => _openRoomHabitCreationFlow(context, roomId),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.addHabit),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive room habit card with native-feeling animations, completion tracking,
/// steppers, member completion drawer, and creator-only controls.
class _InteractiveRoomHabitCard extends StatefulWidget {
  const _InteractiveRoomHabitCard({
    super.key,
    required this.roomId,
    required this.habit,
    required this.roomMembers,
    required this.selectedDate,
  });

  final String roomId;
  final RoomHabit habit;
  final List<RoomMember> roomMembers;
  final DateTime selectedDate;

  @override
  State<_InteractiveRoomHabitCard> createState() =>
      _InteractiveRoomHabitCardState();
}

class _InteractiveRoomHabitCardState extends State<_InteractiveRoomHabitCard> {
  bool _isExpanded = false;

  DateTime get _targetDayOnly => DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      );

  DateTime get _todayDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get _isToday => _targetDayOnly == _todayDate;
  bool get _isFuture => _targetDayOnly.isAfter(_todayDate);

  String get _dateStr =>
      '${_targetDayOnly.year.toString().padLeft(4, "0")}-${_targetDayOnly.month.toString().padLeft(2, "0")}-${_targetDayOnly.day.toString().padLeft(2, "0")}';

  Stream<List<MemberProgress>>? _progressStream;
  Stream<List<ProgressHistoryEntry>>? _historyStream;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    if (_isToday) {
      _progressStream = RoomService.instance
          .streamHabitProgress(widget.roomId, widget.habit.id);
      _historyStream = null;
    } else if (!_isFuture) {
      _historyStream = RoomService.instance.streamHabitProgressHistoryForDate(
        roomId: widget.roomId,
        habitId: widget.habit.id,
        date: _dateStr,
      );
      _progressStream = null;
    } else {
      _progressStream = null;
      _historyStream = null;
    }
  }

  @override
  void didUpdateWidget(covariant _InteractiveRoomHabitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldDay = DateTime(
      oldWidget.selectedDate.year,
      oldWidget.selectedDate.month,
      oldWidget.selectedDate.day,
    );
    if (oldWidget.roomId != widget.roomId ||
        oldWidget.habit.id != widget.habit.id ||
        oldDay != _targetDayOnly) {
      _initStreams();
    }
  }

  Future<void> _openEditSheet() async {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (widget.habit.createdBy != currentUid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isTr
              ? 'Sadece alışkanlığı oluşturan kişi düzenleyebilir.'
              : 'Only the creator can edit this habit.'),
        ),
      );
      return;
    }

    final habitToEdit = widget.habit.toHabit(
      roomId: widget.roomId,
      date: widget.selectedDate,
    );
    final edited = habitToEdit.habitType == HabitType.simple &&
            !habitToEdit.isAdvanced
        ? await Navigator.of(context).push<Habit>(
            MaterialPageRoute(
              builder: (_) => SimpleHabitScreen(
                existingHabit: habitToEdit,
                isDateLocked: true,
              ),
            ),
          )
        : await Navigator.of(context).push<Habit>(
            MaterialPageRoute(
              builder: (_) => AdvancedHabitScreen(
                existingHabit: habitToEdit,
                isDateLocked: true,
              ),
            ),
          );

    if (edited != null && mounted) {
      final updated = RoomHabit.fromHabit(
        edited,
        createdBy: widget.habit.createdBy,
        createdAt: widget.habit.createdAt,
        id: widget.habit.id,
      );
      await RoomService.instance.updateRoomHabitFull(widget.roomId, updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                isTr ? 'Oda alışkanlığı güncellendi' : 'Room habit updated'),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isTr ? 'Alışkanlığı Sil' : 'Delete Habit'),
        content: Text(
          isTr
              ? '"${widget.habit.title}" alışkanlığı odadaki tüm üyeler için silinecek. Emin misiniz?'
              : 'The habit "${widget.habit.title}" will be deleted for all members. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isTr ? 'Herkes İçin Sil' : 'Delete for Everyone'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await RoomService.instance.deleteRoomHabit(
        widget.roomId,
        widget.habit.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final habitColor = widget.habit.color;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isCreator = currentUid != null && currentUid == widget.habit.createdBy;
    final totalMembers =
        widget.roomMembers.isNotEmpty ? widget.roomMembers.length : 1;

    if (_isFuture) {
      return _buildCardUI(
        theme: theme,
        isDark: isDark,
        habitColor: habitColor,
        isCompleted: false,
        value: 0,
        streak: 0,
        completedSubtaskIds: const [],
        completedUids: const {},
        isCreator: isCreator,
        totalMembers: totalMembers,
        memberValues: const {},
      );
    }

    if (_isToday) {
      return StreamBuilder<List<MemberProgress>>(
        stream: _progressStream,
        initialData: RoomService.instance
            .getHabitProgressInMemory(widget.roomId, widget.habit.id),
        builder: (context, snap) {
          final progressList = (snap.data != null && snap.data!.isNotEmpty)
              ? snap.data!
              : RoomService.instance
                  .getHabitProgressInMemory(widget.roomId, widget.habit.id);
          final myProgress = progressList
                  .where((p) => p.uid == currentUid)
                  .firstOrNull ??
              RoomService.instance
                  .getMemberProgressInMemory(widget.roomId, widget.habit.id);
          final isCompletedToday = myProgress?.isCompletedToday ?? false;
          final todayValue = myProgress?.todayValue ?? 0;
          final streak = myProgress?.streak ?? 0;
          final completedUids = progressList
              .where((p) => p.isCompletedToday)
              .map((p) => p.uid)
              .toSet();
          final memberValues = {
            for (final p in progressList) p.uid: p.todayValue,
          };
          final completedSubtasks =
              myProgress?.completedSubtaskIds ?? const <String>[];

          return _buildCardUI(
            theme: theme,
            isDark: isDark,
            habitColor: habitColor,
            isCompleted: isCompletedToday,
            value: todayValue,
            streak: streak,
            completedSubtaskIds: completedSubtasks,
            completedUids: completedUids,
            isCreator: isCreator,
            totalMembers: totalMembers,
            memberValues: memberValues,
          );
        },
      );
    }

    // Past date: stream history
    return StreamBuilder<List<ProgressHistoryEntry>>(
      stream: _historyStream,
      builder: (context, snap) {
        final historyList = snap.data ?? const <ProgressHistoryEntry>[];
        final myEntry =
            historyList.where((e) => e.uid == currentUid).firstOrNull;
        final isCompleted = myEntry?.isCompleted ?? false;
        final todayValue = myEntry?.value ?? 0;
        final completedUids = historyList
            .where((e) => e.isCompleted)
            .map((e) => e.uid)
            .toSet();
        final memberValues = {
          for (final e in historyList) e.uid: e.value,
        };
        final completedSubtasks =
            myEntry?.completedSubtaskIds ?? const <String>[];

        return _buildCardUI(
          theme: theme,
          isDark: isDark,
          habitColor: habitColor,
          isCompleted: isCompleted,
          value: todayValue,
          streak: 0,
          completedSubtaskIds: completedSubtasks,
          completedUids: completedUids,
          isCreator: isCreator,
          totalMembers: totalMembers,
          memberValues: memberValues,
        );
      },
    );
  }

  Widget _buildCardUI({
    required ThemeData theme,
    required bool isDark,
    required Color habitColor,
    required bool isCompleted,
    required int value,
    required int streak,
    required List<String> completedSubtaskIds,
    required Set<String> completedUids,
    required bool isCreator,
    required int totalMembers,
    required Map<String, int> memberValues,
  }) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final completedCount = completedUids.length;
    final habitSubtitle = widget.habit.isNumerical
        ? '${isTr ? "Hedef" : "Target"}: ${widget.habit.targetCount} ${widget.habit.unit ?? ""} • $completedCount/$totalMembers ${isTr ? "üye" : "members"}'
        : l10n.membersCompletedStatus(completedCount, totalMembers);

    final completedMembers = widget.roomMembers
        .where((m) => completedUids.contains(m.uid))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HabitCard(
          key: ValueKey(
              'habit_card_${widget.habit.id}_${widget.selectedDate.year}_${widget.selectedDate.month}_${widget.selectedDate.day}'),
          heroTag:
              'room_${widget.roomId}_${widget.habit.id}_${widget.selectedDate.millisecondsSinceEpoch}',
          title: widget.habit.title,
          description: habitSubtitle,
          icon: Icons.track_changes,
          emoji: widget.habit.emoji,
          color: habitColor,
          currentStreak: value,
          streakCount: streak,
          targetCount: widget.habit.targetCount,
          isCompleted: isCompleted,
          habitType: widget.habit.habitType,
          numericalTargetType: widget.habit.numericalTargetType,
          timerTargetType: widget.habit.timerTargetType,
          unit: widget.habit.unit,
          categoryName: isTr ? 'Sosyal Hedef' : 'Social Goal',
          readOnly: _isFuture,
          subtasks: widget.habit.subtasks.map((s) {
            final isDone = completedSubtaskIds.contains(s.id);
            return Subtask(id: s.id, title: s.title, isCompleted: isDone);
          }).toList(),
          onSubtaskToggle: (subtaskId, completed) {
            if (_isFuture) return;
            RoomService.instance.toggleMyRoomHabitSubtask(
              roomId: widget.roomId,
              habitId: widget.habit.id,
              habit: widget.habit,
              subtaskId: subtaskId,
              isCompleted: completed,
              date: widget.selectedDate,
            );
          },
          showStreakIndicator: false,
          margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          onTap: () {
            if (_isFuture) {
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isTr
                              ? 'Gelecek günlerin alışkanlıkları gününden önce işaretlenemez.'
                              : 'Habits for future days cannot be marked in advance.',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
              return;
            }
            RoomService.instance.updateMyRoomHabitProgress(
              roomId: widget.roomId,
              habitId: widget.habit.id,
              habit: widget.habit,
              isCompleted: !isCompleted,
              date: widget.selectedDate,
            );
          },
          onValueUpdate: (newValue) {
            if (_isFuture) return;
            RoomService.instance.updateMyRoomHabitProgress(
              roomId: widget.roomId,
              habitId: widget.habit.id,
              habit: widget.habit,
              value: newValue,
              date: widget.selectedDate,
            );
          },
          onEdit: isCreator ? _openEditSheet : null,
          onDelete: isCreator ? _confirmDelete : null,
        ),

        // Attached Social Progress & Member breakdown footer
        _buildSocialProgressFooter(
          theme: theme,
          isDark: isDark,
          habitColor: habitColor,
          completedMembers: completedMembers,
          completedUids: completedUids,
          totalMembers: totalMembers,
          isCreator: isCreator,
          memberValues: memberValues,
        ),
      ],
    );
  }

  Widget _buildSocialProgressFooter({
    required ThemeData theme,
    required bool isDark,
    required Color habitColor,
    required List<RoomMember> completedMembers,
    required Set<String> completedUids,
    required int totalMembers,
    required bool isCreator,
    required Map<String, int> memberValues,
  }) {
    final l10n = AppLocalizations.of(context);
    final isTr = l10n.localeName.startsWith('tr');
    final completedCount = completedMembers.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    size: 15,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.membersCompletedStatus(
                          completedCount, totalMembers),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Avatar stack of completed members
                  if (completedMembers.isNotEmpty)
                    SizedBox(
                      height: 22,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...completedMembers.take(2).map((m) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage: m.avatarUrl != null
                                    ? NetworkImage(m.avatarUrl!)
                                    : null,
                                backgroundColor:
                                    habitColor.withValues(alpha: 0.3),
                                child: m.avatarUrl == null
                                    ? Text(
                                        m.displayName.isNotEmpty
                                            ? m.displayName[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : null,
                              ),
                            );
                          }),
                          if (completedMembers.length > 2)
                            Text(
                              '+${completedMembers.length - 2}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  if (isCreator) ...[
                    const SizedBox(width: 2),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                      tooltip:
                          isTr ? 'Alışkanlık İşlemleri' : 'Habit Actions',
                      onSelected: (val) {
                        if (val == 'edit') {
                          _openEditSheet();
                        } else if (val == 'delete') {
                          _confirmDelete();
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            dense: true,
                            leading:
                                const Icon(Icons.edit_outlined, size: 18),
                            title: Text(l10n.editButton),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            title: Text(
                                isTr ? 'Herkes İçin Sil' : 'Delete for Everyone',
                                style: const TextStyle(color: Colors.red)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expanded Member Breakdown
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Column(
                children: widget.roomMembers.map((member) {
                  final isDone = completedUids.contains(member.uid);
                  final currentUid =
                      FirebaseAuth.instance.currentUser?.uid;
                  final isMe = member.uid == currentUid;
                  final memberVal = memberValues[member.uid] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: member.avatarUrl != null
                              ? NetworkImage(member.avatarUrl!)
                              : null,
                          backgroundColor:
                              habitColor.withValues(alpha: 0.2),
                          child: member.avatarUrl == null
                              ? Text(
                                  member.displayName.isNotEmpty
                                      ? member.displayName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isMe
                                ? '${member.displayName} (${isTr ? "Sen" : "You"})'
                                : member.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isMe
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isDone)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isTr ? 'Tamamladı ✅' : 'Completed ✅',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          )
                        else ...[
                          Flexible(
                            child: Text(
                              _isFuture
                                  ? (isTr ? 'Bekliyor' : 'Upcoming')
                                  : (widget.habit.isNumerical && memberVal > 0
                                      ? '$memberVal / ${widget.habit.targetCount}'
                                      : (isTr ? 'Tamamlamadı' : 'Incomplete')),
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isMe && !_isFuture) ...[
                            const SizedBox(width: 6),
                            PressableScale(
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                await RoomService.instance.sendNudge(
                                  roomId: widget.roomId,
                                  toUid: member.uid,
                                  toName: member.displayName,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isTr
                                          ? '${member.displayName} dürtüldü! ⚡'
                                          : '${member.displayName} nudged! ⚡'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.bolt_rounded,
                                        size: 12, color: Color(0xFFFF6B35)),
                                    const SizedBox(width: 2),
                                    Text(
                                      isTr ? 'Dürt' : 'Nudge',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFF6B35),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Room Habit Creation Flow ─────────────────────────

Future<void> _openRoomHabitCreationFlow(BuildContext context, String roomId) async {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final l10n = AppLocalizations.of(context);
  final isTr = Localizations.localeOf(context).toString().startsWith('tr');

  final habitType = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: theme.colorScheme.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isTr ? 'Oda Alışkanlığı Oluştur' : 'Create Room Habit',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isTr
                  ? 'Tüm oda üyeleri bu alışkanlığı takip edecek.'
                  : 'All room members will track this habit.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Simple habit option
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.pop(ctx, 'simple'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFF6366F1),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.simpleHabitTitle,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.simpleHabitSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Advanced habit option
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.pop(ctx, 'advanced'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_graph_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.advancedHabit,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.advancedHabitSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );

  if (habitType == null || !context.mounted) return;

  final Habit? createdHabit = habitType == 'simple'
      ? await Navigator.of(context).push<Habit>(
          MaterialPageRoute(
            builder: (_) => const SimpleHabitWizardScreen(),
          ),
        )
      : await Navigator.of(context).push<Habit>(
          MaterialPageRoute(
            builder: (_) => const AdvancedHabitWizardScreen(),
          ),
        );

  if (createdHabit != null && context.mounted) {
    await RoomService.instance.addHabitToRoom(roomId, createdHabit);
    if (context.mounted) {
      final l10nCtx = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10nCtx.addedToRoomSnackbar(createdHabit.title)),
        ),
      );
    }
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
        color: theme.colorScheme.surfaceContainerHigh,
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
