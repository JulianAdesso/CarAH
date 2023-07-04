import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:carah_app/model/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

class AppbarWidget extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final List<Widget>? actions;
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final IconData icon;

  const AppbarWidget({Key? key, this.actions, required this.title, this.centerTitle = false, this.backgroundColor, this.textStyle, this.icon = Icons.arrow_back}) : preferredSize = const Size.fromHeight(60), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Only display BackButton, when there is still a page on the stack and not on home screen
      automaticallyImplyLeading: false,
      leading: shouldShowBackButton(context)
          ? IconButton(
              icon: Icon(icon),
              color: textStyle?.color ?? Theme.of(context).iconTheme.color,
              //When on favorites page, always go back to home screen
              onPressed: () => title == favoritesTitle
                  ? context.pushReplacement(
                      bottomNavbarItems[BottomNavbarIndex.home.index]
                          .routerLink!)
                  : context.pop(),
            )
          : null,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      titleTextStyle: textStyle ?? Theme.of(context).appBarTheme.titleTextStyle,
      centerTitle: centerTitle,
      title: Text(title),
      actions: actions,
    );
  }

  bool shouldShowBackButton(BuildContext context) {
    return context.canPop() && title != homeScreenTitle;
  }
}
