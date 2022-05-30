import 'package:shared_preferences/shared_preferences.dart';
import 'i_local_storage.dart';

class LocalStorage implements ILocalStorage {
  factory LocalStorage([SharedPreferences? sharedPreferences]) {
    if (sharedPreferences == null) {
      _initializeSharedPreferences();
    } else {
      _sharedPreferences = sharedPreferences;
    }

    return _instance;
  }

  LocalStorage._internal();

  static final LocalStorage _instance = LocalStorage._internal();

  static const String KEY_ACCESS_TOKEN = 'KEY_ACCESS_TOKEN';
  static const String KEY_USER = 'KEY_USER';

  static SharedPreferences? _sharedPreferences;

  static void _initializeSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  SharedPreferences? _getSharedPreferences() {
    _initializeSharedPreferences();

    return _sharedPreferences;
  }

  @override
  String getAuthToken() {
    String? authToken = _getSharedPreferences()?.getString(KEY_ACCESS_TOKEN);
    authToken ??= '';

    return authToken;
  }

  @override
  void saveAuthToken(String authToken) {
    _getSharedPreferences()?.setString(KEY_ACCESS_TOKEN, authToken);
  }

  @override
  bool userIsLoggedIn() {
    return getAuthToken().isNotEmpty;
  }

  @override
  void clear() {
    _getSharedPreferences()?.clear();
  }
}
