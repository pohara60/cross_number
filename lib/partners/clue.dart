import '../clue.dart';
import '../variable.dart';

/// A [PartnersPuzzle] clue
class PartnersClue extends ExpressionClue {
  final String symmetricName;
  PartnersClue(
      {required super.name,
      super.type = VariableType.C,
      required this.symmetricName,
      required super.length,
      super.valueDesc,
      super.solve});
}

class PartnersEntry extends PartnersClue with EntryMixin {
  PartnersEntry({
    required super.name,
    super.type = VariableType.E,
    required super.symmetricName,
    required super.length,
    super.valueDesc,
    super.solve,
  }) {
    initEntry(this);
  }
}
