import 'package:carah_app/ui/home/home_items.dart';
import 'package:flutter/material.dart';

import '../bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children:
          homeItemsList.map((element) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element.title, style: Theme.of(context).textTheme.titleSmall),
                          Text(element.description)
                        ],
                      ),
                      Icon(element.icon)
                    ],
                  ),
                ),
              ),
            );
          }).toList()
        ,
      ),
      bottomNavigationBar: const BottomNavbar()
    );
  }
}
