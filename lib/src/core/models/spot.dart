import 'package:latlong/latlong.dart';
import 'package:pokeapi/model/utils/common.dart';
import 'package:pokeroutes/src/core/helper/spot_coordinates.dart';

class Spot {
  int id;
  String name;
  NamedAPIResource pokemon;

  SpotCoordinates coordinates;
  bool visited = false;

  Spot({this.id, this.name, this.coordinates, this.pokemon});

  bool get isValid {
    return name.isNotEmpty &&
        coordinates.latitude != null &&
        coordinates.longitude != null;
  }

  int distanceTo(LatLng coord) {
    return Distance().distance(this.coordinates, coord).toInt();
  }

  String formatCoordinates() {
    return coordinates != null ? coordinates.toString() : "";
  }

  @override
  String toString() {
    return pokemon != null
        ? '$id | #${pokemon.id} | $name | $coordinates | $visited'
        : '$id | $name | $coordinates | $visited';
  }
}
