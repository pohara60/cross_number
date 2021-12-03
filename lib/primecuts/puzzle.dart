import 'package:crossnumber/primecuts/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/variable.dart';

class Prime extends Variable {
  Prime(prime) : super(prime) {
    this.values = Set.from(twoDigitPrimes);
  }
  String get prime => this.name;
}

class PrimeCutsPuzzle extends Puzzle<PrimeCutsClue> {
  // Puzzle has Prime variables that are restricted to two digit primes
  late final VariableList variableList;
  PrimeCutsPuzzle() {
    variableList = VariableList<Prime>(List.from(twoDigitPrimes));
  }

  Map<String, Variable> get primes => variableList.variables;
  List<int> get remainingPrimes => variableList.remainingValues;
  Set<String> updatePrimes(String letter, Set<int> possibleDigits) =>
      variableList.updateVariables(letter, possibleDigits);

  void addClue(Clue inputClue) {
    var clue = inputClue as PrimeCutsClue;
    super.addClue(inputClue);
    primes[clue.prime] = Prime(clue.prime);
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    text += 'Primes:\n';
    for (var entry in primes.entries) {
      text += '${entry.key}=${entry.value.values}\n';
    }
    text += 'RemainingPrimes: ${remainingPrimes.toString()}\n';
    return text;
  }

  // postProcessing() {}
}
