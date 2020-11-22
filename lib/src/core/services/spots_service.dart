import 'package:pokeapi/model/utils/common.dart';
import 'package:pokeroute/src/core/helper/spot_coordinates.dart';
import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/services/base_service.dart';
import 'package:pokeroute/src/core/services/route_service.dart';
import 'package:pokeroute/locator.dart';

class SpotsService extends BaseService {
  RouteService routeService = locator<RouteService>();

  final List<Spot> _spots = [];
  // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  //     .map((index) => Spot(
  //         id: index,
  //         name: "START #" + index.toString(),
  //         coordinates: SpotCoordinates.fromCoords(2,2)))
  //     .toList();

  List<Spot> get spots => _spots;

  static int _nextSpotId = 0;

  SpotsService() {
    routeService.updateRoute(spots);
  }

  int _getNextSpotId() {
    return ++_nextSpotId;
  }

  Spot createSpot(
      {int id,
      String name,
      SpotCoordinates coordinates,
      NamedAPIResource pokemon}) {
    var ret = Spot(
        id: id ?? _getNextSpotId(),
        name: name ?? "",
        coordinates: coordinates,
        pokemon: pokemon);
    print("[RouteService] Created Spot: " + ret.toString());
    return ret;
  }

  Spot getSpot(int id) {
    for (var i = 0; i < spots.length; i++) {
      if (spots[i].id == id) {
        return spots[i];
      }
    }
    return null;
  }

  void setSpotName(Spot spot, String name) {
    spot.name = name;
    triggerCallbacks();
  }

  void setSpotPokemon(Spot spot, NamedAPIResource pokemon) {
    spot.pokemon = pokemon;
    triggerCallbacks();
  }

  Future<bool> setSpot(Spot spot) async {
    if (spot.isValid) {
      var index = _getSpotIndex(spot.id);
      if (index == null) {
        _spots.add(spot);
      } else {
        _spots[index] = spot;
      }
      print("Added spot: " + spot.toString());

      await routeService.updateRoute(spots).then((asd) {
        triggerCallbacks();
      });
      return true;
    }
    return false;
  }

  void removeSpot(int id) async {
    print("removeSpot() | Spots: " + _spots.toString());
    print("removeSpot() | Id: " + id.toString());

    var index = _getSpotIndex(id);
    _spots.removeAt(index);

    print("removeSpot() | Spots (after): " + _spots.toString());

    await routeService.updateRoute(spots);
    triggerCallbacks();
  }

  int _getSpotIndex(int id) {
    for (var i = 0; i < spots.length; i++) {
      if (spots[i].id == id) {
        return i;
      }
    }
    return null;
  }
}
