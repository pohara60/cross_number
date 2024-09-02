// Evaluate expression strings, with variable references

// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures

// Token specification
import 'dart:math';

import 'package:basics/string_basics.dart';

import 'generators.dart';
import 'monadic.dart';
import 'polyadic.dart';
import 'variable.dart';

typedef ExpressionCallback = num? Function(
    num? left, num? right, num? result, Node node);

mixin Expression {
  final expressions = <ExpressionEvaluator>[];
  ExpressionEvaluator get exp => expressions[0];
  String get expString => expressions.fold(
      '',
      (previousValue, element) =>
          previousValue == '' ? element.text : '|${element.text}');

  void initExpression(String? valueDesc, String variablePrefix, String name,
      VariableRefList variableRefs,
      {List<String>? entryNames, List<String>? clueNames}) {
    if (valueDesc != null && valueDesc != '') {
      try {
        var exp = ExpressionEvaluator(
            valueDesc, variablePrefix, entryNames, clueNames);
        expressions.add(exp);
        for (var variableName in exp.variableNameRefs..sort()) {
          variableRefs.addVariableReference(variableName);
        }
        for (var clueName in exp.clueNameRefs..sort()) {
          if (entryNames != null && entryNames.contains(clueName)) {
            variableRefs.addEntryReference(clueName);
          } else {
            variableRefs.addClueReference(clueName);
          }
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
const CONCAT = 'CONCAT', CONCAT_RE = r'(?<' + CONCAT + r'>~)';
const MOD = 'MOD', MOD_RE = r'(?<' + MOD + r'>%)';
const ROOT = 'ROOT', ROOT_RE = r'(?<' + ROOT + r'>√)';
const FACTORIAL = 'FACTORIAL', FACTORIAL_RE = r'(?<' + FACTORIAL + r'>!)';
const REVERSE = 'REVERSE', REVERSE_RE = r'(?<' + REVERSE + r">')";
const EXPONENT = 'EXPONENT', EXPONENT_RE = r'(?<' + EXPONENT + r'>\^)';
const LPAREN = 'LPAREN', LPAREN_RE = r'(?<' + LPAREN + r'>\()';
const RPAREN = 'RPAREN', RPAREN_RE = r'(?<' + RPAREN + r'>\))';
const COMMA = 'COMMA', COMMA_RE = r'(?<' + COMMA + r'>\,)';
const STRING = 'STRING', STRING_RE = r'(?<' + STRING + r'>\"[^"]*")';
const EQUAL = 'EQUAL', EQUAL_RE = r'(?<' + EQUAL + r'>=)';
const AND = 'AND', AND_RE = r'(?<' + AND + r'>&)';
const CLUE = 'CLUE', CLUE_RE = r'(?<' + CLUE + r'>E?[adAD]\d+|[IVX]+)';
const VAR = 'VAR', VAR_RE = r'(?<' + VAR + r'>\w)';
const GENERATOR = 'GENERATOR', GENERATOR_RE = r'(?<' + GENERATOR + r'>\#\w+)';
const MONADIC = 'MONADIC', MONADIC_RE = r'(?<' + MONADIC + r'>\$\w+)';
const POLYADIC = 'POLYADIC', POLYADIC_RE = r'(?<' + POLYADIC + r'>\£\w+)';
const WS = 'WS', WS_RE = r'(?<' + WS + r'>\s+)';
const ERROR = 'ERROR', ERROR_RE = r'(?<' + ERROR + r'>.)';
var regExp = RegExp([
  NUM_RE,
  PLUS_RE,
  MINUS_RE,
  TIMES_RE,
  DIVIDE_RE,
  CONCAT_RE,
  MOD_RE,
  ROOT_RE,
  FACTORIAL_RE,
  REVERSE_RE,
  EXPONENT_RE,
  LPAREN_RE,
  RPAREN_RE,
  COMMA_RE,
  STRING_RE,
  EQUAL_RE,
  AND_RE,
  CLUE_RE,
  VAR_RE,
  GENERATOR_RE,
  MONADIC_RE,
  POLYADIC_RE,
  WS_RE,
  ERROR_RE,
].join('|'));

var generators = <String, Generator>{};
var monadics = <String, Monadic>{};
var polyadics = <String, Polyadic>{};

class Token {
  final String type;
  String str;
  final int value;
  final String name;
  bool resolvedVariable = false;
  late final Variable variable;
  Token(this.str, this.type, {this.value = 0, this.name = ''});
  String toLongString() {
    return '$type${value != 0 ? '=${value.toString()}' : ''}${name != '' ? '=$name' : ''}';
  }

  @override
  String toString() => str;
}

class Scanner {
// Token Scanner

  static var initialized = false;

  static void initialize() {
    initializeGenerators(generators);
    initializeMonadics(monadics);
    initializePolyadics(polyadics);
    initialized = true;
  }

  static void addGenerators(List<Generator> generatorList) {
    for (var generator in generatorList) {
      generators[generator.name] = generator;
    }
  }

  static void addMonadics(List<Monadic> monadicList) {
    for (var monadic in monadicList) {
      monadics[monadic.name] = monadic;
    }
  }

  static void addPolyadics(List<Polyadic> polyadicList) {
    for (var polyadic in polyadicList) {
      polyadics[polyadic.name] = polyadic;
    }
  }

  static Iterable<Token?> generateTokens(String text,
      [String variablePrefix = '',
      List<String>? entryNames,
      List<String>? clueNames]) sync* {
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
        if (entryNames != null && entryNames.contains(match) ||
            clueNames != null && clueNames.contains(match)) {
          // Simple alpha entry names are scanned as variables
          // The name is case sensitive
          yield Token(match!, CLUE, name: match);
        } else {
          yield Token(match!, VAR, name: variablePrefix + match);
        }
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
      if (m.namedGroup(POLYADIC) != null) {
        var name = match!.substring(1).toLowerCase();
        if (polyadics.containsKey(name)) {
          yield Token(match, POLYADIC, name: name);
        } else {
          yield Token(match, ERROR, name: 'Unknown Polyadic $match');
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
      if (m.namedGroup(CONCAT) != null) {
        yield Token(match!, CONCAT);
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
      if (m.namedGroup(COMMA) != null) {
        yield Token(match!, COMMA);
      }
      if (m.namedGroup(STRING) != null) {
        yield Token(match!, STRING);
      }
      if (m.namedGroup(EQUAL) != null) {
        yield Token(match!, EQUAL);
      }
      if (m.namedGroup(AND) != null) {
        yield Token(match!, AND);
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
  Token token;
  late NodeComplexity complexity;
  late NodeOrder order;
  List<Node>? operands;
  bool isSubject = false;
  int? depth;

  Node? get left =>
      operands != null && operands!.isNotEmpty ? operands![0] : null;
  Node? get right =>
      operands != null && operands!.isNotEmpty ? operands![1] : null;

  Node(this.token, [List<Node?>? operands, this.depth]) {
    if (operands == null) {
      this.operands = null;
    } else {
      this.operands = [];
      for (var element in operands) {
        if (element != null) this.operands!.add(element);
      }
    }
    nodeComplexity();
    nodeOrder();
  }

  Node? findNode(Token subject) {
    switch (token.type) {
      case CLUE:
      case VAR:
        if (token.type == subject.type && token.name == subject.name) {
          return this;
        }
      default:
        Node? sNode;
        int count = 0;
        if (operands != null) {
          for (var node in operands!) {
            var nNode = node.findNode(subject);
            if (nNode != null) {
              count++;
              sNode = node;
            }
          }
        }
        if (count > 1) {
          throw ExpressionInvalid('More than one node for $subject');
        }
        return sNode;
    }
    return null;
  }

  Node? rearrangeNode(Token newSubject, Token oldSubject, [Node? child]) {
    switch (token.type) {
      case NUM:
      case CLUE:
      case VAR:
        if (token.type == newSubject.type && token.name == newSubject.name) {
          if (child != null) return child;
          return Node(oldSubject);
        }
        return this;
      case PLUS:
      case MINUS:
      case TIMES:
      case DIVIDE:
        if (left != null) {
          if (left!.findNode(newSubject) != null) {
            var newToken = token;
            if (token.type == PLUS) newToken = Token("-", MINUS);
            if (token.type == MINUS && right != null) {
              newToken = Token("+", PLUS);
            }
            if (token.type == TIMES) newToken = Token("/", DIVIDE);
            if (token.type == DIVIDE) newToken = Token("*", TIMES);
            var other = child ?? Node(oldSubject);
            child = Node(newToken, [other, right]);
            return left!.rearrangeNode(newSubject, oldSubject, child);
          }
        }
        if (right != null) {
          if (right!.findNode(newSubject) != null) {
            var newToken = token;
            if (token.type == PLUS) newToken = Token("-", MINUS);
            if (token.type == MINUS) newToken = Token("-", MINUS);
            if (token.type == TIMES) newToken = Token("/", DIVIDE);
            if (token.type == DIVIDE) newToken = Token("/", DIVIDE);
            var other = child ?? Node(oldSubject);
            if (token.type == PLUS) child = Node(newToken, [other, left]);
            if (token.type == MINUS) child = Node(newToken, [left, other]);
            if (token.type == TIMES) child = Node(newToken, [other, left]);
            if (token.type == DIVIDE) child = Node(newToken, [left, other]);
            return right!.rearrangeNode(newSubject, oldSubject, child);
          }
        }
      default:
        throw ExpressionInvalid("Cannot rearrange ${token.type}");
    }
    return null;
  }

  void fixNode(Token oldToken, Token newToken) {
    switch (token.type) {
      case CLUE:
      case VAR:
        if (token.type == oldToken.type && token.name == oldToken.name) {
          token = newToken;
        }
      default:
        if (operands != null) {
          for (var node in operands!) {
            node.fixNode(oldToken, newToken);
          }
        }
    }
  }

  void nodeOrder() {
    if (operands == null || operands!.isEmpty) {
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
      if (token.type == REVERSE) {
        order = NodeOrder.UNKNOWN;
      }
    } else {
      var childOrder1 = operands![0].order;
      var childOrder2 = operands![1].order;
      if (childOrder1 == NodeOrder.SINGLE && childOrder2 == NodeOrder.SINGLE) {
        order = NodeOrder.SINGLE;
      } else if (token.type == MINUS || token.type == DIVIDE) {
        if (childOrder1 == NodeOrder.SINGLE) {
          if (childOrder2 == NodeOrder.ASCENDING) {
            order = NodeOrder.DESCENDING;
          } else {
            order = NodeOrder.ASCENDING;
          }
        } else if (childOrder2 == NodeOrder.SINGLE)
          order = childOrder1;
        else
          order = NodeOrder.UNKNOWN;
      } else if (token.type == MOD) {
        order = NodeOrder.UNKNOWN;
      } else {
        if (childOrder1 == NodeOrder.SINGLE) {
          order = childOrder2;
        } else if (childOrder2 == NodeOrder.SINGLE)
          order = childOrder1;
        else
          order = NodeOrder.UNKNOWN;
      }
    }
    if (token.type == MONADIC || token.type == POLYADIC) {
      var name = token.name;
      var type =
          token.type == MONADIC ? monadics[name]!.type : polyadics[name]!.type;
      var forder = token.type == MONADIC
          ? monadics[name]!.order
          : polyadics[name]!.order;
      if (type == Iterable<int>) {
        // Descending/Ascending/Unknown generator functions
        if (order == NodeOrder.SINGLE && forder == NodeOrder.DESCENDING) {
          order = NodeOrder.DESCENDING;
        } else if (order == NodeOrder.SINGLE && forder == NodeOrder.ASCENDING)
          order = NodeOrder.ASCENDING;
        else
          order = NodeOrder.UNKNOWN;
      } else {
        // Non-generator functions that do not preserve operand order
        if (order != NodeOrder.SINGLE && forder == NodeOrder.UNKNOWN) {
          order = NodeOrder.UNKNOWN;
        }
      }
    }
  }

  void nodeComplexity() {
    if (operands == null || operands!.isEmpty) {
      if (token.type == "GENERATOR") {
        complexity = NodeComplexity.GENERATOR;
      } else {
        complexity = NodeComplexity.SIMPLE;
      }
    } else if (operands!.length == 1) {
      var childComplexity = operands!.first.complexity;
      if (childComplexity == NodeComplexity.GENERATOR_CHILDREN) {
        complexity = NodeComplexity.GENERATOR_CHILDREN;
      } else if (childComplexity == NodeComplexity.GENERATOR_CHILD)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else if (childComplexity == NodeComplexity.GENERATOR)
        complexity = NodeComplexity.GENERATOR_CHILD;
      else // (childComplexity == NodeComplexity.SIMPLE)
        complexity = NodeComplexity.SIMPLE;
    } else {
      var childComplexity1 = operands![0].complexity;
      var childComplexity2 = operands![1].complexity;
      if (childComplexity1 == NodeComplexity.GENERATOR_CHILDREN ||
          childComplexity2 == NodeComplexity.GENERATOR_CHILDREN) {
        complexity = NodeComplexity.GENERATOR_CHILDREN;
      } else if ((childComplexity1 == NodeComplexity.GENERATOR_CHILD ||
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
    if (token.type == MONADIC || token.type == POLYADIC) {
      var name = token.name;
      var type =
          token.type == MONADIC ? monadics[name]!.type : polyadics[name]!.type;
      if (type == Iterable<int>) {
        if (complexity == NodeComplexity.SIMPLE) {
          complexity = NodeComplexity.GENERATOR;
        } else {
          complexity = NodeComplexity.GENERATOR_CHILDREN;
        }
      }
    }
  }

  @override
  String toString() => operands == null || operands!.isEmpty
      ? '$token'
      : token.type == POLYADIC
          ? '$token(${operands!.map((o) => o.toString()).join(',')})'
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

  late final String text;
  late final String variablePrefix;
  List<String> variableNameRefs = [];
  List<String> clueNameRefs = [];
  List<Variable> variableRefs = [];
  late final Iterator tokenIterator;
  Token? tok;
  Token? nexttok;
  Node? tree;

  // Evaluation context
  List<Variable>? variables;
  List<int>? variableValues;

  // Hard-coded result generator
  late final bool usesResult;
  int? result;
  num? minResult;
  num? maxResult;
  List<int>? knownResults;

  ExpressionEvaluator(this.text,
      [this.variablePrefix = '',
      List<String>? entryNames,
      List<String>? clueNames]) {
    var tokenIterable =
        Scanner.generateTokens(text, variablePrefix, entryNames, clueNames);
    tokenIterator = tokenIterable.iterator;
    tok = null; // Last symbol consumed
    nexttok = null; // Next symbol tokenized
    _advance(); // Load first lookahead token
    _parse(); // Build tree
    if (tree != null) {
      _setDepth([tree!]);
    }
    usesResult =
        _hasToken(GENERATOR, "result"); // Does not yet use generator result
    variableNameRefs.sort();
    if (tree!.order == NodeOrder.UNKNOWN &&
        (tree!.complexity == NodeComplexity.GENERATOR_CHILD ||
            tree!.complexity == NodeComplexity.GENERATOR_CHILDREN)) {
      print("Warning: expression '$text' has generator with Unknown Order");
    }
  }

  @override
  String toString() => tree == null ? '' : tree.toString();

  void _parse() {
    tree = logical();
    if (nexttok != null) {
      throw ExpressionError('Parse error at ${nexttok.toString()}');
    }
  }

  bool _hasToken(String token, String name, [Node? node]) {
    node ??= tree!;
    if (node.token.type == token && node.token.name == name) return true;
    if (node.operands != null) {
      for (var child in node.operands!) {
        if (_hasToken(token, name, child)) return true;
      }
    }
    return false;
  }

  void _setDepth(List<Node> nodes, [int depth = 0]) {
    for (var node in nodes) {
      node.depth = depth;
      if (node.operands != null) {
        _setDepth(node.operands!, depth + 1);
      }
    }
  }

  void getVariableReferences(List<String> references, [Node? node]) {
    node ??= tree;
    if (node!.token.type == VAR) {}
  }

  static void integerException() {
    throw ExpressionInvalid('Non-integer expression');
  }

  static int checkInteger(dynamic value) {
    if (value is! num || !isIntegerValue(value)) {
      integerException();
    }
    return value.toInt();
  }

  String? rearrangeExpressionText(String newSubject, String oldSubject) {
    var newSubjectToken = Token(newSubject, CLUE, name: newSubject);
    var oldSubjectToken = Token(oldSubject, CLUE, name: oldSubject);
    // Get new evaluation tree and text
    try {
      if (tree!.findNode(newSubjectToken) != null) {
        var newTree = tree!.rearrangeNode(newSubjectToken, oldSubjectToken);
        var newText = newTree.toString();
        return newText;
      }
      // NewSubject not found
      return null;
    } on ExpressionInvalid {
      // More than one occurrence of newSubject, or cannot be rearranged
      return null;
    }
  }

  String fixReference(clueName) {
    if (clueNameRefs.contains(clueName)) {
      clueNameRefs.remove(clueName);
      var name = variablePrefix + clueName;
      variableNameRefs.add(name);
      tree!.fixNode(
        Token(clueName, CLUE, name: clueName),
        Token(name, VAR, name: name),
      );
      return name;
    }
    return '';
  }

  void resolveReferencesNode(
      Map<(VariableType, String), Variable> allVariables, Node node) {
    var type = node.token.type;
    var name = node.token.name;
    if (type == VAR) {
      if (!node.token.resolvedVariable) {
        var variable = allVariables[(VariableType.V, name)]!;
        node.token.variable = variable;
        // Token is re-used, cannot re-initialise late variable
        node.token.resolvedVariable = true;
      }
      return;
    }
    if (type == CLUE) {
      var variable = allVariables[(VariableType.C, name)];
      if (variable == null) {
        // Entry, alphabetic or prefix E
        if (name.length > 1 && name[0] == 'E') name = name.substring(1);
        variable = allVariables[(VariableType.E, name)]!;
      }
      if (!node.token.resolvedVariable) {
        node.token.variable = variable;
        // Token is re-used, cannot re-initialise late variable
        node.token.resolvedVariable = true;
      }
      return;
    }
    if (node.operands == null) return;
    for (var operand in node.operands!) {
      resolveReferencesNode(allVariables, operand);
    }
  }

  void resolveReferences(Map<(VariableType, String), Variable> allVariables) {
    if (tree != null) {
      var length = variableNameRefs.length + clueNameRefs.length;
      if (length > 0) {
        resolveReferencesNode(allVariables, tree!);
        // Get variable references in same order as variable names
        for (var name in variableNameRefs) {
          var variable = allVariables[(VariableType.V, name)]!;
          variableRefs.add(variable);
        }
        for (var name in clueNameRefs) {
          var variable = allVariables[(VariableType.C, name)];
          if (variable == null) {
            // Entry, alphabetic or prefix E
            if (name.length > 1 && name[0] == 'E') name = name.substring(1);
            variable = allVariables[(VariableType.E, name)]!;
          }
          variableRefs.add(variable);
        }
      }
    }
  }

  int evaluate([
    List<Variable>? variables,
    List<int>? variableValues,
    ExpressionCallback? callback,
  ]) {
    this.variables = variables;
    this.variableValues = variableValues;
    var value = eval(tree, callback);
    checkInteger(value);
    return value.toInt();
  }

  Iterable<int> generate(
    num? min,
    num? max, [
    List<Variable>? variables,
    List<int>? variableValues,
    Set<int>? knownResults,
    ExpressionCallback? callback,
  ]) sync* {
    this.variables = variables;
    this.variableValues = variableValues;
    result = null;
    min ??= 1;
    max ??= 100000; // Arbitrarily large
    minResult = min;
    maxResult = max;
    if (usesResult) {
      this.knownResults = knownResults?.toList()?..sort();
    }
    for (var value in gen(min, max, tree, callback)) {
      num result = resultValue(value);
      if (isIntegerValue(result)) yield result.toInt();
      this.result = null;
    }
  }

  num resultValue(num value) {
    var result = this.result != null ? this.result! : value;
    return result;
  }

  static bool isIntegerValue(num value) {
    return value is int || value == value.roundToDouble();
  }

  void _advance() {
    // Advance one token ahead
    tok = nexttok;
    if (tokenIterator.moveNext()) {
      nexttok = tokenIterator.current;
    } else {
      nexttok = null;
    }
  }

  bool _accept(toktype) {
    // Test and consume the next token if it matches toktype
    if (nexttok?.type == toktype) {
      _advance();
      return true;
    }
    return false;
  }

  void _expect(toktype) {
    // Consume next token if it matches toktype or throw SyntaxError
    if (!_accept(toktype)) {
      throw ExpressionError('Expected $toktype');
    }
  }

  // Grammar rules follow

  Node logical() {
    // logical ::= expr { ('='|'&') expr }*

    var node = expr();
    while (_accept(EQUAL) || _accept(AND)) {
      var token = tok!;
      var right = expr();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node expr() {
    // expression ::= term { ('+'|'-'|'~') term }*

    var node = term();
    while (_accept(PLUS) || _accept(MINUS) || _accept(CONCAT)) {
      var token = tok!;
      var right = term();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node term() {
    // term ::= exponent { ('*'|'/'|'%') exponent }*
    var node = exponent();
    while (_accept(TIMES) || _accept(DIVIDE) || _accept(MOD)) {
      var token = tok!;
      var right = exponent();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node exponent() {
    // exponent ::= unary { '^') unary }*
    var node = unary();
    while (_accept(EXPONENT)) {
      var token = tok!;
      var right = unary();
      node = Node(token, [node, right]);
    }
    return node;
  }

  Node unary() {
    // term ::= { '-' | '√' | MONADIC }* multiplication
    if (_accept(MINUS)) {
      var token = tok!;
      var left = Node(Token('', NUM, value: 0));
      var right = unary();
      var node = Node(token, [left, right]);
      return node;
    }
    if (_accept(ROOT) || _accept(MONADIC)) {
      var token = tok!;
      var right = unary();
      var node = Node(token, [right]);
      return node;
    }
    return multiplication();
  }

  Node multiplication() {
    // multiplication ::= factorial { factorial }*
    var node = factorial();
    if (node != null) {
      while (true) {
        var node2 = factorial();
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
    var node = factor();
    if (node != null && (_accept(FACTORIAL) || _accept(REVERSE))) {
      var token = tok!;
      node = Node(token, [node]);
    }
    return node;
  }

  Node? factor() {
    // factor ::= VAR | CLUE | NUM | GENERATOR | ( expr ) | ERROR | function | STRING
    if (_accept(VAR) || _accept(CLUE) || _accept(NUM) || _accept(GENERATOR)) {
      var token = tok!;
      if (token.type == VAR) {
        if (!variableNameRefs.contains(token.name)) {
          variableNameRefs.add(token.name);
        }
      }
      if (token.type == CLUE) {
        if (!clueNameRefs.contains(token.name)) clueNameRefs.add(token.name);
      }
      return Node(token);
    } else if (_accept(STRING)) {
      var token = tok!;
      token.str = token.str.slice(start: 1, end: token.str.length - 1);
      return Node(token);
    } else if (_accept(LPAREN)) {
      var node = expr();
      _expect(RPAREN);
      return node;
    } else if (_accept(ERROR)) {
      throw ExpressionError(tok!.name);
    } else {
      return function();
    }
  }

  Node? function() {
    // function ::= POLYADIC ( expr {, expr }* )
    if (_accept(POLYADIC)) {
      var token = tok!;
      var operands = <Node>[];
      _expect(LPAREN);
      while (true) {
        var node = expr();
        operands.add(node);
        if (!_accept(COMMA)) break;
      }
      _expect(RPAREN);
      var func = Node(token, operands);
      return func;
    } else {
      return null;
    }
  }

  dynamic eval(Node? node, ExpressionCallback? callback) {
    if (node == null) return 0;
    dynamic left;
    dynamic right;
    dynamic result;
    switch (node.token.type) {
      case NUM:
        result = node.token.value;
      case STRING:
        result = node.token.str;
      case PLUS:
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        result = left + right;
      case MINUS:
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        result = left - right;
      case TIMES:
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        result = left * right;
      case DIVIDE:
        // Require exact integer result - checked later
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        if (right == 0) {
          throw ExpressionInvalid('Divide by zero');
        }
        result = left / right;
      case CONCAT:
        // Require exact integer arguments
        left = eval(node.operands![0], callback);
        checkInteger(left);
        right = eval(node.operands![1], callback);
        checkInteger(right);
        result = int.parse(left.toString() + right.toString());
      case MOD:
        // Require exact integer operands
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        checkInteger(left);
        checkInteger(right);
        result = left % right;
      case ROOT:
        var square = eval(node.operands![0], callback);
        if (square < 0) {
          throw ExpressionInvalid('Negative root');
        }
        var root = sqrt(square).toInt();
        if (root * root != square) {
          throw ExpressionInvalid('Non-integer root');
        }
        result = root;
      case FACTORIAL:
        left = eval(node.operands![0], callback);
        int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
        checkInteger(left);
        result = factorial(left.toInt());
      case REVERSE:
        left = eval(node.operands![0], callback);
        int reverse(int value) {
          var valueStr = value.toString();
          var reverse = '';
          for (var index = 0; index < valueStr.length; index++) {
            reverse = valueStr[index] + reverse;
          }
          return int.parse(reverse);
        }
        checkInteger(left);
        result = reverse(left.toInt());
        if (result == left || left % 10 == 0) {
          throw ExpressionInvalid('Invalid reverse value');
        }
      case EXPONENT:
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        var exp = pow(left, right);
        result = exp;
      case EQUAL:
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        if (left != right) {
          throw ExpressionInvalid('Unequal expressions');
        }
        result = left;
      case AND:
        // False child throws exception
        left = eval(node.operands![0], callback);
        right = eval(node.operands![1], callback);
        result = left;
      case CLUE:
        var name = node.token.name;
        var variable = node.token.variable;
        var index = variables!.indexOf(variable);
        if (index < 0) {
          throw ExpressionInvalid('Unknown clue $name');
        }
        result = variableValues![index];
      case VAR:
        var name = node.token.name;
        var variable = node.token.variable;
        var index = variables!.indexOf(variable);
        if (index < 0) {
          throw ExpressionInvalid('Unknown variable $name');
        }
        result = variableValues![index];
      case MONADIC:
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionInvalid('Unknown monadic $name');
        }
        left = eval(node.operands![0], callback);
        checkInteger(left);
        var funcResult = monadic.func != null
            ? monadic.func!(left.toInt())
            : monadic.funcRange!(left.toInt(), null, null);
        if (funcResult is bool) {
          if (funcResult) {
            result = left;
          } else {
            throw ExpressionInvalid(
                'False bool result for monadic $name in simple expression');
          }
        } else if (funcResult is num) {
          result = funcResult;
        } else {
          throw ExpressionInvalid(
              'Unexpected value type $funcResult for monadic $name');
        }
      case POLYADIC:
        var name = node.token.name;
        var polyadic = polyadics[name];
        if (polyadic == null) {
          throw ExpressionInvalid('Unknown polyadic $name');
        }
        var args = <dynamic>[];
        for (var operand in node.operands!) {
          left = eval(operand, callback);
          args.add(left);
        }
        var funcResult = polyadic.func != null
            ? polyadic.func!(args)
            : polyadic.funcRange!(args, null, null);
        if (funcResult is bool) {
          if (funcResult) {
            result = args[0];
          } else {
            throw ExpressionInvalid(
                'False bool result for polyadic $name in simple expression');
          }
        } else if (funcResult is num) {
          result = funcResult;
        } else {
          throw ExpressionInvalid(
              'Unexpected value type $funcResult for polyadic $name');
        }
      case GENERATOR:
        throw ExpressionInvalid("GENERATOR should be evaluated using 'gen()'");
      default:
        throw ExpressionInvalid('Invalid AST');
    }
    // Apply callback - can update result, or result to null to throw exception
    if (callback != null) {
      result = callback(left, right, result, node);
      if (result == null) {
        throw ExpressionInvalid('Callback rejected result');
      }
    }
    return result;
  }

  Iterable<dynamic> gen(
      num min, num max, Node? node, ExpressionCallback? callback) sync* {
    if (node == null) return;
    if (node.complexity == NodeComplexity.SIMPLE) {
      // Just one value
      yield eval(node, callback);
      return;
    }
    switch (node.token.type) {
      case PLUS:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min - rvalue,
                rvalue == 0 ? max : max - rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  min - left,
                  max - left,
                  rnode,
                  callback,
                )) {
            num? result = (left + right)!;
            if (result! > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case MINUS:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        // Arbitrary min/max limit when do not know what values are to be subtracted
        const arbitraryLimit = 10000;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? -arbitraryLimit : min + rvalue,
                rvalue == 0 ? arbitraryLimit : max + rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left - max,
                  left - min,
                  rnode,
                  callback,
                )) {
            num? result = left - right;
            if (result! > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case TIMES:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min / rvalue,
                rvalue == 0 ? max : max / rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  min / left,
                  max / left,
                  rnode,
                  callback,
                )) {
            num? result = left * right;
            if (result! > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case DIVIDE:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min * rvalue,
                rvalue == 0 ? max : max * rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left / max,
                  left / min,
                  rnode,
                  callback,
                )) {
            if (right == 0) {
              continue;
            }
            num? result = left / right;
            if (result! > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case CONCAT:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min * rvalue,
                rvalue == 0 ? max : max * rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left / max,
                  left / min,
                  rnode,
                  callback,
                )) {
            if (right == 0) {
              continue;
            }
            // Require exact integer arguments
            left = eval(node.operands![0], callback);
            checkInteger(left);
            right = eval(node.operands![1], callback);
            checkInteger(right);
            num? result = int.parse(left.toString() + right.toString());
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case MOD:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : min,
                rvalue == 0 ? max : max,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  2,
                  left,
                  rnode,
                  callback,
                )) {
            if (isIntegerValue(left) && isIntegerValue(right)) {
              num? result = left % right;
              if (result! > max) {
                continue;
              }
              if (result < min) {
                continue;
              }
              if (callback != null) {
                result = callback(left, right, result, node);
                if (result == null) continue;
              }
              yield result;
            }
          }
        }
        break;
      case ROOT:
        for (var square
            in gen(min * min, max * max, node.operands![0], callback)) {
          if (square < 0) {
            continue;
          }
          num? result = sqrt(square).toInt();
          if (result > max) {
            if (node.order == NodeOrder.ASCENDING) break;
            continue;
          }
          if (result < min) {
            if (node.order == NodeOrder.DESCENDING) break;
            continue;
          }
          if (result * result == square) {
            if (callback != null) {
              result = callback(square, null, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case FACTORIAL:
        for (var left in gen(1, max, node.operands![0], callback)) {
          int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
          if (isIntegerValue(left)) {
            num? result = factorial(left.toInt());
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, null, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case REVERSE:
        for (var left in gen(min, max, node.operands![0], callback)) {
          int reverse(int value) {
            var valueStr = value.toString();
            var reverse = '';
            for (var index = 0; index < valueStr.length; index++) {
              reverse = valueStr[index] + reverse;
            }
            return int.parse(reverse);
          }

          if (isIntegerValue(left)) {
            num? result = reverse(left.toInt());
            if (result == left || left % 10 == 0) continue;
            if (result > max) {
              // if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              // if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, null, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case EXPONENT:
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 1 : pow(min, 1 / rvalue),
                rvalue == 0 ? max : pow(max, 1 / rvalue),
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  left <= 1 ? 2 : log(min) / log(left),
                  left <= 1 ? max : log(max) / log(left),
                  rnode,
                  callback,
                )) {
            num? result = pow(left, right);
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }
            if (callback != null) {
              result = callback(left, right, result, node);
              if (result == null) continue;
            }
            yield result;
          }
        }
        break;
      case EQUAL:
      case AND:
        var isAnd = node.token.type == AND;
        var lnode = node.operands![0];
        var lvalue =
            lnode.order == NodeOrder.SINGLE ? eval(lnode, callback) : 0;
        var rnode = node.operands![1];
        var rvalue =
            rnode.order == NodeOrder.SINGLE ? eval(rnode, callback) : 0;
        for (var left in lnode.order == NodeOrder.SINGLE
            ? [lvalue]
            : gen(
                rvalue == 0 ? 0 : rvalue,
                rvalue == 0 ? max : rvalue,
                lnode,
                callback,
              )) {
          for (var right in rnode.order == NodeOrder.SINGLE
              ? [rvalue]
              : gen(
                  isAnd ? 0 : left,
                  isAnd ? pow(10, max.toString().length) : left,
                  rnode,
                  callback,
                )) {
            num? result = resultValue(left);
            if (result > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              continue;
            }
            if (result < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              continue;
            }

            if (isAnd || node.token.type == EQUAL && left == right) {
              if (callback != null) {
                result = callback(left, right, result, node);
                if (result == null) continue;
              }
              yield result;
            }
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
          min = minResult!;
          max = maxResult!;
          // if previously evaluated want same value
          if (result != null) {
            if (result! >= min && result! <= max) yield result!;
            return;
          }
          // if have previous known values then return them
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
        for (num? result in generator.func(min, max)) {
          if (result! > max) {
            if (node.order == NodeOrder.ASCENDING) break;
            continue;
          }
          if (result < min) {
            if (node.order == NodeOrder.DESCENDING) break;
            continue;
          }
          // Side-efffect
          if (name == "result") this.result = result as int;
          if (callback != null) {
            result = callback(null, null, result, node);
            if (result == null) continue;
          }
          yield result;
        }
        break;
      case MONADIC:
        var name = node.token.name;
        var monadic = monadics[name];
        if (monadic == null) {
          throw ExpressionError('Unknown monadic $name');
        }
        // const int intMaxValue =
        //     9007199254740991; // Max for dart web, otherwise 9223372036854775807
        var childNode = node.operands![0];
        // Heuristic for min/max of argument to function
        var fmin = 1;
        var fmax = max;
        if (monadic.type is! bool && name != 'jumble') {
          fmax = maxResult! * maxResult!;
        }
        for (var left in gen(fmin, fmax, childNode, callback)) {
          if (isIntegerValue(left)) {
            var result = monadic.func != null
                ? monadic.func!(left.toInt())
                : monadic.funcRange!(left.toInt(), min, max);
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
              if (callback != null) {
                result = callback(left, null, result, node);
                if (result == null) continue;
              }
              yield result;
            } else if (result is Iterable<int>) {
              var breakOuter = true;
              var anyResult = false;
              // Override to prevent runaway NodeOrder.UNKNOWN
              var iterationCount = 0;
              const iterationLimit = 100000;
              for (int? fresult in result) {
                iterationCount++;
                anyResult = true;
                if (fresult! > max) {
                  if (node.order == NodeOrder.ASCENDING) break;
                  breakOuter = false;
                  if (node.order == NodeOrder.UNKNOWN &&
                      iterationCount > iterationLimit) break;
                  continue;
                }
                if (fresult < min) {
                  if (node.order == NodeOrder.DESCENDING) break;
                  breakOuter = false;
                  if (node.order == NodeOrder.UNKNOWN &&
                      iterationCount > iterationLimit) break;
                  continue;
                }
                breakOuter = false;
                if (callback != null) {
                  fresult = callback(left, null, fresult as num, node) as int?;
                  if (fresult == null) continue;
                }
                yield fresult;
              }
              if (anyResult && breakOuter) break;
            } else {
              throw ExpressionError(
                  'Unexpected value type $result for monadic $name');
            }
          }
        }
        break;
      case POLYADIC:
        var name = node.token.name;
        var polyadic = polyadics[name];
        if (polyadic == null) {
          throw ExpressionError('Unknown polyadic $name');
        }
        // Only cope with simple arguments
        for (var operand in node.operands!) {
          if (operand.complexity != NodeComplexity.SIMPLE) {
            throw ExpressionError(
                'Polyadic functions ($name) only support simple arguments');
          }
        }
        var args = <dynamic>[];
        for (var operand in node.operands!) {
          var value = eval(operand, callback);
          args.add(value);
        }
        var result = polyadic.func != null
            ? polyadic.func!(args)
            : polyadic.funcRange!(args, min, max);
        if (result is bool) {
          if (!result) break;
          // if true then return argument
          result = args[0];
        }
        if (result is num) {
          if (result > max) break;
          if (result < min) break;
          if (callback != null) {
            result = callback(args[0], null, result, node);
            if (result == null) break;
          }
          yield result;
        } else if (result is Iterable<int>) {
          // Override to prevent runaway NodeOrder.UNKNOWN
          var iterationCount = 0;
          const iterationLimit = 100000;
          for (int? fresult in result) {
            iterationCount++;
            if (fresult! > max) {
              if (node.order == NodeOrder.ASCENDING) break;
              if (node.order == NodeOrder.UNKNOWN &&
                  iterationCount > iterationLimit) break;
              continue;
            }
            if (fresult < min) {
              if (node.order == NodeOrder.DESCENDING) break;
              if (node.order == NodeOrder.UNKNOWN &&
                  iterationCount > iterationLimit) break;
              continue;
            }
            if (callback != null) {
              fresult = callback(args[0], null, fresult as num, node) as int?;
              if (fresult == null) continue;
            }
            yield fresult;
          }
        } else {
          throw ExpressionError(
              'Unexpected value type $result for polyadic $name');
        }
        break;
      case NUM:
      case STRING:
      case VAR:
      case CLUE:
        throw ExpressionError(
            'NUM, VAR and CLUE should be NodeComplexity.SIMPLE');
      default:
        throw ExpressionError('Invalid AST');
    }
  }
}
