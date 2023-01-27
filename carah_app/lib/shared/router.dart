import 'package:carah_app/model/article.dart';
import 'package:carah_app/model/faq_question.dart';
import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/shared/categories_widget.dart';
import 'package:carah_app/shared/subcategory_widget.dart';
import 'package:carah_app/ui/Articles/articles_content.dart';
import 'package:carah_app/ui/Articles/articles_gallery.dart';
import 'package:carah_app/ui/Favorites/favorites_view.dart';
import 'package:carah_app/ui/home/home_page.dart';
import 'package:carah_app/ui/settings/imprint.dart';
import 'package:carah_app/ui/settings/settings_widget.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:carah_app/ui/home/search.dart';


import '../ui/FAQ/faq_content.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/',
      builder: (context, state) => const HomePage()),
    GoRoute(path: '/search',
      builder: (context, state) => Search()),
    GoRoute(path: '/articles_categories',
        builder: (context, state) => const CategoryWidget(path: 'articles', type: 'articles_category',title: 'Articles', categoryUUID: '0a8e66b695f5410cac44b1a9531a7a2b')),
    GoRoute(path: '/articles/:id',
    builder: (context, state) => SubcategoryWidget<Article, ArticlesProvider>(id: state.params['id']!, path: 'article')),
    GoRoute(path: '/article/:id/gallery',
        builder: (context, state) => ArticlesGallery(id: state.params['id']!)),
    GoRoute(path: '/article/:id',
    builder: (context, state) => ArticlesContent(id: state.params['id']!)),
    GoRoute(path: '/faq_categories',
        builder: (context, state) => const CategoryWidget(path: 'faqs', type: 'faq_category', title: 'FAQ', categoryUUID: 'b46628c6bc284debbd2ab8c76888a850')),
    GoRoute(path: '/faqs/:id',
        builder: (context, state) => SubcategoryWidget<Question, QuestionsProvider>(id: state.params['id']!, path: 'faq')),
    GoRoute(path: '/faq/:id',
        builder: (context, state) => FAQContent(id: state.params['id']!)),
    GoRoute(path: '/favorites',
        builder: (context, state) => const FavoritesView()),
    GoRoute(path: '/guides_categories',
      builder: (context, state) => const CategoryWidget(path: 'guidelines', type: 'guides_category', title: 'Tokoloho Guides', categoryUUID: '032d1768c07b455c8ea700b5bf68e0ec')),
    GoRoute(path: '/settings',
    builder: (context, state) => const SettingsWidget()),
    GoRoute(path: '/settings/imprint',
        builder: (context, state) => const Imprint()),
  ],
);