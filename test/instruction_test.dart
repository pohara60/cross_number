import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('instruction', 'lib/instruction/instruction_output.txt');
  });
}
