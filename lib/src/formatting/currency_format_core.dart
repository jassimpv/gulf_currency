import 'package:intl/intl.dart';

import 'currency_negative_format.dart';

/// The numeral part of a formatted currency value, and whether the original
/// amount was negative (the sign/wrapping is applied separately so widgets
/// can style the symbol independently from the numeral).
typedef CurrencyParts = ({String numberPart, bool isNegative});

/// Locale `intl` always ships number-formatting data for, used as a last
/// resort when the caller's [locale] isn't one `intl` recognizes.
const String fallbackLocale = 'en_US';

/// Runs [build] with [locale], retrying once with [fallbackLocale] if
/// `intl` doesn't recognize [locale]. `intl` signals this by throwing an
/// `ArgumentError` with an "Invalid locale" message from deep inside
/// `NumberFormat`'s constructors, e.g. for a locale string passed through
/// from user input or the device that `intl`'s bundled data has no entry
/// for (now, or in a future `intl` release that changes what's supported).
T withLocaleFallback<T>(String locale, T Function(String locale) build) {
  try {
    return build(locale);
  } on ArgumentError catch (error) {
    final Object? message = error.message;
    final bool isUnrecognizedLocale =
        message is String && message.startsWith('Invalid locale');
    if (!isUnrecognizedLocale || locale == fallbackLocale) rethrow;
    return build(fallbackLocale);
  }
}

/// Shared numeral-formatting engine behind [AedCurrencyFormatter],
/// [SarCurrencyFormatter], and the generic currency formatter. Not exported;
/// only the currency symbol/code differ between currencies, so the
/// formatting logic lives here once.
/// Null, empty, or whitespace-only values return an empty numeral for
/// symbol-only display instead of being parsed as a number.
CurrencyParts formatCurrencyParts(
  dynamic value, {
  required int decimalDigits,
  required String locale,
  required bool compact,
}) {
  if (value == null || (value is String && value.trim().isEmpty)) {
    return (numberPart: '', isNegative: false);
  }
  final num amount = toNumOrThrow(value);
  final bool isNegative = amount < 0;
  final num absAmount = amount.abs();

  final NumberFormat numberFormat = _currencyNumberFormat(
    locale: locale,
    decimalDigits: decimalDigits,
    compact: compact,
  );
  return (
    numberPart: numberFormat.format(absAmount).trim(),
    isNegative: isNegative,
  );
}

/// Builds the [NumberFormat] used to render the numeral, via
/// [withLocaleFallback] since `intl` may not recognize [locale].
NumberFormat _currencyNumberFormat({
  required String locale,
  required int decimalDigits,
  required bool compact,
}) {
  return withLocaleFallback(
    locale,
    (String locale) => compact
        ? NumberFormat.compactCurrency(
            locale: locale,
            symbol: '',
            decimalDigits: decimalDigits,
          )
        : NumberFormat.currency(
            locale: locale,
            symbol: '',
            decimalDigits: decimalDigits,
          ),
  );
}

/// Formats [value] as a full currency string, combining the symbol/code
/// prefix, the numeral, and any negative-value wrapping.
/// Null or empty strings return only the configured symbol or code, without
/// spaces.
String formatCurrencyValue(
  dynamic value, {
  required String symbolText,
  required String codeText,
  required int decimalDigits,
  required String locale,
  required bool showSymbol,
  required bool showCode,
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

  if (parts.numberPart.isEmpty) {
    if (showSymbol) return symbolText;
    return showCode ? codeText : '';
  }

  final String spacing = ' ' * symbolSpacing;
  final String prefix = showSymbol
      ? '$symbolText$spacing'
      : (showCode ? '$codeText$spacing' : '');
  final String body = '$prefix${parts.numberPart}';

  if (!parts.isNegative) return body;

  switch (negativeFormat) {
    case CurrencyNegativeFormat.minusSign:
      return '-$body';
    case CurrencyNegativeFormat.parentheses:
      return '($body)';
    case CurrencyNegativeFormat.trailing:
      return '$body-';
  }
}

/// Parses [value] (an [int], [double], [num], or numeric [String]) into a
/// [num], throwing if it can't be interpreted as one.
num toNumOrThrow(dynamic value) {
  if (value is num) return value;
  if (value is String) {
    final num? parsed = num.tryParse(value.trim());
    if (parsed == null) {
      throw FormatException(
        'Cannot parse "$value" as a number for currency formatting.',
      );
    }
    return parsed;
  }
  throw ArgumentError.value(
    value,
    'value',
    'Must be an int, double, num, or numeric String.',
  );
}
