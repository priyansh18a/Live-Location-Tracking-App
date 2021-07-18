import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'package:authentification/HomePage.dart';

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
  BehaviorSubject<double> radius = BehaviorSubject();
  StreamSubscription subscription;
  Set<Marker> customMarkers = {};

  double lat ;
  double long;


  void _onMapCreated(GoogleMapController controller)
  {
    // location.onLocationChanged.listen((position) {
    //   GeoFirePoint myLocation = geo.point(
    //       latitude: position.latitude, longitude: position.longitude);
      // firestore.collection('locations')
      //     .add({'name': 'myLocation', 'position': myLocation.data});
    // });
    mapController.complete(controller);
  }

  void _updateMarkers(List<DocumentSnapshot> documentList){
    customMarkers = {};
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document['position']['geopoint'];
      Marker marker = Marker(
        markerId: MarkerId(document['name']),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(title: document['name'], snippet: document['name']),
        icon: BitmapDescriptor.defaultMarker,
      );
      setState(() {
        customMarkers.add(marker);
      });
    });
  }

  _setQuery() async {
    var pos = await location.getLocation();
    this.lat = pos.latitude;
    this.long = pos.longitude;
    GeoFirePoint myLocation = geo.point(latitude: lat, longitude: long);
    // GeoFirePoint abc = geo.point(latitude: 25.9875, longitude: 80.3395);
    // firestore.collection('locations').add({'name': 'Kanpur', 'position': abc.data});

    var ref = firestore.collection('locations');

    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(new LatLng(lat, long)));

    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: myLocation,
          radius: rad,
          field: 'position',
          strictMode: true
      );
    }).listen(_updateMarkers);

  }

  _updateQuery(value) async {
    setState(() {
      radius.add(value);
    });
    final zoomMap = {100.0: 12.0, 150.0: 11.0, 200: 9.0, 250.0: 8.0, 300:7, 350.0: 6.0, 400.0: 5.0, 450: 4.0, 500.0: 3.0};
    final num zoom = zoomMap[value];
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(CameraUpdate.zoomTo(zoom));
    // controller.moveCamera(CameraUpdate.newLatLngZoom(new LatLng(lat, long), zoom));
  }

  @override
  void initState() {
    super.initState();
    radius.add(100.0);
    this._setQuery();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Google Map'),
            ),
            drawer: drawer(context),
            body:Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(26.8467088, 80.9461592),
                      zoom: 14.4746,
                    ),
                    onMapCreated: _onMapCreated,
                    markers: customMarkers,
                  ),
                  Positioned(
                      bottom: 50,
                      left: 10,
                      child: Slider(
                        min: 100.0,
                        max: 500.0,
                        divisions: 8,
                        value: radius.value,
                        label: 'Radius ${radius.value} kms',
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.withOpacity(0.3),
                        onChanged: _updateQuery,
                      )
                  )
                ])
    );
  }



  @override
  void dispose() {
    radius.close();
    subscription.cancel();
    super.dispose();
  }

}


