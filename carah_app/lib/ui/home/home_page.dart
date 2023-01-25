import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool connectivity = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        setState(() {
          connectivity = true;
        });
      } else {
        setState(() {
          connectivity = false;
        });
      }
    });
  }

  bool isEnabled(ListItem element) {
    if (element.routerLink == null) {
      return false;
    } else if (connectivity) {
      return true;
    } else if (!connectivity && element.availableInOfflineMode) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tokoloho Health Outreach'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: homeItemsList.map((element) {
            return GestureDetector(
              onTap: isEnabled(element)
                  ? () => context.push(element.routerLink!)
                  : null,
              child: Card(
                  color: isEnabled(element)
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).disabledColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
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
          }).toList(),
        ),
        bottomNavigationBar: BottomNavbar(currIndex: 0));
  }
}
