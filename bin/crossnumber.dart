import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:crossnumber/dicenets/dicenets.dart';
import 'package:crossnumber/primecuts/primecuts.dart';

const help = 'help';
const program = 'crossnumber';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var runner = CommandRunner('crossnumber', 'Cross Number helper.')
    ..addCommand(DiceNetsCommand())
    ..addCommand(PrimeCutsCommand());
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
