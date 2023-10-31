import '../clue.dart';
import '../set.dart';

/// A [Puzzle] clue
class PrimeCutsClue extends ExpressionClue {
  /// Name of Prime
  final String prime;

  /// List of referenced primes
  List<String> get primeReferences => this.variableReferences;
  addPrimeReference(String prime) => this.addVariableReference(prime);

  PrimeCutsClue({
    required name,
    required length,
    required this.prime,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);

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
    var entriesStr = entry == null
        ? ''
        : ',\n\tentries=' +
            (entry!.values == null
                ? '{unknown}'
                : entry!.values!.toShortString());
    // return '$Clue(name=$name,length=$length,value: $valueDesc,\n\t${identityStr}referrers=[$referrersStr],\n\tvalues=$valueStr$digitsStr';
    return '$runtimeType(name=$name,prime=$prime,length=$length,value: $valueDesc,\n\t${identityStr}referrers=[$referrersStr],\n\tvalues=$valueStr$entriesStr$digitsStr';
  }

  @override
  Set<int>? getValuesFromDigits() {
    // Ok for entries
    if (this is EntryMixin) {
      return super.getValuesFromDigits();
    }
    // Cannot get clue values from entry digits because they have additional prime digits
    return null;
  }
}

class PrimeCutsEntry extends PrimeCutsClue with EntryMixin {
  PrimeCutsEntry({
    required name,
    required length,
    required prime,
    valueDesc,
    solve,
  }) : super(
            name: name,
            length: length,
            prime: prime,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
