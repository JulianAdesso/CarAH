import 'package:carah_app/model/faq_question.dart';
import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/FAQ_provider.dart';

class FAQQuestions extends StatefulWidget {
  String id;
  FAQQuestions({super.key, required this.id});

  @override
  _FAQQuestions createState() => _FAQQuestions();
}

class _FAQQuestions extends State<FAQQuestions> {
  TextEditingController editingController = TextEditingController();

  bool showSearchWidget = false;
  List<Question> shownQuestions = [];


  @override
  void initState() {
    super.initState();
  }

  void filterSearchResults(String query) {
    QuestionsProvider articleProvider = Provider.of<QuestionsProvider>(context);
    List<Question> dummySearchList = <Question>[];
    if (query.isNotEmpty) {
      //Show all titles that contain query
      List<Question> dummyListData = <Question>[];
      dummySearchList.forEach((item) {
        if (item.title.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
          shownQuestions.clear();
        shownQuestions.addAll(dummyListData);
      });
      return;
    } else {
      //Show all titles
      setState(() {
        shownQuestions.clear();
        shownQuestions.addAll(articleProvider.questions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context);
    questionsProvider.fetchDataByCategory(widget.id);
    shownQuestions= questionsProvider.questions;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchWidget = !showSearchWidget;
                shownQuestions.clear();
                shownQuestions.addAll(questionsProvider.questions);
                editingController.text = "";
              });
            },
            tooltip: 'search',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (showSearchWidget)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
          Expanded(
            child: ListView.builder(
              // to here.
              padding: const EdgeInsets.all(0.0),
              itemCount: shownQuestions.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
                  ),
                  child: ListTile(
                    title: Text(
                      shownQuestions[i].title.toString(),
                    ),
                    onTap: () {
                      context.push('/faq/${shownQuestions[i].uuid}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }
}
