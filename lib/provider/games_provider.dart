import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:game_library/models/games.dart';
import 'package:game_library/features/data/api/api.dart';

class GamesProvider extends ChangeNotifier {
  final List<Games> _games = [];
  final api = Api();
  final Map<int, Games> gameDetails = {};

  List<Games> get games => _games;

  Future<void> fetchGames() async {
    final data = await api.getGames();
    debugPrint('Raw response: ${data.data}');
    _games.clear();
    for (var gameData in data.data) {
      _games.add(Games.fromJson(gameData));
    }
    notifyListeners();
  }

  Future<void> fetchGameDetails(int id) async {
    final data = await api.getGameDetails(id);
    debugPrint('Game details response: ${data.data}');
    gameDetails[id] = Games.fromJson(data.data);

    notifyListeners();
  }

  Future<void> postGame(
    String title,
    String imageUrl,
    String description,
    int genreId,
    int developerId,
    DateTime releaseDate,
  ) async {
    try {
      await api.postGame(
        title: title,
        imageUrl: imageUrl,
        description: description,
        genreId: genreId,
        developerId: developerId,
        releaseDate: releaseDate,
      );
        await fetchGames(); 
    } on DioException catch (e) {
      print(e.response?.data);
    }
    notifyListeners();
  }

  Future<void> putGame(
    int id,
    String title,
    String imageUrl,
    String description,
    int genreId,
    int developerId,
    DateTime releaseDate,
  ) async {
    try {
      await api.updateGame(
        id,
        title,
        imageUrl,
        description,
        genreId,
        developerId,
        releaseDate,
      );
      await fetchGames(); 
      await fetchGameDetails(id);
    } on DioException catch (e) {
      print(e.response?.data);
    }

    notifyListeners();
  }

Future<void> deleteGame(int id) async {
  await api.deleteGame(id); 
  await fetchGames();  
}
}
