import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('abcd', 'lib/abcd/abcd_output.txt');
  });
}
