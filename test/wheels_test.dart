import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('wheels', 'lib/wheels/wheels_output.txt');
  });
}
