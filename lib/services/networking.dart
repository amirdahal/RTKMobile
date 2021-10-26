// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'package:rtk_mobile/services/local_storage.dart';

class NetworkHelper {
  static String IP = LocalStorageManager.IP;
  // final Dio dio = Dio();

  NetworkHelper() {
    IP = LocalStorageManager.localIp;
  }

  Future setMode(String mode) async {
    IP = LocalStorageManager.IP;
    String url = 'http://$IP/command/\$EZ_RTK,SET-MODE,$mode';
    http.Response response = await http.get(Uri.parse(url));
    return response.statusCode;
  }

  Future setWiFiConfig(String ssid, String password) async {
    IP = LocalStorageManager.IP;
    String url = 'http://$IP/connect/\$EZ_RTK,SET-WIFI,$ssid,$password';
    http.Response response = await http.get(Uri.parse(url));
    print(response.body);
    return response.body;
  }

  Future setManualCommand(String command) async {
    IP = LocalStorageManager.IP;
    String url = 'http://$IP/command/$command';
    http.Response response = await http.get(Uri.parse(url));
    return response.statusCode;
  }

  Future getInitialData() async {
    IP = LocalStorageManager.IP;
    String tempUrl = 'http://$IP/init/';
    print(tempUrl);
    http.Response response = await http.get(Uri.parse(tempUrl));
    return response.body;
  }

  Future getLiveDate() async {
    IP = LocalStorageManager.IP;
    String url = 'http://$IP/livedata';
    return await http.get(Uri.parse(url));
  }

  Future getFiles() async {
    IP = LocalStorageManager.IP;
    String url = 'http://$IP/files';
    return await http.get(Uri.parse(url));
  }
}
