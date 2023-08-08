import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('primecuts', 'lib/primecuts/primecuts_output.txt');
  });
}
