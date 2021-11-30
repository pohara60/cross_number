extension SetExtensions<int> on Set<int> {
  String toShortString() {
    var list = List.from(this);
    int? first = null;
    int? last = null;
    var isRange = true;
    for (var item in list) {
      if (first == null) {
        first = item;
      } else if (item - 1 != last) {
        isRange = false;
      }
      last = item;
    }
    if (isRange && this.length > 2) {
      return '\{$first..$last\}';
    }
    return this.toString();
  }
}

extension ListSetExtensions on List<Set<int>> {
  String toShortString() {
    var text = '[';
    var first = true;
    for (var item in this) {
      if (!first) text += ',';
      text += item.toShortString();
      first = false;
    }
    text += ']';
    return text;
  }
}

extension ListIntExtensions on List<int> {
  String toShortString() {
    int? first = null;
    int? last = null;
    var isRange = true;
    for (var item in this) {
      if (first == null) {
        first = item;
      } else {
        if (last! + 1 == item) {
          isRange = false;
        }
      }
      last = item;
    }
    if (isRange && this.length > 2) {
      return '\{$first..$last\}';
    }
    return this.toString();
  }
}
