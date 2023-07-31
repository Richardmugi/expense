import 'package:flutter/material.dart';

class AmountPage extends StatefulWidget {
  final String expense;

  AmountPage(this.expense);

  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  // ignore: unused_field
  double _quantity = 1;
  // ignore: unused_field
  double _amount = 0;

  void _saveAmount() {
    // TODO: Save the _quantity and _amount to your desired storage (e.g., SharedPreferences, database).
    Navigator.pop(
        context); // Navigate back to the previous screen after saving.
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
              onSaved: (value) {
                _quantity = double.tryParse(value!) ?? 1.0;
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
              onSaved: (value) {
                _amount = double.tryParse(value!) ?? 0.0;
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
    );
  }
}
