import 'dart:math'; // Import the dart:math library for mathematical functions

import 'package:montra/models/transaction.dart'; // Import the Transaction model
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

  final Transaction transaction; // Transaction data for this item

  @override
  Widget build(BuildContext context) {
    return Card( // Display transaction data within a card widget
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Set padding for the card content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to start horizontally
          children: [
            Text(
              transaction.title, // Display transaction title
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), // Apply theme styling to the title text
            ),
            const SizedBox(height: 4,), // Add a small vertical spacing
            Row(
              children: [
                Text('Rp. ${transaction.amount.toStringAsFixed(0)}'), // Display transaction amount
                const Spacer(), // Add flexible space to push the next widget to the right
                Row(
                  children: [
                    Icon(categoryIcons[transaction.category]), // Display category icon
                    const SizedBox(width: 8,), // Add a small horizontal spacing
                    Text(transaction.formattedDate), // Display formatted transaction date
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
