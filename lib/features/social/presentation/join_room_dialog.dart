import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/room_service.dart';
import '../../../l10n/app_localizations.dart';

/// Dialog for joining a room via a 6-character invite code.
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

  Future<void> _join() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(() => _error = AppLocalizations.of(context).invalidCodeLengthError);
      return;
    }
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
          SnackBar(content: Text(AppLocalizations.of(context).joinRoomSuccessSnackbar(roomName))),
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

    return AlertDialog(
      title: Text(AppLocalizations.of(context).joinRoomTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).joinRoomCodeMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _codeCtrl,
            decoration: InputDecoration(
              hintText: 'ABCD12',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.vpn_key_outlined),
              errorText: _error,
              counterText: '',
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
            ],
            style: theme.textTheme.titleLarge?.copyWith(
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            onSubmitted: (_) => _join(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancelButton),
        ),
        FilledButton(
          onPressed: _loading ? null : _join,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context).joinButton),
        ),
      ],
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
