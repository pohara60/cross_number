import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand(
        'increasingprime', 'lib/increasingprime/increasingprime_output.txt');
  });
}
