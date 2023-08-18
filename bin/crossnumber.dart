import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:crossnumber/dicenets/dicenets.dart';
import 'package:crossnumber/dicenets2/dicenets2.dart';
import 'package:crossnumber/evenodder/evenodder.dart';
import 'package:crossnumber/frequency/frequency.dart';
import 'package:crossnumber/instruction/instruction.dart';
import 'package:crossnumber/primecuts/primecuts.dart';
import 'package:crossnumber/letters/letters.dart';
import 'package:crossnumber/distancing/distancing.dart';
import 'package:crossnumber/puzzle.dart';
import 'package:crossnumber/root66/root66.dart';
import 'package:crossnumber/sequences/sequences.dart';

const help = 'help';
const program = 'crossnumber';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var runner = CommandRunner('crossnumber', 'Cross Number helper.')
    ..addCommand(DiceNetsCommand())
    ..addCommand(DiceNets2Command())
    ..addCommand(PrimeCutsCommand())
    ..addCommand(LettersCommand())
    ..addCommand(DistancingCommand())
    ..addCommand(FrequencyCommand())
    ..addCommand(SequencesCommand())
    ..addCommand(EvenOdderCommand())
    ..addCommand(InstructionCommand())
    ..addCommand(Root66Command());
  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    // Arguments exception
    print('$program: ${e.message}');
    print('');
    print('${runner.usage}');
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
      print('${e.msg}');
    }
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
