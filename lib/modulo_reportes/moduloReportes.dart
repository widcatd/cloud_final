import 'dart:async';
import 'dart:collection';
import 'dart:convert' show json;
import 'dart:io';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reportes extends StatefulWidget {
  @override
  State createState() => ReportesState();
}

class ReportesState extends State<Reportes> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _icono_inseguro;
  BitmapDescriptor _icono_seguro;
  CollectionReference users =
      FirebaseFirestore.instance.collection('AlertasGeneradas');

  @override
  void initState() {
    super.initState();
    _iconoAlertaInseguro();
    _iconoAlertaSeguro();
  }

  void _iconoAlertaInseguro() async {
    _icono_inseguro = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/peligro.png');
  }

  void _iconoAlertaSeguro() async {
    _icono_seguro = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/policia2.png');
  }

  void _mapControl(GoogleMapController controller) {
    _mapController = controller;

    //setState(() {
    /*
      _markers.add(
        Marker(
            markerId: MarkerId("0"),
            position: LatLng(-16.39889, -71.535),
            infoWindow:
                InfoWindow(title: "Centro de Arequipa", snippet: "Zona segura"),
            icon: _icono_seguro),
      );
      Stream collectionStream =
          FirebaseFirestore.instance.collection('AlertasGeneradas').snapshots();
      print('kekw1');
      */

    //print(collectionStream);

    //print('kekw');
    FirebaseFirestore.instance
        .collection('puntosDePeligros')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _markers.add(
                    Marker(
                        markerId: MarkerId(doc["id"]),
                        position: LatLng(doc["posicion"].latitude,
                            doc["posicion"].longitude),
                        infoWindow: InfoWindow(
                            title: doc["tipo"], snippet: doc["descripcion"]),
                        icon: _icono_inseguro),
                  );
                  print(doc["id"]);
                });
              }),
            });
    FirebaseFirestore.instance
        .collection('AlertasGeneradas')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _markers.add(
                    Marker(
                        markerId: MarkerId(doc.id),
                        position: LatLng(
                            doc["LatLng"].latitude, doc["LatLng"].longitude),
                        infoWindow: InfoWindow(
                            title: doc["zona"], snippet: doc["zona"]),
                        icon: _icono_seguro),
                  );
                  print(doc["zona"]);
                });
              }),
            });
    /*        
      _markers.add(Marker(
          markerId: MarkerId("1asd"),
          position: LatLng(-16.39879, -71.538),
          infoWindow: InfoWindow(
              title: "No en el de Arequipa", snippet: "Zona no segura"),
          icon: _icono_inseguro));
          */
    //});
  }

  void _mapControl_firebase(GoogleMapController controller, MarkerId _id,
      LatLng ubicacion, String zona, String descripcion) {
    _mapController = controller;
    setState(() {
      _markers.add(
        Marker(
            markerId: _id,
            position: ubicacion,
            infoWindow: InfoWindow(title: zona, snippet: descripcion),
            icon: _icono_seguro),
      );
    });
  }

  // TODO: implement widget
  Widget build(BuildContext context) {
    LatLng latLng = LatLng(-16.39889, -71.535);
    //CameraPosition cameraPosition = CameraPosition(target: latLng);

    return Scaffold(
      appBar: AppBar(
        title: Text("Alerta Arequipa"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _mapControl,
            initialCameraPosition: CameraPosition(
              target: latLng,
              zoom: 15,
            ),
            markers: _markers,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
            child: Text("Alerta Arequipa"),
          ),
        ],
      ),
    );
  }
}
