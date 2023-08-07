import 'package:expense/amount_page.dart';

import 'package:expense/goals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class ExpenseTrackingPage extends StatefulWidget {
  @override
  _ExpenseTrackingPageState createState() => _ExpenseTrackingPageState();
}

class _ExpenseTrackingPageState extends State<ExpenseTrackingPage> {
  Map<String, List<String>> categories = {
    'Food': ['Eggs', 'Bread', 'Milk', 'Vegetables', 'Fruits'],
    'Shoes': ['Sneakers', 'Sandals', 'Boots'],
    'Rent': ['Monthly Rent', 'Utilities'],
    // Add more categories and items as needed.
  };

  TextEditingController _newCategoryController = TextEditingController();
  TextEditingController _newExpenseController = TextEditingController();

  String? selectedCategory;
  String? selectedExpense;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  void dispose() {
    _saveCategories();
    super.dispose();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCategories();
  }

  void _loadCategories() {
    final savedCategories = _prefs!.getStringList('categories');
    if (savedCategories != null) {
      setState(() {
        categories.clear();
        for (final savedCategory in savedCategories) {
          categories[savedCategory] =
              _prefs!.getStringList(savedCategory) ?? [];
        }
      });
    }
  }

  void _saveCategories() {
    final categoryKeys = categories.keys.toList();
    _prefs!.setStringList('categories', categoryKeys);
    for (final categoryKey in categoryKeys) {
      _prefs!.setStringList(categoryKey, categories[categoryKey]!);
    }
  }

  void _addNewCategory() {
    String newCategory = _newCategoryController.text.trim();
    if (newCategory.isNotEmpty) {
      setState(() {
        categories[newCategory] = [];
      });
      _newCategoryController.clear();
      _saveCategories(); // Save updated categories to shared preferences
    }
  }

  void _addNewExpense() {
    String newExpense = _newExpenseController.text.trim();
    if (selectedCategory != null && newExpense.isNotEmpty) {
      setState(() {
        categories[selectedCategory!]!.add(newExpense);
      });
      _newExpenseController.clear();
      _saveCategories(); // Save updated categories to shared preferences
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      selectedExpense =
          null; // Reset selectedExpense when a new category is chosen.
    });
  }

  void _onExpenseSelected(String expense) {
    setState(() {
      selectedExpense = expense;
    });
    _navigateToAmountPage();
  }

  void _navigateToAmountPage() {
    if (selectedExpense != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmountPage(selectedExpense!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracking'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add a New Category:'),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCategoryController,
                    decoration: InputDecoration(
                      hintText: 'Category name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNewCategory,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Add new expense within selected category section
            if (selectedCategory != null) ...[
              Text('Add a New Expense:'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newExpenseController,
                      decoration: InputDecoration(
                        hintText: 'Expense name',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addNewExpense,
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
            Text(
              'Select a Category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.keys.length,
                itemBuilder: (context, index) {
                  final category = categories.keys.toList()[index];
                  return GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            if (selectedCategory != null) ...[
              Text(
                'Select an Expense:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: categories[selectedCategory!]!.length,
                  itemBuilder: (context, index) {
                    final expense = categories[selectedCategory!]![index];
                    return ListTile(
                      onTap: () => _onExpenseSelected(expense),
                      title: Text(expense),
                      trailing:
                          selectedExpense == expense ? Icon(Icons.check) : null,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set the current index for the ExpenseTrackingPage
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Set a goal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navigate to the BudgetPage (set a goal)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BudgetPage(),
              ),
            );
          } else if (index == 2) {
            // Navigate to the RecordsPage
            Navigator.pushNamed(
              context,
              '/fourth',
            );
          }
        },
      ),
    );
  }
}
