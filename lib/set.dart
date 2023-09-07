extension SetExtensions on Set<int> {
  String toShortString() {
    var list = List<int>.from(this);
    list.sort();
    return '{${_toShortString(list)}}';
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
    return '[${_toShortString(this)}]';
  }
}

const kLimit = 20;
String _toShortString(List<int> list) {
  int? first = null;
  int? last = null;
  var isRange = true;
  var count = 0;
  var str = StringBuffer();
  for (var item in list) {
    if (first == null) {
      first = item;
    } else {
      str.write(',');
      if (last! + 1 != item) {
        isRange = false;
      }
    }
    last = item;
    str.write(item);
    count++;
    if (!isRange && count >= kLimit) break;
  }
  if (isRange && list.length > 2) {
    return '$first..$last';
  }
  if (list.length > kLimit) {
    str.write(' and ${list.length - count} more');
  }
  return str.toString();
}
