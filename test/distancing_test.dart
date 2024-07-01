import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('distancing', 'lib/distancing/distancing_output.txt');
  });
}
