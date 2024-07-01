import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('primecuts', 'lib/primecuts/primecuts_output.txt');
  });
}
