import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class DailyTaskDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final bool isEditing;

  const DailyTaskDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.isEditing = false,
  });

  @override
  State<DailyTaskDialog> createState() => _DailyTaskDialogState();
}

class _DailyTaskDialogState extends State<DailyTaskDialog> {
  late final TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final task = {
        'title': _titleController.text.trim(),
        'description': '',
        'date': DateTime.now(),
        'completed': false,
      };

      Navigator.of(context).pop(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        widget.isEditing
            ? (l10n.localeName.startsWith('tr')
                ? 'Görevi Düzenle'
                : 'Edit Task')
            : l10n.createDailyTask,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.taskTitle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.taskTitleRequired;
                }
                return null;
              },
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _createTask,
          child: Text(widget.isEditing
              ? (l10n.localeName.startsWith('tr') ? 'Kaydet' : 'Save')
              : l10n.create),
        ),
      ],
    );
  }
}
