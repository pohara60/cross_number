// ignore_for_file: curly_braces_in_flow_control_structures

import 'clue.dart';
import 'grid.dart';
import 'variable.dart';

class UndoStack {
  static final undoIndex = <int>[];
  static get undoing => undoIndex.isNotEmpty;
  static var undoTop = 0;
  static final undoObject = <Object>[];
  static final undoValue = <Set<int>?>[];
  static final undoDigits = <List<Set<int>>>[];

  static void begin() {
    undoIndex.add(undoTop);
  }

  static void push(Object object) {
    if (!undoing) return;
    undoObject.add(object);
    Set<int>? set = {};
    List<Set<int>>? digits;
    if (object is Cell) {
      set = object.digits;
    } else if (object is Clue) {
      set = object.values;
      if (object is EntryMixin) {
        digits = List.from(object.digits);
        undoDigits.add(digits);
      }
    } else if (object is Variable)
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
      if (object is Cell) {
        object.digitsNoUndo = set!;
      } else if (object is Clue) {
        object.valuesNoUndo = set;
        if (object is EntryMixin) {
          var digits = undoDigits.removeLast();
          for (var i = 0; i < digits.length; i++) {
            object.digits[i] = digits[i];
          }
        }
      } else if (object is Variable)
        object.valuesNoUndo = set;
      else
        throw Exception();
    }
  }
}
