import 'package:flutter_web/material.dart';
import 'package:pokeroutes/locator.dart';
import 'package:pokeroutes/src/core/models/spot.dart';
import 'package:pokeroutes/src/core/services/pokemon_service.dart';
import 'package:pokeroutes/src/core/services/route_service.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spot_entries_model.dart';
import 'package:pokeroutes/src/core/viewmodels/list_spots_model.dart';
import 'package:pokeroutes/src/ui/views/base_view.dart';
import 'package:provider/provider.dart';

class SpotWidget extends StatefulWidget {
  final Spot spot;

  SpotWidget({Key key, this.spot}) : super(key: key);

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
            return Card(
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("energy_backgrounds/${type.data}.png"),
                          fit: BoxFit.fitWidth,
                          repeat: ImageRepeat.noRepeat,
                          alignment: Alignment.center)),
                  child: Stack(
                    children: <Widget>[
                      Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  color: foregroundColor,
                                  icon: Icon(isActive
                                      ? Icons.my_location
                                      : Icons.location_searching),
                                  onPressed: () {
                                    model.idActiveLocation = widget.spot.id;
                                  },
                                ),
                                IconButton(
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
                                color: foregroundColor,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<ListSpotEntriesModel>(context)
                                      .removeSpot(widget.spot.id);
                                },
                              ),
                            ),
                          )),
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
      int dexNumber = int.parse(widget.spot.pokemon.id);
      return await PokemonService.getPokemonType(dexNumber);
    } catch (e) {
      return "default";
    }
  }
}
