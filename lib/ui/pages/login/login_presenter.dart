import 'package:autos/api/api_provider.dart';
import 'package:autos/storage/i_local_storage.dart';

import 'i_login_view.dart';

class LoginPresenter {
  LoginPresenter(this._view, this._apiProvider, this._localStorage);

  final ILoginView? _view;
  final IApiProvider _apiProvider;
  final ILocalStorage _localStorage;

  void doLogin(String email, String code) {
    assert(_view != null);
    _view?.showLoading();
    _apiProvider
        .login(email, code)
        .then((token) => {_localStorage.saveAuthToken(token)})
        .then((value) => _view?.onLoginSuccess())
        .whenComplete(() => _view?.hideLoading())
        .catchError((onError) {
      _view?.onLoginError(null);
      _view?.hideLoading();
    });
  }
}
