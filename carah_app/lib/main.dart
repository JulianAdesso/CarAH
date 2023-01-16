import 'package:carah_app/model/article.dart';
import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/faq_category.dart';
import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:carah_app/providers/faq_category_provider.dart';
import 'package:carah_app/shared/router.dart';
import 'package:carah_app/ui/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'model/faq_question.dart';




void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(FAQCategoryAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(QuestionAdapter());
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
            useMaterial3: true,
            colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.light,
    );
  }
}
