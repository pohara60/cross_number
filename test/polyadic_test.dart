import 'package:crossnumber/expression.dart';

void main() {
  printTokens(r'£gcd(A1,CD)');
  // printTokens(r'$prime 11');
  evaluate(r'£gcd(24,9)');
}

void evaluate(String text) {
  var exp = ExpressionEvaluator(text);
  var value = exp.evaluate();
  print('$text = $exp = $value');
}

void printTokens(String text) {
  var tokens = Scanner.generateTokens(text).toList();
  print(tokens);
}
