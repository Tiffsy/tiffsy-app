import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';

class HomeRepo {
  static Future<List<MenuDataModel>> fetchMenu() async {
    var client = http.Client();
    List<MenuDataModel> menu = [];
    try {
      var response =
          await http.get(Uri.parse('http://10.0.2.2:4000/tiffsy/today-menu'));
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
}
