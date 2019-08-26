import 'package:flutter_web/material.dart';
import 'package:pokeroutes/src/core/models/spot.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroutes/src/ui/views/base_view.dart';
import 'package:pokeroutes/src/ui/views/spot_entry_list_item_view.dart';

class ListSpotEntriesView extends StatefulWidget {
  ListSpotEntriesView() : super();

  @override
  _ListSpotEntriesViewState createState() => _ListSpotEntriesViewState();
}

class _ListSpotEntriesViewState extends State<ListSpotEntriesView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ListSpotEntriesModel>(builder: (context, model, child) {
      return Column(
        children: <Widget>[
          SpotEntryListItem(addNew: true),
          Expanded(
              child: model.spots.isNotEmpty
                  ? getListViewOfSpots(model.spots)
                  : Container()),
        ],
        // ),
      );
    });
  }
}

Widget getListViewOfSpots(List<Spot> spots) => ListView.builder(
    itemCount: spots.length,
    itemBuilder: (context, index) {
      return SpotEntryListItem(
        key: Key(spots[index].id.toString()),
        id: spots[index].id,
        addNew: false,
        spot: spots[index],
      );
    });
