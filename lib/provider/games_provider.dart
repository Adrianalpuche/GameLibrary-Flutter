
import 'package:flutter/material.dart';
import 'package:game_library/models/games.dart';
import 'package:game_library/features/data/api/api.dart';

class GamesProvider extends ChangeNotifier {
  List<Games> _games = [];
  List<Games> get games => _games;
  

  Future<void> fetchGames() async {
    try {
      final api = Api();
      final data = await api.getGames();
      
      notifyListeners();
    } catch (e) {
      print('Error fetching games: $e');
    }
  }
}