import 'package:flutter/material.dart';
import 'package:gulf_currency/gulf_currency.dart';

const Color _ink = Color(0xFF191433);
const Color _muted = Color(0xFF827D9C);
const Color _purple = Color(0xFF7C3AED);
const Color _blue = Color(0xFF245BDB);

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gulf Currency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _purple),
        scaffoldBackgroundColor: const Color(0xFFFAF7FF),
      ),
      home: const _ExampleScreen(),
    );
  }
}

class _ExampleScreen extends StatelessWidget {
  const _ExampleScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFFCF9FF), Color(0xFFF3EDFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _ExampleHeader(),
                    const SizedBox(height: 24),
                    const _CurrencyPickerDemo(),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Example Currencies',
                      subtitle: 'Using CurrencyText widget',
                      child: Column(
                        children: <Widget>[
                          for (int i = 0; i < _samples.length; i++) ...<Widget>[
                            if (i > 0) const SizedBox(height: 8),
                            _CurrencySampleRow(sample: _samples[i]),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleHeader extends StatelessWidget {
  const _ExampleHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFA76BFA), Color(0xFF7138EF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x267C3AED),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child:
              const Icon(Icons.payments_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Gulf Currency',
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 4),
              Text('Example UI', style: TextStyle(color: _muted, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x087C3AED),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: _ink,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _CurrencySample {
  const _CurrencySample({
    required this.option,
    required this.locale,
    required this.color,
    required this.backgroundColor,
    this.value,
  });

  final CurrencyOption option;
  final String locale;
  final Color color;
  final Color backgroundColor;
  final num? value;
}

const List<_CurrencySample> _samples = <_CurrencySample>[
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'USD', countryCode: 'US'),
    locale: 'en_US',
    color: Color(0xFF168552),
    backgroundColor: Color(0xFFE3F3EB),
  ),
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'JPY', countryCode: 'JP'),
    locale: 'ja_JP',
    color: Color(0xFFD32346),
    backgroundColor: Color(0xFFFFE4EB),
    value: 1250,
  ),
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'GBP', countryCode: 'GB'),
    locale: 'en_GB',
    color: Color(0xFF1954D6),
    backgroundColor: Color(0xFFE3EBFF),
  ),
  // CurrencyText automatically delegates to AedText/SarText
  // when the resolved currency is AED or SAR.
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'AED', countryCode: 'AE'),
    locale: 'en_AE',
    color: _purple,
    value: 1250,
    backgroundColor: Color(0xFFF1E6FF),
  ),
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'SAR', countryCode: 'SA'),
    locale: 'ar_SA',
    color: Color(0xFFB96113),
    backgroundColor: Color(0xFFFFEFE1),
  ),
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'OMR', countryCode: 'OM'),
    locale: 'en_OM',
    color: Color(0xFF078AB5),
    value: 1250,
    backgroundColor: Color(0xFFE1F4FC),
  ),
  _CurrencySample(
    option: CurrencyOption(currencyCode: 'MVR', countryCode: 'MV'),
    locale: 'en_MV',
    color: Color(0xFFD52668),
    value: 1250,
    backgroundColor: Color(0xFFFFE4EF),
  ),
];

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.option, this.size = 36});

  final CurrencyOption option;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: option.flag.isEmpty
          ? Icon(Icons.public, size: size * 0.65, color: _muted)
          : Text(
              option.flag,
              style: TextStyle(fontSize: size * 0.8, height: 1),
            ),
    );
  }
}

class _CurrencySampleRow extends StatelessWidget {
  const _CurrencySampleRow({required this.sample});

  final _CurrencySample sample;

  @override
  Widget build(BuildContext context) {
    final Widget description = Row(
      children: <Widget>[
        _FlagBadge(option: sample.option),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                sample.option.name,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'CurrencyText (${sample.locale})',
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
    final Widget amount = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: sample.backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: CurrencyText(
          sample.value,
          currencyCode: sample.option.currencyCode,
          locale: sample.locale,
          maxLines: 1,
          style: TextStyle(
            color: sample.color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6FE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 260) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                description,
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: amount),
              ],
            );
          }
          return Row(
            children: <Widget>[
              Expanded(child: description),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.45,
                ),
                child: amount,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CurrencyPickerDemo extends StatefulWidget {
  const _CurrencyPickerDemo();

  @override
  State<_CurrencyPickerDemo> createState() => _CurrencyPickerDemoState();
}

class _CurrencyPickerDemoState extends State<_CurrencyPickerDemo> {
  String _currencyCode = 'AED';

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Currency Picker',
      subtitle: 'Select a currency to see the formatted value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double menuWidth =
                  constraints.maxWidth.clamp(0, 420).toDouble();
              return CurrencyPicker(
                value: _currencyCode,
                onChanged: (String code) =>
                    setState(() => _currencyCode = code),
                style: const TextStyle(fontSize: 14, color: _ink),
                dropdownColor: Colors.white,
                selectedItemColor: const Color(0xFFF1E9FF),
                borderRadius: BorderRadius.circular(16),
                dropdownConstraints: BoxConstraints(
                  minWidth: menuWidth,
                  maxWidth: menuWidth,
                  maxHeight: 360,
                ),
                dropdownOffset: const Offset(0, 8),
                itemHeight: 56,
                itemPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                dropdownIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: _muted,
                ),
                decoration: InputDecoration(
                  labelText: 'Currency',
                  labelStyle: const TextStyle(color: _muted, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD8D0E8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _purple, width: 1.5),
                  ),
                ),
                selectedItemBuilder:
                    (BuildContext context, CurrencyOption option) {
                  return Row(
                    children: <Widget>[
                      _FlagBadge(option: option, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${option.currencyCode} – ${option.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _ink, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        option.symbol,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 16,
                          fontFamily: option.symbolFontFamily,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFEDF1FF), Color(0xFFE4EBFF)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget amount = FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: CurrencyText(
                    1250.75,
                    currencyCode: _currencyCode,
                    locale: 'en_US',
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: _blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
                const Widget label = Text(
                  'Selected currency',
                  style: TextStyle(color: _muted, fontSize: 12),
                );
                if (constraints.maxWidth < 240) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      label,
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerRight, child: amount),
                    ],
                  );
                }
                return Row(
                  children: <Widget>[
                    const Expanded(child: label),
                    const SizedBox(width: 12),
                    Expanded(child: amount),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
