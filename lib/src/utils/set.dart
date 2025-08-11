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
  if (list.isEmpty) return '';

  int? first;
  int? last;
  var count = 0;
  var str = StringBuffer();
  var str2 = StringBuffer();
  for (var item in list) {
    if (first == null) {
      first = item;
    } else {
      str2.write(',');
      if (last! + 1 != item) {
        if (last > first) {
          if (last > first + 1) {
            str.write('$first..$last,');
          } else {
            str.write('$first,$last,');
          }
          str2.clear();
        } else {
          str.write(str2);
          str2.clear();
        }
        first = item;
      }
    }
    last = item;
    str2.write(item);
    count++;
    if (count >= kLimit) break;
  }
  if (last! > first!) {
    if (last > first + 1) {
      str.write('$first..$last');
    } else {
      str.write('$first,$last');
    }
  } else {
    str.write('$first');
  }
  if (list.length > count) {
    if (list.length > count + 1) {
      str.write(',${list.length - count} more,${list.last}');
    } else {
      str.write(',${list.last}');
    }
  }
  return str.toString();
}
