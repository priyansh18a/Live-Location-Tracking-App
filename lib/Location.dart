
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  bool isloggedin = false;


  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Start");
      }
    });
  }

  getLocation() async {




  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Treklocation',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Welcome to Treklocation'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children:  <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Treklocation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Location'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("Location");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),

                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
            body: Container(
              child: !isloggedin
                  ? CircularProgressIndicator()
                  : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      "Hello you are logged in using mail id ",
                      style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    ),
                    onPressed: getLocation,
                    child: Text('Get Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),

                  )
                ],
              ),
            ))
    );
  }
}


