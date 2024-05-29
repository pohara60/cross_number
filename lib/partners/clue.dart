import '../clue.dart';
import '../variable.dart';

/// A [PartnersPuzzle] clue
class PartnersClue extends ExpressionClue {
  final String symmetricName;
  PartnersClue(
      {required name,
      VariableType type = VariableType.C,
      required this.symmetricName,
      required length,
      valueDesc,
      solve})
      : super(
            name: name,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {}
}

class PartnersEntry extends PartnersClue with EntryMixin {
  PartnersEntry({
    required name,
    VariableType type = VariableType.E,
    required symmetricName,
    required length,
    valueDesc,
    solve,
  }) : super(
            name: name,
            symmetricName: symmetricName,
            type: type,
            length: length,
            valueDesc: valueDesc,
            solve: solve) {
    initEntry(this);
  }
}
