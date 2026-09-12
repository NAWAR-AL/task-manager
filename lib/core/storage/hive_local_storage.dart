import 'package:hive/hive.dart';
import 'package:task_manager/core/storage/local_storage.dart';

class HiveLocalStorage implements LocalStorage {
  final HiveCipher hive;
  HiveLocalStorage(this.hive);

  Future<Box> _getBox(String collection) async {
    return await Hive.openBox(collection);
  }

  @override
  Future<void> delete({required String collection, required String id}) async {
    final box = await _getBox(collection);
    await box.delete(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final box = await _getBox(collection);
    return box.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<void> save({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final box = await _getBox(collection);
    await box.put(id, data);
  }

  @override
  Future<void> update({
    required String id,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final box = await _getBox(collection);
    await box.put(id, data);
  }
}
