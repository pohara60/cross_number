import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('knights', 'lib/knights/knights_output.txt');
  });
}
