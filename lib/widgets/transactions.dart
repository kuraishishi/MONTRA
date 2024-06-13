import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:montra/main.dart'; // Importing the main.dart file
import 'package:montra/widgets/chart/chart.dart'; // Importing the chart widget
import 'package:montra/widgets/new_transaction.dart'; // Importing the new transaction widget
import 'package:flutter/material.dart';
import '../models/transaction.dart'; // Importing the transaction model
import '../models/transactions_storage.dart'; // Importing the transactions storage model

// Define the Transactions widget as a StatefulWidget
class Transactions extends StatefulWidget {
  const Transactions({Key? key});

  @override
  State<Transactions> createState() => _TransactionsState(); // Create the state for the Transactions widget
}

// Initialize variables for storing registered transactions and months
List<Transaction> _registeredTransactions = [];
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

// Define the state for the Transactions widget
class _TransactionsState extends State<Transactions> {
  final TransactionsStorage _transactionsStorage = TransactionsStorage(); // Initialize a TransactionsStorage object
  late String _selectedMonth; // Store the selected month

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Load transactions when the widget initializes
    _selectedMonth = months[DateTime.now().month - 1]; // Set the selected month to the current month
  }

  // Calculate the total income from transactions
  double calculateTotalIncome(List<Transaction> transactions) {
    double total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      }
    }
    return total;
  }

  // Calculate the total expense from transactions
  double calculateTotalExpense(List<Transaction> transactions) {
    double total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        total += transaction.amount;
      }
    }
    return total;
  }

  // Calculate the balance (income - expense)
  double calculateBalance(List<Transaction> transactions) {
    return calculateTotalIncome(transactions) - calculateTotalExpense(transactions);
  }

  // Load transactions from storage
  Future<void> _loadTransactions() async {
    List<Transaction> loadedTransactions = await _transactionsStorage.loadTransactions();
    setState(() {
      _registeredTransactions = loadedTransactions;
    });
  }

  // Add a transaction to the list and save it
  Future<void> _addTransaction(Transaction transaction) async {
    setState(() {
      _registeredTransactions.add(transaction);
    });
    await _transactionsStorage.saveTransactions(_registeredTransactions);
  }

  // Open the add transaction overlay
  void _openAddTransactionOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTransaction(
        onAddTransaction: _addTransaction,
      ),
    );
  }

  // Open the detailed transactions page
  void _openTransactionsDetailPage(List<Transaction> transactions) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransactionsDetailPage(transactions: transactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on the selected month
    final filteredTransactions = _registeredTransactions.where((transaction) {
      return DateFormat('MMMM').format(transaction.date) == _selectedMonth;
    }).toList();

    // Initialize mainContent widget
    Widget mainContent = const Center(
    );

    final width = MediaQuery.of(context).size.width; // Get the device width

    return Scaffold(
      appBar: AppBar(
        title: const Text('Montra'),
        actions: [
          IconButton(
            onPressed: _openAddTransactionOverlay, // Open the add transaction overlay
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Monthly Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Display a list of months to filter transactions
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = months[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMonth = month; // Update the selected month
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: month == _selectedMonth ? Colors.blue.withOpacity(0.5) : null,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(month, style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Display total income, expenses, and balance
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Income',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp.${calculateTotalIncome(filteredTransactions).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Total Expenses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp.${calculateTotalExpense(filteredTransactions).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp.${calculateBalance(filteredTransactions).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Display chart and main content based on screen width
            width < 600
                ? Column(
              children: [
                Chart(transactions: filteredTransactions), // Display the chart
                const SizedBox(height: 16),
                mainContent,
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: Chart(transactions: filteredTransactions), // Display the chart
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _openTransactionsDetailPage(filteredTransactions), // Open detailed transactions page
              child: const Text('View Detailed Transactions'),
            ),
          ],
        ),
      ),
    );
  }
}

// Define a page to display detailed transactions
class TransactionsDetailPage extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsDetailPage({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final amountText = transaction.type == TransactionType.income
              ? '+Rp.${transaction.amount}'
              : '-Rp.${transaction.amount}';
          final formattedDate = DateFormat.yMMMd().format(transaction.date);

          return ListTile(
            title: Text(transaction.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: $amountText'),
                Text('Date: $formattedDate'),
                Text('Category: ${transaction.category}'),
                Text('Type: ${transaction.type}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
