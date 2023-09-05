import '../clue.dart';

/// A [PartnersPuzzle] clue
class PartnersClue extends ExpressionClue {
  final String symmetricName;
  PartnersClue(
      {required name,
      required this.symmetricName,
      required length,
      valueDesc,
      solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {}
}

class PartnersEntry extends PartnersClue with EntryMixin {
  PartnersEntry({
    required name,
    required symmetricName,
    required length,
    valueDesc,
    solve,
  }) : super(
            name: name,
            symmetricName: symmetricName,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
