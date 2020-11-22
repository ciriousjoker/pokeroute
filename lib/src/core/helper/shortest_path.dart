import 'package:pokeroute/src/core/models/optimized_route.dart';
import 'package:pokeroute/src/core/models/spot.dart';

class ShortestPath {
  List<Spot> spots;
  List<List<int>> graph;
  List<OptimizedRoute> routes = [];

  ShortestPath({this.spots}) {
    graph = _getGraph(spots);
    _resetVisited();
  }

  List<bool> _resetVisited() {
    var retVisited = List<bool>(spots.length);
    retVisited.fillRange(0, spots.length, false);
    return retVisited;
  }

  void _recurse(int currentIndex, List<bool> currentVisited,
      OptimizedRoute currentRoute) {
    currentRoute.addIndex(currentIndex);
    currentVisited[currentIndex] = true;

    if (currentRoute.length >= spots.length) {
      routes.add(currentRoute);
      return;
    }

    for (var i = 0; i < spots.length; i++) {
      if (!currentVisited[i]) {
        _recurse(i, currentVisited, currentRoute);
      }
    }
    return;
  }

  Future<OptimizedRoute> getOptimizedRoute() async {
    for (var i = 0; i < spots.length; i++) {
      _recurse(i, _resetVisited(), OptimizedRoute(spots));
    }

    OptimizedRoute retRoute;
    for (var i = 0; i < routes.length; i++) {
      if (retRoute == null || routes[i].distance < retRoute.distance) {
        retRoute = routes[i];
      }
    }

    print("[ShortestPath] Returned: " + retRoute.toString());
    return retRoute;
  }

  List<List<int>> _getGraph(List<Spot> spots) {
    var retGraph = <List<int>>[];

    for (final spot in spots) {
      var distances = <int>[];

      for (var i = 0; i < spots.length; i++) {
        distances.add(spot.distanceTo(spots[i].coordinates));
      }

      retGraph.add(distances);
    }

    return retGraph;
  }
}
