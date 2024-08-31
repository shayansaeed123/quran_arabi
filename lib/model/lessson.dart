class Lesson {
  final int categoryId;
  final String categoryTitle;
  final List<LessonDetails> lessons;

  Lesson({
    required this.categoryId,
    required this.categoryTitle,
    required this.lessons,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var lessonsList = json['lessons'] as List;
    List<LessonDetails> lessonsData =
        lessonsList.map((i) => LessonDetails.fromJson(i)).toList();

    return Lesson(
      categoryId: json['category_id'],
      categoryTitle: json['category_title'],
      lessons: lessonsData,
    );
  }
}

class LessonDetails {
  final int lessonId;
  final String lessonTitle;
  final bool attempted1;
  final int correctAnswersAttempted1Count;
  final bool attempted2;
  final int correctAnswersAttempted2Count;
  final int totalQuestions;

  LessonDetails({
    required this.lessonId,
    required this.lessonTitle,
    required this.attempted1,
    required this.correctAnswersAttempted1Count,
    required this.attempted2,
    required this.correctAnswersAttempted2Count,
    required this.totalQuestions,
  });

  factory LessonDetails.fromJson(Map<String, dynamic> json) {
    return LessonDetails(
      lessonId: json['lesson_id'],
      lessonTitle: json['lesson_title'],
      attempted1: json['attempted1'],
      correctAnswersAttempted1Count: json['correct_answers_attempted1_count'],
      attempted2: json['attempted2'],
      correctAnswersAttempted2Count: json['correct_answers_attempted2_count'],
      totalQuestions: json['total_questions'],
    );
  }
}