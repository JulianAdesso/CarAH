import 'package:carah_app/model/guideline.dart';
import 'package:flutter/material.dart';

class GuidelineSubPage extends StatelessWidget {
  const GuidelineSubPage({
    super.key,
    required this.guideline,
  });

  final Guideline guideline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            guideline.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Text(guideline.content),
            ))
      ],
    );
  }
}