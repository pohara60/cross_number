import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('evenodder', 'lib/evenodder/evenodder_output.txt');
  });
}
