import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('wheels', 'lib/wheels/wheels_output.txt');
  });
}
