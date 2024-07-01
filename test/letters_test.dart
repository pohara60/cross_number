import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('letters', 'lib/letters/letters_output.txt');
  });
}
