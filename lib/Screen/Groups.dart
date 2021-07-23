import 'package:authentification/Utilities/Members.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/Screen/HomePage.dart';
import 'package:authentification/Utilities/GroupMap.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String _username;

  getUser() async {
    _username = '' ;
    DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (documentSnapshot.exists) {
        _username =  documentSnapshot.get('displayName');
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
        title: Text('Groups'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: StreamBuilder(
                  stream: firestore.collection('groups').where('users', arrayContains: _username).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((element) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 8.2,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Card(
                                color: Colors.orange,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Container(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                          element['groupName'],
                                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight:FontWeight.bold),
                                        ),
                                      ),
                                      subtitle: Text(
                                          element["users"].join(",  "),
                                          style: TextStyle(color: Colors.black,)
                                      ),
                                      trailing: element['admin']==_username? PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Edit Members"),
                                              value: 1,
                                            ),
                                            PopupMenuItem(
                                              child: Text("Delete Group") ,
                                              value: 2,
                                            )
                                          ],
                                          onSelected: (value) {
                                            if(value == 1){
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => Members(
                                                  sltUsernames: element['users'],
                                                  grpName: element['groupName'],
                                                  grpId: element.id,
                                                ),
                                              ),
                                              );
                                            }
                                            if(value == 2){
                                              firestore.collection('groups').doc(element.id)
                                                  .delete()
                                                  .then((value) => print("User Deleted"))
                                                  .catchError((error) => print("Failed to delete user: $error"));
                                            }
                                          },
                                      ): PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text("Leave Group") ,
                                              value: 1,
                                            ),
                                          ],
                                        onSelected: (value) {
                                          if(value == 1){
                                            firestore.collection('groups').doc(element.id)
                                                .update({
                                                'users': FieldValue.arrayRemove(<String>[_username])
                                                }).then((value) => print("User Deleted"))
                                                .catchError((error) => print("Failed to delete user: $error"));
                                          }
                                        },
                                      ) ,
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => GroupMap(
                                            groupId: element.id.toString(),
                                            title: element['groupName'].toString(),
                                          ),
                                        ),
                                        );
                                        },
                                    ),
                                  ]
                                )
                              )
                            )
                        );
                      }).toList(),
                    );
                    },
              )
            )
          ]
        )
      ),
      drawer: drawer(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("Search");
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),

    );
  }
}
