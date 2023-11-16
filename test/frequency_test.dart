import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('frequency', 'lib/frequency/frequency_output.txt');
  });
}
