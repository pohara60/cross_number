import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('sequences', 'lib/sequences/sequences_output.txt');
  });
}
