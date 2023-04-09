abstract class Notification {
  String title;
  String courseCode;
  String courseName;
  String content;

  Notification(
      {required this.title,
      required this.courseCode,
      required this.courseName,
      required this.content});
}

class AnnouncementNotification extends Notification {
  AnnouncementNotification({
    required super.title,
    required super.courseCode,
    required super.courseName,
    required super.content,
  });

  @override
  String toString() {
    return "$title $courseCode $courseName $content";
  }
}

class AssignmentNotification extends Notification {
  String dueDate;

  AssignmentNotification(
      {required super.title,
      required super.courseCode,
      required super.courseName,
      required super.content,
      required this.dueDate});

  @override
  String toString() {
    return "$title $courseCode $courseName $content $dueDate";
  }
}
