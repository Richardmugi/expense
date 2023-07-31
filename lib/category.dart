import 'package:expense/amount_page.dart';
import 'package:expense/transaction.dart';
import 'package:flutter/material.dart';

class ExpenseTrackingPage extends StatefulWidget {
  @override
  _ExpenseTrackingPageState createState() => _ExpenseTrackingPageState();
}

class _ExpenseTrackingPageState extends State<ExpenseTrackingPage> {
  Map<String, List<String>> categories = {
    'Food': ['Eggs', 'Bread', 'Milk', 'Vegetables', 'Fruits'],
    'Shoes': ['Sneakers', 'Sandals', 'Boots'],
    'Rent': ['Monthly Rent', 'Utilities'],
    // Add more categories and items as needed.
  };

  String? selectedCategory;
  String? selectedExpense;

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      selectedExpense =
          null; // Reset selectedExpense when a new category is chosen.
    });
  }

  void _onExpenseSelected(String expense) {
    setState(() {
      selectedExpense = expense;
    });
    _navigateToAmountPage();
  }

  void _navigateToAmountPage() {
    if (selectedExpense != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmountPage(selectedExpense!),
        ),
      );
    }
  }

  void _onTransactionSaved(String expense, double quantity, double amount) {
    // TODO: Implement the logic to save the transaction.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDisplayPage(
          expense: expense,
          quantity: quantity,
          amount: amount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a Category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.keys.length,
                itemBuilder: (context, index) {
                  final category = categories.keys.toList()[index];
                  return GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            if (selectedCategory != null) ...[
              Text(
                'Select an Expense:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: categories[selectedCategory!]!.length,
                  itemBuilder: (context, index) {
                    final expense = categories[selectedCategory!]![index];
                    return ListTile(
                      onTap: () => _onExpenseSelected(expense),
                      title: Text(expense),
                      trailing:
                          selectedExpense == expense ? Icon(Icons.check) : null,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
