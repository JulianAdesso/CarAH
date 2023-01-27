import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

import '../../providers/articles_provider.dart';

class Imprint extends StatefulWidget {


  const Imprint({super.key});

  @override
  _Imprint createState() => _Imprint();
}

class _Imprint extends State<Imprint> {

  bool isLoading = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<ArticlesProvider>(context, listen: false)
        .getImprint();
    setState(() {
      isLoading = false;
    });
  }


  setFavorite() {}

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Loading...'),
                ),
              ],
            ),
          )
      );
    }
    return Consumer<ArticlesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(provider.currentArticle != null
              ? provider.currentArticle!.title
              : '',
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                provider.currentArticle != null
                    ? Html(data: provider.currentArticle!.content)
                    : const Text("Keine Daten zu der ID")
              ],
            )),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
