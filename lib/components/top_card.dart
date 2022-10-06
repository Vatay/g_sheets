import 'package:balance/components/mini_info.dart';
import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;
  const TopCard(
      {super.key,
      required this.balance,
      required this.income,
      required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Баланс:',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
              ),
            ),
            Text(
              '\₴ $balance',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MiniInfo(
                  income: income,
                  title: 'Дохід',
                  color: Colors.green,
                  icon: Icons.arrow_upward,
                ),
                MiniInfo(
                  income: expense,
                  title: 'Витрати',
                  color: Colors.red,
                  icon: Icons.arrow_downward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
