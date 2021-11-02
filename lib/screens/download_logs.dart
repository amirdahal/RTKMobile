import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:rtk_mobile/components/bottom_navigation_bar.dart';
import 'package:rtk_mobile/services/local_storage.dart';
import 'package:rtk_mobile/services/networking.dart';
import 'package:url_launcher/url_launcher.dart';

class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool _isLoading = false;
  List<String> files = [];

  NetworkHelper networkHelper = NetworkHelper();

  void getFiles() async {
    setState(() => _isLoading = true);
    http.Response response = await networkHelper.getFiles();
    String bodyText = response.body;
    print(bodyText);
    setState(() {
      _isLoading = false;
      files = bodyText.split(' ');
      if (bodyText == 'failed to open directory') {
        files = [];
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          showCloseIcon: false,
          closeIcon: Icon(Icons.close_fullscreen_outlined),
          title: 'No files found',
          desc: 'No files were found or there was some problem',
          btnOkOnPress: () {},
        ).show();
      }
    });
    print(files);
    print(files.length);
  }

  @override
  void initState() {
    super.initState();
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DOWNLOAD LOGS'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => getFiles(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: _isLoading
                ? SpinKitFadingFour(
                    color: Colors.white,
                  )
                : ListView.builder(
                    itemCount: files.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(Icons.list),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                          onTap: () async {
                            var _url =
                                'http://${LocalStorageManager.IP}/download${files[index]}';
                            await canLaunch(_url)
                                ? await launch(_url)
                                : throw 'Could not launch $_url';
                          },
                        ),
                        title:
                            Text("${files[index].split(".")[0].substring(1)}"),
                      );
                    }),
          ),
          Expanded(child: BottomNavigtionBar(currentIndex: 2))
        ],
      ),
    );
  }
}
