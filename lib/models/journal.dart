import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.userId});

  Journal.empty({required int id})
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        userId = id;

  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["created_At"]),
        updatedAt = DateTime.parse(map["updated_At"]),
        userId = map["userId"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_At": createdAt.toString(),
      "updated_At": updatedAt.toString(),
      "userId": userId
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt\nuserId: $userId";
  }
}
