import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/topic.dart';
import '../providers/news_provider.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({Key? key}) : super(key: key);

  Widget buildGridView(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
    List<Topic> topicList = newsProvider.getTopicList;
    // remove latest as it cannot be unfollowed
    topicList.removeWhere((element) => element.topicTitle == 'Latest');
    return GridView.builder(
      itemCount: topicList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: (1 / .5),
      ),
      itemBuilder: (BuildContext ctx, int index) {
        Color mainColor = topicList[index].isFollowing
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColorLight;
        Color cardContentColor = topicList[index].isFollowing
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).primaryColor;
        return GestureDetector(
          onTap: () {
            topicList[index].isFollowing = !topicList[index].isFollowing;
            newsProvider.updateTopicList(context, topicList[index]);
          },
          child: Card(
            color: topicList[index].isFollowing
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Row(
                      children: [
                        Text(
                          topicList[index].topicTitle,
                          style: TextStyle(color: cardContentColor),
                        ),
                        Icon(
                          topicList[index].topicIcon,
                          color: cardContentColor,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: topicList[index].isFollowing,
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.check_circle_outline,
                        color: cardContentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Topics',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Flexible(child: buildGridView(context)),
          ],
        ),
      ),
    );
  }
}
