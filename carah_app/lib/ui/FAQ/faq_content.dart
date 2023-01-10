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
    Provider.of<QuestionsProvider>(context)
        .getQuestionByUUID(widget.id);
    return Consumer<QuestionsProvider>(
        builder: (context, provider, child)
        {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => context.pop(),
              ),
              title: Text(provider.currentQuestion != null ? provider.currentQuestion!.title : ''),
            ),
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                        onTap: (){context.push('/article/${widget.id}/gallery');},
                        child: provider.images! != null && !provider.images!.isEmpty ? provider.images!.first!
                            : SizedBox.shrink()),
                    provider.currentQuestion != null ? Html(data: provider.currentQuestion!.content)
                        : Text("Keine Daten zu der ID")
                  ],
                )
            ),
            bottomNavigationBar: BottomNavbar(currIndex: 0),
          );
        });
  }}