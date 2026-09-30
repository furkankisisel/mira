import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mira/design_system/components/pressable_scale.dart';
import '../../data/room_service.dart';

/// Interactive modal sheet providing quick, playful, and competitive
/// nudges between room members.
Future<void> showFunNudgeSheet({
  required BuildContext context,
  required String roomId,
  required String targetUid,
  required String targetName,
  String? targetAvatarUrl,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FunNudgeContent(
      roomId: roomId,
      targetUid: targetUid,
      targetName: targetName,
      targetAvatarUrl: targetAvatarUrl,
    ),
  );
}

class _FunNudgeContent extends StatefulWidget {
  final String roomId;
  final String targetUid;
  final String targetName;
  final String? targetAvatarUrl;

  const _FunNudgeContent({
    required this.roomId,
    required this.targetUid,
    required this.targetName,
    this.targetAvatarUrl,
  });

  @override
  State<_FunNudgeContent> createState() => _FunNudgeContentState();
}

class _FunNudgeContentState extends State<_FunNudgeContent> {
  final _customCtrl = TextEditingController();
  bool _isSending = false;

  final List<_NudgePreset> _presets = const [
    _NudgePreset(
      emoji: '👑',
      tag: 'REKABET',
      color: Color(0xFFF59E0B),
      message: 'Tahtını sallıyorum, dikkat et! 👑',
    ),
    _NudgePreset(
      emoji: '⚡',
      tag: 'YARIŞ',
      color: Color(0xFF38BDF8),
      message: 'Hadi biraz hızlan, yetişiyorum! ⚡',
    ),
    _NudgePreset(
      emoji: '🔥',
      tag: 'MOTİVASYON',
      color: Color(0xFFFF5722),
      message: 'Serini yakma, tempoyu koru! 🔥',
    ),
    _NudgePreset(
      emoji: '☕',
      tag: 'MOLA BİTTİ',
      color: Color(0xFF8B5CF6),
      message: 'Kahve molası bitti, göreve dön! ☕',
    ),
    _NudgePreset(
      emoji: '🚀',
      tag: 'BİRLİKTE',
      color: Color(0xFF10B981),
      message: 'Bugünkü hedefini tamamla, beraber zirveye! 🚀',
    ),
  ];

  Future<void> _send(String message) async {
    if (_isSending || message.trim().isEmpty) return;
    setState(() => _isSending = true);
    HapticFeedback.mediumImpact();

    try {
      await RoomService.instance.sendNudge(
        roomId: widget.roomId,
        toUid: widget.targetUid,
        toName: widget.targetName,
        message: message.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('👊 ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    '${widget.targetName} dürtüldü: "$message"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B26) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
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
          const SizedBox(height: 16),

          // Header with Avatar & Target Name
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: widget.targetAvatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            widget.targetAvatarUrl!,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Text(
                              '👊',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        )
                      : const Text('👊', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.targetName}\'i Dürt',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Dostane bir rekabet mesajı veya motivasyon gönder!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Preset Fun Messages
          ..._presets.map((preset) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: PressableScale(
                onTap: () => _send(preset.message),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: preset.color.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: preset.color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            preset.emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              preset.tag,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                                color: preset.color,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              preset.message,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.send_rounded,
                        size: 16,
                        color: preset.color,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          // Custom Nudge Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Özel bir mesaj yaz...',
                      hintStyle: TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    maxLines: 1,
                    onSubmitted: (val) => _send(val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  color: theme.colorScheme.primary,
                  onPressed: () => _send(_customCtrl.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NudgePreset {
  final String emoji;
  final String tag;
  final Color color;
  final String message;

  const _NudgePreset({
    required this.emoji,
    required this.tag,
    required this.color,
    required this.message,
  });
}
