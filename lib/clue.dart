import 'package:crossnumber/cartesian.dart';
import 'package:powers/powers.dart';

import 'expression.dart';
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

  // References
  final _variableRefs = VariableRefList();
  List<String> get variableReferences => _variableRefs.variableNames;
  List<String> get clueReferences => _variableRefs.clueNames;
  List<String> get entryReferences => _variableRefs.entryNames;
  List<String> get variableClueReferences => [
        ..._variableRefs.variableNames,
        ..._variableRefs.clueNames,
        ..._variableRefs.entryNames,
      ];

  // Mutual reference to an other clue
  bool circularClueReference = false;

  /// List of clues that need to be examined when this clue is updated
  late final List<Clue> referrers;

  // Mapped grid entry - Clue with EntryMixin
  Clue? _entry;
  Clue? get entry => _entry;
  void set entry(Clue? entry) {
    _entry = entry;
  }

  EntryMixin? get entryMixin => entry == null ? null : entry as EntryMixin;

  List<DigitIdentity?> get digitIdentities => entry!.digitIdentities;
  List<Set<int>> get digits => entry!.digits;

  bool get isAcross => this.name[0] == 'A';
  bool get isDown => this.name[0] == 'D';

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
    required name,
    required this.length,
    this.valueDesc,
    solve,
  }) : super(name, solve: solve) {
    referrers = <Clue>[];
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

  addReferrer(Clue clue) {
    if (!referrers.contains(clue)) referrers.add(clue);
  }

  addClueReference(String clueName) {
    _variableRefs.addClueReference(clueName);
  }

  addVariableReference(String variable) {
    _variableRefs.addVariableReference(variable);
  }

  removeClueReference(String name) {
    _variableRefs.removeClueReference(name);
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
      if (name[0] != other.name[0]) return name.compareTo(other.name);
      var n1 = int.parse(name.substring(1));
      var n2 = int.parse(other.name.substring(1));
      return n1.compareTo(n2);
    }
    // Clues before Variables
    return -1;
  }

  Set<int>? getValuesFromDigits() {
    if (entryMixin == null) return null;
    return entryMixin!.getValuesFromDigits();
  }
}

bool updatePossible(Set<int> possible, Set<int> possibleValues) {
  var updated = possible.any((element) => !possibleValues.contains(element));
  possible.removeWhere((element) => !possibleValues.contains(element));
  return updated;
}

class VariableClue extends Clue with PriorityVariable {
  /// Computed - Count of combinations of variable values
  VariableClue({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {}
}

class ExpressionClue extends VariableClue with Expression {
  ExpressionClue({
    required String name,
    required int? length,
    String? valueDesc,
    Function? solve,
    variablePrefix = '',
    List<String>? entryNames,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initExpression(valueDesc, variablePrefix, name, _variableRefs, entryNames);
  }

  addExpression(String valueDesc,
      {String variablePrefix = '', List<String>? entryNames}) {
    this.valueDesc = this.valueDesc == null || this.valueDesc == ''
        ? valueDesc
        : '${this.valueDesc} | $valueDesc';
    initExpression(valueDesc, variablePrefix, name, _variableRefs, entryNames);
  }

  bool fixReference(clueName) {
    var updated = false;
    for (var exp in this.expressions) {
      var name = exp.fixReference(clueName);
      if (name != '') {
        if (this.clueReferences.contains(clueName)) {
          this.removeClueReference(clueName);
          this.addVariableReference(name);
        }
        updated = true;
      }
    }
    if (updated) {
      _variableRefs.fixReference(clueName);
    }
    return updated;
  }

  void sortVariables() {
    _variableRefs.sort();
  }
}

/// A reference to [Entry] digit
class DigitIdentity {
  // The referenced clue
  final EntryMixin entry;
  final int digit;

  Clue get clue => entry;

  DigitIdentity({
    required this.entry,
    required this.digit,
  });

  String toString() {
    return '$entry[$digit]';
  }
}

mixin EntryMixin on Clue {
  /// Max digit value
  static var maxDigit = 9;

  /// Optional row/col for start of entry, set by validateEntriesFromGrid
  int? row;
  int? col;
  static const MAXROWS = 100;
  int cellIndex(int digit) {
    if (isDown) {
      return (row! + digit) * MAXROWS + col!;
    }
    return row! * MAXROWS + col! + digit;
  }

  /// Common digits with other clues: each digit has optional reference to clue and digit
  late final List<DigitIdentity?> digitIdentities;

  /// Computed - Possible digits
  late final List<Set<int>> digits;

  // Mapped Clue
  Clue? _clue;
  Clue? get clue => _clue;
  void set clue(Clue? clue) {
    _clue = clue;
  }

  void initEntry(Clue entry) {
    digitIdentities = List.filled(entry.length!, null);
    digits = [];
    initDigits();
    // Self-reference to make Clue methods work
    entry._entry = entry;
  }

  void initDigits() {
    digits.clear(); // Clear for reset
    // possible digits are 0..9, except cannot have leading 0
    for (var d = 0; d < this.length!; d++) {
      digits.add(
          Set.from(List.generate(EntryMixin.maxDigit + 1, (index) => index)));
      if (d == 0) digits[d].remove(0);
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
      digits[d] = savedDigits[d];
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
    if (count > 1000) return null;
    var values = <int>{};
    for (var product in cartesian(allDigits, true)) {
      int value = product.reduce((value, element) => value * 10 + element);
      values.add(value);
    }
    return values;
  }
}

class Entry extends Clue with EntryMixin {
  Entry({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    assert(length != null);
    initEntry(this);
  }
}

class VariableEntry extends VariableClue with EntryMixin {
  VariableEntry({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }

  addVariableReference(String variable) {
    _variableRefs.addVariableReference(variable);
  }
}

class ExpressionEntry extends ExpressionClue with EntryMixin {
  ExpressionEntry(
      {required String name,
      required int length,
      String? valueDesc,
      Function? solve,
      variablePrefix = ''})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}
