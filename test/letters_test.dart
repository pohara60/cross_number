import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('letters', 'lib/letters/letters_output.txt');
  });
}
