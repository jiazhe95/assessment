import 'package:assessment/models/news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/news_provider.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({
    Key? key,
    required this.news,
  }) : super(key: key);
  final News news;

  PreferredSizeWidget buildAppBar(
      BuildContext context, ValueNotifier<int> progressBar) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  news.publisher.publisherImageUrl,
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
          Text(
            news.publisher.publisherName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(6.0),
        child: ValueListenableBuilder(
          valueListenable: progressBar,
          builder: (_, int progress, __) {
            return Visibility(
              visible: progress != 100,
              child: LinearProgressIndicator(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
                value: progress / 100,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.increaseNewsRead(context);
    ValueNotifier<int> progressBar = ValueNotifier(0);
    final snackBar = SnackBar(
      content: Text('Ads from the publisher’s website'),
    );
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            progressBar.value = progress;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(news.link));

    return Scaffold(
      appBar: buildAppBar(context, progressBar),
      body: WebViewWidget(controller: controller),
    );
  }
}
