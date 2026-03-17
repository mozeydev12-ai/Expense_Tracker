import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  static const String _boxName = 'expenses';
  static const String _budgetKey = 'budget';
  static const _uuid = Uuid();

  // ── Internal references ──────────────────────────────────
  final Box<Expense> _box = Hive.box<Expense>(_boxName);
  final Box<dynamic> _settingsBox = Hive.box('settings');

  // ── Public state ─────────────────────────────────────────

  /// All transactions, newest first.
  List<Expense> get all => _box.values.toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  /// Only expense-type transactions.
  List<Expense> get expenses =>
      all.where((e) => e.type == 'expense').toList();

  /// Only income-type transactions.
  List<Expense> get incomes =>
      all.where((e) => e.type == 'income').toList();

  /// Filter by category. Pass null or 'all' to get everything.
  List<Expense> byCategory(String? cat) {
    if (cat == null || cat == 'all') return all;
    return all.where((e) => e.category == cat).toList();
  }

  // ── Computed totals ───────────────────────────────────────

  double get totalExpenses =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get totalIncome =>
      incomes.fold(0.0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpenses;

  // ── Budget ────────────────────────────────────────────────

  double get budget =>
      (_settingsBox.get(_budgetKey) as double?) ?? 150000;

  double get budgetUsedPercent =>
      budget > 0 ? (totalExpenses / budget).clamp(0, 1) : 0;

  Future<void> setBudget(double value) async {
    await _settingsBox.put(_budgetKey, value);
    notifyListeners();
  }

  // ── Spending by category (for pie chart) ─────────────────

  Map<String, double> get spendingByCategory {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    // Sort by amount descending
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  // ── CRUD ─────────────────────────────────────────────────

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required String type,
    DateTime? date,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date ?? DateTime.now(),
      category: category,
      type: type,
    );
    await _box.put(expense.id, expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> updateExpense(Expense updated) async {
    await _box.put(updated.id, updated);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}
