import 'dart:io';

import 'package:crossnumber/crossnumber.dart';
import 'package:crossnumber/no21/puzzle.dart';

class No21 extends Crossnumber<No21Puzzle> {
  var gridString = [
    '+--+--+--+--+--+--+--+',
    '|1 :2 |3 :4 |5 :6 :  |',
    '+::+::+::+::+--+::+--+',
    '|7 :  :  |8 :  |9 :  |',
    '+::+--+::+::+--+::+--+',
    '|10:11|12:  |13:  :14|',
    '+--+::+--+::+::+--+::+',
    '|15:  :16:  :  :17:  |',
    '+::+--+::+::+--+::+--+',
    '|18:19:  |20:21|22:23|',
    '+--+::+--+::+::+--+::+',
    '|24:  |25:  |26:27:  |',
    '+--+::+--+::+::+::+::+',
    '|28:  :  |29:  |30:  |',
    '+--+--+--+--+--+--+--+',
  ];

  void initCrossnumber() {
    // D8 references all other cells!
    puzzle.addDigitIdentityFromGrid();

    super.initCrossnumber();
  }

  void printReferences() {
    var clues = puzzle.clues.values;
    for (var clue in clues) {
      stdout.write(clue.name);
      for (var otherClue in clues) {
        if (clue.referrers.contains(otherClue)) {
          stdout.write('\t${otherClue.name}');
        } else {
          stdout.write('\t');
        }
      }
      stdout.write('\n');
    }
  }

  void solve([bool iteration = true]) {
    print("SOLVE------------");

    super.solve(false);
  }
}
