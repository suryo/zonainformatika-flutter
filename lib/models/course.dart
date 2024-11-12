// models/course.dart
class Course {
  final int id;
  final String title;
  final String shortDesc;
  final String author;
  final String image;

  Course({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.author,
    required this.image,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      shortDesc: json['short_desc'],
      author: json['author'],
      image: json['image'],
    );
  }
}
