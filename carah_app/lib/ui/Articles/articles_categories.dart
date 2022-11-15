import 'package:carah_app/ui/Articles/articles_Category_items.dart';
import 'package:flutter/material.dart';

import 'articles_items.dart';
import 'articles_overview.dart';

class ArticlesCategories extends StatelessWidget{
  const ArticlesCategories({super.key});

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles Categories'),
      ),
      body: ListView.builder(
        // to here.
        padding: const EdgeInsets.all(0.0),
        itemCount: categoryItemList.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(
              categoryItemList[i].icon
            ),
            title: Text(
              categoryItemList[i].title.toString(),
            ),
            subtitle: Text(
              categoryItemList[i].caption.toString()
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArticlesOverview()),
              );
            },
          );
        },
      ),
    );
  }


}