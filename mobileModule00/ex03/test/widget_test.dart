// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ex03/main.dart';

void main() {
  final controller = CalculatorController();
  group('Invalid expression', () {
    String result = controller.result;
    test('Empty expression should return original result', () {
      controller.expression = '';
      controller.calculate();
      expect(controller.result, result);
    });
    test('Only - operator in expression should return original result', () {
      controller.expression = '-';
      controller.calculate();
      expect(controller.result, result);
    });
    test('Expression end with operator should return original result', () {
      controller.expression = '10+';
      controller.calculate();
      expect(controller.result, result);
    });
  });
  group('Invalie percision input [0.+1.]', () {
    test('Number should return -1 when calculate number invalid precision ', () {
      controller.expression = '-1.';
      controller.calculate();
      expect(controller.result, '-1');
    });
    test('First number should return 1 when calculate first number invalid precision ', () {
      controller.expression = '0.+1';
      controller.calculate();
      expect(controller.result, '1');
    });
    test('Second number should return 1 when calculate second number invalid precision ', () {
      controller.expression = '0+1.';
      controller.calculate();
      expect(controller.result, '1');
    });
    test('Both number should return 1 when calculate both number invalid precision ', () {
      controller.expression = '0+1.';
      controller.calculate();
      expect(controller.result, '1');
    });
    test('Negative number should return 1 when calculate nagative number invalid precision ', () {
      controller.expression = '0+-1.';
      controller.calculate();
      expect(controller.result, '-1');
    });
    test('Both nagative number should return 1 when calculate both nagative number invalid precision ', () {
      controller.expression = '-10+-1.';
      controller.calculate();
      expect(controller.result, '-11');
    });
  });
  group('Calculation', () {
    List<Map<String,String>> testcases1 = [
      {'test' : '1+1', 'result' : '2'},
      {'test' : '5-2', 'result' : '3'},
      {'test' : '4×6', 'result' : '24'},
      {'test' : '8/2', 'result' : '4'},
      {'test' : '7/2', 'result' : '3.5'},
      {'test' : '-5+3', 'result' : '-2'},
      {'test' : '-5×-5', 'result' : '25'},
      {'test' : '0×999', 'result' : '0'},
    ];
    for (int i = 0; i < testcases1.length; ++i) {
      test('Basic arithmetic [${testcases1[i]['test']}]', () {
        controller.expression = testcases1[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases1[i]['result']);
      });
    }

    List<Map<String,String>> testcases2 = [
        {'test' : '1.5+1.5', 'result' : '3'},
        {'test' : '2.5×2', 'result' : '5'},
        {'test' : '1/3', 'result' : '0.3333333333333333'},
        {'test' : '-1.5/2', 'result' : '-0.75'},
        {'test' : '7/2', 'result' : '3.5'},
        {'test' : '0.1+0.2', 'result' : '0.3'},
      ];
    for (int i = 0; i < testcases2.length; ++i) {
    test('Decimal case [${testcases2[i]['test']}]', () {
        controller.expression = testcases2[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases2[i]['result']);
      });
    }

    List<Map<String,String>> testcases3 = [
      {'test' : '5/0', 'result' : 'Undefined'},
      {'test' : '0/0', 'result' : 'Indeterminate'},
    ];
    for (int i = 0; i < testcases3.length; ++i) {
      test('Division by 0 [${testcases3[i]['test']}]', () {
        controller.expression = testcases3[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases3[i]['result']);
      });
    }

    List<Map<String,String>> testcases4 = [
      {'test' : '999,999,999,999,999,999+1', 'result' : '1,000,000,000,000,000,000'},
      {'test' : '123,456,789,012,345,678×9', 'result' : '1,111,111,101,111,111,102'},
    ];
    for (int i = 0; i < testcases4.length; ++i) {
      test('Very Large Numbers [${testcases4[i]['test']}]', () {
        controller.expression = testcases4[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases4[i]['result']);
      });
    }

    List<Map<String,String>> testcases5 = [
      {'test' : '-0', 'result' : '0'},
      {'test' : '5+-3', 'result' : '2'},
      {'test' : '5--3', 'result' : '8'},
      {'test' : '-1,000,000+1', 'result' : '-999,999'},
    ];
    for (int i = 0; i < testcases5.length; ++i) {
    test('Edge case [${testcases5[i]['test']}]', () {
        controller.expression = testcases5[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases5[i]['result']);
      });
    }

    List<Map<String,String>> testcases7 = [
      {'test' : '59-89+-20/6', 'result' : '-33.3333333333333333'},
      {'test' : '5+3-2', 'result' : '6'},
      {'test' : '10-5+2', 'result' : '7'},
      {'test' : '8/2×3', 'result' : '12'},
      {'test' : '4×5/2', 'result' : '10'},
      {'test' : '-5+3×2', 'result' : '1'},
      {'test' : '-5×-3+2', 'result' : '17'},
      {'test' : '10/-2+3', 'result' : '-2'},
      {'test' : '6/-3×-2', 'result' : '4'},
      {'test' : '-10/-2/-5', 'result' : '-1'},
      {'test' : '2+3×4-5', 'result' : '9'},
      {'test' : '10-2×3-4', 'result' : '0'},
      {'test' : '100/10/2+5', 'result' : '10'},
      {'test' : '5×2-8/4+3', 'result' : '11'},
      {'test' : '20/5×2-3+1', 'result' : '6'},
      {'test' : '-2×3+4×-5', 'result' : '-26'},
      {'test' : '10/-2×-3+4', 'result' : '19'},
      {'test' : '50/5/2×-3', 'result' : '-15'},
      {'test' : '-100/10×-2/5', 'result' : '4'},
      {'test' : '1-2-3-4', 'result' : '-8'},
      {'test' : '1.5+2.5×2', 'result' : '6.5'},
      {'test' : '10.0/4×2', 'result' : '5'},
      {'test' : '-1.5/3×6', 'result' : '-3'},
      {'test' : '5.5-1.5×2', 'result' : '2.5'},
      {'test' : '1,200.50+-300.25×2', 'result' : '600'},
      {'test' : '10,000.75/-2×3', 'result' : '-15,001.125'},
      {'test' : '5,500.5-1,200.25/2', 'result' : '4,900.375'},
      {'test' : '-12,345.678×-3+1,000.111', 'result' : '38,037.145'},
      {'test' : '100,000.25/4×-2+3,333.333-1,111.111', 'result' : '-47,777.903'},
      {'test' : '1,234,567.890123+-987,654.321987/3', 'result' : '905,349.782794'},
      {'test' : '-9,999.99×-9/-3', 'result' : '-29,999.97'},
      {'test' : '123,456,789.987654×2-50,000,000.123456', 'result' : '196,913,579.851852'},
      {'test' : '1,000,000.000001/3', 'result' : '333,333.3333336666666666'},
    ];
    for (int i = 0; i < testcases7.length; ++i) {
      test('Mutiple operations [${testcases7[i]['test']}]', () {
        controller.expression = testcases7[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases7[i]['result']);
      });
    }
  });
  group('Division test', () {
    test('division by 0 should return undefined', () {
      controller.expression = '10/0';
      controller.calculate();
      expect(controller.result, 'Undefined');
    });
    test('division by 1 should return 10', () {
      controller.expression = '10/1.';
      controller.calculate();
      expect(controller.result, '10');
    });
    test('division by -1 should return -10', () {
      controller.expression = '10/-1';
      controller.calculate();
      expect(controller.result, '-10');
    });
    test('10 division by 0.2 should return 50', () {
      controller.expression = '10/0.2';
      controller.calculate();
      expect(controller.result, '50');
    });
    test('-1 division by 10 should return -0.1', () {
      controller.expression = '-1/10';
      controller.calculate();
      expect(controller.result, '-0.1');
    });
  });

  test('add value test', () {
    String value;
    controller.fullClean();
    const List<Map<String,String>> t = [
      {'value': '-', 'expression': '-'},
      {'value': '-', 'expression': '-'},
      {'value': '1', 'expression': '-1'},
      {'value': '-', 'expression': '-1-'},
      {'value': '+', 'expression': '-1-'},
      {'value': '×', 'expression': '-1-'},
      {'value': '/', 'expression': '-1-'},
      {'value': '-', 'expression': '-1--'},
      {'value': '.', 'expression': '-1--0.'},
      {'value': '00', 'expression': '-1--0.00'},
      {'value': '1', 'expression': '-1--0.001'},
      {'value': '+', 'expression': '-1--0.001+'},
      {'value': '-', 'expression': '-1--0.001+-'},
      {'value': '-', 'expression': '-1--0.001+-'},
      {'value': '00', 'expression': '-1--0.001+-0'},
      {'value': '00', 'expression': '-1--0.001+-0'},
      {'value': '0', 'expression': '-1--0.001+-0'},
      {'value': '+', 'expression': '-1--0.001+-0+'},
      {'value': '+', 'expression': '-1--0.001+-0+'},
      {'value': '×', 'expression': '-1--0.001+-0+'},
      {'value': '/', 'expression': '-1--0.001+-0+'},
      {'value': '-', 'expression': '-1--0.001+-0+-'},
      {'value': '-', 'expression': '-1--0.001+-0+-'},
      {'value': '/', 'expression': '-1--0.001+-0+-'},
      {'value': '×', 'expression': '-1--0.001+-0+-'},
      {'value': '+', 'expression': '-1--0.001+-0+-'},
      {'value': '1', 'expression': '-1--0.001+-0+-1'},
      {'value': '×', 'expression': '-1--0.001+-0+-1×'},
      {'value': '+', 'expression': '-1--0.001+-0+-1×'},
      {'value': '/', 'expression': '-1--0.001+-0+-1×'},
      {'value': '/', 'expression': '-1--0.001+-0+-1×'},
      {'value': '-', 'expression': '-1--0.001+-0+-1×-'},
      {'value': '1', 'expression': '-1--0.001+-0+-1×-1'},
      {'value': '/', 'expression': '-1--0.001+-0+-1×-1/'},
      {'value': '/', 'expression': '-1--0.001+-0+-1×-1/'},
      {'value': '+', 'expression': '-1--0.001+-0+-1×-1/'},
      {'value': '×', 'expression': '-1--0.001+-0+-1×-1/'},
      {'value': '-', 'expression': '-1--0.001+-0+-1×-1/-'},
      {'value': '.', 'expression': '-1--0.001+-0+-1×-1/-0.'},
    ];
    for (int index = 0; index < t.length; ++index) {
      value = t[index]['value'] ?? '';
      controller.addValue(value);
      expect(controller.expression, t[index]['expression']);

    }
  });

  group('Spcial mode', () {
    List<Map<String,String>> testcases = [
        {'test' : '0.1+0.2', 'result' : '0.30000000000000004'},
        {'test' : '123,456,789,012,345,678×9', 'result' : '1,111,111,101,111,111,200'},
        {'test' : '59-89+-20/6', 'result' : '-33.333333333333336'},
        {'test' : '1,234,567.890123+-987,654.321987/3', 'result' : '905,349.7827939999'},
        {'test' : '1,000,000.000001/3', 'result' : '333,333.33333366667'},
        {'test' : '0/0', 'result' : 'Indeterminate'},
      ];

    test('Switch to spacial mode', () {
      expect(controller.isSpacial, false);
      controller.expression = '0/0';
      controller.calculate();
      expect(controller.result, 'Indeterminate');
      controller.expression = '-0./-0.--';
      controller.fullClean();
      expect(controller.isSpacial, true);
    });

  for (int i = 0; i < testcases.length; ++i) {
    test('Spcial Mode [${testcases[i]['test']}]', () {
        controller.expression = testcases[i]['test']!;
        controller.calculate();
        expect(controller.result, testcases[i]['result']);
      });
    }
    test('Switch to normal mode', () {
      expect(controller.isSpacial, true);
      controller.expression = '-0./-0.--';
      controller.fullClean();
      expect(controller.isSpacial, false);
    });
  });

}
