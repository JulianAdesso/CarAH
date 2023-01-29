import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class FAQContent extends StatefulWidget {
  final String id;

  const FAQContent({super.key, required this.id});

  @override
  _FAQContent createState() => _FAQContent();
}

class _FAQContent extends State<FAQContent> {
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
    var provider = Provider.of<QuestionsProvider>(context, listen: false);
    await provider.getQuestionByUUID(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingSpinnerWidget();
    }
    return Consumer<QuestionsProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: const AppbarWidget(
          title: 'Answer',
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      provider.currentQuestion != null
                          ? provider.currentQuestion!.title
                          : '',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            provider.currentQuestion != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Html(data: provider.currentQuestion!.content))
                : const Text("Keine Daten zu der ID")
          ],
        )),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
