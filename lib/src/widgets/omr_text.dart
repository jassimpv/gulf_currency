import 'currency_symbol_text_base.dart';
import '../formatting/omr_currency_formatter_base.dart';

/// Displays [value] as Omani Rial currency text using the official Rial
/// symbol, with the bundled [OmrCurrencyFormatter.symbolFontFamily] font
/// automatically applied so the glyph renders correctly with zero setup.
class OmrText extends SymbolCurrencyText {
  const OmrText(
    super.value, {
    super.key,
    super.decimalDigits = 3,
    super.locale = 'en_OM',
    super.symbolSpacing,
    super.compact,
    super.negativeFormat,
    super.style,
    super.textAlign,
    super.overflow,
    super.maxLines,
  });

  @override
  String get symbolText => OmrCurrencyFormatter.symbol;

  @override
  String get symbolFontFamily => OmrCurrencyFormatter.symbolFontFamily;
}
