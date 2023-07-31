import 'package:flutter/material.dart';

class TransactionDisplayPage extends StatefulWidget {
  final String expense;
  final double quantity;
  final double amount;

  TransactionDisplayPage({
    required this.expense,
    required this.quantity,
    required this.amount,
  });

  @override
  _TransactionDisplayPageState createState() => _TransactionDisplayPageState();
}

class _TransactionDisplayPageState extends State<TransactionDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense: ${widget.expense}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Quantity: ${widget.quantity.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Amount: \$${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement the logic to delete the transaction.
                Navigator.pop(
                    context); // Navigate back to the previous screen after deleting.
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
