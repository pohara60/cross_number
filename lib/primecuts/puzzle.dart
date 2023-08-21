import 'package:crossnumber/primecuts/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/variable.dart';

class PrimeVariable extends Variable {
  PrimeVariable(prime) : super(prime) {
    this.values = Set.from(twoDigitPrimes);
  }
  String get prime => this.name;
}

class PrimeCutsPuzzle
    extends VariablePuzzle<PrimeCutsClue, PrimeCutsEntry, PrimeVariable> {
  // Puzzle has Prime variables that are restricted to two digit primes
  PrimeCutsPuzzle() : super(List.from(twoDigitPrimes));

  Map<String, Variable> get primes => variableList.variables;
  List<int> get remainingPrimes => variableList.remainingValues;
  Set<String> updatePrimes(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  void addEntry(Clue inputClue) {
    var clue = inputClue as PrimeCutsEntry;
    super.addEntry(inputClue);
    primes[clue.prime] = PrimeVariable(clue.prime);
  }
}
