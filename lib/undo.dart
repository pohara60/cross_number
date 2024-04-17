import 'clue.dart';
import 'grid.dart';
import 'variable.dart';

class UndoStack {
  static final undoIndex = <int>[];
  static get undoing => undoIndex.isNotEmpty;
  static var undoTop = 0;
  static final undoObject = <Object>[];
  static final undoValue = <Set<int>?>[];

  static void begin() {
    undoIndex.add(undoTop);
  }

  static void push(Object object) {
    if (!undoing) return;
    undoObject.add(object);
    Set<int>? set = {};
    if (object is Cell)
      set = object.digits;
    else if (object is Clue)
      set = object.values;
    else if (object is Variable)
      set = object.values;
    else
      throw Exception();
    undoValue.add(set);
    undoTop++;
  }

  static void undo() {
    assert(undoing);
    var oldTop = undoIndex.removeLast();
    while (undoTop > oldTop) {
      undoTop--;
      var object = undoObject.removeLast();
      var set = undoValue.removeLast();
      if (object is Cell)
        object.digitsNoUndo = set!;
      else if (object is Clue)
        object.valuesNoUndo = set;
      else if (object is Variable)
        object.valuesNoUndo = set;
      else
        throw Exception();
    }
  }
}
