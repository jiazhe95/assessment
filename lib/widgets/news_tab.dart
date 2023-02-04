import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/home_page_mode_enum.dart';
import '../providers/news_provider.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  TextStyle getTextStyle(BuildContext context, bool isSelectedHomePageMode) {
    TextStyle activeTextStyle = TextStyle(
      color: Theme.of(context).primaryColorLight,
      fontWeight: FontWeight.bold,
    );
    TextStyle inactiveTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
    );

    return isSelectedHomePageMode ? activeTextStyle : inactiveTextStyle;
  }

  ButtonStyle getButtonStyle(
      BuildContext context, bool isSelectedHomePageMode) {
    ButtonStyle activeButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ButtonStyle inactiveButtonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      backgroundColor: Theme.of(context).primaryColorLight,
    );

    return isSelectedHomePageMode ? activeButtonStyle : inactiveButtonStyle;
  }

  Icon getIcon(
      BuildContext context, IconData iconData, bool isSelectedHomePageMode) {
    return Icon(
      iconData,
      color: isSelectedHomePageMode
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).primaryColor,
    );
  }

  Widget buildTabButton(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
    var topicList = newsProvider.getTopicList;
    var currentHomePageMode = newsProvider.getHomePageMode;
    topicList.removeWhere((element) => !element.isFollowing);

    return Row(
      mainAxisAlignment: topicList.length == 1
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceEvenly,
      children: topicList.map((topic) {
        var homePageMode;

        switch (topic.topicTitle) {
          case 'Latest':
            homePageMode = HomePageMode.latest;
            break;
          case 'Trending':
            homePageMode = HomePageMode.trending;
            break;
          case 'News':
            homePageMode = HomePageMode.news;
            break;
        }

        bool isSelectedHomePageMode = currentHomePageMode == homePageMode;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton.icon(
            onPressed: () {
              newsProvider.setHomePageMode = homePageMode;
            },
            icon: getIcon(
              context,
              topic.topicIcon,
              isSelectedHomePageMode,
            ),
            label: Text(
              topic.topicTitle,
              style: getTextStyle(context, isSelectedHomePageMode),
            ),
            style: getButtonStyle(context, isSelectedHomePageMode),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTabButton(context),
    );
  }
}
