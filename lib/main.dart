import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{

  await Hive.initFlutter();
  await Hive.openBox('money');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    //statusbar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.amber,
      systemNavigationBarColor: Colors.transparent
    )
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.amber),
      home: const Homepage(),
    );
  }
}