import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/model/guideline.dart';
import 'package:carah_app/providers/guidelines_provider.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:carah_app/ui/guidelines/guideline_subpage.dart';
import 'package:carah_app/ui/guidelines/pageview_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuidelinesCategoryWidget extends StatefulWidget {
  final String id;

  const GuidelinesCategoryWidget({super.key, required this.id});

  @override
  _GuidelinesContent createState() => _GuidelinesContent();
}

class _GuidelinesContent extends State<GuidelinesCategoryWidget> {
  bool isLoading = false;
  List<Guideline> showGuidelinePages = [];
  final PageController controller = PageController(initialPage: 0);
  int _activePage = 0;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    var provider = Provider.of<GuidelinesProvider>(context, listen: false);
    provider.guidelines.clear();
    await provider.fetchLightDataByCategory(widget.id);
    for (var i = 0; i < provider.lightItems.length; i++) {
      await provider.fetchDataByCategory(provider.lightItems[i].uuid);
    }
    showGuidelinePages = provider.guidelines;
    showGuidelinePages.sort((a, b) => a.position!.compareTo(b.position as num));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingSpinnerWidget();
    }
    return Consumer<GuidelinesProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppbarWidget(title: provider.guidelines.first.category),
        body: Column(children: <Widget>[
          PageViewIndicator(
              itemCount: showGuidelinePages.length,
              controller: controller,
              activePage: _activePage),
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemCount: showGuidelinePages.length,
              itemBuilder: (BuildContext context, int index) {
                return GuidelineSubPage(guideline: showGuidelinePages[index]);
              },
            ),
          ),
        ]),
        bottomNavigationBar:
            BottomNavbar(currIndex: BottomNavbarIndex.home.index),
      );
    });
  }
}
