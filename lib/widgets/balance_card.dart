import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.bg3,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'TOTAL BALANCE',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 10,
              letterSpacing: 1.2,
              color: AppTheme.textSec,
            ),
          ),
          const SizedBox(height: 6),

          // Balance amount with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppTheme.goldLight, AppTheme.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              Fmt.currency(balance),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white, // shader overrides this
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Income / Expense pills
          Row(
            children: [
              Expanded(
                child: _Pill(
                  label: 'Income',
                  value: Fmt.currency(income),
                  valueColor: AppTheme.green,
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppTheme.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Pill(
                  label: 'Expenses',
                  value: Fmt.currency(expenses),
                  valueColor: AppTheme.red,
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppTheme.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label, value;
  final Color valueColor, iconColor;
  final IconData icon;

  const _Pill({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.bg4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 9,
                    letterSpacing: 0.6,
                    color: AppTheme.textTert,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
