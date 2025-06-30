import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String semester;

  @HiveField(3)
  String contact;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? rollNo;

  @HiveField(6)
  String? image;

  Student({
    required this.id,
    required this.name,
    required this.semester,
    required this.contact,
    required this.email,
    required this.rollNo,
    this.image,
  });
}
