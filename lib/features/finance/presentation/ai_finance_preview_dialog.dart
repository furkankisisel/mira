import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../domain/ai_finance_dto.dart';
import '../data/transaction_model.dart';
import '../data/finance_category_repository.dart';
import '../data/finance_category.dart';
import 'package:uuid/uuid.dart';

class AiFinancePreviewDialog extends StatefulWidget {
  final List<AiFinanceTransactionDto> parsedTransactions;
  final FinanceCategoryRepository catRepo; // ADDED

  const AiFinancePreviewDialog({
    super.key,
    required this.parsedTransactions,
    required this.catRepo, // ADDED
  });

  @override
  State<AiFinancePreviewDialog> createState() => _AiFinancePreviewDialogState();
}

class _AiFinancePreviewDialogState extends State<AiFinancePreviewDialog> {
  late List<_WorkingTransaction> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.parsedTransactions.map((dto) {
      return _WorkingTransaction(
        isSelected: true,
        title: dto.title,
        amount: dto.amount,
        date: dto.date,
        type: dto.type == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        emoji: dto.emoji,
      );
    }).toList();
  }

  Future<void> _saveSelected() async {
    final selected = <FinanceTransaction>[];
    
    for (var e in _items.where((item) => item.isSelected)) {
      String? categoryId;
      if (e.emoji != null && e.emoji!.isNotEmpty) {
        // Try to find an existing category with this emoji and type
        final existingCats = widget.catRepo.byType(e.type);
        try {
          final match = existingCats.firstWhere((cat) => cat.emoji == e.emoji);
          categoryId = match.id;
        } catch (_) {
          // If not found, create a new category to hold this emoji
          final newId = const Uuid().v4();
          categoryId = newId;
          final newCat = FinanceCategory(
            id: newId,
            name: e.title.length > 15 ? e.title.substring(0, 15) : e.title, // use title as category name
            iconCodePoint: Icons.category.codePoint,
            emoji: e.emoji,
            type: e.type,
            colorValue: Theme.of(context).colorScheme.primary.value,
          );
          await widget.catRepo.add(newCat);
        }
      }

      selected.add(FinanceTransaction(
        id: const Uuid().v4(),
        title: e.title,
        amount: e.amount,
        date: e.date,
        type: e.type,
        categoryId: categoryId,
      ));
    }
    
    if (mounted) Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final currencySymbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analiz Sonucu'),
        actions: [
          TextButton(
            onPressed: () {
              bool anySelected = _items.any((e) => e.isSelected);
              setState(() {
                for (var element in _items) {
                  element.isSelected = !anySelected;
                }
              });
            },
            child: Text(_items.any((e) => e.isSelected) ? 'Tümünü Kaldır' : 'Tümünü Seç'),
          )
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('İşlem bulunamadı.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isSelected,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => item.isSelected = val);
                            }
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (item.emoji != null && item.emoji!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(item.emoji!, style: const TextStyle(fontSize: 20)),
                                    ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: item.title,
                                      decoration: const InputDecoration(
                                        labelText: 'Başlık',
                                        isDense: true,
                                      ),
                                      onChanged: (val) => item.title = val,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      initialValue: item.amount.toString(),
                                      decoration: InputDecoration(
                                        labelText: 'Tutar',
                                        prefixText: currencySymbol,
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        item.amount = double.tryParse(val) ?? 0.0;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: DropdownButtonFormField<TransactionType>(
                                      value: item.type,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Tür',
                                        isDense: true,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: TransactionType.expense,
                                          child: Text('Gider', overflow: TextOverflow.ellipsis),
                                        ),
                                        DropdownMenuItem(
                                          value: TransactionType.income,
                                          child: Text('Gelir', overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() => item.type = val);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: _items.any((e) => e.isSelected) ? _saveSelected : null,
            child: const Text('Seçilenleri Kaydet'),
          ),
        ),
      ),
    );
  }
}

class _WorkingTransaction {
  bool isSelected;
  String title;
  double amount;
  DateTime date;
  TransactionType type;
  String? emoji; // We just story emoji for visual display here; not saved to DB model yet unless we add category finding logic later

  _WorkingTransaction({
    required this.isSelected,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.emoji,
  });
}
