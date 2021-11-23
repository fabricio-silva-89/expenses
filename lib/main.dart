import 'dart:math';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';

import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: Colors.amber,
              primary: Colors.purple,
            ),
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [];
  bool showChart = false;

  List<Transaction> get recentTransactions {
    return transactions
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  void addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
  }

  openTransactioFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(onSubmit: addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text(
        'Despesas Pessoais',
      ),
      actions: [
        if (isLandscape)
          IconButton(
            onPressed: () {
              setState(() {
                showChart = !showChart;
              });
            },
            icon: Icon(showChart ? Icons.list : Icons.pie_chart),
          ),
        IconButton(
          onPressed: () => openTransactioFormModal(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    final avalibleHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text('Exibir Gráfico'),
            //       Switch(
            //         value: showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (showChart || !isLandscape)
              SizedBox(
                height: avalibleHeight * (isLandscape ? 0.7 : 0.3),
                child: Chart(recentTransactions: recentTransactions),
              ),
            if (!showChart || !isLandscape)
              SizedBox(
                height: avalibleHeight * 0.7,
                child: TransactionList(
                  transactions: transactions,
                  onRemove: deleteTransaction,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openTransactioFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
