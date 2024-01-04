import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class LoadingAnimation {
  static const String _animationOnePath =
      "assets/loading_animations/tiffsy_loading_animation1.json";
  static const String _animationTwoPath =
      "assets/loading_animations/tiffsy_loading_animation2.json";

  static Widget loadingAnimationOne(BuildContext context) {
    return Lottie.asset(_animationOnePath,
        height: MediaQuery.sizeOf(context).height * 0.2, repeat: true);
  }

  static Widget loadingAnimationTwo(BuildContext context) {
    return Lottie.asset(_animationTwoPath,
        height: MediaQuery.sizeOf(context).height * 0.2, repeat: true);
  }
}
