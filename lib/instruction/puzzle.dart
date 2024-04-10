import '../instruction/clue.dart';
import '../puzzle.dart';

class InstructionPuzzle extends Puzzle<InstructionClue, InstructionEntry> {
  InstructionPuzzle();
  InstructionPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(gridString);
}
