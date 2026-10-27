import 'currency_negative_format.dart';
import 'currency_symbol_formatter_base.dart';

/// Formats numeric values as Omani Rial currency text, using the official
/// symbol launched by the Central Bank of Oman on 2025-11-19.
///
/// Defaults to [showCode] (`"OMR"`) rather than [showSymbol]: the official
/// symbol is Unicode `U+20C4`, scheduled for Unicode 18.0 (September 2026),
/// but not yet rendered by mainstream device fonts. This package bundles
/// that font (family [symbolFontFamily]) for Flutter apps: use the
/// `OmrText` widget for zero-setup rendering of the symbol, or pass
/// `showSymbol: true, showCode: false` and apply [symbolFontFamily] to your
/// own `TextStyle` yourself.
class OmrCurrencyFormatter extends SymbolCurrencyFormatter {
  /// The official Omani Rial currency symbol (Unicode U+20C4).
  ///
  /// Requires a font that maps this codepoint to the Rial glyph, such as
  /// the bundled [symbolFontFamily], to render correctly.
  static const String symbol = '⃄';

  /// The ISO-style currency code, used when a symbol font isn't available.
  static const String code = 'OMR';

  /// The font family bundled with this package that maps `U+20C4` to the
  /// official Omani Rial glyph. Apply it via `TextStyle(fontFamily:
  /// OmrCurrencyFormatter.symbolFontFamily)`, or use `OmrText`, which does
  /// this automatically.
  ///
  /// Flutter namespaces fonts a package declares in its own pubspec.yaml as
  /// `packages/<package_name>/<family>`, so this is *not* just `'OmaniRial'`.
  static const String symbolFontFamily = 'packages/gulf_currency/OmaniRial';

  /// Creates a reusable, configured OMR currency formatter.
  const OmrCurrencyFormatter({
    super.decimalDigits = 3,
    super.locale = 'en_OM',
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

  /// Formats [value] as OMR currency text using default or supplied options.
  ///
  /// This is a convenience for one-off formatting; use the constructor
  /// instead when reusing the same options repeatedly.
  static String format(
    dynamic value, {
    int decimalDigits = 3,
    String locale = 'en_OM',
    bool showSymbol = false,
    bool showCode = true,
    int symbolSpacing = 1,
    bool compact = false,
    CurrencyNegativeFormat negativeFormat = CurrencyNegativeFormat.minusSign,
  }) {
    return OmrCurrencyFormatter(
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
