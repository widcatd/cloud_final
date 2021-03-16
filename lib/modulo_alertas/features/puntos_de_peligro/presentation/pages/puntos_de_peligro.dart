import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/puntos_de_peligro_model.dart';
import '../../service/puntos_de_peligro_service.dart';

class PuntosDePeligroPage extends StatefulWidget {
  PuntosDePeligroPage({Key key}) : super(key: key);

  @override
  _PuntosDePeligroPageState createState() => _PuntosDePeligroPageState();
}

class _PuntosDePeligroPageState extends State<PuntosDePeligroPage> {
  Map<MarkerId, Marker> _markers = Map();
  final TextEditingController _descripcionTextController =
      new TextEditingController(); //fecha marcado inicial
  final _form1Key = GlobalKey<FormState>();
  final _puntosDePeligroService = PuntosDePeligroService();
  GoogleMapController _mapController;
  BitmapDescriptor _icono_inseguro;
  BitmapDescriptor _icono_seguro;
  Position _currentPosition;
  LatLng _currentPos;
  StreamSubscription<Position> _streamSubscription;
  bool _hideForm = true;
  @override
  void initState() {
    super.initState();
    _iconoAlertaInseguro();
    _iconoAlertaSeguro();
    this._listenCurrentPosition();
  }

  void _listenCurrentPosition() {
    _streamSubscription = Geolocator.getPositionStream().listen(_move);
  }

  void _listenMarkers() {
    this._puntosDePeligroService.findAllStream().listen((event) {});
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
    setState(() {
      final markerId1 = MarkerId("one");
      final markerId2 = MarkerId("one");
      final marker1 = Marker(
        markerId: markerId1,
        position: LatLng(-16.39889, -71.535),
        infoWindow: InfoWindow(
          title: "Centro de Arequipa",
          snippet: "Zona segura",
        ),
        icon: _icono_seguro,
      );
      final marker2 = Marker(
        markerId: MarkerId("two"),
        position: LatLng(-16.39879, -71.538),
        infoWindow: InfoWindow(
          title: "No en el de Arequipa",
          snippet: "Zona no segura",
        ),
        icon: _icono_inseguro,
      );
      _markers[markerId1] = marker1;
      _markers[markerId2] = marker2;
    });
  }

  _move(Position position) {
    final camaraUpdate =
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude));
    _mapController.animateCamera(camaraUpdate);
  }

  // TODO: implement widget
  Widget build(BuildContext context) {
    LatLng latLng = LatLng(-16.39889, -71.535);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: this._puntosDePeligroService.findAllStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<PuntosDePeligroModel> _models = snapshot.data;
                return GoogleMap(
                  onMapCreated: _mapControl,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: latLng,
                    zoom: 15,
                  ),
                  markers: Set.of(this.createMarkers(_models).values),
                  onTap: this.onTapInMap,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          (!_hideForm)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    returnForm(),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Map<MarkerId, Marker> createMarkers(List<PuntosDePeligroModel> list) {
    list.forEach((element) {
      final markerId = MarkerId(element.id);
      final marker = Marker(
        markerId: markerId,
        position: LatLng(element.posicion.latitude, element.posicion.longitude),
        infoWindow: InfoWindow(
          title: element.tipo == '1' ? "Alerta leve" : "Alerta grave",
          snippet: element.tipo == '1' ? "Alerta leve" : "Alerta grave",
        ),
        icon: _icono_seguro,
      );
      _markers[markerId] = marker;
    });
    return this._markers;
  }

  onTapInMap(LatLng position) {
    final markerId = MarkerId('myPosition');
    final marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(
        title: 'Alberto prro',
      ),
    );
    this._currentPos = position;
    setState(() {
      this._hideForm = !_hideForm;
      _markers[markerId] = marker;
    });
  }

  @override
  void dispose() {
    this._streamSubscription.cancel();
    super.dispose();
  }

  Widget returnForm() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue.withOpacity(0.8),
      ),
      child: Column(
        children: [
          Form(
            key: _form1Key,
            child: Column(
              children: [
                TextFormField(
                  controller: _descripcionTextController,
                  decoration: InputDecoration(
                    hintText: 'Descripcion',
                  ),
                  validator: (value) {
                    return value == null ? 'Ingrese una descripcion' : null;
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                child: Text('Enviar'),
                color: Colors.green.withOpacity(0.8),
                onPressed: () {
                  if (this._form1Key.currentState.validate()) {
                    final puntoDePeligroModel = PuntosDePeligroModel(
                      id: DateTime.now().toIso8601String(),
                      posicion: GeoPoint(this._currentPos.latitude,
                          this._currentPos.longitude),
                      descripcion: _descripcionTextController.text,
                      tipo: 'nuevo tipo',
                      estado: '1',
                      createdAt: 'alberto',
                      createdBy: 'alberto',
                    );
                    this
                        ._puntosDePeligroService
                        .createOne(puntoDePeligroModel)
                        .then((value) {
                      this._descripcionTextController.text = '';
                      setState(() {
                        this._hideForm = true;
                      });
                    });
                  }
                },
              ),
              MaterialButton(
                  child: Text('Cancelar'),
                  color: Colors.redAccent.withOpacity(0.8),
                  onPressed: () {
                    this._hideForm = true;
                    setState(() {});
                  }),
            ],
          )
        ],
      ),
    );
  }
}
