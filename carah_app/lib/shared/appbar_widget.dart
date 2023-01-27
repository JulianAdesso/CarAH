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
      leading: context.canPop() ? BackButton(
        onPressed: () => context.pop(),
      ) : null,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      centerTitle: centerTitle,
      title: Text(title),
      actions: actions,
    );
  }
}
