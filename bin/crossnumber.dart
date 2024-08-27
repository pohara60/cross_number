import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:crossnumber/abcd/abcd.dart';
import 'package:crossnumber/abcde/abcde.dart';
import 'package:crossnumber/almostfermat/almostfermat.dart';
import 'package:crossnumber/chessboard/chessboard.dart';
import 'package:crossnumber/columns/columns.dart';
import 'package:crossnumber/combinations/combinations.dart';
import 'package:crossnumber/couplets/couplets.dart';
import 'package:crossnumber/cubesandwich/cubesandwich.dart';

import 'package:crossnumber/dicenets/dicenets.dart';
import 'package:crossnumber/dicenets2/dicenets2.dart';
import 'package:crossnumber/dieanotherday/dieanotherday.dart';
import 'package:crossnumber/eraser/eraser.dart';
import 'package:crossnumber/evenodder/evenodder.dart';
import 'package:crossnumber/factors/factors.dart';
import 'package:crossnumber/fourseasons/fourseasons.dart';
import 'package:crossnumber/frequency/frequency.dart';
import 'package:crossnumber/inbetweeners/inbetweeners.dart';
import 'package:crossnumber/increasingfibonnaci/increasingfibonnaci.dart';
import 'package:crossnumber/increasingprime/increasingprime.dart';
import 'package:crossnumber/instruction/instruction.dart';
import 'package:crossnumber/knights/knights.dart';
import 'package:crossnumber/knights2/knights2.dart';
import 'package:crossnumber/no21/no21.dart';
import 'package:crossnumber/opposingdigitsum/opposingdigitsum.dart';
import 'package:crossnumber/pandigitals/pandigitals.dart';
import 'package:crossnumber/particular/particular.dart';
import 'package:crossnumber/partners/partners.dart';
import 'package:crossnumber/powerplay/powerplay.dart';
import 'package:crossnumber/primania/primania.dart';
import 'package:crossnumber/prime/prime.dart';
import 'package:crossnumber/primecuts/primecuts.dart';
import 'package:crossnumber/letters/letters.dart';
import 'package:crossnumber/distancing/distancing.dart';
import 'package:crossnumber/primecuts2/primecuts2.dart';
import 'package:crossnumber/primeknight/primeknight.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/root66/root66.dart';
import 'package:crossnumber/root66_2/root66_2.dart';
import 'package:crossnumber/sequences/sequences.dart';
import 'package:crossnumber/squarestriangles/squarestriangles.dart';
import 'package:crossnumber/sumsquares/sumsquares.dart';
import 'package:crossnumber/taketwoorthree/taketwoorthree.dart';
import 'package:crossnumber/tetromino/tetromino.dart';
import 'package:crossnumber/thirty/thirty.dart';
import 'package:crossnumber/transformation/transformation.dart';
import 'package:crossnumber/triangularpairs/triangularpairs.dart';
import 'package:crossnumber/twentyfive/twentyfive.dart';
import 'package:crossnumber/twoprimes/twoprimes.dart';
import 'package:crossnumber/undersix/undersix.dart';
import 'package:crossnumber/virus/virus.dart';
import 'package:crossnumber/wheels/wheels.dart';

const help = 'help';
const program = 'crossnumber';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var runner = CommandRunner('crossnumber', 'Cross Number helper.')
    ..addCommand(DiceNetsCommand())
    ..addCommand(PrimeCutsCommand())
    ..addCommand(LettersCommand())
    ..addCommand(DistancingCommand())
    ..addCommand(FrequencyCommand())
    ..addCommand(SequencesCommand())
    ..addCommand(EvenOdderCommand())
    ..addCommand(InstructionCommand())
    ..addCommand(Root66Command())
    ..addCommand(DiceNets2Command())
    ..addCommand(No21Command())
    ..addCommand(Root66_2Command())
    ..addCommand(PartnersCommand())
    ..addCommand(WheelsCommand())
    ..addCommand(PrimeCommand())
    ..addCommand(ChessboardCommand())
    ..addCommand(ParticularCommand())
    ..addCommand(PandigitalsCommand())
    ..addCommand(PrimeCuts2Command())
    ..addCommand(ABCDCommand())
    ..addCommand(ColumnsCommand())
    ..addCommand(KnightsCommand())
    ..addCommand(TwoPrimesCommand())
    ..addCommand(IncreasingFibonnaciCommand())
    ..addCommand(IncreasingPrimeCommand())
    ..addCommand(DieAnotherDayCommand())
    ..addCommand(ThirtyCommand())
    ..addCommand(CubeSandwichCommand())
    ..addCommand(PowerPlayCommand())
    ..addCommand(AlmostFermatCommand())
    ..addCommand(Knights2Command())
    ..addCommand(TwentyFiveCommand())
    ..addCommand(CoupletsCommand())
    ..addCommand(UnderSixCommand())
    ..addCommand(SumSquaresCommand())
    ..addCommand(CombinationsCommand())
    ..addCommand(TriangularPairsCommand())
    ..addCommand(PrimeKnightCommand())
    ..addCommand(FactorsCommand())
    ..addCommand(TransformationCommand())
    ..addCommand(SquaresTrianglesCommand())
    ..addCommand(OpposingDigitSumCommand())
    ..addCommand(EraserCommand())
    ..addCommand(PrimaniaCommand())
    ..addCommand(ABCDECommand())
    ..addCommand(TetrominoCommand())
    ..addCommand(FourSeasonsCommand())
    ..addCommand(VirusCommand())
    ..addCommand(TakeTwoOrThreeCommand());
  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    // Arguments exception
    print('$program: ${e.message}');
    print('');
    print(runner.usage);
  } catch (e) {
    print('$program: $e');
  }
}

class DiceNetsCommand extends Command {
  @override
  final name = 'dicenets';
  @override
  final description = 'solve hardcoded dicenets puzzle.';

  @override
  void run() {
    // Get and print solve
    final dn = DiceNets();
    dn.solve();
  }
}

class PrimeCutsCommand extends Command {
  @override
  final name = 'primecuts';
  @override
  final description = 'solve hardcoded primecuts puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = PrimeCuts();
    pc.solve();
  }
}

class LettersCommand extends Command {
  @override
  final name = 'letters';
  @override
  final description = 'solve hardcoded letters puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Letters();
    pc.solve();
  }
}

class DistancingCommand extends Command {
  @override
  final name = 'distancing';
  @override
  final description = 'solve hardcoded distancing puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Distancing();
    pc.solve();
  }
}

class FrequencyCommand extends Command {
  @override
  final name = 'frequency';
  @override
  final description = 'solve hardcoded frequency puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Frequency();
    pc.solve();
  }
}

class SequencesCommand extends Command {
  @override
  final name = 'sequences';
  @override
  final description = 'solve hardcoded sequences puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Sequences();
    pc.solve();
  }
}

class EvenOdderCommand extends Command {
  @override
  final name = 'evenodder';
  @override
  final description = 'solve hardcoded evenodder puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = EvenOdder();
    pc.solve();
  }
}

class InstructionCommand extends Command {
  @override
  final name = 'instruction';
  @override
  final description = 'solve hardcoded instruction puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Instruction();
    pc.solve();
  }
}

class Root66Command extends Command {
  @override
  final name = 'root66';
  @override
  final description = 'solve hardcoded root66 puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Root66();
    pc.solve();
  }
}

class DiceNets2Command extends Command {
  @override
  final name = 'dicenets2';
  @override
  final description = 'solve hardcoded dicenets puzzle - new version.';

  @override
  void run() {
    // Get and print solve
    try {
      final dn = DiceNets2();
      dn.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    }
  }
}

class No21Command extends Command {
  @override
  final name = 'no21';
  @override
  final description = 'solve hardcoded no21 puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = No21();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    }
  }
}

// ignore: camel_case_types
class Root66_2Command extends Command {
  @override
  final name = 'root66_2';
  @override
  final description = 'solve hardcoded root66_2 puzzle.';

  @override
  void run() {
    // Get and print solve
    final pc = Root66_2();
    pc.solve();
  }
}

class PartnersCommand extends Command {
  @override
  final name = 'partners';
  @override
  final description = 'solve hardcoded partners puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Partners();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    }
  }
}

class WheelsCommand extends Command {
  @override
  final name = 'wheels';
  @override
  final description = 'solve hardcoded wheels puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Wheels();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    }
  }
}

class PrimeCommand extends Command {
  @override
  final name = 'prime';
  @override
  final description = 'solve hardcoded prime puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Prime();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    }
  }
}

class ChessboardCommand extends Command {
  @override
  final name = 'chessboard';
  @override
  final description = 'solve hardcoded chessboard puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Chessboard();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    }
  }
}

class ParticularCommand extends Command {
  @override
  final name = 'particular';
  @override
  final description = 'solve hardcoded particular puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Particular();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    }
  }
}

class PandigitalsCommand extends Command {
  @override
  final name = 'pandigitals';
  @override
  final description = 'solve hardcoded pandigitals puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Pandigitals();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class PrimeCuts2Command extends Command {
  @override
  final name = 'primecuts2';
  @override
  final description = 'solve hardcoded primecuts2 puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = PrimeCuts2();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class ABCDCommand extends Command {
  @override
  final name = 'abcd';
  @override
  final description = 'solve hardcoded abcd puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = ABCD();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class ColumnsCommand extends Command {
  @override
  final name = 'columns';
  @override
  final description = 'solve hardcoded columns puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Columns();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class KnightsCommand extends Command {
  @override
  final name = 'knights';
  @override
  final description = 'solve hardcoded knights puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Knights();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class TwoPrimesCommand extends Command {
  @override
  final name = 'twoprimes';
  @override
  final description = 'solve hardcoded twoprimes puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = TwoPrimes();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class IncreasingFibonnaciCommand extends Command {
  @override
  final name = 'increasingfibonnaci';
  @override
  final description = 'solve hardcoded increasingfibonnaci puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = IncreasingFibonnaci();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class IncreasingPrimeCommand extends Command {
  @override
  final name = 'increasingprime';
  @override
  final description = 'solve hardcoded increasingprime puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = IncreasingPrime();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    }
  }
}

class DieAnotherDayCommand extends Command {
  @override
  final name = 'DieAnotherDay';
  @override
  final description = 'solve hardcoded DieAnotherDay puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = DieAnotherDay();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class ThirtyCommand extends Command {
  @override
  final name = 'Thirty';
  @override
  final description = 'solve hardcoded Thirty puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Thirty();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class CubeSandwichCommand extends Command {
  @override
  final name = 'CubeSandwich';
  @override
  final description = 'solve hardcoded CubeSandwich puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = CubeSandwich();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class PowerPlayCommand extends Command {
  @override
  final name = 'PowerPlay';
  @override
  final description = 'solve hardcoded PowerPlay puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = PowerPlay();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class AlmostFermatCommand extends Command {
  @override
  final name = 'AlmostFermat';
  @override
  final description = 'solve hardcoded AlmostFermat puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = AlmostFermat();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class Knights2Command extends Command {
  @override
  final name = 'Knights2';
  @override
  final description = 'solve hardcoded Knights2 puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Knights2();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class TwentyFiveCommand extends Command {
  @override
  final name = 'TwentyFive';
  @override
  final description = 'solve hardcoded TwentyFive puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = TwentyFive();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class CoupletsCommand extends Command {
  @override
  final name = 'Couplets';
  @override
  final description = 'solve hardcoded Couplets puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Couplets();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class UnderSixCommand extends Command {
  @override
  final name = 'UnderSix';
  @override
  final description = 'solve hardcoded UnderSix puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = UnderSix();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class SumSquaresCommand extends Command {
  @override
  final name = 'SumSquares';
  @override
  final description = 'solve hardcoded SumSquares puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = SumSquares();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class CombinationsCommand extends Command {
  @override
  final name = 'Combinations';
  @override
  final description = 'solve hardcoded Combinations puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Combinations();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class TriangularPairsCommand extends Command {
  @override
  final name = 'TriangularPairs';
  @override
  final description = 'solve hardcoded TriangularPairs puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = TriangularPairs();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class PrimeKnightCommand extends Command {
  @override
  final name = 'PrimeKnight';
  @override
  final description = 'solve hardcoded PrimeKnight puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = PrimeKnight();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class FactorsCommand extends Command {
  @override
  final name = 'Factors';
  @override
  final description = 'solve hardcoded Factors puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Factors();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class TransformationCommand extends Command {
  @override
  final name = 'Transformation';
  @override
  final description = 'solve hardcoded Transformation puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Transformation();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class InbetweenersCommand extends Command {
  @override
  final name = 'Inbetweeners';
  @override
  final description = 'solve hardcoded Inbetweeners puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Inbetweeners();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class SquaresTrianglesCommand extends Command {
  @override
  final name = 'SquaresTriangles';
  @override
  final description = 'solve hardcoded SquaresTriangles puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = SquaresTriangles();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class OpposingDigitSumCommand extends Command {
  @override
  final name = 'OpposingDigitSum';
  @override
  final description = 'solve hardcoded OpposingDigitSum puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = OpposingDigitSum();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class EraserCommand extends Command {
  @override
  final name = 'Eraser';
  @override
  final description = 'solve hardcoded Eraser puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Eraser();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class ABCDECommand extends Command {
  @override
  final name = 'ABCDE';
  @override
  final description = 'solve hardcoded ABCDE puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = ABCDE();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class PrimaniaCommand extends Command {
  @override
  final name = 'Primania';
  @override
  final description = 'solve hardcoded Primania puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Primania();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class TetrominoCommand extends Command {
  @override
  final name = 'Tetromino';
  @override
  final description = 'solve hardcoded Tetromino puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Tetromino();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class FourSeasonsCommand extends Command {
  @override
  final name = 'FourSeasons';
  @override
  final description = 'solve hardcoded FourSeasons puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = FourSeasons();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class VirusCommand extends Command {
  @override
  final name = 'Virus';
  @override
  final description = 'solve hardcoded Virus puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = Virus();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}

class TakeTwoOrThreeCommand extends Command {
  @override
  final name = 'TakeTwoOrThree';
  @override
  final description = 'solve hardcoded TakeTwoOrThree puzzle.';

  @override
  void run() {
    // Get and print solve
    try {
      final pc = TakeTwoOrThree();
      pc.solve();
    } on PuzzleException catch (e) {
      print(e.msg);
    } on SolveException catch (e) {
      print(e.msg);
    } on SolveError catch (e) {
      print(e.msg);
    } catch (e) {
      print('Exception ${e.toString()}');
    }
  }
}
