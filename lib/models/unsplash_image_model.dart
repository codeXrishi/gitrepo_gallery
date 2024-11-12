class UnsplashImageModel {
  final String id;
  final String url;
  final String fullImageUrl;
  final String author;

  UnsplashImageModel({
    required this.id,
    required this.url,
    required this.fullImageUrl,
    required this.author,
  });

  factory UnsplashImageModel.fromJson(Map<String, dynamic> json) {
    return UnsplashImageModel(
      id: json['id'],
      url: json['urls']['small'],
      fullImageUrl: json['urls']['full'],
      author: json['user']['name'],
    );
  }
}
