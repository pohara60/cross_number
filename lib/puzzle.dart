import 'package:crossnumber/clue.dart';

class Puzzle {
  covariant late Map<String, Clue> clues;

  Puzzle() {}

  void addClue(Clue clue) {
    clues[clue.name] = clue;
  }

  // clue1[digit1-1] = clue2[digit2-1]
  void addDigitIdentity(Clue clue1, int digit1, Clue clue2, int digit2) {
    clue1.digitIdentities[digit1 - 1] =
        DigitIdentity(clue: clue2, digit: digit2 - 1);
    clue2.digitIdentities[digit2 - 1] =
        DigitIdentity(clue: clue1, digit: digit1 - 1);
    clue2.addReferrer(clue1);
    clue1.addReferrer(clue2);
  }

  /// clue1 refers to clue2
  void addReference(Clue clue1, Clue clue2, [bool symmetric = false]) {
    clue2.addReferrer(clue1);
    if (symmetric) {
      clue1.addReferrer(clue2);
    }
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    return text;
  }

  String toSummary() {
    var text = 'Puzzle Summary\n';
    for (var clue in clues.values) {
      text += clue.toSummary() + '\n';
    }
    return text;
  }

  List<int> knownValues = [];

  bool updateValues(Clue clue, Set<int> possibleValue) {
    possibleValue.removeAll(knownValues);
    var updated = clue.updateValues(possibleValue);
    if (possibleValue.length == 1) {
      knownValues.addAll(possibleValue);
    }
    return updated;
  }

  postProcessing() {}
}

class Answer {
  List<int> possible;
  int? value;
  Answer(this.possible) {
    if (this.possible.length == 1) {
      this.value = this.possible[0];
    }
  }
}
