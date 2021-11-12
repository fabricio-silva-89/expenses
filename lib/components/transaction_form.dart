import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  TransactionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
              controller: valueController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Nova Transação'),
                  style: TextButton.styleFrom(
                    primary: Colors.purple,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
