import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:decimal/decimal.dart';

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
  final controller = CalculatorController();

  void onPressHandler(String input) {
    setState(() {
      if (input == '=') {
        controller.calculate();
      }
      else if (input == 'AC') {
        controller.fullClean();
      }
      else if (input == 'C') {
        controller.clearLastValue();
      }
      else {
        controller.addValue(input);
      }
    });
  }

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
                expression: controller.expression,
                result: controller.result,
              ),
            ),
            Expanded(
              flex: 5,
              child: CalculatorButtons(onPressHandler: onPressHandler,),
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
            _displayText(expression.isEmpty ? '0' : expression),
            _displayText(result.isEmpty ? '0' : result),
          ],
        ),
      ),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final Function onPressHandler;
  static const List< List<String> > _buttonKeys = [
    ['7', '8', '9', 'C', 'AC'],
    ['4', '5', '6', '+', '-'],
    ['1', '2', '3', '×', '/'],
    ['0', '.', '00', '=', ''],
  ];

  const CalculatorButtons({super.key, required this.onPressHandler});

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
        onTap: () => onPressHandler(text),
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

class CalculatorController {
  String                    expression = '';
  String                    result = '';
  bool                      isSpacial = false;
  static const List<String> operators = ['+', '-', '×', '/'];
  static const List<String> digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '.', ','];
  static const List<String> nanValue = ['Undefined', 'Indeterminate'];

  void addValue(String value) {
    String number = _getLastNumber(expression);

    if (['', '-'].contains(number) && value == '.'){
      expression += '0.';
    }
    else if (number == '0' && digits.contains(value) && !['0', '.', '00'].contains(value)) {
      expression = expression.substring(0, expression.length - 1) + value;
    }
    else if (['0', '00'].contains(value) && expression.isNotEmpty && ['', '-'].contains(number)
    || expression.isEmpty && ['0', '00'].contains(value)) {
      expression += '0';
    }
    else if (operators.contains(value) && expression.isEmpty && !nanValue.contains(result) && result.isNotEmpty) {
      expression = result + value;
    }
    else if ((number.isEmpty && ['0', '00', '+', '/', '×'].contains(value))
      || (number.contains('.') && value == '.')
      || (['0', '00'].contains(value) && (number == '0' || number == '-0'))
      || (operators.contains(value) && (expression == '-' || expression.isNotEmpty && operators.contains(expression[expression.length - 1]) && operators.contains(expression[expression.length - 2])))) {}
    else if (operators.contains(value)) {
      expression += value;
    }
    else {
      value = _getLastNumber(expression) + value;
      value = _convertToCommaNum(value);
      expression = expression.substring(0, expression.length - number.length) + value;
    }
    return;
  }

  void calculate(){
    final List<String>? input;
    String              number;

    if (expression.isEmpty || operators.contains(expression[expression.length - 1])) { return; }
    input = _pasreNumber(expression);
    if (isSpacial == false) {
      number = _calculateExpression(input);
    }
    else {
      number = _calculateSpacial(input.join(''));
    }
    if (_isContainOnlyNumber(number)) {
      number = _convertToCommaNum(number);
    }
    result = _trimAfterPrecision(number);
    expression = '';
  }
  String _calculateExpression(List<String> listExpression) {
    int           index = 0;
    bool          isFirst = true;
    List<dynamic> listExp = [...listExpression];
    List<dynamic> zero = ['0', 0, 0.toDecimal()];
    
    if (listExpression.length == 1) { return listExpression[0]; }
    while (index < listExp.length && listExp.length > 1){
      if (isFirst == true && ['*', "/"].contains(listExp[index])) {
        if (listExp[index] == '/' && zero.contains(listExp[index + 1])) {
          return zero.contains(listExp[index - 1]) ? 'Indeterminate' : 'Undefined';
        }
        listExp[index - 1] = _calculateDecimal(listExp[index - 1], listExp[index + 1], listExp[index]);
        listExp.removeRange(index, index + 2);
        index--;
      }
      else if (isFirst == false && ['+', '-'].contains(listExp[index])) {
        listExp[index - 1] = _calculateDecimal(listExp[index - 1], listExp[index + 1], listExp[index]);
        listExp.removeRange(index, index + 2);
        index--;
      }
      else {
        index++;
        if (isFirst == true && index >= listExp.length) {
          index = 0;
          isFirst = false;
        }
      }
    }
    return listExp[0].toString();
    
  }

  Decimal? _calculateDecimal(dynamic pos1, dynamic pos2, String operate) {
    Decimal num1 = pos1.runtimeType == String ? _convertToDecimal(pos1) : pos1;
    Decimal num2 = pos2.runtimeType == String ? _convertToDecimal(pos2) : pos2;
    switch (operate) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        var result = num1 / num2;
        return result.toDecimal(
            scaleOnInfinitePrecision: 16,
          );
    }
    return null;
  }

  Decimal _convertToDecimal(String number) {
    if (number.contains('.')) {
      return Decimal.parse(number);
    }
    return Decimal.fromBigInt(BigInt.parse(number));
  }

  String _calculateSpacial(String input){
    ExpressionParser  p = GrammarParser();
    Expression        exp;
    var               evaluator =  RealEvaluator();

    exp = p.parse(input);
    num eval = evaluator.evaluate(exp);
    return eval.toString();
  }

  void clearLastValue() {
    String  number = '';
    int     length;

    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
      number = _getLastNumber(expression);
      length = number.length;
      number = _convertToCommaNum(number);
      expression = expression.substring(0, expression.length - length) + number;
    }
    return;
  }

  void fullClean() {
    if (expression == '-0./-0.--' && result == 'Indeterminate') {
      isSpacial = !isSpacial;
    }
    expression = '';
    result = '';
    return;
  }

  String _convertToCommaNum(String number) {
    String        result = '';
    int           count = 0;
    List<String>? splitedNum;

    splitedNum = number.split('.');
    if (splitedNum.isEmpty) { return number; }
    for (int i = splitedNum[0].length - 1; i >= 0; --i) {
      if ([',', '-'].contains(splitedNum[0][i])) { continue;}
      if (count == 3) {
          result = ',$result';
        count = 0;
      }
      result = splitedNum[0][i] + result;
      count++;
    }
    result = number.isNotEmpty && number[0] == '-' ? '-$result' : result;
    return splitedNum.length == 2 ? '$result.${splitedNum[1]}' : result;
  }

  String _getLastNumber(String expression) {
    int     index = expression.length - 1;
    String  number = '';

    while (index >= 0 && digits.contains(expression[index])
      || index == 0 && expression[index] == '-'
      || index > 0 && expression[index] == '-' && operators.contains(expression[index - 1])) {
      number = expression[index] + number;
      index--;
    }
    return number;
  }

  String _trimAfterPrecision(String number) {
    int index = number.length - 1;

    if (number == 'Infinity') { return 'Undefined'; }
    if (number == 'NaN') { return 'Indeterminate'; }
    while (index >= 0 && number[index] == '0') { --index; }
    if (number.contains('.') && index != number.length - 1) {
      return number.substring(0, index);
    }  
    return number;
  }

  List<String> _pasreNumber(String number) {
    List<String>  listExp = [];
    String        tmpNumber = '';

    for (int i = 0; i < number.length; ++i) {
      if (i != 0 && operators.contains(number[i]) && digits.contains(number[i - 1])) {
        _addNumbertoExpList(listExp, tmpNumber);
        listExp.add(number[i] == '×' ? '*' : number[i]);
        tmpNumber = '';
      }
      else {
        if (number[i] == '×') {
          tmpNumber += '*';
        }
        else if (number[i] != ',') {
          tmpNumber += number[i];
        }
      }
    }
    _addNumbertoExpList(listExp, tmpNumber);
    return listExp;
  }

  bool _isContainOnlyNumber(String number) {
    int index = 0;

    if (number.isEmpty) { return false; }
    if (number[index] == '-') {index++;}
    while (index < number.length) {
      if (!digits.contains(number[index++])) {
        return false;
      }
    }
    return true;
  }

  void _addNumbertoExpList(List<String> listExp, String number) {
    if (number[number.length - 1] == '.') {
      number = number.substring(0, number.length - 1);
    }
    number = number == '-0' ? '0' : number;
    listExp.add(number);
    return;
  }

}