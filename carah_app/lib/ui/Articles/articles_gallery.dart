import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/articles_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


import '../bottom_navbar.dart';

class ArticlesGallery extends StatefulWidget {

  final String id;

  const ArticlesGallery({super.key, required this.id});

  @override
  _ArticlesGallery createState() => _ArticlesGallery();
  }


class _ArticlesGallery extends State<ArticlesGallery> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ArticlesProvider>(context)
        .getArticleByUUID(widget.id);
    return Consumer<ArticlesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => context.pop(),
              ),
              title: Text(
                  provider.currentArticle != null ? provider.currentArticle!
                      .title : ''),
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
                      provider.currentArticle != null &&
                          provider.currentArticle!.saved
                          ? Icons.favorite
                          : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      if (provider.currentArticle != null) {
                        provider.currentArticle!.saved =
                        !provider.currentArticle!.saved;
                      }
                    });
                  },
                ),
              ],
            ),
            body:
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                List<Image> tmpList = [];
                for (var i = 0; i < 5; i++) {
                  tmpList.add(Image.memory(provider.image!));
                }
                return PhotoViewGalleryPageOptions(
                    imageProvider: (tmpList[index].image),
                    //imageProvider: (provider.images[index].image), //TODO Use images instead
                    //Image.memory(provider.images[index]!).memory(provider.image!).image),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                );
              },
              //itemCount: provider.images.length,
              itemCount: 5,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,

                ),
              ),
            )
          );



            /**PhotoView(imageProvider: (Image
                .memory(provider.image!)
                .image)),
            bottomNavigationBar: BottomNavbar(currIndex: 0),
          );
                **/
        });
  }
}
