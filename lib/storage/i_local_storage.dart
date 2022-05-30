abstract class ILocalStorage {
  String getAuthToken();
  void saveAuthToken(String authToken);
  bool userIsLoggedIn();
  void clear();
}
