import '../clue.dart';
import '../set.dart';
import '../variable.dart';

/// A [Puzzle] clue
class PrimeCutsClue extends ExpressionClue {
  /// Name of Prime
  final String prime;

  /// List of referenced primes
  List<String> get primeReferences => variableNameReferences;
  addPrimeReference(String prime) => addVariableReference(prime);

  PrimeCutsClue({
    required super.name,
    super.type = VariableType.C,
    required super.length,
    required this.prime,
    super.valueDesc,
    super.solve,
  });

  @override
  String toString() {
    var identityStr = entry == null
        ? ''
        : 'identities=[${digitIdentities
                .asMap()
                .entries
                .map((e) => e.value == null
                    ? ''
                    : '$name[${e.key}]=${e.value!.entry.name}[${e.value!.digit}]')
                .where((element) => element != '')
                .join(',')}],';
    var digitsStr =
        entry == null ? '' : ',\n\tdigits=${digits.toShortString()}';
    var referrersStr = referrers.map((e) => e.name).join(',');
    var valueStr = values == null ? '{unknown}' : values!.toShortString();
    var entriesStr = entry == null
        ? ''
        : ',\n\tentries=${entry!.values == null
                ? '{unknown}'
                : entry!.values!.toShortString()}';
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
    required super.name,
    super.type = VariableType.E,
    required super.length,
    required super.prime,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
