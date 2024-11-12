import 'package:flutter/material.dart';

import '../services/bookmark_service.dart';

class FullscreenImageScreen extends StatefulWidget {
  final String imageUrl;

  const FullscreenImageScreen({super.key, required this.imageUrl});

  @override
  _FullscreenImageScreenState createState() => _FullscreenImageScreenState();
}

class _FullscreenImageScreenState extends State<FullscreenImageScreen> {
  final BookmarkService bookmarkService = BookmarkService();
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    isBookmarked = await bookmarkService.isBookmarked(widget.imageUrl);
    setState(() {});
  }

  void _toggleBookmark() async {
    if (isBookmarked) {
      await bookmarkService.removeBookmark(widget.imageUrl);
    } else {
      await bookmarkService.addBookmark(widget.imageUrl);
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(widget.imageUrl),
        ),
      ),
    );
  }
}
