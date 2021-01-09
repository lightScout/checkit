import 'package:hive/hive.dart';
part 'flags.g.dart';

@HiveType(typeId: 3)
class Flags {
  @HiveField(0)
  String name;
  @HiveField(1)
  bool value;
  @HiveField(2)
  var data;

  Flags({this.name, this.value, this.data});

  get getFlagName {
    return name;
  }

  get getFlagValue {
    return value;
  }

  get getFlagData {
    return data;
  }

  set setFlagValue(bool newValue) {
    value = newValue;
  }
}
