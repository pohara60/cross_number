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

  set tryValue(int? value) {
    _tryValue = value;
  }

  Set<int>? get values => _tryValue != null ? {_tryValue!} : _values;
  set values(Set<int>? values) {
    _values = values;
  }

  Clue({
    required this.name,
    required this.length,
    this.valueDesc,
    this.solve,
  }) {
    digitIdentities = List.filled(length, null);
    referrers = <Clue>[];
    initDigits();
  }

  void initDigits() {
    // possible digits are 0..9, except cannot have leading 0
    digits = [];
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
    const kLimit = 20;
    var valueStr = values == null
        ? '{unknown}'
        : values!.length > kLimit
            ? '{more than $kLimit}'
            : values.toString();
    return 'Clue(name=$name,length=$length,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tdigits=$digits';
  }

  String toSummary() {
    const kLimit = 20;
    var valueStr = values == null
        ? '{unknown}'
        : values!.length > kLimit
            ? '{more than $kLimit}'
            : values.toString();
    return '$name, $valueDesc, values=$valueStr';
  }
}

bool updatePossible(Set<int> possible, Set<int> possibleValues) {
  var updated = possible.any((element) => !possibleValues.contains(element));
  possible.removeWhere((element) => !possibleValues.contains(element));
  return updated;
}

class VariableClue extends Clue {
  late final List<String> variableReferences;

  VariableClue({required name, required length, valueDesc, solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    this.variableReferences = <String>[];
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
