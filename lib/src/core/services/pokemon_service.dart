import 'dart:async';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/model/utils/common.dart';
import 'package:pokeapi/pokeapi.dart';

class PokemonService {
  Future<List<NamedAPIResource>> indexPokemon =
      PokeAPI.getCommonList<Pokemon>(1, 255);

  static Future<String> getPokemonType(int id) async {
    print("Getting type for: " + id.toString());
    var pokemon = await PokeAPI.getObject<Pokemon>(id);
    String primaryType;
    for (var type in pokemon.types) {
      if (type.slot == 1) {
        primaryType = type.type.name;
      }
    }
    print("Primary type: " + primaryType);
    return primaryType;
  }
}
