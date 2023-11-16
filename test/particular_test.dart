import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('particular', 'lib/particular/particular_output.txt');
  });
}
