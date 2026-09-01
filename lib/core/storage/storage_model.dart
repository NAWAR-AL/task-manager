enum SyncOperation { create, update, delete }

class PendingOperation {
  final String id;
  final String collection;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  PendingOperation({
    required this.collection,
    required this.id,
    required this.data,
    required this.operation,
  });
  Map<String, dynamic> tojson() {
    return {
      'id': id,

      'collection': collection,
      'data': data,
      'operation': operation,
    };
  }

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      collection: json['collection'],
      id: json['id'],
      data: Map<String, dynamic>.from(json['data']),
      operation: SyncOperation.values.byName(json['operation']),
    );
  }
}
