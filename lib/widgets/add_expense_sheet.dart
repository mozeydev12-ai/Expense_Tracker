import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();

  String _selectedCategory = 'food';
  String _selectedType = 'expense';
  bool _isLoading = false;

  static const _categories = [
    ('food', '🍔', 'Food'),
    ('transport', '🚗', 'Transport'),
    ('bills', '⚡', 'Bills'),
    ('health', '💊', 'Health'),
    ('shopping', '🛍️', 'Shopping'),
    ('other', '✨', 'Other'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _titleFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await context.read<ExpenseProvider>().addExpense(
          title: _titleCtrl.text.trim(),
          amount: double.parse(_amountCtrl.text),
          category: _selectedCategory,
          type: _selectedType,
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedType == 'income'
                ? '✅ Income recorded!'
                : '✅ Expense saved!',
            style: const TextStyle(
              fontFamily: 'Syne',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppTheme.bg4,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bg2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppTheme.border2)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const Text(
              'Add Transaction',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrim,
              ),
            ),
            const SizedBox(height: 22),

            // ── Type toggle ──────────────────────────────
            _TypeToggle(
              selected: _selectedType,
              onChanged: (t) => setState(() => _selectedType = t),
            ),
            const SizedBox(height: 18),

            // ── Amount field ─────────────────────────────
            _FieldLabel(label: 'Amount'),
            TextFormField(
              controller: _amountCtrl,
              focusNode: _amountFocus,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_titleFocus),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.gold,
              ),
              decoration: const InputDecoration(
                prefixText: '₦ ',
                prefixStyle: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gold,
                ),
                hintText: '0.00',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                final n = double.tryParse(v);
                if (n == null) return 'Enter a valid number';
                if (n <= 0) return 'Amount must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Title field ──────────────────────────────
            _FieldLabel(label: 'Description'),
            TextFormField(
              controller: _titleCtrl,
              focusNode: _titleFocus,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: AppTheme.textPrim),
              decoration: const InputDecoration(
                hintText: 'What did you spend on?',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter a description';
                }
                if (v.trim().length < 2) {
                  return 'Description is too short';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // ── Category picker ──────────────────────────
            _FieldLabel(label: 'Category'),
            _CategoryGrid(
              selected: _selectedCategory,
              onChanged: (c) => setState(() => _selectedCategory = c),
            ),
            const SizedBox(height: 22),

            // ── Submit ───────────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.bg,
                        ),
                      )
                    : const Text('Save Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 10,
          letterSpacing: 1.0,
          color: AppTheme.textSec,
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _TypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _TypeButton(
          label: '- Expense',
          isSelected: selected == 'expense',
          selectedColor: AppTheme.red,
          onTap: () => onChanged('expense'),
        )),
        const SizedBox(width: 10),
        Expanded(child: _TypeButton(
          label: '+ Income',
          isSelected: selected == 'income',
          selectedColor: AppTheme.green,
          onTap: () => onChanged('income'),
        )),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.12)
              : AppTheme.bg3,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : AppTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? selectedColor : AppTheme.textSec,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  static const _items = [
    ('food', '🍔', 'Food'),
    ('transport', '🚗', 'Transport'),
    ('bills', '⚡', 'Bills'),
    ('health', '💊', 'Health'),
    ('shopping', '🛍️', 'Shopping'),
    ('other', '✨', 'Other'),
  ];

  const _CategoryGrid({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      crossAxisSpacing: 8,
      mainAxisSpacing: 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _items.map((item) {
        final (key, icon, label) = item;
        final isSelected = selected == key;
        return GestureDetector(
          onTap: () => onChanged(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.gold.withOpacity(0.12)
                  : AppTheme.bg3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.gold : AppTheme.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 8,
                    color: isSelected ? AppTheme.gold : AppTheme.textSec,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
