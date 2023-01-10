import 'package:carah_app/ui/Articles/articles_categories.dart';
import 'package:carah_app/ui/Articles/articles_content.dart';
import 'package:carah_app/ui/Articles/articles_gallery.dart';
import 'package:carah_app/ui/Articles/articles_overview.dart';
import 'package:carah_app/ui/home/home_page.dart';
import 'package:go_router/go_router.dart';

import 'package:carah_app/ui/FAQ/faq_categories.dart';

import '../ui/FAQ/faq_content.dart';
import '../ui/FAQ/faq_gallery.dart';
import '../ui/FAQ/faq_questions.dart';

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
    GoRoute(path: '/article/:id/gallery',
        builder: (context, state) => ArticlesGallery(id: state.params['id']!)),
    GoRoute(path: '/faq_categories',
        builder: (context, state) => const FAQCategories()),
    GoRoute(path: '/faq/:id',
        builder: (context, state) => FAQQuestions(id: state.params['id']!)),
    GoRoute(path: '/faq/:id',
        builder: (context, state) => FAQContent(id: state.params['id']!)),
    GoRoute(path: '/faq/:id/gallery',
        builder: (context, state) => FAQGallery(id: state.params['id']!)),

  ],
);