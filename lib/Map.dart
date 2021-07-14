
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';



class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Completer<GoogleMapController> mapController = Completer();
  Location location = new Location();
  final geo = Geoflutterfire();




  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("Start");
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  userLocation() async {
    var pos = await location.getLocation();
    GeoFirePoint myLocation = geo.point(latitude: pos.latitude, longitude:  pos.longitude);
    firestore.collection('locations')
        .add({'name': 'myLocation', 'position': myLocation.data});
  }


  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.userLocation();
  }

  @override
  build(context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Google Map'),
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
                    title: Text('Map'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("Map");
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
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(37.42796133580664, -122.085749655962),
                      zoom: 14.4746,
                    ),
                    onMapCreated: _onMapCreated ,
                    myLocationEnabled: true,
                  )]
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: _goToTheLake,
                  label: Text('To the lake!'),
                  icon: Icon(Icons.location_on),
                ),
    );
  }


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(37.43296265331, -122.08832357078792),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414)));
  }

}


