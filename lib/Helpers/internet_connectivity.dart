import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      print("no internet");
      Get.rawSnackbar(
          backgroundColor: const Color(0xfffffcef),
          messageText: const Text("Please connect to the Internet"),
          isDismissible: false,
          duration: const Duration(days: 1),
          snackStyle: SnackStyle.FLOATING);
    } else {
      print("s internet");
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
    }
  }
}

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
