
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleMapController mapController;


  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Start");
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }


  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Location'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children:  <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.orange,
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
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("/");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
            body:Stack(
                children: [
                GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
                mapType: MapType.normal,
                ),
            ]
        )
    );
  }
}


