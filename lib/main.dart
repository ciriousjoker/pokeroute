import 'package:flutter_web/material.dart';
import 'package:pokeroutes/src/core/viewmodels/base_model.dart';
import 'package:pokeroutes/src/core/viewmodels/current_spot_model.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroutes/locator.dart';
import 'package:pokeroutes/src/ui/router.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => BaseModel()),
        ChangeNotifierProvider(builder: (context) => ListSpotsModel()),
        ChangeNotifierProvider(builder: (context) => ListSpotEntriesModel()),
        ChangeNotifierProvider(builder: (context) => CurrentSpotModel()),
      ],
      child: MaterialApp(
        title: 'PokeRoutes',
        theme: ThemeData(),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
