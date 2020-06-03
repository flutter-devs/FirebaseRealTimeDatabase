import 'dart:convert';

import 'package:firebaseapp/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  List<Profile> userProfile = [];

  bool isloading = false;

  Future<void> sendData() async {
    setState(() {
      isloading = true;
    });
    await http.post("https://fir-flutter-d60b0.firebaseio.com/userprofile.json",
        body: json.encode({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
        }));
    setState(() {
      isloading = false;
    });
    setState(() {
      userProfile.add(Profile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
      ));
    });
  }

  Future<void> fetchtheprofiles() async {
    final response = await http
        .get("https://fir-flutter-d60b0.firebaseio.com/userprofile.json?");
    print(json.decode(response.body));
    final List<Profile> loadedProfile = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((profileId, profileData) {
      loadedProfile.add(
        Profile(
          email: profileData['email'],
          lastName: profileData['firstName'],
          firstName: profileData['lastName'],
        ),
      );
    });
    userProfile = loadedProfile;
  }

  @override
  void initState() {
    fetchtheprofiles();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("User Profile"),
            leading: Icon(Icons.verified_user,color: Colors.green,),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'email'),
                ),
               isloading?CircularProgressIndicator(): FlatButton(
                  child: Text("Send"),
                  color: Colors.indigo,
                  onPressed: sendData,
                ),
                Container(
                        child: Column(
                          children: userProfile
                              .map((ctx) => Profile(
                                    firstName: ctx.firstName,
                                    lastName: ctx.lastName,
                                    email: ctx.email,
                                  ))
                              .toList(),
                        ),
                      )
              ],
            ),
          )),
    );
  }
}
