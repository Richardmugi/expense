import 'package:expense/records.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AmountPage extends StatefulWidget {
  final String expense;

  AmountPage(this.expense);

  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  double _quantity = 1;
  double _amount = 0;

  void _saveAmount() async {
    // Save the _quantity and _amount to SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final expenseRecord = {
      'expense': widget.expense,
      'quantity': _quantity,
      'amount': _amount,
      'date': DateTime.now()
          .toString(), // Add the current date and time to the record.
    };
    List<String> existingRecords = prefs.getStringList('expense_records') ?? [];
    existingRecords.add(json.encode(expenseRecord));
    prefs.setStringList('expense_records', existingRecords);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Quantity and Amount'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Expense: ${widget.expense}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid quantity';
                }
                final double quantity = double.tryParse(value) ?? 0.0;
                if (quantity <= 0) {
                  return 'Quantity must be greater than zero';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _quantity = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount (\$)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid amount';
                }
                final double amount = double.tryParse(value) ?? 0.0;
                if (amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAmount,
              child: Text('Save'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set the current index for the AmountPage
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Amount',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to the ExpenseTrackingPage (Categories page)
            Navigator.pushNamed(
              context,
              '/third',
            );
          }
        },
      ),
    );
  }
}
