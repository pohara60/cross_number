import 'package:crossnumber/primecuts/clue.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/clue.dart';
import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/set.dart';

class Prime {
  final String prime;
  late Set<int> _values;
  int? _value;
  Prime(this.prime) {
    _values = Set.from(twoDigitPrimes);
  }
  tryValue(int value) => _value = value;
  Set<int> get values => _value != null ? {_value!} : _values;
  set values(Set<int> values) => _values = values;
  String toString() {
    return values.toShortString();
  }
}

class PrimeCutsPuzzle extends Puzzle<PrimeCutsClue> {
  final Map<String, Prime> primes = {};
  final List<int> remainingPrimes = List.from(twoDigitPrimes);

  PrimeCutsPuzzle();

  void addClue(Clue inputClue) {
    var clue = inputClue as PrimeCutsClue;
    super.addClue(inputClue);
    primes[clue.prime] = Prime(clue.prime);
  }

  Set<String> updatePrimes(String prime, Set<int> possiblePrimes) {
    var updatedPrimes = <String>{};
    var possibleValues = this.primes[prime]!.values;
    var updated = updatePossible(possibleValues, possiblePrimes);
    if (updated) {
      updatedPrimes.add(prime);
      if (possibleValues.length == 1) {
        List<String> knownPrimes = [prime];
        int index = 0;
        while (index < knownPrimes.length) {
          String primeKey = knownPrimes[index];
          int primeValue = this.primes[primeKey]!.values.first;
          // Remove the known prime from all other prime possible values
          remainingPrimes.remove(primeValue);
          for (var entry in this.primes.entries) {
            if (entry.key != primeKey) {
              if (entry.value.values.remove(primeValue)) {
                updatedPrimes.add(entry.key);
                if (entry.value.values.length == 1) {
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
      text += '${entry.key}=${entry.value.values}\n';
    }
    text += 'RemainingPrimes: ${remainingPrimes.toString()}\n';
    return text;
  }

  // postProcessing() {}
}
