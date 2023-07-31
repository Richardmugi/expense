import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseGoalPage extends StatefulWidget {
  @override
  _ExpenseGoalPageState createState() => _ExpenseGoalPageState();
}

class _ExpenseGoalPageState extends State<ExpenseGoalPage> {
  double _weeklyExpenseGoal = 0.0;
  final _formKey = GlobalKey<FormState>();

  void _saveExpenseGoal() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Save the _weeklyExpenseGoal to your desired storage (e.g., SharedPreferences, database).
      Navigator.pop(
          context); // Navigate back to the previous screen after saving.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Weekly Expense Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                decoration:
                    InputDecoration(labelText: 'Weekly Expense Goal (\$)'),
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
                  _weeklyExpenseGoal = double.tryParse(value!) ?? 0.0;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveExpenseGoal,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
