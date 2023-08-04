import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Map<String, dynamic>> _expenseRecords = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recordStrings = prefs.getStringList('expense_records') ?? [];
    List<Map<String, dynamic>> records = recordStrings.map((record) {
      return Map<String, dynamic>.from(json.decode(record));
    }).toList();
    setState(() {
      _expenseRecords = records;
    });
  }

  double _calculateTotalExpenses() {
    return _expenseRecords.length.toDouble();
  }

  double _calculateTotalAmount() {
    double totalAmount = 0;
    for (var record in _expenseRecords) {
      totalAmount += record['amount'];
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = _calculateTotalExpenses();
    double totalAmount = _calculateTotalAmount();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Records '),
        backgroundColor: Colors.purple,
      ),
      body: _expenseRecords.isNotEmpty
          ? ListView(
              children: [
                ...List.generate(_expenseRecords.length, (index) {
                  final expenseRecord = _expenseRecords[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Expense: ${expenseRecord['expense']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${expenseRecord['quantity']}'),
                          Text('Amount: \$${expenseRecord['amount']}'),
                          Text('Date: ${expenseRecord['date']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(index);
                        },
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Expenses: $totalExpenses',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text('No expense records found.'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/third');
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Do you want to delete this expense record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteRecord(index);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRecord(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _expenseRecords.removeAt(index);
    });
    List<String> recordStrings = _expenseRecords.map((record) {
      return json.encode(record);
    }).toList();
    prefs.setStringList('expense_records', recordStrings);
  }
}
