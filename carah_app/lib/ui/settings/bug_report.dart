import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/appbar_widget.dart';

class BugReport extends StatelessWidget {
  const BugReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(
        title: "Bug report",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text('With this contact form you can send us feedback, errors and suggestions for improvement.', style: Theme.of(context).textTheme.headline6),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last name'
                  ),

                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: const TextField(
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message'
                  ),

                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: (){},
                  child: Text('Send'))
            ],
          ),
        ),
      ),
    );
  }
}
