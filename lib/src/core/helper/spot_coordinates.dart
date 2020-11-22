import 'package:latlong/latlong.dart';

class SpotCoordinates extends LatLng {
  bool _isValid = false;
  bool get isValid => (_isValid || (latitude != 0 && longitude != 0));

  SpotCoordinates() : super(0, 0);

  SpotCoordinates.fromCoords(double latitude, double longitude)
      : super(latitude, longitude);

  SpotCoordinates.fromLatLng(LatLng coords)
      : super(coords.latitude, coords.longitude);

  static SpotCoordinates fromString(String coords) {
    var parsed = _parseCoordinates(coords);

    return parsed != null
        ? SpotCoordinates.fromCoords(parsed.latitude, parsed.longitude)
        : null;
  }

  static LatLng _parseCoordinates(String text) {
    // Regular expression that filters for only valid gps coordinates separated by " " or "," plus any number of " " before/after
    // See this for details: https://regexr.com/4jm62
    var regExp = RegExp(
        r"[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)\s*[ |,]\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)");

    if (!regExp.hasMatch(text)) {
      return null;
    }

    var match = regExp.firstMatch(text).group(0).toString();

    print("Matched coordinates: " + match.toString());

    var splitMatches = match.split(RegExp(r" |,"));
    var stringLatitude = splitMatches[0];
    var stringLongitude = splitMatches[splitMatches.length - 1];

    print("[$text]  => ($stringLongitude|$stringLatitude)");

    var latitude = double.parse(stringLatitude);
    var longitude = double.parse(stringLongitude);

    return LatLng(latitude, longitude);
  }

  void setValid() {
    _isValid = true;
  }

  @override
  String toString() {
    return isValid ? "$latitude,$longitude" : "";
  }
}
