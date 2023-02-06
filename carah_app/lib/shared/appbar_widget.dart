import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:carah_app/shared/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

class AppbarWidget extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final List<Widget>? actions;
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;

  const AppbarWidget({Key? key, this.actions, required this.title, this.centerTitle = false, this.backgroundColor}) : preferredSize = const Size.fromHeight(60), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Only display Backbutton, when there is still a page on the stack
      leading: context.canPop()
          ? BackButton(
              //When on favorites page, always go back to home screen
              onPressed: () => title == favoritesTitle
                  ? context.pushReplacement(
                      bottomNavbarItems[BottomNavbarIndex.home.index]
                          .routerLink!)
                  : context.pop(),
            )
          : null,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      centerTitle: centerTitle,
      title: Text(title),
      actions: actions,
    );
  }
}
