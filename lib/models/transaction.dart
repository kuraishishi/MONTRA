import 'package:flutter/cupertino.dart'; // Import Cupertino library for iOS style widgets
import 'package:flutter/material.dart'; // Import Material library for Android style widgets
import 'package:uuid/uuid.dart'; // Import Uuid package for generating unique IDs
import 'package:intl/intl.dart'; // Import Intl package for date formatting

final formatter = DateFormat.yMd(); // Initialize date formatter for formatting dates
// To generate unique id's
const uuid = Uuid(); // Create a Uuid instance

// Define an enum for transaction categories
enum Category { food, travel, leisure, work }

// Define icons corresponding to each transaction category
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

// Define an enum for transaction types (income or expense)
enum TransactionType { income, expense }

// Define a Transaction class to represent individual transactions
class Transaction {
  Transaction({
    required this.title, // Title of the transaction
    required this.amount, // Amount of the transaction
    required this.date, // Date of the transaction
    required this.category, // Category of the transaction
    required this.type, // Type of the transaction (income or expense)
  }) : id = uuid.v4(); // Generate a unique ID for the transaction

  final String id; // Unique ID of the transaction
  final String title; // Title of the transaction
  final double amount; // Amount of the transaction
  final DateTime date; // Date of the transaction
  final Category category; // Category of the transaction
  final TransactionType type; // Type of the transaction (income or expense)

  String get formattedDate {
    return formatter.format(date); // Format the date using the defined formatter
  }
}

// Define a TransactionBucket class to represent a collection of transactions for a specific category
class TransactionBucket {
  const TransactionBucket({required this.category, required this.transactions}); // Constructor

  // Constructor to create a TransactionBucket for a specific category from a list of all transactions
  TransactionBucket.forCategory(List<Transaction> allTransactions, this.category)
      : transactions = allTransactions.where((transaction) => transaction.category == category).toList();

  final Category category; // Category of the transaction bucket
  final List<Transaction> transactions; // List of transactions in the bucket

  // Calculate the total expenses for all transactions in the bucket
  double get totalExpenses {
    double sum = 0;
    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      sum += transaction.amount;
    }
    return sum;
  }

  // Calculate the total income for all transactions in the bucket
  double get totalIncome {
    double sum = 0;
    for (final transaction in transactions.where((t) => t.type == TransactionType.income)) {
      sum += transaction.amount;
    }
    return sum;
  }
}
