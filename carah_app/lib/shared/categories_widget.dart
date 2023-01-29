import 'dart:async';
import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import 'appbar_widget.dart';
import 'bottom_navbar.dart';
import 'loading_spinner_widget.dart';

class CategoryWidget extends StatefulWidget {
  final String path;

  final String type;

  final String title;

  final String categoryUUID;

  const CategoryWidget(
      {super.key,
      required this.path,
      required this.type,
      required this.title,
      required this.categoryUUID});

  @override
  _CategoryWidget createState() => _CategoryWidget();
}

class _CategoryWidget extends State<CategoryWidget> {
  bool isLoading = true;

  late StreamSubscription<ConnectivityResult> connectivityStream;

  get onTap => null;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    var provider = Provider.of<CategoryProvider>(context, listen: false);
    await provider.fetchAllCategories(widget.categoryUUID, widget.type);
    setState(() {
      isLoading = false;
    });
    var connectivity = Connectivity();
    connectivityStream =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        fetchData();
      } else {
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingSpinnerWidget();
    }
    return Scaffold(
      appBar: AppbarWidget(
        title: widget.title,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return provider.categories.isNotEmpty
              ? ListView(
                  children: provider.categories.map((item) {
                  return GestureDetector(
                    onTap: () {
                      context.push('/${widget.path}/${item.uuid}');
                    },
                    child: Card(
                      margin: const EdgeInsets.all(15),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Text(
                                        item.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    Text(
                                      item.description ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList())
              : const Center(child: Text("No articles downloaded yet"));
        },
      ),
      bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }

  @override
  void dispose() {
    super.dispose();

    connectivityStream.cancel();
  }

}
