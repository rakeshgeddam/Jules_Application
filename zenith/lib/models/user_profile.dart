import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 2)
class UserProfile extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  int totalPomodoros;

  @HiveField(2)
  int streakDays;

  @HiveField(3)
  DateTime lastLogin;

  UserProfile({
    required this.userName,
    this.totalPomodoros = 0,
    this.streakDays = 0,
    required this.lastLogin,
  });
}
