import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/expenses_storage.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

List<Expense> _registeredExpenses = [];
List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class _ExpensesState extends State<Expenses> {
  final ExpensesStorage _expensesStorage = ExpensesStorage();

  @override
  void initState() {
    super.initState();

    _loadExpenses();
  }

  double calculateTotalExpense() {
    double total = 0;
    for (Expense expense in _registeredExpenses) {
      total += expense.amount;
    }
    return total;
  }

  Future<void> _loadExpenses() async {
    List<Expense> loadedExpenses = await _expensesStorage.loadExpenses();
    setState(() {
      _registeredExpenses = loadedExpenses;
    });
  }

  Future<void> _addExpense(Expense expense) async {
    setState(() {
      _registeredExpenses.add(expense);
    });
    await _expensesStorage.saveExpenses(_registeredExpenses);
  }

  Future<void> _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    await _expensesStorage.saveExpenses(_registeredExpenses);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: kColorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        content: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Expense Deleted', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
        ),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
              _expensesStorage.saveExpenses(_registeredExpenses);
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montra'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 600
          ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent),
          // Bottom bar with total expense
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Total Expense : Rp. ${calculateTotalExpense()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}

