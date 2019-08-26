import 'package:pokeroutes/locator.dart';
import 'package:pokeroutes/src/core/helper/cooldown.dart';
import 'package:pokeroutes/src/core/models/optimized_route.dart';
import 'package:pokeroutes/src/core/models/spot.dart';
import 'package:pokeroutes/src/core/services/base_service.dart';
import 'package:pokeroutes/src/core/helper/shortest_path.dart';
import 'package:pokeroutes/src/core/services/spots_service.dart';

class RouteService extends BaseService {
  OptimizedRoute currentRoute;

  DateTime cooldownStart = DateTime.now();
  Duration get cooldownTotal =>
      Duration(minutes: Cooldown.getCooldownForDistance(distanceCurrent));

  bool get hasRoute => currentRoute != null && currentRoute.length > 0;

  int _idActiveLocation = 0;
  int get idActiveLocation => _idActiveLocation;
  set idActiveLocation(int id) {
    _idActiveLocation = id;
    triggerCallbacks();
  }

  int _idTargetLocation = 0;
  int get idTargetLocation => _idTargetLocation;
  set idTargetLocation(int id) {
    _idTargetLocation = id;
    triggerCallbacks();
  }

  List<Spot> get spotsSorted =>
      currentRoute != null ? currentRoute.spotsSorted : List();

  String get routeHash => currentRoute != null ? currentRoute.hash : null;

  void printLocations() {
    // print("idActiveLocation: " + idActiveLocation.toString());
    // print("idTargetLocation: " + idTargetLocation.toString());
  }

  int get distanceCurrent {
    printLocations();

    try {
      return currentRoute
          .getSpot(idActiveLocation)
          .distanceTo(currentRoute.getSpot(idTargetLocation).coordinates);
    } catch (e) {
      return 0;
    }
  }

  int get distanceTotal {
    print(
        "distanceTotal() | TODO: Remove this, it's not needed and also calculated wrong");
    printLocations();
    return spotsSorted[0].distanceTo(spotsSorted.last.coordinates);
  }

  Future<void> updateRoute(List<Spot> spots) async {
    if (spots != null && spots.isNotEmpty) {
      currentRoute = await ShortestPath(spots: spots).getOptimizedRoute();
      print("[RouteService] updateRoute() | currentRoute: " +
          currentRoute.toString());
    } else {
      currentRoute = null;
    }

    if (spotsSorted != null && spotsSorted.isNotEmpty) {
      idActiveLocation = spotsSorted[0].id;
      idTargetLocation = spotsSorted[0].id;
    }

    triggerCallbacks();
  }

  void moveToTargetLocation(int id) {
    print("moveToTargetLocation()");
    printLocations();
    idActiveLocation = id;
    int nextIndex = currentRoute.getSortedSpotIndex(idActiveLocation + 1);
    do {
      idTargetLocation = spotsSorted[++nextIndex].id;
    } while (locator<SpotsService>().getSpot(idTargetLocation).visited &&
        nextIndex < spotsSorted.length - 1);
    printLocations();
    triggerCallbacks();
  }

  void resetCooldown() {
    cooldownStart = DateTime.now();
  }
}
