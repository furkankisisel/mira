import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mira/design_system/components/pressable_scale.dart';
import '../../domain/room_score_model.dart';
import 'fun_nudge_sheet.dart';

/// Elite 3D-styled Olympic podium displaying the Top 3 champions of the room
/// with crowned pedestals, avatars, point totals, and leader gap tracking.
class RoomPodiumWidget extends StatelessWidget {
  final List<RoomMemberScore> scores;
  final String roomId;
  final bool isDark;
  final bool isTr;

  const RoomPodiumWidget({
    super.key,
    required this.scores,
    required this.roomId,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    final first = scores.isNotEmpty ? scores[0] : null;
    final second = scores.length > 1 ? scores[1] : null;
    final third = scores.length > 2 ? scores[2] : null;

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHigh,
            colorScheme.surface,
          ],
        ),
        border: Border.all(
          color:
              colorScheme.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Podium Title & Crown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👑', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                isTr ? 'LİDERLİK KÜRSÜSÜ' : 'CHAMPIONS PODIUM',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: isDark
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3D Podium Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd Place (Silver - Left)
              Expanded(
                child: _buildPodiumColumn(
                  context: context,
                  score: second,
                  rank: 2,
                  podiumHeight: 90,
                  primaryColor: const Color(0xFF94A3B8),
                  accentColor: const Color(0xFFCBD5E1),
                  badgeLabel: '🥈 2.',
                  isCurrent: second?.uid == currentUid,
                ),
              ),
              const SizedBox(width: 10),

              // 1st Place (Gold & Crown - Center & Elevated)
              Expanded(
                child: _buildPodiumColumn(
                  context: context,
                  score: first,
                  rank: 1,
                  podiumHeight: 128,
                  primaryColor: const Color(0xFFF59E0B),
                  accentColor: const Color(0xFFFFD700),
                  badgeLabel: '🥇 1.',
                  isCurrent: first?.uid == currentUid,
                ),
              ),
              const SizedBox(width: 10),

              // 3rd Place (Bronze - Right)
              Expanded(
                child: _buildPodiumColumn(
                  context: context,
                  score: third,
                  rank: 3,
                  podiumHeight: 74,
                  primaryColor: const Color(0xFFD97706),
                  accentColor: const Color(0xFFFDBA74),
                  badgeLabel: '🥉 3.',
                  isCurrent: third?.uid == currentUid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required BuildContext context,
    required RoomMemberScore? score,
    required int rank,
    required double podiumHeight,
    required Color primaryColor,
    required Color accentColor,
    required String badgeLabel,
    required bool isCurrent,
  }) {
    if (score == null) {
      // Empty pedestal for small rooms
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: podiumHeight,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.black.withValues(alpha: 0.02),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final avatarSize = rank == 1 ? 58.0 : 48.0;

    return PressableScale(
      onTap: () {
        HapticFeedback.lightImpact();
        _openMemberSheet(context, score);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crown on top of #1
          if (rank == 1) ...[
            const Text('👑', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
          ] else ...[
            const SizedBox(height: 24),
          ],

          // Avatar with Halo & Rank Medal
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: avatarSize + 6,
                height: avatarSize + 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      accentColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(
                        alpha: isDark ? 0.40 : 0.25,
                      ),
                      blurRadius: rank == 1 ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: ClipOval(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: score.avatarUrl != null
                          ? Image.network(
                              score.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _avatarFallback(score),
                            )
                          : _avatarFallback(score),
                    ),
                  ),
                ),
              ),

              // Rank Tag Badge
              Positioned(
                bottom: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badgeLabel,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Member Name
          Text(
            score.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: rank == 1 ? 13.5 : 12,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: isCurrent
                  ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),

          // Total Points Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: isDark ? 0.18 : 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${score.totalPoints} XP',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 3D Pedestal Block
          Container(
            height: podiumHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor.withValues(alpha: isDark ? 0.35 : 0.22),
                  primaryColor.withValues(alpha: isDark ? 0.12 : 0.08),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gap difference label
                if (rank == 1)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isTr ? 'LİDER' : 'LEADER',
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    '-${score.pointsBehindLeader} XP',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),

                // Streak flame counter
                if (score.maxStreak > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 13,
                        color: Color(0xFFFF5722),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${score.maxStreak}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(RoomMemberScore score) {
    return Center(
      child: Text(
        score.displayName.isNotEmpty ? score.displayName[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  void _openMemberSheet(BuildContext context, RoomMemberScore score) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isMe = score.uid == currentUid;

    if (isMe) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isTr
                ? 'Şu an ${score.rank}. sıradasın! (${score.totalPoints} XP)'
                : 'You are currently #${score.rank}! (${score.totalPoints} XP)',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Open fun nudge sheet
    showFunNudgeSheet(
      context: context,
      roomId: roomId,
      targetUid: score.uid,
      targetName: score.displayName,
      targetAvatarUrl: score.avatarUrl,
    );
  }
}
