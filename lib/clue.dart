import 'package:crossnumber/expression.dart';
import 'package:crossnumber/set.dart';
import 'package:powers/powers.dart';

/// A [Puzzle] clue
class Clue {
  /// Name
  final String name;

  /// Number of digits
  final int length;

  /// Description of clue
  final String? valueDesc;

  /// Common digits with other clues: each digit has optional reference to clue and digit
  late final List<DigitIdentity?> digitIdentities;

  /// List of clues that need to be examined when this clue is updated
  late final List<Clue> referrers;

  /// Solve function
  final Function? solve;

  /// Computed - Possible digits
  late final List<Set<int>> digits;

  /// Computed - Possible Values
  Set<int>? _values;

  /// Try possible value
  int? _tryValue;

  bool get isAcross => this.name[0] == 'A';
  bool get isDown => this.name[0] == 'D';

  set tryValue(int? value) {
    _tryValue = value;
  }

  Set<int>? get values => _tryValue != null ? {_tryValue!} : _values;
  set values(Set<int>? values) {
    _values = values;
  }

  /// Computed - Range of possible values
  int get lo => 10.pow(length - 1) as int;
  int get hi => (10.pow(length) as int) - 1;
  Iterable<int> get range =>
      Iterable<int>.generate(hi - lo + 1, (index) => lo + index);

  /// Computed - Values
  Set<int>? _restrictedValues;
  set restrictedValues(Set<int> values) {
    if (_restrictedValues == null) {
      _restrictedValues = values;
    } else {
      _restrictedValues = _restrictedValues!.intersection(values);
    }
  }

  Clue({
    required this.name,
    required this.length,
    this.valueDesc,
    this.solve,
  }) {
    digitIdentities = List.filled(length, null);
    referrers = <Clue>[];
    digits = [];
    this.reset();
  }

  void reset() {
    initDigits();
    _values = null;
    _restrictedValues = null;
  }

  void initDigits() {
    digits.clear(); // Clear for reset
    // possible digits are 0..9, except cannot have leading 0
    for (var d = 0; d < this.length; d++) {
      digits.add(Set.from(List.generate(10, (index) => index)));
      if (d == 0) digits[d].remove(0);
    }
  }

  addReferrer(Clue clue) {
    this.referrers.add(clue);
  }

  bool initialise() {
    // Update digits from digit references
    var updated = false;
    for (var d = 0; d < length; d++) {
      if (digitIdentities[d] != null) {
        var clue2 = digitIdentities[d]!.clue;
        var d2 = digitIdentities[d]!.digit;
        var possibleDigits = clue2.digits[d2];
        if (updatePossible(digits[d], possibleDigits)) updated = true;
      }
    }
    return updated;
  }

  List<int> getValues(Iterable<int> Function() getInitialValues) {
    if (_values == null) {
      return getInitialValues().toList();
    }
    if (_restrictedValues != null &&
        _restrictedValues!.length != _values!.length) {
      //   print(
      //       '${this.name} reference removed ${_values.length - _restrictedValues.length} values');
      return _values!.intersection(_restrictedValues!).toList();
    }
    return _values!.toList();
  }

  bool finalise() {
    // Update digits from values
    if (this.values == null) return false;
    var updated = false;
    for (var d = 0; d < length; d++) {
      var possibleDigits = <int>{};
      for (var value in this.values!) {
        var digit = int.parse(value.toString()[d]);
        possibleDigits.add(digit);
      }
      if (updatePossible(digits[d], possibleDigits)) updated = true;
    }
    return updated;
  }

  bool updateValues(Set<int> possibleValue) {
    var updated = false;
    if (this.values == null) {
      this.values = possibleValue;
      updated = true;
    } else {
      if (updatePossible(this.values!, possibleValue)) updated = true;
    }
    return updated;
  }

  bool digitsMatch(int value) {
    for (var d = this.length - 1; d >= 0; d--) {
      var digit = value % 10;
      if (!this.digits[d].contains(digit)) return false;
      value = value ~/ 10;
    }
    return true;
  }

  String toString() {
    var identityStr = digitIdentities
        .asMap()
        .entries
        .map((e) => e.value == null
            ? ''
            : '${this.name}[${e.key}]=${e.value!.clue.name}[${e.value!.digit}]')
        .where((element) => element != '')
        .join(',');
    var referrersStr = referrers.map((e) => e.name).join(',');
    var valueStr = values == null ? '{unknown}' : values!.toShortString();
    return 'Clue(name=$name,length=$length,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tdigits=${digits.toShortString()}';
  }

  String toSummary() {
    var valueStr = values == null ? '{unknown}' : values!.toShortString();
    return '$name, $valueDesc, values=$valueStr';
  }

  compareTo(Clue other) {
    if (name[0] != other.name[0]) return name.compareTo(other.name);
    var n1 = int.parse(name.substring(1));
    var n2 = int.parse(other.name.substring(1));
    return n1.compareTo(n2);
  }
}

bool updatePossible(Set<int> possible, Set<int> possibleValues) {
  var updated = possible.any((element) => !possibleValues.contains(element));
  possible.removeWhere((element) => !possibleValues.contains(element));
  return updated;
}

class VariableClue extends Clue {
  late final List<String> variableReferences;
  late ExpressionEvaluator exp;

  /// Computed - Count of combinations of variable values
  int count = 0;

  VariableClue({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    this.variableReferences = <String>[];
    if (valueDesc != '') {
      this.exp = ExpressionEvaluator(valueDesc);
    }
  }

  addVariableReference(String variable) {
    this.variableReferences.add(variable);
  }
}

/// A reference to [Clue]
class ClueReference {
  // The referenced clue
  final Clue clue;

  ClueReference({
    required this.clue,
  });

  String toString() {
    return 'clue=$clue';
  }
}

/// A reference to [Clue] digit
class DigitIdentity {
  // The referenced clue
  final Clue clue;
  final int digit;

  DigitIdentity({
    required this.clue,
    required this.digit,
  });

  String toString() {
    return '$clue[$digit]';
  }
}
