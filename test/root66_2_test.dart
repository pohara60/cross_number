import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('root66_2', 'lib/root66_2/root66_2_output.txt');
    // test_command('root66', 'test/root66_output.txt');
  }, timeout: Timeout.factor(2));
}
