import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../domain/ai_habit_dto.dart';
import '../domain/ai_habit_repository.dart';
import '../domain/habit_repository.dart';
import '../domain/habit_repository.dart';
import '../domain/daily_task_repository.dart'; // Added

class AiHabitPreviewScreen extends StatefulWidget {
  final List<AiHabitDto> habits;
  final AiHabitRepository repository;

  const AiHabitPreviewScreen({
    super.key,
    required this.habits,
    required this.repository,
  });

  @override
  State<AiHabitPreviewScreen> createState() => _AiHabitPreviewScreenState();
}

class _AiHabitPreviewScreenState extends State<AiHabitPreviewScreen> {
  late List<AiHabitDto> _habits;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _habits = List.from(widget.habits);
  }

  void _removeHabit(int index) {
    setState(() {
      _habits.removeAt(index);
    });
  }

  Future<void> _confirmHabits() async {
    if (_habits.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final habitRepo = HabitRepository.instance;
      final taskRepo = DailyTaskRepository.instance; // Added
      final l10n = AppLocalizations.of(context)!;

      int addedCount = 0;
      for (var dto in _habits) {
        if (dto.isTask) {
          final task = dto.toDailyTask();
          await taskRepo.addTask(task);
        } else {
          final habit = dto.toHabit();
          await habitRepo.addHabit(habit);
        }
        addedCount++;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiHabitAddedMessage(addedCount))),
      );

      // Pop back to habit screen (pop preview, pop creation)
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving habits: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiPreviewTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habitDto = _habits[index];
                // Convert to temporary habit for display
                final tempHabit = habitDto.toHabit();

                return Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: tempHabit.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              tempHabit.emoji != null &&
                                  tempHabit.emoji!.isNotEmpty
                              ? Center(
                                  child: Text(
                                    tempHabit.emoji!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                )
                              : Icon(tempHabit.icon, color: tempHabit.color),
                        ),
                        title: Row(
                          children: [
                            if (habitDto.isTask)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'TASK',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        theme.colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                tempHabit.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tempHabit.description),
                            if (habitDto.durationDays != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Duration: ${habitDto.durationDays} days',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeHabit(index),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _confirmHabits,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(l10n.confirmHabits),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
