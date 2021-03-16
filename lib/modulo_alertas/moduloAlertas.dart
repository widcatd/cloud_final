import 'dart:async';
import 'dart:collection';
import 'dart:convert' show json;
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart';

class Alertas extends StatefulWidget {
  @override
  State createState() => AlertasState();
}

class AlertasState extends State<Alertas> {
  // TODO: implement widget
  Completer<GoogleMapController> _controller = Completer();
  double lat = -16.39889;
  double lng = -71.535;

  static const LatLng _ubicacion_actual = const LatLng(-16.39889, -71.535);
  Set<Marker> _markers = {};
  LatLng _ultima_ubiacion = LatLng(-16.39889, -71.535);
  MapType _actual_maptype = MapType.normal;
  CollectionReference users =
      FirebaseFirestore.instance.collection('AlertasGeneradas');

  // iconos
  BitmapDescriptor _icono_inseguro;
  BitmapDescriptor _icono_seguro;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _ultima_ubiacion = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _actual_maptype = _actual_maptype == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _iconoAlertaInseguro() async {
    _icono_inseguro = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/peligro.png');
  }

  void _iconoAlertaSeguro() async {
    _icono_seguro = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/policia2.png');
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_ultima_ubiacion.toString()),
        position: _ultima_ubiacion,
        infoWindow: InfoWindow(
          title: 'marcado',
          snippet: 'Zona marcada',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      LatLng ub_db = _ultima_ubiacion;
      GeoPoint point =
          GeoPoint(_ultima_ubiacion.latitude, _ultima_ubiacion.longitude);
      Map<String, dynamic> ubicacion = {
        "usuario": 'Gustavo i ch', // John Doe
        "zona": 'cerro colorado - pachacu', // Stokes and Sons
        "LatLng": point,
        "icono": 'icono1'
        //"LatLng": _ultima_ubiacion // 42
      };
      users.add(ubicacion);
      print(_ultima_ubiacion.toString());
      //AddUser(_ultima_ubiacion, 'Cerro colorado', 'Gustavo I');
    });
  }

  Widget button_pad1(Function function) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: new Tab(icon: new Image.asset("assets/peligro.png")),
    );
  }

  Widget button_pad2(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.red,
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerta Arequipa"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _ubicacion_actual,
              zoom: 15,
            ),
            mapType: _actual_maptype,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  button_pad1(_onMapTypeButtonPressed),
                  SizedBox(
                    height: 12,
                  ),
                  button_pad2(_onAddMarkerButtonPressed, Icons.add_location),
                  SizedBox(
                    height: 12,
                  ),
                  button_pad2(_onAddMarkerButtonPressed, Icons.add_location),
                ],
              ),
            ),
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
