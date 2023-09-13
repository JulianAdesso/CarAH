import 'package:carah_app/model/bottom_navbar_index.dart';
import 'package:carah_app/shared/appbar_widget.dart';
import 'package:carah_app/shared/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../model/settings.dart';
import '../../providers/settings_provider.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  Settings? currentSettings;

  @override
  initState() {
    super.initState();
    var provider = Provider.of<SettingsProvider>(context, listen: false);
    provider.getSettingsOfUser();
    currentSettings = provider.userSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(
        title: "Settings",
      ),
      body: Consumer<SettingsProvider>(builder: (key, builder, child) {
        return Scrollable(
            viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Column(
            children: [
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.mobiledata_off, size: Theme.of(context).iconTheme.size,)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Data Save Mode", style: Theme.of(context).textTheme.titleLarge),
                                Text("Turn Data Save Mode on or off", style: Theme.of(context).textTheme.labelLarge)
                              ],
                            ),
                          ],
                        ),

                        Switch(
                            value: currentSettings != null
                                ? currentSettings!.dataSaveMode
                                : false,
                            onChanged: (val) {
                              if (currentSettings != null) {
                                setState(() {
                                  currentSettings!.dataSaveMode = val;
                                  Provider.of<SettingsProvider>(context,
                                          listen: false)
                                      .saveSettings(currentSettings!);
                                });
                              }
                            }),
                      ]),
                ),
              ),
              GestureDetector(
                onTap: (){
                  context.push('/settings/imprint');
                },
                child: Card(
                  elevation: 1,
                  margin: const EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(Symbols.format_paragraph, size: Theme.of(context).iconTheme.size,)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Imprint", style: Theme.of(context).textTheme.titleLarge),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  context.push('/settings/privacy_policy');
                },
                child: Card(
                  elevation: 1,
                  margin: const EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(Symbols.policy, size: Theme.of(context).iconTheme.size,)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Privacy Policy", style: Theme.of(context).textTheme.titleLarge),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          );
        });
      }),
      bottomNavigationBar: BottomNavbar(
        currIndex: BottomNavbarIndex.settings.index,
      ),
    );
  }
}
