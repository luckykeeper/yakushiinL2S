// YakushiinL2S. Convert Dual Language Lrc To Srt For YakushiinPlayer. (webapp)
// @CreateTime    : 2025/06/17 13:38
// @Author        : Luckykeeper
// @Email         : luckykeeper@luckykeeper.site
// @Project       : YakushiinL2S(webapp)

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:webapp/pages/l2s_app_page.dart';

void main() async {
  // https://github.com/miguelpruivo/flutter_file_picker/issues/1616
  // https://github.com/miguelpruivo/flutter_file_picker/issues/1602#issuecomment-2870217776
  if (kIsWeb) {
    FilePickerWeb.registerWith(Registrar());
  }
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(ProviderScope(child: YakushiinApp(savedThemeMode: savedThemeMode)));
}

class YakushiinApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const YakushiinApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.cyan,
          surfaceContainerLow: Color(0xFFF2FBFC),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          surfaceContainerLow: Color(0xFF152324),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('zh')],
        title: 'YakushiinL2S',
        theme: theme,
        darkTheme: darkTheme,
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: botToastBuilder,
        initialRoute: "/",
        routes: {"/": (context) => const L2sAppPage()},
      ),
      debugShowFloatingThemeButton: true,
    );
  }
}
