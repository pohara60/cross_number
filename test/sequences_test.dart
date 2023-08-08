import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('sequences', 'lib/sequences/sequences_output.txt');
  });
}
