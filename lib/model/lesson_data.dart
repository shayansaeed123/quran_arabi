class LessonData {
  final int lesson_id;
  final String featured_image;
  LessonData({
    required this.lesson_id, 
  required this.featured_image, 
  });
  factory LessonData.fromJson(Map<String, dynamic> json) {
    return LessonData(
      lesson_id: json['id'],
      featured_image: json['featured_image'],
    );
  }
}



