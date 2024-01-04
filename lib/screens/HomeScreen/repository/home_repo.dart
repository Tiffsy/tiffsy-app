import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';

class HomeRepo {
  static Future<List<MenuDataModel>> fetchMenu() async {
    var client = http.Client();
    List<MenuDataModel> menu = [];
    try {
      var response = await http.get(Uri.parse('$apiJsURL/today-menu'));
      List result = jsonDecode(response.body);

      print(result);

      for (int i = 0; i < result.length; i++) {
        MenuDataModel menuItem = MenuDataModel.fromJson(result[i]);
        menu.add(menuItem);
      }
      print(menu);
      return menu;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Result<Map<String, dynamic>>> getCustomerIdByMail(
      String mailId) async {
    try {
      String cst_id = "";
      Map<String, dynamic> params = {
        "cst_mail": mailId,
      };
      var response =
          await http.post(Uri.parse('$apiJsURL/get-cst-mail'), body: params);
      Map<String, dynamic> result = jsonDecode(response.body);
      return Result(data: result, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }

  static Future<Result<Map<String, dynamic>>> getCustomerIdByPhone(
      String phoneNumber) async {
    try {
      Map<String, dynamic> params = {
        "cst_contact": phoneNumber,
      };
      var response =
      await http.post(Uri.parse('$apiJsURL/get-cst-phone'), body: params);
      print(response.body);
      Map<String, dynamic> result = jsonDecode(response.body);
      return Result(data: result, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }

  static bool checkUserAuthenticationMethod() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        print('Provider ID: ${userInfo.providerId}');
        if (userInfo.providerId == 'google.com') {
          return false;
        } else if (userInfo.providerId == 'phone') {
          return true;
        }
      }
    }
    return false;
  }

  static String getUserInfo(){
     User? user = FirebaseAuth.instance.currentUser;
     if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        print('Provider ID: ${userInfo.providerId}');
        if (userInfo.providerId == 'google.com') {
          return user.email.toString();
        } else if (userInfo.providerId == 'phone') {
          return user.phoneNumber.toString();
        }
      }
    }
    return "";
  }

}
