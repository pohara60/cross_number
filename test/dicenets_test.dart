import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('dicenets', 'lib/dicenets/dicenets_output.txt');
  });
}
