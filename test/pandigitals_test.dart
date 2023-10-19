import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('pandigitals', 'lib/pandigitals/pandigitals_output.txt');
  });
}
