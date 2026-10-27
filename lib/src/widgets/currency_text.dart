import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/currency_display_data.dart';
import '../formatting/currency_format_core.dart';
import 'currency_symbol_spans.dart';
import '../data/currency_locale_data.dart';
import '../formatting/currency_negative_format.dart';

/// Displays [value] as currency text for any world currency, resolving the
/// currency from [currencyCode], [locale], or the device's current locale.
///
/// Uses currency display metadata to apply bundled symbol fonts where needed.
/// Other currency symbols use ordinary Unicode text.
class CurrencyText extends StatelessWidget {
  const CurrencyText(
    this.value, {
    super.key,
    this.locale,
    this.currencyCode,
    this.decimalDigits,
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

  /// The locale used to resolve the currency and drive number formatting.
  /// Defaults to the device's current locale when null.
  final String? locale;

  /// Explicit currency code or local identifier from `allCurrencyOptions`.
  /// Overrides locale-based currency resolution, while [locale] still controls
  /// the number formatting. Useful for formatting a picker's selected value.
  final String? currencyCode;

  /// Number of digits to show after the decimal point. Defaults to the
  /// resolved currency's own convention when null.
  final int? decimalDigits;

  /// Number of space characters placed between the symbol and the numeral.
  final int symbolSpacing;

  /// Whether to use a compact representation (e.g. `1.2K`, `3.4M`).
  final bool compact;

  /// How negative amounts should be rendered.
  final CurrencyNegativeFormat negativeFormat;

  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final String loc = locale ?? systemLocale();
    final String resolvedCurrencyCode = currencyCode?.trim().toUpperCase() ??
        currencyCodeForLocale(loc) ??
        'USD';

    final CurrencyDisplayData? displayData =
        circulatingCurrencyData[resolvedCurrencyCode];
    final NumberFormat? probe = displayData == null ||
            (decimalDigits == null && displayData.decimalDigits == null)
        ? withLocaleFallback(
            loc,
            (String locale) => NumberFormat.simpleCurrency(
              locale: locale,
              name: resolvedCurrencyCode,
            ),
          )
        : null;
    final String symbol = displayData?.symbol ?? probe!.currencySymbol;
    final String? symbolFontFamily = displayData?.symbolFontFamily;
    final int digits = decimalDigits ??
        displayData?.decimalDigits ??
        probe?.decimalDigits ??
        displayData?.decimalDigits ??
        2;
    final List<InlineSpan> spans = buildCurrencySymbolSpans(
      value: value,
      symbolText: symbol,
      symbolFontFamily: symbolFontFamily,
      decimalDigits: digits,
      locale: loc,
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
