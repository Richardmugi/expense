import 'dart:convert';

import 'package:expense/amount_page.dart';

import 'package:expense/setgoal.dart';
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
    _navigateToAmountPage(
        selectedCategory!, expense); // Pass the selected category and expense
  }

  void _navigateToAmountPage(String category, String expense) {
    if (selectedExpense != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AmountPage(category, expense), // Pass both category and expense
        ),
      );
    }
  }

  void _setGoalForExpense(String expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Goal for $expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _showAmountDialog(expense, 'Weekly'),
                child: Text('Set Weekly Goal'),
              ),
              ElevatedButton(
                onPressed: () => _showAmountDialog(expense, 'Monthly'),
                child: Text('Set Monthly Goal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAmountDialog(String expense, String timeFrame) {
    double _goalAmount = 0;
    DateTime _selectedDate = DateTime.now(); // Initialize with the current date

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set $timeFrame Goal for $expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Goal Amount'),
                onChanged: (value) {
                  setState(() {
                    _goalAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 10),
              Text('Select a Date:'),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _saveGoal(expense, timeFrame, _goalAmount, _selectedDate);
                  Navigator.pop(context);
                },
                child: Text('Save Goal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveGoal(String expense, String timeFrame, double goalAmount,
      DateTime selectedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final goal = {
      'expense': expense,
      'timeFrame': timeFrame,
      'goalAmount': goalAmount,
      'selectedDate': selectedDate.toString(),
    };
    List<String> existingGoals = prefs.getStringList('expense_goals') ?? [];
    existingGoals.add(json.encode(goal));
    prefs.setStringList('expense_goals', existingGoals);
  }

  void _deleteCategory(String category) {
    setState(() {
      categories.remove(category);
      selectedCategory = null;
      selectedExpense = null;
    });
    _saveCategories();
  }

  void _deleteExpense(String expense) {
    setState(() {
      categories[selectedCategory!]!.remove(expense);
      selectedExpense = null;
    });
    _saveCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category),
                          ),
                        ],
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedExpense == expense) Icon(Icons.check),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteExpense(expense),
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_money,
                                color: Colors.green), // Add goal icon
                            onPressed: () => _setGoalForExpense(
                                expense), // Call the function to set a goal
                          ),
                        ],
                      ),
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
                builder: (context) => YourGoalsPage(),
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
