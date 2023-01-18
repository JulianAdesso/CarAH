import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  bool isEnabled(ListItem element, AsyncSnapshot<bool> snapshot){
    if(element.routerLink == null){
      return false;
    } else if(snapshot.hasData && snapshot.data!){
      return true;
    } else if(snapshot.hasData && !snapshot.data! && element.availableInOfflineMode){
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
            return FutureBuilder<bool>(
                future: checkConnectivity(),
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: isEnabled(element, snapshot)
                        ? () => context.push(element.routerLink!)
                        : null,
                    child: Card(
                        color: isEnabled(element, snapshot) ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).disabledColor,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        size: 50.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                });
          }).toList(),
        ),
        bottomNavigationBar: BottomNavbar(currIndex: 0));
  }
}
