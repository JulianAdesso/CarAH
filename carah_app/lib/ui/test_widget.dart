import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  Future<dynamic> fetchFromCMS() async {
    var articlesFromCMS = await http.get(
        Uri.parse(
            'http://h2992008.stratoserver.net:8080/api/v2/CarAH/nodes/8dc33d54f3594897ab8292e2d04280c7/children'),
        headers: {
          "Content-Type": "application/json",
        });
    List<dynamic> result = jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data'].map((element) {
      return {
        "name" : element['fields']['Display_Name']
      };
    }).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {

    Future<dynamic> res = fetchFromCMS();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: res,
            builder: (context, snapshot) {
            if(snapshot.hasData){
              return Text(snapshot.data!.toString());
            } else {
              return const Text('No data available');
            }
        }),
      ),
    );
  }
}
