import 'package:flutter/material.dart';
import 'package:pokeroute/locator.dart';
import 'package:pokeroute/src/core/services/route_service.dart';

class ExportGpx extends StatefulWidget {
  ExportGpx({Key key}) : super(key: key);

  @override
  _ExportGpxState createState() => _ExportGpxState();
}

class _ExportGpxState extends State<ExportGpx> {
  @override
  Widget build(BuildContext context) {
    var textEditingControllerFileName = TextEditingController();

    return Container(
      child: ListTile(
        title: TextField(
            controller: textEditingControllerFileName,
            decoration: InputDecoration(hintText: 'Filename')),
        trailing: MaterialButton(
            child: Text("Download"),
            onPressed: () {
              print("TODO: Implement download");
              try {
                locator<RouteService>().currentRoute.toGpx();
              } catch (e) {
                print("Couldn't export to gpx");
              }
            }),
      ),
    );
  }
}
