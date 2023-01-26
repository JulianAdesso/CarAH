import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../ui/bottom_navbar.dart';

class CategoryWidget extends StatefulWidget {

  final String path;

  final String type;

  final String title;

  final String categoryUUID;

  const CategoryWidget({super.key, required this.path, required this.type, required this.title, required this.categoryUUID});

  @override
  _CategoryWidget createState() => _CategoryWidget();
}

class _CategoryWidget
    extends State<CategoryWidget> {

  bool isLoading = true;

  get onTap => null;


  @override
  void initState() {
    fetchData();
    super.initState();
  }


  void fetchData() async{
    setState((){
    isLoading = true;
  });
    var provider = Provider.of<CategoryProvider>(context, listen: false);
  await provider.fetchAllCategories(widget.categoryUUID, widget.type);
  setState((){
    isLoading = false;
  });

  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return ListView(
              children: provider.categories.isNotEmpty? provider.categories.map((item) {
                return GestureDetector(
                  onTap: () {
                    context.push('/${widget.path}/${item.uuid}');
                  },
                  child: Card(
                    margin: const EdgeInsets.all(15),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Text(item.name,
                                      style:
                                      Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  Text(item.description ?? "",
                                    style: Theme.of(context).textTheme.bodyMedium,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList() : [const Center(child: Text("No articles downloaded"))]);


        },
      ),
      bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }
}