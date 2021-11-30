import 'package:crossnumber/clue.dart';
import 'package:crossnumber/set.dart';

/// A [LettersPuzzle] clue
class LettersClue extends Clue {
  /// List of referenced primes
  late final List<String> letterReferences;

  LettersClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    this.letterReferences = <String>[];
  }

  addLetterReference(String letter) {
    this.letterReferences.add(letter);
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
    return 'Clue(name=$name,length=$length,value: $valueDesc,\n\tidentities=[$identityStr],referrers=[$referrersStr],\n\tvalues=$valueStr,\n\tdigits=${digits.toShortString()}';
  }
}
