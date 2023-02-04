import 'package:assessment/models/publisher.dart';

class News {
  int newsId;
  String newsTitle;
  String imageUrl;
  String updated;
  String link;
  Publisher publisher;

  News(
    this.newsId,
    this.newsTitle,
    this.imageUrl,
    this.updated,
    this.link,
    this.publisher,
  );
}
