import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/Screen/HomePage.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _displayName;
  late String _email;

  getUser() async {
    DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (documentSnapshot.exists) {
      _email = documentSnapshot.get('email');
      _displayName =  documentSnapshot.get('displayName');
    } else {
      print('User does not exist in the database');
    }
  }

  @override
  void initState() {
    super.initState();
    getUser().whenComplete(() {
      setState((){});
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 20, 10),
                  child: new RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'Name: ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: '$_displayName',
                          style: new TextStyle(color: Colors.orange),
                        ),
                      ],
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                  child: new RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'Email id: ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: '$_email',
                          style: new TextStyle(color: Colors.orange),
                        ),
                      ],
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
        ),
        drawer: drawer(context)
    );
  }
}
