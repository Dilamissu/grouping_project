import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/state.dart';
import 'package:grouping_project/model/auth/auth_model_lib.dart';
// import 'package:grouping_project/VM/state.dart';
// import 'package:grouping_project/VM/view_model_lib.dart';
// import 'package:grouping_project/model/model_lib.dart';
// import 'package:grouping_project/model/register_model.dart';

class SignInViewModel extends ChangeNotifier {
  // final AuthService authService = AuthService();
  RegisterModel passwordRegisterModel = RegisterModel();

  String get password => passwordRegisterModel.password;
  String get passwordConfirm => passwordRegisterModel.passwordConfirm;
  String get userName => passwordRegisterModel.userName;
  String get email => passwordRegisterModel.email;
  bool get isPasswordValid => passwordRegisterModel.isPasswordValid;
  bool get isPasswordConfirmValid =>
      passwordRegisterModel.isPasswordConfirmValid;
  bool get isUserNameValid => passwordRegisterModel.isUserNameValid;
  bool isLoading = false;
  RegisterState registerState = RegisterState.fail;

  void onEmailChange(String value) {
    passwordRegisterModel.updateEmail(value);
    notifyListeners();
  }

  void onUserNameChange(String value) {
    passwordRegisterModel.updateUserName(value);
    notifyListeners();
  }

  void onPasswordChange(String value) {
    passwordRegisterModel.updatePassword(value);
    notifyListeners();
  }
  void onPasswordConfirmChange(String value) {
    passwordRegisterModel.updatePasswordConfirm(value);
    notifyListeners();
  }

  String? emailValidator(value) {
    return isUserNameValid ? null : "請輸入有效電子郵件";
  }

  String? userNameValidator(value) {
    return isUserNameValid ? null : "請填入使用者名稱";
  }

  String? passwordValidator(value) {
    return isPasswordValid ? null : "密碼長度禁止低於6";
  }

  String? passwordConfirmValidator(value) {
    return isPasswordConfirmValid ? null : "兩次輸入密碼不吻合";
  }

  Future<void> register() async {
    isLoading = true;
    notifyListeners();
    registerState = await passwordRegisterModel.register( email, password, userName);
    isLoading = false;
    notifyListeners();
  }
}
