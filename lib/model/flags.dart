import 'package:hive/hive.dart';
part 'flags.g.dart';

@HiveType(typeId: 3)
class Flags {
  @HiveField(0)
  String name;
  @HiveField(1)
  bool value;

  Flags({this.name, this.value});

  get getFlagName {
    return name;
  }

  get getFlagValue {
    return value;
  }

  set setFlagValue(bool newValue) {
    value = newValue;
  }
}
