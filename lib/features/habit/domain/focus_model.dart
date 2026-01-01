/// Focus model representing the daily focus item (habit or daily task).
///
/// This model stores which habit or task is set as the user's focus for
/// the day, along with any AI-generated motivation message.

enum FocusType { habit, dailyTask }

class FocusItem {
  const FocusItem({
    required this.id,
    required this.type,
    required this.dateKey,
    this.aiMotivationMessage,
    this.lastAiUpdate,
  });

  /// The ID of the focused habit or daily task
  final String id;

  /// Whether this is a habit or daily task
  final FocusType type;

  /// The date this focus is for (YYYY-MM-DD format)
  final String dateKey;

  /// AI-generated motivational message for this focus item
  final String? aiMotivationMessage;

  /// When the AI message was last updated
  final DateTime? lastAiUpdate;

  /// Creates a copy with optional field updates
  FocusItem copyWith({
    String? id,
    FocusType? type,
    String? dateKey,
    String? aiMotivationMessage,
    DateTime? lastAiUpdate,
  }) {
    return FocusItem(
      id: id ?? this.id,
      type: type ?? this.type,
      dateKey: dateKey ?? this.dateKey,
      aiMotivationMessage: aiMotivationMessage ?? this.aiMotivationMessage,
      lastAiUpdate: lastAiUpdate ?? this.lastAiUpdate,
    );
  }

  /// Serializes to JSON for persistence
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'dateKey': dateKey,
    if (aiMotivationMessage != null) 'aiMotivationMessage': aiMotivationMessage,
    if (lastAiUpdate != null) 'lastAiUpdate': lastAiUpdate!.toIso8601String(),
  };

  /// Deserializes from JSON
  factory FocusItem.fromJson(Map<String, dynamic> json) {
    return FocusItem(
      id: json['id'] as String,
      type: FocusType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => FocusType.habit,
      ),
      dateKey: json['dateKey'] as String,
      aiMotivationMessage: json['aiMotivationMessage'] as String?,
      lastAiUpdate: json['lastAiUpdate'] != null
          ? DateTime.tryParse(json['lastAiUpdate'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          dateKey == other.dateKey;

  @override
  int get hashCode => Object.hash(id, type, dateKey);
}
