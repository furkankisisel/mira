import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/room_service.dart';
import '../../domain/room_member_model.dart';
import '../../domain/room_habit_model.dart';
import '../../domain/room_score_model.dart';

/// Compact mini preview podium displayed directly on room cards in SocialHubScreen.
/// Shows the Top 3 champions (Gold 🥇, Silver 🥈, Bronze 🥉) with avatars, XP totals,
/// and responsive pedestals so users immediately see competition at a glance.
class RoomMiniPodiumPreview extends StatefulWidget {
  final String roomId;

  const RoomMiniPodiumPreview({
    super.key,
    required this.roomId,
  });

  @override
  State<RoomMiniPodiumPreview> createState() => _RoomMiniPodiumPreviewState();
}

class _RoomMiniPodiumPreviewState extends State<RoomMiniPodiumPreview> {
  List<RoomMember> _members = [];
  List<RoomHabit> _habits = [];
  final Map<String, List<MemberProgress>> _progressMap = {};

  StreamSubscription? _membersSub;
  StreamSubscription? _habitsSub;
  final List<StreamSubscription> _progressSubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _membersSub = RoomService.instance.streamMembers(widget.roomId).listen((members) {
      if (mounted) {
        setState(() {
          _members = members;
          _isLoading = false;
        });
      }
    });

    _habitsSub = RoomService.instance.streamRoomHabits(widget.roomId).listen((habits) {
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
        if (mounted) {
          setState(() => _progressMap[h.id] = list);
        }
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

    if (_isLoading) {
      return _buildSkeletonPodium(isDark, isTr);
    }

    final scores = RoomMemberScore.computeScores(
      members: _members,
      habits: _habits,
      habitProgressMap: _progressMap,
    );

    final first = scores.isNotEmpty ? scores[0] : null;
    final second = scores.length > 1 ? scores[1] : null;
    final third = scores.length > 2 ? scores[2] : null;

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    final containerBg = isDark
        ? const Color(0xFF131722).withValues(alpha: 0.65)
        : const Color(0xFFF8FAFC);
    final containerBorder = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);

    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: containerBorder, width: 1.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top Header Strip: Micro Title & Status Chip ──
            Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(
                  isTr ? 'LİDERLİK KÜRSÜSÜ' : 'PODIUM PREVIEW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                  ),
                ),
                const Spacer(),
                if (first != null && first.totalPoints > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('👑', style: TextStyle(fontSize: 9.5)),
                        const SizedBox(width: 3),
                        Text(
                          '${first.totalPoints} XP',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    isTr ? 'Yarış devam ediyor' : 'Race in progress',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // ── 3D Mini Olympic Pedestal Row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 🥈 2nd Place (Silver - Left)
                Expanded(
                  child: _buildMiniColumn(
                    score: second,
                    rank: 2,
                    podiumHeight: 28,
                    avatarSize: 26,
                    medal: '🥈',
                    primaryColor: const Color(0xFF94A3B8),
                    accentColor: const Color(0xFFCBD5E1),
                    isDark: isDark,
                    isCurrent: second?.uid == currentUid,
                    isTr: isTr,
                  ),
                ),
                const SizedBox(width: 6),

                // 🥇 1st Place (Gold & Crown - Center & Tallest)
                Expanded(
                  flex: 11,
                  child: _buildMiniColumn(
                    score: first,
                    rank: 1,
                    podiumHeight: 40,
                    avatarSize: 32,
                    medal: '🥇',
                    primaryColor: const Color(0xFFF59E0B),
                    accentColor: const Color(0xFFFFD700),
                    isDark: isDark,
                    isCurrent: first?.uid == currentUid,
                    isTr: isTr,
                  ),
                ),
                const SizedBox(width: 6),

                // 🥉 3rd Place (Bronze - Right)
                Expanded(
                  child: _buildMiniColumn(
                    score: third,
                    rank: 3,
                    podiumHeight: 22,
                    avatarSize: 26,
                    medal: '🥉',
                    primaryColor: const Color(0xFFD97706),
                    accentColor: const Color(0xFFFDBA74),
                    isDark: isDark,
                    isCurrent: third?.uid == currentUid,
                    isTr: isTr,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniColumn({
    required RoomMemberScore? score,
    required int rank,
    required double podiumHeight,
    required double avatarSize,
    required String medal,
    required Color primaryColor,
    required Color accentColor,
    required bool isDark,
    required bool isCurrent,
    required bool isTr,
  }) {
    // Empty pedestal slot
    if (score == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.add_rounded,
              size: 13,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isTr ? 'Açık' : 'Open',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: podiumHeight,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.02),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05),
                width: 0.9,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
          ),
        ],
      );
    }

    final isLeader = rank == 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown above 1st place
        if (isLeader) ...[
          const Text('👑', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 1),
        ] else ...[
          const SizedBox(height: 13),
        ],

        // Member Avatar with rank-tinted ring
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent ? primaryColor : primaryColor.withValues(alpha: 0.70),
                  width: isCurrent ? 1.8 : 1.4,
                ),
                boxShadow: isLeader
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: score.avatarUrl != null && score.avatarUrl!.isNotEmpty
                    ? Image.network(
                        score.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(score.displayName, primaryColor, isDark),
                      )
                    : _avatarFallback(score.displayName, primaryColor, isDark),
              ),
            ),
            if (isCurrent)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF10B981),
                    border: Border.all(
                      color: isDark ? const Color(0xFF131722) : Colors.white,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 3),

        // Display Name (truncated)
        Text(
          score.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: isCurrent || isLeader ? FontWeight.w800 : FontWeight.w600,
            color: isDark
                ? (isCurrent ? Colors.white : Colors.white70)
                : (isCurrent ? Colors.black : Colors.black87),
          ),
        ),

        const SizedBox(height: 3),

        // 3D Pedestal Block
        Container(
          height: podiumHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: isDark ? 0.90 : 0.85),
                Color.lerp(primaryColor, Colors.black, isDark ? 0.40 : 0.20)!,
              ],
            ),
            border: Border(
              top: BorderSide(color: accentColor, width: 1.4),
              left: BorderSide(color: accentColor.withValues(alpha: 0.40), width: 0.8),
              right: BorderSide(color: accentColor.withValues(alpha: 0.40), width: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.30 : 0.15),
                blurRadius: isLeader ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                medal,
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 1),
              Text(
                '${score.totalPoints}P',
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback(String name, Color primaryColor, bool isDark) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: primaryColor.withValues(alpha: isDark ? 0.20 : 0.15),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildSkeletonPodium(bool isDark, bool isTr) {
    final placeholderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.04);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722).withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(
                isTr ? 'LİDERLİK KÜRSÜSÜ' : 'PODIUM PREVIEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white30 : Colors.black38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 11,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
