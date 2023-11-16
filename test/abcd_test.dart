import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('abcd', 'lib/abcd/abcd_output.txt');
  });
}
