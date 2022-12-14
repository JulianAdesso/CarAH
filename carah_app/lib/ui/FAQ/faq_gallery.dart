import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/articles_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


import '../bottom_navbar.dart';

class FAQGallery extends StatefulWidget {

  final String id;

  const FAQGallery({super.key, required this.id});

  @override
  _FAQGallery createState() => _FAQGallery();
}

int shownPictureNumber = 1;

class _FAQGallery extends State<FAQGallery> {
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
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text( shownPictureNumber.toString() + " from " + provider.images.length.toString()),
              ),
              body:
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  shownPictureNumber = index + 1;
                  return PhotoViewGalleryPageOptions(
                    imageProvider: (provider.images[index].image),
                    initialScale: PhotoViewComputedScale.contained * 1,
                  );
                },
                itemCount: provider.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
              )
          );
        });
  }
}
