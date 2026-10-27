/// Format int, double, num, and String values as currency text and widgets.
///
/// UAE Dirham (AED), Saudi Riyal (SAR), Omani Rial (OMR), and Maldivian Rufiyaa
/// (MVR) use bundled symbol fonts. Other circulating currencies use shared
/// display metadata and `package:intl` for number formatting. Currencies can
/// be chosen explicitly by code or resolved from a locale.
library gulf_currency;

export 'src/data/currency_locale_data.dart'
    show currencyCodeForLocale, systemLocale;
export 'src/formatting/currency_negative_format.dart';
export 'src/widgets/currency_picker.dart';
export 'src/widgets/currency_text.dart';
