import 'package:another_flushbar/flushbar.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

class ArticlesContent extends StatefulWidget {
  final String id;


  const ArticlesContent({super.key, required this.id});

  @override
  _ArticlesContent createState() => _ArticlesContent();
}

class _ArticlesContent extends State<ArticlesContent> {

  bool isLoading = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<ArticlesProvider>(context, listen: false)
        .getArticleByUUID(widget.id);
    setState(() {
      isLoading = false;
    });
  }


    setFavorite() {}

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
    if(isLoading) {
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Loading...'),
                ),
              ],
            ),
          )
      );
    }
    return Consumer<ArticlesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(provider.currentArticle != null
              ? provider.currentArticle!.title
              : '',
          ),
          actions: [
            IconButton(
                icon: Icon(provider.currentArticle != null &&
                        provider.currentArticle!.downloaded
                    ? Icons.cloud_download
                    : Icons.cloud_download_outlined,),
                onPressed: () async {
                  if (provider.currentArticle != null &&
                      !provider.currentArticle!.downloaded) {
                        setState(() {
                      provider.currentArticle!.downloaded =
                          !provider.currentArticle!.downloaded;
                    });
                    if (await provider
                        .downloadArticle(provider.currentArticle!, provider.currentArticle!.category)) {
                      snackBar.show(context);
                    }
                  }
                }),
            IconButton(
              icon: Icon(provider.currentArticle != null &&
                      provider.currentArticle!.saved
                  ? Icons.favorite
                  : Icons.favorite_border,
                color: provider.currentArticle != null &&
                        provider.currentArticle!.saved
                    ? Theme.of(context).colorScheme.error
                    : Colors.white,
              ),
              onPressed: () => {
                setState(() {
                  if (provider.currentArticle != null) {
                    provider.setFavorite(
                      provider.currentArticle!.uuid,
                        !provider.currentArticle!.saved,
                    );
                  }
                }),
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
