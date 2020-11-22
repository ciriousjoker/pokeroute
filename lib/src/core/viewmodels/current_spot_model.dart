import 'package:pokeroute/src/core/models/optimized_route.dart';
import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/viewmodels/base_model.dart';

class CurrentSpotModel extends BaseModel {
  List<Spot> get spots => spotsService.spots;
  List<Spot> get spotsSorted => routeService.spotsSorted;
  OptimizedRoute get route => routeService.currentRoute;
  bool get hasRoute => routeService.hasRoute;
  String get routeHash => routeService.routeHash;

  int get idTargetLocation => routeService.idTargetLocation;
  set idTargetLocation(int id) => routeService.idTargetLocation = id;

  int getSortedSpotIndex(int id) =>
      routeService.currentRoute.getSortedSpotIndex(id);
  Spot getSpot(int id) => spotsService.getSpot(id);

  bool get visited {
    var spot = getSpot(idTargetLocation);
    return spot != null ? spot.visited : false;
  }

  void resetCooldown() => routeService.resetCooldown();

  void setVisited(Spot spot, bool visited) {
    print("setVisited()");
    if (spot == null) return;
    spot.visited = visited;

    // Move the player to the next waypoint
    if (visited) {
      routeService.moveToTargetLocation(spot.id);
    }

    notifyAllListeners();
  }
}
