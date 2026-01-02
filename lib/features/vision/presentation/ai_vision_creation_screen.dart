import 'package:flutter/material.dart';
import '../../habit/domain/ai_habit_repository.dart';
import '../../vision/domain/ai_vision_dto.dart';
import 'package:mira/l10n/app_localizations.dart';

class AiVisionCreationScreen extends StatefulWidget {
  final AiHabitRepository repository;

  const AiVisionCreationScreen({super.key, required this.repository});

  @override
  State<AiVisionCreationScreen> createState() => _AiVisionCreationScreenState();
}

class _AiVisionCreationScreenState extends State<AiVisionCreationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': AppLocalizations.of(context).tellMeYourDream,
          // Ideally use l10n here, but hardcoding for MVP speed as user speaks English/Turkish automatically handled by AI
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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Send message to AI in conversational mode
      // The AI will reply with text (questions) or a Vision plan (when ready)
      final response = await widget.repository.sendVisionMessage(_messages);

      if (!mounted) return;

      setState(() {
        if (response.vision != null) {
          _messages.add({'role': 'assistant', 'content': response.message});
          _isLoading = false;
          // If vision is present, we are done
          _finishWithVision(response.vision!);
        } else {
          _messages.add({'role': 'assistant', 'content': response.message});
          _isLoading = false;
        }
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Error: $e. Please try again.',
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _finishWithVision(AiVisionDto vision) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context, vision);
    });
  }

  @override
  Widget build(BuildContext context) {
    // using existing l10n or hardcoded for new features
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Vision with AI")),
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
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "E.g. I want to become a Digital Nomad",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
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
