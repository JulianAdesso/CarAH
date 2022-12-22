import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

import 'package:galleryimage/galleryimage.dart'; //TODO Implement image galery

class ArticlesContent extends StatefulWidget {

  final String id;

  const ArticlesContent({super.key, required this.id});

  @override
  _ArticlesContent createState() => _ArticlesContent();
}

class _ArticlesContent extends State<ArticlesContent> {

  @override
  Widget build(BuildContext context) {
    Provider.of<ArticlesProvider>(context)
        .getArticleByUUID(widget.id);
    return Consumer<ArticlesProvider>(
        builder: (context, provider, child)
    {
      provider.getImageByUUID(provider.currentArticle!.imageId!.first);
      provider.getImagesByUUID(provider.currentArticle!.imageId!);
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          title: Text(provider.currentArticle != null ? provider.currentArticle!.title : ''),
          actions: [
            IconButton(
              icon: Icon(provider.currentArticle != null &&
                  provider.currentArticle!.downloaded
                  ? Icons.cloud_download
                  : Icons.cloud_download_outlined),
              onPressed: () {
                setState(() {
                  if (provider.currentArticle != null) {
                    provider.currentArticle!.downloaded =
                    !provider.currentArticle!.downloaded;
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                  provider.currentArticle != null && provider.currentArticle!.saved
                      ? Icons.favorite
                      : Icons.favorite_border),
              onPressed: () {
                setState(() {
                  if (provider.currentArticle != null) {
                    provider.currentArticle!.saved = !provider.currentArticle!.saved;
                  }
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              provider.image != null ? Image.memory(provider.image!) //TODO: Use images instead of image
                  : Text("Keine Daten zu der ID"),
              provider.currentArticle != null ? Html(data: provider.currentArticle!.content)
                  : Text("Keine Daten zu der ID")
            ],
          )
        ),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
}}