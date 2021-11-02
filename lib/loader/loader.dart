import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rtk_mobile/components/constants.dart';
import 'package:rtk_mobile/components/round_icon_button.dart';
import 'package:rtk_mobile/services/local_storage.dart';
import 'package:rtk_mobile/services/map_object.dart';
import 'package:rtk_mobile/services/networking.dart';

class LoaderScreen extends StatefulWidget {
  @override
  _LoaderScreenState createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  bool _step1 = true;
  bool _step2 = false;
  String _infoText1 =
      "1. Connect to EZ_RTK wifi to start setup.\n2. If done click button below.";
  String _infoText2 =
      "1. Connect to wifi as ESP.\n2. If done click button below.";

  @override
  void initState() {
    setPosition();

    super.initState();
  }

  void setPosition() async {
    Position position = await UserLocation().getPosition();
    LocalStorageManager.position = position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.satelliteDish,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'RTK',
              style: kNumberTextStyle,
            ),
            SizedBox(height: 150.0),
            Visibility(
              visible: _step1,
              child: Column(
                children: [
                  Text(
                    _infoText1,
                    textAlign: TextAlign.center,
                    style: kLabelTextStyle.copyWith(),
                  ),
                  SizedBox(height: 100.0),
                  RoundIconButton(
                    icon: FontAwesomeIcons.arrowCircleRight,
                    onPressed: () async {
                      setState(() => _step1 = false);
                      var some = await networkHelper.getInitialData();
                      if (some != 'none') {
                        List cred = some.split(':');
                        LocalStorageManager.IP = cred[1];
                        _infoText2 =
                            "1. Connect to ${cred[0]} wifi as ESP.\n2. If done click button below.";
                        setState(() => _step2 = true);
                      } else if (some == 'none') {
                        _infoText2 =
                            "Looks like ESP isn't connected to any network. Proceed with EZ_RTK wifi and configure your esp";
                        setState(() => _step2 = true);
                      } else {
                        setState(() {
                          _step1 = true;
                          _step2 = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _step2,
              child: Column(
                children: [
                  Text(
                    _infoText2,
                    textAlign: TextAlign.center,
                    style: kLabelTextStyle.copyWith(),
                  ),
                  SizedBox(height: 100.0),
                  RoundIconButton(
                    icon: FontAwesomeIcons.arrowCircleRight,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/0');
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Icon(
                  Icons.repeat,
                  size: 35.0,
                  color: Colors.red,
                  semanticLabel: 'Reset app',
                ),
              ),
              onTap: () {
                setState(() {
                  _step1 = true;
                  _step2 = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
