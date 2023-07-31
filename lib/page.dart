import 'package:expense/models/transaction.dart';
import 'package:expense/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  void _deleteTransaction(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                _userTransactions.removeWhere((tx) => tx.id == id);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  double get _totalAmount {
    return _userTransactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            'Daily Expenses',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                color: Colors.purple,
                child: Card(
                  child: Center(
                    child: Text(
                      'CHART',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              TransactionList(_userTransactions, _deleteTransaction),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Total Number of Transactions: ${_userTransactions.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Total Amount: \$${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
