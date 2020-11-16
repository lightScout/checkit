import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  String name;

  Category({this.name});

  get categoryName {
    return name;
  }
}
