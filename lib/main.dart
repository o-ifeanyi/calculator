import 'package:calculator/provider/calculator.dart';
import 'package:calculator/screens/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // prevents rotation of app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Calculator>(
      create: (ctx) => Calculator(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Color(0xFFFF9500),
          scaffoldBackgroundColor: Color(0xFF17181A),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CalculatorScreen(),
      ),
    );
  }
}
