typedef GeneratorFunc = Iterable<int> Function(num min, num max);

class Generator {
  String name;
  GeneratorFunc func;
  Generator(this.name, this.func);
}

void initializeGenerators(Map<String, Generator> generators) {
  generators['integer'] = Generator('integer', generateIntegers);
  generators['prime'] = Generator('prime', generatePrimes);
}

Iterable<int> generateIntegers(num min, num max) sync* {
  for (var integer = min.toInt(); integer <= max.toInt(); integer++)
    yield integer;
}

Iterable<int> generatePrimes(num min, num max) sync* {
  var primes = getPrimesUpto(max.toInt());
  yield* primes.where((element) => element >= min && element <= max);
}

List<int> primes = [2, 3, 5, 7];
List<int> getPrimesUpto(limit) {
  var lo = primes.last ~/ 2;
  var hi = limit ~/ 2 - lo;
  if (hi <= 0) return primes;

  List<int> sieve = List.generate(hi, (i) => 2 * (lo + i) + 3);
  for (var i = 0; i < hi; i++) {
    if (sieve[i] != 0) {
      for (var p in primes) {
        if (sieve[i] % p == 0) {
          sieve[i] = 0;
        }
      }
    }
    if (sieve[i] != 0) {
      for (var j = i + 1; j < hi; j++) {
        if (sieve[j] % sieve[i] == 0) {
          sieve[j] = 0;
        }
      }
    }
  }
  primes.addAll(sieve.where((element) => element != 0 && element <= limit));
  return primes;
}
