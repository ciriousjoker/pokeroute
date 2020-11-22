import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/viewmodels/base_model.dart';

class ListSpotsModel extends BaseModel {
  List<Spot> get spots => spotsService.spots;
  List<Spot> get spotsSorted => routeService.spotsSorted;

  bool get hasSpots =>
      spotsService.spots != null && spotsService.spots.isNotEmpty;

  void resetCooldown() => routeService.resetCooldown();

  bool isVisited(int id) {
    var spot = spotsService.getSpot(id);
    return spot != null ? spot.visited : false;
  }

  void toggleVisited(int id) {
    var spot = spotsService.getSpot(id);
    if (spot != null) {
      spot.visited = !spot.visited;
    }
    notifyAllListeners();
  }

  int get idActiveLocation => routeService.idActiveLocation;
  set idActiveLocation(int id) => routeService.idActiveLocation = id;

  DateTime get cooldownStart => routeService.cooldownStart;
  Duration get cooldownTotal => routeService.cooldownTotal;
  Duration get cooldownElapsed => DateTime.now().difference(cooldownStart);
  double get cooldownProgress {
    try {
      var ret = cooldownElapsed.inSeconds / cooldownTotal.inSeconds;
      if (ret.isInfinite) {
        ret = 1;
      }
      return ret;
    } catch (e) {
      return null;
    }
  }

  int get distanceCurrent => routeService.distanceCurrent;
  int get distanceTotal => routeService.distanceTotal;
}
