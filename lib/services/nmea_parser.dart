class NmeaParser {
  static List nmea;

  static dynamic parse(String sentence) {
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
        return null;
        //return parser.parsePsti();
      case "\$GNGLL":
        return parser.parseGngll();
    }
    return null;
  }

  parseGpgga() {
    var cor, lat, lon;
    try {
      if (nmea[3] == "S") {
        lat = -1 * double.parse(nmea[2]);
      } else {
        lat = double.parse(nmea[2]);
      }
      if (nmea[5] == "W") {
        lon = -1 * double.parse(nmea[4]);
      } else {
        lon = double.parse(nmea[4]);
      }
      lat = dmsToDecimal(lat);
      lon = dmsToDecimal(lon);
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

  parsePsti() {
    var cor, lat, lon;
    try {
      if (nmea[5] == "S") {
        lat = -1 * double.parse(nmea[4]);
      } else {
        lat = double.parse(nmea[4]);
      }
      if (nmea[7] == "W") {
        lon = -1 * double.parse(nmea[6]);
      } else {
        lon = double.parse(nmea[6]);
      }
      lat = dmsToDecimal(lat);
      lon = dmsToDecimal(lon);
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

  parseGprmc() {
    var cor, lat, lon;
    try {
      if (nmea[4] == "S") {
        lat = -1 * double.parse(nmea[3]);
      } else {
        lat = double.parse(nmea[3]);
      }
      if (nmea[6] == "W") {
        lon = -1 * double.parse(nmea[5]);
      } else {
        lon = double.parse(nmea[5]);
      }
      lat = dmsToDecimal(lat);
      lon = dmsToDecimal(lon);
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

  parseGngll() {
    var cor, lat, lon;
    try {
      if (nmea[2] == "S") {
        lat = -1 * double.parse(nmea[1]);
      } else {
        lat = double.parse(nmea[1]);
      }
      if (nmea[4] == "W") {
        lon = -1 * double.parse(nmea[3]);
      } else {
        lon = double.parse(nmea[3]);
      }
      lat = dmsToDecimal(lat);
      lon = dmsToDecimal(lon);
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

  dmsToDecimal(dms) {
    var dd = dms~/100;
    var mm = dms-dd*100;
    var c = dd+mm/60;
    return c.toStringAsFixed(5);
  }
}
