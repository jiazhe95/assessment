import 'package:assessment/screens/home_page.dart';
import 'package:assessment/screens/news_page.dart';
import 'package:assessment/screens/statistics_page.dart';
import 'package:assessment/screens/topics_page.dart';
import 'package:flutter/material.dart';

import '../models/news.dart';
import 'constants.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case newsRoute:
        var data = settings.arguments as News;
        return MaterialPageRoute(builder: (_) => NewsPage(news: data));
      case topicsRoute:
        return MaterialPageRoute(builder: (_) => TopicsPage());
      case statisticsRoute:
        return MaterialPageRoute(builder: (_) => StatisticsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
