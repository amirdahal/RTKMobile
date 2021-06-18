import 'package:flutter/material.dart';
import 'package:rtk_mobile/components/ReusableCard.dart';
import 'package:rtk_mobile/components/bottom_navigation_bar.dart';
import 'package:rtk_mobile/components/constants.dart';
import 'package:rtk_mobile/components/rounded_button.dart';
import 'package:rtk_mobile/services/local_storage.dart';
import 'package:validators/validators.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController ipController = TextEditingController();
  bool isIPValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: null,
                    cardChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'IP ADDRESS',
                              style: kBodyTextStyle,
                            ),
                          ),
                          TextField(
                            controller: ipController,
                            onChanged: (value) {
                              setState(() {
                                if (!isIP(value) && !isNull(value))
                                  isIPValid = false;
                                else
                                  isIPValid = true;
                              });
                            },
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            autofocus: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: kTextFieldInputDecoration.copyWith(
                              hintText: 'IP ADDRESS',
                            ),
                          ),
                          Visibility(
                            visible: !isIPValid,
                            child: Text(
                              '* Invalid IP address',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          RoundedButton(
                            onPressed: () {
                              if (ipController.text != null && isIPValid) {
                                setState(() {
                                  LocalStorageManager.IP = ipController.text;
                                });
                              }
                              //save current IP for future use
                              //save in local storage and database
                            },
                            title: 'Save',
                            colour: kInactiveCardColor,
                          ),
                          Text(
                            '${LocalStorageManager.IP}',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'If some problem exists in connection, please connect your device to same wifi network as ESP32 and update the IP address above'),
          ),
          BottomNavigtionBar(
            currentIndex: 3,
          ),
        ],
      ),
    );
  }
}
