import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Journal.empty()
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["created_At"]),
        updatedAt = DateTime.parse(map["updated_At"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_At": createdAt.toString(),
      "updated_At": updatedAt.toString()
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
