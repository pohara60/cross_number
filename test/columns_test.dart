import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('columns', 'lib/columns/columns_output.txt');
  });
}
