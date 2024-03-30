import 'dart:convert';

import 'package:fast_blogs/screens/AddBlogsScreen.dart';
import 'package:fast_blogs/screens/SigninScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var AllBlogs = [];

  Future<void> getBlogs() async{
    print("Getting blogs");

    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    //print(token);

    try {
      var res = await http.get(
          Uri.parse("https://backend.rushikesh1.workers.dev/api/v1/blog-bulk"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": token!
          }
      );

      AllBlogs = jsonDecode(res.body);

    } catch (e) {
      const snackBar = SnackBar(
        content: Text("Something went wrong! Please try again."),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  Future<void> refreshBlogs() async {
    setState(() {
      AllBlogs = []; // Clear the existing blogs data
    });
    await getBlogs(); // Fetch fresh blogs data
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(6.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png?ssl=1",
              scale: 0.5,
            ),
          ),
        ),
        title: const Text(
          "Fast Blogs",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString("token", "");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SigninScreen())
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshBlogs(),
        child: Stack(
          children: [
            SafeArea(
              child: FutureBuilder(
                  future: getBlogs(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
        
                    return ListView.builder(
                        itemCount: AllBlogs.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 5,
        
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AllBlogs[index]["title"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AllBlogs[index]["content"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
              ),
            ),
            Positioned(
              bottom: 40.0,
              right: 40.0,
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBlogsScreen()));
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
