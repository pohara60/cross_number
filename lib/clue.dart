import 'package:crossnumber/cartesian.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:powers/powers.dart';

import 'expression.dart';
import 'grid.dart';
import 'puzzle.dart';
import 'set.dart';
import 'variable.dart';

/// A [Puzzle] clue
class Clue extends Variable {
  /// Inherits: name, values, tryValue

  /// Number of digits, min and max values
  final int? length;
  late int? min, max;

  /// Description of clue
  String? valueDesc;

  // Mutual reference to an other clue
  bool circularClueReference = false;

  // Mapped grid entry - Clue with EntryMixin
  Clue? _entry;
  Clue? get entry => _entry;
  void set entry(Clue? entry) {
    _entry = entry;
  }

  EntryMixin? get entryMixin => entry == null ? null : entry as EntryMixin;

  List<DigitIdentity?> get digitIdentities => entry!.digitIdentities;
  List<Set<int>> get digits => entry!.digits;

  void setDigits(int i, Set<int> set) {
    entry!.setDigits(i, set);
  }

  bool get isAcross => this.name[0] == 'A';
  bool get isDown => this.name[0] == 'D';
  bool get isUnknown => !isAcross && !isDown;

  /// Computed - Range of possible values
  int? get lo => min;
  int? get hi => max;
  Iterable<int> get range => hi == null || lo == null
      ? []
      : Iterable<int>.generate(hi! - lo! + 1, (index) => lo! + index);

  /// Restricted list of values
  Set<int>? _restrictedValues;
  set restrictedValues(Set<int> values) {
    if (_restrictedValues == null) {
      _restrictedValues = values;
    } else {
      _restrictedValues = _restrictedValues!.intersection(values);
    }
  }

  Clue({
    required String name,
    required VariableType type,
    required int? this.length,
    String? this.valueDesc,
    SolveFunction? solve,
  }) : super(name, variableType: type, solve: solve) {
    this.reset();
  }

  void reset() {
    if (entry != null) (entry as EntryMixin).initDigits();
    values = null;
    if (length != null) {
      min = 10.pow(length! - 1) as int;
      max = (10.pow(length!) as int) - 1;
    } else {
      min = null;
      max = null;
    }
    _restrictedValues = null;
  }

  bool initialise() {
    // Update entry digits from digit references
    var updated = false;
    if (entry != null) (entry as EntryMixin).updateDigitsFromOtherEntries();
    return updated;
  }

  List<int> getValues(Iterable<int> Function() getInitialValues) {
    if (values == null) {
      return getInitialValues().toList();
    }
    if (_restrictedValues != null &&
        _restrictedValues!.length != values!.length) {
      //   print(
      //       '${this.name} reference removed ${values.length - _restrictedValues.length} values');
      return values!.intersection(_restrictedValues!).toList();
    }
    return values!.toList();
  }

  bool finalise() {
    // Update digits from values
    if (this.values == null) return false;
    var updated = false;
    if (entry != null) {
      if ((entry as EntryMixin).updateDigits(this.values!)) updated = true;
    }
    return updated;
  }

  List<Set<int>> saveDigits() {
    assert(entry != null);

    return entry!.saveDigits();
  }

  void restoreDigits(List<Set<int>> savedDigits) {
    assert(entry != null);
    entry!.restoreDigits(savedDigits);
  }

  bool updateValues(Set<int> possibleValue) {
    var updated = false;
    if (this.values == null) {
      this.values = possibleValue;
      updated = true;
    } else {
      checkAnswer(possibleValue);
      if (updatePossible(this.values!, possibleValue)) updated = true;
    }
    return updated;
  }

  bool digitsMatch(int value) {
    if (entry != null) return entry!.digitsMatch(value);
    return true;
  }

  String toString() {
    var identityStr = entry == null
        ? ''
        : 'identities=[' +
            digitIdentities
                .asMap()
                .entries
                .map((e) => e.value == null
                    ? ''
                    : '${this.name}[${e.key}]=${e.value!.entry.name}[${e.value!.digit}]')
                .where((element) => element != '')
                .join(',') +
            '],';
    var digitsStr =
        entry == null ? '' : ',\n\tdigits=${digits.toShortString()}';
    var referrersStr = referrers.map((e) => e.name).join(',');
    var valueStr = values == null ? '{unknown}' : values!.toShortString();
    // return '$Clue(name=$name,length=$length,value: $valueDesc,\n\t${identityStr}referrers=[$referrersStr],\n\tvalues=$valueStr$digitsStr';
    return '$runtimeType(name=$name,length=$length,value: $valueDesc,\n\t${identityStr}referrers=[$referrersStr],\n\tvalues=$valueStr$digitsStr';
  }

  String toSummary() {
    String valueString(Set<int>? values) =>
        values == null ? '{unknown}' : values.toShortString();
    var valueStr =
        '${valueDesc == null ? "" : "$valueDesc, "}values=${valueString(values)}';
    if (entry != null && entry != this)
      valueStr += ', entry=${valueString(entry!.values)}';
    return '$name, $valueStr';
  }

  @override
  compareTo(Variable other) {
    if (other is Clue) {
      if (name[0] == 'A' || name[0] == 'D') {
        if (name[0] != other.name[0]) return name.compareTo(other.name);
        var n1 = int.parse(name.substring(1));
        var n2 = int.parse(other.name.substring(1));
        return n1.compareTo(n2);
      } else {
        var n1 = romanToDecimal(name);
        var n2 = romanToDecimal(other.name);
        return n1.compareTo(n2);
      }
    }
    // Clues before Variables
    return -1;
  }

  Set<int>? getValuesFromDigits() {
    if (entryMixin == null) return null;
    return entryMixin!.getValuesFromDigits();
  }

  static const powers = [10000000, 1000000, 100000, 10000, 1000, 100, 10, 1];
  List<int> clueDigits(int digit) {
    if (values == null) return [];
    var digits = <int>{};
    for (var value in values!) {
      var v = value ~/ powers[digit + 8 - length!] % 10;
      digits.add(v);
    }
    return digits.toList()..sort();
  }
}

bool updatePossible(Set<int> possible, Set<int> possibleValues) {
  var updated = possible.any((element) => !possibleValues.contains(element));
  possible.removeWhere((element) => !possibleValues.contains(element));
  return updated;
}

class VariableClue extends Clue with PriorityVariable {
  /// Computed - Count of combinations of variable values
  VariableClue(
      {required String name,
      required VariableType type,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {}
}

class ExpressionClue extends VariableClue with Expression {
  ExpressionClue({
    required String name,
    required VariableType type,
    required int? length,
    String? valueDesc,
    List<String>? addDesc,
    SolveFunction? solve,
    variablePrefix = '',
    List<String>? entryNames,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initExpression(valueDesc, variablePrefix, name, variableRefs, entryNames);
    if (addDesc != null) {
      for (var desc in addDesc) {
        addExpression(desc, entryNames: entryNames);
      }
    }
  }

  addExpression(String valueDesc,
      {String variablePrefix = '', List<String>? entryNames}) {
    this.valueDesc = this.valueDesc == null || this.valueDesc == ''
        ? valueDesc
        : '${this.valueDesc} | $valueDesc';
    initExpression(valueDesc, variablePrefix, name, variableRefs, entryNames);
  }

  bool fixReference(clueName) {
    var updated = false;
    for (var exp in this.expressions) {
      var name = exp.fixReference(clueName);
      if (name != '') {
        if (this.clueNameReferences.contains(clueName)) {
          this.removeClueReference(clueName);
          this.addVariableReference(name);
        }
        updated = true;
      }
    }
    if (updated) {
      variableRefs.fixReference(clueName);
    }
    return updated;
  }

  void sortVariables() {
    variableRefs.sort();
  }
}

/// A reference to [Entry] digit
class DigitIdentity {
  // The referenced clue
  final EntryMixin entry;
  final int digit;

  Clue get clue => entry;

  DigitIdentity({
    required EntryMixin this.entry,
    required int this.digit,
  });

  String toString() {
    return '$entry[$digit]';
  }
}

mixin EntryMixin on Clue {
  /// Max digit value
  static var maxDigit = 9;

  /// Zero allowed
  static var zeroDigit = true;

  /// Optional row/col for start of entry, set by validateEntriesFromGrid
  int? row;
  int? col;
  static const MAXROWS = 100;
  int cellDigitIndex(int digit) {
    if (isDown) {
      return cellIndex(row! + digit, col!);
    }
    return cellIndex(row!, col! + digit);
  }

  static int cellIndex(int row, int col) {
    return row * MAXROWS + col;
  }

  /// Common digits with other clues: each digit has optional reference to clue and digit
  late final List<DigitIdentity?> digitIdentities;

  /// Cells - set when puzzle has a Grid
  final cells = <Cell>[];
  bool _hasGrid = false;
  bool get hasGrid => _hasGrid;
  void set hasGrid(bool hasGrid) {
    assert(hasGrid == true && cells.length == length!);
    _hasGrid = hasGrid;
  }

  /// Computed - Possible digits, used when puzzle does not have a grid (legacy)
  var _digits = <Set<int>>[];
  List<Set<int>> get digits {
    var tryValue = this.tryValue;
    if (tryValue != null) return digitsFromValue;
    if (hasGrid) return cells.map((e) => e.digits).toList();
    return _digits;
  }

  List<Set<int>> get digitsFromValue {
    var tryValue = this.tryValue;
    if (tryValue == null) {
      if (values != null && values!.length == 1) {
        tryValue = values!.first;
      }
    }
    if (tryValue != null) {
      var digits = List<Set<int>>.generate(this.length!, (_) => {});
      for (var d = this.length! - 1; d >= 0; d--) {
        var digit = tryValue! % 10;
        tryValue = tryValue ~/ 10;
        digits[d].add(digit);
      }
      return digits;
    } else {
      return _digits;
    }
  }

  void set digits(List<Set<int>> digits) {
    if (!hasGrid) {
      _digits = digits;
      return;
    }
    var index = 0;
    for (var cell in cells) {
      cell.digits = digits[index++];
    }
  }

  // Mapped Clue
  Clue? _clue;
  Clue? get clue => _clue;
  void set clue(Clue? clue) {
    _clue = clue;
  }

  void initEntry(Clue entry) {
    digitIdentities = List.filled(entry.length!, null);
    initDigits();
    // Self-reference to make Clue methods work
    entry._entry = entry;
  }

  void initDigits() {
    // possible digits are 0..9, except cannot have leading 0
    if (!hasGrid && _digits.isEmpty) {
      _digits.addAll(List.generate(length!, (index) => <int>{}));
    }
    for (var d = 0; d < this.length!; d++) {
      setDigits(d,
          Set.from(List.generate(EntryMixin.maxDigit + 1, (index) => index)));
      if (d == 0 || !zeroDigit) digits[d].remove(0);
    }
  }

  bool updateDigits(Set<int> values) {
    var updated = false;
    for (var d = 0; d < length!; d++) {
      var possibleDigits = <int>{};
      for (var value in values) {
        var digit = int.parse(value.toString()[d]);
        possibleDigits.add(digit);
      }
      if (updatePossible(digits[d], possibleDigits)) updated = true;
    }
    return updated;
  }

  bool updateDigitsFromOtherEntries() {
    var updated = false;
    for (var d = 0; d < length!; d++) {
      if (digitIdentities[d] != null) {
        var entry2 = digitIdentities[d]!.entry;
        var d2 = digitIdentities[d]!.digit;
        var possibleDigits = entry2.digits[d2];
        if (updatePossible(digits[d], possibleDigits)) updated = true;
      }
    }
    return updated;
  }

  List<Set<int>> saveDigits() {
    var result = <Set<int>>[];
    for (var d = 0; d < length!; d++) {
      result.add(Set.from(digits[d]));
    }
    return result;
  }

  void restoreDigits(List<Set<int>> savedDigits) {
    for (var d = 0; d < length!; d++) {
      setDigits(d, savedDigits[d]);
    }
  }

  bool digitsMatch(int value) {
    for (var d = this.length! - 1; d >= 0; d--) {
      var digit = value % 10;
      if (!this.digits[d].contains(digit)) return false;
      value = value ~/ 10;
    }
    return true;
  }

  Set<int>? getValuesFromDigits() {
    var allDigits =
        List<List<int>>.generate(length!, (d) => digits[d].toList());
    var count = cartesianCount(allDigits);
    if (count == 0) throw SolveException('No values for a digit');
    if (count > 1000) return null;
    var values = <int>{};
    for (var product in cartesian(allDigits, true)) {
      int value = product.reduce((value, element) => value * 10 + element);
      values.add(value);
    }
    return values;
  }

  void updateValuesFromDigits() {
    var digitValues = getValuesFromDigits();
    if (digitValues == null) return;

    if (values == null) {
      values = digitValues;
      return;
    }

    var newValues =
        values!.where((value) => digitValues.contains(value)).toSet();
    if (newValues.length != values!.length) {
      values = newValues;
      for (var cell in cells) {
        cell.updateDigitsFromEntry(this);
      }
    }
  }

  void setDigits(int d, Set<int> set) {
    if (hasGrid)
      cells[d].digits = set;
    else
      _digits[d] = set;
  }

  void addDigitIdentity(int digit1, EntryMixin otherEntry, int digit2) {
    digitIdentities[digit1 - 1] =
        DigitIdentity(entry: otherEntry, digit: digit2 - 1);
    otherEntry.digitIdentities[digit2 - 1] =
        DigitIdentity(entry: this, digit: digit1 - 1);
    addReferrer(otherEntry);
    otherEntry.addReferrer(this);
    if (clue != null && otherEntry.clue != null) {
      // Entrys are mapped to clues, so add reference betwen them
      clue!.addReferrer(otherEntry.clue!);
      otherEntry.clue!.addReferrer(clue!);
    }
  }
}

class Entry extends Clue with EntryMixin {
  Entry(
      {required String name,
      required VariableType type,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    assert(length != null);
    initEntry(this);
  }
}

class VariableEntry extends VariableClue with EntryMixin {
  VariableEntry(
      {required String name,
      required VariableType type,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }

  addVariableReference(String variable) {
    variableRefs.addVariableReference(variable);
  }
}

class ExpressionEntry extends ExpressionClue with EntryMixin {
  ExpressionEntry(
      {required String name,
      required VariableType type,
      required int length,
      String? valueDesc,
      SolveFunction? solve,
      variablePrefix = ''})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
