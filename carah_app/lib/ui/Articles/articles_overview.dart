import 'package:carah_app/ui/Articles/articles_content.dart';
import 'package:carah_app/ui/Articles/articles_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlesOverview extends StatefulWidget {
  const ArticlesOverview({super.key});

  @override
  _ArticlesOverview createState() => _ArticlesOverview();
}

class _ArticlesOverview extends State<ArticlesOverview> {
  TextEditingController editingController = TextEditingController();

  var shownArticles = <ListArticlesItem>[];
  bool showSearchWidget = false;

  @override
  void initState() {
    shownArticles.addAll(articlesItemsList);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<ListArticlesItem> dummySearchList = <ListArticlesItem>[];
    dummySearchList.addAll(articlesItemsList);
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<ListArticlesItem> dummyListData = <ListArticlesItem>[];
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
        shownArticles.addAll(articlesItemsList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchWidget = !showSearchWidget;
                shownArticles.clear();
                shownArticles.addAll(articlesItemsList);
                editingController.text = "";
              });
            },
            tooltip: 'search',
          ),
        ],
      ),
      body: Container(
        child: Column(
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
                  return ListTile(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ArticlesContent()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
