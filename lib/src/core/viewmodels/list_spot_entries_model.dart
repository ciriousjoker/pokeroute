import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/viewmodels/base_model.dart';

class ListSpotEntriesModel extends BaseModel {
  List<Spot> get spots => spotsService.spots;

  Future<bool> setSpot(Spot spot) => spotsService.setSpot(spot);
  Spot getSpot(int id) => spotsService.getSpot(id);
  void removeSpot(int id) => spotsService.removeSpot(id);
}
