import 'package:flutter/material.dart';

import '../data/room_service.dart';
import '../../../l10n/app_localizations.dart';

/// Dialog for creating a new social room.
class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({super.key});

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  final _nameCtrl = TextEditingController();
  String? _selectedEmoji;
  bool _loading = false;

  static const _emojis = [
    '🏠', '🎯', '🔥', '💪', '🌟', '🏆', '📚', '🧘', '🏃', '🎨'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);

    try {
      await RoomService.instance.createRoom(
        name: _nameCtrl.text.trim(),
        emoji: _selectedEmoji ?? '🏠',
      );
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).createRoomSuccessSnackbar)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).errorPrefix}$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(AppLocalizations.of(context).createRoomTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Emoji picker
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _emojis.map((emoji) {
              final isSelected = _selectedEmoji == emoji;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = emoji),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(
                            color: theme.colorScheme.primary, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Name field
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).roomNameLabel,
              hintText: AppLocalizations.of(context).roomNameHint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.group),
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLength: 30,
            onSubmitted: (_) => _create(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancelButton),
        ),
        FilledButton(
          onPressed: _loading ? null : _create,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context).createButton),
        ),
      ],
    );
  }
}
