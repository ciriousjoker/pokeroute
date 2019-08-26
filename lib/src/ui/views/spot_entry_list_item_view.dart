// import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_web/material.dart';
import 'package:pokeapi/model/utils/common.dart';
import 'package:pokeroutes/locator.dart';
import 'package:pokeroutes/src/core/helper/spot_coordinates.dart';
import 'package:pokeroutes/src/core/models/spot.dart';
import 'package:pokeroutes/src/core/services/pokemon_service.dart';
import 'package:pokeroutes/src/core/services/spots_service.dart';

class SpotEntryListItem extends StatefulWidget {
  final bool addNew;
  final int id;

  final Spot spot;

  SpotEntryListItem({Key key, this.id, this.addNew = false, this.spot})
      : super(key: key);

  _SpotEntryListItemState createState() => _SpotEntryListItemState();
}

class _SpotEntryListItemState extends State<SpotEntryListItem> {
  TextEditingController textEditingControllerName;
  TextEditingController textEditingControllerCoordinates;

  FocusNode focusNodeName;
  FocusNode focusNodeCoordinates;

  SpotsService spotsService;

  GlobalKey key = GlobalKey<AutoCompleteTextFieldState<NamedAPIResource>>();

  // TODO: Change true to isPokemonThemeEnabled
  Color foregroundColor = true ? Colors.white : Colors.black;

  Future<List<NamedAPIResource>> suggestions;

  Spot spot;

  @override
  void initState() {
    textEditingControllerName = TextEditingController();
    textEditingControllerCoordinates = TextEditingController();

    focusNodeName = FocusNode();
    focusNodeCoordinates = FocusNode();

    focusNodeCoordinates.addListener(() {
      if (!focusNodeCoordinates.hasFocus) {
        print("Coordinates has lost focus.");
        if (!widget.addNew) {
          saveSpot();
        }
      }
    });

    spotsService = locator<SpotsService>();

    /// Load spot data or create an empty one
    spot = widget.spot ?? spotsService.createSpot();

    suggestions = locator<PokemonService>().indexPokemon;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadDataFromSpot();

    return ListTile(
      title: Row(children: <Widget>[
        Expanded(
            flex: 4,
            child: FutureBuilder<List<NamedAPIResource>>(
              future: suggestions,
              builder: (BuildContext context,
                  AsyncSnapshot<List<NamedAPIResource>> snapshot) {
                if (snapshot.data != null) {
                  return getSuggestionTextfield(snapshot.data);
                } else {
                  return TextField(
                    controller: textEditingControllerName,
                    focusNode: focusNodeName,
                    style: TextStyle(color: foregroundColor),
                    decoration: getInputDecoration("Name", foregroundColor),
                    onChanged: (text) {
                      spotsService.setSpotName(spot, text);
                    },
                  );
                }
              },
            )),
        Container(width: 24),
        Expanded(
          flex: 4,
          child: TextField(
              style: TextStyle(color: foregroundColor),
              controller: textEditingControllerCoordinates,
              onChanged: (text) {
                spot.coordinates = SpotCoordinates.fromString(text);
                spot.coordinates.setValid();
              },
              focusNode: focusNodeCoordinates,
              decoration: getInputDecoration("Coordinates", foregroundColor)),
        ),
      ]),
      trailing: IconButton(
        color: foregroundColor,
        icon: Icon(widget.addNew ? Icons.add : Icons.delete),
        onPressed: () {
          if (widget.addNew) {
            saveSpot(reset: true);
          } else {
            spotsService.removeSpot(spot.id);
          }
        },
      ),
    );
    // });
  }

  void saveSpot({bool reset = false}) async {
    Spot spotProxy = spot;
    if (reset) {
      resetState();
    }
    await locator<SpotsService>().setSpot(spotProxy);
  }

  void resetState() {
    setState(() {
      // Bugfix for a bug where text would reappear if you continued typing after it's been cleared
      // https://github.com/flutter/flutter/issues/35438
      textEditingControllerName.clear();
      textEditingControllerCoordinates.clear();
      focusNodeName.unfocus();
      focusNodeName.requestFocus();

      spot = widget.spot ?? spotsService.createSpot();
    });
  }

  void loadDataFromSpot() {
    assert(spot != null);
    if (textEditingControllerName.text != spot.name) {
      textEditingControllerName.text = spot.name;
    }

    if (textEditingControllerCoordinates.text != spot.formatCoordinates()) {
      textEditingControllerCoordinates.text = spot.formatCoordinates();
    }
  }

  String getPokemonName(NamedAPIResource data) {
    assert(data != null);
    return data.name[0].toUpperCase() + data.name.substring(1);
  }

  int sortByQuality(String name1, String name2, String searchString) {
    double quality1 = _getQuality(name1, searchString);
    double quality2 = _getQuality(name2, searchString);
    return quality2.compareTo(quality1);
  }

  double _getQuality(String name, String searchString) {
    double matches = 0;
    String nameRest = name.toLowerCase();
    for (int i = 0; i < searchString.length; ++i) {
      String character = searchString[i].toLowerCase();
      if (nameRest.contains(character)) {
        matches++;
        nameRest.replaceFirst(character, "");
      }
    }
    double quality = matches / name.length.toDouble();

    return quality;
  }

  Widget getSuggestionTextfield(List<NamedAPIResource> data) {
    return AutoCompleteTextField<NamedAPIResource>(
        style: TextStyle(color: foregroundColor),
        decoration: InputDecoration(
          hintText: "Pokemon",
          hintStyle: TextStyle(color: foregroundColor.withOpacity(0.87)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: foregroundColor)),
          suffixIcon: widget.addNew
              ? Icon(
                  Icons.search,
                  color: foregroundColor,
                )
              : null,
        ),
        key: key,
        controller: textEditingControllerName,
        focusNode: focusNodeName,
        suggestions: data,
        textChanged: (text) {
          spotsService.setSpotName(spot, text);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(getPokemonName(suggestion)),
          );
        },
        itemSorter: (a, b) =>
            sortByQuality(a.name, b.name, textEditingControllerName.text),
        itemFilter: (suggestion, input) {
          String name = suggestion.name.toLowerCase();
          for (int i = 0; i < input.length; ++i) {
            if (!name.contains(input[i].toLowerCase())) {
              return false;
            }
          }
          return true;
        },
        itemSubmitted: (pokemon) => setState(() {
              print("Submitted: " + pokemon.name);

              spotsService.setSpotName(spot, getPokemonName(pokemon));
              spotsService.setSpotPokemon(spot, pokemon);
            }));
  }

  getInputDecoration(String text, Color color) {
    return InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: foregroundColor.withOpacity(0.87)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)));
  }
}
