import 'package:carah_app/providers/FAQ_provider.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FAQContent extends StatefulWidget {
  final String id;

  const FAQContent({super.key, required this.id});

  @override
  _FAQContent createState() => _FAQContent();
}

class _FAQContent extends State<FAQContent> {
  @override
  Widget build(BuildContext context) {
    Provider.of<QuestionsProvider>(context).getQuestionByUUID(widget.id);
    return Consumer<QuestionsProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          title: Text('Answer'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black12,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(provider.currentQuestion != null
                        ? provider.currentQuestion!.title
                        : ''),
                  ),
                ),
              ),
            ),
            provider.currentQuestion != null
                ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Html(data: provider.currentQuestion!.content))
                : Text("Keine Daten zu der ID")
          ],
        )),
        bottomNavigationBar: BottomNavbar(currIndex: 0),
      );
    });
  }
}
