import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


Widget drawer(BuildContext context) {
  return new  Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
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
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Groups'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("Groups");
          },
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("Profile");
          },
        ),
      ],
    ),
  );
}


late String username;

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late String displayName;
  late User firebaseUser;
  bool isLoggedIn = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Start");
      }
    });
  }

  getUser() async {
    firebaseUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (documentSnapshot.exists) {
      displayName =  documentSnapshot.get('displayName');
      username = displayName;
    } else {
      print('User does not exist in the database');
    }

    setState(() {
      isLoggedIn = true;
    });

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
    getUser().whenComplete(() {
      setState((){});
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                title: Text('Home'),
              ),
        body: Container(
        child: !isLoggedIn
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
            ])
              ],
            ): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(25, 10, 30, 10),
                  child: new RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'Welcome to ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: 'Treklocation',
                          style: new TextStyle(color: Colors.blue),
                        ),
                      ],
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Text(
                    "Hello $displayName!",
                    style:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal, color: Colors.orange),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: new RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'To see your groups move to ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: 'Groups Page.',
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed("Groups");
                            },
                        ),
                      ],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: new RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'To see your profile move to ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: 'Profile Page.',
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed("Profile");
                            },
                        ),
                      ],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  ),
                  onPressed: signOut,
                  child: Text('Sign Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),

                )
              ],
            ),
          ]
        ),
    ) ,
          drawer: drawer(context)
    );
  }
}
