import 'package:crossnumber/src/base/base_domains.dart';
import 'package:crossnumber/src/base/base_puzzle.dart';
import 'package:crossnumber/src/base/base_solver.dart';
import 'package:crossnumber/src/base/digits.dart';
import 'package:crossnumber/src/models/entry.dart';
import 'package:crossnumber/src/models/grid.dart';
import 'package:test/test.dart';

import '../puzzles/base_squares.dart';

void main() {
  group('digits', () {
    test('symbols round-trip', () {
      expect(digitSymbol(0), '0');
      expect(digitSymbol(9), '9');
      expect(digitSymbol(10), 'A');
      expect(digitSymbol(16), 'G');
      expect(digitValue('a'), 10);
      expect(digitValue('G'), 16);
    });

    test('digitsOf and valueOf', () {
      expect(digitsOf(256, 17, 2)!.toString(), 'F1');
      expect(valueOf(DigitString([15, 1]), 17), 256);

      expect(digitsOf(25, 10, 2)!.toString(), '25');
      expect(digitsOf(4, 2, 2), isNull);
      expect(digitsOf(25, 5, 3)!.toString(), '100');
    });
  });

  group('always-square detection', () {
    test('known always-square strings', () {
      expect(isAlwaysSquare(DigitString([1, 2, 1])), isTrue);
      expect(isAlwaysSquare(DigitString([1, 0, 0, 0, 0])), isTrue);
      expect(isAlwaysSquare(DigitString([9, 0, 0])), isTrue);
      expect(isAlwaysSquare(DigitString([1, 0, 4, 0, 4])), isTrue);
    });

    test('non-always-square strings', () {
      expect(isAlwaysSquare(DigitString([1, 2, 3])), isFalse);
      expect(isAlwaysSquare(DigitString([1, 0, 2])), isFalse);
      expect(isAlwaysSquare(DigitString([8, 3, 1])), isFalse);
    });
  });

  group('candidate generation', () {
    test('fixed base 5, length 3', () {
      final options = candidatesFor(3, const BaseClue(5));
      expect(options, isNotEmpty);
      expect(options.every((option) => option.base == 5), isTrue);
      expect(
        options.map((option) => option.value).toSet(),
        {25, 36, 49, 64, 81, 100, 121},
      );
    });

    test('fixed value 25, length 2', () {
      final options = candidatesFor(2, const ValueClue(25));
      expect(options.every((option) => option.value == 25), isTrue);
      expect(options.map((option) => option.base).toSet(), {6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17});
    });
  });

  group('Base Squares', () {
    test('solves and reports the ambiguous always-square entry', () {
      final puzzle = baseSquares();
      final result = BaseSolver(puzzle).solveAll();

      expect(result.solutions, hasLength(9));
      expect(result.ambiguousAlwaysSquareValues(), {
        'D29': {64, 100, 144, 225, 256},
      });
    });

    test('every solution satisfies the clues and global rules', () {
      final puzzle = baseSquares();
      final result = BaseSolver(puzzle).solveAll();
      final geometry = Grid.fromString(puzzle.gridString.trimRight());

      for (final solution in result.solutions) {
        final valueCounts = <int, int>{};
        final baseCounts = <int, int>{};
        final usedStrings = <String>{};

        for (final entry in geometry.entries.values) {
          final option = solution.entries[entry.id]!;

          expect(option.base, inInclusiveRange(2, 17));
          expect(squares, contains(option.value));
          expect(option.digits.digits.first, isNot(0));
          expect(option.digits.digits.every((digit) => digit < option.base), isTrue);
          expect(valueOf(option.digits, option.base), option.value);

          for (var i = 0; i < entry.length; i++) {
            final row = entry.orientation == EntryOrientation.across ? entry.row : entry.row + i;
            final col = entry.orientation == EntryOrientation.across ? entry.col + i : entry.col;
            expect(solution.grid[row][col], option.digits.digits[i], reason: '${entry.id} at $row,$col');
          }

          valueCounts[option.value] = (valueCounts[option.value] ?? 0) + 1;
          baseCounts[option.base] = (baseCounts[option.base] ?? 0) + 1;
          expect(usedStrings.add(option.digits.toString()), isTrue, reason: 'duplicate entry ${option.digits}');
        }

        for (var base = 2; base <= 8; base++) {
          expect(baseCounts[base], 3, reason: 'base $base count');
        }
        for (var base = 9; base <= 17; base++) {
          expect(baseCounts[base], inInclusiveRange(1, 3), reason: 'base $base count');
        }

        for (final value in squares) {
          expect(valueCounts[value], inInclusiveRange(1, 2), reason: 'square $value count');
        }

        final zeroCount = solution.grid.expand((row) => row).where((digit) => digit == 0).length;
        expect(zeroCount, 16);

        final presentDigits = solution.grid.expand((row) => row).toSet();
        for (var digit = 1; digit <= 16; digit++) {
          expect(presentDigits, contains(digit), reason: 'digit $digit missing');
        }

        for (final entry in puzzle.clues.entries) {
          final option = solution.entries[entry.key]!;
          switch (entry.value) {
            case ValueClue(value: final value):
              expect(option.value, value);
            case BaseClue(base: final base):
              expect(option.base, base);
            case AlwaysSquareClue():
              expect(isAlwaysSquare(option.digits), isTrue);
            case MiddleDigitSquareClue():
              expect(const {0, 1, 4, 9}.contains(option.digits.digits[option.digits.length ~/ 2]), isTrue);
            case NotValueClue(value: final value):
              expect(option.value, isNot(value));
            case NotBaseClue(base: final base):
              expect(option.base, isNot(base));
            case UncluedClue():
              break;
          }
        }
      }
    });
  });
}
