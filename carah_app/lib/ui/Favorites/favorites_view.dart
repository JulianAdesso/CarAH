import 'package:carah_app/model/article.dart';
import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../shared/bottom_navbar.dart';
import '../../shared/loading_spinner_widget.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late Future<List<Article>> _favoritesFuture;

  @override
  void initState() {
    ArticlesProvider articlesProvider =
        Provider.of<ArticlesProvider>(context, listen: false);
    _favoritesFuture = articlesProvider.fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ArticlesProvider articlesProvider = Provider.of<ArticlesProvider>(context);
    return Scaffold(
      appBar: const AppbarWidget(
        title: 'Favorites Overview',
      ),
      body: FutureBuilder(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingSpinnerWidget();
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('There aren\'t any favorites yet'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data![i].title.toString(),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        snapshot.data![i].saved
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            snapshot.data![i].saved ? Colors.red : Colors.black,
                        size: 30,
                      ),
                      onPressed: () => {
                        setState(
                          () {
                            articlesProvider.setFavorite(
                              snapshot.data![i].uuid,
                              !snapshot.data![i].saved,
                            );
                            snapshot.data!.removeAt(i);
                          },
                        ),
                      },
                    ),
                    onTap: () async {
                      await context.push(Uri(
                          path: '/article/${snapshot.data![i].uuid}',
                          queryParameters: {
                            'catId': snapshot.data![i].category
                          }).toString());
                      _favoritesFuture = articlesProvider.fetchFavorites();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavbar(
        currIndex: BottomNavbarIndex.favorites.index,
      ),
    );
  }
}
