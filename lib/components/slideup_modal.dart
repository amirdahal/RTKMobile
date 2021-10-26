import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

void slideUpModal(context, child) {
  showModalBottomSheet(
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    context: context,
    builder: (BuildContext c) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.white60,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        // child: SingleChildScrollView(
        //   child: child,
        // ),
        child: child,
      );
    },
  );
}

void showMyDialog(context, title, description) async {
  return AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    headerAnimationLoop: false,
    dialogType: DialogType.SUCCES,
    title: title,
    desc: description,
    btnOkOnPress: () {
      debugPrint('OnClcik');
    },
    btnOkIcon: Icons.check_circle,
    onDissmissCallback: () {
      debugPrint('Dialog Dissmiss from callback');
    },
  ).show();
}
