import 'package:get_it/get_it.dart';
import 'package:pokeroutes/src/core/services/pokemon_service.dart';
import 'package:pokeroutes/src/core/services/route_service.dart';
import 'package:pokeroutes/src/core/services/spots_service.dart';
import 'package:pokeroutes/src/core/viewmodels/base_model.dart';
import 'package:pokeroutes/src/core/viewmodels/current_spot_model.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroutes/src/core/viewmodels/main_model.dart';
import 'package:pokeroutes/src/core/viewmodels/spot_entry_list_item_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SpotsService());
  locator.registerLazySingleton(() => RouteService());
  locator.registerLazySingleton(() => PokemonService());

  locator.registerSingleton<BaseModel>(BaseModel());

  locator.registerFactory(() => SpotEntryListItemModel());
  locator.registerFactory(() => MainModel());
  locator.registerFactory(() => ListSpotEntriesModel());
  locator.registerFactory(() => ListSpotsModel());
  locator.registerFactory(() => CurrentSpotModel());
}
