import '../clue.dart';
import '../variable.dart';

/// A [Puzzle] clue
class PrimeCutsClue extends VariableClue {
  /// Name of Prime
  final String prime;

  /// Description of clue
  final String? primeDesc;
  final String? preValueDesc;

  /// Computed - Possible Values before Prime
  Set<int>? preValues;

  /// List of referenced primes
  List<String> get primeReferences => variableNameReferences;
  addPrimeReference(String prime) => addVariableReference(prime);

  PrimeCutsClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    required this.prime,
    super.valueDesc,
    this.primeDesc,
    this.preValueDesc,
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
    return 'Clue(name=$name,length=$length,value: $valueDesc,\n\tprime=${primeDesc ?? prime},preValue: $preValueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tpreValues=$preValueStr),\n\tdigits=$digits';
  }
}

class PrimeCutsEntry extends PrimeCutsClue with EntryMixin {
  PrimeCutsEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    required super.prime,
    super.valueDesc,
    super.primeDesc,
    super.preValueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
