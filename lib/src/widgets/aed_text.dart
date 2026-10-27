import '../formatting/aed_currency_formatter_base.dart';
import 'currency_symbol_text_base.dart';

/// Displays [value] as UAE Dirham currency text using the official Dirham
/// symbol, with the bundled [AedCurrencyFormatter.symbolFontFamily] font
/// automatically applied so the glyph renders correctly with zero setup.
class AedText extends SymbolCurrencyText {
  const AedText(
    super.value, {
    super.key,
    super.decimalDigits = 2,
    super.locale = 'en_AE',
    super.symbolSpacing,
    super.compact,
    super.negativeFormat,
    super.style,
    super.textAlign,
    super.overflow,
    super.maxLines,
  });

  @override
  String get symbolText => AedCurrencyFormatter.symbol;

  @override
  String get symbolFontFamily => AedCurrencyFormatter.symbolFontFamily;
}
