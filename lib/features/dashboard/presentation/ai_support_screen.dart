import 'package:flutter/material.dart';
import 'package:mira/l10n/app_localizations.dart';
import '../../habit/domain/ai_habit_repository.dart';

import 'package:mira/design_system/theme/app_theme.dart';
import 'package:mira/design_system/theme/theme_variations.dart';

class AiSupportScreen extends StatefulWidget {
  final AiHabitRepository repository;
  final String? startingContext;
  final ThemeVariant variant;

  const AiSupportScreen({
    super.key,
    required this.repository,
    this.startingContext,
    required this.variant,
  });

  @override
  State<AiSupportScreen> createState() => _AiSupportScreenState();
}

class _AiSupportScreenState extends State<AiSupportScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final l10n = AppLocalizations.of(context);
      // Add initial welcome message
      if (widget.startingContext != null) {
        _messages.add({
          'role': 'assistant',
          'content': l10n.aiContextMessage(widget.startingContext!),
        });
      } else {
        _messages.add({'role': 'assistant', 'content': l10n.aiWelcomeMessage});
      }
      _hasInitialized = true;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final languageCode = Localizations.localeOf(context).languageCode;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
      _controller.clear();
    });

    // Scroll to user message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await widget.repository.sendSupportMessage(
        _messages,
        languageCode: languageCode,
      );

      setState(() {
        _messages.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': "Sorry, I encountered an error: $e",
        });
        _isLoading = false;
      });
    }

    // Scroll to assistant message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    // Determine effective theme (Override if World theme -> switch to Purple)
    final effectiveTheme = widget.variant == ThemeVariant.world
        ? (Theme.of(context).brightness == Brightness.dark
              ? AppTheme.dark(ThemeVariant.purple)
              : AppTheme.light(ThemeVariant.purple))
        : Theme.of(context);

    return Theme(
      data: effectiveTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;
          final l10n = AppLocalizations.of(context);

          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aiAssistantTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.aiAssistantOnline,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: colorScheme.surface,
              elevation: 0,
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  height: 1,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isUser
                                  ? const Radius.circular(20)
                                  : const Radius.circular(4),
                              bottomRight: isUser
                                  ? const Radius.circular(4)
                                  : const Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isUser
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Suggestion Chips
                      _buildSuggestionChips(context, l10n, colorScheme),
                      // Input Area
                      // Input Area
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      onSubmitted: (_) => _sendMessage(),
                                      decoration: InputDecoration(
                                        hintText: "Ask anything...",
                                        hintStyle: TextStyle(
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.6),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _sendMessage,
                                      icon: const Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 20,
                                      ),
                                      color: colorScheme.onPrimary,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionChips(
    BuildContext context,
    AppLocalizations? l10n,
    ColorScheme colorScheme,
  ) {
    if (_isLoading || l10n == null) return const SizedBox.shrink();

    final List<Widget> chips = [];

    // 1. Contextual "Show Me How" Chip
    if (_messages.isNotEmpty &&
        _messages.last['role'] == 'assistant' &&
        (_messages.last['content']?.contains('show you') ?? false)) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ActionChip(
            label: Text(l10n.aiShowMeHow),
            onPressed: () {
              _controller.text = l10n.aiShowMeHow;
              _sendMessage();
            },
            backgroundColor: colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          ),
        ),
      );
    }

    // 2. Initial "Quick Starter" Chips (Only if just Welcome message or empty)
    // We check if messages length is <= 1 (Welcome message)
    if (_messages.length <= 1) {
      final starters = [
        {'label': l10n.aiQuickHabit, 'text': l10n.aiQuickHabit},
        {'label': l10n.aiQuickVision, 'text': l10n.aiQuickVision},
        {'label': l10n.aiQuickTimer, 'text': l10n.aiQuickTimer},
        {'label': l10n.aiQuickGamification, 'text': l10n.aiQuickGamification},
        {'label': l10n.aiQuickMood, 'text': l10n.aiQuickMood},
        {'label': l10n.aiQuickFinance, 'text': l10n.aiQuickFinance},
        {'label': l10n.aiQuickMotivation, 'text': l10n.aiQuickMotivation},
        {'label': l10n.aiQuickProfile, 'text': l10n.aiQuickProfile},
      ];

      for (final starter in starters) {
        chips.add(
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: Text(starter['label']!),
              onPressed: () {
                _controller.text = starter['text']!;
                _sendMessage();
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
        );
      }
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: chips,
      ),
    );
  }
}
