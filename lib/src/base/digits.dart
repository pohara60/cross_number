/// The digit symbols used by base-aware entries.
///
/// Digits 0-9 keep their usual symbols and 10-16 use A-G.
const String digitSymbols = '0123456789ABCDEFG';

/// Converts a digit symbol to its integer value.
///
/// Throws [FormatException] if [symbol] is not a valid digit symbol.
int digitValue(String symbol) {
  final index = digitSymbols.indexOf(symbol.toUpperCase());
  if (index < 0) {
    throw FormatException('Invalid digit symbol: $symbol');
  }
  return index;
}

/// Converts a digit value to its symbol.
///
/// Throws [RangeError] if [digit] is outside 0-16.
String digitSymbol(int digit) {
  if (digit < 0 || digit >= digitSymbols.length) {
    throw RangeError.range(digit, 0, digitSymbols.length - 1, 'digit');
  }
  return digitSymbols[digit];
}

/// Formats a sequence of digits as a string.
String digitsToString(Iterable<int> digits) => digits.map(digitSymbol).join();

/// An immutable digit string.
///
/// Two [DigitString] values are equal when they have the same digits.
class DigitString {
  /// The digits, most significant first.
  final List<int> digits;

  /// Creates an immutable digit string.
  DigitString(List<int> digits) : digits = List.unmodifiable(digits);

  /// The number of digits.
  int get length => digits.length;

  @override
  bool operator ==(Object other) {
    if (other is! DigitString || other.digits.length != digits.length) {
      return false;
    }
    for (var i = 0; i < digits.length; i++) {
      if (other.digits[i] != digits[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(digits);

  @override
  String toString() => digitsToString(digits);
}

/// Returns the digits of [value] in [base], most significant first.
///
/// Returns `null` when [value] does not have exactly [length] digits in
/// [base], or when the most significant digit would be zero.
DigitString? digitsOf(int value, int base, int length) {
  if (base < 2 || base > 17 || length < 1) return null;

  final digits = <int>[];
  var remaining = value;

  for (var i = 0; i < length; i++) {
    digits.add(remaining % base);
    remaining ~/= base;
  }

  if (remaining != 0) return null;

  final mostSignificantFirst = digits.reversed.toList();
  if (mostSignificantFirst.first == 0) return null;
  return DigitString(mostSignificantFirst);
}

/// Returns the base-10 value of [digits] interpreted in [base].
int valueOf(DigitString digits, int base) {
  var value = 0;
  for (final digit in digits.digits) {
    value = value * base + digit;
  }
  return value;
}
