import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nodechat/nodechat.dart';
import 'package:http/http.dart' as http;
import 'package:nodechat/src/node_server_exception.dart';

typedef T Converter<T>(String response);

abstract class Collection {
  String get _serverUrl => NodeChat.instance.serverUrl;
  String get yourUserId => NodeChat.instance.yourUserId;

  Map<String, String> _jsonHeader = <String, String>{"Content-Type": "application/json"};

  Logger _logger = Logger();

  Future<T> cGet<T>({@required String api, @required Converter<T> converter}) {
    final request = http.get(_serverUrl + api);
    return _cCall<T>(request, converter);
  }

  Future<T> cPut<T>({@required String api, @required Converter<T> converter, @required Map body}) {
    final request = http.put(_serverUrl + api, headers: _jsonHeader, body: jsonEncode(body));
    return _cCall<T>(request, converter);
  }

  Future<T> cPost<T>({@required String api, @required Converter<T> converter, @required Map body}) {
    final request = http.post(_serverUrl + api, headers: _jsonHeader, body: jsonEncode(body));
    return _cCall<T>(request, converter);
  }

  Future<T> _cCall<T>(Future<http.Response> request, Converter<T> converter) async {
    try {
      final response = await request;
      final body = getResponseBody(response);
      return converter(body);
    } catch (error, stackTracer) {
      _logger.e("An error has occurred!", error, stackTracer);
      return null;
    }
  }

  String getResponseBody(http.Response response) {
    if (response.statusCode == 999) throw NodeServerException("Lỗi server!");
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw HttpException("Lỗi kết nối ${response.statusCode}");
    return response.body;
  }
}
