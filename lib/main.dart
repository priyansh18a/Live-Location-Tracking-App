import 'package:authentification/Screen/Login.dart';
import 'package:authentification/Screen/SignUp.dart';
import 'package:authentification/Screen/Start.dart';
import 'package:authentification/Screen/Map.dart';
import 'package:authentification/Screen/Groups.dart';
import 'package:authentification/Screen/Search.dart';
import 'package:authentification/Screen/EditMembers.dart';
import 'package:authentification/Screen/Profile.dart';
import 'package:flutter/material.dart';
import 'Screen/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),

      routes: <String,WidgetBuilder>{
        "Login" : (BuildContext context)=>Login(),
        "SignUp":(BuildContext context)=>SignUp(),
        "Start":(BuildContext context)=>Start(),
        "Profile":(BuildContext context)=>Profile(),
        "Map":(BuildContext context)=>Map(),
        "Groups":(BuildContext context)=>Groups(),
        "Search":(BuildContext context)=>Search(),
        "EditMembers":(BuildContext context)=>EditMembers(),
      },
      
    );
  }

}



