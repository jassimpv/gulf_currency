import 'currency_negative_format.dart';
import 'currency_symbol_formatter_base.dart';

/// Formats numeric values as Saudi Riyal currency text, using the new
/// Saudi Riyal symbol introduced by the Saudi Central Bank (SAMA) in 2025.
///
/// Defaults to [showCode] (`"SAR"`) rather than [showSymbol]: the new
/// symbol doesn't have a permanent Unicode codepoint yet, so this package's
/// bundled font ([symbolFontFamily]) maps it onto the placeholder character
/// [symbol] (`#`). Outside a widget styled with that font, [symbol] would
/// just render as a literal `#`. Use the `SarText` widget for zero-setup
/// rendering of the symbol, or pass `showSymbol: true, showCode: false` and
/// apply [symbolFontFamily] to your own `TextStyle` yourself.
class SarCurrencyFormatter extends SymbolCurrencyFormatter {
  /// The placeholder character the bundled [symbolFontFamily] font maps to
  /// the Saudi Riyal glyph.
  ///
  /// This is a plain `#` outside of a widget using [symbolFontFamily] -- it
  /// only renders as the Riyal symbol when styled with that font.
  static const String symbol = '#';

  /// The ISO-style currency code, used when the symbol font isn't applied.
  static const String code = 'SAR';

  /// The font family bundled with this package that maps [symbol] (`#`) to
  /// the Saudi Riyal glyph. Apply it via `TextStyle(fontFamily:
  /// SarCurrencyFormatter.symbolFontFamily)`, or use `SarText`, which does
  /// this automatically.
  ///
  /// Flutter namespaces fonts a package declares in its own pubspec.yaml as
  /// `packages/<package_name>/<family>`, so this is *not* just
  /// `'SaudiRiyal'`.
  static const String symbolFontFamily = 'packages/gulf_currency/SaudiRiyal';

  /// Creates a reusable, configured SAR currency formatter.
  const SarCurrencyFormatter({
    super.decimalDigits = 2,
    super.locale = 'en_SA',
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

  /// Formats [value] as SAR currency text using default or supplied options.
  ///
  /// This is a convenience for one-off formatting; use the constructor
  /// instead when reusing the same options repeatedly.
  static String format(
    dynamic value, {
    int decimalDigits = 2,
    String locale = 'en_SA',
    bool showSymbol = false,
    bool showCode = true,
    int symbolSpacing = 1,
    bool compact = false,
    CurrencyNegativeFormat negativeFormat = CurrencyNegativeFormat.minusSign,
  }) {
    return SarCurrencyFormatter(
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
