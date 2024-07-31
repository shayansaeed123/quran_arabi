import 'dart:typed_data';

class quizhomemodel{
  final int id;
  final String type_id;
  final String featured_image; 
  // final String description;
  // final String font_size;
  // final String text_color_code;
  final String audiourl;
  final title;
  final options;
  // final text_type;
  quizhomemodel({
    required this.id,
    required this.title, 
    required this.featured_image, 
    required this.type_id,
    required this.audiourl,
    // required this.description,
    // required this.font_size,
    // required this.text_color_code,
    required this.options,
    // required this.text_type
  });
  factory quizhomemodel.fromJson(Map<String, dynamic> json) {
    return quizhomemodel(
      id: json['id'],
      title: json['title'],
      type_id: json['type_id'],
      audiourl:json['audio_question'],
      // description: json['description'],
      featured_image: json['image_question'],
      // font_size: json['font_size'],
      // text_color_code: json['text_color_code'],
      options: json['options'],
      // text_type:json['text_type']
    );
  }
}

