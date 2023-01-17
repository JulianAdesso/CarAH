import 'package:another_flushbar/flushbar.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

class ArticlesContent extends StatefulWidget {
  final String id;
  final String categoryUUID;

  const ArticlesContent({super.key, required this.id, required this.categoryUUID});

  @override
  _ArticlesContent createState() => _ArticlesContent();
}

class _ArticlesContent extends State<ArticlesContent> {

  @override
  void initState() {
   super.initState();
   Provider.of<ArticlesProvider>(context, listen: false).getArticleByUUID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var snackBar = Flushbar(
      message:
          "The article was successfully downloaded and is now available in offline mode",
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.decelerate,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.fromLTRB(8, 60, 8, 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      borderColor: Colors.grey,
      messageColor:
          Theme.of(context).dialogTheme.contentTextStyle?.color ?? Colors.black,
    );


    return Consumer<ArticlesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(provider.currentArticle != null
              ? provider.currentArticle!.title
              : ''),
          actions: [
            IconButton(
                icon: Icon(provider.currentArticle != null &&
                        provider.currentArticle!.downloaded
                    ? Icons.cloud_download
                    : Icons.cloud_download_outlined),
                onPressed: () async {
                  if (provider.currentArticle != null &&
                      !provider.currentArticle!.downloaded) {
                    setState(() {
                      provider.currentArticle!.downloaded =
                          !provider.currentArticle!.downloaded;
                    });
                    if (await provider
                        .downloadArticle(provider.currentArticle!, widget.categoryUUID)) {
                      snackBar.show(context);
                    }
                  }
                }),
            IconButton(
              icon: Icon(provider.currentArticle != null &&
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
        body: SingleChildScrollView(
            child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  context.push('/article/${widget.id}/gallery');
                },
                child: provider.showingImages.isNotEmpty
                    ? provider.showingImages.first
                    : const SizedBox.shrink()),
            provider.currentArticle != null
                ? Html(data: provider.currentArticle!.content)
                : const Text("Keine Daten zu der ID")
          ],
        )),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
