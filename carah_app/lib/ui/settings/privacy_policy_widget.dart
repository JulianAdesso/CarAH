import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

import '../../model/bottom_navbar_index.dart';
import '../../shared/bottom_navbar.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  Future<PDFDocument> getAsset() async {
    PDFDocument doc = await PDFDocument.fromAsset('assets/privacy_policy.pdf');
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Privacy Policy'),
      ),
      body: FutureBuilder(future: getAsset(),
      builder: (context, data) {
        if(data.hasData) {
          return PDFViewer(document: data.data!,
          scrollDirection: Axis.vertical,
          showPicker: false,
          showNavigation: false,);
        }
        else {
          return const LoadingSpinnerWidget();
        }
      }),
      bottomNavigationBar: BottomNavbar(currIndex: BottomNavbarIndex.home.index),
    );
  }
}
