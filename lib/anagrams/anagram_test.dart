import 'package:trotter/trotter.dart';

var a12 = [0, 6, 0, 0, 8, 0];
var a14 = [0, 2, 0, 0, 1, 0];
var d7 = [0, 6, 0, 0, 4, 0];
var d8 = [0, 1, 0, 0, 8, 0];

var a12Anagram = [0, 7, 0, 0, 8, 0];
var a14Anagram = [0, 7, 0, 0, 1, 0];
var d7Anagram = [0, 7, 0, 0, 0, 0];
var d8Anagram = [0, 1, 0, 0, 8, 0];

/* JS
let f =
_=>[...Array(1e6).keys(F=i=>[...i+''].sort()+0)].filter(n=>n*(R=i=>F(n/i--)==F(n)||R(i)%i)(9))
console.dir(f, { maxArrayLength: null });

Output:
[
    3105,   7128,   7425,   8316,   8712,   9513,   9801,  30105,  31050,  37125,
   42741,  44172,  67128,  70416,  71208,  71253,  71280,  71328,  71928,  72108,
   72441,  74142,  74250,  74628,  74925,  78912,  79128,  80712,  81816,  82755,
   83160,  83181,  83916,  84510,  85725,  86712,  87120,  87132,  87192,  87912,
   89154,  90321,  90801,  91152,  91203,  93513,  94041,  94143,  95130,  95193,
   95613,  95832,  98010,  98091,  98901, 251748, 257148, 285174, 285714, 300105,
  301050, 307125, 310284, 310500, 321705, 341172, 342711, 370521, 371142, 371250,
  371628, 371925, 372411, 384102, 403515, 405135, 410256, 411372, 411723, 415368,
  415380, 415638, 419076, 419580, 420741, 421056, 423711, 425016, 427113, 427410,
  427491, 428571, 430515, 431379, 431568, 435105, 436158, 441072, 441720, 449172,
  451035, 451305, 458112, 461538, 463158, 471852, 475281, 501624, 502416, 504216,
  512208, 512820, 517428, 517482, 517725, 525771, 527175, 561024, 562104, 568971,
  571428, 571482, 581124, 589761, 615384, 619584, 620379, 620568, 623079, 625128,
  641088, 667128, 670416, 671208, 671280, 671328, 671928, 672108, 678912, 679128,
  681072, 691872, 692037, 692307, 704016, 704136, 704160, 704196, 705213, 705321,
  706416, 711342, 711423, 712008, 712080, 712503, 712530, 712800, 713208, 713280,
  713328, 713748, 714285, 716283, 717948, 719208, 719253, 719280, 719328, 719928,
  720108, 720441, 721068, 721080, 721308, 721602, 723411, 724113, 724410, 724491,
  728244, 730812, 731892, 732108, 741042, 741285, 741420, 742284, 742500, 744822,
  746280, 746928, 749142, 749250, 749628, 749925, 753081, 754188, 755271, 760212,
  761082, 761238, 761904, 771525, 772551, 779148, 783111, 786912, 789120, 789132,
  789192, 789312, 790416, 791208, 791280, 791328, 791928, 792108, 798912, 799128,
  800712, 806712, 807120, 807132, 807192, 807912, 814752, 816816, 818160, 818916,
  820512, 822744, 823716, 824472, 825174, 825714, 827550, 827658, 827955, 829467,
  830412, 831117, 831600, 831762, 831810, 831831, 839160, 839181, 839916, 840510,
  841023, 841104, 843102, 845100, 845910, 847422, 851148, 851220, 851742, 852471,
  857142, 857250, 857628, 857925, 862512, 862758, 862947, 865728, 866712, 867120,
  867132, 867192, 867912, 871200, 871320, 871332, 871425, 871920, 871932, 871992,
  874125, 879120, 879132, 879192, 879912, 888216, 891054, 891540, 891594, 891723,
  892755, 894510, 895725, 899154, 900801, 901152, 903021, 903210, 903231, 904041,
  908010, 908091, 908901, 909321, 910203, 911043, 911358, 911520, 911736, 911952,
  912030, 912093, 912303, 916083, 920241, 920376, 923076, 923580, 925113, 925614,
  930321, 931176, 931203, 933513, 934143, 935130, 935193, 935613, 935832, 940410,
  940491, 941430, 941493, 941652, 943137, 943173, 951300, 951588, 951930, 951993,
  952380, 956130, 956193, 956613, 958032, 958320, 958332, 958392, 958632, 958716,
  959832, 960741, 962037, 962307, 970137, 971028, 980100, 980910, 980991, 989010,
  989091, 989901
]
*/

void main(List<String> args) {
  // var start = 100000;
  // var end = 500000; // Start checking from 1000000
  var start = 100000;
  var end = 500000;
  var chunkSize = 1000;
  while (start < end) {
    var max = start + chunkSize; // Check 1000 numbers at a time
    if (max > end) max = end;
    checkNumber(start, max); // Start checking from 100000
    start = max;
  }
}

void checkNumber(int number, int max) {
  if (number >= max) return;
  var string = number.toString();
  var list = string.split('').toList();
  var seenPermutations = <int>{};
  for (var perm in getPermutations(list)) {
    if (int.parse(perm[0]) <= int.parse(list[0]))
      continue; // Anagram must be greater than original
    var value = int.parse(perm.join(''));
    if (seenPermutations.contains(value)) continue; // Skip duplicates
    if (value % number == 0) {
      print('Found anagram: $value is a multiple of $number');
    }
    seenPermutations.add(value);
  }
  checkNumber(number + 1, max);
}

Iterable<List<String>> getPermutations(List<String> items) sync* {
  if (items.isEmpty) {
    yield [];
  } else {
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      var remaining = List<String>.from(items)..removeAt(i);
      for (var perm in getPermutations(remaining)) {
        yield [item, ...perm];
      }
    }
  }
}

old() {
  // Try every combination of initial values
  for (var a12d1 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
    for (var a12d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      a12[1] = a12d1;
      a12[4] = a12d4;
      for (var a14d1 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
        for (var a14d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
          a14[1] = a14d1;
          a14[4] = a14d4;
          for (var d7d1 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
            for (var d7d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
              d7[1] = d7d1;
              d7[4] = d7d4;
              for (var d8d1 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
                for (var d8d4 in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
                  d8[1] = d8d1;
                  d8[4] = d8d4;
                  // Check entries
                  checkEntries(a12, a14, d7, d8, a12Anagram, a14Anagram,
                      d7Anagram, d8Anagram);
                }
              }
            }
          }
        }
      }
    }
  }
}

void checkEntries(
    List<int> a12Digits,
    List<int> a14Digits,
    List<int> d7Digits,
    List<int> d8Digits,
    List<int> a12DigitsAnagram,
    List<int> a14DigitsAnagram,
    List<int> d7DigitsAnagram,
    List<int> d8DigitsAnagram) {
  // Try possible values for original values and permutations
  var knownValues = <int>[];
  var a12Amalgams = Amalgams(4, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
  for (final a12Amalgam in a12Amalgams()) {
    for (var a12Digit in [0, 2, 3, 5]) {
      var a12AmalgamDigit = a12Digit == 0
          ? 0
          : a12Digit == 5
              ? 3
              : a12Digit - 1;
      var a12DigitValue = a12Amalgam[a12AmalgamDigit];
      if (a12Digit == 0 && (a12DigitValue == 0 || a12DigitValue > 4)) {
        break; // Skip if leading zero or too big for anagram multiple
      }
      a12Digits[a12Digit] = a12DigitValue;
      if (a12Digit == 5) {
        var a12Value = int.parse(a12Digits.join());
        // Check that known Anagram digits are in new values
        if (!a12Digits.contains(a12DigitsAnagram[1]) ||
            !a12Digits.contains(a12DigitsAnagram[4])) {
          break; // Skip if anagram digits are not present
        }
        knownValues.add(a12Value);
        // Set intersecting digits
        d7Digits[2] = a12Digits[2];
        d8Digits[2] = a12Digits[3];

        for (var a12AnagramValue in getAnagram(a12Digits, a12DigitsAnagram)) {
          if (knownValues.contains(a12AnagramValue)) {
            continue; // Skip known values
          }
          var anagramString = a12AnagramValue.toString();
          var anagramDigits = anagramString.split('').map(int.parse).toList();
          for (var a12AnagramDigit in [0, 2, 3, 5]) {
            var a12AnagramDigitValue = anagramDigits[a12AnagramDigit];
            a12DigitsAnagram[a12AnagramDigit] = a12AnagramDigitValue;
          }
          knownValues.add(a12AnagramValue);
          // Set intersecting digits
          d7DigitsAnagram[2] = a12DigitsAnagram[2];
          d8DigitsAnagram[2] = a12DigitsAnagram[3];

          // Try possible values for a8
          var a14Amalgams = Amalgams(4, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
          for (final a14Amalgam in a14Amalgams()) {
            for (var a14Digit in [0, 2, 3, 5]) {
              var a14AmalgamDigit = a14Digit == 0
                  ? 0
                  : a14Digit == 5
                      ? 3
                      : a14Digit - 1;
              var a14DigitValue = a14Amalgam[a14AmalgamDigit];
              if (a14Digit == 0 && (a14DigitValue == 0 || a14DigitValue > 4)) {
                break; // Skip if leading zero or too big for anagram multiple
              }
              a14Digits[a14Digit] = a14DigitValue;
              if (a14Digit == 5) {
                var a14Value = int.parse(a14Digits.join());
                // Check that known Anagram digits are in new values
                if (!a14Digits.contains(a14DigitsAnagram[1]) ||
                    !a14Digits.contains(a14DigitsAnagram[4])) {
                  break; // Skip if anagram digits are not present
                }
                if (knownValues.contains(a14Value)) {
                  break; // Skip known values
                }
                knownValues.add(a14Value);
                // Set intersecting digits
                d7Digits[3] = a14Digits[2];
                d8Digits[3] = a14Digits[3];
                for (var a14AnagramValue
                    in getAnagram(a14Digits, a14DigitsAnagram)) {
                  if (knownValues.contains(a14AnagramValue)) {
                    continue; // Skip known values
                  }
                  var anagramString = a14AnagramValue.toString();
                  var anagramDigits =
                      anagramString.split('').map(int.parse).toList();
                  for (var a14AnagramDigit in [0, 2, 3, 5]) {
                    var a14AnagramDigitValue = anagramDigits[a14AnagramDigit];
                    a14DigitsAnagram[a14AnagramDigit] = a14AnagramDigitValue;
                  }
                  knownValues.add(a14AnagramValue);
                  // Set intersecting digits
                  d7DigitsAnagram[3] = a14DigitsAnagram[2];
                  d8DigitsAnagram[3] = a14DigitsAnagram[3];

                  // Try possible values for d7
                  var d7Amalgams = Amalgams(2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
                  for (final d7Amalgam in d7Amalgams()) {
                    for (var d7Digit in [0, 5]) {
                      var d7AmalgamDigit = d7Digit == 0 ? 0 : 1;
                      var d7DigitValue = d7Amalgam[d7AmalgamDigit];
                      if (d7Digit == 0 &&
                          (d7DigitValue == 0 || d7DigitValue > 4)) {
                        break; // Skip if leading zero or too big for anagram multiple
                      }
                      d7Digits[d7Digit] = d7DigitValue;
                      if (d7Digit == 5) {
                        // Check that known Anagram digits are in new values
                        if (!d7Digits.contains(d7DigitsAnagram[1]) ||
                            !d7Digits.contains(d7DigitsAnagram[4])) {
                          break; // Skip if anagram digits are not present
                        }
                        var d7Value = int.parse(d7Digits.join());
                        if (knownValues.contains(d7Value)) {
                          break; // Skip known values
                        }
                        knownValues.add(d7Value);
                        for (var d7AnagramValue in getAnagram(
                            d7Digits, d7DigitsAnagram,
                            isDown: true)) {
                          if (knownValues.contains(d7AnagramValue)) {
                            continue; // Skip known values
                          }
                          var anagramString = d7AnagramValue.toString();
                          var anagramDigits =
                              anagramString.split('').map(int.parse).toList();
                          for (var d7AnagramDigit in [0, 5]) {
                            var d7AnagramDigitValue =
                                anagramDigits[d7AnagramDigit];
                            d7DigitsAnagram[d7AnagramDigit] =
                                d7AnagramDigitValue;
                          }
                          knownValues.add(d7AnagramValue);
                          // Try possible values for d8
                          var d8Amalgams =
                              Amalgams(2, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
                          for (final d8Amalgam in d8Amalgams()) {
                            for (var d8Digit in [0, 5]) {
                              var d8AmalgamDigit = d8Digit == 0 ? 0 : 1;
                              var d8DigitValue = d8Amalgam[d8AmalgamDigit];
                              if (d8Digit == 0 &&
                                  (d8DigitValue == 0 || d8DigitValue > 4)) {
                                break; // Skip if leading zero or too big for anagram multiple
                              }
                              d8Digits[d8Digit] = d8DigitValue;
                              if (d8Digit == 5) {
                                if (!d8Digits.contains(d8DigitsAnagram[1]) ||
                                    !d8Digits.contains(d8DigitsAnagram[4])) {
                                  break; // Skip if anagram digits are not present
                                }
                                var d8Value = int.parse(d8Digits.join());
                                if (knownValues.contains(d8Value)) {
                                  break; // Skip known values
                                }
                                knownValues.add(d8Value);

                                for (var d8AnagramValue in getAnagram(
                                    d8Digits, d8DigitsAnagram,
                                    isDown: true)) {
                                  if (knownValues.contains(d8AnagramValue)) {
                                    continue; // Skip known values
                                  }
                                  var anagramString = d8AnagramValue.toString();
                                  var anagramDigits = anagramString
                                      .split('')
                                      .map(int.parse)
                                      .toList();
                                  for (var d8AnagramDigit in [0, 5]) {
                                    var d8AnagramDigitValue =
                                        anagramDigits[d8AnagramDigit];
                                    d8DigitsAnagram[d8AnagramDigit] =
                                        d8AnagramDigitValue;
                                  }
                                  knownValues.add(d8AnagramValue);

                                  // Found a valid anagram set
                                  print('Values=$knownValues');

                                  knownValues.removeLast();
                                }
                                knownValues.removeLast();
                              }
                            }
                          }
                          knownValues.removeLast();
                        }
                        knownValues.removeLast();
                      }
                    }
                  }
                  knownValues.removeLast();
                }
                knownValues.removeLast();
              }
            }
          }
          knownValues.removeLast();
        }
        knownValues.removeLast();
      }
    }
  }
}

Iterable<int> getAnagram(List<int> digits, List<int> digitsAnagram,
    {bool isDown = false}) sync* {
  // Anagram is a multiple of the original value
  // Try multiples of the original value that are 6 digits long
  // Check if the anagram is a valid permutation of the original value
  // Check that known Anagram digits are in new values
  if (!digits.contains(digitsAnagram[1]) ||
      !digits.contains(digitsAnagram[4])) {
    return; // Skip if anagram digits are not present
  }
  if (isDown &&
      (!digits.contains(digitsAnagram[2]) ||
          !digits.contains(digitsAnagram[3]))) {
    return; // Skip if anagram digits are not present
  }
  for (var multiple in [2, 3, 4, 5, 6, 7, 8, 9]) {
    var value = int.parse(digits.join());
    var anagramValue = value * multiple;
    var anagramString = anagramValue.toString();
    var anagramStringLength = anagramString.length;
    if (anagramStringLength < 6) continue;
    if (anagramStringLength > 6) break;
    var anagramDigits = anagramString.split('').map(int.parse).toList();
    if (anagramDigits[1] == digitsAnagram[1] &&
        anagramDigits[4] == digitsAnagram[4] &&
        (!isDown ||
            (anagramDigits[2] == digitsAnagram[2] &&
                anagramDigits[3] == digitsAnagram[3]))) {
      if (isAnagram(digits, anagramDigits)) {
        yield anagramValue; // Yield valid anagram value
      }
    }
  }
}

bool isAnagram(List<int> digits, List<int> anagramDigits) {
  // Check if the anagramDigits are a valid permutation of the digits
  var digitCount = <int, int>{};
  for (var digit in digits) {
    digitCount[digit] = (digitCount[digit] ?? 0) + 1;
  }
  for (var anagramDigit in anagramDigits) {
    if (!digitCount.containsKey(anagramDigit) ||
        digitCount[anagramDigit]! <= 0) {
      return false; // Not a valid anagram
    }
    digitCount[anagramDigit] = digitCount[anagramDigit]! - 1;
  }
  return true; // Valid anagram
}

var possibleMultiples = {
  251748,
  257148,
  285174,
  285714,
  300105,
  301050,
  307125,
  310284,
  310500,
  321705,
  341172,
  342711,
  370521,
  371142,
  371250,
  371628,
  371925,
  372411,
  384102,
  403515,
  405135,
  410256,
  411372,
  411723,
  415368,
  415380,
  415638,
  419076,
  419580,
  420741,
  421056,
  423711,
  425016,
  427113,
  427410,
  427491,
  428571,
  430515,
  431379,
  431568,
  435105,
  436158,
  441072,
  441720,
  449172,
  451035,
  451305,
  458112,
  461538,
  463158,
  471852,
  475281,
  501624,
  502416,
  504216,
  512208,
  512820,
  517428,
  517482,
  517725,
  525771,
  527175,
  561024,
  562104,
  568971,
  571428,
  571482,
  581124,
  589761,
  615384,
  619584,
  620379,
  620568,
  623079,
  625128,
  641088,
  667128,
  670416,
  671208,
  671280,
  671328,
  671928,
  672108,
  678912,
  679128,
  681072,
  691872,
  692037,
  692307,
  704016,
  704136,
  704160,
  704196,
  705213,
  705321,
  706416,
  711342,
  711423,
  712008,
  712080,
  712503,
  712530,
  712800,
  713208,
  713280,
  713328,
  713748,
  714285,
  716283,
  717948,
  719208,
  719253,
  719280,
  719328,
  719928,
  720108,
  720441,
  721068,
  721080,
  721308,
  721602,
  723411,
  724113,
  724410,
  724491,
  728244,
  730812,
  731892,
  732108,
  741042,
  741285,
  741420,
  742284,
  742500,
  744822,
  746280,
  746928,
  749142,
  749250,
  749628,
  749925,
  753081,
  754188,
  755271,
  760212,
  761082,
  761238,
  761904,
  771525,
  772551,
  779148,
  783111,
  786912,
  789120,
  789132,
  789192,
  789312,
  790416,
  791208,
  791280,
  791328,
  791928,
  792108,
  798912,
  799128,
  800712,
  806712,
  807120,
  807132,
  807192,
  807912,
  814752,
  816816,
  818160,
  818916,
  820512,
  822744,
  823716,
  824472,
  825174,
  825714,
  827550,
  827658,
  827955,
  829467,
  830412,
  831117,
  831600,
  831762,
  831810,
  831831,
  839160,
  839181,
  839916,
  840510,
  841023,
  841104,
  843102,
  845100,
  845910,
  847422,
  851148,
  851220,
  851742,
  852471,
  857142,
  857250,
  857628,
  857925,
  862512,
  862758,
  862947,
  865728,
  866712,
  867120,
  867132,
  867192,
  867912,
  871200,
  871320,
  871332,
  871425,
  871920,
  871932,
  871992,
  874125,
  879120,
  879132,
  879192,
  879912,
  888216,
  891054,
  891540,
  891594,
  891723,
  892755,
  894510,
  895725,
  899154,
  900801,
  901152,
  903021,
  903210,
  903231,
  904041,
  908010,
  908091,
  908901,
  909321,
  910203,
  911043,
  911358,
  911520,
  911736,
  911952,
  912030,
  912093,
  912303,
  916083,
  920241,
  920376,
  923076,
  923580,
  925113,
  925614,
  930321,
  931176,
  931203,
  933513,
  934143,
  935130,
  935193,
  935613,
  935832,
  940410,
  940491,
  941430,
  941493,
  941652,
  943137,
  943173,
  951300,
  951588,
  951930,
  951993,
  952380,
  956130,
  956193,
  956613,
  958032,
  958320,
  958332,
  958392,
  958632,
  958716,
  959832,
  960741,
  962037,
  962307,
  970137,
  971028,
  980100,
  980910,
  980991,
  989010,
  989091,
  989901
};
