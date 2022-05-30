import 'package:http/http.dart';

extension ResponseExtensions on BaseResponse {
  bool isSuccessful() {
    return statusCode >= 200 && statusCode < 400;
  }
}