import 'package:flutter/widgets.dart';

import '../formatting/currency_negative_format.dart';
import 'currency_symbol_spans.dart';

/// Shared implementation behind the currency-specific widgets that use this
/// package's bundled symbol fonts (`AedText`, `SarText`, `OmrText`). Only
/// the symbol, font family, and their per-currency defaults differ; the
/// `build` logic lives here once.
abstract class SymbolCurrencyText extends StatelessWidget {
  const SymbolCurrencyText(
    this.value, {
    super.key,
    required this.decimalDigits,
    required this.locale,
    this.symbolSpacing = 1,
    this.compact = false,
    this.negativeFormat = CurrencyNegativeFormat.minusSign,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  /// The value to format: an [int], [double], [num], a numeric [String], or null.
  /// Null, empty, or whitespace-only values display only the symbol.
  final dynamic value;

  /// Number of digits to show after the decimal point.
  final int decimalDigits;

  /// The locale used for digit grouping and decimal separators.
  final String locale;

  /// Number of space characters placed between the symbol and the numeral.
  final int symbolSpacing;

  /// Whether to use a compact representation (e.g. `1.2K`, `3.4M`).
  final bool compact;

  /// How negative amounts should be rendered.
  final CurrencyNegativeFormat negativeFormat;

  /// The base text style. [symbolFontFamily] is applied on top of this style
  /// so the currency glyph always renders correctly.
  final TextStyle? style;

  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  /// The currency symbol text to render.
  String get symbolText;

  /// The bundled font family that maps [symbolText] to the correct glyph.
  String get symbolFontFamily;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = buildCurrencySymbolSpans(
      value: value,
      symbolText: symbolText,
      symbolFontFamily: symbolFontFamily,
      decimalDigits: decimalDigits,
      locale: locale,
      symbolSpacing: symbolSpacing,
      compact: compact,
      negativeFormat: negativeFormat,
    );
    return Text.rich(
      TextSpan(style: style, children: spans),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
