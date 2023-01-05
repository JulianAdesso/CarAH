import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/faq_category_provider.dart';

class FAQCategories extends StatelessWidget {
  const FAQCategories({super.key});

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('FAQ'),
      ),
      body: Consumer<FAQCategoryProvider>(
        builder: (context, provider, child) {
          provider.fetchAllCategories();
          return ListView(
              children: provider.categories.isNotEmpty? provider.categories.map((item) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                  ),
                  child: ListTile(
                    title: Text(
                      item.name,
                    ),
                    subtitle: Text(item.description ?? ""),
                    onTap: () {
                      context.push('/faq/${item.uuid}');
                    },
                  ),
                );
              }).toList() : []);
        },
      ),
    );
  }
}
