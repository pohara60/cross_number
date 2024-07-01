import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('dicenets2', 'lib/dicenets2/dicenets2_output.txt');
  });
}
