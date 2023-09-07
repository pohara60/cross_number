import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('partners', 'lib/partners/partners_output.txt');
  });
}
