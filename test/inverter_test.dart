import 'package:crossnumber/src/expressions/inverter.dart';
import 'package:crossnumber/src/expressions/parser.dart';
import 'package:crossnumber/src/models/clue.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:test/test.dart';

void main() {
  group('ExpressionInverter', () {
    final clue = Clue('X', []);
    test('should invert a simple addition expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('A1+D1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}-D1)'));
    });
    test('should invert a simple subtraction expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('A1-D1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}+D1)'));
    });
    test('should invert a simple multiplication expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('A1*D1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}/D1)'));
    });
    test('should invert a simple division expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('A1/D1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}*D1)'));
    });
    test('should invert opposite addition expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('D1+A1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}-D1)'));
    });
    test('should invert opposite subtraction expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('D1-A1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(D1-${clue.id})'));
    });
    test('should invert opposite multiplication expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('D1*A1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(${clue.id}/D1)'));
    });
    test('should invert opposite division expression', () {
      final entryA1 = Entry(
          id: 'A1',
          row: 0,
          col: 0,
          length: 2,
          orientation: EntryOrientation.across);
      final expression = Parser('D1/A1').parse();
      final inverter = ExpressionInverter(expression, clue, entryA1);
      final invertedExpression = inverter.invert();
      expect(invertedExpression, isNotNull);
      expect(invertedExpression.toString(), equals('(D1/${clue.id})'));
    });
  });
}
