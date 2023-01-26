import 'package:carah_app/model/article.dart';
import 'package:carah_app/providers/articles_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../bottom_navbar.dart';

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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Favorites Overview'),
      ),
      body: FutureBuilder(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                      await context.push('/article/${snapshot.data![i].category}/${snapshot.data![i].uuid}');
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
        currIndex: 2,
      ),
    );
  }
}
