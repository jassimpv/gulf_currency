import 'package:flutter/widgets.dart';

import '../formatting/currency_format_core.dart';
import '../formatting/currency_negative_format.dart';

/// Builds the [InlineSpan]s for a currency-symbol widget (`AedText`,
/// `SarText`), applying [symbolFontFamily] to *only* the symbol character.
///
/// Some bundled icon fonts map otherwise-ordinary codepoints (e.g. ASCII
/// digits) to empty placeholder glyphs as an artifact of their generation
/// process. Applying such a font to the whole formatted string would make
/// those digits disappear, so the special font must be scoped to just the
/// symbol span, leaving the numeral in the ambient font.
List<InlineSpan> buildCurrencySymbolSpans({
  required dynamic value,
  required String symbolText,
  required String? symbolFontFamily,
  required int decimalDigits,
  required String locale,
  required int symbolSpacing,
  required bool compact,
  required CurrencyNegativeFormat negativeFormat,
}) {
  final CurrencyParts parts = formatCurrencyParts(
    value,
    decimalDigits: decimalDigits,
    locale: locale,
    compact: compact,
  );
  final TextSpan symbolSpan = TextSpan(
    text: symbolText,
    style: TextStyle(fontFamily: symbolFontFamily),
  );
  if (parts.numberPart.isEmpty) return <InlineSpan>[symbolSpan];

  final String spacing = ' ' * symbolSpacing;
  final TextSpan numberSpan = TextSpan(text: '$spacing${parts.numberPart}');

  switch (negativeFormat) {
    case CurrencyNegativeFormat.minusSign:
      return <InlineSpan>[
        if (parts.isNegative) const TextSpan(text: '-'),
        symbolSpan,
        numberSpan,
      ];
    case CurrencyNegativeFormat.parentheses:
      return parts.isNegative
          ? <InlineSpan>[
              const TextSpan(text: '('),
              symbolSpan,
              numberSpan,
              const TextSpan(text: ')'),
            ]
          : <InlineSpan>[symbolSpan, numberSpan];
    case CurrencyNegativeFormat.trailing:
      return <InlineSpan>[
        symbolSpan,
        numberSpan,
        if (parts.isNegative) const TextSpan(text: '-'),
      ];
  }
}
