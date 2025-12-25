import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'ai_habit_preview_screen.dart';
import '../domain/ai_habit_repository.dart';
import '../domain/ai_habit_service.dart'; // for AiChatResponse

class AiHabitCreationScreen extends StatefulWidget {
  final AiHabitRepository repository;

  const AiHabitCreationScreen({super.key, required this.repository});

  @override
  State<AiHabitCreationScreen> createState() => _AiHabitCreationScreenState();
}

class _AiHabitCreationScreenState extends State<AiHabitCreationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages =
      []; // role: user/assistant, content: text
  List<String> _currentOptions = []; // Suggestion chips
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add initial welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': l10n
              .aiInputHint, // Use the hint as a welcome or generic "How can I help?"
          // Better: "Hello! I'm Mira. Tell me about your goals."
          // l10n.aiInputHint is "How can I help you?". Close enough.
        });
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? manualText]) async {
    final text = manualText ?? _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
      _currentOptions = []; // Clear options after selection
    });
    _scrollToBottom();

    try {
      final history = List<Map<String, String>>.from(_messages);

      final response = await widget.repository.sendMessage(history);

      if (!mounted) return;

      setState(() {
        _messages.add({'role': 'assistant', 'content': response.message});
        _isLoading = false;
        if (response.options != null) {
          _currentOptions = response.options!;
        }
      });
      _scrollToBottom();

      if (response.habits != null && response.habits!.isNotEmpty) {
        // Habits generated! Navigate to preview.
        // We ensure the user sees the confirmation message first?
        // Maybe delay slightly?
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiHabitPreviewScreen(
              habits: response.habits!,
              repository: widget.repository,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Error: $e'});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createWithAi)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? Radius.zero : null,
                        bottomLeft: !isUser ? Radius.zero : null,
                      ),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: TextStyle(
                        color: isUser
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_currentOptions.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _currentOptions.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(opt),
                      onPressed: _isLoading ? null : () => _sendMessage(opt),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: l10n.aiInputHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading ? null : () => _sendMessage(),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
