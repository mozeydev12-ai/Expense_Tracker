import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryFilter extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChanged;

  const CategoryFilter({
    super.key,
    required this.active,
    required this.onChanged,
  });

  static const _items = [
    ('all', '🔮', 'All'),
    ('food', '🍔', 'Food'),
    ('transport', '🚗', 'Transport'),
    ('bills', '⚡', 'Bills'),
    ('health', '💊', 'Health'),
    ('shopping', '🛍️', 'Shopping'),
    ('other', '✨', 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Text(
            'Categories',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrim,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: _items.map((item) {
              final (key, icon, label) = item;
              final isActive = active == key;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _Chip(
                  icon: icon,
                  label: label,
                  isActive: isActive,
                  onTap: () => onChanged(key),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String icon, label;
  final bool isActive;
  final VoidCallback onTap;

  const _Chip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.gold.withOpacity(0.12)
                    : AppTheme.bg3,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? AppTheme.gold : AppTheme.border,
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 10,
                color: isActive ? AppTheme.gold : AppTheme.textSec,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
