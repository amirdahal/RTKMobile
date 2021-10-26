class NmeaParser {
  static List nmea;

  static Future<dynamic> parse(String sentence) {
    NmeaParser parser = new NmeaParser();
    nmea = sentence.split(",");

    switch (nmea[0]) {
      case "\$GPGGA":
        return parser.parseGpgga();
      case "\$GPRMC":
      case "\$GNRMC":
        return parser.parseGprmc();
      case "\$GPGSA":
        return null;
      case "\$GPGSV":
        return null;
      case "\$PSTI":
        return parser.parsePsti();
      case "\$GNGLL":
        return parser.parseGngll();
    }
    return null;
  }

  Future<dynamic> parseGpgga() async {
    var cor, lat, lon;
    try {
      if (nmea[3] == "S") {
        lat = (-1 * double.parse(nmea[2]) / 100).toStringAsFixed(5);
      } else {
        lat = (double.parse(nmea[2]) / 100).toStringAsFixed(5);
      }
      if (nmea[5] == "W") {
        lon = (-1 * double.parse(nmea[4]) / 100).toStringAsFixed(5);
      } else {
        lon = (double.parse(nmea[4]) / 100).toStringAsFixed(5);
      }
      cor = '''
          {
            "lat": $lat,
            "lon": $lon
          }
        ''';
      return cor;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> parsePsti() async {
    var cor, lat, lon;
    try {
      if (nmea[5] == "S") {
        lat = (-1 * double.parse(nmea[5]) / 100).toStringAsFixed(5);
      } else {
        lat = (double.parse(nmea[5]) / 100).toStringAsFixed(5);
      }
      if (nmea[7] == "W") {
        lon = (-1 * double.parse(nmea[6]) / 100).toStringAsFixed(5);
      } else {
        lon = (double.parse(nmea[6]) / 100).toStringAsFixed(5);
      }
      cor = '''
          {
            "lat": $lat,
            "lon": $lon
          }
        ''';
      return cor;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> parseGprmc() async {
    var cor, lat, lon;
    try {
      if (nmea[4] == "S") {
        lat = (-1 * double.parse(nmea[3]) / 100).toStringAsFixed(5);
      } else {
        lat = (double.parse(nmea[3]) / 100).toStringAsFixed(5);
      }
      if (nmea[6] == "W") {
        lon = (-1 * double.parse(nmea[5]) / 100).toStringAsFixed(5);
      } else {
        lon = (double.parse(nmea[5]) / 100).toStringAsFixed(5);
      }
      cor = '''
          {
            "lat": $lat,
            "lon": $lon
          }
        ''';
      return cor;
    } catch (e) {
      return null;
    }
  }

  // dynamic parseGpgsa() {}
  // dynamic parseGpgsv() {}

  Future<dynamic> parseGngll() async {
    var cor, lat, lon;
    try {
      if (nmea[2] == "S") {
        lat = (-1 * double.parse(nmea[1]) / 100).toStringAsFixed(5);
      } else {
        lat = (double.parse(nmea[1]) / 100).toStringAsFixed(5);
      }
      if (nmea[4] == "W") {
        lon = (-1 * double.parse(nmea[3]) / 100).toStringAsFixed(5);
      } else {
        lon = (double.parse(nmea[3]) / 100).toStringAsFixed(5);
      }
      cor = '''
          {
            "lat": $lat,
            "lon": $lon
          }
        ''';
      return cor;
    } catch (e) {
      return null;
    }
  }
}
