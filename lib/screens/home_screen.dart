import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';
import '../widgets/balance_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final transactions = provider.byCategory(_activeFilter);

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: _buildHeader(context),
                  ),
                ),

                // ── Balance card ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: BalanceCard(
                      balance: provider.balance,
                      income: provider.totalIncome,
                      expenses: provider.totalExpenses,
                    ),
                  ),
                ),

                // ── Category filter ─────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: CategoryFilter(
                      active: _activeFilter,
                      onChanged: (cat) => setState(() => _activeFilter = cat),
                    ),
                  ),
                ),

                // ── Section header ───────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transactions',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrim,
                          ),
                        ),
                        Text(
                          '${transactions.length} records',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSec,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Transaction list ────────────────────────
                transactions.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        sliver: SliverList.separated(
                          itemCount: transactions.length,
                          separatorBuilder: (_, _EmptyState) =>
                              const SizedBox(height: 10),
                          itemBuilder: (ctx, i) {
                            return TransactionTile(
                              expense: transactions[i],
                              onDelete: () => provider
                                  .deleteExpense(transactions[i].id),
                            );
                          },
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 10,
                letterSpacing: 1.2,
                color: AppTheme.textSec,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Chukwuemeka 👋',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrim,
              ),
            ),
          ],
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.gold.withOpacity(0.12),
            border: Border.all(color: AppTheme.gold, width: 1.5),
          ),
          child: const Center(
            child: Text(
              'CE',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.gold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        const Text('💸', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 16),
        const Text(
          'No transactions yet',
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSec,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tap + to record your first expense',
          style: TextStyle(fontSize: 13, color: AppTheme.textTert),
        ),
      ],
    );
  }
}
