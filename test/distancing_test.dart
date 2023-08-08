import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('distancing', 'lib/distancing/distancing_output.txt');
  });
}
