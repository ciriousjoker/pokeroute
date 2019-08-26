import 'dart:async';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/model/utils/common.dart';
import 'package:pokeapi/pokeapi.dart';

class PokemonService {
  Future<List<NamedAPIResource>> indexPokemon;

  PokemonService() {
    _loadPokemonIndex();
  }

  static Future<String> getPokemonType(int id) async {
    print("Getting type for: " + id.toString());
    Pokemon pokemon = await PokeAPI.getObject<Pokemon>(id);
    String primaryType;
    for (Types type in pokemon.types) {
      if (type.slot == 1) {
        primaryType = type.type.name;
      }
    }
    print("Primary type: " + primaryType);
    return primaryType;
  }

  void _loadPokemonIndex() async {
    indexPokemon = PokeAPI.getCommonList<Pokemon>(1, 151);
  }
}
