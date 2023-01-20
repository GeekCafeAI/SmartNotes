import 'dart:convert';

// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

class Task {
  Task({
    required this.message,
    required this.note,
  });

  final String message;
  final Note note;

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        message: json["message"] ?? "",
        note: Note.fromJson(json["note"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "note": note.toJson(),
      };
}

class Note {
  Note({
    required this.id,
    required this.userId,
    required this.status,
    required this.text,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String userId;
  final String status;
  final String text;
  final List tags;
  final String createdAt;
  final String updatedAt;

  factory Note.fromRawJson(String str) => Note.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        userId: json["user_id"],
        status: json["status"],
        text: json["text"],
        tags: json["tags"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "status": status,
        "text": text,
        "tags": tags,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
