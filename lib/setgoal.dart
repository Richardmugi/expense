import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourGoalsPage extends StatefulWidget {
  @override
  _YourGoalsPageState createState() => _YourGoalsPageState();
}

class _YourGoalsPageState extends State<YourGoalsPage> {
  List<Map<String, dynamic>> _expenseGoals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalStrings = prefs.getStringList('expense_goals') ?? [];
    List<Map<String, dynamic>> goals = goalStrings.map((goal) {
      return Map<String, dynamic>.from(json.decode(goal));
    }).toList();

    setState(() {
      _expenseGoals = goals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Goals'),
        backgroundColor: Colors.purple,
      ),
      body: _expenseGoals.isNotEmpty
          ? ListView.builder(
              itemCount: _expenseGoals.length,
              itemBuilder: (context, index) {
                final goal = _expenseGoals[index];
                final selectedDate = goal['selectedDate'];
                final selectedDateText = selectedDate != null
                    ? DateFormat.yMMMMd().format(DateTime.parse(selectedDate))
                    : 'Not set';

                return ListTile(
                  title: Text('Expense: ${goal['expense']}'),
                  subtitle: Text(
                    'Time Frame: ${goal['timeFrame']}\nGoal Amount: ${goal['goalAmount']}\nSelected Date: $selectedDateText',
                  ),
                );
              },
            )
          : Center(
              child: Text('No goals set.'),
            ),
    );
  }
}
