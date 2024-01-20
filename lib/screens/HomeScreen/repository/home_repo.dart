import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tiffsy_app/Constants/network_contants.dart';
import 'package:tiffsy_app/Helpers/result.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';

class HomeRepo {
  static Future<Result<List<MenuDataModel>>> fetchMenu() async {
    List<MenuDataModel> menu = [];
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      Map<String, dynamic> params = {
        "dt": formattedDate
      };
      var response = await http.post(Uri.parse('$apiJsURL/today-menu'), body: params);
      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        MenuDataModel menuItem = MenuDataModel.fromJson(result[i]);
        menu.add(menuItem);
      }
      return Result(data: menu, error: null);
    } catch (err) {
      return Result(data: null, error: err.toString());
    }
  }

  static Future<Result<Map<String, dynamic>>> getCustomerIdByMail(
      String mailId) async {
    try {
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
      var response = await http.post(Uri.parse('$apiJsURL/get-cst-phone'),
          body: params);
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
        if (userInfo.providerId == 'google.com') {
          return false;
        } else if (userInfo.providerId == 'phone') {
          return true;
        }
      }
    }
    return false;
  }

  static String getUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          return user.email.toString();
        } else if (userInfo.providerId == 'phone') {
          return user.phoneNumber.toString();
        }
      }
    }
    return "";
  }

  static Future<Result<String>> getToken(String mailId, String cst_id, String nmbr) async {
    try{
      Map<String,dynamic> params = {
        "cst_id": cst_id,
        "cst_nmbr": nmbr,
        "cst_mail": mailId
      };
      var response =  await http.post(Uri.parse('$apiJsURL/get-token'), body: params);
      Map<String, dynamic> result = jsonDecode(response.body);
      return Result(data: result['token'], error: null);
    }
    catch(err){
      return Result(data: null, error: err.toString());
    }
  }

}
