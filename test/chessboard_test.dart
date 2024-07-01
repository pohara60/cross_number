import 'package:test/test.dart';
import 'test_util.dart';

void main() {
  group('Command line', () {
    testCommand('chessboard', 'lib/chessboard/chessboard_output.txt');
  });
}
