import 'digits.dart';

/// One possible filling of a base-aware entry.
///
/// The entry is written as [digits] in [base] and has the base-10 [value].
class EntryOption {
  /// The base used by the entry, in the range 2-17.
  final int base;

  /// The base-10 value of [digits] in [base].
  final int value;

  /// The digits of the entry, most significant first.
  final DigitString digits;

  /// Creates an entry option.
  const EntryOption(this.base, this.value, this.digits);

  @override
  String toString() => '${digits.toString()} (base $base) = $value';
}
