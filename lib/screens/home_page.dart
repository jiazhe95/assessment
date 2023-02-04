import 'dart:async';

import 'package:assessment/enums/home_page_mode_enum.dart';
import 'package:assessment/providers/news_provider.dart';
import 'package:assessment/utils/general_util.dart';
import 'package:assessment/widgets/settings_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../widgets/news_list.dart';
import '../widgets/news_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future? future = runAllAsyncMethods();

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Column(
      children: [
        NewsTab(),
        NewsList(),
      ],
    ),
    SettingsList(),
  ];
  ValueNotifier<int> titleSubtitleIndex = ValueNotifier(-1);
  ValueNotifier<String> title = ValueNotifier('TestTitle');
  ValueNotifier<String> subtitle = ValueNotifier('TestSubtitle');

  static const List<int> hourList = [6, 12, 14, 18];
  static const List<String> titleList = [
    'Good Morning',
    'Good Afternoon',
    'Good Evening',
    'Good Night',
  ];
  static const List<String> subtitleList = [
    'Catch up on news you’ve missed',
    '',
    'Here’s what you’ve missed',
    'Have a good rest!',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  runAllAsyncMethods() async {
    await convertCsvToNews();
    setupDateTimeStream();
  }

  Future<void> convertCsvToNews() async {
    var newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.setLatestNewsList =
        await GeneralUtils().loadCsvAndConvertToNews('assets/csv/latest.csv');
    newsProvider.setTrendingNewsList =
        await GeneralUtils().loadCsvAndConvertToNews('assets/csv/trending.csv');
    newsProvider.setNewsList =
        await GeneralUtils().loadCsvAndConvertToNews('assets/csv/news.csv');
    newsProvider.setHomePageMode = HomePageMode.latest;
    return;
  }

  setupDateTimeStream() {
    var mas = tz.getLocation('Asia/Singapore');
    var now = tz.TZDateTime.now(mas);
    bool isHourAfter18 =
        now.hour > hourList[hourList.length - 1] || now.hour < hourList[0];
    int hour = hourList.firstWhere((element) => element > now.hour, orElse: () {
      return hourList[0] + now.hour;
    });
    int minutesForTimer = (hour - now.hour) * 60 - now.minute;
    // if it's just initialized then setup for the title and subtitle first
    if (titleSubtitleIndex.value == -1) {
      if (isHourAfter18) {
        titleSubtitleIndex.value = hourList.length - 1;
      } else if (hourList.indexOf(hour) > 0) {
        // move to previous hourList
        titleSubtitleIndex.value = hourList.indexOf(hour) - 1;
      } else {
        titleSubtitleIndex.value = 0;
      }
    }

    Timer(Duration(minutes: minutesForTimer), () {
      titleSubtitleIndex.value = hourList.indexOf(hour);
      setupDateTimeStream();
    });
  }

  Widget buildHomeAppBarTitle(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: titleSubtitleIndex,
      builder: (_, int index, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleList[index],
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            subtitleList[index].isNotEmpty
                ? Text(
                    subtitleList[index],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget settingsAppBarTitle = Text(
      'Settings',
      style: TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    );

    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (ctx2, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: _selectedIndex == 0
                      ? buildHomeAppBarTitle(context)
                      : settingsAppBarTitle,
                ),
              ],
              body: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            );
          } else {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 50,
                width: 50,
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
