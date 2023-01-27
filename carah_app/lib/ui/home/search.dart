import 'package:carah_app/model/searchContent.dart';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/content.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  _Search createState() => _Search();
}

String query = "";
bool isLoading = false;

class _Search extends State<Search> {
  TextEditingController editingController = TextEditingController();
  bool showSearchWidget = false;
  List<Content> shownContents = [];
  @override
  void initState() {
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    super.initState();
    shownContents = contentProvider.items;
    fetchData(contentProvider);
  }

  void fetchData(ContentProvider<Content> tmpContentProvider) async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<ContentProvider>(context, listen: false)
        .fetchAllContent();
    filterSearchResults(query, tmpContentProvider);
    setState(() {
      isLoading = false;
    });
  }

  IconData getIcon(SearchContent tmpSearchIcon) {
    if (tmpSearchIcon.contentType == ContentType.article) {
      return homeItemsList[0].icon;
    } else if (tmpSearchIcon.contentType == ContentType.question) {
      return homeItemsList[1].icon;
    } else {
      return Icons.question_mark;
    }
  }

  Future<void> filterSearchResults(
      String query, ContentProvider contentProvider) async {
    shownContents = [];
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<Content> dummyListData = [];
      for (var item in contentProvider.items) {
        if ((item as Content)
            .title
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        shownContents = dummyListData;
      });
    } else {
      //Show all titles
      setState(() {
        shownContents = contentProvider.items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) async {
                query = value;
                await filterSearchResults(value, contentProvider);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
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
                : ListView.builder(
                    // to here.
                    key: UniqueKey(),
                    padding: const EdgeInsets.all(0.0),
                    itemCount: shownContents.length,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey)),
                        ),
                        child: ListTile(
                          leading:
                              Icon(getIcon(shownContents[i] as SearchContent)),
                          title: Text(
                            shownContents[i].title.toString(),
                          ),
                          onTap: () {
                            if ((shownContents[i] as SearchContent)
                                    .contentType ==
                                ContentType.article) {
                              context.push('/article/${shownContents[i].uuid}');
                            }
                            if ((shownContents[i] as SearchContent)
                                    .contentType ==
                                ContentType.question) {
                              context.push('/faq/${shownContents[i].uuid}');
                            }
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
