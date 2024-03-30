import 'dart:convert';

import 'package:fast_blogs/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController(); 
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void doTheSignup() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try{
      var res = await http.post(Uri.parse("https://backend.rushikesh1.workers.dev/api/v1/signup"),
      headers: <String, String> {
        "Content-Type": "application/json"
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        })
      );

      var response; 
      if(res.statusCode == 200){
        response = jsonDecode(res.body);
      }

      const snackBar = SnackBar(
        content: Text("Invalid credentials! Please try again."),
        backgroundColor: Colors.red,
      );

      print(res.statusCode);

      if(res.statusCode != 200){
        print("into if statement");
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      //print(response["jwt"]);

      if(response["jwt"] != null){
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("token", response["jwt"]);
      }

      Navigator.pushReplacement((context), MaterialPageRoute(builder:(context) => const HomeScreen()));
    }catch(e){
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),

            const Center(
              child: Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: (){
                doTheSignup();
              }, 
              child: Text("Sign up"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),

          ],
        )
      )
    );
  }
}