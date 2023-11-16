class ExpressionInvalid implements Exception {
  final String msg;
  ExpressionInvalid(this.msg);
}

class Node {
  final String token;
  Node? left;
  Node? right;

  Node(this.token, [this.left, this.right]);

  Node? findNode(String subject) {
    Node? sNode = null;
    int count = 0;
    for (var node in [this.left, this.right]) {
      if (node != null) {
        var nNode = node.findNode(subject);
        if (nNode != null) {
          count++;
          sNode = nNode;
        }
      }
    }
    if (this.token == subject) {
      count++;
      sNode = this;
    }
    if (count > 1) throw ExpressionInvalid('More than one node for $subject');
    return sNode;
  }

  Node? rearrangeNode(String oldSubject, String newSubject, Node? child) {
    if (token == oldSubject) {
      if (child != null) return child;
      return Node(newSubject);
    }
    if (left != null) {
      if (left!.findNode(oldSubject) != null) {
        var newToken = token;
        if (token == "+") newToken = "-";
        if (token == "-" && right != null) newToken = "+";
        if (token == "*") newToken = "/";
        if (token == "/") newToken = "*";
        var other = child ?? Node(newSubject);
        child = Node(newToken, other, right);
        return left!.rearrangeNode(oldSubject, newSubject, child);
      }
    }
    if (right != null) {
      if (right!.findNode(oldSubject) != null) {
        var newToken = token;
        if (token == "+") newToken = "-";
        if (token == "-") newToken = "-";
        if (token == "*") newToken = "/";
        if (token == "/") newToken = "/";
        var other = child ?? Node(newSubject);
        if (token == "+") child = Node(newToken, other, left);
        if (token == "-") child = Node(newToken, left, other);
        if (token == "*") child = Node(newToken, other, left);
        if (token == "/") child = Node(newToken, left, other);
        return right!.rearrangeNode(oldSubject, newSubject, child);
      }
    }
    return null;
  }

  String toString() =>
      "($token${left != null ? ' ' + left.toString() : ''}${right != null ? ' ' + right.toString() : ''})";
}

void main() {
  var tree1 = Node("-", Node("-", Node("x"), Node("O")), Node("y"));
  var tree2 = Node(
      "+", Node("C"), Node("-", Node("-", Node("O"), Node("g")), Node("h")));
  var tree3 = Node("*", Node("j"), Node("+", Node("O"), Node("c")));
  var tree4 = Node("*", Node("a"), Node("-", Node("O")));
  for (var tree in [tree1, tree2, tree3, tree4]) {
    var newTree = tree.rearrangeNode("O", "N", null);
    print("$tree => $newTree");
  }
}
