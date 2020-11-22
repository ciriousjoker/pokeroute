import 'package:flutter/material.dart';
import 'package:pokeroute/locator.dart';
import 'package:pokeroute/src/core/models/spot.dart';
import 'package:pokeroute/src/core/services/pokemon_service.dart';
import 'package:pokeroute/src/core/services/route_service.dart';
import 'package:pokeroute/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroute/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroute/src/ui/views/base_view.dart';
import 'package:provider/provider.dart';

class SpotWidget extends StatefulWidget {
  final Spot spot;

  SpotWidget({Key key, this.spot}) : super(key: key);

  @override
  _SpotWidgetState createState() => _SpotWidgetState();
}

class _SpotWidgetState extends State<SpotWidget> {
  bool isActive = false;
  ListSpotsModel model;

  Color get foregroundColor => widget.spot.pokemon != null
      ? Color.fromRGBO(255, 255, 255, 0.87)
      : Color.fromRGBO(0, 0, 0, 0.87);

  Future<String> pokemonType;

  @override
  void initState() {
    pokemonType = getPokemonType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ListSpotsModel>(builder: (context, model, child) {
      this.model = model;
      if (model.idActiveLocation != null &&
          model.idActiveLocation == widget.spot.id) {
        isActive = true;
      } else {
        isActive = false;
      }

      // TODO: Add loading animation until images are loaded

      return FutureBuilder(
          future: pokemonType,
          builder: (context, type) {
            if (type.data == null) {
              return Card(
                  child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text(widget.spot.name),
                subtitle: Text(widget.spot.formatCoordinates()),
              ));
            }
            print("type.data: " + type?.data?.toString());
            return Card(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    image: DecorationImage(
                        image:
                            AssetImage("energy_backgrounds/${type.data}.png"),
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        alignment: Alignment.center),
                  ),
                  child: Stack(
                    children: <Widget>[
                      // Material(
                      //     color: Colors.transparent,
                      //     child:
                      ListTile(
                        leading: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              tooltip: "Mark as current location",
                              color: foregroundColor,
                              icon: Icon(isActive
                                  ? Icons.my_location
                                  : Icons.location_searching),
                              onPressed: () {
                                model.idActiveLocation = widget.spot.id;
                              },
                            ),
                            IconButton(
                              tooltip: "Mark as caught",
                              color: foregroundColor,
                              icon: Icon(widget.spot.visited
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              onPressed: () {
                                print("Caught pokemon.");
                                model.toggleVisited(widget.spot.id);
                                locator<RouteService>()
                                    .moveToTargetLocation(widget.spot.id);
                              },
                            ),
                            getPokemonImage()
                          ],
                        ),
                        title: Text(
                          widget.spot.name,
                          style: TextStyle(
                            color: foregroundColor,
                          ),
                        ),
                        subtitle: getSubtitle(),
                        trailing: InkWell(
                          child: IconButton(
                            tooltip: "Remove the spot",
                            color: foregroundColor,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              Provider.of<ListSpotEntriesModel>(context,
                                      listen: false)
                                  .removeSpot(widget.spot.id);
                            },
                          ),
                        ),
                      )
                      // ),
                    ],
                  )),
            );
          });
    });
  }

  Widget getPokemonImage() {
    if (widget.spot.pokemon != null) {
      return Image(
        image: NetworkImage(
            'https://pokeres.bastionbot.org/images/pokemon/${widget.spot.pokemon.id}.png'),
        fit: BoxFit.scaleDown,
      );
    } else {
      return Container();
    }
  }

  Text getSubtitle() {
    return Text(
      widget.spot.formatCoordinates(),
      style: TextStyle(color: foregroundColor),
    );
  }

  Future<String> getPokemonType() async {
    try {
      var dexNumber = int.parse(widget.spot.pokemon.id);
      return await PokemonService.getPokemonType(dexNumber);
    } catch (e) {
      return "default";
    }
  }
}
