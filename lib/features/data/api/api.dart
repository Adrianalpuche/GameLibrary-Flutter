import 'package:dio/dio.dart';

class Api {
  final _dio = Dio();
  final url = 'http://localhost:5207/api';

  Future<Response> getGames() async{
    final response = await _dio.get('$url/games');
    final data = response.data;
    return data;
  }
  



  


}
