import 'package:fast_blogs/screens/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fast Blogs",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Scaffold(
        body: SplashScreen(),
      )
    );
  }
}


