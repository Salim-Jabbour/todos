import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../resource/const_manager.dart';

class DioUtil {
  static Future<Dio> createDioInstance() async {
    final headers = <String, dynamic>{};

    headers['Accept'] = 'application/json';
    headers['Accept-Language'] = 'en';
    headers['Content-Type'] = 'application/json';

    final dio = Dio(
      BaseOptions(headers: headers, baseUrl: ConstManager.baseUrl),
    );

    dio.interceptors.clear();

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    return dio;
  }
}
