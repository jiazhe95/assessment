import 'package:assessment/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';
import '../providers/news_provider.dart';
import '../utils/constants.dart';

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
    List<News> selectedNewsList = newsProvider.getSelectedNewsList;

    return Flexible(
      child: ListView.builder(
        itemCount: selectedNewsList.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              newsProvider.updateStatistics(selectedNewsList[i]);
              Navigator.pushNamed(
                context,
                newsRoute,
                arguments: selectedNewsList[i],
              );
            },
            child: NewsCard(
              news: selectedNewsList[i],
            ),
          );
        },
      ),
    );
  }
}
