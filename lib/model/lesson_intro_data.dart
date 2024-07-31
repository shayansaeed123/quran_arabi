class LessonIntroData {
  final int id;
  final String featured_image; 
  LessonIntroData({
    required this.id, 
  required this.featured_image, 
  });
  factory LessonIntroData.fromJson(Map<String, dynamic> json) {
    return LessonIntroData(
      id: json['id'],
      featured_image: json['featured_image'],
    );
  }
}
