// ansi.dart
// From: https://github.com/timsneath/dart_console/blob/main/lib/src/ansi.dart
//
// Contains ANSI escape sequences used by dart_console. Other classes should
// use these constants rather than embedding raw control codes.
//
// For more information on commonly-accepted ANSI mode control sequences, read
// https://vt100.net/docs/vt100-ug/chapter3.html.

import 'dart:io';

const ansiDeviceStatusReportCursorPosition = '\x1b[6n';
const ansiEraseInDisplayAll = '\x1b[2J';
const ansiEraseInLineAll = '\x1b[2K';
const ansiEraseCursorToEnd = '\x1b[K';

const ansiHideCursor = '\x1b[?25l';
const ansiShowCursor = '\x1b[?25h';

const ansiCursorLeft = '\x1b[D';
const ansiCursorRight = '\x1b[C';
const ansiCursorUp = '\x1b[A';
const ansiCursorDown = '\x1b[B';

const ansiResetCursorPosition = '\x1b[H';
const ansiMoveCursorToScreenEdge = '\x1b[999C\x1b[999B';
String ansiCursorPosition(int row, int col) => '\x1b[$row;${col}H';

String ansiSetColor(int color) => '\x1b[${color}m';
String ansiSetExtendedForegroundColor(int color) => '\x1b[38;5;${color}m';
String ansiSetExtendedBackgroundColor(int color) => '\x1b[48;5;${color}m';
const ansiResetColor = '\x1b[m';

String ansiSetTextStyles(
    {bool bold = false,
    bool faint = false,
    bool italic = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
    bool invisible = false,
    bool strikethru = false}) {
  final styles = <int>[];
  if (bold) styles.add(1);
  if (faint) styles.add(2);
  if (italic) styles.add(3);
  if (underscore) styles.add(4);
  if (blink) styles.add(5);
  if (inverted) styles.add(7);
  if (invisible) styles.add(8);
  if (strikethru) styles.add(9);
  return '\x1b[${styles.join(";")}m';
}

void main() {
  backtrack(0, 6);
}

void backtrack(int i, int len) {
  if (i == len) return;
  if (i == 2 || i == 4) addProgress("Progress");
  for (var value = 1; value <= 3; value++) {
    pushProgress(value);
    sleep(Duration(milliseconds: 10));
    backtrack(i + 1, len);
    popProgress();
  }
}

var progress = '';
var characters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
pushProgress(int value) {
  var char = characters[value];
  progress += char;
  stdout.write('$char');
}

popProgress() {
  progress = progress.substring(0, progress.length - 1);
  const ansiCursorLeft = '\x1b[D';
  const ansiEraseCursorToEnd = '\x1b[K';
  stdout.write(ansiCursorLeft);
  stdout.write(ansiEraseCursorToEnd);
}

addProgress(String msg) {
  stdout.write(' ');
  stdout.writeln(msg);
  stdout.write(progress);
}
