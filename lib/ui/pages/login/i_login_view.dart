abstract class ILoginView {
  void onLoginSuccess();
  void onLoginError(String? message);
  void showLoading();
  void hideLoading();
}