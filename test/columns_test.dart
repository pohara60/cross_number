import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('columns', 'lib/columns/columns_output.txt');
  });
}
