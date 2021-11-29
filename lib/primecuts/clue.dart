import 'package:crossnumber/clue.dart';

/// A [Puzzle] clue
class PrimeCutsClue extends Clue {
  /// Name of Prime
  final String prime;

  /// Description of clue
  final String? primeDesc;
  final String? preValueDesc;

  /// List of referenced primes
  late final List<String> primeReferences;

  /// Computed - Possible Values before Prime
  Set<int>? preValues;

  PrimeCutsClue({
    required name,
    required length,
    required this.prime,
    valueDesc,
    this.primeDesc,
    this.preValueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    this.primeReferences = <String>[];
  }

  addPrimeReference(String prime) {
    this.primeReferences.add(prime);
  }

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
