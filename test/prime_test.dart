import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('prime', 'lib/prime/prime_output.txt');
  });
}
