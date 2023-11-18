// Test of Clue/Entry refactoring

// ignore_for_file: unused_field

import 'package:crossnumber/expression.dart';
import 'package:crossnumber/variable.dart';
import 'package:powers/powers.dart';

class Variable {
  final String name;
  late Set<int>? _values;
  int? _tryValue;

  Variable(this.name);
}

class VariableRef {
  final String name;
  Variable? variable;
  bool get isVariable => variable != null && !(variable is Clue);
  bool get isClue =>
      variable != null && variable is Clue && !(variable is Entry);
  bool get isGridEntry => variable != null && variable is Entry;

  VariableRef(this.name);
}

class VariableRefList {
  final _references = <VariableRef>[];
  List<String> get names => _references.map((r) => r.name).toList();
  List<String> get variableNames =>
      _references.where((r) => r.isVariable).map((r) => r.name).toList();
  List<String> get clueNames =>
      _references.where((r) => r.isClue).map((r) => r.name).toList();
  List<Variable> get variables => _references
      .where((r) => r.isVariable)
      .map((r) => r.variable as Variable)
      .toList();
  List<Clue> get clues => _references
      .where((r) => r.isClue)
      .map((r) => r.variable as Clue)
      .toList();
}

class Clue extends Variable {
  final int length;
  late int min, max;
  final String? valueDesc;

  final _variableRefs = VariableRefList();
  List<String> get variableReferences => _variableRefs.variableNames;
  List<String> get clueReferences => _variableRefs.clueNames;
  List<String> get variableClueReferences => _variableRefs.names;
  bool circularClueReference = false;
  final SolveFunction? solve;

  // Mapped grid entry
  Clue? _entry;
  Clue? get entry => _entry;
  List<DigitIdentity?> get digitIdentities => entry!.digitIdentities;
  List<Entry> get referrers => entry!.referrers;
  List<Set<int>> get digits => entry!.digits;

  Clue({
    required String name,
    required int this.length,
    String? this.valueDesc,
    SolveFunction? this.solve,
  }) : super(name) {
    min = 10.pow(length - 1) as int;
    max = (10.pow(length) as int) - 1;
  }

  bool get isAcross => this.name[0] == 'A';
  bool get isDown => this.name[0] == 'D';

  int get lo => 10.pow(length - 1) as int;
  int get hi => (10.pow(length) as int) - 1;
  Iterable<int> get range =>
      Iterable<int>.generate(hi - lo + 1, (index) => lo + index);

  Set<int>? _restrictedValues;

  toString() => '$runtimeType $name';
}

class VariableClue extends Clue {
  VariableClue(
      {required String name,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(
            name: name, length: length!, valueDesc: valueDesc, solve: solve) {}
  int count = 0;
  toString() => '$runtimeType $name';
}

mixin Expression {
  late ExpressionEvaluator exp;

  void initExpression(
      String? valueDesc, variablePrefix, String name, Clue clue) {
    if (valueDesc != null && valueDesc != '') {
      try {
        exp = ExpressionEvaluator(valueDesc, variablePrefix);
        // for (var variableName in exp.variableRefs..sort()) {
        //   clue.addVariableReference(variableName);
        // }
        // for (var clueName in exp.clueRefs..sort()) {
        //   clue.addClueReference(clueName);
        // }
      } on ExpressionError catch (e) {
        throw ExpressionError('$name expression $valueDesc error ${e.msg}');
      }
    }
  }
}

class ExpressionClue extends VariableClue with Expression {
  late ExpressionEvaluator exp;

  ExpressionClue(
      {required String name,
      required int length,
      String? valueDesc,
      SolveFunction? solve,
      variablePrefix = ''})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initExpression(valueDesc, variablePrefix, name, this);
  }
  toString() => '$runtimeType $name';
}

class DigitIdentity {
  // The referenced clue
  final EntryMixin entry;
  final int digit;

  Clue get clue => entry._clue!;

  DigitIdentity({
    required this.entry,
    required this.digit,
  });

  String toString() {
    return '$entry[$digit]';
  }
}

mixin EntryMixin on Clue {
  /// Common digits with other clues: each digit has optional reference to clue and digit
  late final List<DigitIdentity?> digitIdentities;

  /// Computed - Possible digits
  late final List<Set<int>> digits;

  // Mapped Clue
  Clue? _clue;
  Clue? get clue => _clue;
  void initEntry(Clue entry) {
    digitIdentities = List.filled(entry.length, null);
    digits = [];
    // Self-reference to make Clue methods work
    entry._entry = entry;
  }
}

class Entry extends Clue with EntryMixin {
  Entry(
      {required String name,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(name: name, length: length!, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}

class VariableEntry extends VariableClue with EntryMixin {
  VariableEntry(
      {required String name,
      required int? length,
      String? valueDesc,
      SolveFunction? solve})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }

  // addVariableReference(String variable) {
  //   _variableRefs.addReference(variable);
  // }
}

class ExpressionEntry extends ExpressionClue with EntryMixin {
  ExpressionEntry(
      {required String name,
      required int length,
      String? valueDesc,
      SolveFunction? solve,
      variablePrefix = ''})
      : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}

class Puzzle<ClueKind extends Clue, EntryKind extends ClueKind> {
  final _clues = <String, ClueKind>{};
  final _entries = <String, EntryKind>{};
  Map<String, ClueKind> get clues => _clues.isNotEmpty ? _clues : _entries;
  Map<String, EntryKind> get entries => _entries;
  // Grid? grid;

  Puzzle() {}
  Puzzle.grid(List<String> gridString) {
    // this.grid = Grid(gridString);
  }

  void addClue(ClueKind clue) {
    clues[clue.name] = clue;
  }

  void addEntry(EntryKind entry) {
    entries[entry.name] = entry;
  }

  String toString() {
    var text = 'Puzzle\n';
    for (var clue in clues.values) {
      text += clue.toString() + '\n';
    }
    return text;
  }
}

class Crossnumber<PuzzleKind extends Puzzle<Clue, Clue>> {
  late PuzzleKind puzzle;

  Crossnumber();

  void initCrossnumber() {
    print(puzzle.toString());
  }
}

class DiceNets extends Crossnumber<DiceNetsPuzzle> {
  DiceNets() {
    puzzle = DiceNetsPuzzle();
    initCrossnumber();
  }
}

class DiceNetsPuzzle extends Puzzle<DiceNetsClue, DiceNetsEntry> {
  DiceNetsPuzzle() {
    // Clue.maxDigit = 6;
  }
}

class DiceNetsClue extends Clue {
  DiceNetsClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length!, valueDesc: valueDesc, solve: solve);
}

class DiceNetsEntry extends DiceNetsClue with EntryMixin {
  DiceNetsEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length!, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}

class Instruction extends Crossnumber<InstructionPuzzle> {
  Instruction() {
    puzzle = InstructionPuzzle();
    initCrossnumber();
  }
}

class InstructionPuzzle extends Puzzle<InstructionClue, InstructionEntry> {
  InstructionPuzzle() {
    // Clue.maxDigit = 6;
  }
}

class InstructionClue extends ExpressionClue {
  InstructionClue({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length!, valueDesc: valueDesc, solve: solve);
}

class InstructionEntry extends InstructionClue with EntryMixin {
  InstructionEntry({
    required String name,
    required int? length,
    String? valueDesc,
    SolveFunction? solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve) {
    initEntry(this);
  }
}

void main(List<String> args) {
  var dicenets = DiceNets();
  var a1 = DiceNetsEntry(name: "A1", length: 2, valueDesc: "", solve: null);
  dicenets.puzzle.addEntry(a1);
  dicenets.puzzle.entries[a1.name] = a1;
  print(dicenets.puzzle.toString());
  var instructions = Instruction();
  var d1 = InstructionEntry(name: "D1", length: 2, valueDesc: "", solve: null);
  instructions.puzzle.addEntry(d1);
  instructions.puzzle.entries[d1.name] = d1;
  print(instructions.puzzle.toString());
}
