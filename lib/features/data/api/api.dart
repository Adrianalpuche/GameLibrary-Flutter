import 'package:dio/dio.dart';
import 'package:game_library/models/games.dart';

class Api {
  final _dio = Dio();
  final url = 'http://localhost:5207/api';

  Future<Response> getGames() async{
     return  await _dio.get('$url/games');
  }

  Future<Response> getGameDetails(int id) async {
    return await _dio.get('$url/games/$id');
  }


  Future<Games> postGame({
    required String title,
    required String imageUrl,
    required String description,
    required int genreId,
     required int developerId,
    required DateTime releaseDate

  }) async {

    final response = await _dio.post(
      '$url/games',
      data: {
        'title': title,
        'imageUrl': imageUrl,
        'description': description,
        'genreId': genreId,
        'developerId': developerId,
        'releaseDate': releaseDate.toIso8601String(),
      },
    );

  return Games.fromJson(response.data);
}

  Future<void> updateGame(
    int id,
    String title,
    String imageUrl,
    String description,
    int genreId,
    int developerId,
    DateTime releaseDate
    ) 
    async{
      await _dio.put(
      '$url/games/$id',
      data: {
        'title': title,
        'imageUrl': imageUrl,
        'description': description,
        'genreId': genreId,
        'developerId': developerId,
        'releaseDate': releaseDate.toIso8601String(),
      }
    );

  }

  Future<Response> deleteGame(int id) async {
    return await _dio.delete('$url/games/$id');
  }


  


}
