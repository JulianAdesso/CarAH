import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              onTap: () => element.routerLink != null ? context.push(element.routerLink!) : null,
              child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(element.icon,
                            size: 50.0,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Text(element.title,
                                      style:
                                          Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                Text(element.description!,
                                style: Theme.of(context).textTheme.bodyMedium,)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  )),
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavbar(currIndex: 0));
  }
}
