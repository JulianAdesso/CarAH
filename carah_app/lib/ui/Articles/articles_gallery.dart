import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/articles_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ArticlesGallery extends StatefulWidget {

  final String id;

  const ArticlesGallery({super.key, required this.id});

  @override
  _ArticlesGallery createState() => _ArticlesGallery();
  }

  int shownPictureNumber = 1;

class _ArticlesGallery extends State<ArticlesGallery> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ArticlesProvider>(context)
        .getArticleByUUID(widget.id);
    return Consumer<ArticlesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black ,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text( "$shownPictureNumber from ${provider.images.length}"),
            ),
            body: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                shownPictureNumber = index + 1;
                return PhotoViewGalleryPageOptions(
                imageProvider: (provider.showingImages[index].image),
                  initialScale: PhotoViewComputedScale.contained * 1,
                );
              },
              itemCount: provider.images.length,
              loadingBuilder: (context, event) => const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                ),
              ),
            )
          );
        });
  }
}
