class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final bool isAllDay;
  final String focusMode;
  final List<String> allowedContacts;
  final List<String> blockedApps;
  final String recurrenceRule;
  final String naturalLanguageNote;

  Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.isRecurring,
    required this.isAllDay,
    required this.focusMode,
    required this.allowedContacts,
    required this.blockedApps,
    required this.recurrenceRule,
    required this.naturalLanguageNote,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isRecurring: json['isRecurring'],
      isAllDay: json['isAllDay'],
      focusMode: json['focusMode'],
      allowedContacts: List<String>.from(json['allowedContacts']),
      blockedApps: List<String>.from(json['blockedApps']),
      recurrenceRule: json['recurrenceRule'],
      naturalLanguageNote: json['naturalLanguageNote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isRecurring': isRecurring,
      'isAllDay': isAllDay,
      'focusMode': focusMode,
      'allowedContacts': allowedContacts,
      'blockedApps': blockedApps,
      'recurrenceRule': recurrenceRule,
      'naturalLanguageNote': naturalLanguageNote,
    };
  }
}
