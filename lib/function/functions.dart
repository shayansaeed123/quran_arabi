import 'dart:convert';
import '../model/images_get.dart';
import 'package:http/http.dart' as http;
Future<List<imageget>> imagedata() async {
    var url =Uri.parse("https://quranarbi.turk.pk/api/images");
    final response = await http.get(url);
    if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => imageget.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}