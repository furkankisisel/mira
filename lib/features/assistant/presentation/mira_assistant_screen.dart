import 'package:flutter/material.dart';

import '../../../design_system/theme/theme_variations.dart';

import '../data/mira_assistant_service.dart';
import '../../habit/presentation/simple_habit_screen.dart';
import '../../timer/timer_screen.dart';
import '../../mood/mood_screen.dart';
import '../../games/presentation/games_screen.dart';
import '../../habit/domain/habit_repository.dart';
import '../../habit/domain/habit_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../reports/domain/report_model.dart';
import 'mira_premium_report_screen.dart';

/// Message bubble for chat display
class _ChatMessage {
  final String text;
  final bool isUser;
  final List<QuickAction>? actions;
  final List<String>? quickReplies;
  final WeeklyReport? report;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.actions,
    this.quickReplies,
    this.report,
  });
}

class MiraAssistantScreen extends StatefulWidget {
  const MiraAssistantScreen({
    super.key,
    this.variant,
    this.onNavigationCommand,
  });

  final ThemeVariant? variant;
  final Function(String command)? onNavigationCommand;

  @override
  State<MiraAssistantScreen> createState() => _MiraAssistantScreenState();
}

class _MiraAssistantScreenState extends State<MiraAssistantScreen> {
  final _service = MiraAssistantService();
  final _messages = <_ChatMessage>[];
  final _history = <Map<String, String>>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialMessage() async {
    setState(() => _isLoading = true);

    try {
      final l10n = AppLocalizations.of(context);
      final insight = await _service.getUserInsight();
      String greeting;

      final hour = DateTime.now().hour;
      if (hour < 12) {
        greeting = '${l10n.greetingMorning}! ☀️';
      } else if (hour < 18) {
        greeting = '${l10n.greetingAfternoon}! 🌤️';
      } else {
        greeting = '${l10n.greetingEvening}! 🌙';
      }

      String statusMessage;
      if (insight.totalHabits == 0) {
        statusMessage = l10n.emptyHabitTitle; // Or a better key if available
      } else if (insight.incompleteToday == 0) {
        statusMessage = l10n
            .habitAddSuccess(0)
            .replaceAll('0', 'All'); // Workaround or better string
      } else {
        statusMessage =
            '${insight.completedToday}/${insight.totalHabits} ${l10n.habits}. ${l10n.howAreYouFeeling}';
      }

      _messages.add(
        _ChatMessage(
          text: '$greeting $statusMessage',
          isUser: false,
          quickReplies: _service.getDefaultQuickReplies(),
        ),
      );
    } catch (e) {
      _messages.add(
        _ChatMessage(
          text: '${AppLocalizations.of(context).greetingMorning}! 😊',
          isUser: false,
          quickReplies: _service.getDefaultQuickReplies(),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Check if user wants to play games
    if (text.toLowerCase().contains('oyun')) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const GamesScreen()));
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    _history.add({'role': 'user', 'content': text});

    try {
      final languageCode = Localizations.localeOf(context).languageCode;
      final response = await _service.sendMessage(
        text,
        _history,
        languageCode: languageCode,
      );

      _history.add({'role': 'assistant', 'content': response.message});

      setState(() {
        _messages.add(
          _ChatMessage(
            text: response.message,
            isUser: false,
            actions: response.actions,
            quickReplies: response.quickReplies,
            report: response.report,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: AppLocalizations.of(context).failedToLoad('Try again'),
            isUser: false,
            quickReplies: _service.getDefaultQuickReplies(),
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
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

  Future<void> _handleQuickAction(QuickAction action,
      [WeeklyReport? report]) async {
    switch (action.routeId) {
      case 'open_report':
        if (report != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MiraPremiumReportScreen(
                report: report,
              ),
            ),
          );
        }
        break;
      case 'create_habit':
        final result = await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SimpleHabitScreen()));

        if (result != null && result is Habit && mounted) {
          await HabitRepository.instance.addHabit(result);
          setState(() {
            _messages.add(
              _ChatMessage(
                text: AppLocalizations.of(
                  context,
                ).habitCreatedMessage(result.title),
                isUser: false,
              ),
            );
          });
          _scrollToBottom();
        }
        break;
      case 'habits':
        widget.onNavigationCommand?.call('habits');
        break;
      case 'timer':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TimerScreen(variant: widget.variant),
          ),
        );
        break;
      case 'mood':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MoodScreen(
                variant: ThemeVariant.cotton), // Assuming a default variant
          ),
        );
        break;
      case 'vision':
        widget.onNavigationCommand?.call('vision');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWorld = false;
    final accent = colorScheme.primary;

    return Theme(
      data: theme.copyWith(colorScheme: colorScheme.copyWith(primary: accent)),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return _buildTypingIndicator(accent);
                }
                return _buildMessageBubble(_messages[index], accent);
              },
            ),
          ),
          _buildInputArea(accent),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message, Color accent) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  message.isUser ? accent : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: message.isUser ? const Radius.circular(4) : null,
                bottomLeft: !message.isUser ? const Radius.circular(4) : null,
              ),
            ),
            child: Text(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: message.isUser ? Colors.white : colorScheme.onSurface,
              ),
            ),
          ),

          // Quick Actions
          if (message.actions != null && message.actions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: message.actions!.map((action) {
                return FilledButton.icon(
                  onPressed: () => _handleQuickAction(action, message.report),
                  icon: Icon(action.icon, size: 18),
                  label: Text(action.label),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Quick Replies
          if (message.quickReplies != null &&
              message.quickReplies!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: message.quickReplies!.map((reply) {
                return ActionChip(
                  label: Text(
                    reply,
                    style: TextStyle(fontSize: 12, color: accent),
                  ),
                  onPressed: () => _sendMessage(reply),
                  backgroundColor: accent.withOpacity(0.1),
                  side: BorderSide(color: accent.withOpacity(0.3)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + i * 200),
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.3 + value * 0.5),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(Color accent) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).viewPadding.bottom,
      ),
      // Removed background color and border to blend with screen
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).writeMessage,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () => _sendMessage(_controller.text),
            icon: const Icon(Icons.send_rounded),
            style: IconButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
