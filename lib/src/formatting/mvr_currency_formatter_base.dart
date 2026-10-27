import 'currency_negative_format.dart';
import 'currency_symbol_formatter_base.dart';

/// Formats numeric values as Maldivian Rufiyaa currency text, using the
/// official symbol introduced by the Maldives Monetary Authority (MMA) on
/// 2022-07-03.
///
/// Defaults to [showCode] (`"MVR"`) rather than [showSymbol]: the official
/// symbol is Unicode `U+20C2`, scheduled for Unicode 18.0 (September 2026),
/// but not yet rendered by mainstream device fonts. This package bundles
/// that font (family [symbolFontFamily]) for Flutter apps: use the
/// `MvrText` widget for zero-setup rendering of the symbol, or pass
/// `showSymbol: true, showCode: false` and apply [symbolFontFamily] to your
/// own `TextStyle` yourself.
class MvrCurrencyFormatter extends SymbolCurrencyFormatter {
  /// The official Maldivian Rufiyaa currency symbol (Unicode U+20C2).
  ///
  /// Requires a font that maps this codepoint to the Rufiyaa glyph, such as
  /// the bundled [symbolFontFamily], to render correctly.
  static const String symbol = '⃂';

  /// The ISO-style currency code, used when a symbol font isn't available.
  static const String code = 'MVR';

  /// The font family bundled with this package that maps `U+20C2` to the
  /// official Maldivian Rufiyaa glyph. Apply it via `TextStyle(fontFamily:
  /// MvrCurrencyFormatter.symbolFontFamily)`, or use `MvrText`, which does
  /// this automatically.
  ///
  /// Flutter namespaces fonts a package declares in its own pubspec.yaml as
  /// `packages/<package_name>/<family>`, so this is *not* just
  /// `'MaldivianRufiyaa'`.
  static const String symbolFontFamily =
      'packages/gulf_currency/MaldivianRufiyaa';

  /// Creates a reusable, configured MVR currency formatter.
  const MvrCurrencyFormatter({
    super.decimalDigits = 2,
    super.locale = 'en_MV',
    super.showSymbol,
    super.showCode,
    super.symbolSpacing,
    super.compact,
    super.negativeFormat,
  });

  @override
  String get symbolText => symbol;

  @override
  String get codeText => code;

  /// Formats [value] as MVR currency text using default or supplied options.
  ///
  /// This is a convenience for one-off formatting; use the constructor
  /// instead when reusing the same options repeatedly.
  static String format(
    dynamic value, {
    int decimalDigits = 2,
    String locale = 'en_MV',
    bool showSymbol = false,
    bool showCode = true,
    int symbolSpacing = 1,
    bool compact = false,
    CurrencyNegativeFormat negativeFormat = CurrencyNegativeFormat.minusSign,
  }) {
    return MvrCurrencyFormatter(
      decimalDigits: decimalDigits,
      locale: locale,
      showSymbol: showSymbol,
      showCode: showCode,
      symbolSpacing: symbolSpacing,
      compact: compact,
      negativeFormat: negativeFormat,
    ).formatValue(value);
  }
}
