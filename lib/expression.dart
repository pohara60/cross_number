// Evaluate expression strings, with variable references

// Token specification
import 'dart:math';

import 'generators.dart';
import 'monadic.dart';
import 'variable.dart';

mixin Expression {
  late ExpressionEvaluator exp;

  void initExpression(String? valueDesc, variablePrefix, String name,
      VariableRefList variableRefs) {
    if (valueDesc != null && valueDesc != '') {
      try {
        exp = ExpressionEvaluator(valueDesc, variablePrefix);
        for (var variableName in exp.variableRefs..sort()) {
          variableRefs.addVariableReference(variableName);
        }
        for (var clueName in exp.clueRefs..sort()) {
          variableRefs.addClueReference(clueName);
        }
      } on ExpressionError catch (e) {
        throw ExpressionError('$name expression $valueDesc error ${e.msg}');
      }
    }
  }
}

const NUM = 'NUM', NUM_RE = r'(?<' + NUM + r'>\d+)';
const PLUS = 'PLUS', PLUS_RE = r'(?<' + PLUS + r'>\+)';
const MINUS = 'MINUS', MINUS_RE = r'(?<' + MINUS + r'>-)';
const TIMES = 'TIMES', TIMES_RE = r'(?<' + TIMES + r'>\*)';
const DIVIDE = 'DIVIDE', DIVIDE_RE = r'(?<' + DIVIDE + r'>/)';
const MOD = 'MOD', MOD_RE = r'(?<' + MOD + r'>%)';
const ROOT = 'ROOT', ROOT_RE = r'(?<' + ROOT + r'>√)';
const FACTORIAL = 'FACTORIAL', FACTORIAL_RE = r'(?<' + FACTORIAL + r'>!)';
const REVERSE = 'REVERSE', REVERSE_RE = r'(?<' + REVERSE + r">')";
const EXPONENT = 'EXPONENT', EXPONENT_RE = r'(?<' + EXPONENT + r'>\^)';
const LPAREN = 'LPAREN', LPAREN_RE = r'(?<' + LPAREN + r'>\()';
const RPAREN = 'RPAREN', RPAREN_RE = r'(?<' + RPAREN + r'>\))';
const EQUAL = 'EQUAL', EQUAL_RE = r'(?<' + EQUAL + r'>=)';
const CLUE = 'CLUE', CLUE_RE = r'(?<' + CLUE + r'>E?[adAD]\d+)';
const VAR = 'VAR', VAR_RE = r'(?<' + VAR + r'>\w)';
const GENERATOR = 'GENERATOR', GENERATOR_RE = r'(?<' + GENERATOR + r'>\#\w+)';
const MONADIC = 'MONADIC', MONADIC_RE = r'(?<' + MONADIC + r'>\$\w+)';
const WS = 'WS', WS_RE = r'(?<' + WS + r'>\s+)';
const ERROR = 'ERROR', ERROR_RE = r'(?<' + ERROR + r'>.)';
var regExp = RegExp([
  NUM_RE,
  PLUS_RE,
  MINUS_RE,
  TIMES_RE,
  DIVIDE_RE,
  MOD_RE,
  ROOT_RE,
  FACTORIAL_RE,
  REVERSE_RE,
  EXPONENT_RE,
  LPAREN_RE,
  RPAREN_RE,
  EQUAL_RE,
  CLUE_RE,
  VAR_RE,
  GENERATOR_RE,
  MONADIC_RE,
  WS_RE,
  ERROR_RE,
].join('|'));

var generators = <String, Generator>{};
var monadics = <String, Monadic>{};

class Token {
  final String type;
  final String str;
  final int value;
  final String name;
  Token(this.str, this.type, {this.value = 0, this.name = ''});
  String toLongString() {
    return '$type' +
        (value != 0 ? '=${value.toString()}' : '') +
        (name != '' ? '=$name' : '');
  }

  String toString() => this.str;
}

class Scanner {
// Token Scanner

  static var initialized = false;

  static void initialize() {
    initializeGenerators(generators);
    initializeMonadics(monadics);
    initialized = true;
  }

  static void addGenerators(List<Generator> generatorList) {
    generatorList.forEach((generator) {
      generators[generator.name] = generator;
    });
  }

  static Iterable<Token?> generateTokens(String text,
      [String variablePrefix = '']) sync* {
    if (!initialized) initialize();
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    for (final m in matches) {
      var match = m[0];
      if (m.namedGroup(NUM) != null) {
        yield Token(match!, NUM, value: int.parse(match));
      }
      if (m.namedGroup(CLUE) != null) {
        yield Token(match!, CLUE, name: match.toUpperCase());
      }
      if (m.namedGroup(VAR) != null) {
        yield Token(match!, VAR, name: variablePrefix + match);
      }
      if (m.namedGroup(GENERATOR) != null) {
        var name = match!.substring(1).toLowerCase();
        if (generators.containsKey(name)) {
          yield Token(match, GENERATOR, name: name);
        } else {
          yield Token(match, ERROR, name: 'Unknown Generator $match');
        }
      }
      if (m.namedGroup(MONADIC) != null) {
        var name = match!.substring(1).toLowerCase();
        if (monadics.containsKey(name)) {
          yield Token(match, MONADIC, name: name);
        } else {
          yield Token(match, ERROR, name: 'Unknown Monadic $match');
        }
      }
      if (m.namedGroup(PLUS) != null) {
        yield Token(match!, PLUS);
      }
      if (m.namedGroup(TIMES) != null) {
        yield Token(match!, TIMES);
      }
      if (m.namedGroup(MINUS) != null) {
        yield Token(match!, MINUS);
      }
      if (m.namedGroup(DIVIDE) != null) {
        yield Token(match!, DIVIDE);
      }
      if (m.namedGroup(MOD) != null) {
        yield Token(match!, MOD);
      }
      if (m.namedGroup(ROOT) != null) {
        yield Token(match!, ROOT);
      }
      if (m.namedGroup(FACTORIAL) != null) {
        yield Token(match!, FACTORIAL);
      }
      if (m.namedGroup(REVERSE) != null) {
        yield Token(match!, REVERSE);
      }
      if (m.namedGroup(EXPONENT) != null) {
        yield Token(match!, EXPONENT);
      }
      if (m.namedGroup(LPAREN) != null) {
        yield Token(match!, LPAREN);
      }
      if (m.namedGroup(RPAREN) != null) {
        yield Token(match!, RPAREN);
      }
      if (m.namedGroup(EQUAL) != null) {
        yield Token(match!, EQUAL);
      }
      if (m.namedGroup(ERROR) != null) {
        throw ExpressionError('Invalid character ${text[m.start]}');
      }
    }
  }
}

// AST
enum NodeComplexity {
  SIMPLE, // No generator, so single valued
  GENERATOR, // This node generates multiple values
  GENERATOR_CHILD, // One child of this node generates multiple values
  GENERATOR_CHILDREN, // Multiple childen of this node generates multiple values
}

enum NodeOrder {
  SINGLE, // Single value
  ASCENDING, // Multiple values ascending
  DESCENDING, // Multiple values descending
  UNKNOWN, // Unknown order
}

class Node {
  final Token token;
  late NodeComplexity complexity;
  late NodeOrder order;
  List<Node>? operands;
  Node(this.token, [this.operands]) {
    nodeComplexity();
    nodeOrder();
  }

  void nodeOrder() {
    if (operands == null) {
      if (token.type == "GENERATOR") {
        // Assume all generators are ascending
        order = NodeOrder.ASCENDING;
      } else {
        order = NodeOrder.SINGLE;
      }
    } else if (operands!.length == 1) {
      var childOrder = operands!.first.order;
      //if (operands!.first.token.type==MINUS)
      order = childOrder;
      if (token.type == MONADIC) {
        var name = token.name;
        var monadic = monadics[name]!;
        if (monadic.type == Iterable<int>) {
          // Ascending generator functions
          if (order == NodeOrder.SINGLE && monadic != 'jumble')
            order = NodeOrder.ASCENDING;
          else
            order = NodeOrder.UNKNOWN;
        } else {
          // Non-generator functions that do not preserver operand order
          if (order != NodeOrder.SINGLE && ['ds', 'dp', 'mp'].contains(name))
            order = NodeOrder.UNKNOWN;
        }
      } else if (token.type == REVERSE) {
        order = NodeOrder.UNKNOWN;
      }
    } else {
      var childOrder1 = operands![0].order;
      var childOrder2 = operands![1].order;
      if (childOrder1 == NodeOrder.SINGLE && childOrder2 == NodeOrder.SINGLE)
        order = NodeOrder.SINGLE;
      else if (token.type == MINUS || token.type == DIVIDE) {
        if (childOrder1 == NodeOrder.SINGLE) {
          if (childOrder2 == NodeOrder.ASCENDING)
            order = NodeOrder.DESCENDING;
          else
            order = NodeOrder.ASCENDING;
        } else if (childOrder2 == NodeOrder.SINGLE)
          order = childOrder1;
        else
          order = NodeOrder.UNKNOWN;
      } else if (token.type == MOD) {
        order = NodeOrder.UNKNOWN;
      } else {
        if (childOrder1 == NodeOrder.SINGLE)
          order = childOrder2;
        else if (childOrder2 == NodeOrder.SINGLE)
          order = childOrder1;
        else
          order = NodeOrder.UNKNOWN;
      }
    }
  }

  void nodeComplexity() {
    if (operands == null) {
      if (token.type == "GENERATOR") {
        complexity = NodeComplexity.GENERATOR;
      } else {
        complexity = NodeComplexity.SIMPLE;
      }
    } else if (operands!.length == 1) {
      var childComplexity = operands!.first.complexity;
      if (childComplexity == NodeComplexity.GENERATOR_CHILDREN)
        complexity = NodeComplexity.GENERATOR_CHILDREN;
      else if (childComplexity == NodeComplexity.GENERATOR_CHILD)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else if (childComplexity == NodeComplexity.GENERATOR)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else // (childComplexity == NodeComplexity.SIMPLE)
        complexity = NodeComplexity.SIMPLE;
      if (token.type == MONADIC) {
        var name = token.name;
        var monadic = monadics[name]!;
        if (monadic.type == Iterable<int>) {
          if (complexity == NodeComplexity.SIMPLE)
            complexity = NodeComplexity.GENERATOR;
          else
            complexity = NodeComplexity.GENERATOR_CHILDREN;
        }
      }
    } else {
      var childComplexity1 = operands![0].complexity;
      var childComplexity2 = operands![1].complexity;
      if (childComplexity1 == NodeComplexity.GENERATOR_CHILDREN ||
          childComplexity2 == NodeComplexity.GENERATOR_CHILDREN)
        complexity = NodeComplexity.GENERATOR_CHILDREN;
      else if ((childComplexity1 == NodeComplexity.GENERATOR_CHILD ||
              childComplexity1 == NodeComplexity.GENERATOR) &&
          (childComplexity2 == NodeComplexity.GENERATOR_CHILD ||
              childComplexity2 == NodeComplexity.GENERATOR))
        complexity = NodeComplexity.GENERATOR_CHILDREN;
      else if (childComplexity1 == NodeComplexity.GENERATOR_CHILD ||
          childComplexity2 == NodeComplexity.GENERATOR_CHILD)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else if (childComplexity1 == NodeComplexity.GENERATOR ||
          childComplexity2 == NodeComplexity.GENERATOR)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else // (childComplexity == NodeComplexity.SIMPLE)
        complexity = NodeComplexity.SIMPLE;
    }
  }

  String toString() => operands == null
      ? '$token'
      : operands!.length == 1
          ? '$token${operands![0]}'
          : '(${operands![0]}$token${operands![1]})';

//      '($token${operands == null ? '' : operands!.map<String>((e) => ' $e')})';
}

class ExpressionError implements Exception {
  final String msg;
  ExpressionError(this.msg);
}

class ExpressionInvalid implements Exception {
  final String msg;
  ExpressionInvalid(this.msg);
}

// Parser
class ExpressionEvaluator {
  // Implementation of a recursive descent parser.   Each method
  // implements a single grammar rule.  Use the ._accept() method
  // to test and accept the current lookahead token.  Use the ._expect()
  // method to exactly match and discard the next token on on the input
  // (or throw a SyntaxError if it doesn't match).

  final String text;
  final String variablePrefix;
  List<String> variableRefs = [];
  List<String> clueRefs = [];
  late final Iterator tokenIterator;
  Token? tok;
  Token? nexttok;
  Node? tree;

  // Evaluation context
  List<String>? variableNames;
  List<int>? variableValues;

  // Hard-coded result generator
  int? result;
  num? minResult;
  num? maxResult;
  List<int>? knownResults;

  ExpressionEvaluator(this.text, [this.variablePrefix = '']) {
    var tokenIterable = Scanner.generateTokens(text, variablePrefix);
    this.tokenIterator = tokenIterable.iterator;
    this.tok = null; // Last symbol consumed
    this.nexttok = null; // Next symbol tokenized
    this._advance(); // Load first lookahead token
    this._parse(); // Build tree
  }

  String toString() => this.tree == null ? '' : this.tree.toString();

  void _parse() {
    this.tree = this.logical();
    if (this.nexttok != null) {
      throw ExpressionError('Parse error at ${this.nexttok.toString()}');
    }
  }

  void getVariableReferences(List<String> references, [Node? node]) {
    if (node == null) node = tree;
    if (node!.token.type == VAR) {}
  }

  void integerException() {
    throw ExpressionInvalid('Non-integer expression');
  }

  void checkInteger(num value) {
    if (!isIntegerValue(value)) {
      integerException();
    }
  }

  int evaluate([List<String>? variableNames, List<int>? variableValues]) {
    this.variableNames = variableNames;
    this.variableValues = variableValues;
    var value = this.eval(this.tree);
    checkInteger(value);
    return value.toInt();
  }

  Iterable<int> generate(
    num min,
    num max, [
    List<String>? variableNames,
    List<int>? variableValues,
    Set<int>? knownResults,
  ]) sync* {
    this.variableNames = variableNames;
    this.variableValues = variableValues;
    this.result = null;
    this.minResult = min;
    this.maxResult = max;
    this.knownResults = knownResults?.toList()?..sort();
    for (var value in this.gen(min, max, this.tree)) {
      num result = resultValue(value);
      if (isIntegerValue(result)) yield result.toInt();
      this.result = null;
    }
  }

  num resultValue(num value) {
    var result = this.result != null ? this.result! : value;
    return result;
  }

  bool isIntegerValue(num value) {
    return value is int || value == value.roundToDouble();
  }

  void _advance() {
    // Advance one token ahead
    this.tok = this.nexttok;
    if (tokenIterator.moveNext()) {
      this.nexttok = tokenIterator.current;
    } else {
      this.nexttok = null;
    }
  }

  bool _accept(toktype) {
    // Test and consume the next token if it matches toktype
    if (this.nexttok?.type == toktype) {
      this._advance();
      return true;
    }
    return false;
  }

  void _expect(toktype) {
    // Consume next token if it matches toktype or throw SyntaxError
    if (!this._accept(toktype)) {
      throw ExpressionError('Expected ' + toktype);
    }
  }

  // Grammar rules follow

  Node logical() {
    // logical ::= expr { '=' expr }*

    var node = this.expr();
    while (this._accept(EQUAL)) {
      var token = this.tok!;
      var right = this.expr();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node expr() {
    // expression ::= term { ('+'|'-') term }*

    var node = this.term();
    while (this._accept(PLUS) || this._accept(MINUS)) {
      var token = this.tok!;
      var right = this.term();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node term() {
    // term ::= exponent { ('*'|'/'|'%') exponent }*
    var node = this.exponent();
    while (this._accept(TIMES) || this._accept(DIVIDE) || this._accept(MOD)) {
      var token = this.tok!;
      var right = this.exponent();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node exponent() {
    // exponent ::= unary { '^') unary }*
    var node = this.unary();
    while (this._accept(EXPONENT)) {
      var token = this.tok!;
      var right = this.unary();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node unary() {
    // term ::= { '-' | '√' | MONADIC }* multiplication
    if (this._accept(MINUS)) {
      var token = this.tok!;
      var left = Node(Token('', NUM, value: 0));
      var right = this.unary();
      var node = Node(token, [left, right]);
      return node;
    }
    if (this._accept(ROOT) || this._accept(MONADIC)) {
      var token = this.tok!;
      var right = this.unary();
      var node = Node(token, [right]);
      return node;
    }
    return this.multiplication();
  }

  Node multiplication() {
    // multiplication ::= factorial { factorial }*
    var node = this.factorial();
    if (node != null) {
      while (true) {
        var node2 = this.factorial();
        if (node2 == null) return node!;
        var token = Token('', TIMES);
        node = Node(token, [node!, node2]);
      }
    } else {
      throw ExpressionError('Expected NUMBER, VARIABLE, GENERATOR or LPAREN');
    }
  }

  Node? factorial() {
    // factorial ::= factor { '!' | "'"}
    var node = this.factor();
    if (node != null && (this._accept(FACTORIAL) || this._accept(REVERSE))) {
      var token = this.tok!;
      node = Node(token, [node]);
    }
    return node;
  }

  Node? factor() {
    // factor ::= VAR | CLUE | NUM | GENERATOR | ( expr ) | ERROR
    if (this._accept(VAR) ||
        this._accept(CLUE) ||
        this._accept(NUM) ||
        this._accept(GENERATOR)) {
      var token = this.tok!;
      if (token.type == VAR) {
        this.variableRefs.add(token.name);
      }
      if (token.type == CLUE) {
        this.clueRefs.add(token.name);
      }
      return Node(token);
    } else if (this._accept(LPAREN)) {
      var node = this.expr();
      this._expect(RPAREN);
      return node;
    } else if (this._accept(ERROR)) {
      throw ExpressionError(this.tok!.name);
    } else {
      return null;
    }
  }

  num eval(Node? node) {
    if (node == null) return 0;
    switch (node.token.type) {
      case NUM:
        return node.token.value;
      case PLUS:
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left + right;
      case MINUS:
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left - right;
      case TIMES:
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        return left * right;
      case DIVIDE:
        // Require exact integer result - checked later
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        if (right == 0) {
          throw ExpressionInvalid('Divide by zero');
        }
        return left / right;
      case MOD:
        // Require exact integer operands
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        checkInteger(left);
        checkInteger(right);
        return left % right;
      case ROOT:
        var square = eval(node.operands![0]);
        if (square < 0) {
          throw ExpressionInvalid('Negative root');
        }
        var root = sqrt(square).toInt();
        if (root * root != square) {
          throw ExpressionInvalid('Non-integer root');
        }
        return root;
      case FACTORIAL:
        var left = eval(node.operands![0]);
        int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
        checkInteger(left);
        return factorial(left.toInt());
      case REVERSE:
        var left = eval(node.operands![0]);
        int reverse(int value) {
          var valueStr = value.toString();
          var reverse = '';
          for (var index = 0; index < valueStr.length; index++) {
            reverse = valueStr[index] + reverse;
          }
          return int.parse(reverse);
        }
        checkInteger(left);
        var result = reverse(left.toInt());
        if (result == left || left % 10 == 0) {
          throw ExpressionInvalid('Invalid reverse value');
        }
        return result;
      case EXPONENT:
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        var exp = pow(left, right);
        var result = exp;
        return result;
      case EQUAL:
        var left = eval(node.operands![0]);
        var right = eval(node.operands![1]);
        if (left != right) {
          throw ExpressionInvalid('Unequal expressions');
        }
        return left;
      case CLUE:
        var name = node.token.name;
        var index = this.variableNames!.indexOf(name);
        if (index < 0) {
          throw ExpressionInvalid('Unknown clue $name');
        }
        return this.variableValues![index];
      case VAR:
        var name = node.token.name;
        var index = this.variableNames!.indexOf(name);
        if (index < 0) {
          throw ExpressionInvalid('Unknown variable $name');
        }
        return this.variableValues![index];
      case MONADIC:
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionInvalid('Unknown monadic $name');
        }
        var left = eval(node.operands![0]);
        checkInteger(left);
        var result = monadic.func(left.toInt());
        if (result is bool) {
          if (result) return left;
          throw ExpressionInvalid(
              'False bool result for monadic $name in simple expression');
        } else if (result is num) {
          return result;
        } else {
          throw ExpressionInvalid(
              'Unexpected value type $result for monadic $name');
        }
      case GENERATOR:
        throw ExpressionInvalid("GENERATOR should be evaluated using 'gen()'");
      default:
        throw ExpressionInvalid('Invalid AST');
    }
  }

  Iterable<num> gen(num min, num max, Node? node) sync* {
    if (node == null) return;
    if (node.complexity == NodeComplexity.SIMPLE) {
      // Just one value
      yield eval(node);
      return;
    }
    switch (node.token.type) {
      case PLUS:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min - rvalue,
                rvalue == 0 ? max : max - rvalue,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  min - left,
                  max - left,
                  rnode,
                )) {
            var result = left + right;
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case MINUS:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min + rvalue,
                rvalue == 0 ? max : max + rvalue,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left - max,
                  left - min,
                  rnode,
                )) {
            var result = left - right;
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case TIMES:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min / rvalue,
                rvalue == 0 ? max : max / rvalue,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  min / left,
                  max / left,
                  rnode,
                )) {
            var result = left * right;
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case DIVIDE:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min * rvalue,
                rvalue == 0 ? max : max * rvalue,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left / max,
                  left / min,
                  rnode,
                )) {
            if (right == 0) {
              continue;
            }
            var result = left / right;
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case MOD:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min,
                rvalue == 0 ? max : max,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  2,
                  left,
                  rnode,
                )) {
            if (isIntegerValue(left) && isIntegerValue(right)) {
              var result = left % right;
              if (result > max) {
                continue;
              }
              if (result < min) {
                continue;
              }
              yield result;
            }
          }
        }
        break;
      case ROOT:
        for (var square in gen(min * min, max * max, node.operands![0])) {
          if (square < 0) {
            continue;
          }
          var result = sqrt(square).toInt();
          if (result > max) {
            if (node.order == NodeOrder.ASCENDING) break;
            continue;
          }
          if (result < min) {
            if (node.order == NodeOrder.DESCENDING) break;
            continue;
          }
          if (result * result == square) {
            yield result;
          }
        }
        break;
      case FACTORIAL:
        for (var left in gen(1, max, node.operands![0])) {
          int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
          if (isIntegerValue(left)) {
            var result = factorial(left.toInt());
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case REVERSE:
        for (var left in gen(min, max, node.operands![0])) {
          int reverse(int value) {
            var valueStr = value.toString();
            var reverse = '';
            for (var index = 0; index < valueStr.length; index++) {
              reverse = valueStr[index] + reverse;
            }
            return int.parse(reverse);
          }

          if (isIntegerValue(left)) {
            var result = reverse(left.toInt());
            if (result == left || left % 10 == 0) continue;
            if (result > max) {
              // if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              // if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case EXPONENT:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : pow(min, 1 / rvalue),
                rvalue == 0 ? max : pow(max, 1 / rvalue),
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left <= 1 ? 2 : log(min) / log(left),
                  left <= 1 ? max : log(max) / log(left),
                  rnode,
                )) {
            var result = pow(left, right);
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            yield result;
          }
        }
        break;
      case EQUAL:
        var lnode = node.operands![0];
        var lvalue = lnode.order == NodeOrder.SINGLE ? eval(lnode) : 0;
        var rnode = node.operands![1];
        var rvalue = rnode.order == NodeOrder.SINGLE ? eval(rnode) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 0 : rvalue,
                rvalue == 0 ? max : rvalue,
                lnode,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left,
                  left,
                  rnode,
                )) {
            var result = resultValue(left);
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (left == right) yield result;
          }
        }
        break;
      case GENERATOR:
        var name = node.token.name;
        var generator = generators[name];
        if (generator == null) {
          throw ExpressionError('Unknown generator $name');
        }
        if (name == 'result') {
          // Result generator is constrained to expression min/max
          min = this.minResult!;
          max = this.maxResult!;
          // if previously evaluated want same value
          if (this.result != null) {
            if (this.result! >= min && this.result! <= max) yield this.result!;
            return;
          }
          // if have previous known values then no return them
          if (knownResults != null) {
            for (var result in knownResults!) {
              if (result >= min && result <= max) {
                this.result = result;
                yield result;
              }
            }
            return;
          }
        }
        for (var result in generator.func(min, max)) {
          if (result > max) {
            if (node.order == NodeOrder.ASCENDING) break;
            continue;
          }
          if (result < min) {
            if (node.order == NodeOrder.DESCENDING) break;
            continue;
          }
          // Side-efffect
          if (name == "result") this.result = result;
          yield result;
        }
        break;
      case MONADIC:
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionError('Unknown monadic $name');
        }
        const int intMaxValue =
            9007199254740991; // Max for dart web, otherwise 9223372036854775807
        var childNode = node.operands![0];
        for (var left in gen(1, intMaxValue, childNode)) {
          if (isIntegerValue(left)) {
            var result = monadic.func(left.toInt());
            if (result is bool) {
              if (!result) continue;
              // if true then return argument
              result = left;
            }
            if (result is num) {
              if (result > max) {
                if (node.order == NodeOrder.ASCENDING ||
                    childNode.order == NodeOrder.SINGLE) break;
                continue;
              }
              if (result < min) {
                if (node.order == NodeOrder.DESCENDING ||
                    childNode.order == NodeOrder.SINGLE) break;
                continue;
              }
              yield result;
            } else if (result is Iterable<int>) {
              var breakOuter = true;
              for (var fresult in result) {
                if (fresult > max) {
                  // Assume function increases as argument increases
                  if (childNode.order == NodeOrder.ASCENDING ||
                      childNode.order == NodeOrder.SINGLE) break;
                  breakOuter = false;
                  continue;
                }
                if (fresult < min) {
                  if (childNode.order == NodeOrder.DESCENDING) break;
                  breakOuter = false;
                  continue;
                }
                breakOuter = false;
                yield fresult;
              }
              if (breakOuter) break;
            } else {
              throw ExpressionError(
                  'Unexpected value type $result for monadic $name');
            }
          }
        }
        break;
      case NUM:
      case VAR:
      case CLUE:
        throw ExpressionError(
            'NUM, VAR and CLUE should be NodeComplexity.SIMPLE');
      default:
        throw ExpressionError('Invalid AST');
    }
  }
}
