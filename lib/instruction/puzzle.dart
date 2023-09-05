import '../instruction/clue.dart';
import '../puzzle.dart';

class InstructionPuzzle extends Puzzle<InstructionClue, InstructionEntry> {
  InstructionPuzzle();
  InstructionPuzzle.grid(List<String> gridString) : super.grid(gridString);
}
