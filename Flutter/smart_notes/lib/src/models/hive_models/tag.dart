import 'package:hive/hive.dart';

part 'tag.g.dart';

class HiveTag extends HiveObject {
  String name;
  bool isEnabled;
  bool isFavourite;

  HiveTag({
    required this.name,
    required this.isEnabled,
    required this.isFavourite,
  });
}
