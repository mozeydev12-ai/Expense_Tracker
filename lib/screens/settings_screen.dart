import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _showBudgetDialog(ExpenseProvider provider) {
    _budgetController.text = provider.budget.toStringAsFixed(0);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bg3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Set Monthly Budget',
          style: TextStyle(
            fontFamily: 'Syne',
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrim,
          ),
        ),
        content: TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrim, fontSize: 18),
          decoration: const InputDecoration(
            prefixText: '₦ ',
            prefixStyle: TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w700,
              fontFamily: 'Syne',
            ),
            hintText: '0',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSec)),
          ),
          ElevatedButton(
            onPressed: () {
              final v = double.tryParse(_budgetController.text);
              if (v != null && v > 0) {
                provider.setBudget(v);
                Navigator.pop(ctx);
                _toast('✅ Budget updated!');
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bg3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear all data?',
          style: TextStyle(
            fontFamily: 'Syne',
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrim,
          ),
        ),
        content: const Text(
          'This will permanently delete all your transactions. This cannot be undone.',
          style: TextStyle(color: AppTheme.textSec, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSec)),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(ctx);
              _toast('🗑️ All data cleared');
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.bg4,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final pct = provider.budgetUsedPercent;
            final Color barColor = pct >= 1.0
                ? AppTheme.red
                : pct >= 0.75
                    ? AppTheme.gold
                    : AppTheme.green;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrim,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage your account & budget',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSec,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Profile card ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.bg3,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.gold.withOpacity(0.12),
                              border: Border.all(
                                  color: AppTheme.gold, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'CE',
                                style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.gold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chukwuemeka',
                                style: TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrim,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'chuke@gmail.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSec,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Budget section ────────────────────────
                  _SectionLabel(label: 'Monthly Budget'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.bg3,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Budget used',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSec,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Syne',
                                    fontSize: 12,
                                    color: AppTheme.textTert,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: Fmt.currency(
                                          provider.totalExpenses),
                                      style: const TextStyle(
                                          color: AppTheme.textPrim,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                        text:
                                            ' / ${Fmt.currency(provider.budget)}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 8,
                              backgroundColor: AppTheme.bg4,
                              valueColor:
                                  AlwaysStoppedAnimation(barColor),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _showBudgetDialog(provider),
                              child: const Text('Change Budget'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── App preferences ───────────────────────
                  _SectionLabel(label: 'Preferences'),
                  _SettingsGroup(items: [
                    _SettingsTile(
                      icon: '🔔',
                      title: 'Notifications',
                      subtitle: 'Spending alerts & reminders',
                      onTap: () => _toast('Coming soon!'),
                    ),
                    _SettingsTile(
                      icon: '💱',
                      title: 'Currency',
                      subtitle: 'Nigerian Naira (₦)',
                      onTap: () => _toast('Coming soon!'),
                    ),
                    _SettingsTile(
                      icon: '📤',
                      title: 'Export Data',
                      subtitle: 'Download your transactions as CSV',
                      onTap: () => _toast(
                          '📊 ${provider.all.length} transactions ready to export'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Danger zone ───────────────────────────
                  _SectionLabel(label: 'Danger Zone'),
                  _SettingsGroup(items: [
                    _SettingsTile(
                      icon: '🗑️',
                      title: 'Clear all data',
                      subtitle: 'Permanently remove all transactions',
                      titleColor: AppTheme.red,
                      borderColor: AppTheme.red.withOpacity(0.2),
                      onTap: () => _confirmClearAll(provider),
                    ),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 10,
          letterSpacing: 1.0,
          color: AppTheme.textTert,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsTile> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: items.map((tile) {
            final isLast = tile == items.last;
            return Column(
              children: [
                tile,
                if (!isLast)
                  const Divider(
                    height: 1,
                    color: AppTheme.border,
                    indent: 60,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon, title, subtitle;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? borderColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.bg3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(icon,
                        style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: titleColor ?? AppTheme.textPrim,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSec,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  size: 16, color: AppTheme.textTert),
            ],
          ),
        ),
      ),
    );
  }
}
