import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mira/design_system/components/pressable_scale.dart';
import '../../domain/room_score_model.dart';
import 'fun_nudge_sheet.dart';

/// Full interactive league table ranking all members in the room with
/// point totals, streak badges, leader gap tracking, and quick playful nudges.
class RoomOverallLeaderboard extends StatelessWidget {
  final List<RoomMemberScore> scores;
  final String roomId;
  final bool isDark;
  final bool isTr;

  const RoomOverallLeaderboard({
    super.key,
    required this.scores,
    required this.roomId,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isTr ? 'Henüz skor kaydı yok' : 'No scores recorded yet',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isTr
                    ? 'Alışkanlıkları tamamlayarak odadaki ilk puanları toplayın!'
                    : 'Complete room habits to start earning the first points!',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.white38 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final myScore = scores.where((s) => s.uid == currentUid).firstOrNull;
    final myIndex = myScore != null ? scores.indexOf(myScore) : -1;
    final aheadMember = myIndex > 0 ? scores[myIndex - 1] : null;

    final titleColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Motivational Gap Callout Banner ──
        if (myScore != null)
          _buildPersonalGapBanner(
            context,
            myScore,
            aheadMember,
            isDark,
            isTr,
          ),

        // ── League Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Row(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 6),
              Text(
                isTr ? 'GENEL ODA LİGİ' : 'ROOM LEAGUE RANKING',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.9,
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                ),
              ),
              const Spacer(),
              Text(
                '${scores.length} ${isTr ? 'Üye' : 'Members'}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),

        // ── Members List ──
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: scores.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final score = scores[index];
            final isMe = score.uid == currentUid;

            return _LeagueMemberTile(
              score: score,
              roomId: roomId,
              isMe: isMe,
              isDark: isDark,
              isTr: isTr,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPersonalGapBanner(
    BuildContext context,
    RoomMemberScore myScore,
    RoomMemberScore? aheadMember,
    bool isDark,
    bool isTr,
  ) {
    if (myScore.isLeader) {
      // You are #1 Leader!
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.22 : 0.14),
              const Color(0xFFEA580C).withValues(alpha: isDark ? 0.12 : 0.08),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            const Text('👑', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTr ? 'Tebrikler, Odanın Zirvesindesin!' : 'You are Leading the Room!',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isTr
                        ? 'Liderliğini ve serini korumak için bugün görevlerini aksatma!'
                        : 'Keep your streak and habits strong to defend your crown!',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // You are trailing someone ahead
    final gap = myScore.pointsBehindPrevious;
    final aheadName = aheadMember?.displayName ?? (isTr ? 'Lider' : 'Leader');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0284C7).withValues(alpha: isDark ? 0.22 : 0.12),
            const Color(0xFF6366F1).withValues(alpha: isDark ? 0.12 : 0.08),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0284C7).withValues(alpha: 0.20),
            ),
            child: const Center(
              child: Text('🚀', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: isTr
                            ? '$aheadName ile aranda '
                            : 'Only ',
                      ),
                      TextSpan(
                        text: '$gap XP',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: isTr
                            ? ' fark kaldı!'
                            : ' behind $aheadName!',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isTr
                      ? 'Bugün 1 alışkanlık tamamlayarak bir üst sıraya tırmanabilirsin! 🔥'
                      : 'Complete 1 more habit today to climb to the next rank! 🔥',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
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

class _LeagueMemberTile extends StatelessWidget {
  final RoomMemberScore score;
  final String roomId;
  final bool isMe;
  final bool isDark;
  final bool isTr;
  final Color titleColor;
  final Color subtitleColor;

  const _LeagueMemberTile({
    required this.score,
    required this.roomId,
    required this.isMe,
    required this.isDark,
    required this.isTr,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color rankColor;
    if (score.rank == 1) {
      rankColor = const Color(0xFFF59E0B);
    } else if (score.rank == 2) {
      rankColor = const Color(0xFF94A3B8);
    } else if (score.rank == 3) {
      rankColor = const Color(0xFFD97706);
    } else {
      rankColor = isDark ? Colors.white38 : Colors.black38;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe
            ? colorScheme.primary.withValues(alpha: isDark ? 0.16 : 0.10)
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isMe
              ? const Color(0xFF0284C7).withValues(alpha: 0.45)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05)),
          width: isMe ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Rank Badge ──
          Container(
            width: 32,
            alignment: Alignment.center,
            child: score.rank <= 3
                ? Text(score.rankMedal, style: const TextStyle(fontSize: 20))
                : Text(
                    '#${score.rank}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: rankColor,
                    ),
                  ),
          ),
          const SizedBox(width: 8),

          // ── Avatar with border ──
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: rankColor.withValues(alpha: score.rank <= 3 ? 0.6 : 0.2),
                width: 1.8,
              ),
            ),
            child: ClipOval(
              child: score.avatarUrl != null
                  ? Image.network(
                      score.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _avatarFallback(),
                    )
                  : _avatarFallback(),
            ),
          ),
          const SizedBox(width: 12),

          // ── Member Name & Stats Subtitle ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        score.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isMe
                              ? (isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7))
                              : titleColor,
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isTr ? 'SEN' : 'YOU',
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Completed habits chip
                    Text(
                      '${score.completedHabitsCount}/${score.totalHabitsCount} ${isTr ? 'Görev' : 'Tasks'}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                    if (score.maxStreak > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 11,
                              color: Color(0xFFFF5722),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${score.maxStreak}g',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF5722),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ── Points & Difference Gap ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${score.totalPoints} XP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: score.rank == 1
                        ? const Color(0xFFF59E0B)
                        : (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7)),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              if (score.rank == 1)
                Text(
                  isTr ? '👑 Lider' : '👑 Leader',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF59E0B),
                  ),
                )
              else
                Text(
                  '-${score.pointsBehindLeader} XP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),

          // ── Playful Nudge Button (Only for others) ──
          if (!isMe)
            PressableScale(
              onTap: () {
                HapticFeedback.lightImpact();
                showFunNudgeSheet(
                  context: context,
                  roomId: roomId,
                  targetUid: score.uid,
                  targetName: score.displayName,
                  targetAvatarUrl: score.avatarUrl,
                );
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.12),
                  border: Border.all(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.30),
                  ),
                ),
                child: const Center(
                  child: Text('👊', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Center(
      child: Text(
        score.displayName.isNotEmpty ? score.displayName[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}
