import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../enums/home_page_mode_enum.dart';
import '../models/news.dart';
import '../models/publisher.dart';
import '../models/topic.dart';

class NewsProvider with ChangeNotifier {
  List<News> _latestNewsList = [];
  List<News> _trendingNewsList = [];
  List<News> _newsList = [];
  List<News> _selectedNewsList = [];
  List<Topic> _topicList = [
    Topic(
      1,
      'Latest',
      Icons.flash_on,
      true,
    ),
    Topic(
      2,
      'Trending',
      Icons.local_fire_department,
      true,
    ),
    Topic(
      3,
      'News',
      Icons.coffee,
      true,
    )
  ];
  HomePageMode _homePageMode = HomePageMode.latest;
  int _newsRead = 0;
  News? _lastReadNews;
  Map<Publisher, int> _topThreeNewsPublishers = {};
  Map<String, int> _mostReadNewsCategory = {};

  set setLatestNewsList(List<News> latestNewsList) {
    _latestNewsList = latestNewsList;
    _selectedNewsList = _latestNewsList;
  }

  List<News> get getLatestNewsList {
    return [..._latestNewsList];
  }

  set setTrendingNewsList(List<News> trendingNewsList) {
    _trendingNewsList = trendingNewsList;
  }

  List<News> get getTrendingNewsList {
    return [..._trendingNewsList];
  }

  set setNewsList(List<News> newsList) {
    _newsList = newsList;
  }

  List<News> get getNewsList {
    return [..._newsList];
  }

  set setSelectedNewsList(List<News> selectedNewsList) {
    _selectedNewsList = selectedNewsList;
  }

  List<News> get getSelectedNewsList {
    return [..._selectedNewsList];
  }

  set setHomePageMode(HomePageMode homePageMode) {
    if (_homePageMode != homePageMode) {
      _homePageMode = homePageMode;
      switch (homePageMode) {
        case HomePageMode.latest:
          _selectedNewsList = [..._latestNewsList];
          break;
        case HomePageMode.trending:
          _selectedNewsList = [..._trendingNewsList];
          break;
        case HomePageMode.news:
          _selectedNewsList = [..._newsList];
          break;
      }
      notifyListeners();
    }
  }

  HomePageMode get getHomePageMode {
    return _homePageMode;
  }

  set setTopicList(List<Topic> topicList) {
    _topicList = topicList;
  }

  List<Topic> get getTopicList {
    return [..._topicList];
  }

  News? get getLastReadNews {
    return _lastReadNews;
  }

  Map<Publisher, int> get getTopThreeNewsPublishers {
    if (_topThreeNewsPublishers.isNotEmpty) {
      var entries = _topThreeNewsPublishers.entries.toList();
      entries.sort((MapEntry<Publisher, int> b, MapEntry<Publisher, int> a) =>
          a.value.compareTo(b.value));
      var tempMap = Map<Publisher, int>.fromEntries(entries);
      return tempMap;
    } else {
      return {};
    }
  }

  Map<String, int> get getMostReadNewsCategory {
    if (_mostReadNewsCategory.isNotEmpty) {
      var entries = _mostReadNewsCategory.entries.toList();
      entries.sort((MapEntry<String, int> b, MapEntry<String, int> a) =>
          a.value.compareTo(b.value));
      var tempMap = Map<String, int>.fromEntries(entries);
      return tempMap;
    } else {
      return {};
    }
  }

  void updateStatistics(News news) {
    // last read news
    _lastReadNews = news;

    // top three news publishers
    if (!_topThreeNewsPublishers.containsKey(news.publisher)) {
      _topThreeNewsPublishers[news.publisher] = 1;
    } else {
      _topThreeNewsPublishers.update(news.publisher, (value) => value + 1);
    }

    // most read *since there is no category found will just use title as category*
    if (!_mostReadNewsCategory.containsKey(news.newsTitle)) {
      _mostReadNewsCategory[news.newsTitle] = 1;
    } else {
      _mostReadNewsCategory.update(news.newsTitle, (value) => value + 1);
    }
  }

  void increaseNewsRead(BuildContext context) {
    _newsRead++;
    var snackBar;
    if (_newsRead == 5) {
      snackBar = const SnackBar(
        content: Text('Congratulations, you have viewed 5 articles!'),
      );
    } else if (_newsRead == 10) {
      snackBar = const SnackBar(
        content: Text('Wow, you are an avid news reader!'),
      );
    }

    if (snackBar != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  void updateTopicList(BuildContext context, Topic topic) {
    int topicIndex = _topicList.indexWhere((element) => element.id == topic.id);
    _topicList[topicIndex] = topic;

    // if it's current homePageMode is not latest and unfollow topic is not same
    if (!topic.isFollowing) {
      if ((topic.topicTitle == 'Trending' &&
              _homePageMode == HomePageMode.trending) ||
          (topic.topicTitle == 'News' && _homePageMode == HomePageMode.news)) {
        _homePageMode = HomePageMode.latest;
        _selectedNewsList = [..._latestNewsList];
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final snackBar = SnackBar(
        content: Text(topic.isFollowing
            ? 'You\'re now following ${topic.topicTitle}'
            : 'You\'ve unfollow ${topic.topicTitle}'),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    notifyListeners();
  }
}
