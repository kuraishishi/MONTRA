import 'package:montra/widgets/transactions_list/transactions_item.dart';
import 'package:flutter/material.dart';
import 'package:montra/models/transaction.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({Key? key, required this.transactions, required this.onRemoveTransaction});

  final List<Transaction> transactions; // List of transactions to display
  final void Function(Transaction transaction) onRemoveTransaction; // Callback function for removing a transaction

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length, // Total number of transactions
      itemBuilder: (context, index) {
        return Container(
          child: Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error, // Background color for dismiss action
              margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal), // Set the margin to match the card margin
            ),
            key: ValueKey(transactions[index]), // Unique key for each transaction
            onDismissed: (direction){
              onRemoveTransaction(transactions[index]); // Call the remove transaction function when dismissed
            },
            child: TransactionItem(
              transaction: transactions[index], // Pass the transaction data to the item widget
            ),
          ),
        );
      },
    );
  }
}
