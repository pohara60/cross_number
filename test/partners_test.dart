import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('partners', 'lib/partners/partners_output.txt');
  });
}
