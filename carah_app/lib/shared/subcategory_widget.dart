import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/model/lightContent.dart';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../model/content.dart';
import '../model/navigation_items.dart';
import 'appbar_widget.dart';

class SubcategoryWidget<T extends Content, P extends ContentProvider>
    extends StatefulWidget {
  String id;
  String path;
  String title;

  SubcategoryWidget(
      {super.key, required this.id, required this.path, required this.title});

  @override
  _SubcategoryWidget createState() => _SubcategoryWidget<T, P>();
}

class _SubcategoryWidget<T extends Content, P extends ContentProvider>
    extends State<SubcategoryWidget> {
  TextEditingController editingController = TextEditingController();

  bool isLoading = false;
  List<LightContent> shownItems = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    P contentProvider = Provider.of<P>(context, listen: false);
    await contentProvider.fetchLightDataByCategory(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  void filterSearchResults(String query) {
    List<LightContent> dummySearchList = <LightContent>[];
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<LightContent> dummyListData = <LightContent>[];
      dummySearchList.forEach((item) {
        if (item.title.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        shownItems.clear();
        shownItems.addAll(dummyListData);
      });
      return;
    } else {
      //Show all titles
      setState(() {
        shownItems.clear();
        shownItems.addAll(Provider.of<P>(context).lightItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    P provider = Provider.of<P>(context);
    shownItems = provider.lightItems;

    if (isLoading) {
      return const LoadingSpinnerWidget();
    }
    return Scaffold(
      appBar: AppbarWidget(
        title: widget.title,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              // to here.
              padding: const EdgeInsets.all(0.0),
              itemCount: shownItems.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(getIcon()),
                    title: Text(
                      shownItems[i].title.toString(),
                    ),
                    trailing: widget.path == 'article' && !kIsWeb
                        ? IconButton(
                            icon: Icon(
                              shownItems[i].saved
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: shownItems[i].saved
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary,
                              size: 30,
                            ),
                            onPressed: () => {
                              setState(() {
                                provider.setFavorite(
                                  shownItems[i].uuid,
                                  !shownItems[i].saved,
                                );
                              }),
                            },
                          )
                        : null,
                    onTap: () {
                      context.push(Uri(
                              path: '/${widget.path}/${shownItems[i].uuid}',
                              queryParameters: widget.path == 'article'
                                  ? {'catId': widget.id}
                                  : null)
                          .toString());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(currIndex: BottomNavbarIndex.home.index),
    );
  }

  IconData getIcon() {
    if (widget.path == 'article') {
      return homeItemsList[0].icon;
    } else if (widget.path == 'faq') {
      return homeItemsList[1].icon;
    } else {
      return Icons.question_mark;
    }
  }
}
