import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class HiveNote extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String status;
  @HiveField(3)
  String text;
  @HiveField(4)
  String tags;
  @HiveField(5)
  String createdAt;
  @HiveField(6)
  String updatedAt;

  HiveNote({
    required this.id,
    required this.userId,
    required this.status,
    required this.text,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}
