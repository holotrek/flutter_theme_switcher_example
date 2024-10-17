import 'package:flutter/material.dart';
import 'package:flutter_theme_switcher_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeSetting extends StatelessWidget {
  const ThemeModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingLabel(),
        SettingValue(),
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
      'Dark/Light Mode:',
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
  bool? _isDark;

  static const List<(bool?, String)> _states = [
    (null, 'System'),
    (false, 'Light'),
    (true, 'Dark'),
  ];

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      final isDark = prefs.getBool('APP_THEME_MODE');
      setState(() => _isDark = isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    void setDark(bool? isDark) {
      setState(() => _isDark = isDark);
      if (isDark == null) {
        _prefs.then((prefs) => prefs.remove('APP_THEME_MODE'));
      } else {
        _prefs.then((prefs) => prefs.setBool('APP_THEME_MODE', isDark));
      }
      App.setTheme(context, isDark: () => isDark);
    }

    return ToggleButtons(
      isSelected: _states.map((e) => e.$1 == _isDark).toList(),
      children: _states.map((e) => Text(e.$2)).toList(),
      onPressed: (index) => setDark(_states[index].$1),
    );
  }
}
