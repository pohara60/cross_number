import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('root66', 'lib/root66/root66_output.txt');
    // test_command('root66', 'test/root66_output.txt');
  }, timeout: Timeout.factor(2));
}
