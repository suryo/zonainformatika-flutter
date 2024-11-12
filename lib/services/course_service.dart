// services/course_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/course';

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['courses']['data'];
      return data.map<Course>((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
