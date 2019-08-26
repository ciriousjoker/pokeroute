import 'dart:async';

import 'package:duration/duration.dart';
import 'package:flutter_web/material.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroutes/src/ui/views/base_view.dart';

class DistanceBarWidget extends StatefulWidget {
  const DistanceBarWidget({Key key}) : super(key: key);

  @override
  _DistanceBarWidgetState createState() => _DistanceBarWidgetState();
}

class _DistanceBarWidgetState extends State<DistanceBarWidget> {
  ListSpotsModel model;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ListSpotsModel>(builder: (context, model, child) {
      this.model = model;

      double progress = (model.cooldownProgress ?? 0);

      return Container(
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Row(
              children: <Widget>[
                getInfoText(formatDuration(model.cooldownElapsed)),
                Expanded(
                  child:
                      Center(child: getInfoText(getFormattedDistance(model))),
                ),
                getInfoText(formatDuration(model.cooldownTotal))
              ],
            ),
            SizedBox(
                height: 4.0,
                child: LinearProgressIndicator(
                    backgroundColor: progress < 1 ? Colors.grey : Colors.green,
                    value: progress < 1 ? progress : 0)),
          ],
        ),
      );
    });
  }

  String getFormattedDistance(ListSpotsModel model) {
    if (!model.hasSpots) {
      return "";
    }

    // TODO: Replace with proper library
    return model.distanceCurrent.toString() + "m ";
  }

  Text getInfoText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300));
  }

  String formatDuration(Duration duration) {
    return printDuration(duration, abbreviated: true, delimiter: " ");
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      } else {
        t.cancel();
      }
    });
  }
}
