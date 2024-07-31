class lesson_description_type_page{
  final int id;
  final String featured_image; 
  // final int text_type;
  lesson_description_type_page({
    required this.id, 
  required this.featured_image, 
  // required this.text_type,
  });
  factory lesson_description_type_page.fromJson(Map<String, dynamic> json) {
    return lesson_description_type_page(
      id: json['id'],
      featured_image: json['featured_image'],
      // text_type:json['text_type']
      
    
    );
  }
}