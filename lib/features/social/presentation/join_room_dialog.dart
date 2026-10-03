import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/room_service.dart';
import '../../../l10n/app_localizations.dart';

/// Modern, tactile dialog for joining a room via a 6-character invite code.
class JoinRoomDialog extends StatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    HapticFeedback.lightImpact();
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text =
        data?.text?.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '') ??
            '';
    if (text.isNotEmpty) {
      final code = text.length > 6 ? text.substring(0, 6) : text;
      _codeCtrl.text = code;
      setState(() => _error = null);
    }
  }

  Future<void> _join() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(
          () => _error = AppLocalizations.of(context).invalidCodeLengthError);
      return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final roomName = await RoomService.instance.joinRoom(code);
      if (roomName == null) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = AppLocalizations.of(context).roomNotFoundError;
          });
        }
        return;
      }
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Text(
                AppLocalizations.of(context).joinRoomSuccessSnackbar(roomName)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '${AppLocalizations.of(context).errorPrefix}$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final accent = const Color(0xFFF59E0B); // Warm amber for invite/key

    final dialogBg = cs.surfaceContainerHigh;
    final inputBg = cs.surfaceContainerLow;
    final inputBorder =
        cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7);

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7),
          width: 1.2,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: isDark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accent.withValues(alpha: isDark ? 0.40 : 0.28),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.vpn_key_rounded,
                        color: Color(0xFFF59E0B), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.joinRoomTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.joinRoomSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                l10n.joinRoomCodeMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 14),

              // Code Input with paste helper
              Container(
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _error != null
                        ? Colors.red.withValues(alpha: 0.6)
                        : inputBorder,
                    width: 1.2,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeCtrl,
                        decoration: InputDecoration(
                          hintText: '6 HANELİ KOD',
                          hintStyle: TextStyle(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                            fontSize: 15,
                            letterSpacing: 3,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9]')),
                          UpperCaseTextFormatter(),
                        ],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 6,
                          fontFamily: 'monospace',
                          color:
                              Theme.of(context).colorScheme.onSurface,
                        ),
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        onSubmitted: (_) => _join(),
                      ),
                    ),
                    // Paste action button
                    GestureDetector(
                      onTap: _pasteFromClipboard,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.20 : 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                accent.withValues(alpha: isDark ? 0.35 : 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.content_paste_rounded,
                                size: 14, color: accent),
                            const SizedBox(width: 4),
                            Text(
                              'Yapıştır',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _loading ? null : () => Navigator.pop(context),
                      child: Text(
                        l10n.cancelButton,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _loading ? null : _join,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              accent,
                              const Color(0xFFD97706),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white
                                .withValues(alpha: isDark ? 0.25 : 0.50),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(
                                  alpha: isDark ? 0.35 : 0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.login_rounded,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.joinButton,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Forces text input to uppercase.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
