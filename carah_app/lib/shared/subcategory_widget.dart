import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../model/content.dart';

class SubcategoryWidget<T extends Content, P extends ContentProvider>
    extends StatefulWidget {
  String id;
  String path;

  SubcategoryWidget({super.key, required this.id, required this.path});

  @override
  _SubcategoryWidget createState() => _SubcategoryWidget<T, P>();
}

class _SubcategoryWidget<T extends Content, P extends ContentProvider>
    extends State<SubcategoryWidget> {
  TextEditingController editingController = TextEditingController();

  bool isLoading = false;
  bool showSearchWidget = false;
  List<T> shownItems = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState((){
      isLoading = true;
    });
    P contentProvider = Provider.of<P>(context, listen: false);
    await contentProvider.fetchDataByCategory(widget.id);
    setState((){
      isLoading = false;
    });


  }

  void filterSearchResults(String query) {
    List<T> dummySearchList = <T>[];
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<T> dummyListData = <T>[];
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
        shownItems.addAll(Provider.of<P>(context).items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    P provider = Provider.of<P>(context);
    shownItems = provider.items;

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
                shownItems.clear();
                shownItems.addAll(provider.items);
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
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
                    title: Text(
                      shownItems[i].title.toString(),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        shownItems[i].saved
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: shownItems[i].saved ? Colors.red : Colors.black,
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
                    ),
                    onTap: () {
                      if (widget.path == "article") {
                        context.push(
                            '/${widget.path}/${widget.id}/${shownItems[i].uuid}');
                      } else {
                        context.push(
                          '/${widget.path}/${shownItems[i].uuid}',
                        );
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
