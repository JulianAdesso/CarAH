import 'package:carah_app/ui/Articles/articles_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlesOverview extends StatefulWidget {
  const ArticlesOverview({super.key});

  @override
  _ArticlesOverview createState() => _ArticlesOverview();
}


class _ArticlesOverview extends State<ArticlesOverview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW from here ...
      appBar: AppBar(
        title: const Text('Articles Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'search',
          ),
        ],
      ),
      body: ListView.builder(
        // to here.
        padding: const EdgeInsets.all(16.0),
        itemCount: articlesItemsList.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(
              articlesItemsList[i].title.toString(),
            ),
            trailing: Wrap(spacing: 12, children: <Widget>[
              IconButton(
                icon: Icon(articlesItemsList[i].saved
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => {
                  setState(() {
                    articlesItemsList[i].saved =
                    !articlesItemsList[i].saved;
                })
                },
              ),
            ]),
          );
        },
      ),
    );
  }
}
