import 'package:flutter/material.dart';

class PageViewIndicator extends StatelessWidget {
  const PageViewIndicator({
    super.key,
    required this.itemCount,
    required this.controller,
    required int activePage,
  }) : _activePage = activePage;

  final int itemCount;
  final PageController controller;
  final int _activePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
            itemCount,
            (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      controller.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: _activePage == index
                          ? Colors.black38
                          : Colors.black12,
                    ),
                  ),
                )),
      ),
    );
  }
}
