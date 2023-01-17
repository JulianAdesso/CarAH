import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

class ArticlesContent extends StatefulWidget {
  final String id;

  const ArticlesContent({super.key, required this.id});

  @override
  _ArticlesContent createState() => _ArticlesContent();
}

class _ArticlesContent extends State<ArticlesContent> {
  @override
  void initState() {
    Provider.of<ArticlesProvider>(context, listen: false)
        .getArticleByUUID(widget.id);
    super.initState();
  }

  setFavorite() {}

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            provider.currentArticle != null
                ? provider.currentArticle!.title
                : '',
          ),
          actions: [
            IconButton(
              icon: Icon(
                provider.currentArticle != null &&
                        provider.currentArticle!.downloaded
                    ? Icons.cloud_download
                    : Icons.cloud_download_outlined,
              ),
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
                    : Icons.favorite_border,
                color: provider.currentArticle != null &&
                        provider.currentArticle!.saved
                    ? Colors.red
                    : Colors.black,
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
              InkWell(
                onTap: () {
                  context.push('/article/${widget.id}/gallery');
                },
                child: provider.images != null && !provider.images.isEmpty
                    ? provider.images.first
                    : const SizedBox.shrink(),
              ),
              provider.currentArticle != null
                  ? Html(data: provider.currentArticle!.content)
                  : const Text("Keine Daten zu der ID"),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
