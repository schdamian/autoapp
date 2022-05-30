import 'package:autos/api/api_provider.dart';
import 'package:autos/api/api_service.dart';
import 'package:autos/resources.dart';
import 'package:autos/storage/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'i_login_view.dart';
import 'login_presenter.dart';

//https://themeforest.net/item/mfc-car-sales-and-buy-mobile-app-figma-template/screenshots/27987884?index=1

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements ILoginView {
  LoginPresenter? _presenter;

  FocusNode? focusEmail, focusPassword;
  String email = "";
  String password = "";
  bool isLoading = false;

  _LoginPageState() {
    _presenter = LoginPresenter(
        this,
        ApiProvider(apiService: ApiService(localStorage: LocalStorage())),
        LocalStorage());
  }

  @override
  void initState() {
    super.initState();
    focusEmail = FocusNode();
    focusPassword = FocusNode();
  }

  @override
  void dispose() {
    focusEmail?.dispose();
    focusPassword?.dispose();
    super.dispose();
  }

  bool _enableSendButton() {
    return !isLoading && email.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Stack(clipBehavior: Clip.hardEdge, children: <Widget>[
          Container(
              alignment: Alignment.center,
              height: 70.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                          onPressed: _enableSendButton() ? () => {} : null,
                          child: const Text(ResString.login, style: TextStyle(fontSize: 18, color: Colors.black),),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return ResColor.grayLight;
                                } else {
                                  return ResColor.orange;
                                }
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResDimen.buttonRadio),
                                //side: BorderSide(color: ResColor.green)
                              )))),
                    ),
                  ),
                ],
              ))
        ]),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 105, left: 16, right: 16),
        child: Center(
          child: Column(children: <Widget>[
            const Text(ResString.hello, style: TextStyle(fontSize: 28)),
            const Divider(height: 68, color: Colors.transparent),
            TextFormField(
              onChanged: (String value) {
                email = value;
              },
              focusNode: focusEmail,
              onTap: () {
                //TODO
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ResString.emailAddress,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            const Divider(height: 30, color: Colors.transparent),
            TextFormField(
              onChanged: (String value) {
                password = value;
              },
              focusNode: focusPassword,
              onTap: () {
                //TODO
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                labelText: ResString.password,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: CircularProgressIndicator(),
                )),
          ]),
        ),
      ),
    );
  }

  @override
  void onLoginError(String? message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              title: Text(message ?? ResString.loginError,
                  textAlign: TextAlign.center),
              content: ElevatedButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: const Text(
                    ResString.accept,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ResColor.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                              side: const BorderSide(color: ResColor.orange))))),
            ));
  }

  @override
  void onLoginSuccess() {
    //TODO
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }
}
