import 'package:carah_app/ui/Articles/articles_categories.dart';
import 'package:carah_app/ui/Articles/articles_content.dart';
import 'package:carah_app/ui/Articles/articles_overview.dart';
import 'package:carah_app/ui/home/home_page.dart';
import 'package:carah_app/ui/test_widget.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/',
    builder: (context, state) => const HomePage()),
    GoRoute(path: '/articles_categories',
        builder: (context, state) => const ArticlesCategories()),
    GoRoute(path: '/articles/:id',
    builder: (context, state) => ArticlesOverview(id: state.params['id']!)),
    GoRoute(path: '/article/:id',
    builder: (context, state) => ArticlesContent(id: state.params['id']!)),
    GoRoute(path: '/faq',
    builder: (context, state) => const TestWidget())

  ],
);