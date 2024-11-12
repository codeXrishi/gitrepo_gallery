import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String bookmarkKey = "bookmarkedImages";

  // Save a bookmarked image URL
  Future<void> addBookmark(String imageUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarkKey) ?? [];
    if (!bookmarks.contains(imageUrl)) {
      bookmarks.add(imageUrl);
      await prefs.setStringList(bookmarkKey, bookmarks);
    }
  }

  // Remove a bookmarked image URL
  Future<void> removeBookmark(String imageUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarkKey) ?? [];
    bookmarks.remove(imageUrl);
    await prefs.setStringList(bookmarkKey, bookmarks);
  }

  // Get all bookmarked image URLs
  Future<List<String>> getBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(bookmarkKey) ?? [];
  }

  // Check if an image URL is bookmarked
  Future<bool> isBookmarked(String imageUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarkKey) ?? [];
    return bookmarks.contains(imageUrl);
  }
}
