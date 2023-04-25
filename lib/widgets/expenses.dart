import "package:expense_tracker/widgets/chart/chart.dart";
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import "package:expense_tracker/models/expense.dart";
import "package:expense_tracker/widgets/new_expense.dart";
import "package:flutter/material.dart";

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense deleted."),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    List<Widget> mainContent = [
      Column(
        children: [
          Image.asset(
            "assets/images/receipt.png",
            width: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            "No expenses found. Start adding some!",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ];

    if (_registeredExpenses.isNotEmpty) {
      mainContent = [
        width > 600
            ? Expanded(child: Chart(expenses: _registeredExpenses))
            : Chart(expenses: _registeredExpenses),
        Expanded(
            child: ExpensesList(
          expenses: _registeredExpenses,
          onRemoveExpense: _removeExpense,
        ))
      ];
    }

    return Scaffold(
      appBar: AppBar(
        // centerTitle: false,
        title: const Text(
          "Flutter Expense Tracker",
        ),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: width < 600
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: mainContent,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: mainContent,
                ),
        ),
      ),
    );
  }
}
