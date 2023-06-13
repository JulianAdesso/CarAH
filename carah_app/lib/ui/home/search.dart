import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/model/lightContent.dart';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/list_item_provider.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
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
    query = "";
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

  IconData getIcon(LightContent tmpSearchIcon) {
    ListItemProvider provider = Provider.of<ListItemProvider>(context);
    if (tmpSearchIcon.contentType == ContentType.article) {
      return provider.homepageItems.where((element) => element.position == 1).first.icon ?? Icons.question_mark;
    } else if (tmpSearchIcon.contentType == ContentType.question) {
      return provider.homepageItems.where((element) => element.position == 2).first.icon ?? Icons.question_mark;
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
      appBar: const AppbarWidget(
        title: 'Search',
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
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        shownContents = contentProvider.items;
                        editingController.clear();
                      });
                    },
                    icon: const Icon(Icons.clear)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const LoadingSpinnerWidget()
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
                              Icon(getIcon(shownContents[i] as LightContent)),
                          title: Text(
                            shownContents[i].title.toString(),
                          ),
                          onTap: () {
                            if ((shownContents[i] as LightContent)
                                    .contentType ==
                                ContentType.article) {
                              context.push(Uri(
                                  path: '/article/${shownContents[i].uuid}',
                                  queryParameters: {
                                    'catId': shownContents[i].category
                                  }).toString());
                            }
                            if ((shownContents[i] as LightContent)
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
      bottomNavigationBar: BottomNavbar(currIndex: BottomNavbarIndex.search.index),
    );
  }
}
