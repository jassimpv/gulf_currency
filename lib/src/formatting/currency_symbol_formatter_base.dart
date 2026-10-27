import 'currency_format_core.dart';
import 'currency_negative_format.dart';

/// Shared implementation behind the currency-specific formatters that use
/// this package's bundled symbol fonts (`AedCurrencyFormatter`,
/// `SarCurrencyFormatter`, `OmrCurrencyFormatter`). Only the symbol, code,
/// and their per-currency defaults differ; the formatting logic lives here
/// once.
abstract class SymbolCurrencyFormatter {
  /// Number of digits to show after the decimal point.
  final int decimalDigits;

  /// The locale used for digit grouping and decimal separators.
  final String locale;

  /// Whether to prefix the amount with the currency [symbolText].
  final bool showSymbol;

  /// Whether to prefix the amount with the [codeText] instead of the symbol.
  final bool showCode;

  /// Number of space characters placed between the symbol/code and the numeral.
  final int symbolSpacing;

  /// Whether to use a compact representation (e.g. `1.2K`, `3.4M`).
  final bool compact;

  /// How negative amounts should be rendered.
  final CurrencyNegativeFormat negativeFormat;

  /// Throws an [AssertionError] in debug mode if both [showSymbol] and
  /// [showCode] are `true`, since a currency symbol and code must never be
  /// shown together.
  const SymbolCurrencyFormatter({
    required this.decimalDigits,
    required this.locale,
    this.showSymbol = false,
    this.showCode = true,
    this.symbolSpacing = 1,
    this.compact = false,
    this.negativeFormat = CurrencyNegativeFormat.minusSign,
  })  : assert(decimalDigits >= 0, 'decimalDigits cannot be negative'),
        assert(symbolSpacing >= 0, 'symbolSpacing cannot be negative'),
        assert(
          !(showSymbol && showCode),
          'The currency symbol and code must never be shown together. Set '
          'only one of showSymbol / showCode to true.',
        );

  /// The currency symbol text shown when [showSymbol] is `true`.
  String get symbolText;

  /// The ISO-style currency code shown when [showCode] is `true`.
  String get codeText;

  /// Formats [value] using this formatter's configured options.
  ///
  /// [value] may be an [int], [double], [num], a numeric [String], or null.
  /// Null, empty, or whitespace-only values return only the configured symbol
  /// or code, or an empty string when both are hidden.
  String formatValue(dynamic value) {
    return formatCurrencyValue(
      value,
      symbolText: symbolText,
      codeText: codeText,
      decimalDigits: decimalDigits,
      locale: locale,
      showSymbol: showSymbol,
      showCode: showCode,
      symbolSpacing: symbolSpacing,
      compact: compact,
      negativeFormat: negativeFormat,
    );
  }
}
