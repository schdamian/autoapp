import 'package:autos/resources.dart';

class NoConnectionException extends GenericNetworkException {
  NoConnectionException() : super(ResString.noInternet);
}

class UnauthenticatedException extends GenericNetworkException {
  UnauthenticatedException() : super(ResString.loginError);
}

class GenericNetworkException implements Exception {
  final String message;
  GenericNetworkException(this.message);
}