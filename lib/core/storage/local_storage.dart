abstract class LocalStorage {
  Future<void> save({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  });
  Future<List<Map<String, dynamic>>> getAll(String collection);
  Future<void> update({
    required String id,
    required String collection,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String collection, required String id});
}
