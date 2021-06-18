import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtk_mobile/components/round_icon_button.dart';

import 'ReusableCard.dart';
import 'constants.dart';

class DownloadCardTile extends StatelessWidget {
  final Function onPressed;
  final String fileName;

  DownloadCardTile({@required this.fileName, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      //margin: EdgeInsets.all(5.0),
      color: kActiveCardColor,
      cardChild: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(
                FontAwesomeIcons.file,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                '$fileName',
                style: kBodyTextStyle,
              ),
            ),
            Expanded(
              child: RoundIconButton(
                icon: FontAwesomeIcons.download,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
      onPress: onPressed,
    );
  }
}
