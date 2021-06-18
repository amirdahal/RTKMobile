import 'package:flutter/material.dart';
import 'constants.dart';

class CustomIconWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  CustomIconWidget({this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
          color: Colors.white,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle.copyWith(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
