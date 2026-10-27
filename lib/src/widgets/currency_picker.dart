import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/currency_display_data.dart';

final RegExp _countryCodePattern = RegExp(r'^[A-Z]{2}$');

/// Converts an ISO 3166-1 alpha-2 country code (e.g. `AE`) to its flag emoji
/// by mapping each letter to its Unicode regional indicator symbol. Returns
/// an empty string when no two-letter region code is supplied.
String countryFlagEmoji(String countryCode) {
  final String upper = countryCode.trim().toUpperCase();
  if (!_countryCodePattern.hasMatch(upper)) return '';
  final int first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(first) + String.fromCharCode(second);
}

/// One selectable entry in [CurrencyPicker], paired with a representative
/// two-letter region code used to render its flag.
class CurrencyOption {
  const CurrencyOption({required this.currencyCode, required this.countryCode});

  /// The ISO 4217 currency code, e.g. `AED`, or a stable local identifier for
  /// currencies with no ISO code. Check [isIso4217] before using a code with
  /// external services.
  final String currencyCode;

  /// The two-letter flag region, including `EU` for the euro. May be empty
  /// for territories without a Unicode region flag.
  final String countryCode;

  /// The flag emoji for [countryCode].
  String get flag => countryFlagEmoji(countryCode);

  /// A readable currency name, for example `UAE Dirham` or `US Dollar`.
  String get name => _displayData?.name ?? currencyCode;

  /// Whether this option has an ISO 4217 code in the circulating-currency
  /// reference. Local identifiers such as `GGP` and `TVD` return false.
  bool get isIso4217 => _displayData?.isIso4217 ?? false;

  CurrencyDisplayData? get _displayData =>
      circulatingCurrencyData[currencyCode.trim().toUpperCase()];

  /// The currency symbol shown by the picker, including bundled symbols for
  /// AED, SAR, OMR, and MVR.
  String get symbol =>
      _displayData?.symbol ??
      NumberFormat.simpleCurrency(
        locale: 'en_US',
        name: currencyCode.trim().toUpperCase(),
      ).currencySymbol;

  /// Bundled font family for currencies whose official symbol needs one.
  String? get symbolFontFamily => _displayData?.symbolFontFamily;
}

/// Every distinct currency from the circulating-currency reference, sorted
/// by currency code. Includes local currencies without ISO 4217 codes and is
/// unmodifiable; provide [CurrencyPicker.options] to use a filtered list.
final List<CurrencyOption> allCurrencyOptions = _buildCurrencyOptions();

List<CurrencyOption> _buildCurrencyOptions() {
  final List<CurrencyOption> options = circulatingCurrencyData.entries
      .map(
        (MapEntry<String, CurrencyDisplayData> entry) => CurrencyOption(
          currencyCode: entry.key,
          countryCode: entry.value.countryCode,
        ),
      )
      .toList()
    ..sort(
      (CurrencyOption a, CurrencyOption b) =>
          a.currencyCode.compareTo(b.currencyCode),
    );
  return List<CurrencyOption>.unmodifiable(options);
}

/// Builds the widget shown for [option] in a [CurrencyPicker]'s button and
/// menu.
typedef CurrencyOptionBuilder = Widget Function(
    BuildContext context, CurrencyOption option);

/// A dropdown for picking a currency, showing its country flag, currency name,
/// and symbol.
///
/// ```dart
/// CurrencyPicker(
///   value: 'AED',
///   onChanged: (code) => setState(() => selected = code),
/// )
/// ```
///
/// The custom popup menu highlights the selected currency and displays a
/// checkmark. Customize the field with [decoration] and menu colors with
/// [dropdownColor] and [selectedItemColor]. Use [dropdownConstraints],
/// [dropdownShape], and [itemPadding] to adjust the popup layout. Customize
/// each row with [itemBuilder], and the closed field with [selectedItemBuilder].
class CurrencyPicker extends StatelessWidget {
  const CurrencyPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.options,
    this.label,
    this.decoration,
    this.style,
    this.dropdownColor,
    this.borderRadius,
    this.showFlag = true,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.dropdownIcon,
    this.dropdownConstraints = const BoxConstraints(
      minWidth: 220,
      maxHeight: 360,
    ),
    this.dropdownOffset = const Offset(0, 8),
    this.dropdownElevation = 8,
    this.dropdownShape,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.itemHeight = kMinInteractiveDimension,
    this.selectedItemColor,
    this.showSelectedCheckmark = true,
  })  : assert(dropdownElevation >= 0),
        assert(itemHeight >= 0);

  /// The selected currency code or local identifier from [options].
  final String value;

  /// Called with the newly selected currency code when the user picks one.
  final ValueChanged<String> onChanged;

  /// The list of selectable currencies. Defaults to [allCurrencyOptions]
  /// (every currency known to this package) when null.
  final List<CurrencyOption>? options;

  /// Label shown on the dropdown's form field. Defaults to `'Currency'`.
  /// Ignored when [decoration] is provided.
  final String? label;

  /// Full control over the field's chrome (border, fill, padding, etc).
  /// Overrides [label] when provided.
  final InputDecoration? decoration;

  /// Text style applied to each option's name and currency symbol.
  ///
  /// Bundled symbols retain their required font family. Ignored when a custom
  /// builder supplies the content.
  final TextStyle? style;

  /// Background color of the open dropdown menu.
  final Color? dropdownColor;

  /// Corner radius of the field and the open dropdown menu. Defaults to 12.
  /// [dropdownShape] overrides the menu's shape when provided.
  final BorderRadius? borderRadius;

  /// Whether to show the country flag at the start of each row. Ignored
  /// when [itemBuilder] is provided.
  final bool showFlag;

  /// Overrides the default flag, name, and symbol row for each menu option.
  /// Also used in the closed field unless [selectedItemBuilder] is provided.
  final CurrencyOptionBuilder? itemBuilder;

  /// Builds only the selected value in the closed field.
  /// Defaults to [itemBuilder], or the default row when neither is supplied.
  final CurrencyOptionBuilder? selectedItemBuilder;

  /// Widget displayed after the selected currency. Defaults to a small arrow.
  /// Use `SizedBox.shrink()` to hide it.
  final Widget? dropdownIcon;

  /// Size constraints for the popup. Defaults to a minimum width of 220 and
  /// a maximum height of 360 logical pixels. Longer menus scroll.
  final BoxConstraints dropdownConstraints;

  /// Position adjustment for the popup, in logical pixels.
  final Offset dropdownOffset;

  /// Elevation of the popup's shadow. Defaults to 8.
  final double dropdownElevation;

  /// Custom popup shape, including its border and corner radius.
  /// Defaults to a rounded border using [borderRadius].
  final ShapeBorder? dropdownShape;

  /// Padding around each menu row's content.
  final EdgeInsetsGeometry itemPadding;

  /// Minimum menu row height. Defaults to [kMinInteractiveDimension] (48).
  /// Rows grow when their content and [itemPadding] require more space.
  final double itemHeight;

  /// Background color of the selected menu row.
  /// Defaults to the theme's primary container color.
  final Color? selectedItemColor;

  /// Whether the menu reserves space for a selected-row checkmark.
  final bool showSelectedCheckmark;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(12);
    final List<CurrencyOption> currencyOptions = options ?? allCurrencyOptions;
    final CurrencyOption selectedOption = currencyOptions.firstWhere(
      (CurrencyOption option) => option.currencyCode == value,
      orElse: () => CurrencyOption(
        currencyCode: value,
        countryCode:
            circulatingCurrencyData[value.trim().toUpperCase()]?.countryCode ??
                '',
      ),
    );

    Widget buildOptionContent(CurrencyOption option) {
      if (itemBuilder != null) return itemBuilder!(context, option);
      return Row(
        children: <Widget>[
          if (showFlag && option.flag.isNotEmpty) ...<Widget>[
            Text(option.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              option.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            option.symbol,
            style: (style ?? const TextStyle()).copyWith(
              fontFamily: option.symbolFontFamily,
              fontWeight: style?.fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final InputDecoration fieldDecoration = decoration ??
        InputDecoration(
          labelText: label ?? 'Currency',
          border: OutlineInputBorder(borderRadius: radius),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        );
    final Color menuColor =
        dropdownColor ?? Theme.of(context).colorScheme.surface;
    final Color selectedColor =
        selectedItemColor ?? Theme.of(context).colorScheme.primaryContainer;

    return PopupMenuButton<String>(
      tooltip: 'Select currency',
      offset: dropdownOffset,
      color: menuColor,
      elevation: dropdownElevation,
      shape: dropdownShape ??
          RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
      constraints: dropdownConstraints,
      onSelected: onChanged,
      itemBuilder: (BuildContext menuContext) => <PopupMenuEntry<String>>[
        for (final CurrencyOption option in currencyOptions)
          PopupMenuItem<String>(
            value: option.currencyCode,
            height: itemHeight,
            padding: EdgeInsets.zero,
            child: Container(
              constraints: BoxConstraints(minHeight: itemHeight),
              decoration: BoxDecoration(
                color: option.currencyCode == value ? selectedColor : null,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: itemPadding,
              child: Row(
                children: <Widget>[
                  Expanded(child: buildOptionContent(option)),
                  if (showSelectedCheckmark) ...<Widget>[
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 16,
                      child: option.currencyCode == value
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: Theme.of(menuContext).colorScheme.primary,
                            )
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
      child: InputDecorator(
        decoration: fieldDecoration,
        isEmpty: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: selectedItemBuilder?.call(context, selectedOption) ??
                  buildOptionContent(selectedOption),
            ),
            const SizedBox(width: 8),
            dropdownIcon ?? const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }
}
