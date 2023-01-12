import 'package:carah_app/model/article.dart';
import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/faq_category.dart';

import 'package:carah_app/model/list_article_item.dart';
import 'package:carah_app/model/list_faq_item.dart';
import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:carah_app/providers/faq_category_provider.dart';
import 'package:carah_app/shared/router.dart';
import 'package:carah_app/ui/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';




void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(FAQCategoryAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(ListArticlesItemAdapter());
  Hive.registerAdapter(FAQCategoryAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(ListFAQItemAdapter());
  await Hive.openBox('myBox');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ArticlesProvider(),
      ),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => FAQCategoryProvider()),
      ChangeNotifierProvider(create: (context) => QuestionsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ));
  }
}
