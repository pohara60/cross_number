// ignore_for_file: camel_case_types

import '../clue.dart';
import '../variable.dart';

// ignore: constant_identifier_names
enum Root66_2EntryType { UNKNOWN, BCEF, G, BCEFG }

/// A [Puzzle] clue

class Root66_2Clue extends ExpressionClue {
  /// List of referenced letters
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  Root66_2Clue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    super.valueDesc,
    super.solve,
  });

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
    required super.name,
    super.type = VariableType.E,
    required super.length,
    required this.root66type,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
