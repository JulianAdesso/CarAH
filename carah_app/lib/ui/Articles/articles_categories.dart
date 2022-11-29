import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';

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
        title: const Text('Articles Categories'),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          provider.fetchAllCategories();
          return ListView(
                  children: provider.categories.isNotEmpty? provider.categories.map((item) {
                return ListTile(
                  title: Text(
                    item.name,
                  ),
                  subtitle: Text(item.description ?? ""),
                  onTap: () {
                    context.push('/articles/${item.uuid}');
                  },
                );
              }).toList() : []);
        },
      ),
    );
  }
}
