// ignore_for_file: cascade_invocations

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaskedTextController Tests', () {
    test('12345678901 with mask 000.000.000-00 results 123.456.789-01', () {
      final cpfController = MaskedTextController(
        text: '12345678901',
        mask: '000.000.000-00',
      );

      expect(cpfController.text, '123.456.789-01');
    });

    test(
        // ignore: lines_longer_than_80_chars
        '12345678901 with mask 000.000.000-00 and changed results 123.456.789.01',
        () {
      final cpfController = MaskedTextController(
        text: '12345678901',
        mask: '000.000.000-00',
      );

      expect(cpfController.text, '123.456.789-01');

      cpfController.updateMask('000.000.0000-0', shouldUpdateValue: true);

      expect(cpfController.text, '123.456.7890-1');
    });

    test('abc123 with mask AAA results abc', () {
      final controller = MaskedTextController(text: 'abc123', mask: 'AAA');

      expect(controller.text, 'abc');
    });

    test('update text to 123456 and mask 000-000 results on 123-456', () {
      final controller = MaskedTextController(text: '', mask: '000-000');
      controller.updateText('123456');

      expect(controller.text, '123-456');
    });

    test('* must accept all characters', () {
      final controller = MaskedTextController(text: 'a0&#', mask: '****');

      expect(controller.text, 'a0&#');
    });

    test('@ must accept only letters and numbers', () {
      final controller = MaskedTextController(text: 'a0&#', mask: '@@@');

      expect(controller.text, 'a0');
    });

    test('remove * translator must keep * in the mask', () {
      final translator = MaskedTextController.defaultTranslator;
      translator.remove('*');
      final controller = MaskedTextController(
        mask: '0000 **** **** 0000',
        translator: translator,
      );
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });

    test('remove * translator must keep * in the mask', () {
      final translator = MaskedTextController.defaultTranslator;
      translator.remove('*');
      final controller = MaskedTextController(
        mask: '0000 **** **** 0000',
        translator: translator,
      );
      controller.updateText('12345678');

      expect(controller.text, '1234 **** **** 5678');
    });

    test('check cursor position after edit in specifc possition', () async {
      final cpfController = MaskedTextController(
        text: '12345678901',
        mask: '000.000.000-00',
      );

      expect(cpfController.text, '123.456.789-01');
      cpfController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 1),
      );

      cpfController.text = '19345678901';
      await Future.delayed(Duration.zero);
      expect(cpfController.selection.baseOffset, 2);
    });

    test('always force cursor to end of sentence', () {
      final cpfController = MaskedTextController(
        text: '12345678901',
        mask: '000.000.000-00',
        cursorBehavior: CursorBehavior.end,
      );

      expect(cpfController.text, '123.456.789-01');
      cpfController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 1),
      );
      expect(cpfController.selection.baseOffset, '123.456.789-01'.length);
    });
  });

  group('MoneyMaskedTextController Tests', () {
    test('0.01 results 0,01', () {
      final controller = MoneyMaskedTextController();
      controller.updateValue(0.01);

      expect(controller.text, '0,01');
    });

    test('1234.56 results 1.234,56', () {
      final controller = MoneyMaskedTextController();
      controller.updateValue(1234.56);

      expect(controller.text, '1.234,56');
    });

    test('123123.0 results 123.123,00', () {
      final controller = MoneyMaskedTextController();
      controller.updateValue(123123);

      expect(controller.text, '123.123,00');
    });

    test('1231231.0 results 1.231.231,00', () {
      final controller = MoneyMaskedTextController();
      controller.updateValue(1231231);

      expect(controller.text, '1.231.231,00');
    });

    test('custom decimal and thousando separator results in 1,234.00', () {
      final controller = MoneyMaskedTextController(
        decimalSeparator: '.',
        thousandSeparator: ',',
      );
      controller.updateValue(1234);

      expect(controller.text, '1,234.00');
    });

    test('number value for 0,10 must be 0.1', () {
      final controller = MoneyMaskedTextController(
        decimalSeparator: '.',
        thousandSeparator: ',',
      );
      controller.updateValue(0.1);

      expect(controller.numberValue, 0.1);
    });

    test('rightSymbol " US\$" and value 99.99 must resut in 99,99 US\$', () {
      final controller = MoneyMaskedTextController(rightSymbol: ' US\$');
      controller.updateValue(99.99);

      expect(controller.text, '99,99 US\$');
    });

    test('rightSymbol with number must raises an error.', () {
      void executor() {
        MoneyMaskedTextController(rightSymbol: ' U4');
      }

      expect(executor, throwsArgumentError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'rightSymbol " US\$" with 12345678901234 must results in 123.456.789.012,34 US\$',
        () {
      final controller = MoneyMaskedTextController(rightSymbol: ' US\$');
      controller.updateValue(123456789012.34);

      expect(controller.text, '123.456.789.012,34 US\$');
    });

    test('leftSymbol "R\$ " and value 123.45 results in "R\$ 123,45"', () {
      final controller = MoneyMaskedTextController(leftSymbol: 'R\$ ');
      controller.updateValue(123.45);

      expect(controller.text, 'R\$ 123,45');
    });

    test(
        'rightSymbol and leftSymbol  " R\$" and  rightSymbol "+" with value 99.99 unmasked must resut in 99,99',
        () {
      final controller =
          MoneyMaskedTextController(rightSymbol: ' +', leftSymbol: r'R$');
      controller.updateValue(99.99);
      expect(controller.unmasked, '99,99');
    });

    test('precision 3 and value 123.45 results in "123,450"', () {
      final controller = MoneyMaskedTextController(precision: 3);
      controller.updateValue(123.45);

      expect(controller.text, '123,450');
    });

    test('null initial value must result in ""', () {
      final controller = MoneyMaskedTextController(initialValue: null);

      expect(controller.text, '');
    });

    test('number value for null initial value must be 0.0', () {
      final controller = MoneyMaskedTextController(initialValue: null);

      expect(controller.numberValue, 0.0);
    });

    test('leftSymbol "R\$ " and null initial value must result in ""', () {
      final controller = MoneyMaskedTextController(
        leftSymbol: 'R\$ ',
        initialValue: null,
      );

      expect(controller.text, '');
    });

    test(
        // ignore: lines_longer_than_80_chars
        'number value for leftSymbol "R\$ " and null initial value must result in 0.0',
        () {
      final controller = MoneyMaskedTextController(
        leftSymbol: 'R\$ ',
        initialValue: null,
      );

      expect(controller.numberValue, 0.0);
    });

    test('rightSymbol " US\$" and null initial value must resut in ""', () {
      final controller = MoneyMaskedTextController(
        rightSymbol: ' US\$',
        initialValue: null,
      );

      expect(controller.text, '');
    });

    test(
        // ignore: lines_longer_than_80_chars
        'number value for rightSymbol " US\$" and null initial value must resut in 0.0\$',
        () {
      final controller = MoneyMaskedTextController(
        rightSymbol: ' US\$',
        initialValue: null,
      );

      expect(controller.numberValue, 0.0);
    });
  });
}
