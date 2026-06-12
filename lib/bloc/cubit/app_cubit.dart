import 'package:fintracker/data/icons.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  final String? username;
  final String? currencyCode;
  final int themeColor;
  final List<Account> accounts;
  final List<Category> categories;
  final List<Payment> payments;

  const AppState({
    required this.username,
    required this.currencyCode,
    required this.themeColor,
    required this.accounts,
    required this.categories,
    required this.payments,
  });

  bool get isConfigured => username != null && currencyCode != null;

  AppState copyWith({
    String? username,
    String? currencyCode,
    int? themeColor,
    List<Account>? accounts,
    List<Category>? categories,
    List<Payment>? payments,
  }) {
    return AppState(
      username: username ?? this.username,
      currencyCode: currencyCode ?? this.currencyCode,
      themeColor: themeColor ?? this.themeColor,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      payments: payments ?? this.payments,
    );
  }
}

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(
          AppState(
            username: null,
            currencyCode: null,
            themeColor: Colors.green.value,
            accounts: _seedAccounts(),
            categories: _seedCategories(),
            payments: const [],
          ),
        );

  static List<Account> _seedAccounts() => [
        Account(
          id: 1,
          name: 'Cash',
          holderName: 'Personal',
          accountNumber: '',
          iconCodePoint: Icons.wallet.codePoint,
          colorValue: 0xFF0F9D58,
          isDefault: true,
        ),
      ];

  static List<Category> _seedCategories() => [
        Category(id: 1, name: 'Housing', iconCodePoint: Icons.home.codePoint, colorValue: 0xFF5E35B1),
        Category(id: 2, name: 'Transportation', iconCodePoint: Icons.directions_bus.codePoint, colorValue: 0xFF1E88E5),
        Category(id: 3, name: 'Food', iconCodePoint: Icons.restaurant.codePoint, colorValue: 0xFFE53935),
        Category(id: 4, name: 'Utilities', iconCodePoint: Icons.lightbulb.codePoint, colorValue: 0xFFFFA000),
        Category(id: 5, name: 'Healthcare', iconCodePoint: Icons.health_and_safety.codePoint, colorValue: 0xFF43A047),
        Category(id: 6, name: 'Education', iconCodePoint: Icons.school.codePoint, colorValue: 0xFF8E24AA),
        Category(id: 7, name: 'Entertainment', iconCodePoint: Icons.movie.codePoint, colorValue: 0xFFFB8C00),
        Category(id: 8, name: 'Other', iconCodePoint: Icons.more_horiz.codePoint, colorValue: 0xFF546E7A),
      ];

  int _nextAccountId() => state.accounts.isEmpty ? 1 : state.accounts.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  int _nextCategoryId() => state.categories.isEmpty ? 1 : state.categories.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  int _nextPaymentId() => state.payments.isEmpty ? 1 : state.payments.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  void updateUsername(String username) {
    emit(state.copyWith(username: username.trim().isEmpty ? null : username.trim()));
  }

  void updateCurrency(String currencyCode) {
    emit(state.copyWith(currencyCode: currencyCode));
  }

  void updateThemeColor(int color) {
    emit(state.copyWith(themeColor: color));
  }

  void resetProfile() {
    emit(state.copyWith(username: null, currencyCode: null));
  }

  void resetDemoData() {
    emit(
      state.copyWith(
        accounts: _seedAccounts(),
        categories: _seedCategories(),
        payments: const [],
      ),
    );
  }

  void resetAll() {
    emit(
      AppState(
        username: null,
        currencyCode: null,
        themeColor: Colors.green.value,
        accounts: _seedAccounts(),
        categories: _seedCategories(),
        payments: const [],
      ),
    );
  }

  Account? accountById(int id) {
    for (final account in state.accounts) {
      if (account.id == id) return account;
    }
    return null;
  }

  Category? categoryById(int id) {
    for (final category in state.categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  List<Account> summarizedAccounts() {
    final incomeByAccount = <int, double>{};
    final expenseByAccount = <int, double>{};

    for (final payment in state.payments) {
      final accountId = payment.accountId;
      final amount = payment.amount;
      if (payment.type == PaymentType.credit) {
        incomeByAccount[accountId] = (incomeByAccount[accountId] ?? 0) + amount;
      } else {
        expenseByAccount[accountId] = (expenseByAccount[accountId] ?? 0) + amount;
      }
    }

    return state.accounts
        .map(
          (account) => account.copyWith(
            income: incomeByAccount[account.id] ?? 0,
            expense: expenseByAccount[account.id] ?? 0,
            balance: (incomeByAccount[account.id] ?? 0) - (expenseByAccount[account.id] ?? 0),
          ),
        )
        .toList(growable: false);
  }

  List<Category> summarizedCategories({DateTime? month}) {
    final target = month ?? DateTime.now();
    final start = DateTime(target.year, target.month);
    final end = DateTime(target.year, target.month + 1).subtract(const Duration(milliseconds: 1));

    final expenseByCategory = <int, double>{};
    for (final payment in state.payments) {
      if (payment.type != PaymentType.debit) continue;
      if (payment.datetime.isBefore(start) || payment.datetime.isAfter(end)) continue;
      expenseByCategory[payment.categoryId] = (expenseByCategory[payment.categoryId] ?? 0) + payment.amount;
    }

    return state.categories
        .map(
          (category) => category.copyWith(
            expense: expenseByCategory[category.id] ?? 0,
          ),
        )
        .toList(growable: false);
  }

  List<PaymentView> paymentViews({
    DateTimeRange? range,
    PaymentType? type,
    int? accountId,
    int? categoryId,
  }) {
    final filtered = state.payments.where((payment) {
      if (range != null) {
        final start = DateTime(range.start.year, range.start.month, range.start.day);
        final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59, 999);
        if (payment.datetime.isBefore(start) || payment.datetime.isAfter(end)) {
          return false;
        }
      }
      if (type != null && payment.type != type) return false;
      if (accountId != null && payment.accountId != accountId) return false;
      if (categoryId != null && payment.categoryId != categoryId) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.datetime.compareTo(a.datetime));

    return filtered
        .map((payment) {
          final account = accountById(payment.accountId) ?? state.accounts.first;
          final category = categoryById(payment.categoryId) ?? state.categories.first;
          return PaymentView(payment: payment, account: account, category: category);
        })
        .toList(growable: false);
  }

  PaymentView? paymentViewById(int id) {
    for (final payment in state.payments) {
      if (payment.id == id) {
        final account = accountById(payment.accountId) ?? state.accounts.first;
        final category = categoryById(payment.categoryId) ?? state.categories.first;
        return PaymentView(payment: payment, account: account, category: category);
      }
    }
    return null;
  }

  void upsertAccount({
    int? id,
    required String name,
    required String holderName,
    required String accountNumber,
    required int iconCodePoint,
    required int colorValue,
    required bool isDefault,
  }) {
    final account = Account(
      id: id ?? _nextAccountId(),
      name: name.trim(),
      holderName: holderName.trim(),
      accountNumber: accountNumber.trim(),
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      isDefault: isDefault,
    );

    final accounts = [...state.accounts];
    final index = accounts.indexWhere((a) => a.id == account.id);
    if (index >= 0) {
      accounts[index] = account;
    } else {
      accounts.add(account);
    }

    if (isDefault) {
      for (var i = 0; i < accounts.length; i++) {
        if (accounts[i].id != account.id && accounts[i].isDefault) {
          accounts[i] = accounts[i].copyWith(isDefault: false);
        }
      }
    }

    emit(state.copyWith(accounts: accounts));
  }

  void deleteAccount(int id) {
    final filteredPayments = state.payments.where((p) => p.accountId != id).toList(growable: false);
    final filteredAccounts = state.accounts.where((a) => a.id != id).toList(growable: false);

    if (filteredAccounts.isEmpty) {
      emit(
        state.copyWith(
          accounts: _seedAccounts(),
          payments: filteredPayments,
        ),
      );
      return;
    }

    emit(state.copyWith(accounts: filteredAccounts, payments: filteredPayments));
  }

  void upsertCategory({
    int? id,
    required String name,
    required int iconCodePoint,
    required int colorValue,
    required double budget,
  }) {
    final category = Category(
      id: id ?? _nextCategoryId(),
      name: name.trim(),
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      budget: budget,
    );

    final categories = [...state.categories];
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      categories[index] = category;
    } else {
      categories.add(category);
    }

    emit(state.copyWith(categories: categories));
  }

  void deleteCategory(int id) {
    final filteredPayments = state.payments.where((p) => p.categoryId != id).toList(growable: false);
    final filteredCategories = state.categories.where((c) => c.id != id).toList(growable: false);

    if (filteredCategories.isEmpty) {
      emit(
        state.copyWith(
          categories: _seedCategories(),
          payments: filteredPayments,
        ),
      );
      return;
    }

    emit(state.copyWith(categories: filteredCategories, payments: filteredPayments));
  }

  void upsertPayment({
    int? id,
    required int accountId,
    required int categoryId,
    required double amount,
    required PaymentType type,
    required DateTime datetime,
    required String title,
    required String description,
  }) {
    final payment = Payment(
      id: id ?? _nextPaymentId(),
      accountId: accountId,
      categoryId: categoryId,
      amount: amount,
      type: type,
      datetime: datetime,
      title: title.trim(),
      description: description.trim(),
    );

    final payments = [...state.payments];
    final index = payments.indexWhere((p) => p.id == payment.id);
    if (index >= 0) {
      payments[index] = payment;
    } else {
      payments.add(payment);
    }

    emit(state.copyWith(payments: payments));
  }

  void deletePayment(int id) {
    emit(state.copyWith(payments: state.payments.where((p) => p.id != id).toList(growable: false)));
  }

  List<IconData> get iconChoices => AppIcons.icons;
}
