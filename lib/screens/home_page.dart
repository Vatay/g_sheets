import 'dart:async';

import 'package:balance/components/event_button.dart';
import 'package:balance/components/loading_circle.dart';
import 'package:balance/components/top_card.dart';
import 'package:balance/components/transaction.dart';
import 'package:balance/gsheet_api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textControllerTitle = TextEditingController();
  final _textControllerAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool timerHasStarted = false;

  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (timerHasStarted == false && GoogleSheetsApi.loading == true) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            TopCard(
              balance: GoogleSheetsApi.loading
                  ? '-'
                  : GoogleSheetsApi.calulateMoney().moneyNow.toString(),
              income: GoogleSheetsApi.loading
                  ? '-'
                  : GoogleSheetsApi.calulateMoney().income.toString(),
              expense: GoogleSheetsApi.loading
                  ? '-'
                  : GoogleSheetsApi.calulateMoney().expense.toString(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EventButton(
                    icon: Icons.add,
                    color: Colors.green,
                    onTab: () {
                      _newTransaction(true);
                    },
                  ),
                  SizedBox(width: 30),
                  EventButton(
                    icon: Icons.remove,
                    color: Colors.red,
                    onTab: () {
                      _newTransaction(false);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GoogleSheetsApi.loading
                  ? LoadingCircle()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 20,
                        bottom: 10,
                      ),
                      itemCount: GoogleSheetsApi.currentTransaction.length,
                      itemBuilder: (context, index) {
                        return Transaction(
                          transactionName:
                              GoogleSheetsApi.currentTransaction[index][0],
                          money: GoogleSheetsApi.currentTransaction[index][1],
                          type: GoogleSheetsApi.currentTransaction[index][2],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _newTransaction(bool type) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Додати' + (type ? 'дохід' : 'витрати')),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _textControllerTitle,
                    decoration: InputDecoration(
                      hintText: 'Назва*',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validator,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _textControllerAmount,
                    decoration: InputDecoration(
                      hintText: 'Сума грн.*',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validator,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[600]),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Відміна'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[800]),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _enterTransaction(type);
                          _textControllerAmount.clear();
                          _textControllerTitle.clear();
                          setState(() {});
                          Navigator.pop(context);
                        } else {}
                      },
                      child: Text('Додати'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _enterTransaction(bool type) {
    GoogleSheetsApi.insert(
      name: _textControllerTitle.text,
      amount: _textControllerAmount.text,
      type: type,
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле не повинно бути пустим';
    } else {
      return null;
    }
  }
}
