import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddBlogsScreen extends StatefulWidget {
  const AddBlogsScreen({super.key});

  @override
  State<AddBlogsScreen> createState() => _AddBlogsScreenState();
}

class _AddBlogsScreenState extends State<AddBlogsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void blogAddKaro() async {
    String title = titleController.text;
    String content = contentController.text;

    // print(title);
    // print(content);

    var prefs = await SharedPreferences.getInstance();

    var token = prefs.get("token");

    // print(token);

    // Add the code to add the blog here

    try{
      var res = await http.post(Uri.parse("https://backend.rushikesh1.workers.dev/api/v1/blog"),
      headers: <String, String>{
        "Content-Type": "application/json",
        "authorization": token.toString()
      },
      body: jsonEncode({
        "title": title,
        "content": content
      }));

      // print(res.statusCode);
      // print(res.body);


      if(res.statusCode != 200){
        
        const snackbar = SnackBar(
          content: Text("Blog added successfully!"),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return;
      }

      const snackbar = SnackBar(
        content: Text("Blog added successfully!"),
        backgroundColor: Colors.green,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } catch(e){
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Blogs",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                minLines: 6,
                maxLines: null,
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed: (){
                blogAddKaro();
              }, 
              child: const Text("Add Blog"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              )
            )
          ]
        )
      )
    );
  }
}