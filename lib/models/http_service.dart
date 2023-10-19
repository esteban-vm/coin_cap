import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:coincap/models/app_config.dart';

class HttpService {
  late Dio _dio;
  late AppConfig _appConfig;
  late String _baseUrl;

  HttpService() {
    _dio = Dio();
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig.coinApiBaseUrl;
  }

  Future<Response?> get(String path) async {
    try {
      String url = _baseUrl + path;
      Response res = await _dio.get(url);
      return res;
    } catch (exception) {
      print('Unable to perform get request');
    }
    return null;
  }
}
