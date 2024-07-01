import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('frequency', 'lib/frequency/frequency_output.txt');
  });
}
