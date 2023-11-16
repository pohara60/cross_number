import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command(
        'increasingprime', 'lib/increasingprime/increasingprime_output.txt');
  });
}
