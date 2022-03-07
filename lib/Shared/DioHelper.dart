//"https://api.themoviedb.org/3/movie/top_rated?api_key=b6ed23dfdf510291f459cb2c46a090ef"
import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://api.themoviedb.org/",
    ));
  }

  static Future<Response> getData({
    required String path,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(path, queryParameters: query);
  }
}
