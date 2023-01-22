import 'package:carah_app/model/article.dart';
import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/settings.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/settings_provider.dart';
import 'package:carah_app/shared/router.dart';
import 'package:carah_app/ui/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'model/faq_question.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox('myBox');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ChangeNotifierProxyProvider2<CategoryProvider, SettingsProvider, ArticlesProvider>(
        create: (context) => ArticlesProvider(
            categoryProvider: Provider.of<CategoryProvider>(context, listen: false),
            settingsProvider: Provider.of<SettingsProvider>(context, listen: false)),
        update: (_, categoryProvider, settingsProvider, articlesProvider) => articlesProvider!.update(categoryProvider, settingsProvider),
      ),
      ChangeNotifierProvider(create: (context) => QuestionsProvider()),
      ChangeNotifierProvider(create: (context) => ContentProvider())
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
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, iconTheme: const IconThemeData(size: 50.0)),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.light,
    );
  }
}
