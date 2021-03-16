import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PuntosDePeligroModel puntosDePeligroModelFromJson(String str) =>
    PuntosDePeligroModel.fromJson(json.decode(str));

String puntosDePeligroModelToJson(PuntosDePeligroModel data) =>
    json.encode(data.toJson());

class PuntosDePeligroModel {
  PuntosDePeligroModel({
    this.id,
    this.posicion,
    this.descripcion,
    this.tipo,
    this.estado,
    this.createdAt,
    this.createdBy,
  });

  String id;
  String descripcion;
  String tipo;
  String estado;
  String createdAt;
  String createdBy;
  GeoPoint posicion;

  factory PuntosDePeligroModel.fromJson(Map<String, dynamic> json) =>
      PuntosDePeligroModel(
        id: json["id"],
        posicion: json['posicion'],
        descripcion: json["descripcion"],
        tipo: json["tipo"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "posicion": posicion,
        "descripcion": descripcion,
        "tipo": tipo,
        "estado": estado,
        "createdAt": createdAt,
        "createdBy": createdBy,
      };
}
