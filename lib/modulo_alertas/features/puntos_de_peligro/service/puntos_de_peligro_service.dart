import 'package:cloud_final/modulo_alertas/features/puntos_de_peligro/models/puntos_de_peligro_model.dart';

import '../../../core/base/base_service.dart';
import '../../../core/firebase_service/firebase_service.dart';
import '../../../core/path/firebase_path.dart';

class PuntosDePeligroService implements BaseService<PuntosDePeligroModel> {
  final _firestoreService = FirestoreService.instance;
  //Method to retrieve all documents
  @override
  Stream<List<PuntosDePeligroModel>> findAllStream() =>
      _firestoreService.collectionStream(
        path: FirestorePath.puntosDePeligros(),
        builder: (data) => PuntosDePeligroModel.fromJson(data),
      );
  //Method to retrieve document object based on the given Id
  @override
  Stream<PuntosDePeligroModel> findOneStream({String id}) =>
      _firestoreService.documentStream(
        path: FirestorePath.puntosDePeligro(id),
        builder: (data, documentId) => PuntosDePeligroModel.fromJson(data),
      );
  //Method to create/update document
  @override
  Future<void> createOne(PuntosDePeligroModel model) async =>
      await _firestoreService.setData(
        path: FirestorePath.puntosDePeligro(model.id.toString()),
        data: model.toJson(),
      );
  //Method to delete PuntosDePeligroModel entry
  @override
  Future<void> deleteOne(PuntosDePeligroModel model) async {
    await _firestoreService.deleteData(
        path: FirestorePath.puntosDePeligro(model.id.toString()));
  }

  @override
  Stream<List<PuntosDePeligroModel>> lastDocumentsStream(int n) =>
      _firestoreService.collectionStream(
          path: FirestorePath.puntosDePeligros(),
          builder: (data) => PuntosDePeligroModel.fromJson(data),
          queryBuilder: (query) =>
              query.orderBy('id', descending: true).limit(n));
}
