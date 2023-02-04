import 'package:assessment/providers/news_provider.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/my_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MyApp());
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => NewsProvider())],
      child: MaterialApp(
        title: 'Assessment',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          fontFamily: 'Matter',
          primarySwatch: white,
          primaryColor: Colors.blueAccent,
          primaryColorLight: Colors.white,
          primaryColorDark: Colors.black,
        ),
        onGenerateRoute: MyRouter.generateRoute,
        initialRoute: homeRoute,
      ),
    );
  }
}
