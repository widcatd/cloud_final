abstract class BaseService<T> {
  Stream<List<T>> findAllStream();
  Stream<List<T>> lastDocumentsStream(int n);
  Future<void> createOne(T model);
  Future<void> deleteOne(T model);
  Stream<T> findOneStream({String id});
}
