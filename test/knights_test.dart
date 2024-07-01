import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('knights', 'lib/knights/knights_output.txt');
  });
}
