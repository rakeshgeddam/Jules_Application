import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int priority;

  @HiveField(2)
  DateTime? deadline;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String focusMode; 

  @HiveField(6)
  int durationMinutes;

  Task({
    required this.name,
    required this.priority,
    this.deadline,
    this.isCompleted = false,
    required this.createdAt,
    required this.focusMode,
    required this.durationMinutes,
  });
}
