/// Controls how negative amounts are rendered by [AedCurrencyFormatter] and
/// [SarCurrencyFormatter].
enum CurrencyNegativeFormat {
  /// Prefixes the whole formatted string with a minus sign, e.g. `-AED 10.00`.
  minusSign,

  /// Wraps the formatted string in parentheses, e.g. `(AED 10.00)`.
  parentheses,

  /// Appends a trailing minus sign, e.g. `AED 10.00-`.
  trailing,
}
