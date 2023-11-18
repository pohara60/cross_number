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
  List<String> get primeReferences => this.variableReferences;
  addPrimeReference(String prime) => this.addVariableReference(prime);

  PrimeCutsClue({
    required String name,
    required int? length,
    required String this.prime,
    String? valueDesc,
    String? this.primeDesc,
    String? this.preValueDesc,
    SolveFunction? solve,
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
    return 'Clue(name=$name,length=$length,value: $valueDesc,\n\tprime=${primeDesc ?? prime},preValue: $preValueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tpreValues=$preValueStr),\n\tdigits=$digits';
  }
}

class PrimeCutsEntry extends PrimeCutsClue with EntryMixin {
  PrimeCutsEntry({
    required String name,
    required int? length,
    required String prime,
    String? valueDesc,
    String? primeDesc,
    String? preValueDesc,
    SolveFunction? solve,
  }) : super(
            name: name,
            length: length,
            prime: prime,
            valueDesc: valueDesc,
            primeDesc: primeDesc,
            preValueDesc: preValueDesc,
            solve: solve) {
    initEntry(this);
  }
}
