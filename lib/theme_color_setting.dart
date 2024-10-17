import 'package:flutter/material.dart';
import 'package:flutter_theme_switcher_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColorSetting extends StatelessWidget {
  const ThemeColorSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingLabel(),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 250),
          child: const SettingValue(),
        ),
      ],
    );
  }
}

class SettingLabel extends StatelessWidget {
  const SettingLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'App Color:',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class SettingValue extends StatefulWidget {
  const SettingValue({
    super.key,
  });

  @override
  State<SettingValue> createState() => _SettingValueState();
}

class _SettingValueState extends State<SettingValue> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _color = Colors.blue.value;

  static const List<(String, Color)> _themeColors = [
    ('Red', Colors.red),
    ('Deep Orange', Colors.deepOrange),
    ('Orange', Colors.orange),
    ('Amber', Colors.amber),
    ('Yellow', Colors.yellow),
    ('Lime', Colors.lime),
    ('Green', Colors.green),
    ('Teal', Colors.teal),
    ('Cyan', Colors.cyan),
    ('Blue', Colors.blue),
    ('Indigo', Colors.indigo),
    ('Deep Purple', Colors.deepPurple),
    ('Purple', Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      final themeColor = prefs.getInt('APP_THEME_COLOR') ?? Colors.blue.value;
      setState(() => _color = themeColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    void setColor(int? colorVal) {
      final valOrDefault = colorVal ?? Colors.blue.value;
      setState(() => _color = valOrDefault);
      _prefs.then((prefs) => prefs.setInt('APP_THEME_COLOR', valOrDefault));
      App.setTheme(context, themeColor: () => Color(valOrDefault));
    }

    return DropdownButtonFormField(
      items: _themeColors.map((c) {
        return DropdownMenuItem(
          value: c.$2.value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: 100,
                  child: ColoredBox(
                    color: c.$2,
                  ),
                ),
                const SizedBox(width: 10),
                Text(c.$1),
              ],
            ),
          ),
        );
      }).toList(),
      value: _color,
      onChanged: setColor,
    );
  }
}
