import 'package:expense/category.dart';

import 'package:expense/goals.dart';
import 'package:expense/login.dart';
import 'package:expense/records.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

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
        '/third': (context) => ExpenseTrackingPage(),
        '/fourth': (context) => RecordsPage(),
        'fifth': (context) => BudgetPage(),
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
            Image.asset('assets/imageexpense.png', width: 200, height: 200),
            SizedBox(height: 20),
            Text(
              "Welcome to our cutting-edge Expense App Tracker, the ultimate tool to supercharge your financial management! Say goodbye to the hassles of tracking expenses manually and embrace the future of effortless finance control",
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
