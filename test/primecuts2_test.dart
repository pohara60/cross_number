import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('primecuts2', 'lib/primecuts2/primecuts2_output.txt');
  });
}
