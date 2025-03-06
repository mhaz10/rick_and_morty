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



  Future<Map<String, dynamic>> getAllCharacters({int? page}) async {
    Dio dio = Dio(
        BaseOptions(
            baseUrl: baseUrl,
            queryParameters: {
              'page': page
            }
        )
    );
    try {
      Response response = await dio.get('character');
      print(response.data['info']);
      return response.data;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getQuotes() async {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1/',
          headers: {
            'X-Api-Key' : 'byXzXMzK0Q8RFG2JdGPM9A==mpk904LUaltTfgWM'
          }
      )
    );

    try {
      Response response = await dio.get('quotes');
      return response.data[0];
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}