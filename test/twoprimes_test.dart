import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('twoprimes', 'lib/twoprimes/twoprimes_output.txt');
  });
}
