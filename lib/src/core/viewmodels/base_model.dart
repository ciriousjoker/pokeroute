import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokeroute/src/core/services/route_service.dart';
import 'package:pokeroute/src/core/services/spots_service.dart';
import 'package:pokeroute/locator.dart';

class BaseModel extends ChangeNotifier {
  final int id = Random.secure().nextInt(1000);

  SpotsService spotsService = locator<SpotsService>();
  RouteService routeService = locator<RouteService>();

  BaseModel() {
    spotsService.subscribe(() {
      notifyListeners();
    });

    routeService.subscribe(() {
      notifyListeners();
    });
  }

  void notifyAllListeners() {
    spotsService.triggerCallbacks();
    routeService.triggerCallbacks();
  }
}
