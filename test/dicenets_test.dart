import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('dicenets', 'lib/dicenets/dicenets_output.txt');
  });
}
