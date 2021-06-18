import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtk_mobile/components/ReusableCard.dart';
import 'package:rtk_mobile/components/bottom_navigation_bar.dart';
import 'package:rtk_mobile/components/constants.dart';
import 'package:rtk_mobile/components/icon_content.dart';
import 'package:rtk_mobile/components/rounded_button.dart';
import 'package:rtk_mobile/components/slideup_modal.dart';
import 'package:rtk_mobile/services/local_storage.dart';
import 'package:rtk_mobile/services/networking.dart';
import 'package:validators/validators.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NetworkHelper networkHelper = NetworkHelper();

  String ssid, password, manCommand, res;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTK HOME'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      margin: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                      onPress: () => slideUpModal(
                        context,
                        Column(
                          children: [
                            RoundedButton(
                              onPressed: () async {
                                var res = await networkHelper.setMode('BASE');
                                if (res == 200) {
                                  print('Done!!!');
                                  LocalStorageManager.mode = 'BASE';
                                  showMyDialog(context, 'MODE SET',
                                      'RTK mode set to BASE');
                                } else {
                                  print('something went wrong');
                                }
                                setState(() {});
                              },
                              title: 'SET MODE BASE',
                              colour: kInactiveCardColor,
                            ),
                          ],
                        ),
                      ),
                      color: kActiveCardColor,
                      cardChild: CustomIconWidget(
                        //icon: FontAwesomeIcons.broadcastTower,
                        icon: Icons.satellite_outlined,
                        label: 'SET BASE',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      margin: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
                      color: kActiveCardColor,
                      onPress: () => slideUpModal(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration:
                                      kTextFieldInputDecoration.copyWith(
                                          contentPadding: EdgeInsets.all(15.0),
                                          hintText: 'LATITUDE'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration:
                                      kTextFieldInputDecoration.copyWith(
                                          contentPadding: EdgeInsets.all(15.0),
                                          hintText: 'LONGITUDE'),
                                ),
                              ),
                              RoundedButton(
                                onPressed: () async {
                                  var res =
                                      await networkHelper.setMode('ROVER');
                                  if (res == 200) {
                                    print('Done!!!');
                                    LocalStorageManager.mode = 'ROVER';
                                    showMyDialog(context, 'MODE SET',
                                        'RTK mode set to ROVER');
                                  } else {
                                    print('something went wrong');
                                  }
                                  setState(() {});
                                },
                                colour: kInactiveCardColor,
                                title: 'SET MODE ROVER',
                              )
                            ],
                          ),
                        ),
                      ),
                      cardChild: CustomIconWidget(
                        icon: FontAwesomeIcons.satelliteDish,
                        label: 'SET ROVER',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      onPress: () => slideUpModal(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration:
                                      kTextFieldInputDecoration.copyWith(
                                          contentPadding: EdgeInsets.all(15.0),
                                          hintText: 'WIFI SSID'),
                                  onChanged: (value) {
                                    ssid = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration:
                                      kTextFieldInputDecoration.copyWith(
                                          contentPadding: EdgeInsets.all(15.0),
                                          hintText: 'PASSWORD'),
                                  onChanged: (value) {
                                    password = value;
                                  },
                                ),
                              ),
                              RoundedButton(
                                onPressed: () async {
                                  String response = await networkHelper
                                      .setWiFiConfig(ssid, password);
                                  if (isIP(response)) {
                                    showMyDialog(
                                        context,
                                        'Wi-FI setup complete',
                                        'Connect device to "$ssid" Wi-Fi.\nIP address set to $response');
                                    print(
                                        'Wifi connection changed, Connect to $ssid $response wifi.');
                                    LocalStorageManager.IP = response;
                                  } else {
                                    print(
                                        "Some error occurred! Failed to execute command");
                                  }
                                  setState(() {});
                                },
                                colour: kInactiveCardColor,
                                title: 'SET WIFI CREDENTIAL',
                              ),
                            ],
                          ),
                        ),
                      ),
                      color: kActiveCardColor,
                      cardChild: CustomIconWidget(
                        icon: Icons.network_wifi,
                        label: 'CONFIGURE WI-FI',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                      onPress: () => slideUpModal(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration:
                                      kTextFieldInputDecoration.copyWith(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'MANUAL COMMAND',
                                  ),
                                  onChanged: (value) {
                                    manCommand = value;
                                  },
                                ),
                              ),
                              RoundedButton(
                                onPressed: () async {
                                  var res = await networkHelper
                                      .setManualCommand(manCommand);
                                  if (res == 200) {
                                    print('Done!!!');
                                    LocalStorageManager.command = manCommand;
                                    showMyDialog(context, 'COMMAND SENT',
                                        'Command executed there');
                                    manCommand = "";
                                  } else {
                                    print('something went wrong');
                                  }
                                  setState(() {});
                                },
                                colour: kInactiveCardColor,
                                title: 'SEND COMMAND',
                              )
                            ],
                          ),
                        ),
                      ),
                      color: kActiveCardColor,
                      cardChild: CustomIconWidget(
                        icon: Icons.code_sharp,
                        label: 'WRITE COMMAND',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3.8,
              child: Row(
                children: [
                  Expanded(
                    child: ReusableCard(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                      color: kActiveCardColor,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'HISTORY',
                            style: kResultTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Last IP: ',
                                style: kBodyTextStyle,
                              ),
                              Text(
                                '${LocalStorageManager.IP}',
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Last Mode SET: ',
                                style: kBodyTextStyle,
                              ),
                              Text(
                                '${LocalStorageManager.mode}',
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Cmd: ',
                                style: kBodyTextStyle,
                              ),
                              Text(
                                '${LocalStorageManager.command}',
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavigtionBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}
