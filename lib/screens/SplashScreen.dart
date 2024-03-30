import 'package:fast_blogs/screens/HomeScreen.dart';
import 'package:fast_blogs/screens/SigninScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "FAST BLOGS",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void whereToGo() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    //print(token);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (token != null) {
            if (token != "") {
              return const HomeScreen();
            } else {
              return const SigninScreen();
            }
          } else {
            return const SigninScreen();
          }
        }),
      );
    });
  }
}
