import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('increasingfibonnaci',
        'lib/increasingfibonnaci/increasingfibonnaci_output.txt');
  });
}
