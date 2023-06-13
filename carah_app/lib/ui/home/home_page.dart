import 'dart:async';

import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/providers/list_item_provider.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../shared/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<ConnectivityResult> connectivityStream;
  bool connectivityState = true;

  @override
  void initState() {
    super.initState();
    var connectivity = Connectivity();
    setInitialConnectivity(connectivity);
    connectivityStream =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        setState(() {
          connectivityState = true;
        });
      } else {
        setState(() {
          connectivityState = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ListItemProvider>(context).initHomePageItems();
    return Scaffold(
        appBar: AppbarWidget(
          actions: kIsWeb
              ? [
                  IconButton(
                      onPressed: () {
                        context.push('/settings/imprint');
                      },
                      icon: const Icon(Icons.info_outline))
                ]
              : null,
          title: homeScreenTitle,
        ),
        body: Consumer<ListItemProvider>(builder: (context, provider, child) {
          return ListView(
              padding: const EdgeInsets.all(15),
              children: provider.homepageItems.map((element) {
                return GestureDetector(
                  onTap: !element.isDisabled
                      ? () => context.push(element.routerLink!)
                      : null,
                  child: Card(
                      color: !element.isDisabled
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.outline,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Text(
                                              element.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                          ),
                                          Text(
                                            element.description!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            overflow: TextOverflow.visible,
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      element.icon,
                                      size: Theme.of(context).iconTheme.size,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              }).toList());
        }),
        bottomNavigationBar:
            BottomNavbar(currIndex: BottomNavbarIndex.home.index));
  }

  @override
  void dispose() {
    super.dispose();

    connectivityStream.cancel();
  }

  void setInitialConnectivity(Connectivity connectivity) async {
    var result = await connectivity.checkConnectivity();
    setState(() {
      connectivityState = result != ConnectivityResult.none;
    });
  }
}
