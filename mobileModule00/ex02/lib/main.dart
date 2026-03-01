import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobileModule00',
      home: const CalculatorPage(),
      theme: ThemeData(
        useMaterial3: false,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = '0';
  String result = '0';

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF607d8b),
        title: const Text(
          'Calculator',
          style: TextStyle(
            color: Color(0xFFffffff),
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),)
        ),
      body: Padding(
        padding: EdgeInsetsGeometry.only(bottom: bottomInset),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: CalculatorDisplay(
                expression: expression,
                result: result,
              ),
            ),
            Expanded(
              flex: 5,
              child: CalculatorButtons(expression: expression)
            )
          ],
        )
      ),
    );
  }
}

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;

  const CalculatorDisplay({super.key, required this.expression, required this.result});

  Widget _displayText(String text) {
  return Padding(
    padding: const EdgeInsetsGeometry.directional(top: 5, bottom: 0, start: 10, end: 10),
    child: SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF607d8b),
          fontSize: 25,
        )
      ),
    )
  );
}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF37474f),
      width: double.infinity,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _displayText(expression),
            _displayText(result),
          ],
        ),
      ),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final String expression;
  static const List< List<String> > _buttonKeys = [
    ['7', '8', '9', 'C', 'AC'],
    ['4', '5', '6', '+', '-'],
    ['1', '2', '3', '×', '/'],
    ['0', '.', '00', '=', ''],
  ];

  const CalculatorButtons({super.key, required this.expression});

  bool _isNumber(String text) {
    return double.tryParse(text) != null || text == '.';
  }

  bool _isOperator(String text) {
    return ['+','×', '-', '/', '='].contains(text);
  }

  Widget _calculatorButton(String text) {
    if (text == '') {
      return Expanded(
        flex: 1,
        child: Container(
        color: Color(0xFF607d8b),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          print('button pressed :$text');
          },
        child: Ink(
          color: Color(0xFF607d8b),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _isNumber(text)
                  ? Color(0xFF37474f)
                  : _isOperator(text)
                  ? Color(0xFFffffff)
                  : Color(0xFFb22223)
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget _buttonsInRow(List<String> row) {
    return Expanded(
      flex: 1,
      child: Row(
        children: row.map((key) => _calculatorButton(key)).toList()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: _buttonKeys.map((row) => _buttonsInRow(row)).toList()
      )
    );
  }
}