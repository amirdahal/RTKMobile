import 'package:flutter/material.dart';
// import 'package:rtk_mobile/screens/download_logs.dart';
// import 'package:rtk_mobile/screens/home1.dart';

class BottomNavigtionBar extends StatefulWidget {
  final int currentIndex;
  BottomNavigtionBar({@required this.currentIndex});

  @override
  _BottomNavigtionBarState createState() => _BottomNavigtionBarState();
}

class _BottomNavigtionBarState extends State<BottomNavigtionBar> {
  //static List routes = [Home(), Download, Home, Download];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      //backgroundColor: Color(0xFF6200EE),
      backgroundColor: Color(0xFF0A0E21),
      //selectedItemColor: Colors.white,
      selectedItemColor: Color(0xFF24D876),
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: (value) {
        String x = '/$value';
        if (value != widget.currentIndex && value != 1) {
          Navigator.of(context).pushReplacementNamed(x);
        }
        if (value != widget.currentIndex && value == 1) {
          Navigator.pushNamed(context, x);
        }
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(
            Icons.home_outlined,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Map',
          icon: Icon(Icons.location_on_sharp),
          activeIcon: Icon(
            Icons.location_on,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Logs',
          icon: Icon(Icons.download_outlined),
          activeIcon: Icon(
            Icons.download_outlined,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
          activeIcon: Icon(
            Icons.settings,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}
