import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double _weeklyGoal = 0;
  double _monthlyGoal = 0;
  double _weeklyTotal = 0;
  double _monthlyTotal = 0;
  String? _selectedBudgetType;
  String? _selectedCurrency = 'UGX';
  DateTime _selectedDate = DateTime.now(); // Default to today's date

  // New variable to store the selected budget type.

  void _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('weekly_goal', _weeklyGoal);
    prefs.setDouble('monthly_goal', _monthlyGoal);
    prefs.setString('selected_budget_type', _selectedBudgetType!);
    prefs.setString('selected_currency', _selectedCurrency!);
    prefs.setString('selected_date', _selectedDate.toString());
  }

  void _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _weeklyGoal = prefs.getDouble('weekly_goal') ?? 0;
      _monthlyGoal = prefs.getDouble('monthly_goal') ?? 0;
      _selectedBudgetType = prefs.getString('selected_budget_type');
      _selectedCurrency = prefs.getString('selected_currency') ?? 'UGX';
      _selectedDate = DateTime.parse(
          prefs.getString('selected_date') ?? DateTime.now().toString());
    });
  }

  void _loadRecordsTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recordStrings = prefs.getStringList('expense_records') ?? [];
    List<Map<String, dynamic>> records = recordStrings.map((record) {
      return Map<String, dynamic>.from(json.decode(record));
    }).toList();

    DateTime now = DateTime.now();
    int currentWeek = now.weekday;
    int currentMonth = now.month;

    double weeklyTotal = 0;
    double monthlyTotal = 0;

    for (var record in records) {
      double amount = record['amount'];
      DateTime recordDate = DateTime.parse(record['date']);
      int recordWeek = recordDate.weekday;
      int recordMonth = recordDate.month;

      // Calculate total amount for weekly budget
      if (_selectedBudgetType == 'Weekly' && currentWeek == recordWeek) {
        weeklyTotal += amount;
      }

      // Calculate total amount for monthly budget
      if (_selectedBudgetType == 'Monthly' && currentMonth == recordMonth) {
        monthlyTotal += amount;
      }
    }

    setState(() {
      _weeklyTotal = weeklyTotal;
      _monthlyTotal = monthlyTotal;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
    _loadRecordsTotal();
  }

  Widget _buildGoalContainer({
    required String title,
    required double goalAmount,
    required double totalAmount,
    required VoidCallback onTap,
    required String currency,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Goal: $currency ${goalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            if (totalAmount > 0) ...[
              SizedBox(height: 10),
              Text(
                'Amount used: $currency ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              child: Text('Set Goal'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSetWeeklyGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Weekly Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
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
                    _weeklyGoal = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                },
                items: <String>[
                  'UGX',
                  'USD',
                  'EUR',
                  'GBP',
                  'JPY'
                ] // Add more currencies if needed
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveGoals();
                _selectedBudgetType = 'Weekly';
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Pick Date'),
            ),
          ],
        );
      },
    );
  }

  void _onSetMonthlyGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Monthly Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
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
                    _monthlyGoal = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                },
                items: <String>[
                  'UGX',
                  'USD',
                  'EUR',
                  'GBP',
                  'JPY'
                ] // Add more currencies if needed
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveGoals();
                _selectedBudgetType = 'Monthly';
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Pick Date'),
            ),
          ],
        );
      },
    );
  }

  String _getBudgetStatus(double goal, double totalExpenses, String currency) {
    double remainingBudget = goal - totalExpenses;
    double percentageUsed = (totalExpenses / goal) * 100;

    if (totalExpenses > goal) {
      return 'You have exceeded your budget by $currency${(totalExpenses - goal).toStringAsFixed(2)}!';
    } else if (percentageUsed >= 80) {
      return 'You are almost completing your budget (Remaining: $currency${remainingBudget.toStringAsFixed(2)})';
    } else {
      return 'You are within your budget (Remaining: $currency${remainingBudget.toStringAsFixed(2)})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Budget Goals'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGoalContainer(
              title: 'Set Weekly Goal:',
              goalAmount: _weeklyGoal,
              totalAmount: _weeklyTotal,
              onTap: _onSetWeeklyGoal,
              currency: _selectedCurrency!,
            ),
            SizedBox(height: 20),
            _buildGoalContainer(
              title: 'Set Monthly Goal:',
              goalAmount: _monthlyGoal,
              totalAmount: _monthlyTotal,
              onTap: _onSetMonthlyGoal,
              currency: _selectedCurrency!,
            ),
            SizedBox(height: 20),
            if (_selectedBudgetType != null && _selectedBudgetType == 'Weekly')
              Text(
                _getBudgetStatus(_weeklyGoal, _weeklyTotal, _selectedCurrency!),
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            if (_selectedBudgetType != null && _selectedBudgetType == 'Monthly')
              Text(
                _getBudgetStatus(
                    _monthlyGoal, _monthlyTotal, _selectedCurrency!),
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
