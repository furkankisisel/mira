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


/// Detail view for a social room — live dashboard + notes.
class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUid == room.ownerId;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (room.emoji != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(room.emoji!, style: const TextStyle(fontSize: 20)),
              ),
            Flexible(child: Text(room.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).inviteCodeTooltip,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showInviteCode(context),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => _handleMenu(context, v, isOwner),
            itemBuilder: (_) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'code',
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.copy),
                  title: Text(AppLocalizations.of(context).copyCodeTitle),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (isOwner)
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title:
                        Text(AppLocalizations.of(context).deleteRoomTitle, style: const TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              else
                PopupMenuItem(
                  value: 'leave',
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.exit_to_app, color: Colors.red),
                    title: Text(AppLocalizations.of(context).leaveRoomTitle,
                        style: const TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _RoomBody(roomId: room.id),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'room_add_item',
            tooltip: AppLocalizations.of(context).addFabTooltip,
            onPressed: () => _showAddMenu(context),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'room_add_note',
            tooltip: AppLocalizations.of(context).shareNoteTitle,
            onPressed: () => _addNote(context),
            child: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bolt),
              title: Text(l10n.simpleHabitTitle),
              subtitle: Text(l10n.simpleHabitSubtitle),
              onTap: () {
                Navigator.pop(ctx);
                _addSimpleHabit(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.auto_graph),
              title: Text(l10n.advancedHabitTitle),
              subtitle: Text(l10n.advancedHabitSubtitle),
              trailing: const Icon(Icons.workspace_premium, size: 18),
              onTap: () {
                Navigator.pop(ctx);
                _addAdvancedHabit(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(l10n.dailyTaskTitle),
              subtitle: Text(l10n.dailyTaskSubtitle),
              onTap: () {
                Navigator.pop(ctx);
                _addDailyTask(context);
              },
            ),
            const SizedBox(height: 16),
          ],
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
          SnackBar(content: Text(AppLocalizations.of(context).taskAddedSnackbar(title))),
        );
      }
    }
  }

  void _addNote(BuildContext context) {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.shareNoteTitle,
              style: Theme.of(ctx)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: l10n.shareNoteHint,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                if (ctrl.text.trim().isEmpty) return;
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.noteSharedSnackbar)),
                  );
                }
              },
              child: Text(l10n.shareButton),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteCode(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.inviteCodeTooltip),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.shareInviteCodeMessage,
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                room.inviteCode,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.closeButton),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy, size: 18),
            label: Text(l10n.copyButton),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: room.inviteCode));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.inviteCodeCopiedSnackbar)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleMenu(BuildContext context, String value, bool isOwner) async {
    switch (value) {
      case 'code':
        Clipboard.setData(ClipboardData(text: room.inviteCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).inviteCodeCopiedSnackbar)),
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

// ─── Room Body (single scrollable) ───────────────────────

class _RoomBody extends StatelessWidget {
  const _RoomBody({required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nudge banner
          _NudgeBanner(roomId: roomId),

          // Members bar
          _MembersBar(roomId: roomId),
          const Divider(height: 1),

          // Room Stats Card
          RoomStatsCard(roomId: roomId),

          // Ad Banner (Premium Space)
          const _AdBanner(),

          // Section: Habits Dashboard
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).rankingAndHabitsSection,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          _HabitsDashboard(roomId: roomId),

          // Section: Notes
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              AppLocalizations.of(context).notesSection,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _NotesFeed(roomId: roomId),
        ],
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
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                        final name = isMe ? (profile.name.isNotEmpty ? profile.name : m.displayName) : m.displayName;
                        
                        ImageProvider? avatar;
                        if (isMe) {
                          if (profile.avatarPath != null && profile.avatarPath!.isNotEmpty) {
                            avatar = FileImage(io.File(profile.avatarPath!));
                          } else if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
                            avatar = NetworkImage(profile.avatarUrl!);
                          }
                        } else if (m.avatarUrl != null) {
                          avatar = NetworkImage(m.avatarUrl!);
                        }

                        return Container(
                          width: 85,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
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
                                  backgroundColor: avatar == null ? theme.colorScheme.primaryContainer : null,
                                  backgroundImage: avatar,
                                  child: avatar == null
                                      ? Text(
                                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onPrimaryContainer,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.track_changes,
                size: 40,
                color: theme.colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 8),
            Text(
              'Henüz alışkanlık eklenmemiş',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '+ butonuyla odaya bir alışkanlık ekle!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: habitColor.withOpacity(isDark ? 0.2 : 0.1),
          width: 1,
        ),
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
                        stream: RoomService.instance.streamHabitProgress(roomId, habit.id),
                        builder: (ctx, snap) {
                          final progress = snap.data ?? [];
                          final completed = progress.where((p) => p.isCompleted).length;
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
                    icon: Icon(Icons.more_vert, size: 18,
                        color: theme.colorScheme.onSurfaceVariant),
                    tooltip: AppLocalizations.of(context).editDeleteTooltip,
                    onSelected: (val) async {
                      if (val == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(AppLocalizations.of(context).deleteHabitTitle),
                            content: Text(AppLocalizations.of(context).deleteHabitConfirm(habit.title)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context).cancelButton),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: Text(AppLocalizations.of(context).deleteButton),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await RoomService.instance.deleteRoomHabit(roomId, habit.id);
                        }
                      } else if (val == 'edit') {
                        final localHabit = HabitRepository.instance.habits
                            .where((h) => h.title == habit.title)
                            .firstOrNull;

                        if (localHabit == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context).editOnlyPersonalHabits)),
                            );
                          }
                          return;
                        }

                        if (habit.isAdvanced) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdvancedHabitScreen(existingHabit: localHabit),
                            ),
                          );
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SimpleHabitScreen(existingHabit: localHabit),
                            ),
                          );
                        }

                        final updatedLocal = HabitRepository.instance.findById(localHabit.id);
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
                          leading: const Icon(Icons.delete_outline, color: Colors.red),
                          title: Text(AppLocalizations.of(context).deleteButton, style: const TextStyle(color: Colors.red)),
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
            stream:
                RoomService.instance.streamHabitProgress(roomId, habit.id),
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
          children: nudges.map((nudge) => _NudgeCard(
            nudge: nudge,
            roomId: roomId,
          )).toList(),
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
                  AppLocalizations.of(context).nudgeNotification(nudge.fromName),
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
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.authorAvatarUrl != null)
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(post.authorAvatarUrl!),
              )
            else
              CircleAvatar(
                radius: 14,
                child: Text(
                  post.authorName.isNotEmpty
                      ? post.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.authorName,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 4),
                  Text(post.content, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            if (post.authorUid == currentUid)
              IconButton(
                icon: Icon(Icons.close,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                onPressed: () async {
                  await RoomService.instance.deletePost(post.roomId, post.id);
                },
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${l10n.minutesSuffixShort}';
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
