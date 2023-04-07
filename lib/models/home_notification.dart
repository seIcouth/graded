abstract class HomeNotification {
  String title;
  String courseCode;
  String courseName;
  String content;

  HomeNotification(
      {required this.title,
      required this.courseCode,
      required this.courseName,
      required this.content});
}

class AssignmentNotification extends HomeNotification {
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

class AnnouncementNotification extends HomeNotification {
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
