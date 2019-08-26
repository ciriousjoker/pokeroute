import 'dart:math';

import 'package:gpx/gpx.dart';
import 'package:pokeroutes/src/core/models/spot.dart';

class OptimizedRoute {
  int id = Random().nextInt(100);

  int get distance => _calculateDistance();

  int get length {
    return spotsSorted.length;
  }

  List<Spot> spots = List();
  // List<int> sortedIndices = List();
  List<Spot> spotsSorted = List();

  String get hash {
    String retHash = "";
    spotsSorted.forEach((spot) => retHash += spot.id.toString());
    return retHash;
  }

  // int idActiveLocation;
  // int
  // int secondsTimeout;
  // int secondsDuration

  OptimizedRoute(List<Spot> spots) {
    this.spots = spots ?? List();
  }

  Spot getSpot(int id) {
    return spotsSorted[getSortedSpotIndex(id)];
  }

  int getSortedSpotIndex(int id) {
    // print("getSpotIndex() | spotsSorted: " + spotsSorted.toString());
    // print("getSpotIndex() | id: " + id.toString());

    for (int i = 0; i < spotsSorted.length; i++) {
      if (spotsSorted[i].id == id) {
        // print("Returned index: " + i.toString());
        return i;
      }
    }
    // print("Returned null as index.");
    return null;
  }

  void addIndex(int index) {
    // sortedIndices.add(index);
    spotsSorted.add(spots[index]);
  }

  @override
  String toString() {
    // print("[OptimizedRoute $id] Printing route with id: " + id.toString());

    // print("[OptimizedRoute $id] Spots: " + spots.toString());
    // print("[OptimizedRoute $id] SortedIndices: " + sortedIndices.toString());

    String line = "";

    try {
      if (spots.isEmpty) {
        return "[OptimizedRoute $id] There are no spots yet.";
      }

      if (spotsSorted.isEmpty) {
        return "[OptimizedRoute $id] Spots aren't sorted yet.";
      }

      Spot spotCurrent = spotsSorted[0];

      line += "[OptimizedRoute $id] [Distance total: " +
          distance.toString() +
          "] " +
          spotCurrent.name;
      for (int i = 1; i < spotsSorted.length; i++) {
        Spot spotNext = spotsSorted[i];
        int distance = spotCurrent.distanceTo(spotNext.coordinates);
        // Distance().distance(spot.coordinates, spotNext.coordinates);
        line += " -( " + distance.toString() + " )> " + spotNext.name;
        spotCurrent = spotNext;
      }
    } catch (e) {
      // print("[OptimizedRoute $id] Something went wrong.");
      return "[OptimizedRoute $id] Something went wrong.";
    }

    return line;
  }

  String toGpx() {
    var gpx = Gpx();
    gpx.creator = "PokeRoutes";
    // gpx.metadata
    gpx.wpts = spots
        .map((spot) => Wpt(
            lat: spot.coordinates.latitude,
            lon: spot.coordinates.longitude,
            name: spot.name))
        .toList();

    // [
    //   Wpt(lat: 36.62, lon: 101.77, ele: 10.0, name: 'Xining', desc: 'China'),
    // ];

    // generate xml string
    var gpxString = GpxWriter().asString(gpx, pretty: true);
    print(gpxString);
    return gpxString;
  }

  int _calculateDistance() {
    int retDistance = 0;
    Spot lastSpot = spotsSorted[0];
    for (int i = 0; i < spotsSorted.length - 1; ++i) {
      Spot nextSpot = spotsSorted[i + 1];
      int distance = lastSpot.distanceTo(nextSpot.coordinates);
      // print(lastSpot.name + " -( " + distance.toString() + " )> " + nextSpot.name);
      retDistance += distance;
      lastSpot = nextSpot;
    }
    return retDistance;
  }
}
