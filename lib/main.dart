import 'package:calculator/provider/calculator.dart';
import 'package:calculator/screens/calculator_screen.dart';
import 'package:calculator/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  // prevents rotation of app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SharedPreferences.getInstance().then((pref) {
    final isDark = pref.getBool('isDark') ?? false;
    runApp(MyApp(appTheme: isDark ? kDarktTheme : kLightTheme));
  });
}

class MyApp extends StatelessWidget {
  final ThemeData appTheme;
  MyApp({this.appTheme});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Calculator>(
      create: (ctx) => Calculator(theme: appTheme),
      child: Consumer<Calculator>(
        builder: (context, calc, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: calc.theme,
            home: CalculatorScreen(),
          );
        }
      ),
    );
  }
}
