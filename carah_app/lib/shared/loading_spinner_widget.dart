import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatelessWidget {
  const LoadingSpinnerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
