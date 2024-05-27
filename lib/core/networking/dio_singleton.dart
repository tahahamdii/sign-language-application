import 'package:dio/dio.dart';
import 'package:messagerie/core/networking/api_constants.dart';
class DioSingleton {
  Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      //  receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 6000),
      receiveTimeout: Duration(seconds: 6000),
      headers: <String, String>{
        //'Contentt-Type': 'application/x-www-form-urlencoded',
          'Content-Type': 'application/json',
       // 'Content-Type': 'multipart/form-data',
      }));
//declaration DioSingleton pour utilise n'importe ou dans le code
  static final DioSingleton _singleton = DioSingleton._internal();
//constructeur
  factory DioSingleton() {
    return _singleton;
  }
//faire l'instance de DioSingleton avec mot "_internal"
  DioSingleton._internal();
}