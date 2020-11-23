import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  String name;
  @HiveField(1)
  int key;

  Category({this.name, this.key});

  get categoryName {
    return name;
  }
}
