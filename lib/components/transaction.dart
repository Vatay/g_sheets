import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String type;
  const Transaction({
    required this.transactionName,
    required this.money,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$transactionName'),
          Text(
            (type == 'income' ? '+' : '-') + '$money грн.',
            style: TextStyle(
              color: type == 'income' ? Colors.green[400] : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
