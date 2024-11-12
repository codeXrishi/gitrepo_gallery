import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/unsplash_image_model.dart';
import '../services/gallery_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryService galleryService = GalleryService();
  late Future<List<UnsplashImageModel>> futureImages;

  @override
  void initState() {
    super.initState();
    futureImages = galleryService.fetchGalleryImages();
  }

  void _bookmarkImage(UnsplashImageModel image) {
    galleryService.saveBookmarkedImage(image);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Image bookmarked")));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UnsplashImageModel>>(
      future: futureImages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading gallery'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No images available'));
        }

        List<UnsplashImageModel> images = snapshot.data!;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            UnsplashImageModel image = images[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewGalleryScreen(image),
                ),
              ),
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(image.author),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () => _bookmarkImage(image),
                  ),
                ),
                child: Image.network(image.url, fit: BoxFit.cover),
              ),
            );
          },
        );
      },
    );
  }
}

class PhotoViewGalleryScreen extends StatelessWidget {
  final UnsplashImageModel image;

  const PhotoViewGalleryScreen(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image by ${image.author}")),
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(image.fullImageUrl),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
