import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:montra/models/transaction.dart'; // Import Transaction model

class TransactionsStorage {
  // Save transactions to SharedPreferences
  Future<void> saveTransactions(List<Transaction> transactions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get instance of SharedPreferences
    String transactionString = transactions.map((transaction) {
      // Map each transaction to a string format for storage
      return "${transaction.title}|${transaction.amount}|${transaction.date.toIso8601String()}|${transaction.category}|${transaction.type}";
    }).join(";"); // Join transaction strings with a delimiter
    await prefs.setString('transactions', transactionString); // Save transaction string to SharedPreferences
  }

  // Load transactions from SharedPreferences
  Future<List<Transaction>> loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get instance of SharedPreferences
    String? transactionString = prefs.getString('transactions'); // Get transaction string from SharedPreferences
    List<Transaction> transactions = [];
    if (transactionString != null && transactionString.isNotEmpty) {
      // Check if transaction string is not null or empty
      List<String> transactionList = transactionString.split(";"); // Split transaction string into individual transactions
      transactions = transactionList.map((transactionString) {
        List<String> values = transactionString.split("|"); // Split transaction string into values
        return Transaction(
          title: values[0],
          amount: double.parse(values[1]),
          date: DateTime.parse(values[2]),
          category: Category.values.firstWhere((e) => e.toString() == values[3]), // Parse category from string
          type: TransactionType.values.firstWhere((e) => e.toString() == values[4]), // Parse transaction type from string
        );
      }).toList(); // Map each transaction string to a Transaction object
    }
    return transactions; // Return list of transactions
  }
}
