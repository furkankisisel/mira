import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../data/finance_category.dart';
import '../data/finance_category_repository.dart';
import '../data/transaction_model.dart';
import '../domain/ai_finance_dto.dart';

class AiFinancePreviewDialog extends StatefulWidget {
  final List<AiFinanceTransactionDto> parsedTransactions;
  final FinanceCategoryRepository catRepo;

  const AiFinancePreviewDialog({
    super.key,
    required this.parsedTransactions,
    required this.catRepo,
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
        type: dto.type == 'income' ? TransactionType.income : TransactionType.expense,
        emoji: dto.emoji,
      );
    }).toList();
  }

  Future<void> _saveSelected() async {
    HapticFeedback.mediumImpact();
    final selected = <FinanceTransaction>[];

    for (var e in _items.where((item) => item.isSelected)) {
      String? categoryId;
      if (e.emoji != null && e.emoji!.isNotEmpty) {
        final existingCats = widget.catRepo.byType(e.type);
        try {
          final match = existingCats.firstWhere((cat) => cat.emoji == e.emoji);
          categoryId = match.id;
        } catch (_) {
          final newId = const Uuid().v4();
          categoryId = newId;
          final newCat = FinanceCategory(
            id: newId,
            name: e.title.length > 15 ? e.title.substring(0, 15) : e.title,
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toString();
    final isTr = locale.startsWith('tr');
    final currencySymbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;

    final selectedCount = _items.where((e) => e.isSelected).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isTr ? 'AI Ekstre / Fiş Analizi' : 'AI Statement Analysis',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              bool anySelected = _items.any((e) => e.isSelected);
              setState(() {
                for (var element in _items) {
                  element.isSelected = !anySelected;
                }
              });
            },
            child: Text(
              _items.any((e) => e.isSelected)
                  ? (isTr ? 'Tümünü Kaldır' : 'Deselect All')
                  : (isTr ? 'Tümünü Seç' : 'Select All'),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Text(
                isTr ? 'Hiçbir işlem bulunamadı.' : 'No transactions found.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isIncome = item.type == TransactionType.income;
                final amountColor = isIncome ? const Color(0xFF10B981) : const Color(0xFFF43F5E);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? (item.isSelected
                            ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                            : scheme.surfaceContainerHighest.withValues(alpha: 0.2))
                        : (item.isSelected ? Colors.white : Colors.grey.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item.isSelected
                          ? scheme.primary.withValues(alpha: 0.4)
                          : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      width: item.isSelected ? 1.5 : 1,
                    ),
                    boxShadow: item.isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Checkbox(
                          value: item.isSelected,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          activeColor: scheme.primary,
                          onChanged: (val) {
                            if (val != null) {
                              HapticFeedback.selectionClick();
                              setState(() => item.isSelected = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Editable fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Emoji Row
                            Row(
                              children: [
                                if (item.emoji != null && item.emoji!.isNotEmpty) ...[
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: (isIncome ? const Color(0xFF10B981) : const Color(0xFFF43F5E))
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item.emoji!, style: const TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                Expanded(
                                  child: TextFormField(
                                    initialValue: item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: isTr ? 'İşlem Başlığı' : 'Title',
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) => item.title = val,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Amount & Type Selector Row
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.black.withValues(alpha: 0.03),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextFormField(
                                      initialValue: item.amount.toStringAsFixed(2),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: amountColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixText: currencySymbol,
                                        prefixStyle: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          color: amountColor,
                                        ),
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {
                                        item.amount = double.tryParse(val) ?? 0.0;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.black.withValues(alpha: 0.03),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<TransactionType>(
                                        value: item.type,
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down_rounded),
                                        items: [
                                          DropdownMenuItem(
                                            value: TransactionType.expense,
                                            child: Text(
                                              isTr ? 'Gider' : 'Expense',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFF43F5E),
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: TransactionType.income,
                                            child: Text(
                                              isTr ? 'Gelir' : 'Income',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF10B981),
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) {
                                            HapticFeedback.selectionClick();
                                            setState(() => item.type = val);
                                          }
                                        },
                                      ),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: selectedCount > 0 ? _saveSelected : null,
            child: Text(
              selectedCount > 0
                  ? (isTr ? 'Seçilen $selectedCount İşlemi Kaydet' : 'Save $selectedCount Records')
                  : (isTr ? 'İşlem Seçin' : 'Select Records'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
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
  String? emoji;

  _WorkingTransaction({
    required this.isSelected,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.emoji,
  });
}
