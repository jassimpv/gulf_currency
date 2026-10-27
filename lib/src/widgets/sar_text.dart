import 'currency_symbol_text_base.dart';
import '../formatting/sar_currency_formatter_base.dart';

/// Displays [value] as Saudi Riyal currency text using the new Saudi Riyal
/// symbol, with the bundled [SarCurrencyFormatter.symbolFontFamily] font
/// automatically applied so the glyph renders correctly with zero setup.
class SarText extends SymbolCurrencyText {
  const SarText(
    super.value, {
    super.key,
    super.decimalDigits = 2,
    super.locale = 'en_SA',
    super.symbolSpacing,
    super.compact,
    super.negativeFormat,
    super.style,
    super.textAlign,
    super.overflow,
    super.maxLines,
  });

  @override
  String get symbolText => SarCurrencyFormatter.symbol;

  @override
  String get symbolFontFamily => SarCurrencyFormatter.symbolFontFamily;
}
