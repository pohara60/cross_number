import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('twoprimes', 'lib/twoprimes/twoprimes_output.txt');
  });
}
