import 'dart:typed_data';

class LessonIntroDataitems{
  final int? id;
  final String type_id;
  final String featured_image; 
  final String description;
  final String font_size;
  final String groupId;
  final String text_color_code;
  final String audiourl;
  final title;
  final title_arbic;
  final videolink;
  final text_type;
  LessonIntroDataitems({
    required this.id,
    required this.groupId,
    required this.title, 
    required this.title_arbic,
    required this.featured_image, 
    required this.type_id,
    required this.audiourl,
    required this.description,
    required this.font_size,
    required this.text_color_code,
    required this.videolink,
    required this.text_type
  });
  factory LessonIntroDataitems.fromJson(Map<String, dynamic> json) {
    return LessonIntroDataitems(
      id: json['id'],
      title: json['title'],
      title_arbic: json['title_arabic'],
      type_id: json['type_id'],
      audiourl:json['audio'],
      description: json['description'],
      featured_image: json['featured_image'],
      font_size: json['font_size'],
      text_color_code: json['text_color_code'],
      videolink: json['video'],
      groupId: json['group_id'],
      text_type:json['text_type']
    );
  }
}


class lesson_description_type_page{
  final int id;
  final String featured_image; 
  lesson_description_type_page({
    required this.id, 
  required this.featured_image, 
  });
  factory lesson_description_type_page.fromJson(Map<String, dynamic> json) {
    return lesson_description_type_page(
      id: json['id'],
      featured_image: json['featured_image'],
    );
  }
}

