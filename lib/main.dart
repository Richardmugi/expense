import 'package:expense/login.dart';

import 'package:shared_preferences/shared_preferences.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Set this to false to remove the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeRoute(),
        '/second': (context) => const Login(),
        '/third': (context) => MyHomePage(),
      },
    );
  }
}

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Your Expense App tracker'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to our cutting-edge Expense App Tracker, the ultimate tool to supercharge your financial management! Say goodbye to the hassles of tracking expenses manually and embrace the future of effortless finance control.\n\nWith our user-friendly interface, you can effortlessly log and categorize expenses in real-time, keeping a pulse on your spending habits like never before. Our powerful analytics will empower you with insightful graphs and reports, allowing you to identify trends, optimize your budget, and achieve your financial goals with ease.\n\nWorried about security? Rest assured, your data is encrypted and protected using industry-leading security measures, ensuring your information stays private and secure at all times.\n\nExperience the convenience of receipt scanning, letting our app handle the tedious task of recording expense details. Never miss a deduction or reimbursement again!\n\nIt's time to take charge of your financial future. Download our Expense App Tracker today and witness the transformation in the way you manage your finances. Start your journey to financial freedom now!",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ), // Add some spacing between the text and the button
            ElevatedButton(
              child: const Text('Get Started'),
              onPressed: () {
                if (isLoggedIn) {
                  // User is already logged in, navigate to the final page
                  Navigator.pushNamed(context, '/third');
                } else {
                  // User needs to log in, navigate to the login page
                  Navigator.pushNamed(context, '/second');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(),
      ),
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}*/

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
      // Add the transaction to the global list
    });
  }

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

  void _startAddNewTransactons(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
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
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Daily Expenses',
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransactons(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show a dialog to add a new transaction
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Add Transaction'),
                  content: NewTransaction(_addNewTransaction),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
