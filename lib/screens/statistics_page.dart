import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';
import '../models/publisher.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  Widget buildLastReadNews(BuildContext context, News lastReadNews) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Last Read News',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        NewsCard(
          news: lastReadNews,
        ),
      ],
    );
  }

  Widget buildTopThreeNewsPublishers(
    BuildContext context,
    Map<Publisher, int> topThreeNewsPublishers,
  ) {
    int ranking = 0;
    List<Widget> widgetList = [
      const Center(
        child: Text(
          'Top Three News Publishers',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
    ];
    var entryList = topThreeNewsPublishers.entries.toList();
    int max = entryList.length > 3 ? 3 : entryList.length;

    for (int i = 0; i < max; i++) {
      ranking++;
      widgetList.add(buildLeaderBoardListTile(
        entryList[i].key,
        entryList[i].value,
        ranking,
      ));
    }

    return Column(
      children: widgetList,
    );
  }

  Widget buildLeaderBoardListTile(
    Publisher publisher,
    int readCount,
    int ranking,
  ) {
    IconData iconData;

    if (ranking == 1) {
      iconData = Icons.looks_one_rounded;
    } else if (ranking == 2) {
      iconData = Icons.looks_two_rounded;
    } else {
      iconData = Icons.looks_3_rounded;
    }

    return ListTile(
      leading: Icon(iconData),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  publisher.publisherImageUrl,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(publisher.publisherName),
        ],
      ),
      trailing: Text('$readCount read(s)'),
    );
  }

  Widget buildMostReadNewsCategory(
    BuildContext context,
    Map<String, int> mostReadNewsCategory,
  ) {
    var entryList = mostReadNewsCategory.entries.toList();
    return Column(
      children: [
        const Center(
          child: Text(
            'Most Read News Category',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Category ${entryList[0].key.substring(0, 4)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            '${entryList[0].value} read(s)',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context, listen: false);
    var lastReadNews = newsProvider.getLastReadNews;
    var topThreeNewsPublishers = newsProvider.getTopThreeNewsPublishers;
    var mostReadNewsCategory = newsProvider.getMostReadNewsCategory;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistics',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              lastReadNews != null
                  ? buildLastReadNews(context, lastReadNews)
                  : const Center(
                      child: Text('No last read news!'),
                    ),
              const Divider(),
              topThreeNewsPublishers.isNotEmpty
                  ? Flexible(
                      child: buildTopThreeNewsPublishers(
                        context,
                        topThreeNewsPublishers,
                      ),
                    )
                  : const Center(
                      child: Text('No top three publishers!'),
                    ),
              const Divider(),
              mostReadNewsCategory.isNotEmpty
                  ? Flexible(
                      child: buildMostReadNewsCategory(
                        context,
                        mostReadNewsCategory,
                      ),
                    )
                  : const Center(
                      child: Text('No most read news category!'),
                    ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
