import '../clue.dart';
import '../variable.dart';

// ignore: constant_identifier_names
enum Root66ClueType { UNKNOWN, BCEF, G, BCEFG }

/// A [Puzzle] clue

class Root66Clue extends ExpressionClue {
  /// Computed - Possible Values before BCEF/G
  Set<int>? preValues;
  Root66ClueType root66type;

  /// List of referenced letters
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  Root66Clue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    required this.root66type,
    super.valueDesc,
    super.solve,
  });

  bool updatePreValues(Set<int> possiblePreValue) {
    var updated = false;
    if (preValues == null) {
      preValues = possiblePreValue;
      updated = true;
    } else {
      if (updatePossible(preValues!, possiblePreValue)) updated = true;
    }
    return updated;
  }

  @override
  String toString() {
    var identityStr = digitIdentities
        .asMap()
        .entries
        .map((e) => e.value == null
            ? ''
            : '$name[${e.key}]=${e.value!.clue.name}[${e.value!.digit}]')
        .where((element) => element != '')
        .join(',');
    var referrersStr = referrers.map((e) => e.name).join(',');
    const kLimit = 20;
    var valueStr = values == null
        ? '{unknown}'
        : values!.length > kLimit
            ? '{more than $kLimit}'
            : values.toString();
    var preValueStr = preValues == null
        ? '{unknown}'
        : preValues!.length > kLimit
            ? '{more than $kLimit}'
            : preValues.toString();
    return 'Clue(name=$name,length=$length,type=$root66type,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tpreValues=$preValueStr),\n\tdigits=$digits';
  }
}

class Root66Entry extends Root66Clue with EntryMixin {
  Root66Entry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    required super.root66type,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
