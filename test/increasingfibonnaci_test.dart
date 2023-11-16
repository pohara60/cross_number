import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    test_command('increasingfibonnaci',
        'lib/increasingfibonnaci/increasingfibonnaci_output.txt');
  });
}
