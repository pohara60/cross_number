import 'package:crossnumber/instruction/clue.dart';
import 'package:crossnumber/puzzle.dart';

class InstructionPuzzle extends Puzzle<InstructionClue, InstructionEntry> {
  InstructionPuzzle();
  InstructionPuzzle.grid(List<String> gridString) : super.grid(gridString);
}
