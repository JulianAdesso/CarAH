import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/article.dart';

class ArticlesOverview extends StatefulWidget {
  String id;
  ArticlesOverview({super.key, required this.id});

  @override
  _ArticlesOverview createState() => _ArticlesOverview();
}

class _ArticlesOverview extends State<ArticlesOverview> {
  TextEditingController editingController = TextEditingController();

  bool showSearchWidget = false;
  List<Article> shownArticles = [];


  @override
  void initState() {
    super.initState();
  }

  void filterSearchResults(String query) {
    ArticlesProvider articleProvider = Provider.of<ArticlesProvider>(context);
    List<Article> dummySearchList = <Article>[];
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<Article> dummyListData = <Article>[];
      dummySearchList.forEach((item) {
        if (item.title.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        shownArticles.clear();
        shownArticles.addAll(dummyListData);
      });
      return;
    } else {
      //Show all titles
      setState(() {
        shownArticles.clear();
        shownArticles.addAll(articleProvider.articles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ArticlesProvider articleProvider = Provider.of<ArticlesProvider>(context);
    articleProvider.fetchDataByCategory(widget.id);
    shownArticles = articleProvider.articles;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Articles Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchWidget = !showSearchWidget;
                shownArticles.clear();
                shownArticles.addAll(articleProvider.articles);
                editingController.text = "";
              });
            },
            tooltip: 'search',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (showSearchWidget)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
          Expanded(
            child: ListView.builder(
              // to here.
              padding: const EdgeInsets.all(0.0),
              itemCount: shownArticles.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                  ),
                  child: ListTile(
                    title: Text(
                      shownArticles[i].title.toString(),
                    ),
                    trailing: IconButton(
                      icon: Icon(shownArticles[i].saved
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () => {
                        setState(() {
                          shownArticles[i].saved = !shownArticles[i].saved;
                        })
                      },
                    ),
                    onTap: () {
                      context.push('/article/${shownArticles[i].uuid}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }
}
