import 'package:flutter/material.dart';
import 'package:gitrepo/screens/bookmark_screen.dart';
import 'package:gitrepo/screens/gallery_screen.dart';

import 'repo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('GitHub & Gallery'),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookmarkScreen()),
                  );
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Repositories'),
                Tab(text: 'Gallery'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RepoScreen(),
              const GalleryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
