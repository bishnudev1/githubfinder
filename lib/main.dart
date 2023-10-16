import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? username;
  var userData;
  TextEditingController _usernameController = TextEditingController();
  

  Future<void> searchUser ()async{

    

    final uri = Uri.parse("https://api.github.com/users/${username}");
    final res = await http.get(uri);
    
    final data = jsonDecode(res.body);
    //log(data["name"]);
    setState(() {
      userData = data;
    });
    log(userData["name"]);
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Github Finder"),
        ),
        body: SafeArea(child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(userData == null ? "No Data" : userData["name"]),
              TextFormField(
                controller: _usernameController,
                validator: (value){
                  return value!.isEmpty || value.length < 2 ? "Enter username" : null;
                },
              ),
              SizedBox(height: 10,),
              ActionChip(label: Text("Search User",
              ),
              onPressed: ()async{
                if(_key.currentState!.validate()){
                  setState(() {
                    username = _usernameController.text.trim();
                  });
                  await searchUser();

                }
              },
              )
            ],
          ),
        )),
      ),
    );
  }
}
