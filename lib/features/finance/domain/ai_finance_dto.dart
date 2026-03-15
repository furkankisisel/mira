class AiFinanceResponse {
  final List<AiFinanceTransactionDto> transactions;

  AiFinanceResponse({required this.transactions});

  factory AiFinanceResponse.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] == null) {
      return AiFinanceResponse(transactions: []);
    }
    return AiFinanceResponse(
      transactions: (json['transactions'] as List)
          .map((e) => AiFinanceTransactionDto.fromJson(e))
          .toList(),
    );
  }
}

class AiFinanceTransactionDto {
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'income' or 'expense'
  final String? emoji; // Emoji for the transaction category

  AiFinanceTransactionDto({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.emoji,
  });

  factory AiFinanceTransactionDto.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['date']);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return AiFinanceTransactionDto(
      title: json['title'] ?? 'Bilinmeyen İşlem',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: parsedDate,
      type: json['type'] == 'income' ? 'income' : 'expense',
      emoji: json['emoji'] as String?,
    );
  }
}

