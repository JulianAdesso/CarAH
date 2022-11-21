import 'package:carah_app/ui/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import 'articles_items.dart';

class ArticlesContent extends StatefulWidget {

  final int? id;

  const ArticlesContent({super.key, this.id});

  @override
  _ArticlesContent createState() => _ArticlesContent();
}

class _ArticlesContent extends State<ArticlesContent> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text('Articles Content ${widget.id}'),
        actions: [
          IconButton(
            icon: Icon(articlesItemsList[1].downloaded
                ? Icons.cloud_download
                : Icons.cloud_download_outlined),
            onPressed: () {
              setState(() {
                articlesItemsList[1].downloaded = !articlesItemsList[1].downloaded;
              });
            },
          ),
          IconButton(
            icon: Icon(articlesItemsList[1].saved
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              setState(() {
                articlesItemsList[1].saved = !articlesItemsList[1].saved;
              });
            },
          ),
        ],
      ),
    body: SingleChildScrollView(
      child: Html(
        data: """
                <h1>adesso supports day hospital in South Africa with e-health solutions</h1>
                The Tokoloho Foundation day hospital was founded in the Tumahole township in the town of Parys, just south of Johannesburg, in 2008. It specialises in treating and providing medication to the rising number of patients suffering from chronic illnesses. These include HIV, which remains widespread in Africa, and also diseases such as tuberculosis, diabetes, high blood pressure and epilepsy. The hospital’s catchment area covers around 150,000 people, many of whom live in areas with insufficient medical care.
                <p>
                The Tokoloho Foundation’s work requires a great deal of coordination in this region: Tasks include arranging appointments, offering regular HIV and tuberculosis screening, notifying people of test results, dispensing prescribed medication, providing information about dosage and, if necessary, delivering medication directly to patients, inviting people to events and responding to medical questions. It is a huge workload for a small day hospital with just under 30 employees, which is to be relieved with immediate effect through the use of the e-health solution MediOne. adesso developed the MediOne app in conjunction with general practitioner Dr Ralph Jäger and his company MediOne GmbH.
                <p>
                Dr Almud Pollmeier, from the Südafrika-Hilfe association based in Ratingen, knows how hard it can be from her own experiences in the country. “Support from telemedicine is extremely valuable, especially in a region with a weak infrastructure such as this. There aren’t enough doctors here, but there are also a lot of people with long-term and even contagious diseases. These patients require intensive medical treatment even across long distances. Thankfully mobile communication networks and smartphones are widespread in South Africa. It makes sense to use these devices to provide medical care to patients.”
                <p>
                An adesso team consisting of e-health specialists paid a visit to the region in South Africa in November to familiarise themselves with the situation there. The first phase was to improve the IT infrastructure and integrate the MediOne e-health communication tool, a secure application featuring end-to-end encryption, into the day hospital and on the smartphones of the hospital’s employees. MediOne is an intuitive instant messaging app compatible with all current smartphones and connects patients with their Tokoloho health care centre around the clock.
                <p>
                The next phase of the project is already being planned, and involves continuing the work being done with as part of a project-based inter-cultural exchange programme for young people. As part of Agenda 2030, the Federal Ministry of Economic Cooperation and Development (BMZ) helps finance projects that actively and sustainably shape global society. Against this backdrop there is also the prospect of assistance for the partnership between adesso, Arbeit und Leben NRW and Südafrika-Hilfe and the Tokoloho Foundation to improve the level of medical care. Preparations are underway to secure funding for the inter-cultural health project between German IT experts at adesso (under the age of 30, as the project focuses on young people) and the day hospital in South Africa.

                """,
      ),
    ),
      bottomNavigationBar: BottomNavbar(currIndex: 0),
    );
  }
}