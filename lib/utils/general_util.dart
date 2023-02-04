import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../models/news.dart';
import '../models/publisher.dart';

class GeneralUtils {
  Future<List<News>> loadCsvAndConvertToNews(String path) async {
    final csvData = await rootBundle.loadString(path);
    List<List<dynamic>> csvTableData =
        const CsvToListConverter().convert(csvData);
    // differentiate index as it might be different on csv
    int newsTitleIndex = 0;
    int imageUrlIndex = 0;
    int updatedIndex = 0;
    int linkIndex = 0;

    int publisherNameIndex = 0;
    int publisherImageUrlIndex = 0;
    int publisherRectangleUrlIndex = 0;
    csvTableData[0].asMap().forEach((index, value) {
      switch (value) {
        case 'News Title':
          newsTitleIndex = index;
          break;
        case 'Publisher name':
          publisherNameIndex = index;
          break;
        case 'Image url':
          imageUrlIndex = index;
          break;
        case 'Publisher image url':
          publisherImageUrlIndex = index;
          break;
        case 'Publisher rectangle url':
          publisherRectangleUrlIndex = index;
          break;
        case 'Updated':
          updatedIndex = index;
          break;
        case 'Link':
          linkIndex = index;
          break;
      }
    });

    // remove first element for header
    csvTableData.removeAt(0);

    int i = 1;
    List<News> newsList = csvTableData.map((news) {
      return News(
        i++,
        news[newsTitleIndex],
        news[imageUrlIndex],
        news[updatedIndex],
        news[linkIndex],
        Publisher(
          news[publisherNameIndex],
          news[publisherImageUrlIndex],
          news[publisherRectangleUrlIndex],
        ),
      );
    }).toList();

    return newsList;
  }
}
