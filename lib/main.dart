import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:pHUST/screen/home/home_screen.dart';
import 'package:pHUST/screen/login/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  ThemeMode themeMode = ThemeMode.system;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final localeString = prefs.getString('selectedLocale');
  final userNumber = prefs.getString(USER_NUMBER);
  bool isFirstOpen = true;
  if (userNumber == "" || userNumber == null) {
    isFirstOpen = true;
  } else {
    isFirstOpen = false;
  }
  Locale? locale;
  if (localeString != null) {
    final parts = localeString.split('_');
    locale = Locale(parts[0], parts.length > 1 ? parts[1] : "");
  }

  initializeDateFormatting('en', null);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeMode),
        ),
      ],
      child: EasyLocalization(
          supportedLocales: SUPPORT_LANGUAGES,
          useFallbackTranslations: true,
          path: 'assets/translations',
          startLocale: locale,
          fallbackLocale: const Locale('en', 'US'),
          child: MainApp(isFirstOpen: isFirstOpen)
          // ),
          )));
}

class MainApp extends StatefulWidget {
  final bool isFirstOpen;
  const MainApp({super.key, required this.isFirstOpen});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool get isFirstOpen => widget.isFirstOpen;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: isFirstOpen ? LoginScreen() : HomeScreen());
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider(this.themeMode);
}
