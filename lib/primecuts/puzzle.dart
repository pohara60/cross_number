import 'package:crossnumber/primecuts/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';

class PrimeCutsPuzzle extends Puzzle {
  late Map<String, PrimeCutsClue> clues;
  final Map<String, Set<int>> primes = {};
  final List<int> remainingPrimes = List.from(twoDigitPrimes);

  PrimeCutsPuzzle();

  void addClue(Clue inputClue) {
    var clue = inputClue as PrimeCutsClue;
    super.addClue(inputClue);
    primes[clue.prime] = Set.from(twoDigitPrimes);
  }

  Set<String> updatePrimes(String prime, Set<int> possibleDigits) {
    var updatedPrimes = <String>{};
    var possiblePrimes = this.primes[prime]!;
    var updated = updatePossible(possiblePrimes, possibleDigits);
    if (updated) {
      updatedPrimes.add(prime);
      if (possiblePrimes.length == 1) {
        List<String> knownPrimes = [prime];
        int index = 0;
        while (index < knownPrimes.length) {
          String primeKey = knownPrimes[index];
          int primeValue = this.primes[primeKey]!.first;
          // Remove the known prime from all other prime possible values
          remainingPrimes.remove(primeValue);
          for (var entry in this.primes.entries) {
            if (entry.key != primeKey) {
              if (entry.value.remove(primeValue)) {
                updatedPrimes.add(entry.key);
                if (entry.value.length == 1) {
                  knownPrimes.add(entry.key);
                }
              }
            }
          }
          index++;
        }
      }
    }
    return updatedPrimes;
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    text += 'Primes:\n';
    for (var entry in primes.entries) {
      text += '${entry.key}=${entry.value}\n';
    }
    text += 'RemainingPrimes: ${remainingPrimes.toString()}\n';
    return text;
  }

  // postProcessing() {}
}
