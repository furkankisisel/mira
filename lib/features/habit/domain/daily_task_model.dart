class DailyTask {
  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.dateKey, // YYYY-MM-DD
    this.completionDateKey, // YYYY-MM-DD when completed
    this.isDone = false,
    this.listId,
  });

  final String id;
  String title;
  String description;
  String dateKey;
  String? completionDateKey;
  bool isDone;
  String? listId;

  // Focus state
  bool isFocus = false;
  String? focusMessage;
  DateTime? focusSetAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dateKey': dateKey,
    'completionDateKey': completionDateKey,
    'isDone': isDone,
    'listId': listId,
    'isFocus': isFocus,
    'focusMessage': focusMessage,
    'focusSetAt': focusSetAt?.toIso8601String(),
  };

  static DailyTask fromJson(Map<String, dynamic> json) =>
      DailyTask(
          id: json['id'] as String,
          title: json['title'] as String? ?? '',
          description: json['description'] as String? ?? '',
          dateKey: json['dateKey'] as String,
          completionDateKey: json['completionDateKey'] as String?,
          isDone: json['isDone'] as bool? ?? false,
          listId: json['listId'] as String?,
        )
        ..isFocus = json['isFocus'] as bool? ?? false
        ..focusMessage = json['focusMessage'] as String?
        ..focusSetAt = json['focusSetAt'] != null
            ? DateTime.parse(json['focusSetAt'] as String)
            : null;
}
