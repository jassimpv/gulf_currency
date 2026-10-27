## 2.0.1

- Null, empty, or whitespace-only amounts now display only the currency symbol; example amount badges are constrained to prevent horizontal overflow.
- Added a shared catalog of circulating currency names, symbols, and representative flags, including local currencies without ISO codes.
- Updated the default picker to use the circulating currency catalog and expose `CurrencyOption.isIso4217`.
- Added `CurrencyText.currencyCode` for formatting the selected currency independently of its display locale.
- Updated current locale currency mappings and redesigned the example with currency cards and a selected amount preview.

## 2.0.0

- **Breaking:** package renamed from `gulf_currency_formatter` to `gulf_currency`. Update your `pubspec.yaml` dependency and import statements accordingly.
- Added a `CurrencyPicker` dropdown widget for selecting a currency with its country flag, customizable via `decoration`, `style`, `dropdownColor`, `borderRadius`, `showFlag`, and `itemBuilder`.

## 1.1.0

- Added MVR (Maldivian Rufiyaa) support, with bundled official symbol font.

## 1.0.4

- Shortened pubspec description to meet pub.dev's 60-180 character guidance.

## 1.0.3

- Added link to the Medium article in the README.

## 1.0.2

- Updated README screenshot reference path.

## 1.0.1

- Fixed README screenshot rendering.
- Removed duplicate screenshot block in README.

## 1.0.0

- First public release on pub.dev.
- Currency formatting for numeric values and numeric strings.
- Bundled symbol font support for AED, SAR, and OMR.
- Generic locale-driven currency formatting for other currencies.
