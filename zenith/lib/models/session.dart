import 'package:hive/hive.dart';
import 'package:zenith/models/task.dart';

part 'session.g.dart';

@HiveType(typeId: 3)
class Session extends HiveObject {
  @HiveField(0)
  final DateTime startTime;

  @HiveField(1)
  final DateTime endTime;

  @HiveField(2)
  final String focusMode;

  @HiveField(3)
  final List<Task> completedTasks;

  Session({
    required this.startTime,
    required this.endTime,
    required this.focusMode,
    required this.completedTasks,
  });
}
