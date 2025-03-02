import 'package:dio/dio.dart';
import 'package:rick_and_morty/constants/strings.dart';

class CharactersWebServices {
  late Dio dio;

  CharactersWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20 * 1000), // 60 seconds
      receiveTimeout: Duration(seconds: 20 * 1000), // 60 seconds
    );

    dio = Dio(options);
  }



  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('character');
      print(response.data['info']);
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}