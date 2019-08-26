import 'dart:math';
import 'package:flutter_web/widgets.dart';
import 'package:pokeroutes/src/core/services/route_service.dart';
import 'package:pokeroutes/src/core/services/spots_service.dart';
import 'package:pokeroutes/locator.dart';

class BaseModel extends ChangeNotifier {
  final int id = Random.secure().nextInt(1000);

  SpotsService spotsService = locator<SpotsService>();
  RouteService routeService = locator<RouteService>();

  BaseModel() {
    spotsService.subscribe(() {
      print("[BaseModel] onDataChanged() for SpotsService " +
          spotsService.spots.toString());
      notifyListeners();
    });

    routeService.subscribe(() {
      print("[BaseModel] onDataChanged() for RouteService " +
          routeService.currentRoute.toString());
      notifyListeners();
    });
  }

  void notifyAllListeners() {
    spotsService.triggerCallbacks();
    routeService.triggerCallbacks();
  }
}
