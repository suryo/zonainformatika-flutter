import 'package:flutter/material.dart';
import 'home.dart';
import 'tutor_page.dart';
import 'mylearning_page.dart';
import 'article_page.dart';
import 'account_page.dart';

void onItemTapped(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TutorPage(),
      ),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyLearningPage(),
      ),
    );
  } else if (index == 3) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(),
      ),
    );
  } else if (index == 4) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(),
      ),
    );
  }
}
