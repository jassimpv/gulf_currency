import 'currency_symbol_text_base.dart';
import '../formatting/mvr_currency_formatter_base.dart';

/// Displays [value] as Maldivian Rufiyaa currency text using the official
/// Rufiyaa symbol, with the bundled [MvrCurrencyFormatter.symbolFontFamily]
/// font automatically applied so the glyph renders correctly with zero
/// setup.
class MvrText extends SymbolCurrencyText {
  const MvrText(
    super.value, {
    super.key,
    super.decimalDigits = 2,
    super.locale = 'en_MV',
    super.symbolSpacing,
    super.compact,
    super.negativeFormat,
    super.style,
    super.textAlign,
    super.overflow,
    super.maxLines,
  });

  @override
  String get symbolText => MvrCurrencyFormatter.symbol;

  @override
  String get symbolFontFamily => MvrCurrencyFormatter.symbolFontFamily;
}
