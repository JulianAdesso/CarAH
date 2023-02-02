import 'package:another_flushbar/flushbar.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

class ArticlesContent extends StatefulWidget {
  final String id;
  final String categoryId;

  const ArticlesContent(
      {super.key, required this.id, required this.categoryId});

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
        .getArticleByUUID(widget.id, widget.categoryId);
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
      margin: const EdgeInsets.fromLTRB(8, 65, 8, 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      borderColor: Colors.grey,
      messageColor:
          Theme.of(context).dialogTheme.contentTextStyle?.color ?? Colors.black,
    );
    if (isLoading) {
      return const LoadingSpinnerWidget();
    }
    return Consumer<ArticlesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppbarWidget(
          title: provider.currentArticle != null
              ? provider.currentArticle!.title
              : '',
          actions: [
            if (!kIsWeb)
              IconButton(
                  icon: Icon(
                    provider.currentArticle != null &&
                            provider.currentArticle!.downloaded
                        ? Icons.cloud_download
                        : Icons.cloud_download_outlined,
                  ),
                  onPressed: () async {
                    if (provider.currentArticle != null) {
                      if (!provider.currentArticle!.downloaded) {
                        if (await provider.downloadArticle(
                            provider.currentArticle!,
                            provider.currentArticle!.category)) {
                          snackBar.show(context);
                          setState(() {
                            provider.currentArticle!.downloaded = true;
                          });
                        }
                      } else {
                        if (await provider.removeArticleFromDownloads(
                            provider.currentArticle!)) {
                          setState(() {
                            provider.currentArticle!.downloaded = false;
                          });
                        }
                      }
                    }
                  }),
            if (!kIsWeb)
              IconButton(
                icon: Icon(
                  provider.currentArticle != null &&
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
                  context.push(Uri(
                          path: '/article/${widget.id}/gallery',
                          queryParameters: {'catId': widget.categoryId})
                      .toString());
                },
                child: provider.showingImages.isNotEmpty
                    ? Stack(
                        children: <Widget>[
                          provider.showingImages.first,
                          if (provider.showingImages.length > 1)
                            Positioned(
                              right: 15,
                              bottom: 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    constraints: const BoxConstraints(
                                      maxWidth: 80,
                                      maxHeight: 40,
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          '1 / ${provider.showingImages.length}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              ),
                            )
                        ],
                      )
                    : const SizedBox.shrink()),
            provider.currentArticle != null
                ? Html(data: provider.currentArticle!.content)
                : const Text("No Data for ID")
          ],
        )),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
