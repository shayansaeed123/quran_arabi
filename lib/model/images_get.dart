class imageget {
  final int id;
  final String featured_image;
  imageget({
    required this.id, 
  required this.featured_image, 
  });
  factory imageget.fromJson(Map<String, dynamic> json) {
    return imageget(
      id: json['id'],
      featured_image: json['featured_image'],
    );
  }
}



