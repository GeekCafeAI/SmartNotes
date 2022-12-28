// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

class Task {
  Task({required this.tags, required this.text, required this.id});

  final String tags;
  final String text;
  final int id;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        tags: json["tags"] ?? "",
        text: json["text"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {"tags": tags, "text": text, "id": id};

  List<String> getTagsAsList() {
    final splitTags = tags.split(",");
    final List<String> outPutList = [];
    for (int i = 0; i < splitTags.length; i++) {
      outPutList.add(splitTags[i]);
    }
    return outPutList;
  }
}
