import '../clue.dart';
import '../variable.dart';

enum Root66_2EntryType { UNKNOWN, BCEF, G, BCEFG }

/// A [Puzzle] clue

class Root66_2Clue extends ExpressionClue {
  /// List of referenced letters
  List<String> get letterReferences => this.variableReferences;
  addLetterReference(String letter) => this.addVariableReference(letter);

  Root66_2Clue({
    required String name,
    VariableType type = VariableType.C,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve);

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
    var entriesStr = entry!.values == null
        ? '{unknown}'
        : entry!.values!.length > kLimit
            ? '{more than $kLimit}'
            : entry!.values.toString();
    var valueStr = values == null
        ? '{unknown}'
        : values!.length > kLimit
            ? '{more than $kLimit}'
            : values.toString();
    return '$runtimeType(name=$name,length=$length,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr),\n\tentries=$entriesStr,\n\tdigits=$digits';
  }
}

class Root66_2Entry extends Root66_2Clue with EntryMixin {
  Root66_2EntryType root66type;
  Root66_2Entry({
    required name,
    VariableType type = VariableType.E,
    required length,
    required this.root66type,
    valueDesc,
    solve,
  }) : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
