import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './pages/landing.dart';

import 'package:flutter/services.dart';

import 'stores/stores.dart' show MemoData;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => MemoData(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papership',
      theme: ThemeData(
        brightness: Brightness.light,
        highlightColor: Colors.white.withOpacity(.25),
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.blue),
        ),
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(color: Colors.blue),
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.blue),
          ),
          actionsIconTheme: IconThemeData(color: Colors.blue),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          hoverColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.25),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        highlightColor: Colors.white.withOpacity(.25),
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.blue),
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          backwardsCompatibility: false,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(color: Colors.blue),
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.blue),
          ),
          actionsIconTheme: IconThemeData(color: Colors.blue),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          hoverColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.25),
        ),
      ),
      home: Landing(),
    );
  }
}
