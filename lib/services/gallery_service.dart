import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/unsplash_image_model.dart';

class GalleryService {
  static const String unsplashApiUrl =
      "https://api.unsplash.com/photos?client_id=d8SSzGvqhbvMvavM0pYm4Nc-GI3JRrW28MlGCtlk2Fo";

  // Fetch gallery images from Unsplash API
  Future<List<UnsplashImageModel>> fetchGalleryImages() async {
    final response = await http.get(Uri.parse(unsplashApiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => UnsplashImageModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load gallery images');
    }
  }

  // Save bookmarked image to SharedPreferences
  Future<void> saveBookmarkedImage(UnsplashImageModel image) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarks = prefs.getString('bookmarked_images');
    List<UnsplashImageModel> bookmarkedImages = [];

    if (bookmarks != null) {
      List<dynamic> bookmarksJson = json.decode(bookmarks);
      bookmarkedImages = bookmarksJson
          .map((data) => UnsplashImageModel.fromJson(data))
          .toList();
    }

    bookmarkedImages.add(image);
    await prefs.setString('bookmarked_images', json.encode(bookmarkedImages));
  }

  // Fetch bookmarked images from SharedPreferences
  Future<List<UnsplashImageModel>> fetchBookmarkedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarks = prefs.getString('bookmarked_images');

    if (bookmarks != null) {
      List<dynamic> bookmarksJson = json.decode(bookmarks);
      return bookmarksJson
          .map((data) => UnsplashImageModel.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }
}
