import 'package:flutter/material.dart';
import 'package:flutter_theme_switcher_example/theme_color_setting.dart';
import 'package:flutter_theme_switcher_example/theme_mode_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();

  static void setTheme(
    BuildContext context, {
    Color Function()? themeColor,
    bool? Function()? isDark,
  }) {
    final state = context.findAncestorStateOfType<_AppState>();
    state?.setTheme(themeColor, isDark);
  }
}

class _AppState extends State<App> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Color _seedColor = Colors.blue;
  bool? _isDark;

  void setTheme(Color Function()? themeColor, bool? Function()? isDark) {
    setState(() {
      _seedColor = themeColor == null ? _seedColor : themeColor();
      _isDark = isDark == null ? _isDark : isDark();
    });
  }

  @override
  void initState() {
    super.initState();

    // Setup theme
    _prefs.then((SharedPreferences prefs) {
      final isDark = prefs.getBool('APP_THEME_MODE');
      final colorVal = prefs.getInt('APP_THEME_COLOR') ?? Colors.blue.value;
      final color = Color(colorVal);
      setTheme(() => color, () => isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(ThemeData baseTheme, Brightness brightness) {
      return baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: brightness,
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Theme Switcher',
      theme: buildTheme(ThemeData.light(), Brightness.light),
      darkTheme: buildTheme(ThemeData.dark(), Brightness.dark),
      themeMode: _isDark == true
          ? ThemeMode.dark
          : _isDark == false
              ? ThemeMode.light
              : ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Theme Switcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemeColorSetting(),
            SizedBox(height: 20),
            ThemeModeSetting(),
          ],
        ),
      ),
    );
  }
}
