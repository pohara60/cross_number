import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('evenodder', 'lib/evenodder/evenodder_output.txt');
  });
}
