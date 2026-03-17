import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = expense.type == 'expense';
    final catColor =
        AppTheme.catColors[expense.category] ?? AppTheme.textSec;
    final catIcon = AppTheme.catIcons[expense.category] ?? '✨';

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded,
                color: AppTheme.red, size: 22),
            SizedBox(height: 2),
            Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.red,
                fontSize: 10,
                fontFamily: 'Syne',
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bg3,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Left colour stripe
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(width: 3, color: catColor),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
                child: Row(
                  children: [
                    // Category icon bubble
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(catIcon,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrim,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${DateFormat('MMM d, h:mm a').format(expense.date)} · '
                            '${AppTheme.catLabels[expense.category] ?? expense.category}',
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 10,
                              color: AppTheme.textSec,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount
                    Text(
                      '${isExpense ? '-' : '+'}${Fmt.currency(expense.amount)}',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isExpense ? AppTheme.red : AppTheme.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
