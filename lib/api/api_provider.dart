import 'dart:async';

import 'package:autos/api/api_service.dart';

class ApiProvider implements IApiProvider {
  factory ApiProvider({IApiService? apiService}) {
    return _instance ??= ApiProvider._internal(apiService: apiService);
  }

  ApiProvider._internal({this.apiService});

  static ApiProvider? _instance;

  final IApiService? apiService;

  @override
  Future<String> login(String email, String code) async {
    return apiService!.post('login/', {'email': email, "code": code}).then((value) => value.toString());
  }
}

abstract class IApiProvider implements IAuthApi {}

abstract class IAuthApi {
  Future<String> login(String email, String code);
}
