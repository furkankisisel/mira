/// Weekly AI Report Model
class WeeklyReport {
  final String id;
  final DateTime weekStart;
  final DateTime weekEnd;
  final ReportType type;
  final String title;
  final String content;
  final DateTime generatedAt;
  final Map<String, dynamic>? metadata;

  WeeklyReport({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    required this.type,
    required this.title,
    required this.content,
    required this.generatedAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'weekStart': weekStart.toIso8601String(),
        'weekEnd': weekEnd.toIso8601String(),
        'type': type.name,
        'title': title,
        'content': content,
        'generatedAt': generatedAt.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };

  factory WeeklyReport.fromJson(Map<String, dynamic> json) => WeeklyReport(
        id: json['id'] as String,
        weekStart: DateTime.parse(json['weekStart'] as String),
        weekEnd: DateTime.parse(json['weekEnd'] as String),
        type: ReportType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ReportType.habits,
        ),
        title: json['title'] as String,
        content: json['content'] as String,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}

/// Report types available
enum ReportType {
  habits, // Alışkanlık analizi
  finance, // Finansal analiz
  mood, // Ruh hali analizi
  combined, // Genel haftalık özet
}

extension ReportTypeExtension on ReportType {
  String get displayName {
    switch (this) {
      case ReportType.habits:
        return 'Alışkanlık Raporu';
      case ReportType.finance:
        return 'Finansal Rapor';
      case ReportType.mood:
        return 'Ruh Hali Raporu';
      case ReportType.combined:
        return 'Haftalık Özet';
    }
  }

  String get emoji {
    switch (this) {
      case ReportType.habits:
        return '📊';
      case ReportType.finance:
        return '💰';
      case ReportType.mood:
        return '😊';
      case ReportType.combined:
        return '📋';
    }
  }
}
