// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:fast_blogs/screens/HomeScreen.dart';
import 'package:fast_blogs/screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void SigninRequestKaro() async {
    String email = emailController.text;
    String password = passwordController.text;

    print(email);
    print(password);

    try{
      var res = await http.post(Uri.parse("https://backend.rushikesh1.workers.dev/api/v1/signin"), 
      headers: <String, String>{
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "email": email,
        "password": password
      }));
      
      print(res.statusCode);
      
      var response = jsonDecode(res.body);

      const snackBar = SnackBar(
        content: Text("Invalid credentials! Please try again."),
        backgroundColor: Colors.red,
      );

      if(res.statusCode != 200){
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      //print(response["jwt"]);

      if(response["jwt"] != null){
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("token", response["jwt"]);
      }

      Navigator.pushReplacement((context), MaterialPageRoute(builder:(context) => const HomeScreen()));

    } catch(e){
      print('Error $e');

      const snackBar = SnackBar(
        content: Text("Something went wrong! Please try again."),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Fast Blogs", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            const Center(child: Text("Welcome back to Fast Blogs!!", style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500
            ),)),

            const SizedBox(height: 150,),
            const Center(child: Text("Sign in to continue...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500
                  ),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder:(context) => const SignupScreen(),
                      ));
                    },
                    child: Text("Sign up", style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade600
                    ),),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0) 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2
                    )
                  ),
                  focusColor: Colors.grey
                ),
              ),
            ),

            const SizedBox(height: 30,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: const Icon(Icons.visibility),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0) 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2
                    )
                  )
                ),
              ),
            ),

            const SizedBox(height: 30,),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  SigninRequestKaro();      
                },
                child: Text("Sign in"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
