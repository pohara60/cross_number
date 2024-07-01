import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('pandigitals', 'lib/pandigitals/pandigitals_output.txt');
  });
}
