import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String taskStatus;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.taskStatus,
    required this.description,
    required this.date,
    this.isSynced = false,
    required this.updatedAt,
  });
}
