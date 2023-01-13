import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../bottom_navbar.dart';

class ArticlesCategories extends StatelessWidget {
  const ArticlesCategories({super.key});

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Articles Categories'),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          provider.fetchAllCategories();
          return ListView(
              children: provider.categories.isNotEmpty? provider.categories.map((item) {
                return GestureDetector(
                  onTap: () {
                    context.push('/articles/${item.uuid}');
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
              }).toList() : []);


        },
      ),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }
}