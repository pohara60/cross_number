import '../clue.dart';
import '../set.dart';
import 'package:powers/powers.dart';

import '../variable.dart';

/// A [InstructionPuzzle] clue
class No21Clue extends ExpressionClue {
  late int _cellsTwoDigits;
  No21Clue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      super.valueDesc,
      super.solve,
      int cellsTwoDigits = 1})
      : _cellsTwoDigits = cellsTwoDigits,
        super() {
    // Some cells contain two digits
    // Assume upto two of these per clue
    setDoubleDigits();
  }

  set cellsTwoDigits(int cells) {
    _cellsTwoDigits = cells;
    setDoubleDigits();
  }

  @override
  bool digitsMatch(int value) {
    if (entry != null) return (entry as No21Entry).digitsMatch(value);
    return true;
  }

  @override
  toString() => '${super.toString()}, min=$min, max=$max';

  @override
  String toSummary() {
    var valueStr = values == null ? '{unknown}' : values!.toShortString();
    return '$name, ${valueDesc == null ? "" : "$valueDesc, "}min=$min, max=$max, values=$valueStr';
  }

  setDoubleDigits() {
    max = (10.pow(length! + _cellsTwoDigits) as int) - 1;
  }

  @override
  bool finalise() {
    // Update digits from values
    if (values == null) return false;
    if (entry != null) return (entry as No21Entry).updateDigits(values!);
    return false;
  }
}

class No21Entry extends No21Clue with EntryMixin {
  No21Entry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }

  @override
  bool digitsMatch(int value, [List<List<int>>? digitMatches]) {
    if (value >= 10.pow(digits.length)) {
      return twoDigitsMatch(value, digitMatches);
    }

    var mValue = value;
    if (digitMatches != null) digitMatches.add(<int>[]);
    for (var d = length! - 1; d >= 0; d--) {
      var digit = mValue % 10;
      if (!digits[d].contains(digit)) {
        if (digitMatches != null) digitMatches.removeLast();
        return false;
      }
      if (digitMatches != null) digitMatches.last.insert(0, digit);
      mValue = mValue ~/ 10;
    }
    return true;
  }

  bool twoDigitsMatch(int matchValue, [List<List<int>>? digitMatches]) {
    var strValue = matchValue.toString();
    var anyMatch = false;
    int numDoubleDigits = strValue.length - length!;
    if (numDoubleDigits == 1) {
      for (var dd = length! - 1; dd >= 0; dd--) {
        var match = true;
        var value = matchValue;
        if (digitMatches != null) digitMatches.add(<int>[]);
        for (var d = length! - 1; d >= 0; d--) {
          var divisor = dd == d ? 100 : 10;
          var minDigit = dd == d ? 10 : 0;
          var digit = value % divisor;
          if (digit < minDigit || !digits[d].contains(digit)) {
            match = false;
            break;
          }
          if (digitMatches != null) digitMatches.last.insert(0, digit);
          value = value ~/ divisor;
        }
        if (match) {
          if (digitMatches == null) return true;
          anyMatch = true;
        } else {
          if (digitMatches != null) digitMatches.removeLast();
        }
      }
    } else if (numDoubleDigits == 2) {
      for (var dd1 = length! - 1; dd1 > 0; dd1--) {
        var value = matchValue;
        for (var dd2 = dd1 - 1; dd2 >= 0; dd2--) {
          var match = true;
          if (digitMatches != null) digitMatches.add(<int>[]);
          for (var d = length! - 1; d >= 0; d--) {
            var divisor = dd1 == d || dd2 == d ? 100 : 10;
            var minDigit = dd1 == d || dd2 == d ? 10 : 0;
            var digit = value % divisor;
            if (digit < minDigit || !digits[d].contains(digit)) {
              match = false;
              break;
            }
            if (digitMatches != null) digitMatches.last.insert(0, digit);
            value = value ~/ divisor;
          }
          if (match) {
            if (digitMatches == null) return true;
            anyMatch = true;
          } else {
            if (digitMatches != null) digitMatches.removeLast();
          }
        }
      }
    } else {
      throw Exception('Entry $name two many double digits');
    }
    return anyMatch;
  }

  @override
  bool updateDigits(Set<int> values) {
    var updated = false;
    var possibleDigits = List.generate(length!, (_) => <int>{});
    for (var value in values) {
      var digitMatches = <List<int>>[];
      if (digitsMatch(value, digitMatches)) {
        for (var d = 0; d < length!; d++) {
          for (var digitMatch in digitMatches) {
            var digit = digitMatch[d];
            possibleDigits[d].add(digit);
          }
        }
      }
    }
    for (var d = 0; d < length!; d++) {
      if (updatePossible(digits[d], possibleDigits[d])) updated = true;
    }

    return updated;
  }
}
