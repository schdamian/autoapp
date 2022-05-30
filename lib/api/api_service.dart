import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:autos/models/generic_network_error.dart';
import 'package:autos/storage/i_local_storage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../resources.dart';
import 'exception/network_exceptions.dart';

class ApiService implements IApiService {

  factory ApiService({ILocalStorage? localStorage}) {
    return _instance ??= ApiService._internal(localStorage: localStorage);
  }

  ApiService._internal({this.localStorage});

  static ApiService? _instance;

  final ILocalStorage? localStorage;
  static final bool useMockEndpoints = dotenv.env['USE_MOCK_ENDPOINTS']?.toLowerCase() == 'true';
  static final String? baseUrl = useMockEndpoints ? dotenv.env['BASE_MOCK_URL'] : dotenv.env['BASE_URL'];

  Future<bool> isOnline() async {
    final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Map<String, String> getDefaultHeaders() {
    final String? authToken = localStorage?.getAuthToken();
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json'
    };

    if (authToken != null && authToken.isNotEmpty) {
      defaultHeaders.addAll({ 'Authorization': 'Bearer $authToken' });
    }

    return defaultHeaders;
  }

  @override
  Future<dynamic> get(String endpoint, [ Object? body, Map<String, String>? headers ]) async {
    return performRequest(endpoint, body, headers, NetworkOperation.get);
  }

  @override
  Future<dynamic> post(String? endpoint, Object? body, [ Map<String, String>? headers ]) async {
    return performRequest(endpoint, body, headers, NetworkOperation.post);
  }

  Future<dynamic> performRequest(String? endpoint, Object? body, Map<String, String>? headers, NetworkOperation operation) async {
    if (await isOnline()) {
      headers ??= { };
      headers.addAll(getDefaultHeaders());

      final Uri url = Uri.parse('$baseUrl$endpoint');
      http.Response? response;

      final jsonBody = jsonEncode(body);

      response = await _performRequest(operation, response, url, headers, jsonBody);

      if (response!.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } else {
        String detail = "";
        try {
          var firstValue = Map.from(jsonDecode(response.body)).values.first;
          if (firstValue is LinkedHashSet) {
            detail = firstValue.first;
          } else {
            detail = firstValue;
          }
        } catch (error) {
          //empty
        }
        final GenericNetworkError networkError = GenericNetworkError(
            detail: detail
        );
        throw GenericNetworkException(
          networkError.detail = ResString.unknownError
        );
      }
    } else {
      throw NoConnectionException();
    }
  }

  Future<http.Response>? _performRequest(NetworkOperation operation, http.Response? response, Uri url, Map<String, String> headers, String jsonBody) async {
    switch (operation) {
      case NetworkOperation.get:
        response = await http.get(url, headers: headers);
        break;
      case NetworkOperation.post:
        response = await http.post(url, headers: headers, body: jsonBody);
        break;
      case NetworkOperation.head:
        response = await http.head(url, headers: headers);
        break;
      case NetworkOperation.patch:
        response = await http.patch(url, headers: headers, body: jsonBody);
        break;
      case NetworkOperation.delete:
        response = await http.delete(url, headers: headers, body: jsonBody);
        break;
    }
    return response;
  }
}

enum NetworkOperation { head, get, post, patch, delete }

abstract class IApiService {
  Future<dynamic> get(String endpoint, [ Object body, Map<String, String> headers ]);
  Future<dynamic> post(String endpoint, Object body, [ Map<String, String> headers ]);
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}