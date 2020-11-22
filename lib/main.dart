import 'package:flutter/material.dart';
import 'package:pokeroute/src/core/viewmodels/base_model.dart';
import 'package:pokeroute/src/core/viewmodels/current_spot_model.dart';
import 'package:pokeroute/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroute/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroute/locator.dart';
import 'package:pokeroute/src/ui/router.dart' as router;
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
        ChangeNotifierProvider(create: (context) => BaseModel()),
        ChangeNotifierProvider(create: (context) => ListSpotsModel()),
        ChangeNotifierProvider(create: (context) => ListSpotEntriesModel()),
        ChangeNotifierProvider(create: (context) => CurrentSpotModel()),
      ],
      child: MaterialApp(
        title: 'PokeRoute',
        theme: ThemeData(),
        onGenerateRoute: router.Router.generateRoute,
      ),
    );
  }
}
