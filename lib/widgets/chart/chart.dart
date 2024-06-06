import 'package:flutter/material.dart';
import 'package:montra/widgets/chart/chart_bar.dart'; // Import the ChartBar widget
import 'package:montra/models/transaction.dart'; // Import the Transaction model

class Chart extends StatelessWidget {
  const Chart({super.key, required this.transactions});

  final List<Transaction> transactions; // List of transactions to be displayed in the chart

  // Get a list of transaction buckets based on categories
  List<TransactionBucket> get buckets {
    return [
      TransactionBucket.forCategory(transactions, Category.food),
      TransactionBucket.forCategory(transactions, Category.leisure),
      TransactionBucket.forCategory(transactions, Category.travel),
      TransactionBucket.forCategory(transactions, Category.work),
    ];
  }

  // Get the maximum total expense among all buckets
  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark; // Check if the current theme is dark mode

    return Container(
      margin: const EdgeInsets.all(16), // Set margin for the container
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ), // Set padding for the container
      width: double.infinity, // Make the container take the full width available
      height: 180, // Set the height of the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Apply border radius to the container
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3), // Apply gradient color scheme
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter, // Set gradient start position
          end: Alignment.topCenter, // Set gradient end position
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense, // Calculate fill percentage for each chart bar
                  )
              ],
            ),
          ),
          const SizedBox(height: 12), // Add some vertical space
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4), // Set padding for each icon
                  child: Icon(
                    categoryIcons[bucket.category], // Get the icon for the category
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.secondary // Set icon color based on dark or light mode
                        : Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.7),
                  ),
                ),
              ),
            )
                .toList(),
          )
        ],
      ),
    );
  }
}
