import 'package:equatable/equatable.dart';

class Publisher extends Equatable {
  String publisherName;
  String publisherImageUrl;
  String publisherRectangleUrl;

  Publisher(
    this.publisherName,
    this.publisherImageUrl,
    this.publisherRectangleUrl,
  );

  @override
  List<Object?> get props =>
      [publisherName, publisherImageUrl, publisherRectangleUrl];
}
