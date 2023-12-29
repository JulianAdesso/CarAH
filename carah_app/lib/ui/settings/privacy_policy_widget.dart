import 'package:carah_app/shared/loading_spinner_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:pdfx/pdfx.dart';

import '../../model/bottom_navbar_index.dart';
import '../../shared/bottom_navbar.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  PdfController getAsset() {
    PdfController doc = PdfController(
      document: PdfDocument.openAsset('assets/privacy_policy.pdf'),
    );
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
      body: PdfView(
        controller: getAsset(),
        scrollDirection: Axis.vertical,
        pageSnapping: kIsWeb ? false : true,
        builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (context) {
              return const LoadingSpinnerWidget();
            }),
      ),
      bottomNavigationBar:
          BottomNavbar(currIndex: BottomNavbarIndex.home.index),
    );
  }
}
