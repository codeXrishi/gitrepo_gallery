import 'package:flutter/material.dart';
import 'package:gitrepo/screens/full_screenn_image.dart';

import '../services/bookmark_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkService bookmarkService = BookmarkService();
  late Future<List<String>> futureBookmarks;

  @override
  void initState() {
    super.initState();
    futureBookmarks = bookmarkService.getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarked Images")),
      body: FutureBuilder<List<String>>(
        future: futureBookmarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading bookmarks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarks yet'));
          }

          List<String> bookmarks = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              String imageUrl = bookmarks[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullscreenImageScreen(imageUrl: imageUrl),
                    ),
                  );
                },
                child: Image.network(imageUrl, fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
