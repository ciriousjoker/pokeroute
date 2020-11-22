import 'package:flutter/material.dart';
import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroute/src/ui/views/base_view.dart';
import 'package:pokeroute/src/ui/widgets/spot_widget.dart';

class ListSpotsView extends StatefulWidget {
  ListSpotsView() : super();

  @override
  _ListSpotsViewState createState() => _ListSpotsViewState();
}

class _ListSpotsViewState extends State<ListSpotsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ListSpotsModel>(builder: (contextSpots, model, childSpots) {
      if (model.spots.isNotEmpty) {
        return getSpots(model.spotsSorted);
      }

      return Align(
        alignment: Alignment.center,
        child: Text("Add spots to see your route.",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
      );
    });
  }

  Widget getSpots(List<Spot> spots) {
    var retSteps = <SpotWidget>[];
    for (var spot in spots) {
      retSteps.add(SpotWidget(key: Key(spot.id.toString()), spot: spot));
    }
    return ListView.builder(
        itemCount: spots.length,
        itemBuilder: (context, index) => retSteps[index]);
  }
}
