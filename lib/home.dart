import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> buttons = [
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '(',
    '0',
    ')',
    '/',
    '.',
    'X',
    'x',
    '=',
  ];

  List<String> expression = [];

  void handleButtons(String s) {
    setState(() {
      if (s == '=') {
        String exp = expression.join();
        try {
          double result = evaluate(exp);
          expression = [result.toString()];
        } catch (e) {
          expression = ['Error'];
        }
      } else if (s == 'X') {
        expression.clear();
      } else if (s == 'x') {
        if (expression.isNotEmpty) {
          String last = expression.removeLast();
          if (last.length > 1) {
            expression.add(last.substring(0, last.length - 1));
          }
        }
      } else if (s == '.') {
        if (expression.isEmpty ||
            RegExp(r'[+\-*/()]').hasMatch(expression.last)) {
          expression.add('0.');
        } else if (!expression.last.contains('.')) {
          expression[expression.length - 1] += '.';
        }
      } else if (RegExp(r'[+\-*/()]').hasMatch(s)) {
        expression.add(s);
      } else {
        if (expression.isEmpty ||
            RegExp(r'[+\-*/()]').hasMatch(expression.last)) {
          expression.add(s);
        } else {
          expression[expression.length - 1] += s;
        }
      }
    });
  }

  double evaluate(String exp) {
    while (exp.contains('(')) {
      int open = exp.lastIndexOf('(');
      int close = exp.indexOf(')', open);
      String subExpression = exp.substring(open + 1, close);
      double subResult = evaluate(subExpression);
      exp = exp.replaceRange(open, close + 1, subResult.toString());
    }
    return _evaluateSimple(exp);
  }

  double _evaluateSimple(String exp) {
    List<String> tokens = [];
    String number = '';
    for (int i = 0; i < exp.length; i++) {
      if ('0123456789.'.contains(exp[i])) {
        number += exp[i];
      } else {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }
        tokens.add(exp[i]);
      }
    }
    if (number.isNotEmpty) {
      tokens.add(number);
    }

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double num1 = double.parse(tokens[i - 1]);
        double num2 = double.parse(tokens[i + 1]);
        double result = tokens[i] == '*' ? num1 * num2 : num1 / num2;
        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i--;
      }
    }

    double ans = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);
      if (op == '+') {
        ans += num;
      } else if (op == '-') {
        ans -= num;
      }
    }
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text("Calculator", style: TextStyle(color: Colors.grey[300])),
          // leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        expression.join(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.grey[800],
                      ),
                      onPressed: () {
                        handleButtons(buttons[index]);
                      },
                      child: Text(
                        buttons[index],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
