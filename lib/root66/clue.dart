import 'package:crossnumber/clue.dart';

enum Root66ClueType { UNKNOWN, BCEF, G, BCEFG }

/// A [Puzzle] clue
class Root66Clue extends VariableClue {
  /// Computed - Possible Values before BCEF/G
  Set<int>? preValues;
  Root66ClueType type;

  /// List of referenced letters
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  Root66Clue({
    required name,
    required length,
    required this.type,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);

  bool updatePreValues(Set<int> possiblePreValue) {
    var updated = false;
    if (this.preValues == null) {
      this.preValues = possiblePreValue;
      updated = true;
    } else {
      if (updatePossible(this.preValues!, possiblePreValue)) updated = true;
    }
    return updated;
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
    var preValueStr = preValues == null
        ? '{unknown}'
        : preValues!.length > kLimit
            ? '{more than $kLimit}'
            : preValues.toString();
    return 'Clue(name=$name,length=$length,type=$type,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tpreValues=$preValueStr),\n\tdigits=$digits';
  }
}