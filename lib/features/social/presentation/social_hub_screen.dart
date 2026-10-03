import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/room_service.dart';
import '../domain/room_model.dart';
import 'room_detail_screen.dart';
import 'create_room_dialog.dart';
import 'join_room_dialog.dart';
import 'widgets/room_mini_podium.dart';
import '../../../l10n/app_localizations.dart';

/// Main social hub: lists rooms the user belongs to with
/// an elite, tactile, and Scandinavian minimalist design.
class SocialHubScreen extends StatelessWidget {
  const SocialHubScreen({super.key, this.showAppBar = true});
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final bgColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: showAppBar
          ? AppBar(
              title: Text(
                l10n.socialRoomsTitle,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: -0.3),
              ),
              actions: [
                IconButton(
                  tooltip: 'Seçenekler',
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => showFabOptions(context),
                ),
              ],
            )
          : null,
      body: isGuest ? const _EliteGuestPrompt() : const _EliteRoomList(),
    );
  }

  /// Modern bottom action sheet for creating or joining a room
  static void showFabOptions(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: cs.surfaceContainerHigh,
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
                l10n.socialRoomsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Birlikte odaklanın, alışkanlıkları paylaşın ve gelişin',
                style: TextStyle(
                  fontSize: 12.5,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              _SheetActionCard(
                icon: Icons.add_home_work_rounded,
                iconColor: cs.primary,
                title: l10n.createRoomTitle,
                subtitle: l10n.createRoomSubtitle,
                onTap: () {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder: (_) => const CreateRoomDialog(),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SheetActionCard(
                icon: Icons.vpn_key_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: l10n.joinRoomTitle,
                subtitle: l10n.joinRoomSubtitle,
                onTap: () {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder: (_) => const JoinRoomDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetActionCard extends StatelessWidget {
  const _SheetActionCard({
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7),
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withValues(alpha: isDark ? 0.40 : 0.25),
                  width: 1.1,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _EliteGuestPrompt extends StatelessWidget {
  const _EliteGuestPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withValues(alpha: 0.20),
                    cs.primary.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.30),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child:
                  Icon(Icons.people_alt_rounded, size: 44, color: cs.primary),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.socialFeaturesTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.socialFeaturesGuestMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.45,
                fontSize: 13.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EliteRoomList extends StatelessWidget {
  const _EliteRoomList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Room>>(
      stream: RoomService.instance.streamMyRooms(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final rooms = snap.data ?? [];
        if (rooms.isEmpty) {
          return const _EliteEmptyState();
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
          children: [
            // Top Quick Action Row
            _buildTopQuickActions(context, cs, isDark, l10n),

            const SizedBox(height: 18),

            // Section Label
            Row(
              children: [
                Text(
                  'ODALARIM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: isDark ? 0.20 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${rooms.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Room Cards
            for (final room in rooms) ...[
              _EliteRoomCard(room: room),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTopQuickActions(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        // Create Room Button
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_rounded,
            label: l10n.createRoomTitle,
            isPrimary: true,
            onTap: () {
              HapticFeedback.lightImpact();
              showDialog(
                context: context,
                builder: (_) => const CreateRoomDialog(),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        // Join Room Button
        Expanded(
          child: _QuickActionButton(
            icon: Icons.vpn_key_outlined,
            label: l10n.joinRoomTitle,
            isPrimary: false,
            onTap: () {
              HapticFeedback.lightImpact();
              showDialog(
                context: context,
                builder: (_) => const JoinRoomDialog(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primaryBg = LinearGradient(
      colors: [
        cs.primary,
        Color.lerp(cs.primary, Colors.black, isDark ? 0.20 : 0.10)!,
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary ? primaryBg : null,
          color: isPrimary ? null : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? Colors.white.withValues(alpha: isDark ? 0.25 : 0.50)
                : cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? cs.primary.withValues(alpha: isDark ? 0.30 : 0.22)
                  : Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF334155)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EliteEmptyState extends StatelessWidget {
  const _EliteEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Layered claymorphic icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cs.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                    cs.primary.withValues(alpha: 0.02),
                  ],
                ),
                border: Border.all(
                  color: cs.primary.withValues(alpha: isDark ? 0.30 : 0.20),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.hub_rounded,
                size: 48,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.noRoomsJoinedTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noRoomsJoinedMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 13.5,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            // Actions
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.add_rounded,
                    label: l10n.createRoomTitle,
                    isPrimary: true,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      showDialog(
                        context: context,
                        builder: (_) => const CreateRoomDialog(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.vpn_key_outlined,
                    label: l10n.joinRoomTitle,
                    isPrimary: false,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      showDialog(
                        context: context,
                        builder: (_) => const JoinRoomDialog(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EliteRoomCard extends StatelessWidget {
  const _EliteRoomCard({required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = room.ownerId == currentUid;

    final cardBg = cs.surfaceContainerHigh;
    final cardBorder = cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RoomDetailScreen(room: room),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            if (!isDark)
              const BoxShadow(
                color: Colors.white,
                blurRadius: 1,
                offset: Offset(0, -1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Emoji Avatar with soft ambient badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: isDark ? 0.16 : 0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cs.primary.withValues(alpha: isDark ? 0.30 : 0.20),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    room.emoji ?? '🏠',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),

                const SizedBox(width: 14),

                // Room info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Member count pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 12,
                                  color: cs.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)
                                      .memberCountText(room.memberCount),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Owner badge
                          if (isOwner)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B)
                                    .withValues(alpha: isDark ? 0.20 : 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFF59E0B)
                                      .withValues(alpha: isDark ? 0.35 : 0.25),
                                  width: 0.9,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '👑 Kurucu',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Chevron action button
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.surfaceContainerHighest,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Mini Podium Preview: Shows Top 3 members at a glance
            RoomMiniPodiumPreview(roomId: room.id),
          ],
        ),
      ),
    );
  }
}
